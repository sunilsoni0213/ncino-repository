public with sharing class CreatePackageSendService extends nFUSE.SendService {
	@TestVisible
	private static PluginConfigurationService pluginConfigService = new PluginConfigurationService();
	@TestVisible
	private static CreatePackageMapper createPackageMapper = new CreatePackageMapper();
	@TestVisible
	private static AResponseNormalizer normalizer = new CreatePackageResponseNormalizer();

	public protected override Object preSendRequest(Object request, nFUSE.AMiddlewareMessage message) {
		if (request instanceof HttpRequest) {
			HttpRequest httpReq = (HttpRequest) request;
			httpReq.setEndpoint(getEndpoint());

			httpReq.setHeader('Authorization', 'Basic ' + getApiKey());
			httpReq.setHeader('Accept', 'application/json');
			httpReq.setMethod('POST');

			CreatePackageModel body = createPackageMapper.buildCreatePackageModel(message);
			httpReq.setBody(JSON.serialize(body));

			return httpReq;
		} else {
			throw new XException(X_HTTP_ERROR);
		}
	}

	public protected override nFUSE.AMiddlewareMessage postSendSeam(nFUSE.AMiddlewareMessage message) {
		if (message == null || message.httpResponse == null) {
			throw new XException(X_EXPECTED_HTTP_RESPONSE);
		}
		message.httpResponse.setBody(normalizer.process(message));

		return message;
	}

	private String getEndpoint() {
		String endpoint = pluginConfigService.getPluginPropertyValue(OneSpanESignature.KEY_CREATE_PACKAGE_ENDPOINT);
		if (!String.isEmpty(endpoint)) {
			return endpoint;
		}

		throw new XException(X_ESIGNATURE_CONFIGS_NOT_CONFIGURED);
	}

	private String getApiKey() {
		String apiKey = pluginConfigService.getApiKey();
		if (!String.isEmpty(apiKey)) {
			return apiKey;
		}

		throw new XException(X_ESIGNATURE_CONFIGS_NOT_CONFIGURED);
	}

	private class XException extends Exception {
	}

	@TestVisible
	private static final String
		X_EXPECTED_HTTP_RESPONSE = 'Expected type \'HttpResponse\' not present on MiddlewareMessage',
		X_ESIGNATURE_CONFIGS_NOT_CONFIGURED = 'Please ensure OneSpan E-SIGNATURE Configs are properly configured.',
		X_HTTP_ERROR = 'OneSpan E-Signature Plugin expects a valid HttpRequest.';
}
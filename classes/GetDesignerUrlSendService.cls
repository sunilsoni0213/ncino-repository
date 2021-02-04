public with sharing class GetDesignerUrlSendService extends nFUSE.SendService {
	@TestVisible
	private static PluginConfigurationService pluginConfigService = new PluginConfigurationService();
	@TestVisible
	private GetDesignerUrlMapper designerUrlMapper = new GetDesignerUrlMapper();
	@TestVisible
	private AResponseNormalizer normalizer = new GetDesignerUrlResponseNormalizer();

	public protected override Object preSendRequest(Object request, nFUSE.AMiddlewareMessage message) {
		if (request instanceof HttpRequest) {
			HttpRequest httpReq = (HttpRequest) request;
			Map<String, Object> msg = (Map<String, Object>) JSON.deserializeUntyped(message.toMsg());

			httpReq.setEndpoint(getEndpoint());

			httpReq.setHeader('Authorization', 'Basic ' + getApiKey());
			httpReq.setHeader('Accept', 'application/json');
			httpReq.setHeader('Content-Type', 'application/json');
			httpReq.setMethod('POST');

			DesignerUrlModel body = designerUrlMapper.buildDesignerUrlModel(msg);
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
		String endpoint = pluginConfigService.getPluginPropertyValue(OneSpanESignature.KEY_GET_DESIGNER_URL_ENDPOINT);
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
		X_ESIGNATURE_CONFIGS_NOT_CONFIGURED = 'Please ensure OneSpan E-SIGNATURE Configs are properly configured.',
		X_EXPECTED_HTTP_RESPONSE = 'Expected type \'HttpResponse\' not present on MiddlewareMessage',
		X_HTTP_ERROR = 'OneSpan E-Signature Plugin expects a valid HttpRequest.';
}
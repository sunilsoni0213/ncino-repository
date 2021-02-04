public with sharing class RetrievePackageMetadataSendService extends nFUSE.SendService {
	@TestVisible
	private static PluginConfigurationService pluginConfigService = new PluginConfigurationService();
	@TestVisible
	private PackageMetadataMessagePropertyExtractor propertyExtractor = new PackageMetadataMessagePropertyExtractor();
	@TestVisible
	private static AResponseNormalizer normalizer = new RetrievePackageMetadataNormalizer();

	public protected override Object preSendRequest(Object request, nFUSE.AMiddlewareMessage message) {
		if (request instanceof HttpRequest) {
			Map<String, Object> msg = (Map<String, Object>) JSON.deserializeUntyped(message.toMsg());
			String packageId = propertyExtractor.getVendorCollectionId(msg);

			HttpRequest httpReq = (HttpRequest) request;
			httpReq.setEndpoint(getEndpoint(packageId));
			httpReq.setHeader('Authorization', 'Basic ' + getApiKey());
			httpReq.setHeader('Accept', 'application/json');
			httpReq.setHeader('Content-Type', 'application/json');

			return httpReq;
		} else {
			throw new XException(X_HTTP_ERROR);
		}
	}

	public override nFUSE.AMiddlewareMessage preSendSeam(nFUSE.AMiddlewareMessage message) {
		message.method = 'GET';
		return message;
	}

	public protected override nFUSE.AMiddlewareMessage postSendSeam(nFUSE.AMiddlewareMessage message) {
		if (message == null || message.httpResponse == null) {
			throw new XException(X_EXPECTED_HTTP_RESPONSE);
		}

		message.httpResponse.setBody(normalizer.process(message));

		return message;
	}

	private String getEndpoint(String packageId) {
		String endpoint = pluginConfigService.getPluginPropertyValue(OneSpanESignature.KEY_RETRIEVE_PACKAGE_METADATA_ENDPOINT);
		if (!String.isEmpty(endpoint)) {
			return endpoint.replace('{packageId}', packageId);
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
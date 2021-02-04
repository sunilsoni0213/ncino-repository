public with sharing class AddDocumentSendService extends nFUSE.SendService {
	private static PluginConfigurationService pluginConfigService = new PluginConfigurationService();
	@TestVisible
	private static DocumentService docService = new DocumentService();
	@TestVisible
	private static AResponseNormalizer normalizer = new AddDocumentResponseNormalizer();

	public override Object preSendRequest(Object request, nFUSE.AMiddlewareMessage message) {
		if (request instanceof HttpRequest) {
			Map<String, Object> msg = (Map<String, Object>) JSON.deserializeUntyped(message.toMsg());
			String packageId = docService.getPackageId(msg);
			Blob multipartFormData = docService.buildDocumentMultipartFormData(msg) ;

			HttpRequest httpReq = (HttpRequest) request;
			httpReq.setEndpoint(getEndpoint(packageId));

			httpReq.setHeader('Authorization', 'Basic ' + getApiKey());
			httpReq.setHeader('Content-Type', 'multipart/form-data; boundary=' + BOUNDARY);
			httpReq.setMethod('POST');
			httpReq.setTimeout(120000);
			httpReq.setBodyAsBlob(multipartFormData);
			httpReq.setHeader('Content-Length', String.valueOf(multipartFormData.size()));

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

	private String getEndpoint(String packageId) {
		String endpoint = pluginConfigService.getPluginPropertyValue(OneSpanESignature.KEY_ADD_DOCUMENT_ENDPOINT);
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
	public static final String
		BOUNDARY = '----WebKitFormBoundary1bNO60n7FqP5WO4t',
		X_ESIGNATURE_CONFIGS_NOT_CONFIGURED = 'Please ensure OneSpan E-SIGNATURE Configs are properly configured.',
		X_EXPECTED_HTTP_RESPONSE = 'Expected type \'HttpResponse\' not present on MiddlewareMessage',
		X_HTTP_ERROR = 'OneSpan E-Signature Plugin expects a valid HttpRequest.';
}
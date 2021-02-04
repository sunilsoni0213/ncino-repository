public with sharing class GetDesignerUrlResponseNormalizer extends AResponseNormalizer {
	@TestVisible
	private GetDesignerUrlPropertyExtractor designerPropertyExtractor = new GetDesignerUrlPropertyExtractor();
	@TestVisible
	private static PluginConfigurationService pluginConfigService = new PluginConfigurationService();

	public override String process(nFUSE.AMiddlewareMessage message) {
		Map<String, Object> rawResponseMap = deserialize(message.httpResponse.getBody());
		Map<String, Object> msg = (Map<String, Object>) JSON.deserializeUntyped(message.toMsg());

		String token = extractToken(rawResponseMap);
		String designerUrl = buildDesignerUrl(token, designerPropertyExtractor.getVendorCollectionId(msg));
		Map<String, Object> normalizedResponseMap = normalize(
			message.httpResponse.getStatusCode(),
			designerUrl
		);

		return JSON.serialize(buildProcessedMap(rawResponseMap, normalizedResponseMap));
	}

	private String extractToken(Map<String, Object> rawResponseMap) {
		String token = (String) rawResponseMap.get(KEY_VALUE);
		if (String.isEmpty(token)) {
			throw new XException(
				String.format(
					X_DESIGNER_TOKEN_NOT_FOUND,
					new List<String>{JSON.serialize(rawResponseMap)}
				)
			);
		}

		return token;
	}

	private String buildDesignerUrl(String token, String packageId) {
		String sessionUrl = pluginConfigService.getPluginPropertyValue(OneSpanESignature.KEY_DESIGNER_SESSION_URL);
		if (String.isEmpty(sessionUrl)) {
			throw new XException(X_ESIGNATURE_DESIGNER_NOT_CONFIGURED);
		}
		sessionUrl = sessionUrl.replace('{senderToken}', token);
		sessionUrl = sessionUrl.replace('{packageId}', packageId);
		return sessionUrl;
	}

	private Map<String, Object> normalize(Integer statusCode, String designerUrl) {
		return new Map<String, Object>{
			KEY_TAGGING_URL => designerUrl,
			KEY_NORMALIZED_STATUS_CODE => statusCode
		};
	}

	private class XException extends Exception {
	}

	@TestVisible
	private static final String
		KEY_TAGGING_URL = 'tagging_url',
		KEY_NORMALIZED_STATUS_CODE = 'status_code',
		KEY_VALUE = 'value',
		X_DESIGNER_TOKEN_NOT_FOUND = 'Expected Designer Token was not found in response. Received: {0}',
		X_ESIGNATURE_DESIGNER_NOT_CONFIGURED = 'Please ensure OneSpan E-SIGNATURE Config "Designer_Session_Url" is properly configured.';
}
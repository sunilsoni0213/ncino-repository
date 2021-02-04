public with sharing class AddDocumentResponseNormalizer extends AResponseNormalizer {
	public override String process(nFUSE.AMiddlewareMessage message) {
		Map<String, Object> rawResponseMap = deserialize(message.httpResponse.getBody());
		String documentId = extractDocumentId(rawResponseMap);
		Map<String, Object> normalizedResponseMap = normalize(
			message.httpResponse.getStatusCode(),
			documentId
		);

		return JSON.serialize(buildProcessedMap(rawResponseMap, normalizedResponseMap));
	}

	private String extractDocumentId(Map<String, Object> rawResponseMap) {
		String documentId = (String) rawResponseMap.get(KEY_ID);

		if (String.isEmpty(documentId)) {
			throw new AResponseNormalizer.XResponseException(
				String.format(
					X_ADD_DOCUMENT_ID_NOT_FOUND,
					new List<String>{JSON.serialize(rawResponseMap)}
				)
			);
		}

		return documentId;
	}

	private Map<String, Object> normalize(Integer statusCode, String documentId) {
		return new Map<String, Object>{
			KEY_VENDOR_DOCUMENT_ID => documentId,
			KEY_NORMALIZED_STATUS_CODE => statusCode
		};
	}

	@TestVisible
	private static final String
		KEY_ID = 'id',
		KEY_NORMALIZED_STATUS_CODE = 'status_code',
		KEY_VENDOR_DOCUMENT_ID = 'vendor_document_id',
		X_ADD_DOCUMENT_ID_NOT_FOUND = 'Expected Add Document Id was not found in response. Received: {0}';
}
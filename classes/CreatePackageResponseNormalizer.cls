public class CreatePackageResponseNormalizer extends AResponseNormalizer {

	public override String process(nFUSE.AMiddlewareMessage message) {
		Map<String, Object> rawResponseMap = deserialize(message.httpResponse.getBody());
		String createPackageId = extractPackageId(rawResponseMap);
		Map<String, Object> normalizedResponseMap = normalize(
			message.httpResponse.getStatusCode(),
			createPackageId
		);

		return JSON.serialize(buildProcessedMap(rawResponseMap, normalizedResponseMap));
	}

	private String extractPackageId(Map<String, Object> rawResponseMap) {
		String createPackageId = (String) rawResponseMap.get(KEY_ID);

		if (String.isEmpty(createPackageId)) {
			throw new AResponseNormalizer.XResponseException(
				String.format(
					X_CREATE_PACKAGE_ID_NOT_FOUND,
					new List<String>{JSON.serialize(rawResponseMap)}
				)
			);
		}

		return createPackageId;
	}

	private Map<String, Object> normalize(Integer statusCode, String createPackageId) {
		return new Map<String, Object>{
			KEY_VENDOR_COLLECTION_ID => createPackageId,
			KEY_NORMALIZED_STATUS_CODE => statusCode
		};
	}

	@TestVisible
	private static final String
		KEY_ID = 'id',
		KEY_NORMALIZED_STATUS_CODE = 'status_code',
		KEY_VENDOR_COLLECTION_ID = 'vendor_collection_id',
		X_CREATE_PACKAGE_ID_NOT_FOUND = 'Expected Create Package Id was not found in response. Received: {0}';
}
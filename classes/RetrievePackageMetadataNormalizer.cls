public with sharing class RetrievePackageMetadataNormalizer extends AResponseNormalizer {
	@TestVisible
	private RetrievePackageMetadataMapper mapper = new RetrievePackageMetadataMapper();

	public override String process(nFUSE.AMiddlewareMessage message) {
		Map<String, Object> rawResponseMap = deserialize(message.httpResponse.getBody());
		PackageMetadata packageInfo = mapper.buildPackageMetadata(rawResponseMap);
		Map<String, Object> normalizedResponseMap = normalize(
			message.httpResponse.getStatusCode(),
			packageInfo
		);

		return JSON.serialize(buildProcessedMap(new Map<String, Object>(), normalizedResponseMap));
	}

	private Map<String, Object> normalize(Integer statusCode, PackageMetadata packageInfo) {
		return new Map<String, Object>{
			KEY_VENDOR_COLLECTION_METADATA => packageInfo,
			KEY_NORMALIZED_STATUS_CODE => statusCode
		};
	}

	@TestVisible
	private static final String
		KEY_NORMALIZED_STATUS_CODE = 'status_code',
		KEY_VENDOR_COLLECTION_METADATA = 'collection_metadata';

}
public with sharing class PackageMetadataMessagePropertyExtractor extends APropertyExtractor {

	public String getVendorCollectionId(Map<String, Object> message) {
		Map<String, Object> collection = getDocumentCollection(message);
		Map<String, Object> properties = (Map<String, Object>) collection.get(KEY_PROPERTIES);
		validateProperty(properties, new List<String>{KEY_DOCUMENT_COLLECTION, KEY_PROPERTIES});

		String vendorId = getMapValueAsString((Map<String, Object>) properties.get(KEY_VENDOR_COLLECTION_ID));
		validateProperty(vendorId, new List<String>{KEY_DOCUMENT_COLLECTION, KEY_VENDOR_COLLECTION_ID});

		return vendorId;
	}

	@TestVisible
	private Map<String, Object> getDocumentCollection(Map<String, Object> message) {
		Map<String, Object> props = (Map<String, Object>) message.get(KEY_PROPERTIES);
		Map<String, Object> collection = (Map<String, Object>) props.get(KEY_DOCUMENT_COLLECTION);
		validateProperty(collection, new List<String>{KEY_DOCUMENT_COLLECTION});

		return collection;
	}

	@TestVisible
	private static final String
		KEY_DOCUMENT_COLLECTION = 'document_collection',
		KEY_PROPERTIES = 'properties',
		KEY_VENDOR_COLLECTION_ID = 'LLC_BI__Vendor_Collection_Id__c';
}
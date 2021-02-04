public with sharing class AddDocumentPropertyExtractor extends APropertyExtractor {
	public String getDocumentCollectionId(Map<String, Object> message) {
		Map<String, Object> collection = getDocumentCollection(message);
		String documentCollectionId = getMapValueAsString(collection.get(KEY_RECORD_ID));
		validateProperty(documentCollectionId, new List<String>{KEY_DOCUMENT_COLLECTION, KEY_RECORD_ID});

		return documentCollectionId;
	}

	public String getVendorCollectionId(Map<String, Object> message) {
		Map<String, Object> collection = getDocumentCollection(message);
		Map<String, Object> properties = (Map<String, Object>) collection.get(KEY_PROPERTIES);
		validateProperty(properties, new List<String>{KEY_DOCUMENT_COLLECTION, KEY_PROPERTIES});
		String vendorId = getMapValueAsString((Map<String, Object>) properties.get(KEY_VENDOR_COLLECTION_ID));
		validateProperty(vendorId, new List<String>{KEY_DOCUMENT_COLLECTION, KEY_VENDOR_COLLECTION_ID});

		return vendorId;
	}

	public String getDocumentCollectionIndexId(Map<String, Object> message) {
		Map<String, Object> documentCollectionIndex = getDocumentCollectionIndex(message);
		String documentCollectionIndexId = getMapValueAsString(documentCollectionIndex.get(KEY_RECORD_ID));
		validateProperty(documentCollectionIndexId, new List<String>{KEY_DOCUMENT_COLLECTION_INDEX, KEY_RECORD_ID});

		return documentCollectionIndexId;
	}

	public String getDocumentVersionId(Map<String, Object> message) {
		Map<String, Object> documentVersion = getDocumentVersions(message)[0];
		String documentVersionId = getMapValueAsString(documentVersion.get(KEY_RECORD_ID));
		validateProperty(documentVersionId, new List<String>{KEY_DOCUMENT_VERSIONS, KEY_RECORD_ID});

		return documentVersionId;
	}

	public String getFileExtension(Map<String, Object> message) {
		Map<String, Object> properties = getDocumentVersionProps(message);
		String fileType = getMapValueAsString((Map<String, Object>) properties.get(KEY_FILE_EXTENSION));
		validateProperty(fileType, new List<String>{KEY_DOCUMENT_VERSIONS, KEY_FILE_EXTENSION});

		return fileType;
	}

	public String getFileName(Map<String, Object> message) {
		Map<String, Object> properties = getDocumentVersionProps(message);
		String fileName = getMapValueAsString((Map<String, Object>) properties.get(KEY_FILE_TITLE));

		validateProperty(fileName, new List<String>{KEY_DOCUMENT_VERSIONS, KEY_FILE_TITLE});

		return fileName;
	}

	public String getContentVersionId(Map<String, Object> message) {
		Map<String, Object> properties = getDocumentVersionProps(message);
		String contentVersionId = getMapValueAsString((Map<String, Object>) properties.get(KEY_CONTENT_VERSION_ID));
		validateProperty(contentVersionId, new List<String>{KEY_DOCUMENT_VERSIONS, KEY_CONTENT_VERSION_ID});

		return contentVersionId;
	}

	public String getPlaceholderId(Map<String, Object> message) {
		Map<String, Object> properties = getDocumentVersionProps(message);
		String placeholderId = getMapValueAsString((Map<String, Object>) properties.get(KEY_PLACEHOLDER_ID));
		validateProperty(placeholderId, new List<String>{KEY_DOCUMENT_VERSIONS, KEY_PLACEHOLDER_ID});

		return placeholderId;
	}

	@TestVisible
	public Map<String, Object> getDocumentVersionProps(Map<String, Object> message) {
		Map<String, Object> documentVersion = getDocumentVersions(message)[0];
		Map<String, Object> properties = (Map<String, Object>) documentVersion.get(KEY_PROPERTIES);
		validateProperty(properties, new List<String>{KEY_DOCUMENT_VERSIONS, KEY_PROPERTIES});

		return properties;
	}

	@TestVisible
	private List<Map<String, Object>> getDocumentVersions(Map<String, Object> message) {
		Map<String, Object> documentStore = getDocumentStore(message);
		List<Object> documentVersionsObj = (List<Object>) documentStore.get(KEY_DOCUMENT_VERSIONS);
		validateProperty(documentVersionsObj, new List<String>{KEY_DOCUMENT_STORE, KEY_DOCUMENT_VERSIONS});

		List<Map<String, Object>> documentVersions = new List<Map<String, Object>>();
		for (Object version : documentVersionsObj) {
			documentVersions.add((Map<String, Object>) version);
		}
		validateProperty(documentVersions, new List<String>{KEY_DOCUMENT_STORE, KEY_DOCUMENT_VERSIONS});

		return documentVersions;
	}

	@TestVisible
	private Map<String, Object> getDocumentStore(Map<String, Object> message) {
		Map<String, Object> collectionIndex = getDocumentCollectionIndex(message);
		Map<String, Object> documentStore = (Map<String, Object>) collectionIndex.get(KEY_DOCUMENT_STORE);
		validateProperty(documentStore, new List<String>{KEY_DOCUMENT_COLLECTION_INDEX, KEY_DOCUMENT_STORE});

		return documentStore;
	}

	@TestVisible
	private Map<String, Object> getDocumentCollection(Map<String, Object> message) {
		Map<String, Object> collectionIndex = getDocumentCollectionIndex(message);
		Map<String, Object> collection = (Map<String, Object>) collectionIndex.get(KEY_DOCUMENT_COLLECTION);
		validateProperty(collection, new List<String>{KEY_DOCUMENT_COLLECTION});

		return collection;
	}

	@TestVisible
	public Map<String, Object> getDocumentCollectionIndex(Map<String, Object> message) {
		Map<String, Object> props = (Map<String, Object>) message.get(KEY_PROPERTIES);
		Map<String, Object> collectionIndex = (Map<String, Object>) props.get(KEY_DOCUMENT_COLLECTION_INDEX);
		validateProperty(collectionIndex, new List<String>{KEY_DOCUMENT_COLLECTION_INDEX});

		return collectionIndex;
	}

	@TestVisible
	private static final String
		KEY_CONTENT_VERSION_ID = 'LLC_BI__Content_Version_Id__c',
		KEY_DOCUMENT_COLLECTION = 'documentCollection',
		KEY_DOCUMENT_COLLECTION_INDEX = 'document_collection_index',
		KEY_DOCUMENT_STORE = 'documentStore',
		KEY_DOCUMENT_VERSIONS = 'documentVersions',
		KEY_FILE_TITLE = 'LLC_BI__Title__c',
		KEY_FILE_EXTENSION = 'LLC_BI__File_Extension__c',
		KEY_PLACEHOLDER_ID = 'LLC_BI__Placeholder_Id__c',
		KEY_PROPERTIES = 'properties',
		KEY_RECORD_ID = 'recordId',
		KEY_VENDOR_COLLECTION_ID = 'LLC_BI__Vendor_Collection_Id__c';
}
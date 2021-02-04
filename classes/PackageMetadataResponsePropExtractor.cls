public with sharing class PackageMetadataResponsePropExtractor extends APropertyExtractor {

	public Boolean hasSignatureTag(Map<String, Object> document) {
		List<Object> approvals = extractApprovals(document);
		for (Object approval : approvals) {
			List<Object> fields = extractFields((Map<String, Object>) approval);
			for (Object field : fields) {
				if (isSignatureField((Map<String, Object>) field)) {
					return true;
				}
			}
		}

		return false;
	}

	public String extractDocumentCollectionId(Map<String, Object> document) {
		Map<String, Object> data = extractCustomDocumentData(document);
		return getMapValueAsString(data.get(KEY_DOCUMENT_COLLECTION_ID));
	}

	public String extractDocumentCollectionIndexId(Map<String, Object> document) {
		Map<String, Object> data = extractCustomDocumentData(document);
		return getMapValueAsString(data.get(KEY_DOCUMENT_COLLECTION_INDEX_ID));
	}

	public String extractDocumentVersionId(Map<String, Object> document) {
		Map<String, Object> data = extractCustomDocumentData(document);
		return getMapValueAsString(data.get(KEY_DOCUMENT_VERSION_ID));
	}

	public String extractPlaceholderId(Map<String, Object> document) {
		Map<String, Object> data = extractCustomDocumentData(document);
		return getMapValueAsString(data.get(KEY_PLACEHOLDER_ID));
	}

	public List<Object> extractDocuments(Map<String, Object> rawResponseMap) {
		return getMapValueAsObjectList(rawResponseMap.get(KEY_DOCUMENTS));
	}

	private Map<String, Object> extractCustomDocumentData(Map<String, Object> document) {
		return getMapValueAsMapObject(document.get(KEY_DATA));
	}

	private Boolean isSignatureField(Map<String, Object> field) {
		String fieldType = getMapValueAsString(field.get(KEY_TYPE));
		if (fieldType.equalsIgnoreCase(SIGNATURE_TYPE)) {
			return true;
		}

		return false;
	}

	private List<Object> extractFields(Map<String, Object> approval) {
		return getMapValueAsObjectList(approval.get(KEY_FIELDS));
	}

	private List<Object> extractApprovals(Map<String, Object> document) {
		return getMapValueAsObjectList(document.get(KEY_APPROVALS));
	}



	@TestVisible
	private static final String
		KEY_APPROVALS = 'approvals',
		KEY_DATA = 'data',
		KEY_DOCUMENTS = 'documents',
		KEY_DOCUMENT_COLLECTION_ID = 'documentCollectionId',
		KEY_DOCUMENT_COLLECTION_INDEX_ID = 'documentCollectionIndexId',
		KEY_DOCUMENT_VERSION_ID = 'documentVersionId',
		KEY_FIELDS = 'fields',
		KEY_PLACEHOLDER_ID = 'placeholderId',
		KEY_TYPE = 'type',
		SIGNATURE_TYPE = 'SIGNATURE';
}
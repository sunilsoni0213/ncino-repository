public with sharing class RetrievePackageMetadataMapper {
	@TestVisible
	PackageMetadataResponsePropExtractor extractor = new PackageMetadataResponsePropExtractor();

	public PackageMetadata buildPackageMetadata(Map<String, Object> rawResponseMap) {
		PackageMetadata pkgMetadata = new PackageMetadata();
		pkgMetadata.documents = new List<DocumentMetadata>();

		List<Object> documents = extractor.extractDocuments(rawResponseMap);
		for (Object docObj : documents) {
			Map<String, Object> document = (Map<String, Object>) docObj;
			String collectionIndex = extractor.extractDocumentCollectionIndexId(document);
			if (!String.isEmpty(collectionIndex)) {
				DocumentMetadata docMetadata = new DocumentMetadata();
				docMetadata.hasBeenTagged = extractor.hasSignatureTag(document);
				docMetadata.data = new DocumentCustomData();
				docMetadata.data.documentCollectionId = extractor.extractDocumentCollectionId(document);
				docMetadata.data.documentCollectionIndexId = collectionIndex;
				docMetadata.data.documentVersionId = extractor.extractDocumentVersionId(document);
				docMetadata.data.placeholderId = extractor.extractPlaceholderId(document);
				pkgMetadata.documents.add(docMetadata);
			}
		}
		return pkgMetadata;
	}
}
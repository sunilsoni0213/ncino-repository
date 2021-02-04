public with sharing class AddDocumentMapper {
	@TestVisible
	private AddDocumentPropertyExtractor documentExtractor = new AddDocumentPropertyExtractor();

	public DocumentModel getDocumentModel(Map<String, Object> message) {
		DocumentModel model = new DocumentModel();

		model.name = documentExtractor.getFileName(message);
		model.id = documentExtractor.getPlaceholderId(message);
		model.data = new DocumentCustomData();
		model.data.documentVersionId = documentExtractor.getDocumentVersionId(message);
		model.data.placeholderId = documentExtractor.getPlaceholderId(message);
		model.data.documentCollectionIndexId = documentExtractor.getDocumentCollectionIndexId(message);
		model.data.documentCollectionId = documentExtractor.getDocumentCollectionId(message);

		return model;
	}
}
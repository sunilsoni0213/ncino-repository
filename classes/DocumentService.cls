public with sharing class DocumentService {
	@TestVisible
	private ContentVersionSelector contentVerSelector = new ContentVersionSelector();
	@TestVisible
	private AddDocumentPropertyExtractor documentExtractor = new AddDocumentPropertyExtractor();

	@TestVisible
	private AddDocumentMapper documentMapper = new AddDocumentMapper();

	public String getPackageId(Map<String, Object> message) {
		return documentExtractor.getVendorCollectionId(message);
	}

	public Blob buildDocumentMultipartFormData(Map<String, Object> message) {
		DocumentModel docModel = documentMapper.getDocumentModel(message);
		String fileType = documentExtractor.getFileExtension(message);
		ContentVersion contentVersion = contentVerSelector.fetchContentVersion(documentExtractor.getContentVersionId(message));
		if (contentVersion == null) {
			throw new XException(X_EMPTY_FILE + docModel.name);
		}

		String contentDisposition = '\nContent-Disposition: form-data; name="payload"';
		String secondHeaderEncoded = DocumentEncodeUtility.encodeString(
			'--'
				+ AddDocumentSendService.BOUNDARY
				+ contentDisposition
		);

		List<String> encodedStrings = DocumentEncodeUtility.encodeDocument(
			contentVersion.VersionData,
			AddDocumentSendService.BOUNDARY,
			docModel.name,
			getMimeType(fileType)
		);
		String headerPlusBodyEncoded = encodedStrings[0];
		String footerEncoded = encodedStrings[1];

		String documentJSON = JSON.serialize(docModel);
		String documentJSONEncoded = DocumentEncodeUtility.encodeContent(documentJSON);

		return EncodingUtil.base64Decode(
			headerPlusBodyEncoded
				+ secondHeaderEncoded
				+ documentJSONEncoded
				+ footerEncoded
		);
	}

	@TestVisible
	private static String getMimeType(String fileType) {
		if (String.isNotEmpty(fileType)) {
			switch on fileType.toUpperCase() {
				when 'PDF' {
					return MIME_TYPE_PDF;
				}
				when 'DOCX' {
					return MIME_TYPE_DOC;
				}
				when 'DOC' {
					return MIME_TYPE_DOC;
				}
				when 'TXT' {
					return MIME_TYPE_TXT;
				}
			}
		}

		return '';
	}

	private class XException extends Exception {
	}

	@TestVisible
	private static final String
		MIME_TYPE_PDF = 'application/pdf',
		MIME_TYPE_DOC = 'application/msword',
		MIME_TYPE_TXT = 'text/plain',
		X_EMPTY_FILE = 'The Document has no content: ';
}
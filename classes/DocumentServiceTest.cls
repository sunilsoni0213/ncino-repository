@isTest(IsParallel=true)
public with sharing class DocumentServiceTest {
	@TestSetup
	private static void setup() {
		nFORCE.BeanRegistry.getInstance().registerBean(
			String.valueOf(ClassTypeProvider.class),
			nFORCE.ClassTypeProvider.class,
			ClassTypeProvider.class,
			null,
			true
		);
	}

	@isTest
	private static void shouldReturnPackageId() {
		nFORCE.Mocker.ObjectMock documentMock = nFORCE.Mocker.mock(AddDocumentPropertyExtractor.class);
		documentMock.getMethod('getVendorCollectionId', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('1234');
		DocumentService service = new DocumentService();
		service.documentExtractor = (AddDocumentPropertyExtractor) documentMock.getStub();

		Test.startTest();
		String packageId = service.getPackageId(new Map<String, Object>());
		Test.stopTest();

		System.assertEquals('1234', packageId);
		documentMock.assertExpectations();
	}

	@isTest
	private static void shouldReturnMultipartFormData() {
		nFORCE.Mocker.ObjectMock documentMock = nFORCE.Mocker.mock(AddDocumentPropertyExtractor.class);
		documentMock.getMethod('getFileExtension', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('PDF');
		documentMock.getMethod('getContentVersionId', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('1234');

		ContentVersion contentVersion = new ContentVersion();
		contentVersion.VersionData = Blob.valueOf('fileBlob');

		nFORCE.Mocker.ObjectMock selectorMock = nFORCE.Mocker.mock(ContentVersionSelector.class);
		selectorMock.getMethod('fetchContentVersion', String.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn(contentVersion);

		DocumentModel model = new DocumentModel();
		model.data = new DocumentCustomData();
		model.name = 'Rage.PDF';

		nFORCE.Mocker.ObjectMock mapperMock = nFORCE.Mocker.mock(AddDocumentMapper.class);
		mapperMock.getMethod('getDocumentModel', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn(model);

		DocumentService service = new DocumentService();
		service.documentExtractor = (AddDocumentPropertyExtractor) documentMock.getStub();
		service.contentVerSelector = (ContentVersionSelector) selectorMock.getStub();
		service.documentMapper = (AddDocumentMapper) mapperMock.getStub();

		Test.startTest();
		Blob body = service.buildDocumentMultipartFormData(new Map<String, Object>());
		List<String> bodyLines = body.toString().split('\n');
		Test.stopTest();

		System.assertEquals('--' + AddDocumentSendService.BOUNDARY, bodyLines[0]);
		System.assertEquals('Content-Disposition: form-data; name="file"; filename="Rage.PDF"', bodyLines[1]);
		System.assert(bodyLines[2].startsWith('Content-Type: application/pdf'));
		System.assertEquals('\r', bodyLines[3]);
		System.assertEquals('fileBlob\r' + '--' + AddDocumentSendService.BOUNDARY, bodyLines[4]);
		System.assert(bodyLines[5].startsWith('Content-Disposition: form-data; name="payload"'));
		System.assertEquals('\r', bodyLines[6]);
		System.assert(bodyLines[7].startsWith(JSON.serialize(model)));
		System.assertEquals('--' + AddDocumentSendService.BOUNDARY + '--', bodyLines[9]);
		documentMock.assertExpectations();
		selectorMock.assertExpectations();
		mapperMock.assertExpectations();
	}

	@isTest
	private static void shouldReturnMimeType() {
		Test.startTest();
		String typePDf = DocumentService.getMimeType('pDf');
		String typeDocx = DocumentService.getMimeType('DOCX');
		String typeDoc = DocumentService.getMimeType('doc');
		String typeTxt = DocumentService.getMimeType('TxT');
		String type = DocumentService.getMimeType('Blah');
		Test.stopTest();

		System.assertEquals(DocumentService.MIME_TYPE_PDF, typePDf);
		System.assertEquals(DocumentService.MIME_TYPE_DOC, typeDoc);
		System.assertEquals(DocumentService.MIME_TYPE_DOC, typeDocx);
		System.assertEquals(DocumentService.MIME_TYPE_TXT, typeTxt);
		System.assertEquals('', type);
	}
}
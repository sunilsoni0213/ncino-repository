@IsTest(IsParallel=true)
public with sharing class AddDocumentMapperTest {
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

	@IsTest
	private static void shouldReturnDocumentModel_WhenGetDocumentModelCalled() {
		nFORCE.Mocker.ObjectMock documentMock = nFORCE.Mocker.mock(AddDocumentPropertyExtractor.class);
		documentMock.getMethod('getFileName', Map<String,Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('Rage.PDF');
		documentMock.getMethod('getDocumentVersionId', Map<String,Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('1234');
		documentMock.getMethod('getPlaceholderId', Map<String,Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(2))
			.setExpectedReturn('1234');
		documentMock.getMethod('getDocumentCollectionId', Map<String,Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('1234');
		documentMock.getMethod('getDocumentCollectionIndexId', Map<String,Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('1234');

		AddDocumentMapper mapper = new AddDocumentMapper();
		mapper.documentExtractor = (AddDocumentPropertyExtractor) documentMock.getStub();

		Test.startTest();
		DocumentModel model = mapper.getDocumentModel(new Map<String,Object>());
		Test.stopTest();

		System.assertEquals('Rage.PDF', model.name);
		System.assertEquals('1234', model.data.documentCollectionId);
		System.assertEquals('1234', model.data.placeholderId);
		System.assertEquals('1234', model.data.documentCollectionIndexId);
		documentMock.assertExpectations();
	}
}
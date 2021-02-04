@isTest(IsParallel=true)
public with sharing class RetrievePackageMetadataMapperTest {
	@TestSetup
	static void setup() {
		nFORCE.BeanRegistry.getInstance().registerBean(
			String.valueOf(ClassTypeProvider.class),
			nFORCE.ClassTypeProvider.class,
			ClassTypeProvider.class,
			null,
			true
		);
	}

	@isTest
	private static void shouldPackageMetaData() {
		nFORCE.Mocker.ObjectMock documentMock = nFORCE.Mocker.mock(PackageMetadataResponsePropExtractor.class);
		List<Object> documents = new List<Object>();
		documents.add(new Map<String, Object>());

		documentMock.getMethod('extractDocumentCollectionId', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('🍎');
		documentMock.getMethod('extractDocumentCollectionIndexId', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('🌶');
		documentMock.getMethod('extractDocumentVersionId', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('🍒');
		documentMock.getMethod('extractPlaceholderId', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('🍔');
		documentMock.getMethod('hasSignatureTag', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn(true);
		documentMock.getMethod('extractDocuments', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn(documents);

		RetrievePackageMetadataMapper mapper = new RetrievePackageMetadataMapper();
		mapper.extractor = (PackageMetadataResponsePropExtractor) documentMock.getStub();

		Test.startTest();
		PackageMetadata model = mapper.buildPackageMetadata(new Map<String, Object>());
		Test.stopTest();

		System.assertEquals(1, model.documents.size());
		System.assertEquals('🍎', model.documents[0].data.documentCollectionId);
		System.assertEquals('🍔', model.documents[0].data.placeholderId);
		System.assertEquals('🌶', model.documents[0].data.documentCollectionIndexId);
		System.assertEquals('🍒', model.documents[0].data.documentVersionId);
		System.assertEquals(true, model.documents[0].hasBeenTagged);

		documentMock.assertExpectations();
	}
}
@isTest(IsParallel=true)
public with sharing class GetDesignerUrlMapperTest {
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
	private static void shouldReturnDocumentModel_WhenGetDocumentModelCalled() {
		nFORCE.Mocker.ObjectMock extractorMock = nFORCE.Mocker.mock(GetDesignerUrlPropertyExtractor.class);
		extractorMock.getMethod('getVendorCollectionId', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('1234567890');
		GetDesignerUrlMapper mapper = new GetDesignerUrlMapper();
		mapper.extractor = (GetDesignerUrlPropertyExtractor) extractorMock.getStub();

		Test.startTest();
		DesignerUrlModel model = mapper.buildDesignerUrlModel(new Map<String, Object>());
		Test.stopTest();

		System.assertEquals('1234567890', model.packageId);
		extractorMock.assertExpectations();
	}
}
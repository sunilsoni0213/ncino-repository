@isTest(IsParallel=true)
public with sharing class CreatePackageMapperTest {

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
	private static void shouldReturnCreatePackageModel() {
		List<Map<String, Object>> authSigners = new List<Map<String, Object>>();
		authSigners.add(new Map<String, Object>());
		authSigners.add(new Map<String, Object>());

		nFORCE.Mocker.ObjectMock extractorMock = nFORCE.Mocker.mock(CreatePackagePropertyExtractor.class);
		extractorMock.getMethod('getDocumentCollectionId', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('🌎');
		extractorMock.getMethod('getDocumentCollectionName', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('🌕');
		extractorMock.getMethod('getSignerAuthFirstName', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('🌖');
		extractorMock.getMethod('getSignerAuthLastName', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('🌗');
		extractorMock.getMethod('getSignerAuthId', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('🌑');
		extractorMock.getMethod('getSignerAuthEmail', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(2))
			.setExpectedReturn('🌘');
		extractorMock.getMethod('getAuthorizedSigners', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn(authSigners);

		CreatePackageMapper mapper = new CreatePackageMapper();
		mapper.extractor = (CreatePackagePropertyExtractor) extractorMock.getStub();

		Test.startTest();
		CreatePackageModel model = mapper.buildCreatePackageModel(new nFUSE.MiddlewareMessage());
		Test.stopTest();

		System.assertEquals(CreatePackageMapper.PACKAGE_STATUS_DRAFT, model.status);
		System.assertEquals(CreatePackageMapper.LANGUAGE_EN, model.language);
		System.assertEquals('🌕', model.name);
		System.assertNotEquals(null, model.data);
		System.assertEquals('🌎', model.data.documentCollectionId);
		System.assertEquals(1, model.roles.size());
		System.assertEquals(1, model.roles[0].signers.size());
		System.assertEquals('🌑', model.roles[0].id);
		System.assertEquals('🌖', model.roles[0].signers[0].firstName);
		System.assertEquals('🌗', model.roles[0].signers[0].lastName);
		System.assertEquals('🌘', model.roles[0].signers[0].email);

		extractorMock.assertExpectations();
	}
}
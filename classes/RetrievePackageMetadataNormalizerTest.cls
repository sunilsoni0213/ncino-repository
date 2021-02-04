@isTest(IsParallel=true)
public with sharing class RetrievePackageMetadataNormalizerTest {
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

	@IsTest
	private static void shouldNormalizeResponse() {
		nFUSE.AMiddlewareMessage message = createMiddlewareMessageWithResponse(200, new Map<String, Object>{
			'someId' => 'someValue'
		});

		PackageMetadata pkgMetadata = new PackageMetadata();
		DocumentMetadata docMetadata = new DocumentMetadata();
		docMetadata.hasBeenTagged = true;
		docMetadata.data = new DocumentCustomData();
		docMetadata.data.documentCollectionId = '1234';
		pkgMetadata.documents = new List<DocumentMetadata>{docMetadata, docMetadata};

		nFORCE.Mocker.ObjectMock mapperMock = nFORCE.Mocker.mock(RetrievePackageMetadataMapper.class);
		mapperMock.getMethod('buildPackageMetadata', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn(pkgMetadata);

		RetrievePackageMetadataNormalizer normalizer = new RetrievePackageMetadataNormalizer();
		normalizer.mapper = (RetrievePackageMetadataMapper) mapperMock.getStub();

		Test.startTest();
		String output = normalizer.process(message);
		Test.stopTest();

		Map<String, Object> outputMap = (Map<String, Object>) JSON.deserializeUntyped(output);

		System.assertNotEquals(null, output);
		System.assertEquals(new Map<String, Object>(), outputMap.get(AResponseNormalizer.KEY_RAW_RESPONSE));
		System.assertNotEquals(
			null,
			outputMap.get(AResponseNormalizer.KEY_RESPONSE)
		);

		Map<String, Object> normalizedResponseOutputMap = (Map<String, Object>) outputMap
			.get(AResponseNormalizer.KEY_RESPONSE);

		System.assertEquals(
			200,
			(Integer) normalizedResponseOutputMap.get(
				RetrievePackageMetadataNormalizer.KEY_NORMALIZED_STATUS_CODE
			)
		);

		PackageMetadata outputMeta =  (PackageMetadata) JSON.deserialize(
			JSON.serialize(normalizedResponseOutputMap.get(
				RetrievePackageMetadataNormalizer.KEY_VENDOR_COLLECTION_METADATA)
			), PackageMetadata.class);

		System.assertEquals(pkgMetadata.documents[0].data.documentCollectionId, outputMeta.documents[0].data.documentCollectionId);
		System.assertEquals(pkgMetadata.documents[0].hasBeenTagged, outputMeta.documents[0].hasBeenTagged);
		System.assertEquals(pkgMetadata.documents[1].data.documentCollectionId, outputMeta.documents[1].data.documentCollectionId);
		System.assertEquals(pkgMetadata.documents[1].hasBeenTagged, outputMeta.documents[1].hasBeenTagged);
		System.assertEquals(pkgMetadata.documents.size(), outputMeta.documents.size());
		mapperMock.assertExpectations();
	}

	public static nFUSE.AMiddlewareMessage createMiddlewareMessageWithResponse(Integer statusCode, Map<String, Object> bodyParams) {
		nFUSE.MiddlewareMessage testMessage = new nFUSE.MiddlewareMessage();
		testMessage.httpResponse = buildHttpResponse(200, JSON.serialize(bodyParams));

		return testMessage;
	}

	private static HttpResponse buildHttpResponse(Integer statusCode, String body) {
		HttpResponse response = new HttpResponse();
		response.setStatusCode(statusCode);
		response.setBody(body);

		return response;
	}
}
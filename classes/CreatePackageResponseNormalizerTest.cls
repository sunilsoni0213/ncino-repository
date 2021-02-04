@isTest(IsParallel=true)
public with sharing class CreatePackageResponseNormalizerTest {
	@IsTest
	private static void process_clean() {
		nFUSE.AMiddlewareMessage testMessage = createMiddlewareMessageWithResponse(200, new Map<String, Object>{
			CreatePackageResponseNormalizer.KEY_ID => ID_VALUE
		});
		testMessage.properties = new Map<String, Object>{
			'testProp' => 'testValue'
		};

		Test.startTest();
		String output = new CreatePackageResponseNormalizer().process(testMessage);
		Test.stopTest();

		Map<String, Object> outputMap = (Map<String, Object>) JSON.deserializeUntyped(output);

		System.assertNotEquals(null, output);
		System.assertNotEquals(null, outputMap.get(AResponseNormalizer.KEY_RAW_RESPONSE));
		System.assertNotEquals(
			null,
			outputMap.get(AResponseNormalizer.KEY_RESPONSE)
		);

		Map<String, Object> rawResponseOutputMap = (Map<String, Object>) outputMap
			.get(AResponseNormalizer.KEY_RAW_RESPONSE);

		Map<String, Object> normalizedResponseOutputMap = (Map<String, Object>) outputMap
			.get(AResponseNormalizer.KEY_RESPONSE);

		System.assertEquals(
			ID_VALUE,
			(String) rawResponseOutputMap.get(
				CreatePackageResponseNormalizer.KEY_ID
			)
		);
		System.assertEquals(
			200,
			(Integer) normalizedResponseOutputMap.get(
				CreatePackageResponseNormalizer.KEY_NORMALIZED_STATUS_CODE
			)
		);
		System.assertEquals(
			ID_VALUE,
			(String) normalizedResponseOutputMap.get(
				CreatePackageResponseNormalizer.KEY_VENDOR_COLLECTION_ID
			)
		);
	}

	@IsTest
	private static void process_badResponse_nullCollectionId() {
		nFUSE.AMiddlewareMessage testMessage = createMiddlewareMessageWithResponse(200, new Map<String, Object>{
			CreatePackageResponseNormalizer.KEY_ID => null
		});

		Test.startTest();
		String errorMessage;
		try {
			String output = new CreatePackageResponseNormalizer().process(testMessage);
		} catch (Exception ex) {
			errorMessage = ex.getMessage();
		}
		Test.stopTest();

		System.assertEquals(
			true,
			errorMessage.contains(CreatePackageResponseNormalizer.X_CREATE_PACKAGE_ID_NOT_FOUND.substring(0, 20))
		);
	}

	@IsTest
	private static void process_badResponse_emptyStringCollectionId() {
		nFUSE.AMiddlewareMessage testMessage = createMiddlewareMessageWithResponse(200, new Map<String, Object>{
			CreatePackageResponseNormalizer.KEY_ID => ''
		});

		Test.startTest();
		String errorMessage;
		try {
			String output = new CreatePackageResponseNormalizer().process(testMessage);
		} catch (Exception ex) {
			errorMessage = ex.getMessage();
		}
		Test.stopTest();

		System.assertEquals(
			true,
			errorMessage.contains(CreatePackageResponseNormalizer.X_CREATE_PACKAGE_ID_NOT_FOUND.substring(0, 20))
		);
	}

	private static HttpResponse buildHttpResponse(Integer statusCode, String body) {
		HttpResponse response = new HttpResponse();
		response.setStatusCode(statusCode);
		response.setBody(body);

		return response;
	}

	public static nFUSE.AMiddlewareMessage createMiddlewareMessageWithResponse(Integer statusCode, Map<String, Object> bodyParams) {
		nFUSE.MiddlewareMessage testMessage = new nFUSE.MiddlewareMessage();
		testMessage.httpResponse = buildHttpResponse(200, JSON.serialize(bodyParams));

		return testMessage;
	}

	private static final String
		ID_VALUE = '9sKhW-h-qS9m6Ho3zRv3n2a-rkI=';
}
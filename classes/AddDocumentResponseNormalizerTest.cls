@IsTest(IsParallel=true)
public with sharing class AddDocumentResponseNormalizerTest {
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
	private static void shouldNormalizeResponse() {
		nFUSE.AMiddlewareMessage message = createMiddlewareMessageWithResponse(200, new Map<String, Object>{
			AddDocumentResponseNormalizer.KEY_ID => DOCUMENT_ID
		});

		AddDocumentResponseNormalizer normalizer = new AddDocumentResponseNormalizer();

		Test.startTest();
		String output = normalizer.process(message);
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
			DOCUMENT_ID,
			(String) rawResponseOutputMap.get(
				AddDocumentResponseNormalizer.KEY_ID
			)
		);
		System.assertEquals(
			200,
			(Integer) normalizedResponseOutputMap.get(
				AddDocumentResponseNormalizer.KEY_NORMALIZED_STATUS_CODE
			)
		);
		System.assertEquals(
			DOCUMENT_ID,
			(String) normalizedResponseOutputMap.get(
				AddDocumentResponseNormalizer.KEY_VENDOR_DOCUMENT_ID
			)
		);
	}

	@IsTest
	private static void shouldReturnException_whenBadResponse_nullToken() {
		nFUSE.AMiddlewareMessage message = createMiddlewareMessageWithResponse(200, new Map<String, Object>{
			AddDocumentResponseNormalizer.KEY_ID => null
		});

		Test.startTest();
		String errorMessage;
		try {
			String output = new AddDocumentResponseNormalizer().process(message);
		} catch (Exception ex) {
			errorMessage = ex.getMessage();
		}
		Test.stopTest();

		System.assert(
			errorMessage.contains(AddDocumentResponseNormalizer.X_ADD_DOCUMENT_ID_NOT_FOUND.substring(0, 20))
		);
	}

	@IsTest
	private static void shouldReturnException_whenBadResponse_emptyToken() {
		nFUSE.AMiddlewareMessage testMessage = createMiddlewareMessageWithResponse(200, new Map<String, Object>{
			AddDocumentResponseNormalizer.KEY_ID => ''
		});

		Test.startTest();
		String errorMessage;
		try {
			String output = new AddDocumentResponseNormalizer().process(testMessage);
		} catch (Exception ex) {
			errorMessage = ex.getMessage();
		}
		Test.stopTest();

		System.assert(
			errorMessage.contains(AddDocumentResponseNormalizer.X_ADD_DOCUMENT_ID_NOT_FOUND.substring(0, 20))
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
		testMessage.httpResponse = buildHttpResponse(statusCode, JSON.serialize(bodyParams));

		return testMessage;
	}

	private static final String
		DOCUMENT_ID = '9sKhW-h-qS9m6Ho3zRv3n2a-rkI=';
}
@isTest(IsParallel=true)
public with sharing class GetDesignerUrlResponseNormalizerTest {
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
			GetDesignerUrlResponseNormalizer.KEY_VALUE => TOKEN
		});

		nFORCE.Mocker.ObjectMock extractorMock = nFORCE.Mocker.mock(GetDesignerUrlPropertyExtractor.class);
		extractorMock.getMethod('getVendorCollectionId', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('1234567890');

		PluginConfigurationService pluginConfigService = new PluginConfigurationService();
		List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs
			= new List<nFUSE.PluginConfigurationManager.PluginConfiguration>{
				pluginConfigService.createConfig(OneSpanESignature.KEY_DESIGNER_SESSION_URL, 'testUrl/{senderToken}/FFactory/{packageId}/blah/', false)
			};
		new nFUSE.PluginConfigurationManager(OneSpanESignature.PLUGIN_NAME, OneSpanESignature.PLUGIN_VERSION).softInsertConfigurations(configs);

		GetDesignerUrlResponseNormalizer normalizer = new GetDesignerUrlResponseNormalizer();
		normalizer.designerPropertyExtractor = (GetDesignerUrlPropertyExtractor) extractorMock.getStub();

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
			TOKEN,
			(String) rawResponseOutputMap.get(
				GetDesignerUrlResponseNormalizer.KEY_VALUE
			)
		);
		System.assertEquals(
			200,
			(Integer) normalizedResponseOutputMap.get(
				GetDesignerUrlResponseNormalizer.KEY_NORMALIZED_STATUS_CODE
			)
		);
		System.assertEquals(
			'testUrl/' + TOKEN + '/FFactory/1234567890/blah/',
			(String) normalizedResponseOutputMap.get(
				GetDesignerUrlResponseNormalizer.KEY_TAGGING_URL
			)
		);
		extractorMock.assertExpectations();
	}

	@IsTest
	private static void shouldReturnException_whenBadResponse_nullToken() {
		nFUSE.AMiddlewareMessage message = createMiddlewareMessageWithResponse(200, new Map<String, Object>{
			GetDesignerUrlResponseNormalizer.KEY_VALUE => null
		});

		Test.startTest();
		String errorMessage;
		try {
			String output = new GetDesignerUrlResponseNormalizer().process(message);
		} catch (Exception ex) {
			errorMessage = ex.getMessage();
		}
		Test.stopTest();

		System.assert(
			errorMessage.contains(GetDesignerUrlResponseNormalizer.X_DESIGNER_TOKEN_NOT_FOUND.substring(0, 20))
		);
	}

	@IsTest
	private static void shouldReturnException_whenBadResponse_emptyToken() {
		nFUSE.AMiddlewareMessage testMessage = createMiddlewareMessageWithResponse(200, new Map<String, Object>{
			GetDesignerUrlResponseNormalizer.KEY_VALUE => ''
		});

		Test.startTest();
		String errorMessage;
		try {
			String output = new GetDesignerUrlResponseNormalizer().process(testMessage);
		} catch (Exception ex) {
			errorMessage = ex.getMessage();
		}
		Test.stopTest();

		System.assert(
			errorMessage.contains(GetDesignerUrlResponseNormalizer.X_DESIGNER_TOKEN_NOT_FOUND.substring(0, 20))
		);
	}

	@IsTest
	private static void shouldReturnException_whenDesignerSessionUrlNotConfigured() {
		nFUSE.AMiddlewareMessage message = createMiddlewareMessageWithResponse(200, new Map<String, Object>{
			GetDesignerUrlResponseNormalizer.KEY_VALUE => 'ddd'
		});

		nFORCE.Mocker.ObjectMock extractorMock = nFORCE.Mocker.mock(GetDesignerUrlPropertyExtractor.class);
		extractorMock.getMethod('getVendorCollectionId', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('1234567890');

		GetDesignerUrlResponseNormalizer normalizer = new GetDesignerUrlResponseNormalizer();
		normalizer.designerPropertyExtractor = (GetDesignerUrlPropertyExtractor) extractorMock.getStub();

		Test.startTest();
		String errorMessage;
		try {
			String output = normalizer.process(message);
		} catch (Exception ex) {
			errorMessage = ex.getMessage();
		}
		Test.stopTest();

		System.assert(
			errorMessage.contains(GetDesignerUrlResponseNormalizer.X_ESIGNATURE_DESIGNER_NOT_CONFIGURED)
		);
		extractorMock.assertExpectations();
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
		TOKEN = '9sKhW-h-qS9m6Ho3zRv3n2a-rkI=';
}
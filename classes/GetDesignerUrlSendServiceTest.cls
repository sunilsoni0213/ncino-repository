@isTest(IsParallel=true)
public with sharing class GetDesignerUrlSendServiceTest {
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
	private static void shouldSetHttpRequest_WhenPreSendRequestCalled() {
		PluginConfigurationService pluginConfigService = new PluginConfigurationService();

		List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs
			= new List<nFUSE.PluginConfigurationManager.PluginConfiguration>{
				pluginConfigService.createConfig(OneSpanESignature.KEY_GET_DESIGNER_URL_ENDPOINT, 'testUrl/sender', false),
				pluginConfigService.createConfig(OneSpanESignature.KEY_CONFIG_API_KEY, '123456', false)
			};
		new nFUSE.PluginConfigurationManager(OneSpanESignature.PLUGIN_NAME, OneSpanESignature.PLUGIN_VERSION).softInsertConfigurations(configs);

		HttpRequest httpReq = new HttpRequest();
		nFUSE.AMiddlewareMessage m = new nFUSE.MiddlewareMessage();

		DesignerUrlModel model = new DesignerUrlModel();
		model.packageId = '1234';
		nFORCE.Mocker.ObjectMock mapperMock = nFORCE.Mocker.mock(GetDesignerUrlMapper.class);
		mapperMock.getMethod('buildDesignerUrlModel', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn(model);

		GetDesignerUrlSendService service = new GetDesignerUrlSendService();
		service.designerUrlMapper = (GetDesignerUrlMapper) mapperMock.getStub();

		Test.startTest();
		service.preSendRequest(httpReq, m);
		Test.stopTest();

		System.assertEquals('testUrl/sender', httpReq.getEndpoint());
		System.assertEquals('Basic 123456', httpReq.getHeader('Authorization'));
		System.assertEquals('application/json', httpReq.getHeader('Content-Type'));
		System.assertEquals('application/json', httpReq.getHeader('Accept'));
		System.assertEquals(JSON.serialize(model), httpReq.getBody());
		mapperMock.assertExpectations();
	}

	@isTest
	private static void shouldReturnException_WhenNoEndPointURL() {
		PluginConfigurationService pluginConfigService = new PluginConfigurationService();

		List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs
			= new List<nFUSE.PluginConfigurationManager.PluginConfiguration>{
				pluginConfigService.createConfig(OneSpanESignature.KEY_CONFIG_API_KEY, '123456', false)
			};
		new nFUSE.PluginConfigurationManager(OneSpanESignature.PLUGIN_NAME, OneSpanESignature.PLUGIN_VERSION).softInsertConfigurations(configs);

		HttpRequest httpReq = new HttpRequest();
		nFUSE.AMiddlewareMessage m = new nFUSE.MiddlewareMessage();

		try {
			new GetDesignerUrlSendService().preSendRequest(httpReq, m);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assertEquals(GetDesignerUrlSendService.X_ESIGNATURE_CONFIGS_NOT_CONFIGURED, ex.getMessage());
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoAPIKey() {
		PluginConfigurationService pluginConfigService = new PluginConfigurationService();

		List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs
			= new List<nFUSE.PluginConfigurationManager.PluginConfiguration>{
				pluginConfigService.createConfig(OneSpanESignature.KEY_GET_DESIGNER_URL_ENDPOINT, 'testUrl', false)
			};
		new nFUSE.PluginConfigurationManager(OneSpanESignature.PLUGIN_NAME, OneSpanESignature.PLUGIN_VERSION).softInsertConfigurations(configs);

		HttpRequest httpReq = new HttpRequest();
		nFUSE.AMiddlewareMessage m = new nFUSE.MiddlewareMessage();

		try {
			new GetDesignerUrlSendService().preSendRequest(httpReq, m);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assertEquals(GetDesignerUrlSendService.X_ESIGNATURE_CONFIGS_NOT_CONFIGURED, ex.getMessage());
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoHTTPRequest() {
		try {
			new GetDesignerUrlSendService().preSendRequest(null, new nFUSE.MiddlewareMessage());
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assertEquals(GetDesignerUrlSendService.X_HTTP_ERROR, ex.getMessage());
		}
	}

	@IsTest
	private static void shouldCallProcess_whenPostSendSeam() {
		nFORCE.Mocker.ObjectMock mockNormalizer = nFORCE.Mocker.mock(AResponseNormalizer.class);
		mockNormalizer.getMethod('process', nFUSE.AMiddlewareMessage.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('');

		nFUSE.AMiddlewareMessage message = GetDesignerUrlResponseNormalizerTest.createMiddlewareMessageWithResponse(200, new Map<String, Object>{});
		GetDesignerUrlSendService service = new GetDesignerUrlSendService();
		service.normalizer = (AResponseNormalizer) mockNormalizer.getStub();

		Test.startTest();
		service.postSendSeam(message);
		Test.stopTest();

		mockNormalizer.assertExpectations();
	}

	@IsTest
	private static void shouldThrowException_whenPostSendSeam_emptyString() {
		String exceptionMessage;

		Test.startTest();
		try {
			new GetDesignerUrlSendService().postSendSeam(null);
		} catch (Exception ex) {
			exceptionMessage = ex.getMessage();
		}
		Test.stopTest();

		System.assertNotEquals(null, exceptionMessage);
		System.assert(exceptionMessage.contains(GetDesignerUrlSendService.X_EXPECTED_HTTP_RESPONSE));
	}

	@IsTest
	private static void shouldThrowException_whenPostSendSeam_messageHasNoResponse() {
		String exceptionMessage;

		Test.startTest();
		try {
			new GetDesignerUrlSendService().postSendSeam(new nFUSE.MiddlewareMessage());
		} catch (Exception ex) {
			exceptionMessage = ex.getMessage();
		}
		Test.stopTest();

		System.assertNotEquals(null, exceptionMessage);
		System.assert(exceptionMessage.contains(GetDesignerUrlSendService.X_EXPECTED_HTTP_RESPONSE));
	}
}
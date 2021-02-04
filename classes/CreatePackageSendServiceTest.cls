@isTest(IsParallel=true)
public with sharing class CreatePackageSendServiceTest {
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
	private static void shouldSetHeaders_WhenPreSendRequest() {
		PluginConfigurationService pluginConfigService = new PluginConfigurationService();

		List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs
			= new List<nFUSE.PluginConfigurationManager.PluginConfiguration>{
				pluginConfigService.createConfig(OneSpanESignature.KEY_CREATE_PACKAGE_ENDPOINT, 'testUrl', false),
				pluginConfigService.createConfig(OneSpanESignature.KEY_CONFIG_API_KEY, '123456', false)
			};
		new nFUSE.PluginConfigurationManager(OneSpanESignature.PLUGIN_NAME, OneSpanESignature.PLUGIN_VERSION).softInsertConfigurations(configs);

		HttpRequest httpReq = new HttpRequest();
		nFUSE.AMiddlewareMessage m = new nFUSE.MiddlewareMessage();

		nFORCE.Mocker.ObjectMock createPackageMock = nFORCE.Mocker.mock(CreatePackageMapper.class);
		createPackageMock.getMethod('buildCreatePackageModel', nFUSE.AMiddlewareMessage.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn(new CreatePackageModel());

		CreatePackageSendService service = new CreatePackageSendService();
		CreatePackageSendService.createPackageMapper = (CreatePackageMapper) createPackageMock.getStub();

		Test.startTest();
		service.preSendRequest(httpReq, m);
		Test.stopTest();

		System.assertEquals('testUrl', httpReq.getEndpoint());
		System.assertEquals('Basic 123456', httpReq.getHeader('Authorization'));
		createPackageMock.assertExpectations();
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
			new CreatePackageSendService().preSendRequest(httpReq, m);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assertEquals(true, ex.getMessage().equals(CreatePackageSendService.X_ESIGNATURE_CONFIGS_NOT_CONFIGURED));
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoAPIKey() {
		PluginConfigurationService pluginConfigService = new PluginConfigurationService();

		List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs
			= new List<nFUSE.PluginConfigurationManager.PluginConfiguration>{
				pluginConfigService.createConfig(OneSpanESignature.KEY_CREATE_PACKAGE_ENDPOINT, 'testUrl', false)
			};
		new nFUSE.PluginConfigurationManager(OneSpanESignature.PLUGIN_NAME, OneSpanESignature.PLUGIN_VERSION).softInsertConfigurations(configs);

		HttpRequest httpReq = new HttpRequest();
		nFUSE.AMiddlewareMessage m = new nFUSE.MiddlewareMessage();

		try {
			new CreatePackageSendService().preSendRequest(httpReq, m);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assertEquals(true, ex.getMessage().equals(CreatePackageSendService.X_ESIGNATURE_CONFIGS_NOT_CONFIGURED));
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoHTTPRequest() {
		PluginConfigurationService pluginConfigService = new PluginConfigurationService();

		List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs
			= new List<nFUSE.PluginConfigurationManager.PluginConfiguration>{
				pluginConfigService.createConfig(OneSpanESignature.KEY_CREATE_PACKAGE_ENDPOINT, 'testUrl', false),
				pluginConfigService.createConfig(OneSpanESignature.KEY_CONFIG_API_KEY, '123456', false)
			};
		new nFUSE.PluginConfigurationManager(OneSpanESignature.PLUGIN_NAME, OneSpanESignature.PLUGIN_VERSION).softInsertConfigurations(configs);

		nFUSE.AMiddlewareMessage m = new nFUSE.MiddlewareMessage();

		try {
			new CreatePackageSendService().preSendRequest(null, m);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assertEquals(true, ex.getMessage().equals(CreatePackageSendService.X_HTTP_ERROR));
		}
	}

	@IsTest
	private static void shouldCallProcess_whenPostSendSeam() {
		nFORCE.Mocker.ObjectMock mockNormalizer = nFORCE.Mocker.mock(AResponseNormalizer.class);
		mockNormalizer.getMethod('process', nFUSE.AMiddlewareMessage.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('');

		nFUSE.AMiddlewareMessage message = CreatePackageResponseNormalizerTest.createMiddlewareMessageWithResponse(200, new Map<String, Object>{});
		CreatePackageSendService service = new CreatePackageSendService();
		CreatePackageSendService.normalizer = (AResponseNormalizer) mockNormalizer.getStub();

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
			new CreatePackageSendService().postSendSeam(null);
		} catch (Exception ex) {
			exceptionMessage = ex.getMessage();
		}
		Test.stopTest();

		System.assertNotEquals(null, exceptionMessage);
		System.assertEquals(true, exceptionMessage.contains(CreatePackageSendService.X_EXPECTED_HTTP_RESPONSE));
	}

	@IsTest
	private static void shouldThrowException_whenPostSendSeam_messageHasNoResponse() {
		String exceptionMessage;

		Test.startTest();
		try {
			new CreatePackageSendService().postSendSeam(new nFUSE.MiddlewareMessage());
		} catch (Exception ex) {
			exceptionMessage = ex.getMessage();
		}
		Test.stopTest();

		System.assertNotEquals(null, exceptionMessage);
		System.assertEquals(true, exceptionMessage.contains(CreatePackageSendService.X_EXPECTED_HTTP_RESPONSE));
	}
}
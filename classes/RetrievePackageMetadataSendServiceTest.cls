@isTest(IsParallel=true)
public with sharing class RetrievePackageMetadataSendServiceTest {
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
	private static void shouldSetHttpRequest_WhenPreSendRequestCalled() {
		PluginConfigurationService pluginConfigService = new PluginConfigurationService();

		List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs
			= new List<nFUSE.PluginConfigurationManager.PluginConfiguration>{
				pluginConfigService.createConfig(OneSpanESignature.KEY_RETRIEVE_PACKAGE_METADATA_ENDPOINT, 'testUrl/package/{packageId}', false),
				pluginConfigService.createConfig(OneSpanESignature.KEY_CONFIG_API_KEY, '123456', false)
			};
		new nFUSE.PluginConfigurationManager(OneSpanESignature.PLUGIN_NAME, OneSpanESignature.PLUGIN_VERSION).softInsertConfigurations(configs);

		HttpRequest httpReq = new HttpRequest();
		nFUSE.AMiddlewareMessage m = new nFUSE.MiddlewareMessage();

		nFORCE.Mocker.ObjectMock extractorMock = nFORCE.Mocker.mock(PackageMetadataMessagePropertyExtractor.class);
		extractorMock.getMethod('getVendorCollectionId', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('1234');

		RetrievePackageMetadataSendService service = new RetrievePackageMetadataSendService();
		service.propertyExtractor = (PackageMetadataMessagePropertyExtractor) extractorMock.getStub();
		Test.startTest();
		service.preSendRequest(httpReq, m);
		Test.stopTest();

		System.assertEquals('testUrl/package/1234', httpReq.getEndpoint());
		System.assertEquals('Basic 123456', httpReq.getHeader('Authorization'));
		System.assertEquals('application/json', httpReq.getHeader('Content-Type'));
		System.assertEquals('application/json', httpReq.getHeader('Accept'));
		extractorMock.assertExpectations();
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
		nFORCE.Mocker.ObjectMock extractorMock = nFORCE.Mocker.mock(PackageMetadataMessagePropertyExtractor.class);
		extractorMock.getMethod('getVendorCollectionId', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('1234');

		RetrievePackageMetadataSendService service = new RetrievePackageMetadataSendService();
		service.propertyExtractor = (PackageMetadataMessagePropertyExtractor) extractorMock.getStub();

		try {
			service.preSendRequest(httpReq, m);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assertEquals(RetrievePackageMetadataSendService.X_ESIGNATURE_CONFIGS_NOT_CONFIGURED, ex.getMessage());
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoAPIKey() {
		PluginConfigurationService pluginConfigService = new PluginConfigurationService();

		List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs
			= new List<nFUSE.PluginConfigurationManager.PluginConfiguration>{
				pluginConfigService.createConfig(OneSpanESignature.KEY_RETRIEVE_PACKAGE_METADATA_ENDPOINT, 'testUrl', false)
			};
		new nFUSE.PluginConfigurationManager(OneSpanESignature.PLUGIN_NAME, OneSpanESignature.PLUGIN_VERSION).softInsertConfigurations(configs);

		HttpRequest httpReq = new HttpRequest();
		nFUSE.AMiddlewareMessage m = new nFUSE.MiddlewareMessage();
		nFORCE.Mocker.ObjectMock extractorMock = nFORCE.Mocker.mock(PackageMetadataMessagePropertyExtractor.class);
		extractorMock.getMethod('getVendorCollectionId', Map<String, Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('1234');

		RetrievePackageMetadataSendService service = new RetrievePackageMetadataSendService();
		service.propertyExtractor = (PackageMetadataMessagePropertyExtractor) extractorMock.getStub();

		try {
			service.preSendRequest(httpReq, m);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assertEquals(RetrievePackageMetadataSendService.X_ESIGNATURE_CONFIGS_NOT_CONFIGURED, ex.getMessage());
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoHTTPRequest() {
		try {
			new RetrievePackageMetadataSendService().preSendRequest(null, new nFUSE.MiddlewareMessage());
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assertEquals(RetrievePackageMetadataSendService.X_HTTP_ERROR, ex.getMessage());
		}
	}

	@IsTest
	private static void shouldCallProcess_whenPostSendSeam() {
		nFORCE.Mocker.ObjectMock mockNormalizer = nFORCE.Mocker.mock(AResponseNormalizer.class);
		mockNormalizer.getMethod('process', nFUSE.AMiddlewareMessage.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('');

		nFUSE.AMiddlewareMessage message = RetrievePackageMetadataNormalizerTest.createMiddlewareMessageWithResponse(200, new Map<String, Object>{});
		RetrievePackageMetadataSendService service = new RetrievePackageMetadataSendService();
		RetrievePackageMetadataSendService.normalizer = (AResponseNormalizer) mockNormalizer.getStub();

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
			new RetrievePackageMetadataSendService().postSendSeam(null);
		} catch (Exception ex) {
			exceptionMessage = ex.getMessage();
		}
		Test.stopTest();

		System.assertNotEquals(null, exceptionMessage);
		System.assertEquals(true, exceptionMessage.contains(RetrievePackageMetadataSendService.X_EXPECTED_HTTP_RESPONSE));
	}

	@IsTest
	private static void shouldThrowException_whenPostSendSeam_messageHasNoResponse() {
		String exceptionMessage;

		Test.startTest();
		try {
			new RetrievePackageMetadataSendService().postSendSeam(new nFUSE.MiddlewareMessage());
		} catch (Exception ex) {
			exceptionMessage = ex.getMessage();
		}
		Test.stopTest();

		System.assertNotEquals(null, exceptionMessage);
		System.assertEquals(true, exceptionMessage.contains(RetrievePackageMetadataSendService.X_EXPECTED_HTTP_RESPONSE));
	}
}
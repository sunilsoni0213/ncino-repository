@isTest(IsParallel=true)
public with sharing class AddDocumentSendServiceTest {
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
				pluginConfigService.createConfig(OneSpanESignature.KEY_ADD_DOCUMENT_ENDPOINT, 'testUrl/{packageId}/documents', false),
				pluginConfigService.createConfig(OneSpanESignature.KEY_CONFIG_API_KEY, '123456', false)
			};
		new nFUSE.PluginConfigurationManager(OneSpanESignature.PLUGIN_NAME, OneSpanESignature.PLUGIN_VERSION).softInsertConfigurations(configs);

		HttpRequest httpReq = new HttpRequest();
		nFUSE.AMiddlewareMessage m = new nFUSE.MiddlewareMessage();

		nFORCE.Mocker.ObjectMock documentMock = nFORCE.Mocker.mock(DocumentService.class);
		documentMock.getMethod('buildDocumentMultipartFormData', Map<String,Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn(Blob.valueOf('fileBlob'));
		documentMock.getMethod('getPackageId', Map<String,Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('1234567890');

		AddDocumentSendService service = new AddDocumentSendService();
		AddDocumentSendService.docService = (DocumentService) documentMock.getStub();

		Test.startTest();
		service.preSendRequest(httpReq, m);
		Test.stopTest();

		System.assertEquals('testUrl/1234567890/documents', httpReq.getEndpoint());
		System.assertEquals('Basic 123456', httpReq.getHeader('Authorization'));
		System.assertEquals('multipart/form-data; boundary=' + AddDocumentSendService.BOUNDARY, httpReq.getHeader('Content-Type'));
		System.assertEquals(Blob.valueOf('fileBlob'), httpReq.getBodyAsBlob());
		documentMock.assertExpectations();
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

		nFORCE.Mocker.ObjectMock documentMock = nFORCE.Mocker.mock(DocumentService.class);
		documentMock.getMethod('buildDocumentMultipartFormData', Map<String,Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn(Blob.valueOf('fileBlob'));
		documentMock.getMethod('getPackageId', Map<String,Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('1234567890');
		AddDocumentSendService service = new AddDocumentSendService();
		AddDocumentSendService.docService = (DocumentService) documentMock.getStub();

		try {
			service.preSendRequest(httpReq, m);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assertEquals(AddDocumentSendService.X_ESIGNATURE_CONFIGS_NOT_CONFIGURED, ex.getMessage());
		}
		documentMock.assertExpectations();
	}

	@isTest
	private static void shouldReturnException_WhenNoAPIKey() {
		PluginConfigurationService pluginConfigService = new PluginConfigurationService();

		List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs
			= new List<nFUSE.PluginConfigurationManager.PluginConfiguration>{
				pluginConfigService.createConfig(OneSpanESignature.KEY_ADD_DOCUMENT_ENDPOINT, 'testUrl', false)
			};
		new nFUSE.PluginConfigurationManager(OneSpanESignature.PLUGIN_NAME, OneSpanESignature.PLUGIN_VERSION).softInsertConfigurations(configs);

		HttpRequest httpReq = new HttpRequest();
		nFUSE.AMiddlewareMessage m = new nFUSE.MiddlewareMessage();

		nFORCE.Mocker.ObjectMock documentMock = nFORCE.Mocker.mock(DocumentService.class);
		documentMock.getMethod('buildDocumentMultipartFormData', Map<String,Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn(Blob.valueOf('fileBlob'));
		documentMock.getMethod('getPackageId', Map<String,Object>.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('1234567890');

		AddDocumentSendService service = new AddDocumentSendService();
		AddDocumentSendService.docService = (DocumentService) documentMock.getStub();
		try {
			service.preSendRequest(httpReq, m);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assertEquals(AddDocumentSendService.X_ESIGNATURE_CONFIGS_NOT_CONFIGURED, ex.getMessage());
		}
		documentMock.assertExpectations();
	}

	@isTest
	private static void shouldReturnException_WhenNoHTTPRequest() {
		try {
			new AddDocumentSendService().preSendRequest(null, new nFUSE.MiddlewareMessage());
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assertEquals(AddDocumentSendService.X_HTTP_ERROR, ex.getMessage());
		}
	}

	@IsTest
	private static void shouldCallProcess_whenPostSendSeam() {
		nFORCE.Mocker.ObjectMock mockNormalizer = nFORCE.Mocker.mock(AResponseNormalizer.class);
		mockNormalizer.getMethod('process', nFUSE.AMiddlewareMessage.class)
			.setExpectedCallCount(nFORCE.APredicate.equals(1))
			.setExpectedReturn('');

		nFUSE.AMiddlewareMessage message = AddDocumentResponseNormalizerTest.createMiddlewareMessageWithResponse(200, new Map<String, Object>{});
		AddDocumentSendService service = new AddDocumentSendService();
		AddDocumentSendService.normalizer = (AResponseNormalizer) mockNormalizer.getStub();

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
			new AddDocumentSendService().postSendSeam(null);
		} catch (Exception ex) {
			exceptionMessage = ex.getMessage();
		}
		Test.stopTest();

		System.assertNotEquals(null, exceptionMessage);
		System.assertEquals(true, exceptionMessage.contains(AddDocumentSendService.X_EXPECTED_HTTP_RESPONSE));
	}

	@IsTest
	private static void shouldThrowException_whenPostSendSeam_messageHasNoResponse() {
		String exceptionMessage;

		Test.startTest();
		try {
			new AddDocumentSendService().postSendSeam(new nFUSE.MiddlewareMessage());
		} catch (Exception ex) {
			exceptionMessage = ex.getMessage();
		}
		Test.stopTest();

		System.assertNotEquals(null, exceptionMessage);
		System.assertEquals(true, exceptionMessage.contains(AddDocumentSendService.X_EXPECTED_HTTP_RESPONSE));
	}
}
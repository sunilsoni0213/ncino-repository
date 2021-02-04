@isTest
public with sharing class TestESignLiveESignature {

	@TestSetup
	static void setup() {
		new nFUSE.DataInstaller().onInstall(null);
	}

	@isTest
	private static void testActivation_onActivate_registerBean() {
		Test.startTest();
		new ESignLiveESignature().onActivate();
		Test.stopTest();

		nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest('E_Sign_Live_Esignature', '1.0', null);
		nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();

		verifyPluginConfigurationsInstalled();
		System.assert(locator.locate(request, nFUSE.eSignatureService.class) instanceof ESignLiveESignature.EsignLiveService);
	}

	@isTest
	private static void testActivation_onActivateTwice_registerBean() {
		Test.startTest();
		ESignLiveESignature act = new ESignLiveESignature();
		act.onActivate();
		act.onDeactivate();
		act.onActivate();
		Test.stopTest();

		nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest('E_Sign_Live_Esignature', '1.0', null);
		nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();

		verifyPluginConfigurationsInstalled();
		System.assert(locator.locate(request, nFUSE.eSignatureService.class) instanceof ESignLiveESignature.EsignLiveService);
	}

	@isTest
	private static void testActivation_onDeactivate_deregisterBean() {
		Test.startTest();
		ESignLiveESignature act = new ESignLiveESignature();
		act.onActivate();
		act.onDeactivate();
		Test.stopTest();

		nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest('E_Sign_Live_Esignature', '1.0', null);
		nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();

		verifyPluginConfigurationsInstalled();
		try{
			locator.locate(request, nFUSE.eSignatureService.class);
			System.assert(false);
		} catch(Exception e) {
			System.assert(true);
		}
	}

	@isTest
	private static void testActivation_onActivate_installConfiguration() {
		Test.startTest();
		new ESignLiveESignature().onActivate();
		Test.stopTest();
		
		verifyPluginConfigurationsInstalled();
	}

	@isTest
	private static void testActivation_onActivateTwice_installConfiguration() {
		Test.startTest();
		ESignLiveESignature act = new ESignLiveESignature();
		act.onActivate();
		act.onDeactivate();
		act.onActivate();
		Test.stopTest();

		verifyPluginConfigurationsInstalled();
	}

	@isTest
	private static void testEsignatureServiceSetsStatus() {
		ESignLiveESignature act = new ESignLiveESignature();
		act.onActivate();
		MiddlewareMessageMock message = new MiddlewareMessageMock();
		ESignLiveESignature.EsignLiveService service = new ESignLiveESignature.EsignLiveService();

		Test.startTest();
		service.preSendSeam(message);
		Test.stopTest();

		System.assertEquals(null, message.properties.get(ESignLiveESignature.STATUS_SIGNED_KEY));
		System.assertEquals('E-Signature Exception', message.properties.get(ESignLiveESignature.STATUS_EXCEPTION_KEY));
		System.assertEquals('E-signature Needed', message.properties.get(ESignLiveESignature.STATUS_SUCCESSFUL_CANCELLATION_KEY));

	}

	private static void removeValueFromList(List<Object> theList, Object theValue) {
		for(Integer i = 0; i < theList.size(); i++) {
			if(theList.get(i) == theValue) {
				theList.remove(i);
				return;
			}
		}
	}

	private static void verifyPluginConfigurationsInstalled(){
		nFUSE.PluginConfigurationManager configManager = new nFUSE.PluginConfigurationManager(ESignLiveESignature.PLUGIN_NAME, ESignLiveESignature.PLUGIN_VERSION);
		List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs = configManager.getConfigurations();

		List<String> keysToCheck = expectedProperties.clone();
		System.assertEquals(4, keysToCheck.size());
		for(nFUSE.PluginConfigurationManager.PluginConfiguration currentConfig : configs) {
			removeValueFromList(keysToCheck, currentConfig.key);
		}
		System.assertEquals(0, keysToCheck.size());
	}

	private class MiddlewareMessageMock extends nFUSE.AMiddlewareMessage {
		public MiddlewareMessageMock(){}

		public MiddlewareMessageMock putProperty(String key, String value){
			this.properties.put(key, value);
			return this;
		}
	}

	private static List<String> expectedProperties = new List<String> {
		ESignLiveESignature.SYS_PROP_KEY_API_KEY,
		ESignLiveESignature.SYS_PROP_KEY_E_SIGNATURE_VENDOR,
		ESignLiveESignature.SYS_PROP_KEY_E_SIGNATURE_ENABLED,
		ESignLiveESignature.SYS_PROP_KEY_ESIGNLIVE_ENVIRONMENT
	};

}
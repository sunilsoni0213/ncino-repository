@isTest
public with sharing class TestIdologyVerification{

	@testSetup
	static void setup() {
		nFORCE.SystemProperties systemProperties = nFORCE.SystemProperties.getInstance();
		nFORCE__System_Properties__c prop_name = nFORCE.SystemProperties.createProperty(
			EID_PLUGIN_CATEGORY,
			EID_PLUGIN_KEY_NAME,
			null,
			true);

		nFORCE.DmlUtility.insertObj(prop_name);

		nFORCE__System_Properties__c prop_verison = nFORCE.SystemProperties.createProperty(
			EID_PLUGIN_CATEGORY,
			EID_PLUGIN_KEY_VERSION,
			null,
			true);

		nFORCE.DmlUtility.insertObj(prop_verison);
	}

	@isTest
	private static void testActivationOnActivateRegisterBean() {
		Test.startTest();
		new IdologyVerification.IdologyVerificationActivator().onActivate();
		Test.stopTest();

		nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(EID_PLUGIN_NAME, EID_PLUGIN_VERSION, null);
		nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();

		System.assert(locator.locate(request, nFUSE.SendService.class) instanceof IdologyVerification.IdologyVerificationSendService);
	}

	@isTest
	private static void testActivationOnDeactivateDeregisterBean() {
		Test.startTest();
		IdologyVerification.IdologyVerificationActivator act = new IdologyVerification.IdologyVerificationActivator();
		act.onActivate();
		act.onDeactivate();
		Test.stopTest();

		nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(EID_PLUGIN_NAME, EID_PLUGIN_VERSION, null);
		nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();

		Boolean expectedExceptionThrown;

		try {
			locator.locate(request, nFUSE.SendService.class);
		} catch(Exception e) {
			expectedExceptionThrown =  e.getMessage().contains('Unable to locate service for Idology_Verification.1.0:nFUSE.SendService in nFUSE.ServiceLocator.BeanRegistrySource') ? true : false;
		}

		nFORCE.SystemProperties systemProperties = nFORCE.SystemProperties.getInstance();
		String propName = systemProperties.getProperty(EID_PLUGIN_CATEGORY, EID_PLUGIN_KEY_NAME);
		String propVersion = systemProperties.getProperty(EID_PLUGIN_CATEGORY, EID_PLUGIN_KEY_VERSION);

		System.assertEquals(propName, null);
		System.assertEquals(propVersion, null);
		System.AssertEquals(expectedExceptionThrown, true);
	}

	@isTest
	private static void testDeactivateNullProperties() {

		Test.startTest();
		IdologyVerification.IdologyVerificationActivator act = new IdologyVerification.IdologyVerificationActivator();
		act.onActivate();
		act.onDeactivate();
		Test.stopTest();

		nFORCE.SystemProperties systemProperties = nFORCE.SystemProperties.getInstance();

		String propName = systemProperties.getProperty(EID_PLUGIN_CATEGORY, EID_PLUGIN_KEY_NAME);
		String propVersion = systemProperties.getProperty(EID_PLUGIN_CATEGORY, EID_PLUGIN_KEY_VERSION);
		
		System.assertEquals(null, propName);
		System.assertEquals(null, propVersion);
	}

	@isTest
	private static void testActivationOnActivateInstallConfiguration() {
		Test.startTest();
		new IdologyVerification.IdologyVerificationActivator().onActivate();
		Test.stopTest();

		List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs = new nFUSE.PluginConfigurationManager(EID_PLUGIN_NAME, EID_PLUGIN_VERSION).getConfigurations();

		System.assertEquals(3, configs.size());
		System.assertEquals(EID_PLUGIN_CONFIGURATION, configs[0].category);
	}

	@isTest
	private static void testUpdateProperty() {
		Test.startTest();
		new IdologyVerification.IdologyVerificationActivator().updateProperty(EID_PLUGIN_KEY_NAME, 'asdf', EID_PLUGIN_CATEGORY);
		new IdologyVerification.IdologyVerificationActivator().updateProperty(EID_PLUGIN_KEY_VERSION, '1.1', EID_PLUGIN_CATEGORY);
		Test.stopTest();
		
		nFORCE.SystemProperties systemProperties = nFORCE.SystemProperties.getInstance();

		String propName = systemProperties.getProperty(EID_PLUGIN_CATEGORY, EID_PLUGIN_KEY_NAME);
		String propVersion = systemProperties.getProperty(EID_PLUGIN_CATEGORY, EID_PLUGIN_KEY_VERSION);
		
		System.assertEquals('asdf', propName);
		System.assertEquals('1.1', propVersion);
	}

	@isTest
	private static void testAddPluginConfigs() {
		Test.startTest();
		new IdologyVerification.IdologyVerificationActivator().addPluginConfigs();
		Test.stopTest();

		List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs = new nFUSE.PluginConfigurationManager(EID_PLUGIN_NAME, EID_PLUGIN_VERSION).getConfigurations();

		System.assertEquals(configs.size(), 3);
	}

	private static final String
		EID_PLUGIN_NAME = IdologyVerification.PLUGIN_NAME,
		EID_PLUGIN_KEY_NAME = IdologyVerification.PLUGIN_CONFIG_NAME,
		EID_PLUGIN_VERSION = IdologyVerification.PLUGIN_VERSION,
		EID_PLUGIN_KEY_VERSION = IdologyVerification.PLUGIN_CONFIG_VERSION,
		EID_PLUGIN_CATEGORY = IdologyVerification.PLUGIN_CONFIG_CATEGORY,
		EID_PLUGIN_KEY_USERNAME = IdologyVerification.SYS_PROP_KEY_USERNAME,
		EID_PLUGIN_KEY_PASSWORD = IdologyVerification.SYS_PROP_KEY_PASSWORD,
		EID_PLUGIN_KEY_ENVIRONMENT = IdologyVerification.SYS_PROP_KEY_ENVIRONMENT,
		EID_PLUGIN_CONFIGURATION = EID_PLUGIN_NAME + 'Configuration';
}
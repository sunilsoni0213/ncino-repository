@isTest
public with sharing class TestPrecisionLenderPricingController {

	@testSetup
	static void setup() {
		new nFUSE.DataInstaller().onInstall(null);
		List<SObject> toInsert = new List<SObject>();
		nFORCE__System_Properties__c propName = new nFORCE__System_Properties__c(
			Name = PrecisionLender.PLUGIN_CONFIG_NAME,
			nFORCE__Category_Name__c = PrecisionLender.PLUGIN_CONFIG_CATEGORY,
			nFORCE__Key__c = PrecisionLender.PLUGIN_CONFIG_NAME,
			nFORCE__Value__c = null,
			nFORCE__Is_Active__c = true
		);
		toInsert.add(propName);

		nFORCE__System_Properties__c propVersion = new nFORCE__System_Properties__c(
			Name = PrecisionLender.PLUGIN_CONFIG_VERSION,
			nFORCE__Category_Name__c = PrecisionLender.PLUGIN_CONFIG_CATEGORY,
			nFORCE__Key__c = PrecisionLender.PLUGIN_CONFIG_VERSION,
			nFORCE__Value__c = null,
			nFORCE__Is_Active__c = true
		);
		toInsert.add(propVersion);

		insert toInsert;

		nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(
			PrecisionLender.PLUGIN_NAME, PrecisionLender.PLUGIN_VERSION, null);
		nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
		locator.register(request, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class);
	}

	@isTest
	public static void testInitiatePricingAccount() {
		setupClientID();
		Account testAccount = new Account();
		testAccount.Name = 'TestAccount0001';
		testAccount.LLC_BI__lookupKey__c = TEST_ACCOUNT_LOOKUP;
		insert testAccount;

		ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
		PrecisionLenderPricingController plpc = new PrecisionLenderPricingController(sc);
		Test.startTest();
		nFUSE.MiddlewareMessage message = plpc.priceScenario();
		Test.stopTest();

		System.assert(!((List<Object>)message.properties.get(PrecisionLender.RELATIONSHIPS_CONST)).isEmpty());
		System.assertNotEquals(null, message);
		System.assertEquals('TestAccount0001', message.properties.get(PrecisionLender.SCENARIO_CONST));
		System.assertEquals(PrecisionLender.ACTION_PRICING, message.messageHeader.action);
		System.assertEquals(EncodingUtil.convertToHex(Crypto.generateDigest('MD5',
			Blob.valueOf(testAccount.LLC_BI__lookupKey__c + UNENCRYPTED_CLIENT_ID))),
			message.properties.get(PrecisionLender.PROD_EXT_REL_ID));
	}

	@isTest
	public static void testInitiatePricingOpportunity() {
		setupClientID();
		Account testAccount = new Account();
		testAccount.Name = 'TestAccount0001';
		testAccount.LLC_BI__lookupKey__c = TEST_ACCOUNT_LOOKUP;
		insert testAccount;

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'TestOpportunity0001';
		testOpp.StageName = 'Qualification';
		testOpp.CloseDate = Date.Today();
		testOpp.AccountId = testAccount.Id;
		insert testOpp;

		ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);
		PrecisionLenderPricingController plpc = new PrecisionLenderPricingController(sc);
		Test.startTest();
		nFUSE.MiddlewareMessage message = plpc.priceScenario();
		Test.stopTest();

		System.assert(!((List<Object>)message.properties.get(PrecisionLender.RELATIONSHIPS_CONST)).isEmpty());
		System.assertNotEquals(null, message);
		System.assertEquals('TestOpportunity0001', message.properties.get(PrecisionLender.SCENARIO_CONST));
		System.assertEquals(PrecisionLender.ACTION_PRICING, message.messageHeader.action);
		System.assertEquals(EncodingUtil.convertToHex(Crypto.generateDigest('MD5',
			Blob.valueOf(testAccount.LLC_BI__lookupKey__c + UNENCRYPTED_CLIENT_ID))),
			message.properties.get(PrecisionLender.PROD_EXT_REL_ID));
	}

	@isTest
	public static void testGetUnencryptedClientID() {
		setupClientID();
		String hashClientId = PrecisionLenderPricingController.getUnencryptedClientID();
		System.assertEquals(UNENCRYPTED_CLIENT_ID, hashClientId);
	}

	@isTest
	public static void testGetUnencryptedClientIDNoId() {
		String hashClientId = PrecisionLenderPricingController.getUnencryptedClientID();
		System.assertEquals(null, hashClientId);
	}

	private static void setupClientID() {
		nFUSE.PluginConfigurationManager.PluginConfiguration configClientId = new nFUSE.PluginConfigurationManager.PluginConfiguration();
		configClientId.pluginName = PrecisionLender.PLUGIN_NAME;
		configClientId.pluginVersion = PrecisionLender.PLUGIN_VERSION;
		configClientId.category = PrecisionLender.PLUGIN_NAME;
		configClientId.key = PrecisionLender.CONFIG_PROP_KEY_CLIENT_ID;
		configClientId.valueDataType = 'String';
		configClientId.value = UNENCRYPTED_CLIENT_ID;
		configClientId.isEncrypted = true;

		List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs =
			new List<nFUSE.PluginConfigurationManager.PluginConfiguration>{ configClientId };
		new nFUSE.PluginConfigurationManager(PrecisionLender.PLUGIN_NAME, PrecisionLender.PLUGIN_VERSION).softInsertConfigurations(configs);
	}

	private static final String
		TEST_ACCOUNT_LOOKUP = 'plintegrationtest1234',
		UNENCRYPTED_CLIENT_ID = '028aa291-4d03-4238-b04b-f4b85434b7ac';
}
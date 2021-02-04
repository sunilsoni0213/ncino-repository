@isTest
public with sharing class TestPrecisionLender {

	@testSetup
	static void setup() {
		nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
			PrecisionLender.PLUGIN_NAME,
			PrecisionLender.PLUGIN_VERSION,
			null
		);
		nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
		locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class);
	}

	@isTest
	private static void testOnActivateInstallConfiguration() {
		Test.startTest();
		new PrecisionLender.Activator().onActivate();
		Test.stopTest();

		List<nFORCE__System_Properties__c> installedProperties = [
			SELECT
				Id
			FROM
				nFORCE__System_Properties__c
			WHERE
				nFORCE__Category_Name__c = :PrecisionLender.PLUGIN_CONFIG_CATEGORY
			AND
				(nFORCE__Key__c = :PrecisionLender.PLUGIN_CONFIG_VERSION OR nFORCE__Key__c = :PrecisionLender.PLUGIN_CONFIG_NAME)
			AND
				nFORCE__Is_Active__c = true
		];
		List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs = new nFUSE.PluginConfigurationManager(PrecisionLender.PLUGIN_NAME, PrecisionLender.PLUGIN_VERSION).getConfigurations();

		System.assertEquals(installedProperties.size(), 2);
		System.assertEquals(6, configs.size());
		System.assertEquals(PrecisionLender.PLUGIN_NAME+'Configuration', configs[0].category);
	}
	@isTest
	private static void testActivation_onDeactivate() {
		nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
		nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(
			PrecisionLender.PLUGIN_NAME,
			PrecisionLender.PLUGIN_VERSION,
			null
		);

		new PrecisionLender.Activator().onActivate();
		System.assertNotEquals(locator.locate(request, nFUSE.SendService.class), null);

		Test.startTest();
		new PrecisionLender.Activator().onDeactivate();
		Test.stopTest();

		try {
			locator.locate(request, nFUSE.SendService.class);
			System.assert(false);
		} catch (Exception e) {
			System.assert(true);
		}
	}

	@isTest
	public static void testGetPluginSendService() {
		nFUSE.TestEnvironment.getInstance().registerAcmeIdVerificationPlugin(
			PrecisionLender.PLUGIN_NAME,
			true,
			PrecisionLender.PLUGIN_NAME + PrecisionLender.PLUGIN_VERSION,
			nFUSE.TestServices.SendServiceMock.class
		);
		nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(PrecisionLender.PLUGIN_NAME, PrecisionLender.PLUGIN_VERSION, null);

		nFUSE.SendService send = PrecisionLender.getPluginSendService(servRequest);

		System.assertNotEquals(null, send);
		System.assertEquals(true, send instanceof nFUSE.TestServices.SendServiceMock);
	}

	@isTest
	public static void testBeforeInsertLoanSeam() {
		Account acct = new Account(
			Name = 'Test Account'
		);

		insert acct;

		LLC_BI__Loan__c testLoan = new LLC_BI__Loan__c(
			LLC_BI__Product_Line__c = 'Test Product 1',
			LLC_BI__Product_Type__c = 'Test Product Type 1',
			LLC_BI__Product__c = 'Test Product',
			LLC_BI__Account__c = acct.Id);

		insert testLoan;

		List<LLC_BI__Loan__c> listLoans = new List<LLC_BI__Loan__c>();
		listLoans.add(testLoan);

		Test.startTest();
		PrecisionLender.PLLoanService pl = new PrecisionLender.PLLoanService();
		listLoans = pl.beforeInsertLoanSeam(listLoans);
		Test.stopTest();

		System.assertEquals(listLoans[0].Name, 'Test Account Test Product Type 1 Test Product');
	}

	@isTest
	public static void testBeforeInsertProductPackageSeam() {
		LLC_BI__Product_Package__c pp = new LLC_BI__Product_Package__c(
			Name = 'Test Product Package');

		List<LLC_BI__Product_Package__c> productPackages = new List<LLC_BI__Product_Package__c>();
		productPackages.add(pp);

		PrecisionLender.PLProductPackageService pl = new PrecisionLender.PLProductPackageService();

		Test.startTest();
		productPackages = pl.beforeInsertProductPackageSeam(productPackages);
		Test.stopTest();

		System.assertEquals(productPackages[0].Name, 'Test Product Package Product Package');
	}

	@isTest
	public static void testPreSendSeam() {
		new PrecisionLender.Activator().onActivate();
		nFUSE.MiddlewareMessage msg = new nFUSE.MiddlewareMessage();

		PrecisionLender.PLSendService plSendService = new PrecisionLender.PLSendService();

		Test.startTest();
		nFUSE.AMiddlewareMessage theMessage = plSendService.preSendSeam(msg);
		Test.stopTest();

		System.assertEquals(theMessage.properties.size(), 6);
		System.assert(theMessage.properties.containsKey(PrecisionLender.KEY_USERNAME));
		System.assert(theMessage.properties.containsKey(PrecisionLender.KEY_CLIENT_API_KEY));
		System.assert(theMessage.properties.containsKey(PrecisionLender.KEY_CLIENT_ID));
		System.assert(theMessage.properties.containsKey(PrecisionLender.KEY_URL));
		System.assert(theMessage.properties.containsKey(PrecisionLender.KEY_HOST_ENVIRONMENT));
		System.assert(theMessage.properties.containsKey(PrecisionLender.KEY_CLIENT_SERVICE_USERNAME));
	}
}
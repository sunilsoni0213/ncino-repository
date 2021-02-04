@IsTest
public with sharing class TestPrecisionLenderRepricingController {
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

		nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
			PrecisionLender.PLUGIN_NAME, PrecisionLender.PLUGIN_VERSION, null);
		nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
		locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class);
	}
	@IsTest
	public static void testRepriceLoan() {
		Account testAccount = new Account(
			Name = 'TestAccount0001',
			LLC_BI__lookupKey__c = '1234'
		);
		insert testAccount;

		LLC_BI__Loan__c testLoan = new LLC_BI__Loan__c(
			Name = 'Test Loan',
			LLC_BI__Amount__c = 10000,
			LLC_BI__Account__c = testAccount.Id
		);
		insert testLoan;

		LLC_BI__External_Application_Lookup__c newExtApp = new LLC_BI__External_Application_Lookup__c();
		newExtApp.LLC_BI__Context_Id__c = String.valueOf(testLoan.Id);
		newExtApp.LLC_BI__External_Id__c = 'FakeExternalId1';
		newExtApp.Name = PrecisionLender.PLUGIN_NAME + PrecisionLender.LOAN_SUFFIX;
		insert newExtApp;

		LLC_BI__External_Application_Lookup__c newExtApp2 = new LLC_BI__External_Application_Lookup__c();
		newExtApp2.LLC_BI__Context_Id__c = String.valueOf(testLoan.Id);
		newExtApp2.LLC_BI__External_Id__c = 'FakeExternalId2';
		newExtApp2.Name = PrecisionLender.PLUGIN_NAME + PrecisionLender.OPP_SUFFIX;
		insert newExtApp2;

		ApexPages.StandardController sc = new ApexPages.StandardController(testLoan);

		Test.startTest();
		nFUSE.MiddlewareMessage testMSG = PrecisionLenderRepricingController.repriceLoan((String)testLoan.Id);
		Test.stopTest();

		LLC_BI__Loan__c loaner = (LLC_BI__Loan__c)((nFORCE.IForce)testMSG.properties.get('loanKey')).getDbObject();
		System.assertNotEquals(null, testMSG.properties.get('loanKey'));
		System.assertNotEquals(null, PrecisionLender.PROD_EXT_REL_ID);
		System.assertEquals(testLoan.Id, loaner.Id);
		System.assertEquals(testLoan.Name, loaner.Name);
		System.assertEquals(newExtApp.LLC_BI__External_Id__c, testMSG.properties.get(PrecisionLender.EXT_LOAN_KEY));
		System.assertEquals(newExtApp2.LLC_BI__External_Id__c, testMSG.properties.get(PrecisionLender.EXT_OPP_KEY));
	}
}
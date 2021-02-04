@IsTest
public with sharing class TestPrecisionLenderTriggerHandler {

	@TestSetup
	static void setup() {
		new nFUSE.DataInstaller().onInstall(null);
		nFUSE.PackageServiceRequest servRequest = new nFUSE.PackageServiceRequest(
			PrecisionLender.PLUGIN_NAME,
			PrecisionLender.PLUGIN_VERSION,
			null
		);
		nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
		locator.register(servRequest, nFUSE.SendService.class, nFUSE.TestServices.SendServiceMock.class);
	}

	@IsTest
	private static void testInitiateRenewModify() {
		List<SObject> toInsert = new List<SObject>();
		LLC_BI__Loan__c testLoan = new LLC_BI__Loan__c(
			Name = 'Test Loan',
			LLC_BI__Amount__c = 10000
		);
		toInsert.add(testLoan);
		LLC_BI__Loan__c testLoan2 = new LLC_BI__Loan__c(
			Name = 'Test Loan2',
			LLC_BI__Amount__c = 10000,
			LLC_BI__isRenewal__c = true
		);
		toInsert.add(testLoan2);
		insert toInsert;

		List<SObject> toInsert2 = new List<SObject>();
		LLC_BI__External_Application_Lookup__c extLoanApp = new LLC_BI__External_Application_Lookup__c();
		extLoanApp.LLC_BI__Context_Id__c = String.valueOf(testLoan.Id);
		extLoanApp.LLC_BI__External_Id__c = 'FakeExternalId';
		extLoanApp.Name = PrecisionLender.PLUGIN_NAME + PrecisionLender.LOAN_SUFFIX;
		toInsert2.add(extLoanApp);

		LLC_BI__External_Application_Lookup__c extOppApp = new LLC_BI__External_Application_Lookup__c();
		extOppApp.LLC_BI__Context_Id__c = String.valueOf(testLoan.Id);
		extOppApp.LLC_BI__External_Id__c = 'FakeExternalId2';
		extOppApp.Name = PrecisionLender.PLUGIN_NAME + PrecisionLender.OPP_SUFFIX;
		toInsert2.add(extOppApp);
		insert toInsert2;

		Map<String, String> oppMap = new Map <String, String>();
		oppMap.put(extOppApp.LLC_BI__Context_Id__c, extOppApp.LLC_BI__External_Id__c);
		Map<String, String> loanMap = new Map <String, String>();
		loanMap.put(extLoanApp.LLC_BI__Context_Id__c, extLoanApp.LLC_BI__External_Id__c);

		LLC_BI__LoanRenewal__c lr = new LLC_BI__LoanRenewal__c(
			LLC_BI__ParentLoanId__c = testLoan.Id,
			LLC_BI__RootLoanId__c = testLoan.Id,
			LLC_BI__PreviousVersionStatus__c = 't0',
			LLC_BI__PreviousVersionStage__c = 't1',
			LLC_BI__RevisionStatus__c = 't2'
		);
		insert lr;
		lr.LLC_BI__RenewalLoanId__c = testLoan2.Id;
		update lr;

		Map<String, Id> originalRenewalMap = new Map<String, Id>();
		originalRenewalMap.put(testLoan.Id, testLoan2.Id);
		Test.startTest();
		nFUSE.TestServices.SendServiceMock mockSender = (nFUSE.TestServices.SendServiceMock)PrecisionLenderTriggerHandler.initiateRenewModify(loanMap, oppMap, originalRenewalMap);
		Test.stopTest();

		List<nFUSE.AMiddlewareMessage> sentMessages = mockSender.getSentMessages();
		List<Map<String, Object>> renewalInfoList = (List<Map<String, Object>>)sentMessages[0].properties.get(PrecisionLender.PROP_REN_MOD_LOANS);

		System.assertEquals(1, sentMessages.size());
		System.assertEquals(PrecisionLender.ACTION_REN_MOD_LOANS, sentMessages[0].messageHeader.action);
		System.assertEquals(testLoan2.Id, renewalInfoList[0].get(PrecisionLender.PROP_RENEWAL_ID));
		System.assertEquals(extLoanApp.LLC_BI__External_Id__c, renewalInfoList[0].get(PrecisionLender.EXT_LOAN_KEY));
		System.assertEquals(extOppApp.LLC_BI__External_Id__c, renewalInfoList[0].get(PrecisionLender.EXT_OPP_KEY));
		System.assertEquals(null, renewalInfoList[0].get(PrecisionLender.PROD_EXT_REL_ID));
		System.assertNotEquals(null, renewalInfoList);
	}
}
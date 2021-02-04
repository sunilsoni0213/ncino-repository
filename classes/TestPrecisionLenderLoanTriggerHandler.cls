@IsTest
public with sharing class TestPrecisionLenderLoanTriggerHandler {
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
	private static void testStatusStageUpdate() {
		List<LLC_BI__Loan__c> toInsert = new List<SObject>();
		LLC_BI__Loan__c testLoan = new LLC_BI__Loan__c(
			Name = 'Test Loan',
			LLC_BI__Amount__c = 10000,
			LLC_BI__Stage__c = 'stage1x',
			LLC_BI__Status__c = 'status1x'
		);
		toInsert.add(testLoan);
		LLC_BI__Loan__c testLoan2 = new LLC_BI__Loan__c(
			Name = 'Test Loan2',
			LLC_BI__Amount__c = 10000,
			LLC_BI__isRenewal__c = true,
			LLC_BI__Stage__c = 'stage1y',
			LLC_BI__Status__c = 'status1y'
		);
		toInsert.add(testLoan2);
		insert toInsert;

		List<LLC_BI__External_Application_Lookup__c> toInsertExtApps = new List<SObject>();

		LLC_BI__External_Application_Lookup__c extLoanApp = new LLC_BI__External_Application_Lookup__c();
		extLoanApp.LLC_BI__Context_Id__c = String.valueOf(testLoan2.Id);
		extLoanApp.LLC_BI__External_Id__c = 'FakeExternalId1';
		extLoanApp.Name = PrecisionLender.PLUGIN_NAME + PrecisionLender.LOAN_SUFFIX;
		toInsertExtApps.add(extLoanApp);

		LLC_BI__External_Application_Lookup__c extOppApp = new LLC_BI__External_Application_Lookup__c();
		extOppApp.LLC_BI__Context_Id__c = String.valueOf(testLoan2.Id);
		extOppApp.LLC_BI__External_Id__c = 'FakeExternalId2';
		extOppApp.Name = PrecisionLender.PLUGIN_NAME + PrecisionLender.OPP_SUFFIX;
		toInsertExtApps.add(extOppApp);

		insert toInsertExtApps;

		Map<String, String> extOppMap = new Map <String, String>();
		extOppMap.put(extOppApp.LLC_BI__Context_Id__c, extOppApp.LLC_BI__External_Id__c);
		Map<String, String> extLoanMap = new Map <String, String>();
		extLoanMap.put(extLoanApp.LLC_BI__Context_Id__c, extLoanApp.LLC_BI__External_Id__c);

		testLoan2.LLC_BI__Status__c = 'updateStatus';
		update testLoan2;

		Test.startTest();
		nFUSE.TestServices.SendServiceMock mockSender = (nFUSE.TestServices.SendServiceMock)PrecisionLenderLoanTriggerHandler.initiateStageStatusUpdate(extOppMap, extLoanMap, JSON.serialize(toInsert));
		Test.stopTest();

		List<nFUSE.AMiddlewareMessage> sentMessages = mockSender.getSentMessages();

		Map<String, Object> loanMap = (Map<String, Object>) (((List<Object>)sentMessages[0].properties.get(PrecisionLender.KEY_UPDATED_LOANS))[0]);
		System.assertEquals(1, sentMessages.size());
		System.assertEquals(sentMessages[0].messageHeader.action, PrecisionLender.ACTION_STAGE_STATUS_UPDATE);
		System.assertEquals(loanMap.get('PrecisionLenderLoanId'), extLoanApp.LLC_BI__External_Id__c);
		System.assertEquals(loanMap.get('PrecisionLenderOpportunityId'), extOppApp.LLC_BI__External_Id__c);
		System.assertEquals(loanMap.get('newStage'), 'stage1y');
		System.assertEquals(loanMap.get('newStatus'), 'updateStatus');
	}
}
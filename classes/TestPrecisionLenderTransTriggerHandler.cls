@IsTest
public with sharing class TestPrecisionLenderTransTriggerHandler {
	@IsTest
	private static void testCreateExternalAppOnUpdate() {
		new PrecisionLender.Activator().onActivate();

		nFUSE__Transaction_Log__c testLog = new nFUSE__Transaction_Log__c();
		testLog.Name = 'Can You See John Cena?';
		testLog.nFUSE__Action__c = 'testAction';
		testLog.nFUSE__Api_Version__c = '1.0';
		testLog.nFUSE__App_Plugin__c = PrecisionLender.PLUGIN_NAME;
		testLog.nFUSE__External_Id__c = 'EXTID';
		testLog.nFUSE__Primary_Object_Id__c = 'fakeId';
		testLog.nFUSE__Transaction_Status__c = 'Done';
		testLog.nFUSE__Vendor_Status__c = 'Pricing Complete';
		testLog.nFUSE__Requested_By_User_Id__c = 'fakeUserId';
		insert testLog;

		Test.startTest();
		testLog.nFUSE__Transaction_Detail__c = '{"PrecisionLenderPricingId": "238f2858-d5b5-4d1b-8057-8ec59a119739","ProductPackageId": "a3Q1I000000LEM0UAO","PricingURL": "https://application.precisionlender.com/price/opportunity/#/238f2858-d5b5-4d1b-8057-8ec59a119739","vendorStatus": "Pricing Complete","ListLoans": [{"ExtLoan": "aee48f2b-a080-4a20-9745-7377050adeaV","ExtOpp": "aee48f2b-a080-4a20-9745-7377050adea5","Sf": "a0U1I0000005FZkUAM"},{"ExtLoan": "aee48f2b-a080-4a20-9745-7377050adeaW","ExtOpp": "511d9248-ebb7-4bd3-8a21-d5319b45c10b","Sf": "b0U1I0000005FZpUAM"},{"ExtLoan": "aee48f2b-a080-4a20-9745-7377050adeaX","ExtOpp": "0c2de093-7906-4244-9ebd-bd854cdc04ad","Sf":"c0U1I0000005FZuUAM"},{"ExtLoan": "aee48f2b-a080-4a20-9745-7377050adeaY","ExtOpp": "b90e3351-cabc-4dec-9418-1117032c923b","Sf": "d0U1I0000005FZzUAM"},{"ExtLoan": "aee48f2b-a080-4a20-9745-7377050adeaZ","ExtOpp": "a1e1257a-4463-4062-beab-249213753fda","Sf": "e0U1I0000005Fa4UAE"}]}';
		update testLog;
		Test.stopTest();

		List<LLC_BI__External_Application_Lookup__c> externalOppApps = [
			SELECT
				Id,
				Name,
				LLC_BI__Context_Id__c,
				LLC_BI__External_Id__c
			FROM
				LLC_BI__External_Application_Lookup__c
			WHERE
				Name = :PrecisionLender.PLUGIN_NAME + PrecisionLender.OPP_SUFFIX
			ORDER BY
				LLC_BI__Context_Id__c ASC
		];

		List<LLC_BI__External_Application_Lookup__c> externalLoanApps = [
			SELECT
				Id,
				Name,
				LLC_BI__Context_Id__c,
				LLC_BI__External_Id__c
			FROM
				LLC_BI__External_Application_Lookup__c
			WHERE
				Name = :PrecisionLender.PLUGIN_NAME + PrecisionLender.LOAN_SUFFIX
			ORDER BY
				LLC_BI__Context_Id__c ASC
		];

		System.assertEquals(5, externalOppApps.size());
		System.assertEquals(5, externalLoanApps.size());
		System.assertEquals('aee48f2b-a080-4a20-9745-7377050adea5', externalOppApps[0].LLC_BI__External_Id__c);
		System.assertEquals('511d9248-ebb7-4bd3-8a21-d5319b45c10b', externalOppApps[1].LLC_BI__External_Id__c);
		System.assertEquals('0c2de093-7906-4244-9ebd-bd854cdc04ad', externalOppApps[2].LLC_BI__External_Id__c);
		System.assertEquals('b90e3351-cabc-4dec-9418-1117032c923b', externalOppApps[3].LLC_BI__External_Id__c);
		System.assertEquals('a1e1257a-4463-4062-beab-249213753fda', externalOppApps[4].LLC_BI__External_Id__c);

		System.assertEquals('aee48f2b-a080-4a20-9745-7377050adeaV', externalLoanApps[0].LLC_BI__External_Id__c);
		System.assertEquals('aee48f2b-a080-4a20-9745-7377050adeaW', externalLoanApps[1].LLC_BI__External_Id__c);
		System.assertEquals('aee48f2b-a080-4a20-9745-7377050adeaX', externalLoanApps[2].LLC_BI__External_Id__c);
		System.assertEquals('aee48f2b-a080-4a20-9745-7377050adeaY', externalLoanApps[3].LLC_BI__External_Id__c);
		System.assertEquals('aee48f2b-a080-4a20-9745-7377050adeaZ', externalLoanApps[4].LLC_BI__External_Id__c);
	}

}
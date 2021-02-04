@isTest
private class FeeLoaderTest {

    static testMethod void testLoadFeeSystemProperties() {
		FeeLoader fl = new FeeLoader();
		Test.StartTest();
		fl.loadFeeSystemProperties();
		
		List<LLC_BI__System_Properties__c> fees = 
		[
			SELECT
				LLC_BI__Category_Name__c,
				LLC_BI__Is_Active__c,
				LLC_BI__Key__c,
				LLC_BI__Value__c,
				Name		
			FROM
				LLC_BI__System_Properties__c
			WHERE
				LLC_BI__Category_Name__c = 'Fees'
		];
		system.assertEquals(23, fees.size());
		Test.StopTest();
	}
}
@IsTest
public with sharing class TestAPrecisionLenderController {
	@IsTest
	public static void testGetLogDetails() {
		nFUSE__Transaction_Log__c log = new nFUSE__Transaction_Log__c();
		log.nFUSE__External_Id__c = 'Hulk';
		log.nFUSE__API_Version__c = '1.0';
		log.nFUSE__Action__c = 'PL Request';
		log.nFUSE__Object_Id__c = 'Hogan';
		log.nFUSE__Primary_Object_Id__c = 'Brother';
		log.nFUSE__App_Plugin__c = 'PrecisionLender';
		log.nFUSE__Requesting_User_Id__c = 'userId123';
		log.nFUSE__Requested_By_User_Id__c = 'userId123';
		log.nFUSE__Transaction_Status__c = 'Success';
		log.nFUSE__Transaction_Detail__c = '{"Details Map" : "Brother"}';
		insert log;

		Map<String, Object> logDetails;

		Test.startTest();
		logDetails = APrecisionLenderController.getLogDetails((String)log.Id);
		Test.stopTest();

		System.assertEquals((String)logDetails.get('Details Map'), 'Brother');
	}
}
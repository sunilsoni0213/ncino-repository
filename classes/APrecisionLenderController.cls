global virtual with sharing class APrecisionLenderController {
	@TestVisible
	public ApexPages.StandardController controller;
	public String objectId { get; set; }
	public static nFUSE.SendService sendService;
	public static nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();

	private static nFUSE__Transaction_Log__c getTransactionLog(String id) {
		return [
			SELECT
				Id,
				nFUSE__External_Id__c,
				nFUSE__Vendor_Status__c,
				nFUSE__Transaction_Status__c,
				nFUSE__App_Plugin__c,
				nFUSE__Primary_Object_Id__c,
				nFUSE__Transaction_Detail__c
			FROM
				nFUSE__Transaction_Log__c
			WHERE
				nFUSE__External_Id__c =: id
			OR
				Id = :id
			LIMIT 1
		];
	}

	@RemoteAction
	global static Map<String, Object> getLogDetails(String id) {
		try {
			nFUSE__Transaction_Log__c log = getTransactionLog(id);
			return (Map<String, Object>) JSON.deserializeUntyped(log.nFUSE__Transaction_Detail__c);
		} catch (Exception e) {
			return null;
		}
	}
}
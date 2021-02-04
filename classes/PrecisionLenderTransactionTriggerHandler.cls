public with sharing class PrecisionLenderTransactionTriggerHandler {
	public void afterUpdate(List<sObject> newObjs, List<sObject> oldObjs, Set<Id> objIds) {
		List<nFUSE__Transaction_Log__c> newLogs = (List<nFUSE__Transaction_Log__c>) newObjs;
		List<nFUSE__Transaction_Log__c> oldLogs = (List<nFUSE__Transaction_Log__c>) oldObjs;
		List<nFUSE__Transaction_Log__c> relevantLogs = new List<nFUSE__Transaction_Log__c>();
		Set<String> contextIds = new Set<String>();
		Set<Map<String,Object>> newExtIdMap = new Set<Map<String,Object>>();
		for (Integer i = 0; i < newLogs.size(); i++) {
			if (newLogs[i].nFUSE__App_Plugin__c == PrecisionLender.PLUGIN_NAME && newLogs[i].nFUSE__Vendor_Status__c == VENDOR_PRICING_COMPLETE) {
				Map<String, Object> detailsMap;
				try {
					detailsMap = (Map<String, Object>) JSON.deserializeUntyped(newLogs[i].nFUSE__Transaction_Detail__c);
					List<Object> lister = (List<Object>)detailsMap.get(LOANS_KEY);
					for (Object obj : lister) {
						Map<String,Object> newIdMapper = (Map<String,Object>)obj;
						newExtIdMap.add(newIdMapper);
						contextIds.add((String)newIdMapper.get(INTERNAL_ID_KEY));
					}
				} catch (Exception ee) {
					continue;
				}
			}
		}

		if (!newExtIdMap.isEmpty()) {
			createExternalApplicationLookups(contextIds, newExtIdMap);
		}
	}

	private void createExternalApplicationLookups(Set<String> contextIds, Set<Map<String,Object>> newExtIdMap) {
		Set<String> existingExernalLoanApps = getExistingExternalApplications(contextIds, PrecisionLender.LOAN_SUFFIX);
		Set<String> existingExernalOppApps = getExistingExternalApplications(contextIds, PrecisionLender.OPP_SUFFIX);

		List<LLC_BI__External_Application_Lookup__c> toInsertApps = new List<LLC_BI__External_Application_Lookup__c>();

		for (Map<String, Object> detailMapper : newExtIdMap) {
			if (!existingExernalLoanApps.contains((String) detailMapper.get(INTERNAL_ID_KEY))) {
				LLC_BI__External_Application_Lookup__c newExtApp = new LLC_BI__External_Application_Lookup__c();
				newExtApp.LLC_BI__Context_Id__c = (String) detailMapper.get(INTERNAL_ID_KEY);
				newExtApp.LLC_BI__External_Id__c = (String) detailMapper.get(EXTERNAL_LOAN_ID_KEY);
				newExtApp.Name = PrecisionLender.PLUGIN_NAME + PrecisionLender.LOAN_SUFFIX;
				toInsertApps.add(newExtApp);
			}
			if (!existingExernalOppApps.contains((String) detailMapper.get(INTERNAL_ID_KEY))) {
				LLC_BI__External_Application_Lookup__c newExtApp = new LLC_BI__External_Application_Lookup__c();
				newExtApp.LLC_BI__Context_Id__c = (String) detailMapper.get(INTERNAL_ID_KEY);
				newExtApp.LLC_BI__External_Id__c = (String) detailMapper.get(EXTERNAL_OPP_ID_KEY);
				newExtApp.Name = PrecisionLender.PLUGIN_NAME + PrecisionLender.OPP_SUFFIX;
				toInsertApps.add(newExtApp);
			}
		}
		if (!toInsertApps.isEmpty()) {
			nFORCE.DmlUtility.insertObj(toInsertApps);
		}
	}

	private Set<String> getExistingExternalApplications(Set<String> idSet, String suffixString) {
		Set<String> existingStrings = new Set<String>();
		List<LLC_BI__External_Application_Lookup__c> existingExternalApps = [
			SELECT
				Id,
				Name,
				LLC_BI__Context_Id__c,
				LLC_BI__External_Id__c
			FROM
				LLC_BI__External_Application_Lookup__c
			WHERE
				Name = :PrecisionLender.PLUGIN_NAME + suffixString
			AND
				LLC_BI__Context_Id__c IN :idSet
		];

		for (LLC_BI__External_Application_Lookup__c extAL : existingExternalApps) {
			existingStrings.add(extAL.LLC_BI__Context_Id__c);
		}

		return existingStrings;
	}

	public static final String BEAN_NAME =
		nFORCE.BeanRegistry.getInstance().generateUniqueBeanName(
			LLC_BI.ATriggerHandler.class,
			'precision-lender-transaction-log-trigger-handler');
	public static final String
		VENDOR_PRICING_COMPLETE = 'Pricing Complete',
		LOANS_KEY = 'ListLoans',
		EXTERNAL_OPP_ID_KEY = 'ExtOpp',
		EXTERNAL_LOAN_ID_KEY = 'ExtLoan',
		INTERNAL_ID_KEY = 'Sf';
}
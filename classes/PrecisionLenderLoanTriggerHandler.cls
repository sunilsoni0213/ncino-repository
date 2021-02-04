global with sharing virtual class PrecisionLenderLoanTriggerHandler {

	public void afterUpdate(List<sObject> newObjs, List<sObject> oldObjs, Set<Id> objIds) {
		List<LLC_BI__Loan__c> newLoans = (List<LLC_BI__Loan__c>) newObjs;
		List<LLC_BI__Loan__c> oldLoans = (List<LLC_BI__Loan__c>) oldObjs;
		List<LLC_BI__Loan__c> loanList = new List<LLC_BI__Loan__c>();
		Map<String, String> oppIdMap = new Map<String, String>();
		Map<String, String> loanIdMap = new Map<String, String>();

		for (Integer i = 0; i < newLoans.size(); i++) {
			if (isStageStatusChange(newLoans[i], oldLoans[i])) {
				LLC_BI__Loan__c nl = new LLC_BI__Loan__c(
					Id = newLoans[i].Id,
					LLC_BI__Stage__c = newLoans[i].LLC_BI__Stage__c,
					LLC_BI__Status__c = newLoans[i].LLC_BI__Status__c);
				loanList.add(nl);
			}
		}

		List<LLC_BI__External_Application_Lookup__c> extApps = getExistingExternalApplications((new Map<Id, SObject>(loanList)).keySet());

		for (LLC_BI__External_Application_Lookup__c exApp : extApps) {
			if (exApp.Name == PrecisionLender.PLUGIN_NAME + PrecisionLender.LOAN_SUFFIX) {
				loanIdMap.put(exApp.LLC_BI__Context_Id__c, exApp.LLC_BI__External_Id__c);
			} else {
				oppIdMap.put(exApp.LLC_BI__Context_Id__c, exApp.LLC_BI__External_Id__c);
			}
		}

		if (!extApps.isEmpty()) {
			initiateStageStatusUpdateFuture(oppIdMap, loanIdMap, JSON.serialize(loanList));
		}
	}

	@Future(callout=true)
	public static void initiateStageStatusUpdateFuture(Map<String, String> oppIdMap, Map<String, String> loanIdMap, String loanList) {
		initiateStageStatusUpdate(oppIdMap, loanIdMap, loanList);
	}

	@TestVisible
	private static nFUSE.SendService initiateStageStatusUpdate(Map<String, String> oppIdMap, Map<String, String> loanIdMap, String loanList) {
		List<LLC_BI__Loan__c> sObList = (List<LLC_BI__Loan__c>)JSON.deserializeStrict(loanList, List<LLC_BI__Loan__c>.class);

		nFUSE.PackageServiceRequest req = new nFUSE.PackageServiceRequest(
			PrecisionLender.PLUGIN_NAME,
			PrecisionLender.PLUGIN_VERSION,
			null
		);
		req.primaryObjectId = sObList[0].Id;

		nFUSE.MiddlewareMessage msg = createMWMessage(oppIdMap, loanIdMap, sObList);
		nFUSE.SendService sender;
		sender = PrecisionLender.getPluginSendService(req);
		sender.send(req, msg);
		return sender;
	}

	private static nFUSE.MiddlewareMessage createMWMessage(Map<String, String> oppIdMap, Map<String, String> loanIdMap, List<LLC_BI__Loan__c> loanList) {
		List<Map<String, Object>> jsonBodyList = new List<Map<String, Object>>();

		for (LLC_BI__Loan__c loaner : loanList) {
			if (oppIdMap.containsKey((String)loaner.Id) && loanIdMap.containsKey((String)loaner.Id)) {
				Map<String, Object> stageStatusBodyMap = new Map<String, Object>();
				stageStatusBodyMap.put(PrecisionLender.EXT_LOAN_KEY, loanIdMap.get(loaner.Id));
				stageStatusBodyMap.put(PrecisionLender.EXT_OPP_KEY, oppIdMap.get(loaner.Id));
				stageStatusBodyMap.put(PrecisionLender.PROP_STAGE, loaner.LLC_BI__Stage__c);
				stageStatusBodyMap.put(PrecisionLender.PROP_STATUS, loaner.LLC_BI__Status__c);
				jsonBodyList.add(stageStatusBodyMap);
			}
		}

		nFUSE.MiddlewareMessage msg = new nFUSE.MiddlewareMessage();
		msg.messageHeader.action = PrecisionLender.ACTION_STAGE_STATUS_UPDATE;
		msg.properties.put(PrecisionLender.KEY_UPDATED_LOANS, jsonBodyList);
		return msg;
	}

	private List<LLC_BI__External_Application_Lookup__c> getExistingExternalApplications(Set<Id> idSet) {
		return [
			SELECT
				Id,
				Name,
				LLC_BI__Context_Id__c,
				LLC_BI__External_Id__c
			FROM
				LLC_BI__External_Application_Lookup__c
			WHERE
				(Name = :PrecisionLender.PLUGIN_NAME + PrecisionLender.LOAN_SUFFIX OR Name = :PrecisionLender.PLUGIN_NAME + PrecisionLender.OPP_SUFFIX)
			AND
				LLC_BI__Context_Id__c IN :idSet
		];
	}

	private Boolean isStageStatusChange(LLC_BI__Loan__c newLoan, LLC_BI__Loan__c oldLoan) {
		return (newLoan.LLC_BI__Stage__c != oldLoan.LLC_BI__Stage__c || newLoan.LLC_BI__Status__c != oldLoan.LLC_BI__Status__c);
	}


	public static final String BEAN_NAME =
		nFORCE.BeanRegistry.getInstance().generateUniqueBeanName(
			LLC_BI.ATriggerHandler.class,
			'precision-lender-stage-status-trigger-handler');

}
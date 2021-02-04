global with sharing virtual class PrecisionLenderTriggerHandler extends nFORCE.ATriggerHandler {
	public virtual override Boolean isDoubleFireSafe() {
		return true;
	}

	public virtual override Type getType() {
		return PrecisionLenderTriggerHandler.class;
	}

	public virtual override void afterInsert(List<SObject> objs, Set<Id> objIds) {
		Map<String, Id> originalRenewalMap = new Map<String, Id>();
		for (LLC_BI__LoanRenewal__c lr : (List<LLC_BI__LoanRenewal__c>) objs) {
			if (lr.LLC_BI__HasActiveRenewalLoan__c) {
				originalRenewalMap.put(lr.LLC_BI__ParentLoanId__c, lr.LLC_BI__RenewalLoanId__c);
			}
		}

		if (!originalRenewalMap.isEmpty()) {
			initiateRenewModifyFuture(originalRenewalMap);
		}
	}

	@Future(callout=true)
	public static void initiateRenewModifyFuture(Map<String, Id> originalRenewalMap) {
		Map<String, String> externLoanMap = new Map<String, String>();
		Map<String, String> externOppMap = new Map<String, String>();
		List<LLC_BI__External_Application_Lookup__c> extApps = [
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
				LLC_BI__Context_Id__c IN :originalRenewalMap.keySet()
		];

		for (LLC_BI__External_Application_Lookup__c exApp : extApps) {
			if (exApp.Name == PrecisionLender.PLUGIN_NAME + PrecisionLender.LOAN_SUFFIX) {
				externLoanMap.put(exApp.LLC_BI__Context_Id__c, exApp.LLC_BI__External_Id__c);
			} else {
				externOppMap.put(exApp.LLC_BI__Context_Id__c, exApp.LLC_BI__External_Id__c);
			}
		}
		initiateRenewModify(externLoanMap, externOppMap, originalRenewalMap);
	}

	@TestVisible
	private static nFUSE.SendService initiateRenewModify(Map<String, String> externMap, Map<String, String> externOppMap, Map<String, Id> originalRenewalMap) {
		List<LLC_BI__Loan__c> originalLoans = getLoansByIds(externMap.keySet());
		nFUSE.PackageServiceRequest req = new nFUSE.PackageServiceRequest(
			PrecisionLender.PLUGIN_NAME,
			PrecisionLender.PLUGIN_VERSION,
			null
		);

		if (originalLoans.size() > 1) {
			req.primaryObjectId = originalLoans[0].LLC_BI__Product_Package__c;
		} else {
			req.primaryObjectId = originalLoans[0].Id;
		}

		nFUSE.MiddlewareMessage msg = createMWMessage(externMap, externOppMap, originalRenewalMap, originalLoans);
		nFUSE.SendService sender;
		sender = PrecisionLender.getPluginSendService(req);
		sender.send(req, msg);

		return sender;
	}

	private static nFUSE.MiddlewareMessage createMWMessage(Map<String, String> externLoanMap, Map<String, String> externOppMap, Map<String, Id> originalRenewalMap, List<LLC_BI__Loan__c> originalLoans) {
		Map<String, Blob> externalRelationshipMap = createExternalRelationshipMap(originalLoans);
		List<Map<String, Object>> jsonBodyList = new List<Map<String, Object>>();

		for (String extStr : externLoanMap.keySet()) {
			String extRelString;
			if (externalRelationshipMap.containsKey(extStr)) {
				extRelString = EncodingUtil.convertToHex(externalRelationshipMap.get(extStr));
			}

			Map<String, Object> renewalBodyMap = new Map<String, Object>();
			renewalBodyMap.put(PrecisionLender.EXT_LOAN_KEY, externLoanMap.get(extStr));
			renewalBodyMap.put(PrecisionLender.EXT_OPP_KEY, externOppMap.get(extStr));
			renewalBodyMap.put(PrecisionLender.PROP_RENEWAL_ID, originalRenewalMap.get(extStr));
			renewalBodyMap.put(PrecisionLender.PROD_EXT_REL_ID, extRelString);
			jsonBodyList.add(renewalBodyMap);
		}

		nFUSE.MiddlewareMessage msg = new nFUSE.MiddlewareMessage();
		msg.messageHeader.action = PrecisionLender.ACTION_REN_MOD_LOANS;
		msg.properties.put(PrecisionLender.PROP_REN_MOD_LOANS, jsonBodyList);

		return msg;
	}

	private static Map<String, Blob> createExternalRelationshipMap(List<LLC_BI__Loan__c> originalLoans) {
		Map<String, Blob> externalRelationshipMap = new Map<String, Blob>();

		String hashClientId = PrecisionLenderPricingController.getUnencryptedClientID();
		for (LLC_BI__Loan__c loaner : originalLoans) {
			if (loaner.LLC_BI__Account__r.LLC_BI__lookupKey__c != null) {
				externalRelationshipMap.put(loaner.Id, Crypto.generateDigest('MD5', Blob.valueOf(loaner.LLC_BI__Account__r.LLC_BI__lookupKey__c + hashClientId)));
			}
		}

		return externalRelationshipMap;
	}

	@TestVisible
	private static Map<String, String> createPrecisionLenderIdMap(Set<String> loanIds) {
		Map<String, String> externalIdMap = new Map<String, String>();
		List<LLC_BI__External_Application_Lookup__c> externalApp = [
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
				LLC_BI__Context_Id__c IN :loanIds
		];

		for (LLC_BI__External_Application_Lookup__c extApp : externalApp) {
			externalIdMap.put(extApp.LLC_BI__External_Id__c, extApp.LLC_BI__Context_Id__c);
		}

		return externalIdMap;
	}

	private static List<LLC_BI__Loan__c> getLoansByIds(Set<String> loanIds) {
		return [
			SELECT
				Id,
				LLC_BI__Account__r.LLC_BI__lookupKey__c,
				LLC_BI__Product_Package__c
			FROM
				LLC_BI__Loan__c
			WHERE
				Id IN :loanIds
		];
	}

	public static final String BEAN_NAME =
		nFORCE.BeanRegistry.getInstance().generateUniqueBeanName(
			LLC_BI.ATriggerHandler.class,
			'precision-lender-renew-modify-trigger-handler');
}
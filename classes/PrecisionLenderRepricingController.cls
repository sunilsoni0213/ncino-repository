global with sharing class PrecisionLenderRepricingController extends APrecisionLenderController {

	public LLC_BI__Loan__c loanRecord;

	public PrecisionLenderRepricingController(ApexPages.StandardController controller) {
		this.controller = controller;
		this.loanRecord = (LLC_BI__Loan__c)this.controller.getRecord();
		this.objectId = (String)this.loanRecord.Id;
	}

	@RemoteAction
	global static void remoteRepriceLoan(String loanId) {
		repriceLoan(loanId);
	}

	public static nFUSE.MiddlewareMessage repriceLoan(String loanId) {
		nFUSE.PackageServiceRequest req = new nFUSE.PackageServiceRequest(PrecisionLender.PLUGIN_NAME, PrecisionLender.PLUGIN_VERSION, null);
		req.primaryObjectId = loanId;
		nFORCE.ACrossPackageService loanService = (nFORCE.ACrossPackageService) nFORCE.BeanFactory.getInstance().getBeanByUniqueName(NFUSE_SERVICE);

		loanService.setInputParameter(
			INPUT_REQUEST,
			new nFUSE.IntegrationClassTypeProvider().serialize(req)
		);
		loanService.setInputParameter(
			INPUT_LOAN_IDS,
			new Set<Id>{ req.primaryObjectId }
		);

		loanService.executeService();

		List<nFORCE.IForce> fLoans = (List<nFORCE.IForce>) loanService.getOutputParameter(OUTPUT_LOANS);
		Map<String, String> idMapper = getPrecisionLenderIdMap(req.primaryObjectId);
		String accLookup = getLoanAccountLookup(loanId);

		String hashClientId = PrecisionLenderPricingController.getUnencryptedClientID();
		String extRelString;
		if (accLookup != null) {
			Blob blobData = Blob.valueOf(accLookup + hashClientId);
			extRelString = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', blobData));
		}

		nFUSE.MiddlewareMessage msg = new nFUSE.MiddlewareMessage();
		msg.messageHeader.action = PrecisionLender.ACTION_REPRICING;
		msg.properties.put(PROP_LOAN_KEY, fLoans[0]);
		msg.properties.put(PrecisionLender.EXT_OPP_KEY, idMapper.get(PrecisionLender.EXT_OPP_KEY));
		msg.properties.put(PrecisionLender.EXT_LOAN_KEY, idMapper.get(PrecisionLender.EXT_LOAN_KEY));
		msg.properties.put(PrecisionLender.PROD_EXT_REL_ID, extRelString);

		nFUSE.SendService sender = PrecisionLender.getPluginSendService(req);
		sender.send(req, msg);

		return msg;
	}

	private static String getLoanAccountLookup(String loanId) {
		LLC_BI__Loan__c loaner = [
			SELECT
				Id,
				LLC_BI__Account__r.LLC_BI__lookupKey__c
			FROM
				LLC_BI__Loan__c
			WHERE
				Id = :loanId
		];
		return loaner.LLC_BI__Account__r.LLC_BI__lookupKey__c;
	}

	private static Map<String, String> getPrecisionLenderIdMap(String loanId) {
		Map<String, String> idMapper = new Map<String, String>();
		List<LLC_BI__External_Application_Lookup__c> externalApps = [
			SELECT
				Id,
				Name,
				LLC_BI__Context_Id__c,
				LLC_BI__External_Id__c
			FROM
				LLC_BI__External_Application_Lookup__c
			WHERE
				LLC_BI__Context_Id__c = :loanId
			AND
				(
					Name = :PrecisionLender.PLUGIN_NAME + PrecisionLender.OPP_SUFFIX
				OR
					Name = :PrecisionLender.PLUGIN_NAME + PrecisionLender.LOAN_SUFFIX
				)
		];

		if (externalApps != null && externalApps.size() > 0) {
			for (LLC_BI__External_Application_Lookup__c extApp : externalApps) {
				if (extApp.Name == PrecisionLender.PLUGIN_NAME + PrecisionLender.OPP_SUFFIX) {
					idMapper.put(PrecisionLender.EXT_OPP_KEY, extApp.LLC_BI__External_Id__c);
				} else {
					idMapper.put(PrecisionLender.EXT_LOAN_KEY, extApp.LLC_BI__External_Id__c);
				}
			}
		}
		return idMapper;
	}

	@TestVisible
	private static final String
		NFUSE_SERVICE = 'nFUSE.LoanGetXPkg',
		INPUT_REQUEST = 'request',
		INPUT_LOAN_IDS = 'loan_ids',
		OUTPUT_LOANS = 'loans',
		PROP_LOAN_KEY = 'loanKey';
}
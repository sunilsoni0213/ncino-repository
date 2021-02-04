public with sharing class PrecisionLenderPricingController extends APrecisionLenderController {

	public PageReference initiatePricing() {
		priceScenario();
		return null;
	}

	public PrecisionLenderPricingController(ApexPages.StandardController controller) {
		this.controller = controller;
		this.objectId = (String)controller.getId();
	}

	public nFUSE.MiddlewareMessage priceScenario() {
		nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(
			PrecisionLender.PLUGIN_NAME,
			PrecisionLender.PLUGIN_VERSION,
			null);
		request.primaryObjectId = this.controller.getId();

		nFUSE.MiddlewareMessage message = preparePricingMessage(request);

		sendService = PrecisionLender.getPluginSendService(request);
		sendService.send(request, message);

		return message;
	}

	public List<nFORCE.IForce> getRelationships(nFUSE.PackageServiceRequest request, Id relId) {
		nFORCE.ACrossPackageService service = (nFORCE.ACrossPackageService)
		nFORCE.BeanFactory.getInstance().getBeanByUniqueName('nFUSE.RelationshipGetXPkg');
		service.setInputParameter(PrecisionLender.REQUEST_PARAM, new nFUSE.IntegrationClassTypeProvider().serialize(request));
		service.setInputParameter(PrecisionLender.RELATIONSHIPS_PARAM, JSON.serialize(new Set<Id>{relId}));

		service.executeService();

		List<nFORCE.IForce> relationships = (List<nFORCE.IForce>) service
			.getOutputParameter(PrecisionLender.RELATIONSHIPS_CONST);

		return relationships;
	}

	public nFUSE.MiddlewareMessage preparePricingMessage(nFUSE.PackageServiceRequest request) {
		nFUSE.MiddlewareMessage message = new nFUSE.MiddlewareMessage();
		Account acc;
		Id relId;

		if (controller.getRecord() != null) {
			if (controller.getRecord().getSObjectType() == Account.getSObjectType()) {
				acc = getAccountById(controller.getId());
				message.properties.put(PrecisionLender.SCENARIO_CONST, acc.Name);
			} else if (controller.getRecord().getSObjectType() == Opportunity.getSObjectType()) {
				Opportunity opp = getOpportunityById(controller.getId());
				acc = opp.Account;
				message.properties.put(PrecisionLender.SCENARIO_CONST, opp.Name);
			}
			relId = acc.Id;
			message.messageHeader.action = PrecisionLender.ACTION_PRICING;

			list<nFORCE.IForce> relationships = getRelationships(request, relID);

			String hashClientId = getUnencryptedClientID();

			String extRelString;
			if (acc.LLC_BI__lookupKey__c != null) {
				Blob blobData = Blob.valueOf(acc.LLC_BI__lookupKey__c + hashClientId);
				extRelString = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', blobData));
			}

			message.properties.put(PrecisionLender.RELATIONSHIPS_CONST, relationships);
			message.properties.put(PrecisionLender.PROD_EXT_REL_ID, extRelString);
		}
		return message;
	}

	public static String getUnencryptedClientID() {
		List<nFUSE.PluginConfigurationManager.PluginConfiguration> properties = new nFUSE.PluginConfigurationManager(PrecisionLender.PLUGIN_NAME, PrecisionLender.PLUGIN_VERSION).getConfigurations();

		String hashClientId;
		for (nFUSE.PluginConfigurationManager.PluginConfiguration config : properties) {
			if (config.key == PrecisionLender.CONFIG_PROP_KEY_CLIENT_ID) {
				hashClientId = config.value;
			}
		}
		return hashClientId;
	}

	private Account getAccountById(String Id) {
		return [
			SELECT
				Id,
				Name,
				LLC_BI__lookupKey__c
			FROM
				Account
			WHERE
				Id = :Id
			LIMIT 1
		];
	}

	private Opportunity getOpportunityById(String Id) {
		return [
			SELECT
				Name,
				Account.Id,
				Account.LLC_BI__lookupKey__c
			FROM
				Opportunity
			WHERE
				Id = :Id
			LIMIT 1
		];
	}
}
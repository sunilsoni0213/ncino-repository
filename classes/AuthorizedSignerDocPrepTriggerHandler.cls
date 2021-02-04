/**
 * DocPrep Plugin
 **/
global without sharing virtual class AuthorizedSignerDocPrepTriggerHandler extends nFORCE.ATriggerHandler {
	public virtual override Type getType() {
		return AuthorizedSignerDocPrepTriggerHandler.class;
	}

	public virtual override void beforeInsert(List<SObject> objs) {
		List<LLC_BI__Contingent_Liabilty__c> authorizedSigners = (List<LLC_BI__Contingent_Liabilty__c>)objs;

		// Retrieve applicable ownership structure roles for the Authorized Signers being created
		Set<Id> ownershipStructureRoleIds = new Set<Id>();
		Set<Id> entityIds = new Set<Id>();
		for (LLC_BI__Contingent_Liabilty__c signer : authorizedSigners) {
			ownershipStructureRoleIds.add(signer.LLC_BI__Ownership_Structure_Role__c);
			entityIds.add(signer.LLC_BI__Entity__c);
		}

		Map<Id, LLC_BI__Ownership_Structure_Role__c> ownershipStructureRoles =
			getOwnershipStructureRoles(ownershipStructureRoleIds);

		Map<Id, LLC_BI__Legal_Entities__c> entitiesForSigners = getEntities(entityIds);

		// Map the nCino Code field value from the associated ownership structure role to the new Authorized Signer
		for (LLC_BI__Contingent_Liabilty__c signer : authorizedSigners) {
			if (entitiesForSigners.containsKey(signer.LLC_BI__Entity__c) &&
				entitiesForSigners.get(signer.LLC_BI__Entity__c).LLC_BI__Deposit__c != null &&
				signer.LLC_BI__Ownership_Structure_Role__c != null &&
				ownershipStructureRoles.containsKey(signer.LLC_BI__Ownership_Structure_Role__c)) {
				signer.nCino_Code__c = ownershipStructureRoles.get(signer.LLC_BI__Ownership_Structure_Role__c).nCino_Code__c;
			}
		}
	}

	private static Map<Id, LLC_BI__Ownership_Structure_Role__c> getOwnershipStructureRoles(Set<Id> ownershipStructureRoleIds) {
		return new Map<Id, LLC_BI__Ownership_Structure_Role__c>([
			SELECT
				Id,
				LLC_BI__Is_Authorized_Signer__c,
				nCino_Code__c
			FROM
				LLC_BI__Ownership_Structure_Role__c
			WHERE
				Id IN :ownershipStructureRoleIds
		]);
	}

	private static Map<Id, LLC_BI__Legal_Entities__c> getEntities(Set<Id> entityIds) {
		return new Map<Id, LLC_BI__Legal_Entities__c>([
			SELECT
				Id,
				LLC_BI__Deposit__c
			FROM
				LLC_BI__Legal_Entities__c
			WHERE
				Id IN :entityIds
		]);
	}

	public static final String BEAN_NAME =
		nFORCE.BeanRegistry.getInstance().generateUniqueBeanName(
			LLC_BI.ATriggerHandler.class,
			'authorized-signer-doc-prep-trigger-handler');
}
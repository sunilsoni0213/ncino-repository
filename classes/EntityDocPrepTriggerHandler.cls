global with sharing virtual class EntityDocPrepTriggerHandler extends nFORCE.ATriggerHandler {

	public virtual override Type getType() {
		return EntityDocPrepTriggerHandler.class;
	}

	public virtual override void beforeInsert(List<SObject> objs) {
		List<LLC_BI__Legal_Entities__c> entitiesWithDeposits = new List<LLC_BI__Legal_Entities__c>();
		Set<Id> depositIdSet = new Set<Id>();

		List<LLC_BI__Legal_Entities__c> entityList = (List<LLC_BI__Legal_Entities__c>) objs;
		for (LLC_BI__Legal_Entities__c entity : entityList) {
			if (entity.LLC_BI__Deposit__c != null) {
				entitiesWithDeposits.add(entity);
				depositIdSet.add(entity.LLC_BI__Deposit__c);
			}
		}
		List<LLC_BI__Deposit__c> deposits = retrieveDeposits(depositIdSet);
		Map<Id, LLC_BI__Deposit__c> depositIdMap = new Map<Id, LLC_BI__Deposit__c>(deposits);
		List<RoleInfo> roleInfoList = new List<RoleInfo>();
		for (LLC_BI__Legal_Entities__c ei : entitiesWithDeposits) {
			Id ownershipStructureType = depositIdMap.get(ei.LLC_BI__Deposit__c).LLC_BI__Ownership_Structure_Type__c;
			if (ownershipStructureType != null) {
				roleInfoList.add(new RoleInfo(ownershipStructureType, ei.LLC_BI__Relationship_Type__c));
			}
		}

		List<LLC_BI__Ownership_Structure_Role__c> roles = retrieveOwnershipStructureRoles(roleInfoList);
		if (roles == null){
			return;
		}
		Map<String, String> roleCodeMap = createRoleCodeMap(roles);


		for (LLC_BI__Legal_Entities__c ei : entitiesWithDeposits) {
			String structureType = String.valueOf(depositIdMap.get(ei.LLC_BI__Deposit__c).LLC_BI__Ownership_Structure_Type__c);
			String relationshipType = ei.LLC_BI__Relationship_Type__c;
			ei.nCino_Code__c = roleCodeMap.get(structureType + '-' + relationshipType );
		}
	}

	private List<LLC_BI__Ownership_Structure_Role__c> retrieveOwnershipStructureRoles(List<RoleInfo> roleInfoList) {
		if (roleInfoList != null && roleInfoList.size() > 0) {
			String queryString = 
				'SELECT' +
					' Id,' +
					' nCino_Code__c,' +
					' LLC_BI__Ownership_Structure_Type__c,' +
					' LLC_BI__Relationship_Type__c' +
				' FROM' +
					' LLC_BI__Ownership_Structure_Role__c' + 
				' WHERE';

			for (Integer i = 0; i < roleInfoList.size(); i++ ) {
				String structureType = String.valueOf(roleInfoList.get(i).structureType);
				String relationshipType = roleInfoList.get(i).relationshipType;
				queryString +=
					' ( LLC_BI__Ownership_Structure_Type__c = \'' + structureType + '\'' + 
				' AND' +
					' LLC_BI__Relationship_Type__c = \'' + relationshipType +  '\' )';
				if (i < roleInfoList.size() - 1) {
					queryString += ' OR ';
				}
			}
			return (List<LLC_BI__Ownership_Structure_Role__c>) Database.query(queryString);
		}
		return null;
	}

	private Map<String, String> createRoleCodeMap(List<LLC_BI__Ownership_Structure_Role__c> roles) {
		Map<String, String> roleCodeMap = new Map<String, String>();
		for (LLC_BI__Ownership_Structure_Role__c role : roles) {
			roleCodeMap.put(String.valueOf(role.LLC_BI__Ownership_Structure_Type__c) + '-' + role.LLC_BI__Relationship_Type__c, 
				role.nCino_Code__c);
		}
		return roleCodeMap;
	}

	private List<LLC_BI__Deposit__c> retrieveDeposits(Set<Id> idSet) {
		return [
			SELECT
				Id,
				LLC_BI__Ownership_Structure_Type__c
			FROM
				LLC_BI__Deposit__c
			WHERE
				Id IN :idSet
		];
	}

	private Class RoleInfo {
		Id structureType;
		String relationshipType;
		RoleInfo(Id structureType, String relationshipType){
			this.structureType = structureType;
			this.relationshipType = relationshipType;
		}
	}

	public static final String BEAN_NAME =
		nFORCE.BeanRegistry.getInstance().generateUniqueBeanName(
			LLC_BI.ATriggerHandler.class,
			'entity-involvement-doc-prep-trigger-handler');
}
global with sharing class MaintenanceMappingController {

	@RemoteAction
	global static Map<String,List<LLC_BI__Task_Checklist__c>> getMappings(){
		Set<String> allMaintenance = MaintenanceTypeController.retrieveMaintenanceTypes();
		Map<String,List<LLC_BI__Task_Checklist__c>> configMap = getStoredConfiguration();
		for(String mType : allMaintenance){
			if(configMap.get(mType) == null){
				configMap.put(mType, new List<LLC_BI__Task_Checklist__c>());
			}
		}

		if(configMap != null && configMap.size() > 0){
			return configMap;
		}
		return new Map<String, List<LLC_BI__Task_Checklist__c>>();
	}

	@RemoteAction
	global static List<Task> retrieveTasks(){
		return MaintenanceChecklistController.retrieveChecklist();
	}

	@RemoteAction
	global static Map<String,List<LLC_BI__Task_Checklist__c>> saveMappings(String  maintenanceType, List<String> mappings){
		Map<String, List<LLC_BI__Task_Checklist__c>> configuredChecklist = getStoredConfiguration();
		List<LLC_BI__Task_Checklist__c> newMappings = new List<LLC_BI__Task_Checklist__c>();
		removeChecklist(maintenanceType);
		for(String mapping : mappings){
			LLC_BI__Task_Checklist__c newMap = new LLC_BI__Task_Checklist__c();
			newMap.LLC_BI__Task_Id__c = mapping;
			newMap.LLC_BI__Type_Name__c = maintenanceType;
			newMappings.add(newMap);
		}
		insert newMappings;
		return getMappings();
	}

	private static Map<String, List<LLC_BI__Task_Checklist__c>> getStoredConfiguration(){
		Map<String,List<LLC_BI__Task_Checklist__c>> configMap = new Map<String, List<LLC_BI__Task_Checklist__c>>();
		List<LLC_BI__Task_Checklist__c> configList = [
			SELECT 
				Id, 
				LLC_BI__Task_Id__c, 
				LLC_BI__Type_Name__c
			FROM
				LLC_BI__Task_Checklist__c
			];
		for(LLC_BI__Task_Checklist__c configMeta : configList){
			if(configMap.get(configMeta.LLC_BI__Type_Name__c) != null){
				configMap.get(configMeta.LLC_BI__Type_Name__c).add(configMeta);
			}
			else{
				configMap.put(configMeta.LLC_BI__Type_Name__c, new List<LLC_BI__Task_Checklist__c> {configMeta});
			}
		}
		return configMap;
	}

	private static void removeChecklist(String typeName){
		List<LLC_BI__Task_Checklist__c> configList = [
			SELECT
				Id,
				LLC_BI__Task_Id__c,
				LLC_BI__Type_Name__c
			FROM
				LLC_BI__Task_Checklist__c
			WHERE
				LLC_BI__Type_Name__c =: typeName
		];
		delete configList;
	}

}
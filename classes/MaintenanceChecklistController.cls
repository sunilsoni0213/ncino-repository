global with sharing class MaintenanceChecklistController {
	
	@RemoteAction
	global static List<Task> retrieveChecklist(){
		List<Task> templateTasks = [
			SELECT
				Id,
				Subject,
				LLC_BI__Estimated_Time__c,
				LLC_BI__Assignment_Group__c,
				Type
			FROM
				Task
			WHERE
				LLC_BI__isTemplate__c =: true
		];
		return templateTasks;
	}

	@RemoteAction
	global static void addChecklist(List<Task> newChecklist){
		for(Task templateTask : newChecklist){
			templateTask.LLC_BI__isTemplate__c = true;
			templateTask.Type = MAINTENANCE_TASK;
		}
		upsert newChecklist;
	}

	@RemoteAction
	global static void deleteChecklist(List<Task> removalList){
		//functionality to come with editing in sprint 12
	}

	private static final String MAINTENANCE_TASK = 'Maintenance Task Template';

}
@isTest
public class TestMaintenanceChecklistController {
	
	@isTest
	public static void testGetChecklist() {
		createTemplates();

		Test.startTest();

		List<Task> checklist = MaintenanceChecklistController.retrieveChecklist();

		System.assertEquals(5, checklist.size());
		System.assertEquals('TestSubject3', checklist[2].Subject);

		Test.stopTest();
	}
	
	@isTest
	public static void testAddChecklist() {
		List<Task> taskList = new List<Task>();
		Task t1 = new Task(
			Subject = 'Test new template1',
			LLC_BI__Estimated_Time__c = 3
		);
		taskList.add(t1);
		Task t2 = new Task(
			Subject = 'Test new template2',
			LLC_BI__Estimated_Time__c = 5
		);
		taskList.add(t2);

		Test.startTest();

		MaintenanceChecklistController.addChecklist(taskList);

		List<Task> checklist = MaintenanceChecklistController.retrieveChecklist();

		System.assertEquals(2, checklist.size());
		System.assertEquals('Maintenance Task Template', checklist[0].Type);

		Test.stopTest();
	}

	@isTest
	public static void testDeteleChecklist(){
		//sprint 12
	}

	public static void createTemplates(){
		List<Task> tasks = new List<Task>();
		Task t1 = createTemplateTask('TestSubject1', 1);
		Task t2 = createTemplateTask('TestSubject2', 2);
		Task t3 = createTemplateTask('TestSubject3', 3);
		Task t4 = createTemplateTask('TestSubject4', 4);
		Task t5 = createTemplateTask('TestSubject5', 5);
		tasks.add(t1);
		tasks.add(t2);
		tasks.add(t3);
		tasks.add(t4);
		tasks.add(t5);
		insert tasks;
	}

	private static Task createTemplateTask(String subject, Integer estTime){
		Task template = new Task();
		template.Subject = subject;
		template.LLC_BI__Estimated_Time__c = estTime;
		template.LLC_BI__isTemplate__c = true;
		return template;
	}
	
}
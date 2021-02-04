@isTest
public class TestMaintenanceMappingController {
	
	@isTest
	public static void testSaveMappings() {
		Test.startTest();

		TestMaintenanceChecklistController.createTemplates();
		Map<String,List<LLC_BI__Task_Checklist__c>> savedMaps = new Map<String,List<LLC_BI__Task_Checklist__c>>();
		Map<String,List<String>> newMappings = createMappings();
		for(String mType : newMappings.keySet()){
			savedMaps = MaintenanceMappingController.saveMappings(mType, newMappings.get(mType));
		}
		System.assertEquals(1, newMappings.size());

		Set<String> mTypes = MaintenanceTypeController.retrieveMaintenanceTypes();
		System.assertEquals(newMappings.size() + mTypes.size(), savedMaps.size());

		Test.stopTest();
	}
	
	@isTest
	public static void testRetrieveTypes() {
		Test.startTest();

		TestMaintenanceChecklistController.createTemplates();
		List<Task> mTasks = MaintenanceMappingController.retrieveTasks();
		System.assertEquals(5, mTasks.size());

		Test.stopTest();
	}

	@isTest
	public static void testGetMappings() {
		Test.startTest();

		Map<String,List<LLC_BI__Task_Checklist__c>> clMap = MaintenanceMappingController.getMappings();

		Test.stopTest();

		Set<String> mTypes = MaintenanceTypeController.retrieveMaintenanceTypes();
		System.assertEquals(mTypes.size(), clMap.size());
	}

	private static Map<String,List<String>> createMappings(){
		Map<String,List<String>> newMaps = new Map<String,List<String>> {
			'type' => testActions
		};
		return newMaps;
	}

	private static final List<String> testActions = new List<String> {
		'TestSubject1',
		'TestSubject2',
		'TestSubject3'
	};
	
}
@isTest
public class TestMaintenanceTypeController {
	
	@isTest
	static void testRetrieveMaintenanceTypes() {
		
		Test.startTest();

		Set<String> maintenanceTypes = MaintenanceTypeController.retrieveMaintenanceTypes();
		System.assertEquals(true, maintenanceTypes.contains('Address Change'));

		Test.stopTest();
	}

	@isTest
	static void testPicklistUpsert(){
		Test.setMock(WebServiceMock.class, new UpsertPicklistMockCallout());
		MetadataService metaDataService = new MetadataService();
		Test.startTest();

		MaintenanceTypeController.upsertMaintenanceTypes(SAMPLE_PICKLISTS);
		MetadataService.SaveResult[] result = WebSvcCallout.upsertPicklists();
		System.assertNotEquals(null, result);
		System.assertEquals(0, result.size());

		Test.stopTest();
	}

	private static List<String> SAMPLE_PICKLISTS = new List<String>{
		'picklist1',
		'picklist2',
		'picklist3'
	};
}
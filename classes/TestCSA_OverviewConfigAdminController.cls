@isTest
public class TestCSA_OverviewConfigAdminController {
	
	@isTest
	public static void initialize() {
		CSA_OverviewConfigAdminController OCC = new CSA_OverviewConfigAdminController();
	}

	@isTest
	public static void back() {
		CSA_OverviewConfigAdminController OCC = new CSA_OverviewConfigAdminController();

		Test.startTest();

		OCC.back();

		Test.stopTest();
	}

	@isTest
	public static void viewNew() {
		CSA_OverviewConfigAdminController OCC = new CSA_OverviewConfigAdminController();

		Test.startTest();

		OCC.overviewNew();

		Test.stopTest();
	}

	@isTest
	public static void SaveNew() {
		CSA_OverviewConfigAdminController OCC = new CSA_OverviewConfigAdminController();

		Test.startTest();

		OCC.overviewNew();
		OCC.isSaveNew = false;
		OCC.overviewSaveNew();

		Test.stopTest();
	}

	@isTest
	public static void SaveNewNew() {
		CSA_OverviewConfigAdminController OCC = new CSA_OverviewConfigAdminController();

		Test.startTest();

		OCC.overviewNew();
		OCC.isSaveNew = true;
		OCC.overviewSaveNew();

		Test.stopTest();
	}

	@isTest
	public static void viewEdit() {
		Overview_Properties__c testOverviewProperty = createOverviewProperty('1234567', 'Usable_Product_Line', 'Commercial', true);
		CSA_OverviewConfigAdminController OCC = new CSA_OverviewConfigAdminController();

		Test.startTest();

		OCC.overviewId = testOverviewProperty.Id;
		OCC.overviewEdit();

		Test.stopTest();
	}

	@isTest
	public static void saveEdit() {
		Overview_Properties__c testOverviewProperty = createOverviewProperty('1234567', 'Usable_Product_Line', 'Commercial', true);
		CSA_OverviewConfigAdminController OCC = new CSA_OverviewConfigAdminController();

		Test.startTest();

		OCC.overviewId = testOverviewProperty.Id;
		OCC.overviewEdit();
		OCC.overviewSaveEdit();

		Test.stopTest();
	}

	@isTest
	public static void doDelete() {
		Overview_Properties__c testOverviewProperty = createOverviewProperty('1234567', 'Usable_Product_Line', 'Commercial', true);
		CSA_OverviewConfigAdminController OCC = new CSA_OverviewConfigAdminController();

		Test.startTest();

		OCC.overviewId = testOverviewProperty.Id;
		OCC.overviewDelete();

		Test.stopTest();
	}

	@isTest
	public static void activate() {
		Overview_Properties__c testOverviewProperty = createOverviewProperty('1234567', 'Usable_Product_Line', 'Commercial', false);
		CSA_OverviewConfigAdminController OCC = new CSA_OverviewConfigAdminController();

		Test.startTest();

		OCC.overviewId = testOverviewProperty.Id;
		OCC.overviewActivate();

		Test.stopTest();
	}

	@isTest
	public static void deactivate() {
		Overview_Properties__c testOverviewProperty = createOverviewProperty('1234567', 'Usable_Product_Line', 'Commercial', true);
		CSA_OverviewConfigAdminController OCC = new CSA_OverviewConfigAdminController();

		Test.startTest();

		OCC.overviewId = testOverviewProperty.Id;
		OCC.overviewDeactivate();

		Test.stopTest();
	}

	@isTest
	public static void categories() {
		CSA_OverviewConfigAdminController OCC = new CSA_OverviewConfigAdminController();

		Test.startTest();

		OCC.getCategoryPicklist();

		Test.stopTest();
	}

	@isTest
	public static void stages() {
		CSA_OverviewConfigAdminController OCC = new CSA_OverviewConfigAdminController();

		Test.startTest();

		OCC.getStagePicklist();

		Test.stopTest();
	}

	@isTest
	public static void status() {
		CSA_OverviewConfigAdminController OCC = new CSA_OverviewConfigAdminController();

		Test.startTest();

		OCC.getStatusPicklist();

		Test.stopTest();
	}

	@isTest
	public static void productLine() {
		CSA_OverviewConfigAdminController OCC = new CSA_OverviewConfigAdminController();

		Test.startTest();

		OCC.getProductLinePicklist();

		Test.stopTest();
	}

	@isTest(SeeAllData=true)
	public static void reportsList() {
		CSA_OverviewConfigAdminController OCC = new CSA_OverviewConfigAdminController();

		Test.startTest();

		OCC.getReportsPicklist();

		Test.stopTest();
	}

	private static Overview_Properties__c createOverviewProperty(String theName, String category, String sname, Boolean active) {
		Overview_Properties__c newOP = new Overview_Properties__c(
			Name = theName,
			Category_Name__c = category,
			Is_Active__c = active,
			Stage_Status_Product_Line_Name__c = sname);

		Database.insert(newOP);
		return newOP;
	}
}
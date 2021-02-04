@isTest
public class TestCSA_OverviewConfigurationController {
	
	@isTest
	public static void initialize() {
		CSA_OverviewConfigurationController OCC = new CSA_OverviewConfigurationController();
	}

	@isTest
	public static void isInstalledTrue() {
		LLC_BI__System_Properties__c testSystemProperty = createSystemProperty();
		CSA_OverviewConfigurationController OCC = new CSA_OverviewConfigurationController();

		Test.startTest();

		OCC.getIsInstalled();

		Test.stopTest();
	}

	@isTest
	public static void isInstalledFalse() {
		CSA_OverviewConfigurationController OCC = new CSA_OverviewConfigurationController();
		
		Test.startTest();

		OCC.getIsInstalled();

		Test.stopTest();
	}

	@isTest
	public static void installSuccess() {
		nForce__Group__c testGroup = createGroup('nCino Admin', 'admin');
		CSA_OverviewConfigurationController OCC = new CSA_OverviewConfigurationController();
		
		Test.startTest();

		OCC.install();

		Test.stopTest();
	}

	@isTest
	public static void installError() {
		CSA_OverviewConfigurationController OCC = new CSA_OverviewConfigurationController();
		
		Test.startTest();

		OCC.install();

		Test.stopTest();
	}

	@isTest
	public static void uninstall() {
		CSA_OverviewConfigurationController OCC = new CSA_OverviewConfigurationController();
		
		Test.startTest();

		OCC.uninstall();

		Test.stopTest();
	}

	@isTest
	public static void finish() {
		CSA_OverviewConfigurationController OCC = new CSA_OverviewConfigurationController();
		
		Test.startTest();

		OCC.finish();

		Test.stopTest();
	}

	private static LLC_BI__System_Properties__c createSystemProperty() {
		LLC_BI__System_Properties__c newSP = new LLC_BI__System_Properties__c(
			Name = '123456789987645321132',
			LLC_BI__Category_Name__c = 'CSA Overview',
			LLC_BI__Is_Active__c = true,
			LLC_BI__Key__c = 'Is_Installed_CSA_Overview',
			LLC_BI__Value__c = 'true');

		Database.insert(newSP);
		return newSP;
	}

	private static nForce__Group__c createGroup(String nam, String app) {
		nForce__Group__c newG = new nForce__Group__c(
			Name = nam,
			nFORCE__App__c = app);

		Database.insert(newG);
		return newG;
	}
}
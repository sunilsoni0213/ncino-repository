@isTest
public class TestCSA_ConfigValueConfigController {
	@isTest
	public static void isInstalledFalse() {
		CSA_ConfigValueConfigController CVCC = new CSA_ConfigValueConfigController();

		Test.startTest();

		CVCC.getIsInstalled();

		Test.stopTest();
	}

	@isTest
	public static void isInstalledTrue() {
		LLC_BI__System_Properties__c testSystemProperty = createSystemProperty();
		CSA_ConfigValueConfigController CVCC = new CSA_ConfigValueConfigController();

		Test.startTest();

		CVCC.getIsInstalled();

		Test.stopTest();
	}

	@isTest
	public static void install() {
		CSA_ConfigValueConfigController CVCC = new CSA_ConfigValueConfigController();

		Test.startTest();

		CVCC.install();

		Test.stopTest();
	}

	@isTest
	public static void uninstall() {
		CSA_ConfigValueConfigController CVCC = new CSA_ConfigValueConfigController();

		Test.startTest();

		CVCC.uninstall();

		Test.stopTest();
	}

	@isTest
	public static void finish() {
		CSA_ConfigValueConfigController CVCC = new CSA_ConfigValueConfigController();

		Test.startTest();

		CVCC.finish();

		Test.stopTest();
	}

	private static LLC_BI__System_Properties__c createSystemProperty() {
		LLC_BI__System_Properties__c newSP = new LLC_BI__System_Properties__c(
			Name = '123456789987645321132',
			LLC_BI__Category_Name__c = 'CSA Config Admin',
			LLC_BI__Is_Active__c = true,
			LLC_BI__Key__c = 'Is_Installed_Config_Values',
			LLC_BI__Value__c = 'true');

		Database.insert(newSP);
		return newSP;
	}
}
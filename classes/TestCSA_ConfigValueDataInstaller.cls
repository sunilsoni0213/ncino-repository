@isTest
public class TestCSA_ConfigValueDataInstaller {

	@isTest
	public static void installNoData() {
		CSA_ConfigValueDataInstaller dataInstaller = new CSA_ConfigValueDataInstaller();
		Test.testInstall(dataInstaller, null);
	}

	@isTest
	public static void installExistingData() {
		LLC_BI__CFG_ConfigValue__c testConfigValue = createConfigValue('Delete_Feature_Enabled', 'ALL', 'DEL_FEATURE_ENABLE');
		LLC_BI__CFG_ConfigKey__c testConfigKey = createConfigKey('KY_DM_ReviewerRoles', 'KY_DM_ReviewerRole');
		CSA_ConfigValueDataInstaller dataInstaller = new CSA_ConfigValueDataInstaller();
		Test.testInstall(dataInstaller, null);
	}

	@isTest
	public static void uninstall() {
		LLC_BI__System_Properties__c testSystemProperty = createSystemProperty();
		Test.testUninstall(new CSA_ConfigValueDataInstaller());
	}

	private static LLC_BI__CFG_ConfigValue__c createConfigValue(String category, String key, String lookupKey) {
		LLC_BI__CFG_ConfigValue__c newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = category,
			LLC_BI__fieldValue__c = '',
			LLC_BI__Key__c = key,
			LLC_BI__lookupKey__c = lookupKey);

		Database.insert(newCV);
		return newCV;
	}

	private static LLC_BI__CFG_ConfigKey__c createConfigKey(String nam, String lookupKey) {
		LLC_BI__CFG_ConfigKey__c newCK = new LLC_BI__CFG_ConfigKey__c(
			Name = nam,
			LLC_BI__lookupKey__c = lookupKey);

		Database.insert(newCK);
		return newCK;
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
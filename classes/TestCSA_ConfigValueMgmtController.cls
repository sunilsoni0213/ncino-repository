@isTest
public class TestCSA_ConfigValueMgmtController {
	@isTest
	public static void initialize() {
		CSA_ConfigValueMgmtController CVMC = new CSA_ConfigValueMgmtController();
	}

	@isTest
	public static void configValueNew() {
		LLC_BI__CFG_ConfigKey__c testConfigKey = createConfigKey('KY_DM_ReviewerRoles', 'KY_DM_ReviewerRole');
		CSA_ConfigValueMgmtController CVMC = new CSA_ConfigValueMgmtController();

		Test.startTest();

		CVMC.configValueNew();

		Test.stopTest();
	}

	@isTest
	public static void configValueEditStage() {
		LLC_BI__CFG_ConfigValue__c testConfigValue = createConfigValue('Stages_Deletion_Allowed', 'Booked', 'ALL', 'DEL_STAGES_ALLOWED');
		LLC_BI__CFG_ConfigKey__c testConfigKey1 = createConfigKey('KY_DM_ReviewerRoles', 'KY_DM_ReviewerRole');
		LLC_BI__CFG_ConfigKey__c testConfigKey2 = createConfigKey('KY_GBL_CreditRole', 'KY_GBL_CreditRole');
		LLC_BI__CFG_CKJ__c testCKJ = createConfigJoin(testConfigValue.Id, testConfigKey1.Id);
		CSA_ConfigValueMgmtController CVMC = new CSA_ConfigValueMgmtController();

		Test.startTest();

		CVMC.configValueId = testConfigValue.Id;
		CVMC.configValueEdit();

		Test.stopTest();
	}

	@isTest
	public static void configValueEditStatus() {
		LLC_BI__CFG_ConfigValue__c testConfigValue = createConfigValue('Status_Renewal_Allowed', 'Open', 'ALL', 'REN_STATUS_ALLOWED');
		LLC_BI__CFG_ConfigKey__c testConfigKey1 = createConfigKey('KY_DM_ReviewerRoles', 'KY_DM_ReviewerRole');
		LLC_BI__CFG_ConfigKey__c testConfigKey2 = createConfigKey('KY_GBL_CreditRole', 'KY_GBL_CreditRole');
		LLC_BI__CFG_CKJ__c testCKJ = createConfigJoin(testConfigValue.Id, testConfigKey1.Id);
		CSA_ConfigValueMgmtController CVMC = new CSA_ConfigValueMgmtController();

		Test.startTest();

		CVMC.configValueId = testConfigValue.Id;
		CVMC.configValueEdit();

		Test.stopTest();
	}

	@isTest
	public static void configValueEditRoles() {
		LLC_BI__CFG_ConfigValue__c testConfigValue = createConfigValue('Roles_For_Multi-Renewal_Delete', 'Management,IT', 'ALL', 'ROLES_MULTI_DELETE');
		LLC_BI__CFG_ConfigKey__c testConfigKey1 = createConfigKey('KY_DM_ReviewerRoles', 'KY_DM_ReviewerRole');
		LLC_BI__CFG_ConfigKey__c testConfigKey2 = createConfigKey('KY_GBL_CreditRole', 'KY_GBL_CreditRole');
		LLC_BI__CFG_CKJ__c testCKJ = createConfigJoin(testConfigValue.Id, testConfigKey1.Id);
		CSA_ConfigValueMgmtController CVMC = new CSA_ConfigValueMgmtController();

		Test.startTest();

		CVMC.configValueId = testConfigValue.Id;
		CVMC.configValueEdit();

		Test.stopTest();
	}

	@isTest
	public static void configValueEditFields() {
		LLC_BI__CFG_ConfigValue__c testConfigValue = createConfigValue('Renewal_Fields_To_Clone', 'Name', 'ALL', 'FIELDS_TO_CLONE');
		LLC_BI__CFG_ConfigKey__c testConfigKey1 = createConfigKey('KY_DM_ReviewerRoles', 'KY_DM_ReviewerRole');
		LLC_BI__CFG_ConfigKey__c testConfigKey2 = createConfigKey('KY_GBL_CreditRole', 'KY_GBL_CreditRole');
		LLC_BI__CFG_CKJ__c testCKJ = createConfigJoin(testConfigValue.Id, testConfigKey1.Id);
		CSA_ConfigValueMgmtController CVMC = new CSA_ConfigValueMgmtController();

		Test.startTest();

		CVMC.configValueId = testConfigValue.Id;
		CVMC.configValueEdit();

		Test.stopTest();
	}

	@isTest
	public static void configValueEditIgnore() {
		LLC_BI__CFG_ConfigValue__c testConfigValue = createConfigValue('Renewal_Status_Superceded_String', 'Superseded', 'ALL', 'REN_STAT_SUPER_STR');
		LLC_BI__CFG_ConfigKey__c testConfigKey1 = createConfigKey('KY_DM_ReviewerRoles', 'KY_DM_ReviewerRole');
		LLC_BI__CFG_ConfigKey__c testConfigKey2 = createConfigKey('KY_GBL_CreditRole', 'KY_GBL_CreditRole');
		LLC_BI__CFG_CKJ__c testCKJ = createConfigJoin(testConfigValue.Id, testConfigKey1.Id);
		CSA_ConfigValueMgmtController CVMC = new CSA_ConfigValueMgmtController();

		Test.startTest();

		CVMC.configValueId = testConfigValue.Id;
		CVMC.configValueEdit();

		Test.stopTest();
	}

	@isTest
	public static void configValueEditNA() {
		LLC_BI__CFG_ConfigValue__c testConfigValue = createConfigValue('Renewal_Supported', 'Enabled', 'ALL', 'REN_SUPPORTED');
		LLC_BI__CFG_ConfigKey__c testConfigKey1 = createConfigKey('KY_DM_ReviewerRoles', 'KY_DM_ReviewerRole');
		LLC_BI__CFG_ConfigKey__c testConfigKey2 = createConfigKey('KY_GBL_CreditRole', 'KY_GBL_CreditRole');
		LLC_BI__CFG_CKJ__c testCKJ = createConfigJoin(testConfigValue.Id, testConfigKey1.Id);
		CSA_ConfigValueMgmtController CVMC = new CSA_ConfigValueMgmtController();

		Test.startTest();

		CVMC.configValueId = testConfigValue.Id;
		CVMC.configValueEdit();

		Test.stopTest();
	}

	@isTest
	public static void back() {
		LLC_BI__CFG_ConfigValue__c testConfigValue = createConfigValue('Renewal_Supported', 'Enabled', 'ALL', 'REN_SUPPORTED');
		LLC_BI__CFG_ConfigKey__c testConfigKey1 = createConfigKey('KY_DM_ReviewerRoles', 'KY_DM_ReviewerRole');
		LLC_BI__CFG_ConfigKey__c testConfigKey2 = createConfigKey('KY_GBL_CreditRole', 'KY_GBL_CreditRole');
		LLC_BI__CFG_CKJ__c testCKJ = createConfigJoin(testConfigValue.Id, testConfigKey1.Id);
		CSA_ConfigValueMgmtController CVMC = new CSA_ConfigValueMgmtController();

		Test.startTest();

		CVMC.configValueId = testConfigValue.Id;
		CVMC.configValueEdit();
		CVMC.back();

		Test.stopTest();
	}

	@isTest
	public static void configValueDelete() {
		LLC_BI__CFG_ConfigValue__c testConfigValue = createConfigValue('Renewal_Supported', 'Enabled', 'ALL', 'REN_SUPPORTED');
		LLC_BI__CFG_ConfigKey__c testConfigKey1 = createConfigKey('KY_DM_ReviewerRoles', 'KY_DM_ReviewerRole');
		LLC_BI__CFG_ConfigKey__c testConfigKey2 = createConfigKey('KY_GBL_CreditRole', 'KY_GBL_CreditRole');
		LLC_BI__CFG_CKJ__c testCKJ = createConfigJoin(testConfigValue.Id, testConfigKey1.Id);
		CSA_ConfigValueMgmtController CVMC = new CSA_ConfigValueMgmtController();

		Test.startTest();

		CVMC.configValueId = testConfigValue.Id;
		CVMC.configValueDelete();

		Test.stopTest();
	}

	@isTest
	public static void configValueSaveNew() {
		LLC_BI__CFG_ConfigKey__c testConfigKey1 = createConfigKey('KY_DM_ReviewerRoles', 'KY_DM_ReviewerRole');
		LLC_BI__CFG_ConfigKey__c testConfigKey2 = createConfigKey('KY_GBL_CreditRole', 'KY_GBL_CreditRole');
		CSA_ConfigValueMgmtController CVMC = new CSA_ConfigValueMgmtController();

		Test.startTest();

		CVMC.configValue = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__lookupKey__c = 'test_key',
			LLC_BI__Key__c = 'ALL');
		CVMC.selectedAvailableKeys = new List<String>{testConfigKey1.Id};
		CVMC.isSaveNew = false;
		CVMC.configValueSaveNew();

		Test.stopTest();
	}

	@isTest
	public static void configValueSaveNewAgain() {
		LLC_BI__CFG_ConfigKey__c testConfigKey1 = createConfigKey('KY_DM_ReviewerRoles', 'KY_DM_ReviewerRole');
		LLC_BI__CFG_ConfigKey__c testConfigKey2 = createConfigKey('KY_GBL_CreditRole', 'KY_GBL_CreditRole');
		CSA_ConfigValueMgmtController CVMC = new CSA_ConfigValueMgmtController();

		Test.startTest();

		CVMC.configValue = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__lookupKey__c = 'test_key',
			LLC_BI__Key__c = 'ALL');
		CVMC.selectedAvailableKeys = new List<String>{testConfigKey1.Id};
		CVMC.isSaveNew = true;
		CVMC.configValueSaveNew();

		Test.stopTest();
	}

	@isTest
	public static void configValueSaveEdit1() {
		LLC_BI__CFG_ConfigValue__c testConfigValue = createConfigValue('Status_Renewal_Allowed', 'Open', 'ALL', 'REN_STATUS_ALLOWED');
		LLC_BI__CFG_ConfigKey__c testConfigKey1 = createConfigKey('KY_DM_ReviewerRoles', 'KY_DM_ReviewerRole');
		LLC_BI__CFG_ConfigKey__c testConfigKey2 = createConfigKey('KY_GBL_CreditRole', 'KY_GBL_CreditRole');
		LLC_BI__CFG_CKJ__c testCKJ = createConfigJoin(testConfigValue.Id, testConfigKey1.Id);
		CSA_ConfigValueMgmtController CVMC = new CSA_ConfigValueMgmtController();

		Test.startTest();

		CVMC.configValueId = testConfigValue.Id;
		CVMC.configValueEdit();
		CVMC.selectedFieldValues = new List<String>{'Open'};
		CVMC.selectedAvailableKeys = new List<String>{testConfigKey2.Id};
		CVMC.selectedUsedKeys = new List<String>{testConfigKey1.Id};
		CVMC.configValueSaveEdit();
		Test.stopTest();
	}

	@isTest
	public static void configValueSaveEdit2() {
		LLC_BI__CFG_ConfigValue__c testConfigValue = createConfigValue('Renewal_Supported', 'Enabled', 'ALL', 'REN_SUPPORTED');
		LLC_BI__CFG_ConfigKey__c testConfigKey1 = createConfigKey('KY_DM_ReviewerRoles', 'KY_DM_ReviewerRole');
		LLC_BI__CFG_ConfigKey__c testConfigKey2 = createConfigKey('KY_GBL_CreditRole', 'KY_GBL_CreditRole');
		LLC_BI__CFG_CKJ__c testCKJ = createConfigJoin(testConfigValue.Id, testConfigKey1.Id);
		CSA_ConfigValueMgmtController CVMC = new CSA_ConfigValueMgmtController();

		Test.startTest();

		CVMC.configValueId = testConfigValue.Id;
		CVMC.configValueEdit();
		CVMC.selectedAvailableKeys = new List<String>{testConfigKey2.Id};
		CVMC.selectedUsedKeys = new List<String>{testConfigKey1.Id};
		CVMC.configValueSaveEdit();
		Test.stopTest();
	}

	@isTest
	public static void configValueSaveEdit3() {
		LLC_BI__CFG_ConfigValue__c testConfigValue = createConfigValue('Renewal_Status_Superceded_String', 'Superseded', 'ALL', 'REN_STAT_SUPER_STR');
		LLC_BI__CFG_ConfigKey__c testConfigKey1 = createConfigKey('KY_DM_ReviewerRoles', 'KY_DM_ReviewerRole');
		LLC_BI__CFG_ConfigKey__c testConfigKey2 = createConfigKey('KY_GBL_CreditRole', 'KY_GBL_CreditRole');
		LLC_BI__CFG_CKJ__c testCKJ = createConfigJoin(testConfigValue.Id, testConfigKey1.Id);
		CSA_ConfigValueMgmtController CVMC = new CSA_ConfigValueMgmtController();

		Test.startTest();

		CVMC.configValueId = testConfigValue.Id;
		CVMC.configValueEdit();
		CVMC.selectedAvailableKeys = new List<String>{testConfigKey2.Id};
		CVMC.selectedUsedKeys = new List<String>{testConfigKey1.Id};
		CVMC.configValueSaveEdit();
		Test.stopTest();
	}

	@isTest
	public static void stagePicklist() {
		CSA_ConfigValueMgmtController CVMC = new CSA_ConfigValueMgmtController();

		Test.startTest();

		CVMC.getStagePicklist();

		Test.stopTest();
	}

	@isTest
	public static void statusPicklist() {
		CSA_ConfigValueMgmtController CVMC = new CSA_ConfigValueMgmtController();

		Test.startTest();

		CVMC.getStatusPicklist();

		Test.stopTest();
	}

	@isTest
	public static void rolePicklist() {
		CSA_ConfigValueMgmtController CVMC = new CSA_ConfigValueMgmtController();

		Test.startTest();

		CVMC.getRolesPicklist();

		Test.stopTest();
	}

	@isTest
	public static void fieldPicklist() {
		CSA_ConfigValueMgmtController CVMC = new CSA_ConfigValueMgmtController();

		Test.startTest();

		CVMC.getFieldAPIPickList();

		Test.stopTest();
	}

	private static LLC_BI__CFG_ConfigValue__c createConfigValue(String category,String fieldvalue, String key, String lookupKey) {
		LLC_BI__CFG_ConfigValue__c newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = category,
			LLC_BI__fieldValue__c = fieldvalue,
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

	private static LLC_BI__CFG_CKJ__c createConfigJoin(Id configValueId, Id configKeyId) {
		LLC_BI__CFG_CKJ__c newCKJ = new LLC_BI__CFG_CKJ__c(
			LLC_BI__CFG_ConfigValue__c = configValueId,
			LLC_BI__CFG_ConfigKeys__c = configKeyId);

		Database.insert(newCKJ);
		return newCKJ;
	}
}
@isTest
public class TestCSA_CustSuccessConfigController {
	@isTest
	public static void isInstalledFalse() {
		CSA_CustomerSuccessAdminConfigController CSACC = new CSA_CustomerSuccessAdminConfigController();

		Test.startTest();

		CSACC.getIsInstalled();

		Test.stopTest();
	}

	@isTest
	public static void isInstalledTrue() {
		LLC_BI__System_Properties__c testSystemProperty = createSystemProperty();
		CSA_CustomerSuccessAdminConfigController CSACC = new CSA_CustomerSuccessAdminConfigController();

		Test.startTest();

		CSACC.getIsInstalled();

		Test.stopTest();
	}

	@isTest
	public static void installSuccess() {
		nFORCE__Group__c testGroup = createGroup('nCino Administration', 'admin');
		CSA_CustomerSuccessAdminConfigController CSACC = new CSA_CustomerSuccessAdminConfigController();

		Test.startTest();

		CSACC.install();

		Test.stopTest();
	}

	@isTest
	public static void installFail() {
		CSA_CustomerSuccessAdminConfigController CSACC = new CSA_CustomerSuccessAdminConfigController();

		Test.startTest();

		CSACC.install();

		Test.stopTest();
	}

	@isTest
	public static void uninstall() {
		CSA_CustomerSuccessAdminConfigController CSACC = new CSA_CustomerSuccessAdminConfigController();

		Test.startTest();

		CSACC.uninstall();

		Test.stopTest();
	}

	@isTest
	public static void finish() {
		CSA_CustomerSuccessAdminConfigController CSACC = new CSA_CustomerSuccessAdminConfigController();

		Test.startTest();

		CSACC.finish();

		Test.stopTest();
	}

	private static LLC_BI__System_Properties__c createSystemProperty() {
		LLC_BI__System_Properties__c newSP = new LLC_BI__System_Properties__c(
			Name = '123456789987645321132',
			LLC_BI__Category_Name__c = 'CSA Customer Success Admin',
			LLC_BI__Is_Active__c = true,
			LLC_BI__Key__c = 'Is_Installed_CSA_Admin',
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
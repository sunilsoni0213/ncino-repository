@isTest
public class TestCSA_CustSuccessAdminDataInstaller {
	
	@isTest
	public static void install() {
		nFORCE__Group__c testGroup = createGroup('nCino Administration', 'admin');
		CSA_CustomerSuccessAdminDataInstaller dataInstaller = new CSA_CustomerSuccessAdminDataInstaller();
		Test.testInstall(dataInstaller, null);
	}

	@isTest
	public static void uninstall() {
		nFORCE__Group__c testGroup = createGroup('nCino Administration', 'admin');
		nFORCE__Route__c testRoute1 = createRoute('Customer Success Administration', 'c__CSA_AdminLandingPage', 'csa-admin');
		nFORCE__Route__c testRoute2 = createRoute('Credit Memo Config', 'c__CSA_CreditMemoConfig', 'credit-memo-config');
		nFORCE__Route__c testRoute3 = createRoute('Config Value Mgmt', 'c__CSA_ConfigValueMgmt', 'config-value-mgmt');
		nFORCE__Route__c testRoute4 = createRoute('PSC Config Tool', 'c__CSA_PSCConfiguration', 'psc-config');
		nFORCE__Route_Group__c testRouteGroup1 = createRouteGroup(testGroup.Id, testRoute1.Id, null, 10);
		nFORCE__Route_Group__c testRouteGroup2 = createRouteGroup(testGroup.Id, testRoute2.Id, testRoute1.Id, 0);
		nFORCE__Route_Group__c testRouteGroup3 = createRouteGroup(testGroup.Id, testRoute3.Id, testRoute1.Id, 1);
		nFORCE__Route_Group__c testRouteGroup4 = createRouteGroup(testGroup.Id, testRoute4.Id, testRoute1.Id, 2);
		LLC_BI__System_Properties__c testSystemProperty = createSystemProperty();
		Test.testUninstall(new CSA_CustomerSuccessAdminDataInstaller());
	}

	private static nForce__Group__c createGroup(String nam, String app) {
		nForce__Group__c newG = new nForce__Group__c(
			Name = nam,
			nFORCE__App__c = app);

		Database.insert(newG);
		return newG;
	}

	private static nForce__Route__c createRoute(String nam, String body, String app) {
		nForce__Route__c newR = new nForce__Route__c(
			Name = nam,
			nFORCE__Body__c = body,
			nForce__App__c = app,
			nFORCE__Navigation__c = 'nforce__navigation',
			nFORCE__Sub_Navigation__c = 'nforce__sub_navigation',
			nFORCE__Topbar__c = 'nforce__topbar');

		Database.insert(newR);
		return newR;
	}

	private static nFORCE__Route_Group__c createRouteGroup(Id groupId, Id routeId, Id parentRouteId, Decimal display) {
		nFORCE__Route_Group__c newRG = new nFORCE__Route_Group__c(
			nFORCE__Group__c = groupId,
			nFORCE__Route__c = routeId,
			nFORCE__Parent_Route__c = parentRouteId,
			nFORCE__Order__c = display);

		Database.insert(newRG);
		return newRG;
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
}
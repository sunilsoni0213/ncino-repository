@isTest
public class TestCSA_OverviewDataInstaller {
	
	@isTest
	public static void install() {
		nForce__Group__c testGroup = createGroup('nCino Admin', 'admin');
		CSA_OverviewDataInstaller dataInstaller = new CSA_OverviewDataInstaller();
		Test.testInstall(dataInstaller, null);
	}

	@isTest
	public static void installWithExistingRoutes() {
		nForce__Group__c testGroup = createGroup('nCino Admin', 'admin');
		nFORCE__Route__c testRoute = createRoute('CSA Admin', 'c__CSA_CustomerSuccessAdmin', 'csa-admin');
		nFORCE__Route_Group__c testRouteGroup1 = createRouteGroup(testGroup.Id, testRoute.Id, null, 10);
		nFORCE__Route_Group__c testRouteGroup2 = createRouteGroup(testGroup.Id, testRoute.Id, testRoute.Id, 0);
		CSA_OverviewDataInstaller dataInstaller = new CSA_OverviewDataInstaller();
		Test.testInstall(dataInstaller, null);
	}

	@isTest
	public static void uninstall() {
		nForce__Group__c testGroup = createGroup('nCino Admin', 'admin');
		nFORCE__Route__c testRoute = createRoute('Overview Config', 'c__CSA_OverviewConfigAdmin', 'overview-config');
		nFORCE__Route_Group__c testRouteGroup1 = createRouteGroup(testGroup.Id, testRoute.Id, null, 10);
		nFORCE__Route_Group__c testRouteGroup2 = createRouteGroup(testGroup.Id, testRoute.Id, testRoute.Id, 0);
		Test.testUninstall(new CSA_OverviewDataInstaller());
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
}
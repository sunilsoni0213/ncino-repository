@isTest
private class TestDataInstaller {
	
	@isTest
	static void testDataInstallerOnInstall() {
		Test.startTest();

		DataInstaller installer = new DataInstaller();
		installer.onInstall(null);

		List<nFORCE__Route__c> installedRoutes = getInstalledRoutes();

		System.assertEquals(4, installedRoutes.size());

		Test.stopTest();
	}

	@isTest
	static void testDataInstallerOnUninstall() {
		Test.startTest();

		DataInstaller installer = new DataInstaller();
		installer.onInstall(null);

		List<nFORCE__Route__c> installedRoutes = getInstalledRoutes();

		System.assertEquals(4, installedRoutes.size());
		
		installer.onUninstall(null);
		installedRoutes = getInstalledRoutes();

		Test.stopTest();
	}

	@isTest
	static void testDefaultRouteConfiguration(){
		Test.startTest();

		DataInstaller installer = new DataInstaller();
		installer.onInstall(null);

		List<nFORCE__Route__c> installedRoutes = getInstalledRoutes();
		List<nFORCE__Route_Group__c> installedTypeRouteGroups;

		for(nFORCE__Route__c route : installedRoutes){
			if(route.nFORCE__App__c == 'tm-config-mt'){
				installedTypeRouteGroups = getRouteGroups(route.Id);
			}
		}

		System.assertEquals(1, installedTypeRouteGroups.size());
		System.assertEquals(false, installedTypeRouteGroups[0].nFORCE__Is_Default_Context_Child__c);

		Test.stopTest();
	}

	private static List<nFORCE__Route__c> getInstalledRoutes(){
		List<nFORCE__Route__c> routes = [
			SELECT
				Id,
				Name,
				nFORCE__App__c,
				nFORCE__Body__c
			FROM
				nFORCE__Route__c
		];
		if(routes.size() > 0){
			return routes;
		}
		return null;
	}

	private static List<nFORCE__Route_Group__c> getRouteGroups(Id routeId){
		List<nFORCE__Route_Group__c> routeGroups = 
			[
				SELECT
					Id,
					Name,
					nFORCE__Route__r.Name,
					nFORCE__Route__c,
					nFORCE__Order__c,
					nFORCE__Is_Default_Context_Child__c
				FROM
					nFORCE__Route_Group__c
				WHERE
					nFORCE__Route__c = :routeId
			];
		return routeGroups;
	}
	
}
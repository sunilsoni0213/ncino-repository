global with sharing class DataInstaller implements InstallHandler, UninstallHandler {
	global void onInstall(InstallContext context){
		createNewConfig();
		createConfigLayout();
	}

	global void onUninstall(UninstallContext context){
		Map<Id, nFORCE__Group__c> groupMap =
			new Map<Id, nFORCE__Group__c> (
				[
					SELECT
						Id,
						Name
					FROM
						nFORCE__Group__c
					WHERE
						Name =: NCINO_ADMINISTRATION
					AND
						nFORCE__App__c =: NCINO_ADMIN_APP
				]
			);

		Map<Id, nFORCE__Route_Group__c> routeGroupMap =
			new Map<Id, nFORCE__Route_Group__c> (
				[
					SELECT
						Id,
						Name,
						nFORCE__Route__c,
						nFORCE__Route__r.Id,
						nFORCE__Parent_Route__c,
						nFORCE__Parent_Route__r.Id
					FROM
						nFORCE__Route_Group__c
					WHERE
						nFORCE__Group__c IN  :groupMap.keySet()
				]
			);
		
		Set<Id> routeIdSet = new Set<Id>();

		for (nFORCE__Route_Group__c rg : routeGroupMap.values()) {
			if (rg.nFORCE__Route__c != null) {
				routeIdSet.add(rg.nFORCE__Route__c);
			}
			if (rg.nFORCE__Parent_Route__c != null) {
				routeIdSet.add(rg.nFORCE__Parent_Route__c);
			}
		}
		
		Map<Id, nFORCE__Route__c> routeMap = 
			new Map<Id, nFORCE__Route__c> (
				[
					SELECT
						Id,
						Name
					FROM
						nFORCE__Route__c
					WHERE
						Id IN  :routeIdSet
				]
			);		

		Database.Delete(routeGroupMap.values());
		Database.Delete(routeMap.values());
		Database.Delete(groupMap.values());
		
		TMCUtility.deleteSystemProperty(
    		TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
    		TreasuryConfigurationConstants.TM_CONFIG_IS_PRODUCTION_KEY
		);
		
	}
	
	private static void createNewConfig(){
		sObject property = 
			TMCUtility.createSystemProperty(
				null,
				TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
				TreasuryConfigurationConstants.TM_CONFIG_IS_PRODUCTION_KEY,
				'true',
				true,
				true
			);
	}

	private static void createConfigLayout(){
		nFORCE__Group__c g1 = createGroup();
		nFORCE__Route__c parentRoute = getParentRoute();
		List<nFORCE__Route__c> routes = createMaintenanceRoutes();
		createRouteGroups(routes, g1.Id, parentRoute.Id);
	}

	private static nFORCE__Route__c getParentRoute() {
		List<nFORCE__Route__c> parentRoute = [
			SELECT
				Id,
				nFORCE__App__c,
				Name
			FROM
				nFORCE__Route__c
			WHERE
				nFORCE__App__c = :TM_CONFIG_APP_NAME
		];
		if (parentRoute == null || parentRoute.size() ==0) {
			parentRoute = new List<nFORCE__Route__c>();
			parentRoute.add(new nFORCE__Route__c(
				Name = TM_PARENT_ROUTE_NAME,
				nFORCE__App__c = TM_CONFIG_APP_NAME,
				nFORCE__Topbar__c = 'nforce__ngTopbar',
				nFORCE__Body__c = 'LLC_BI__ProductCatalog',
				nFORCE__Navigation__c = 'nforce__Navigation',
				nFORCE__Sub_Navigation__c = 'nFORCE__Sub_Navigation',
				nFORCE__Icon_Class__c = 'n-icon-treasury_configuration'
			));
			insert parentRoute;
		}
		return parentRoute[0];
	}

	private static nFORCE__Group__c createGroup(){
		List<nFORCE__Group__c> group1 = [
			SELECT
				Id,
				Name,
				nFORCE__App__c
			FROM
				nFORCE__Group__c
			WHERE
				nFORCE__App__c = :NCINO_ADMIN_APP
			AND
				Name = : NCINO_ADMINISTRATION
			LIMIT 1
		];

		if (group1 == null || group1.size() ==0) {
			group1.add(new nFORCE__Group__c(
				Name = NCINO_ADMINISTRATION,
				nFORCE__App__c = NCINO_ADMIN_APP
			));
				insert group1;
		}
		return group1[0];
	}

	private static void createRouteGroups(List<nFORCE__Route__c> routes, Id groupId, Id parentId){
		List<nFORCE__Route_Group__c> routeGroups = new List<nFORCE__Route_Group__c>();
		Integer i = 2;
		for(nFORCE__Route__c route : routes){
			Boolean isDefault = false;
			nFORCE__Route_Group__c routeGroup = new nFORCE__Route_Group__c(
				nFORCE__Group__c = groupId,
				nFORCE__Route__c = route.Id,
				nFORCE__Parent_Route__c = parentId,
				nFORCE__Order__c = i
			);
			routeGroups.add(routeGroup);
			i++;
		}
		insert routeGroups;
	}

	private static List<nFORCE__Route__c> createMaintenanceRoutes(){
		List<nFORCE__Route__c> newRoutes = new List<nFORCE__Route__c>();
		newRoutes.add(new nFORCE__Route__c(
			Name = 'Maintenance Types',
			nFORCE__App__c = 'tm-config-mt',
			nFORCE__Is_Hidden__c = false,
			nFORCE__Topbar__c = 'nforce__topbar',
			nFORCE__Body__c = TM_NS + 'MaintenanceTypeConfig',
			nFORCE__Navigation__c = 'nforce__navigation',
			nFORCE__Sub_Navigation__c = 'nforce__sub_navigation',
			nFORCE__Icon_Class__c = 'n-icon-treasury_configuration'));
		newRoutes.add(new nFORCE__Route__c(
			Name = 'Maintenance Checklist Items',
			nFORCE__App__c = 'tm-config-cl-actions',
			nFORCE__Is_Hidden__c = false,
			nFORCE__Topbar__c = 'nforce__topbar',
			nFORCE__Body__c = TM_NS + 'MaintenanceChecklist',
			nFORCE__Navigation__c = 'nforce__navigation',
			nFORCE__Sub_Navigation__c = 'nforce__sub_navigation',
			nFORCE__Icon_Class__c = 'n-icon-treasury_configuration'));
		newRoutes.add(new nFORCE__Route__c(
			Name = 'Checklist Map',
			nFORCE__App__c = 'tm-config-map-types',
			nFORCE__Is_Hidden__c = false,
			nFORCE__Topbar__c = 'nforce__topbar',
			nFORCE__Body__c = TM_NS + 'MaintenanceMapping',
			nFORCE__Navigation__c = 'nforce__navigation',
			nFORCE__Sub_Navigation__c = 'nforce__sub_navigation',
			nFORCE__Icon_Class__c = 'n-icon-treasury_configuration'));
		insert newRoutes;
		return newRoutes;
	}

	/**
	* Routing Configuration Constants
	*/
	private static final String TM_PARENT_ROUTE_NAME = 'Treasury Configuration';
	private static final String TM_CONFIG_APP_NAME = 'treasury-configuration';
	private static final String NCINO_ADMIN_APP = 'admin';
	private static final String NCINO_ADMINISTRATION = 'nCino Administration';
	private static String TM_NS = (TMCUtility.getConfigNamespace() != null ? TMCUtility.getConfigNamespace() + '__' : 'c__');

}
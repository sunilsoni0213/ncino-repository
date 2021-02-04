global class CSA_CustomerSuccessAdminDataInstaller implements InstallHandler, UninstallHandler {
    global void onInstall(InstallContext context) {
        LLC_BI__System_Properties__c property = this.getCreateSystemProperty(PROPERTYCATEGORY, 
																			 PROPERTYACTIVE, 
																			 PROPERTYKEY, 
																			 PROPERTYVALUE);

		Database.insert(property);

		nFORCE__Group__c adminGroup = getAdminGroup();
		nForce__Route__c newR1 = getCreateRoute(ROUTE1NAME, 
												ROUTE1BODY, 
												ROUTE1APP,
												ROUTENAVIGATION, 
												ROUTESUBNAV, 
												ROUTETOPBAR);
		
		nForce__Route__c newR2 = getCreateRoute(ROUTE2NAME, 
												ROUTE2BODY, 
												ROUTE2APP,
												ROUTENAVIGATION, 
												ROUTESUBNAV, 
												ROUTETOPBAR);

		nForce__Route__c newR3 = getCreateRoute(ROUTE3NAME, 
												ROUTE3BODY, 
												ROUTE3APP,
												ROUTENAVIGATION, 
												ROUTESUBNAV, 
												ROUTETOPBAR);

		nForce__Route__c newR4 = getCreateRoute(ROUTE4NAME, 
												ROUTE4BODY, 
												ROUTE4APP,
												ROUTENAVIGATION, 
												ROUTESUBNAV, 
												ROUTETOPBAR);

		Database.insert(newR1);
		Database.insert(newR2);
		Database.insert(newR3);
		Database.insert(newR4);

		List<nFORCE__Route_Group__c> newRouteGroups = new List<nFORCE__Route_Group__c>();

		newRouteGroups.add(getRouteGroup(adminGroup.Id, newR1.Id, null, 10));
		newRouteGroups.add(getRouteGroup(adminGroup.Id, newR2.Id, newR1.Id, 0));
		newRouteGroups.add(getRouteGroup(adminGroup.Id, newR3.Id, newR1.Id, 1));
		newRouteGroups.add(getRouteGroup(adminGroup.Id, newR4.Id, newR1.Id, 2));

		Database.insert(newRouteGroups);
    }

	global void onUninstall(UninstallContext context) {
		List<nForce__Route__c> routes = this.getRoutes(ROUTE1BODY, ROUTE2BODY, ROUTE3BODY, ROUTE4BODY);
		List<nForce__Route_Group__c> routeGroups = new List<nForce__Route_Group__c>();
		if (!routes.isEmpty()) {
			routeGroups = this.getRouteGroups(routes);
			Database.delete(routeGroups);
			Database.delete(routes);
		}

		List<LLC_BI__System_Properties__c> systemProperties = this.getSystemProperties(PROPERTYCATEGORY, 
																					   PROPERTYKEY);

		if (!systemProperties.isEmpty()) {
			Database.delete(systemProperties);
		}
	}

	private List<nForce__Route__c> getRoutes(String body1, String body2, 
											 String body3, String body4) {
		return [SELECT
					Id
				FROM
					nForce__Route__c
				WHERE 
					nForce__Body__c = :body1
				OR
					nForce__Body__c = :body2
				OR
					nForce__Body__c = :body3
				OR
					nForce__Body__c = :body4];
	}

	private List<nFORCE__Route_Group__c> getRouteGroups(List<nForce__Route__c> routes) {
		String[] ids = new List<String>();
		for (nForce__Route__c r: routes) {
			ids.add(r.Id);
		}

		return [SELECT
					Id
				FROM 
					nFORCE__Route_Group__c
				WHERE
					nForce__Route__c IN :ids
				OR
					nFORCE__Parent_Route__c IN :ids];
	}

	private nFORCE__Group__c getAdminGroup() {
		return [SELECT
					Id
				FROM 
					nFORCE__Group__c
				WHERE 
					nFORCE__App__c = :GROUPAPP];
	}

	private nFORCE__Route_Group__c getRouteGroup(Id getAdminGroup, 
												 Id route, 
												 Id parentRoute, 
												 DEcimal dOrder) {
		nFORCE__Route_Group__c newRG = new nFORCE__Route_Group__c(
			nFORCE__Group__c = getAdminGroup,
			nFORCE__lookupKey__c = generateRandomString(18),
			nFORCE__Order__c = dOrder,
			nFORCE__Parent_Route__c = parentRoute,
			nFORCE__Route__c = route);

		return newRG;
	}

	private nForce__Route__c getCreateRoute(String name, 
											String body,
											String app, 
											String nav, 
											String subNav, 
											String topbar) {
		nForce__Route__c newR = new nForce__Route__c(
			Name = name,
			nFORCE__Body__c = body,
			nForce__App__c = app,
			nFORCE__lookupKey__c = generateRandomString(18),
			nFORCE__Navigation__c = nav,
			nFORCE__Sub_Navigation__c = subnav,
			nFORCE__Topbar__c = topbar);

		return newR;
	}

	private List<LLC_BI__System_Properties__c> getSystemProperties(String category, String key) {
		return [SELECT
					Id
				FROM
					LLC_BI__System_Properties__c
				WHERE 
					LLC_BI__Category_Name__c = :category
				AND
					LLC_BI__Key__c = :key];
	}

	private LLC_BI__System_Properties__c getCreateSystemProperty(String category, 
																 Boolean active, 
																 String key, 
																 String value) {
		LLC_BI__System_Properties__c newSP = new LLC_BI__System_Properties__c(
			Name = generateRandomString(18),
			LLC_BI__Category_Name__c = category,
			LLC_BI__Is_Active__c = active,
			LLC_BI__Key__c = key,
			LLC_BI__Value__c = value);

		return newSP;
	}

	public static String generateRandomString(Integer len) {
		final String chars = NUMBERSFORRANDOMIZER;
		String randStr = BLANK;
		while (randStr.length() < len) {
			Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
			randStr += chars.substring(idx, idx + 1);
		}
		return randStr; 
	}

	private static final String PROPERTYCATEGORY = 'CSA Customer Success Admin';
	private static final Boolean PROPERTYACTIVE = true;
	private static final String PROPERTYKEY = 'Is_Installed_CSA_Admin';
	private static final String PROPERTYVALUE = 'true';
	private static final String NUMBERSFORRANDOMIZER = '0123456789';
	private static final String BLANK = '';
	private static final String GROUPAPP = 'admin';
	private static final String ROUTENAVIGATION = 'nforce__navigation';
	private static final String ROUTESUBNAV = 'nforce__sub_navigation';
	private static final String ROUTETOPBAR = 'nforce__topbar';

	private static final String ROUTE1NAME = 'Customer Success Administration';
	private static final String ROUTE1APP = 'csa-admin';
	private static final String ROUTE1BODY = 'c__CSA_AdminLandingPage';
	private static final String ROUTE2NAME = 'Credit Memo Config';
	private static final String ROUTE2APP = 'credit-memo-config';
	private static final String ROUTE2BODY = 'c__CSA_CreditMemoConfig';
	private static final String ROUTE3NAME = 'Config Value Mgmt';
	private static final String ROUTE3APP = 'config-value-mgmt';
	private static final String ROUTE3BODY = 'c__CSA_ConfigValueMgmt';
	private static final String ROUTE4NAME = 'PSC Config Tool';
	private static final String ROUTE4APP = 'psc-config';
	private static final String ROUTE4BODY = 'c__CSA_PSCConfiguration';
}
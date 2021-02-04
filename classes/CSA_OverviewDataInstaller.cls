global class CSA_OverviewDataInstaller implements InstallHandler, UninstallHandler{ 
	global void onInstall(InstallContext context) {
		List<Overview_Properties__c> overviewProperties = new List<Overview_Properties__c>();
		List<nFORCE__Route_Group__c> newRouteGroups = new List<nFORCE__Route_Group__c>();
		Integer count1 = 1;
		Integer count2 = 1;
		Integer count3 = 1;
		
		LLC_BI__System_Properties__c property = this.getCreateSystemProperty(PROPERTYCATEGORY, 
																			 PROPERTYACTIVE, 
																			 PROPERTYKEY, 
																			 PROPERTYVALUE);

		Database.insert(property);
		
		for (Schema.PicklistEntry p: getStagePicklist()) {
			overviewProperties.add(new Overview_Properties__c(
				Name = generateRandomString(18),
				Stage_Status_Product_Line_Name__c = p.value,
				Category_Name__c = USABLESTAGE,
				Report_Name__c = BLANK,
				Report_Id__c = BLANK, 
				Order__c = count1,
				Is_Active__c = true));

			count1 += 1;
		}

		for (Schema.PicklistEntry p: getStatusPicklist()) {
			overviewProperties.add(new Overview_Properties__c(
				Name = generateRandomString(18),
				Stage_Status_Product_Line_Name__c = p.value,
				Category_Name__c = USABLESTATUS,
				Report_Name__c = BLANK,
				Report_Id__c = BLANK,
				Order__c = count2,
				Is_Active__c = true));

			count2 += 1;
		}

		for (Schema.PicklistEntry p: getProductLinePicklist()) {
			overviewProperties.add(new Overview_Properties__c(
				Name = generateRandomString(18),
				Stage_Status_Product_Line_Name__c = p.value,
				Category_Name__c = USABLEPRODUCTLINE,
				Report_Name__c = BLANK,
				Report_Id__c = BLANK, 
				Order__c = count3,
				Is_Active__c = true));

			count3 += 1;
		}

		Database.insert(overviewProperties);

		nFORCE__Group__c adminGroup = getAdminGroup();
		List<nForce__Route__c> csaAdmin = getRouteCSA();
		nForce__Route__c newR1 = getCreateRoute(ROUTE1NAME, 
												ROUTE1BODY, 
												ROUTE1APP,
												ROUTENAVIGATION, 
												ROUTESUBNAV, 
												ROUTETOPBAR);

		Database.insert(newR1);
		
		if (csaAdmin.isEmpty()) {
			newRouteGroups.add(getRouteGroup(adminGroup.Id, newR1.Id, null, 20));
			newRouteGroups.add(getRouteGroup(adminGroup.Id, newR1.Id, newR1.Id, 0));
		} else {
			newRouteGroups.add(getRouteGroup(adminGroup.Id, newR1.Id, csaAdmin.get(0).Id, 20));
		}
		
		Database.insert(newRouteGroups);
	}

	global void onUninstall(UninstallContext context) {
		List<nForce__Route__c> routes = this.getRoutes(ROUTE1BODY);
		List<nForce__Route_Group__c> routeGroups = new List<nForce__Route_Group__c>();
		if (!routes.isEmpty()) {
			routeGroups = this.getRouteGroups(routes);
			Database.delete(routeGroups);
			Database.delete(routes);
		}

		List<Overview_Properties__c> overviewProperties = getOverviewProperties();

		Database.delete(overviewProperties);

		List<LLC_BI__System_Properties__c> systemProperties = this.getSystemProperties(PROPERTYCATEGORY, 
																					   PROPERTYKEY);

		Database.delete(systemProperties);
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

	private List<nForce__Route__c> getRoutes(String body) {
		return [SELECT
					Id
				FROM
					nForce__Route__c
				WHERE 
					nForce__Body__c = :body];
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
					nForce__Parent_Route__c IN :ids];
	}

	private nFORCE__Group__c getAdminGroup() {
		return [SELECT
					Id
				FROM 
					nFORCE__Group__c
				WHERE 
					nFORCE__App__c = :GROUPAPP LIMIT 1];
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

	private List<nForce__Route__c> getRouteCSA() {
		return [SELECT
					Id
				FROM
					nForce__Route__c
				WHERE
					nFORCE__App__c = :CSAAPPNAME LIMIT 1];
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

	private List<Overview_Properties__c> getOverviewProperties() {
		return [SELECT 
					Id
				FROM 
					Overview_Properties__c];
	}

	private List<Schema.PicklistEntry> getStagePicklist() {
        return LLC_BI__Loan__c.LLC_BI__Stage__c.getDescribe().getPicklistValues();
    }

    private List<Schema.PicklistEntry> getStatusPicklist() {
        return LLC_BI__Loan__c.LLC_BI__Status__c.getDescribe().getPicklistValues();
    }

	private List<Schema.PicklistEntry> getProductLinePicklist() {
        return LLC_BI__Loan__c.LLC_BI__Product_Line__c.getDescribe().getPicklistValues();
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

	private static final String NUMBERSFORRANDOMIZER = '1234567890';
	private static final String BLANK = '';
	private static final String USABLESTAGE = 'Usable_Stage';
	private static final String USABLESTATUS = 'Usable_Status';
	private static final String USABLEPRODUCTLINE = 'Usable_Product_Line';
	private static final String PROPERTYCATEGORY = 'CSA Overview';
	private static final Boolean PROPERTYACTIVE = true;
	private static final String PROPERTYKEY = 'Is_Installed_CSA_Overview';
	private static final String PROPERTYVALUE = 'true';
	private static final String GROUPAPP = 'admin';
	private static final String CSAAPPNAME = 'csa-admin';
	private static final String ROUTENAVIGATION = 'nforce__navigation';
	private static final String ROUTESUBNAV = 'nforce__sub_navigation';
	private static final String ROUTETOPBAR = 'nforce__topbar';
	private static final String ROUTE1NAME = 'Overview Config';
	private static final String ROUTE1APP = 'overview-config';
	private static final String ROUTE1BODY = 'c__CSA_OverviewConfigAdmin';
}
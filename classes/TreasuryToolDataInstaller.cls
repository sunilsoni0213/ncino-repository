public with sharing class TreasuryToolDataInstaller implements InstallHandler, UninstallHandler {
	/**
	* Installs single configuration record into nFORCE administration config table
	*
	* @param  Null installation context can be passed
	* @return None
	*
	**/
	public void onInstall(InstallContext context) {
		
		nFORCE__System_Configuration__c config = getConfigurationRecord(TREASURY_TOOL);

		if (config == null) {
			config = 
				createSystemConfigurationRecord(
					TREASURY_TOOL,
					true,
					true,
					true,
					URL.getSalesforceBaseUrl().toExternalForm() + TREASURY_TOOL_PAGE + '?' + TREASURY_APP_START_LOCATOR,
					null,
					true,
					Label.Treasury_Tool_Help,
					true
				);
		}
	}
	
	/**
	* Uninstalls the dictionary configuration record from the nFORCE adminstration config table
	*
	* @param  Null installation context can be passed
	* @return None
	*
	**/
	public void onUninstall(UninstallContext context){

		nFORCE__System_Configuration__c config = getConfigurationRecord(TREASURY_TOOL);
		
		if(config != null){
			Database.delete(config);
		}
	}
	
	/**
	* Private Methods
	**/
	private nFORCE__System_Configuration__c getConfigurationRecord(String name) {
		return 
			nFORCE__System_Configuration__c.getAll().get(name);
	}
		
	private nFORCE__System_Configuration__c createSystemConfigurationRecord(
		String name,
		Boolean isActive,
		Boolean allowsReconfiguration,
		Boolean isLink,
		String linkURL,
		String className,
		Boolean isConfigured,
		String helpText,
		Boolean insertRecord
	) {
		nFORCE__System_Configuration__c systemConfigRecord =  
			new nFORCE__System_Configuration__c(
				Name = name,
				nFORCE__Is_Active__c = isActive,
				nFORCE__Allows_Reconfiguration__c = allowsReconfiguration,
				nFORCE__Is_Link__c = isLink,
				nFORCE__Link_URL__c = linkURL,
				nFORCE__Class_Name__c = className,
				nFORCE__Is_Configured__c = isConfigured,
				nFORCE__Help_Text__c = helpText
			);
		if (insertRecord) {
			Database.insert(systemConfigRecord);
		}
		return systemConfigRecord;
	}
	
	public static final String TREASURY_TOOL_PAGE = Page.TreasuryConfigUI.getURL();
	public static final String TREASURY_TOOL = 'Treasury Tool';
	public static final String TREASURY_APP_START_LOCATOR = 'app=treasury-config.tm-config-system';
}
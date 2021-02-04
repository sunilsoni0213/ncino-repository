public class CSA_ConfigValueConfigController {
	public String successMessage {get;Set;}
	public String errorMessage {get;Set;}

	public Boolean getIsInstalled() {
		List<LLC_BI__System_Properties__c> property = this.getProperty(PROPERTYCATEGORY,
																	   PROPERTYKEY);
		if (property.isEmpty()) {
			return false;
		} else {
			return true;
		}
	}

	public void install() {
		try {
			new CSA_ConfigValueDataInstaller().onInstall(null);
			this.successMessage = System.Label.Config_Value_Config_Success_Install;
		} catch (Exception ex) {
			this.errorMessage = ex.getMessage();
		}
	}

	public void uninstall() {
		try {	        
			new CSA_ConfigValueDataInstaller().onUninstall(null);
			this.successMessage = System.Label.Config_Value_Config_Success_Uninstall;
		} catch (Exception ex) {
			this.errorMessage = ex.getMessage();
		}
	}

	public PageReference finish() {
		PageReference pageRef = new PageReference(INSTALLEDPACKAGEURL);
		return pageRef;
	}

	private List<LLC_BI__System_Properties__c> getProperty(String category, 
														   String key) {
		return [SELECT
					Id
				FROM
					LLC_BI__System_Properties__c
				WHERE
					LLC_BI__Category_Name__c = :CATEGORY
				AND
					LLC_BI__Key__c = :key];
	}

	private static final String INSTALLEDPACKAGEURL= '/0A3';
	private static final String PROPERTYCATEGORY = 'CSA Config Admin';
	private static final String PROPERTYKEY = 'Is_Installed_Config_Values';
}
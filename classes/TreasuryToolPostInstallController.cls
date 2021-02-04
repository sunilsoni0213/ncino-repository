public with sharing class TreasuryToolPostInstallController {
	public Boolean isInstalled {get; set;}
	public Boolean isToolDataInstalled {get; set;}

	/**
	* Parameterless constructor
	*
	**/
	public TreasuryToolPostInstallController() {
		this.isInstalled = TMCUtility.isConfigurationToolInstalled();
		this.isToolDataInstalled = TMCUtility.isToolDataInstalled();
	}
	
	/**
	* Performs configuration installation when called from a VF page
	* Loads tool configuration records first
	* Loads initial usage configuration records second
	*
	* @param  None
	* @return Page reference to current page
	*
	*/
	public PageReference performInstall() {
		if (!this.isInstalled) {
			installToolInstallData(true, true);
			installInitialData(true, true);

			TreasuryConfigurationConstants.SYSTEM_PROPERTIES.clearCache();
			
			this.isInstalled = TMCUtility.isConfigurationToolInstalled();
			this.isToolDataInstalled = TMCUtility.isToolDataInstalled();
			
			ApexPages.addMessage(
				new ApexPages.Message(
					ApexPages.Severity.CONFIRM,CONFIGURATION_INSTALLED_SUCCESSFULLY));
		} else {
			ApexPages.addMessage(
				new ApexPages.Message(
					ApexPages.Severity.INFO,CONFIGURATION_SYSTEM_ALREADY_INSTALLED));
		}
		return null;
	}
	
	/**
	* Performs configuration uninstallation when called from a VF page
	* Unloads initial usage configuration records second
	* Unloads tool configuration records first
	*
	* @param  None
	* @return Page reference to current page
	*
	**/
	public PageReference performUninstall() {
		if (this.isInstalled) {
			installInitialData(false, true);
			installToolInstallData(false, true);

			TreasuryConfigurationConstants.SYSTEM_PROPERTIES.clearCache();
			
			this.isInstalled = TMCUtility.isConfigurationToolInstalled();
			this.isToolDataInstalled = TMCUtility.isToolDataInstalled();
			
			ApexPages.addMessage(
				new ApexPages.Message(
					ApexPages.Severity.CONFIRM,CONFIGURATION_REMOVED_SUCCESSFULLY));
		} else {
			ApexPages.addMessage(
				new ApexPages.Message(
					ApexPages.Severity.INFO,CONFIGURATION_SYSTEM_NOT_INSTALLED));
		}
		return null;
	}
	
	/**
	* Exits page and redirects to:
	* Home page if this is an 'uninstall'
	* nCino Admin page if this is an 'install'
	*
	* @param  None
	* @return Page reference to Home or nCino Admin page
	*
	**/
	public PageReference finishInstallation() {
		
		PageReference pageRef = new PageReference('/');
		if (this.isInstalled) {
			pageRef = new PageReference(TreasuryConfigurationConstants.NCINO_ADMIN_PAGE);
		}
		return pageRef;
	}
	
	/**
	* Private Methods
	**/
	/**
	* Performs initial tool admin page configuration installation
	*
	* @param  None
	* @return sObject for new 'tool installed' system property
	*
	*/
	private sObject installToolInstallData(Boolean install, Boolean performDML) {
		sObject retValue = null;
		if (install) {
			TreasuryToolDataInstaller ttdi = new TreasuryToolDataInstaller();
			ttdi.onInstall(null);
			retValue = 
				TMCUtility.createSystemProperty(
					null,
					TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
					TreasuryConfigurationConstants.TM_CONFIGURATION_TOOL_INSTALLED_KEY,
					'true',
					true,
					performDML
				);
		} else {
			TreasuryToolDataInstaller ttdi = new TreasuryToolDataInstaller();
			ttdi.onUninstall(null);
			retValue = 
				TMCUtility.retrieveSystemPropertyObject(
					TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
					TreasuryConfigurationConstants.TM_CONFIGURATION_TOOL_INSTALLED_KEY
				);
			if (performDML) {
				Database.delete(retValue);
			}
		}
		return retValue;
	}
	
	/**
	* Performs initial data configuration
	*
	* @param  None
	* @return sObject for 'initial data installed' system property
	*
	*/
	private sObject installInitialData(Boolean install, Boolean performDML) {
		sObject retValue = null;
		if (install) {
			DataInstaller di = new DataInstaller();
			di.onInstall(null);
	
			retValue =
				TMCUtility.createSystemProperty(
					null,
					TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
					TreasuryConfigurationConstants.TM_INITIAL_DATA_INSTALLED_KEY,
					'true',
					true,
					performDML
				);
		} else {
			DataInstaller di = new DataInstaller();
			di.onUninstall(null);
			retValue = 
				TMCUtility.retrieveSystemPropertyObject(
					TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
					TreasuryConfigurationConstants.TM_INITIAL_DATA_INSTALLED_KEY
				);
			if (performDML) {
				Database.delete(retValue);
			}
		}
		return retValue;
	}
	
	public static final String CONFIGURATION_INSTALLED_SUCCESSFULLY = 'Treasury Tool Configuration successfully installed.';
	public static final String CONFIGURATION_REMOVED_SUCCESSFULLY = 'Treasury Tool Configuration successfully removed.';
	public static final String CONFIGURATION_SYSTEM_NOT_INSTALLED = 'System not installed';
	public static final String CONFIGURATION_SYSTEM_ALREADY_INSTALLED = 'System already installed';
}
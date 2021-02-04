public with sharing class TreasuryConfigurationConstants {
    /**
    * Configuration Constants
    */
    public static final String TM_CONFIG_IS_PRODUCTION_KEY = 'IsProduction';
    public static final String TM_INITIAL_DATA_INSTALLED_KEY = 'IsInitialDataInstalled';
    public static final String TM_CONFIG_CATEGORY = 'TreasuryManagementConfiguration';
    public static final String TM_CONFIGURATION_TOOL_INSTALLED_KEY = 'isConfigrationToolInstalled';

    public static final String TREASURY_TOOL = 'Treasury Configuration System';
    
    /**
    * Page and Navigation Constants
    */
    public static final String NCINO_ADMIN_PAGE = '/apex/llc_bi__admin?app=admin.ncinoadmin';
    public static final String TREASURY_TOOL_PAGE = 'c__' + Page.TreasuryConfigUI.getURL();
    public static final String TREASURY_APP_START_LOCATOR = 'app=treasury-config.tm-config-cat';
    
    /**
    * Custom Settings Constants
    */
    public static final String PROPERTY_TABLE_NAME = 'nFORCE__System_Properties__c';
    public static final String PROPERTY_FIELD_NAME = 'Name';
    public static final String PROPERTY_FIELD_ID = 'Id';
    public static final String PROPERTY_FIELD_CATEGORY = 'nFORCE__Category_Name__c';
    public static final String PROPERTY_FIELD_KEY = 'nFORCE__Key__c';
    public static final String PROPERTY_FIELD_VALUE = 'nFORCE__Value__c';
    public static final String PROPERTY_FIELD_IS_ACTIVE = 'nFORCE__Is_Active__c';

    /**
    * System Properties Instance
    */
    public static final nFORCE.SystemProperties SYSTEM_PROPERTIES = nFORCE.SystemProperties.getInstance();	
}
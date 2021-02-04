/**
* TMCUtility test class
**/

@isTest
public class TestTreasuryUtility {

    @isTest
    public static void testCreateSystemProperty() {
    	Test.startTest();
    	sObject systemProperty =
    		TMCUtility.createSystemProperty(
    			'MyTestProperty',
    			TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
    			TreasuryConfigurationConstants.TM_CONFIGURATION_TOOL_INSTALLED_KEY,
    			'true',
    			true,
    			true
    		);

    	System.assert(null != systemProperty.get('Id'));
    	Test.stopTest();
    }

    @isTest
    public static void testUpdateSystemProperty() {

    	sObject systemProperty =
    		TMCUtility.createSystemProperty(
    			'MyTestProperty',
    			TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
    			TreasuryConfigurationConstants.TM_CONFIGURATION_TOOL_INSTALLED_KEY,
    			'true',
    			true,
    			true
    		);

    	Test.startTest();

    	sObject testSystemProperty =
	      TMCUtility.updateSystemProperty(
    			'MyTestProperty',
    			TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
    			TreasuryConfigurationConstants.TM_CONFIGURATION_TOOL_INSTALLED_KEY,
    			'false',
    			true
    		);

    	System.assert(
    		testSystemProperty.get(TreasuryConfigurationConstants.PROPERTY_FIELD_VALUE)
    		!=
     		systemProperty.get(TreasuryConfigurationConstants.PROPERTY_FIELD_VALUE)
    	);

    	testSystemProperty =
	      TMCUtility.updateSystemProperty(
    			'MyTestProperty',
    			TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
    			TreasuryConfigurationConstants.TM_CONFIGURATION_TOOL_INSTALLED_KEY,
    			'true',
    			true
    		);

    	System.assert(
    		testSystemProperty.get(TreasuryConfigurationConstants.PROPERTY_FIELD_VALUE)
    		==
     		systemProperty.get(TreasuryConfigurationConstants.PROPERTY_FIELD_VALUE)
    	);

    	Test.stopTest();
    }

    @isTest
    public static void testDeleteSystemProperty() {

    	sObject systemProperty =
	      TMCUtility.createSystemProperty(
    			'MyTestProperty',
    			TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
    			TreasuryConfigurationConstants.TM_CONFIGURATION_TOOL_INSTALLED_KEY,
    			'true',
    			true,
    			true
    		);

    	Test.startTest();

    	sObject testSystemProperty =
	      TMCUtility.retrieveSystemPropertyObject(
    			TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
    			TreasuryConfigurationConstants.TM_CONFIGURATION_TOOL_INSTALLED_KEY
    		);

    	System.assert(
    		testSystemProperty.get(TreasuryConfigurationConstants.PROPERTY_FIELD_ID)
    		==
     		systemProperty.get(TreasuryConfigurationConstants.PROPERTY_FIELD_ID)
     	);

	    TMCUtility.deleteSystemProperty(
			TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
			TreasuryConfigurationConstants.TM_CONFIGURATION_TOOL_INSTALLED_KEY
     	);

		testSystemProperty =
			TMCUtility.retrieveSystemPropertyObject(
    			TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
    			TreasuryConfigurationConstants.TM_CONFIGURATION_TOOL_INSTALLED_KEY
    		);

    	System.assert(testSystemProperty == null);

    	Test.stopTest();
    }

    @isTest
    public static void testCreateOnUpdate() {
    	Test.startTest();

    	sObject testSystemProperty =
	      TMCUtility.updateSystemProperty(
    			'MyTestProperty',
    			TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
    			TreasuryConfigurationConstants.TM_CONFIGURATION_TOOL_INSTALLED_KEY,
    			'true',
    			true
    		);

    	System.assert(null != testSystemProperty.get('Id'));

    	Test.stopTest();
    }

    @isTest
    public static void testIsProduction() {
    	sObject systemProperty =
	      TMCUtility.createSystemProperty(
    			'MyTestProperty',
    			TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
    			TreasuryConfigurationConstants.TM_CONFIG_IS_PRODUCTION_KEY,
    			'true',
    			true,
    			true
    		);

    	Test.startTest();

    	Boolean isProduction = TMCUtility.isProduction();
    	System.assertEquals(true, isProduction);

    	systemProperty =
	      TMCUtility.updateSystemProperty(
    			'MyTestProperty',
    			TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
    			TreasuryConfigurationConstants.TM_CONFIG_IS_PRODUCTION_KEY,
    			'false',
    			true
    		);

		TreasuryConfigurationConstants.SYSTEM_PROPERTIES.clearCache();

    	isProduction = TMCUtility.isProduction();
    	System.assertEquals(false, isProduction);

	    TMCUtility.deleteSystemProperty(
			TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
			TreasuryConfigurationConstants.TM_CONFIG_IS_PRODUCTION_KEY
     	);

		TreasuryConfigurationConstants.SYSTEM_PROPERTIES.clearCache();

    	isProduction = TMCUtility.isProduction();
    	System.assertEquals(false, isProduction);
    }

    @isTest
    public static void testIsToolDataInstalled() {
    	sObject systemProperty =
	      TMCUtility.createSystemProperty(
    			'MyTestProperty',
    			TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
    			TreasuryConfigurationConstants.TM_INITIAL_DATA_INSTALLED_KEY,
    			'true',
    			true,
    			true
    		);

    	Test.startTest();

    	Boolean isToolDataInstalled = TMCUtility.isToolDataInstalled();
    	System.assertEquals(true, isToolDataInstalled);

    	systemProperty =
	      TMCUtility.updateSystemProperty(
    			'MyTestProperty',
    			TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
    			TreasuryConfigurationConstants.TM_INITIAL_DATA_INSTALLED_KEY,
    			'false',
    			true
    		);

		TreasuryConfigurationConstants.SYSTEM_PROPERTIES.clearCache();

    	isToolDataInstalled = TMCUtility.isToolDataInstalled();
    	System.assertEquals(false, isToolDataInstalled);

	    TMCUtility.deleteSystemProperty(
			TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
			TreasuryConfigurationConstants.TM_INITIAL_DATA_INSTALLED_KEY
     	);

		TreasuryConfigurationConstants.SYSTEM_PROPERTIES.clearCache();

    	isToolDataInstalled = TMCUtility.isToolDataInstalled();
    	System.assertEquals(false, isToolDataInstalled);
    }

    @isTest
    public static void testIsConfigurationToolInstalled() {
    	sObject systemProperty =
	      TMCUtility.createSystemProperty(
    			'MyTestProperty',
    			TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
    			TreasuryConfigurationConstants.TM_CONFIGURATION_TOOL_INSTALLED_KEY,
    			'true',
    			true,
    			true
    		);

    	Test.startTest();

    	Boolean isConfigurationToolInstalled = TMCUtility.isConfigurationToolInstalled();
    	System.assertEquals(true, isConfigurationToolInstalled);

    	systemProperty =
	      TMCUtility.updateSystemProperty(
    			'MyTestProperty',
    			TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
    			TreasuryConfigurationConstants.TM_CONFIGURATION_TOOL_INSTALLED_KEY,
    			'false',
    			true
    		);

		TreasuryConfigurationConstants.SYSTEM_PROPERTIES.clearCache();

    	isConfigurationToolInstalled = TMCUtility.isConfigurationToolInstalled();
    	System.assertEquals(false, isConfigurationToolInstalled);

	    TMCUtility.deleteSystemProperty(
			TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
			TreasuryConfigurationConstants.TM_CONFIGURATION_TOOL_INSTALLED_KEY
     	);

		TreasuryConfigurationConstants.SYSTEM_PROPERTIES.clearCache();

    	isConfigurationToolInstalled = TMCUtility.isConfigurationToolInstalled();
    	System.assertEquals(false, isConfigurationToolInstalled);
    }

    @isTest
    public static void testNameSpace() {
    	String nameSpace = TMCUtility.getNamespace();
    	String coreNameSpace = TMCUtility.getCoreNamespace();
    	String initialString = '123%^%A B C';
    	String testString = TMCUtility.alphanumericOnly(initialString);
    	System.assertEquals('123ABC', testString);
    }

    @isTest
    public static void testQueryStringGenerator() {
    	String testString = 'SELECT field1,field2,ID FROM queryObject WHERE name := nameString ORDER BY name';
    	Test.startTest();

    	String queryString =
	      TMCUtility.getQueryString(
    			'queryObject',
    			new List<String>{'field1','field2'},
    			'name := nameString',
    			'name'
    		);

    	System.assertEquals(testString, queryString);

    	Test.stopTest();
    }

}
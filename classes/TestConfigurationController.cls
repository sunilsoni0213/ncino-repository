@isTest
public with sharing class TestConfigurationController {
    @isTest
    static void testControllerInitialization() {
		Test.startTest();

		ConfigurationController cc = new ConfigurationController();

		System.assertEquals('LLC_BI', cc.namespace);
		System.assertEquals(false, cc.isProduction);
		
		Test.stopTest();
    }

    @isTest
    static void testControllerSave() {
		Test.startTest();

		ConfigurationController cc = new ConfigurationController();
		cc.isProduction = true;
		cc.save();

		System.assertEquals('LLC_BI', cc.namespace);
		System.assertEquals(true, cc.isProduction);
		System.assertEquals(true, TMCUtility.isProduction());
		
		Test.stopTest();
    }
}
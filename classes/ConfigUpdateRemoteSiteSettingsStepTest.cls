/****************************************************************************************
Name            : ConfigUpdateRemoteSiteSettingsStepTest
Revision Log    : 2020-03-17 John Kuhl - CodeScience
                :
                :
Use             : Unit Test for IConfigStep class ConfigUpdateRemoteSiteSettingsStep
****************************************************************************************/
@isTest
public class ConfigUpdateRemoteSiteSettingsStepTest {

    @isTest
    public static void testConfigUpdateRemoteSiteSettingsStep(){

        //Query for DemoSetupStep__mdt record for this class
        DemoSetupStep__mdt dssMtd = DemoSetupStepSelector.getActiveAutomationDemoSetupStep('ConfigUpdateRemoteSiteSettingsStep');
        //Create DemoSetupStatus__c record for this step (default StepStatus__c = 'Not Started')
        DemoSetupStatus__c dss = new DemoSetupStatus__c();
        dss.StepNumber__c = dssMtd.StepNumber__c;
        insert dss;

        Test.startTest();
        ConfigUpdateRemoteSiteSettingsStep.execute();
        Test.stopTest();

        DemoSetupStatus__c demoSetupStatus = [SELECT Id, StepStatus__c FROM DemoSetupStatus__c WHERE Id = :dss.Id];

        System.assertEquals('Complete', demoSetupStatus.StepStatus__c);

    }
    
}
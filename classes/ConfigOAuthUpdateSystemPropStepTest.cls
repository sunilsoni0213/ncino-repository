/****************************************************************************************
Name            : ConfigOAuthUpdateSystemPropStepTest
Revision Log    : 2020-03-17 John Kuhl - CodeScience
                :
                :
Use             : Unit Test for IConfigStep class ConfigOAuthUpdateSystemPropertiesStep
****************************************************************************************/
@isTest
public class ConfigOAuthUpdateSystemPropStepTest {
    
    @isTest
    public static void testSystemPropertiesUpdate(){
        Test.setMock(WebServiceMock.class, new CSMetadataServiceTest.WebServiceMockImpl());
        DemoSetupStep__mdt dssMtd = DemoSetupStepSelector.getActiveAutomationDemoSetupStep('ConfigOAuthUpdateSystemPropertiesStep');
        DemoSetupStatus__c dss = new DemoSetupStatus__c();
        dss.StepNumber__c = dssMtd.StepNumber__c;
        insert dss;

        Test.startTest();
        ConfigOAuthUpdateSystemPropertiesStep.execute();
        Test.stopTest();

        dss = [SELECT Id, StepStatus__C FROM DemoSetupStatus__c WHERE Id =: dss.Id];

        System.assertEquals('Complete', dss.StepStatus__c);
    }
    
}
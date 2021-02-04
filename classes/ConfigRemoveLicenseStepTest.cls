/****************************************************************************************
Name            : ConfigRemoveLicenseStepTest
Revision Log    : 2020-03-17 John Kuhl - CodeScience
                :
                :
Use             : Unit Test for IConfigStep class ConfigRemoveLicenseStep
****************************************************************************************/
@isTest
public class ConfigRemoveLicenseStepTest {
    
    @TestSetup
    static void makeData(){

        //Create user
        User u = TestUtility.setupStandardUserWithProfile('ConfigRemoveLicenseStepTest@nCinoTest.com', false);
        u.AutoRemoveManagedLicense__c = true;
        insert u;

        //Query for Package License
        PackageLicense packageLicense = [SELECT Id FROM PackageLicense WHERE NamespacePrefix = 'LLC_BI'];

        //Create and insert UserPackageLicense record for user
        UserPackageLicense upl = new UserPackageLicense();
        upl.UserId = u.Id;
        upl.PackageLicenseId = packageLicense.Id;
        insert upl;

        System.runAs(u){
            DemoSetupStep__mdt dssMtd = DemoSetupStepSelector.getActiveAutomationDemoSetupStep('ConfigRemoveLicenseStep');
            DemoSetupStatus__c dss = new DemoSetupStatus__c();
            dss.StepNumber__c = dssMtd.StepNumber__c;
            insert dss;
        }
    }

    @isTest
    public static void testRemoval(){
        
        Test.startTest();
        //Run class function
        ConfigRemoveLicenseStep.execute();
        Test.stopTest();
        
        //Query for UserId
        User u = [SELECT Id, Name FROM User WHERE Email =: 'ConfigRemoveLicenseStepTest@nCinoTest.com'];

        //Query for UserLicenses
        List<UserPackageLicense> userLicenses = [SELECT Id, UserId, PackageLicenseId FROM UserPackageLicense WHERE UserId = :u.Id];
        System.assertEquals(0, userLicenses.size(), 'User should have no Package Licenses assigned');

    }
}
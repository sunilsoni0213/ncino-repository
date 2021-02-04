@isTest
public class DemoSetupControllerTest {

        @isTest
        static void testRecordRetrieval(){
            //Query for all active DemoSetupStep__mdt records
            List<DemoSetupStep__mdt> demoSetupSteps = [SELECT Id, StepNumber__c, StepTitle__c FROM DemoSetupStep__mdt WHERE Active__c = true];

            Test.startTest();
            //Execute getActiveSteps method to return all DemoSetupSteps__mdt records wrapped
            List<DemoSetupStepMsg> demoSetupStepMsgs = DemoSetupController.getActiveSteps();
            //Execute getActiveStep method on the first record returned in query
            DemoSetupStepMsg demoSetupStepMsg = DemoSetupController.getActiveStep(demoSetupSteps[0].StepNumber__c);
            Test.stopTest();
            
            System.assertEquals(demoSetupSteps.size(), demoSetupStepMsgs.size(), 'The method should return all active DemoSetupStep__mdt records wrapped');
            System.assertEquals(demoSetupSteps[0].StepTitle__c, demoSetupStepMsg.stepTitle, 'The method should return the data for the StepNumber provided');
        }

        @isTest
        static void testRunningStep(){

            //Create user
            User sysAdminU = TestUtility.setupSystemAdminUserWithProfile('ConfigRemoveLicenseStepAdminTest@nCinoTest.com', false);
            User u = TestUtility.setupStandardUserWithProfile('ConfigRemoveLicenseStepTest@nCinoTest.com', false);
            u.AutoRemoveManagedLicense__c = true;

            List<User> users = new List<User>{sysAdminU, u};
            insert users;

            //Query for Package License
            PackageLicense packageLicense = [SELECT Id FROM PackageLicense WHERE NamespacePrefix = 'LLC_BI'];

            //Create and insert UserPackageLicense record for user
            UserPackageLicense upl = new UserPackageLicense();
            upl.UserId = u.Id;
            upl.PackageLicenseId = packageLicense.Id;
            insert upl;

            System.runAs(sysAdminU){
                DemoSetupStep__mdt dssMtd = DemoSetupStepSelector.getActiveAutomationDemoSetupStep('ConfigRemoveLicenseStep');
                DemoSetupStatus__c dss = new DemoSetupStatus__c();
                dss.StepNumber__c = dssMtd.StepNumber__c;
                insert dss;

                //Get the first step
                DemoSetupStep__mdt demoSetupStep = DemoSetupStepSelector.getActiveDemoSetupStep(dssMtd.StepNumber__c);

                //Run step
                Test.startTest();
                DemoSetupController.runStep(demoSetupStep.StepNumber__c);
                Test.stopTest();

            }
            
            //Query for UserLicenses
            List<UserPackageLicense> userLicenses = [SELECT Id, UserId, PackageLicenseId FROM UserPackageLicense WHERE UserId = :u.Id];
            System.assertEquals(0, userLicenses.size(), 'User should have no Package Licenses assigned');
        }
}
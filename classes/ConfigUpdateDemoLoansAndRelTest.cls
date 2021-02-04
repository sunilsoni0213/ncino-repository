/****************************************************************************************
Name            : ConfigUpdateDemoLoansAndRelTest
Revision Log    : 2020-03-17 John Kuhl - CodeScience
                :
                :
Use             : Unit Test for IConfigStep class ConfigUpdateDemoLoansAndRelationships
****************************************************************************************/
@isTest
public class ConfigUpdateDemoLoansAndRelTest {

    @TestSetup
    static void makeData(){

        DemoSetupStep__mdt dssMtd = DemoSetupStepSelector.getActiveAutomationDemoSetupStep('ConfigUpdateDemoLoansAndRelationships');
        DemoSetupStatus__c dss = new DemoSetupStatus__c();
        dss.StepNumber__c = dssMtd.StepNumber__c;
        insert dss;
        
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c(Is_Demo_Loan__c = true);
        insert loan;

        Account acct = new Account(Name = 'Test Account', Is_Demo_Relationship__c = true);
        insert acct;

        Contact con = new Contact(LastName = 'Test Contact', Is_Demo_Contact__c = true, AccountId = acct.Id);
        insert con;

        nFORCE__Screen__c sc = new nFORCE__Screen__c(Name = 'Test');
        insert sc;

        nFORCE__Screen_Section__c scs = new nFORCE__Screen_Section__c(nFORCE__Screen__c = sc.Id);
        insert scs;

        LLC_BI__Id_Document_Type__c idDocType = new LLC_BI__Id_Document_Type__c(Name = 'Drivers License', LLC_BI__Screen_Section__c = scs.Id);
        insert idDocType;

        nFORCE__Field_Configuration__c fc = new nFORCE__Field_Configuration__c(nForce__Field_Name__c = 'LLC_BI__Id_Document_Type__c', nFORCE__sObject_Name__c = 'Account');
        insert fc;
    }

    @isTest
    public static void testConfigUpdateDemoLoansAndRelationshipsStep() {
        Test.startTest();
        ConfigUpdateDemoLoansAndRelationships.execute();
        Test.stopTest();

        LLC_BI__Loan__c loan =  [SELECT Id, Application_Date__c, LLC_BI__CloseDate__c, LLC_BI__Next_Payment_Due__c, LLC_BI__First_Payment_Date__c FROM LLC_BI__Loan__c WHERE Is_Demo_Loan__c = true AND LLC_BI__Stage__c != 'Booked' LIMIT 1];
        System.assertEquals(Date.today(), loan.Application_Date__c);
        System.assertEquals(Date.today().addDays(30), loan.LLC_BI__CloseDate__c);
        System.assertEquals(Date.today().addDays(60), loan.LLC_BI__Next_Payment_Due__c);
        System.assertEquals(Date.today().addDays(60), loan.LLC_BI__First_Payment_Date__c);

        Account acc = [SELECT Id, LLC_BI__Risk_Rating_Review_Date_Decisioned__c, LLC_BI__FICO_Score__c, LLC_BI__FICO_Date__c, LLC_BI__Tax_Identification_Number__c FROM Account WHERE Is_Demo_Relationship__c = true LIMIT 1];
        System.assertEquals(Date.today(), acc.LLC_BI__FICO_Date__c);
        System.assertEquals(Date.today(), acc.LLC_BI__Risk_Rating_Review_Date_Decisioned__c);
        System.assertEquals('987654321', acc.LLC_BI__Tax_Identification_Number__c);

        Contact con = [SELECT Id, LLC_BI__SS__c FROM Contact LIMIT 1];
        System.assertEquals('123498567', con.LLC_BI__SS__c);

        Id docTypeId = [SELECT Id FROM LLC_BI__Id_Document_Type__c WHERE Name = 'Drivers License' LIMIT 1].Id;
        nFORCE__Field_Configuration__c fieldConfig = [SELECT Id, nFORCE__Field_Name__c, nFORCE__Default_Value__c FROM nFORCE__Field_Configuration__c WHERE nFORCE__Field_Name__c = 'LLC_BI__Id_Document_Type__c' LIMIT 1];
        System.assertEquals(docTypeId, fieldConfig.nFORCE__Default_Value__c);

        //Query for DemoSetupStep__mdt record for this class
        DemoSetupStep__mdt dssMdt = DemoSetupStepSelector.getActiveAutomationDemoSetupStep('ConfigUpdateDemoLoansAndRelationships');
        //Query for DemoSetupStatus__c record for this step
        DemoSetupStatus__c demoSetupStatus = DemoSetupStepSelector.getDemoSetupStatus(dssMdt.StepNumber__c);
        System.assertEquals('Complete', demoSetupStatus.StepStatus__c);

    }
}
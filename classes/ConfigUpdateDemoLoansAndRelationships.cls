/****************************************************************************************
Name            : ConfigUpdateDemoLoansAndRelationships
Revision Log    : 2020-03-19 John Kuhl - CodeScience
                :
                :
Use             : IConfigStep class for Updating Demo Loans and Relationships
****************************************************************************************/
public class ConfigUpdateDemoLoansAndRelationships implements IConfigStep{
    
    /**
     * execute
     *
     * This method executes the the configuration step
     **/
    public static void execute(){

        try{
            //Query LLC_BI__Loan__c for records
            List<LLC_BI__Loan__c> loans = [SELECT Id, 
                                                    Application_Date__c,
                                                    LLC_BI__CloseDate__c,
                                                    LLC_BI__Next_Payment_Due__c,
                                                    LLC_BI__First_Payment_Date__c
                                                    FROM LLC_BI__Loan__c
                                                    WHERE Is_Demo_Loan__c = true
                                                    AND LLC_BI__Stage__c != 'Booked'];

            //Update record dates to dynamic dates
            for(LLC_BI__Loan__c loan : loans){
                loan.Application_Date__c = Date.today();
                loan.LLC_BI__CloseDate__c = Date.today().addDays(30);
                loan.LLC_BI__Next_Payment_Due__c = Date.today().addDays(60);
                loan.LLC_BI__First_Payment_Date__c = Date.today().addDays(60);
            }

            //Update records
            update loans;

            //Query for Demo Relationship Accounts
            List<Account> accounts = [SELECT Id,
                                                LLC_BI__Risk_Rating_Review_Date_Decisioned__c,
                                                LLC_BI__FICO_Score__c,
                                                LLC_BI__FICO_Date__c,
                                                LLC_BI__Tax_Identification_Number__c
                                                FROM Account
                                                WHERE Is_Demo_Relationship__c = true];
            
            //Loop through records to set specific values
            for(Account acc : accounts){
                acc.LLC_BI__FICO_Date__c = Date.today();
                acc.LLC_BI__Risk_Rating_Review_Date_Decisioned__c = Date.today();
                acc.LLC_BI__Tax_Identification_Number__c = '987654321';
            }

            //Update records
            update accounts;

            //Query for demo contacts
            List<Contact> contacts = [SELECT Id,
                                                LLC_BI__SS__c
                                                FROM Contact
                                                WHERE Is_Demo_Contact__c = true];
            
            //Loop through records to set specific value
            for(Contact con : contacts){
                con.LLC_BI__SS__c = '123498567';
            }
            //Update records
            update contacts;
            
            //Query for Home page tasks
            List<Task> tasks = [SELECT Id,ActivityDate FROM Task WHERE ActivityDate < TODAY];
            //Loop through records to set value
            for(Task t : tasks){
                t.ActivityDate = Date.today()+7;
            }
            //Update records
            update tasks;

            //Query for Drivers License Id_Document_Type__c record Id
            Id docTypeId = [SELECT Id
                            FROM LLC_BI__Id_Document_Type__c
                            WHERE Name = 'Drivers License'
                            LIMIT 1].Id;
            
            //Query for Field_Configuration__c records
            List<nFORCE__Field_Configuration__c> fieldConfigurations = [SELECT Id,
                                                                                nFORCE__Field_Name__c,
                                                                                nFORCE__Default_Value__c
                                                                                FROM nFORCE__Field_Configuration__c
                                                                                WHERE nFORCE__Field_Name__c = 'LLC_BI__Id_Document_Type__c'];
                
            //Loop through records to set Id_Document_Type__c Id as default value
            for(nFORCE__Field_Configuration__c fieldConfig : fieldConfigurations){
                fieldConfig.nFORCE__Default_Value__c = docTypeId;
            }
            //Update records
            update fieldConfigurations;

            //Update DemoSetupStep__c to 'Complete'
            DemoStepUtility.updateSetupStatusToComplete('ConfigUpdateDemoLoansAndRelationships', null);
        }catch(Exception e){
            DemoStepUtility.updateStepWithError('ConfigUpdateDemoLoansAndRelationships', e.getMessage());
        }
    }
}
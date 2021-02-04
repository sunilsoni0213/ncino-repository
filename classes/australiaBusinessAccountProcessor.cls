global class australiaBusinessAccountProcessor implements Database.Batchable<sObject>
{
  String email='test@gmail.com'; //You would enter in an email address here to get the logs/successes BOO YAH
    global Database.QueryLocator start(Database.BatchableContext BC)
    {

        String query = 'SELECT Id,BillingCountry,BillingCity,BillingState,BillingPostalCode,LLCLP__State_of_Incorporation__c FROM Account WHERE Is_Demo_Relationship__c = False AND LLC_BI__Is_Individual__c = 0';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Account> scope) {
      

        
        for(Account acc : scope)
        {      
          
            acc.BillingCountry = 'Australia';
            acc.BillingCity = 'Melbourne';
            acc.BillingState = 'Victoria';
            acc.BillingPostalCode = '3000';
            acc.LLCLP__State_of_Incorporation__c = '';
        }
        update scope;
        
    }  
    global void finish(Database.BatchableContext BC)
    {
  
        AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :BC.getJobId()];
         //Sends dat mail to your email defined prior
  
    }
  


}
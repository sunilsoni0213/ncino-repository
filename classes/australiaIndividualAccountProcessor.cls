//DO NOT RUN THIS REID OR TEAM IT'S FOR AUSTRALIA ONLY
global class australiaIndividualAccountProcessor implements Database.Batchable<sObject>
{
  String email='test@gmail.com'; //You would enter in an email address here to get the logs/successes BOO YAH
    global Database.QueryLocator start(Database.BatchableContext BC)
    {

        String query = 'SELECT Id,BillingCountry,BillingCity,BillingState,BillingPostalCode FROM Account WHERE Is_Demo_Relationship__c = False AND LLC_BI__Is_Individual__c = 1';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Account> scope) {
      

        
        for(Account acc : scope)
        {      
          
            acc.BillingCountry = 'Australia';
            acc.BillingCity = 'Sydney';
            acc.BillingState = 'New South Wales';
            acc.BillingPostalCode = '2026';
        }
        update scope;
        
    }  
    global void finish(Database.BatchableContext BC)
    {
  
        // This will call my other Apex Batch Job for Business Account Updates. The name of the Apex class is australiaBusinessAccountProcessor
            australiaBusinessAccountProcessor b = new australiaBusinessAccountProcessor();
            database.executebatch(b);

        // This will call my other Apex Batch Job for Collateral Updates. The name of the Apex class is australiaCollateralProcessor
            australiaCollateralProcessor c = new australiaCollateralProcessor();
            database.executebatch(c);        
        
        
        AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :BC.getJobId()];
         //Sends dat mail to your email defined prior
  
    }
  

}


//Open execute anonymous code to execute this in dev console is here: seperate lines just take the comment code out!
//australiaIndividualAccountProcessor obj=new australiaIndividualAccountProcessor();
//Database.executeBatch(obj);
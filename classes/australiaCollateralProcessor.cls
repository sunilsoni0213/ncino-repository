global class australiaCollateralProcessor implements Database.Batchable<sObject>
{
  String email='test@gmail.com'; //You would enter in an email address here to get the logs/successes BOO YAH
    global Database.QueryLocator start(Database.BatchableContext BC)
    {

        String query = 'SELECT Id,LLC_BI__City__c,LLC_BI__State__c,LLC_BI__Zip_Code__c,LLC_BI__County__c,Z_Australia_States__c FROM LLC_BI__Collateral__c WHERE Is_Demo_Collateral__c = False AND Type__c = \'Real Estate\'';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<LLC_BI__Collateral__c> scope) {
      

        
        for(LLC_BI__Collateral__c col : scope)
        {      
          
            col.LLC_BI__City__c = 'Sydney';
            col.LLC_BI__State__c = 'New South Wales';
            col.LLC_BI__Zip_Code__c = '2096';
            col.LLC_BI__County__c = 'Manly';
            col.Z_Australia_States__c = 'New South Wales';
        }
        update scope;
        
    }  
    global void finish(Database.BatchableContext BC)
    {
  
        AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :BC.getJobId()];
         //Sends dat mail to your email defined prior
  
    }
  


}
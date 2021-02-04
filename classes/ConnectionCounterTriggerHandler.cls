public with sharing class ConnectionCounterTriggerHandler {
    
   public static void updateAccount(Id connection) {
        Account a = [SELECT
                Id,
                Connection_Flag__c
            FROM
            Account
            WHERE
                Id =: connection];

        List<LLC_BI__Connection__c> cList = [SELECT
                Id
            FROM
                LLC_BI__Connection__c
            WHERE
                LLC_BI__Connected_From__c =: a.Id];

        if (cList.size() > 0) {
            a.Connection_Flag__c = true;
        } else {    
            a.Connection_Flag__c = false;
        }

        Database.update(a);
   }
}
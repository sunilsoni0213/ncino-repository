public with sharing class DepositAggregatorTriggerHandler {
    
    public static void updateDeposit(Id deposit) {
        Decimal totalDeposits = 0;

        LLC_BI__Deposit__c dep = [SELECT 
                Id,
                LLC_BI__Account__c,
                LLC_BI__Amount__c
            FROM
                LLC_BI__Deposit__c
            WHERE
                Id =: deposit];

        Account a = [SELECT
                Id,
                Estimated_Total_Deposits__c
            FROM
                Account
            WHERE
                Id =: dep.LLC_BI__Account__c];

        List<LLC_BI__Deposit__c> depositList = [SELECT
                Id,
                LLC_BI__Account__c,
                LLC_BI__Amount__c
            FROM
                LLC_BI__Deposit__c
            WHERE
                LLC_BI__Account__c =: a.Id];

        for (LLC_BI__Deposit__c d : depositList) {
            if (d.LLC_BI__Amount__c != null) {
                totalDeposits += d.LLC_BI__Amount__c;
            }
        }

        a.Estimated_Total_Deposits__c = totalDeposits;

        Database.update(a);
    }
}
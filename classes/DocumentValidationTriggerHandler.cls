public with sharing class DocumentValidationTriggerHandler {
    
    public static void updateLoan(Id loan) {

        LLC_BI__Loan__c l = 
            [
                SELECT 
                    Id,
                    LLC_BI__Stage__c,
                    Document_Flag__c
                FROM
                    LLC_BI__Loan__c
                WHERE
                    Id =: loan
            ];

        List<LLC_BI__LLC_LoanDocument__c> docList = 
            [
                SELECT
                    Id,
                    LLC_BI__Loan__c,
                    LLC_BI__reviewStatus__c,
                    NDOC__neededByStage__c
                FROM
                    LLC_BI__LLC_LoanDocument__c
                WHERE
                    LLC_BI__Loan__c =: l.Id
                AND
                    (
                        NDOC__neededByStage__c =: l.LLC_BI__Stage__c 
                            AND
                        ((LLC_BI__reviewStatus__c =: 'Open') OR (LLC_BI__reviewStatus__c = 'Exception'))
                    )
            ];

        if (docList.size() == 0) {
            l.Document_Flag__c = false;
        } else {
            l.Document_Flag__c = true;
        }

        Database.update(l);
    }
}
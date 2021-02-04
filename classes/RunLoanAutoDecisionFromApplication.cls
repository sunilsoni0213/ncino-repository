public without sharing class RunLoanAutoDecisionFromApplication {
    @InvocableMethod (label='Run Loan Auto Desc From Application' description='Run Loan Auto Desc. From Application')
    public static void runLoanAutoDesc(List<Id> applications) {
    System.debug(applications);
        List<LLC_BI__Loan__c> loans = [SELECT Id FROM LLC_BI__Loan__c WHERE LLC_BI__Application__c in: applications];
    for (LLC_BI__Loan__c loan : loans) {
            runSometime(loan.id, UserInfo.getSessionId());
        }
    }
    
   @future(callout=true)
    public static void runSometime(Id loanId, String sessionId) {
        LLC_BI.LoanAutoDecisionController.generateDecision(
            loanId,
            sessionId);
    }
}
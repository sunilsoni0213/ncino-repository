@isTest
private class LoanStageDurationTest {

  @isTest
    static void myUnitTest() {

        LLC_BI__CFG_ConfigValue__c cfg = new LLC_BI__CFG_ConfigValue__c();
        cfg.LLC_BI__Key__c = 'ALL';
        cfg.LLC_BI__fieldValue__c = 'Closed Funded';
        cfg.LLC_BI__Category__c = 'Loan Stage';
        insert cfg;

        LLC_BI__CFG_ConfigValue__c cfg2 = new LLC_BI__CFG_ConfigValue__c();
        cfg2.LLC_BI__Key__c = 'Complete';
        cfg2.LLC_BI__fieldValue__c = 'Complete';
        insert cfg2;

        LLC_BI__Loan__c newLoan = new LLC_BI__Loan__c();
        insert newLoan;
        
        LLC_BI__Opportunity_History__c oppHistory = new LLC_BI__Opportunity_History__c(LLC_BI__StageName__c='Application', LLC_BI__Loan__c= newLoan.Id);
        insert oppHistory;
    
       ApexPages.standardController controller = new ApexPages.standardController(newLoan);
       ApexPages.currentPage().getParameters().put('id', newLoan.Id);
       LoanStageDurationController lsdCont= new LoanStageDurationController(controller); 
    }
}
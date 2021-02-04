trigger loan_DocumentFlag on LLC_BI__Loan__c (after update) {
   for (Integer i = 0 ; i < trigger.new.size(); i++) {
      if (trigger.isUpdate && (trigger.new[i].LLC_BI__Stage__c != trigger.old[i].LLC_BI__Stage__c)) {
         List<LLC_BI__Loan__c> loans = Trigger.new;
         for (LLC_BI__Loan__c loan : loans) {
            DocumentValidationTriggerHandler.updateLoan(loan.Id);
         }
      }
   }
}
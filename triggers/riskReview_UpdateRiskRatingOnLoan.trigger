trigger riskReview_UpdateRiskRatingOnLoan on LLC_BI__Annual_Review__c (after update) {
  
   for (LLC_BI__Annual_Review__c ar : Trigger.new) {
      if (ar.LLC_BI__Final_Risk_Grade__c != null) {
         String startRiskGrade = String.ValueOf(ar.LLC_BI__Final_Risk_Grade__c);
         String riskGrade = startRiskGrade.substring(0,1);
         
         LLC_BI__Loan__c l = [SELECT 
               Id, 
               LLC_BI__Risk_Grade__c 
            FROM 
               LLC_BI__Loan__c 
            WHERE 
               Id =: ar.LLC_BI__Loan__c];
         
         l.LLC_BI__Risk_Grade__c = riskGrade;

         update l;
      }
   }
}
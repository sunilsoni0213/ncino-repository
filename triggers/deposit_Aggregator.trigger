trigger deposit_Aggregator on LLC_BI__Deposit__c (after insert, after update, after delete) {
   for (Integer i = 0 ; i < trigger.new.size(); i++) {
      if (trigger.new[i].LLC_BI__Account__c != null) {
         List<LLC_BI__Deposit__c> deposits = Trigger.new;
         for (LLC_BI__Deposit__c deposit : deposits) {
            DepositAggregatorTriggerHandler.updateDeposit(deposit.Id);
         }
      }
   }
}
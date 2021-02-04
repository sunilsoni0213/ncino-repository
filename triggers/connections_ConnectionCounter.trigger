trigger connections_ConnectionCounter on LLC_BI__Connection__c (after insert) {
    for (Integer i = 0 ; i < trigger.new.size(); i++) {
      if (trigger.isInsert) {
         List<LLC_BI__Connection__c> connections = Trigger.new;
         for (LLC_BI__Connection__c connection : connections) {
            ConnectionCounterTriggerHandler.updateAccount(connection.LLC_BI__Connected_From__c);
         }
      }
   }
}
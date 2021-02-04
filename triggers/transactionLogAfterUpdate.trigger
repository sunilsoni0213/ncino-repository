trigger transactionLogAfterUpdate on nFUSE__Transaction_Log__c (after update) {
	if (nFORCE.BeanRegistry.getInstance().isRegistered(PrecisionLender.TRANSACTION_LOG_AFTER_UPDATE_TRIGGERS_BEAN)) {
		new PrecisionLenderTransactionTriggerHandler().afterUpdate(Trigger.new, Trigger.old, Trigger.newMap.keySet());
	}
}
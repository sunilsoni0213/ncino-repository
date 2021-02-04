trigger loanAfterUpdate on LLC_BI__Loan__c (after update) {
	if (nFORCE.BeanRegistry.getInstance().isRegistered(PrecisionLender.LOAN_AFTER_UPDATE_TRIGGERS_BEAN)) {
		new PrecisionLenderLoanTriggerHandler().afterUpdate(Trigger.new, Trigger.old, Trigger.newMap.keySet());
	}
}
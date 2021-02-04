trigger loanRenewalAfterInsert on LLC_BI__LoanRenewal__c (after insert) {
	nFORCE.TriggerPipeline c =
		(nFORCE.TriggerPipeline) nFORCE.BeanFactory.getInstance().getBeanByUniqueName(
			PrecisionLender.LOAN_RENEWAL_AFTER_INSERT_TRIGGERS_BEAN);
	if (c != null) {
		c.executePipeline();
	}
}
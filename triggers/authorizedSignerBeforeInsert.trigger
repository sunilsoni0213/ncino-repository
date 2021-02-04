trigger authorizedSignerBeforeInsert on LLC_BI__Contingent_Liabilty__c (before insert) {
	nFORCE.TriggerPipeline c =
		(nFORCE.TriggerPipeline)nFORCE.BeanFactory.getInstance().getBeanByUniqueName(
			CSIDepActDocPrep.DEPOSIT_AUTHORIZED_SIGNER_AFTER_INSERT_TRIGGERS_BEAN);
	if (c != null) {
		c.executePipeline();
	}
}
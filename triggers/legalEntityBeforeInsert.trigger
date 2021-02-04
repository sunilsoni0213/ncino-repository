trigger legalEntityBeforeInsert on LLC_BI__Legal_Entities__c (before insert) {
	nFORCE.TriggerPipeline c =
		(nFORCE.TriggerPipeline) nFORCE.BeanFactory.getInstance().getBeanByUniqueName(
			CSIDepActDocPrep.DEPOSIT_ENTITY_INVOLVEMENT_AFTER_INSERT_TRIGGERS_BEAN);
	if (c != null) {
		c.executePipeline();
	}
}
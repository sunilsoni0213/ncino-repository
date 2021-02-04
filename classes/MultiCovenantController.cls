public with sharing class MultiCovenantController {
	public List<LLC_BI__Covenant__c> covenantList {get; set;}
	public Id loanId {get; set;}
	public Id accountId {get; set;}
	public Id contactId {get; set;}

	public MultiCovenantController() {
		Map<String,String> getParameters = ApexPages.currentPage().getParameters();
		this.loanId = getParameters.get(LOAN_ID);
		this.accountId = getParameters.get(ACCOUNT_ID);
		this.contactId = getParameters.get(CONTACT_ID);
		this.covenantList = new List<LLC_BI__Covenant__c>();
		this.covenantList.add(getInitializedCovenantObject(this.loanId,null,null));
	}
	
	public PageReference save() {
		List<LLC_BI__Covenant__c> covenantsToSave = new List<LLC_BI__Covenant__c>();
		PageReference returnPage = null;
		for (LLC_BI__Covenant__c covenant: covenantList) {
			if (
				((covenant.LLC_BI__Account__c != null) 				
				||
				(covenant.LLC_BI__Contact__c != null))
				&&
				(covenant.LLC_BI__Covenant_Sub_Type__c != 'None')
			   )
			{
				covenantsToSave.add(covenant);
			}
		}
		if (covenantsToSave.size() > 0) {
			insert covenantsToSave;
			returnPage = new PageReference('/' + this.loanId);
		} else {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, NO_COVENANTS_FILLED_IN_ERROR));			
		}
		
		return returnPage;
	}
	
	public PageReference cancel() {
		return new PageReference('/' + this.loanId);
	}

	public void removeLastRow()
	{
		if (this.covenantList != null && this.covenantList.size()>0) 
		{
			this.covenantList.remove(this.covenantList.size()-1);
		}
	}

	public void addRow()
	{
		this.covenantList.add(getInitializedCovenantObject(this.loanId,null,null));
	}

	private LLC_BI__Covenant__c getInitializedCovenantObject(Id loanId, Id acctId, Id contactId) {
		return
			new LLC_BI__Covenant__c(
				LLC_BI__Active__c = true,
				LLC_BI__Contact__c = contactId,
				LLC_BI__Covenant_Sub_Type__c = PICKLIST_DEFAULT,
				LLC_BI__Covenant_Type__c = PICKLIST_DEFAULT,
				LLC_BI__Financial_Indicator_Value__c = null,
				LLC_BI__Frequency__c = PICKLIST_DEFAULT,
				LLC_BI__Last_Evaluation_Date__c = null,
				LLC_BI__Last_Evaluation_Status__c = null,
				LLC_BI__Loan__c = loanId,
				LLC_BI__Next_Evaluation_Date__c = null,
				LLC_BI__Notes__c = null,
				LLC_BI__Account__c = acctId
			);
	}
	
	private String PICKLIST_DEFAULT = 'None';
	private String LOAN_ID = 'loanId';
	private String ACCOUNT_ID = 'accountId';
	private String CONTACT_ID = 'contactId';
	private String NO_COVENANTS_FILLED_IN_ERROR = 'No covenant records are complete. Enter required data or cancel to return to loan.';
}
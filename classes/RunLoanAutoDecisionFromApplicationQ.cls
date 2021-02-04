global class RunLoanAutoDecisionFromApplicationQ implements Queueable, Database.AllowsCallouts {
    public Id loanId  {get;set;}
    public String sessId {get;set;}
 
    @InvocableMethod (label='Run Loan Auto Desc From Application as queueable' description='Run Loan Auto Desc From Application as queueable')
    public static void runLoanAutoDesc(List<Id> applications) {
    	System.debug(applications);
        List<LLC_BI__Loan__c> loans = [SELECT Id FROM LLC_BI__Loan__c WHERE LLC_BI__Application__c in: applications];
    	for (LLC_BI__Loan__c loan : loans) {
			RunLoanAutoDecisionFromApplicationQ myBatch = new RunLoanAutoDecisionFromApplicationQ(
                loans[0].id, 
                UserInfo.getSessionId());
            System.enqueueJob(myBatch);
        }
    }
    
    global RunLoanAutoDecisionFromApplicationQ(Id loanId, String sessId) {
        this.loanId = loanId;
        this.sessId = sessId;
    }
 
    public void execute(QueueableContext context) { 
	    LLC_BI.LoanAutoDecisionController.generateDecision(this.loanId, this.sessId);
    }
}
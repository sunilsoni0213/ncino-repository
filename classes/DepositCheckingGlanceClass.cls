public class DepositCheckingGlanceClass {
	private LLC_BI__Deposit__c depositObject;
	public String depositObjectId {get;set;}

	public DepositCheckingGlanceClass(ApexPages.StandardController controller) {
        
        //set current deposit object
        this.depositObject = (LLC_BI__Deposit__c)controller.getRecord();
        
        //store deposit object id
        depositObjectId = depositObject.Id;
    }

}
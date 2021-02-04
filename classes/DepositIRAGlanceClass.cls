public class DepositIRAGlanceClass {
    private LLC_BI__Deposit__c depositObject;
    private LLC_BI__Deposit__c depositObject2;
    public String depositObjectId {get;set;}
    public String DepositSummaryName {get;set;}
    public Contact ContactObject {get;set;}
    
    public DepositIRAGlanceClass(ApexPages.StandardController controller) {
        
        //set current deposit object
        this.depositObject = (LLC_BI__Deposit__c)controller.getRecord();
        
        //store deposit object id
        depositObjectId = depositObject.Id;
        
        //query more fields for current deposit object
        depositObject2 = [select LLC_BI__Account__c from LLC_BI__Deposit__c where id =:depositObjectId];
        
        //grab account id from deposit object
        String aID = depositObject2.LLC_BI__Account__c;
        
        //search contact records for aID
        ContactObject = [select AccountId, Customer_Age__c from Contact where AccountId = :aId];
    }

}
public with sharing class DNBController {
    
    public Id relationshipId {get; set;}
    public String relationshipName {get; set;}
    public String relationshipStreet {get; set;}
    public String relationshipCity {get; set;}
    public String relationshipState {get; set;}
    public String relationshipPostalCode {get; set;}
    
    public DNBController(ApexPages.StandardController controller) {
        relationshipId = controller.getId();
        Account account = [SELECT BillingStreet, BillingCity, BillingState, BillingPostalCode, Name FROM Account WHERE Id =: relationshipId];
        relationshipName = account.Name;
        relationshipStreet = account.BillingStreet;
        relationshipCity = account.BillingCity;
        relationshipState = account.BillingState;
        relationshipPostalCode = account.BillingPostalCode;
    }

}
public with sharing class LocationController {
   
   public Id accountId           { get; set; }
   public Id leadId              { get; set; }
   public Id collateralId        { get; set; }
   public String recordName      { get; set; }
   public String recordStreet    { get; set; }
   public String recordCity      { get; set; }
   public String recordZip       { get; set; }

   public LocationController(ApexPages.StandardController controller) {
      Id objId = ApexPages.currentPage().getParameters().get('id');
      String sObjectType = String.ValueOf(controller.getRecord().getSObjectType());
      
      if (sObjectType == LEAD) {
         Lead l = [SELECT
            Id,
            Name,
            Street,
            City,
            PostalCode
         FROM
            Lead
         WHERE
            Id =: objId];

         recordName = l.Name;
         recordStreet = l.Street;
         recordCity = l.City;
         recordZip = l.PostalCode;

      } else if (sObjectType == ACCOUNT) {
         Account a = [SELECT
            Id,
            Name,
            BillingStreet,
            BillingCity,
            BillingPostalCode
         FROM
            Account
         WHERE
            Id =: objId];

         recordName = a.Name;
         recordStreet = a.BillingStreet;
         recordCity = a.BillingCity;
         recordZip = a.BillingPostalCode;

      } else if (sObjectType == COLLATERAL) {
         LLC_BI__Collateral__c c = [SELECT
            Id,
            Name,
            LLC_BI__Street_Address__c,
            LLC_BI__City__c,
            LLC_BI__Zip_Code__c
         FROM
            LLC_BI__Collateral__c
         WHERE
            Id =: objId];

         recordName = c.Name;
         recordStreet = c.LLC_BI__Street_Address__c;
         recordCity = c.LLC_BI__City__c;
         recordZip = c.LLC_BI__Zip_Code__c;
      }
   }

   private static final String LEAD = 'Lead';
   private static final String ACCOUNT = 'Account';
   private static final String COLLATERAL = 'LLC_BI__Collateral__c';
}
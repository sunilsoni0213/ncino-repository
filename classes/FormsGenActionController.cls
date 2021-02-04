public class FormsGenActionController {
    public FormsGenActionController(ApexPages.StandardController ctrl){}
       public pagereference navigateToForms (){
          string scenarioID = ApexPages.currentPage().getParameters().get('id');
              return new pagereference('/apex/nFORMS__FormGenerator?Type=LLC_BI__Scenario__c&Id='+scenarioID);
       }
   }
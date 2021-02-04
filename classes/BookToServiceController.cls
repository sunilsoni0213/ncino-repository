public with sharing class BookToServiceController {
	public Id recordId;
    
    public BookToServiceController() {
        recordId = ApexPages.currentPage().getParameters().get('id');
    }
  
    public PageReference goBack(){
      //Write your logic here and redirect
      PageReference retURL = new PageReference('/' + recordId);
      retURL.setRedirect(true);
        /**LLC_BI__Loan__c loanUpdate = [SELECT LLC_BI__Stage__c FROM LLC_BI__Loan__c WHERE Id =: recordId LIMIT 1];
        loanUpdate.LLC_BI__Stage__c = 'Booked';
        update loanUpdate; **/
      return retURL;
	}
}
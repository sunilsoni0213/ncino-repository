public with sharing class FundDepositController {
	public Id recordId;
    
    public FundDepositController() {
        recordId = ApexPages.currentPage().getParameters().get('id');
    }
  
    public PageReference goBack(){
      //Write your logic here and redirect
      PageReference retURL = new PageReference('/' + recordId);
      retURL.setRedirect(true);
      return retURL;
	}
}
public with sharing class FlowRedirectController {
    public Object FlowRedirectController() {
        String unique_id = ApexPages.currentPage().getParameters().get('id');
        if (unique_id == null) {
            // Return Home if no ID
            String url = '/home/home.jsp';
            return new PageReference(url);
        }
        // Get Contact ID and set Redirect
        String LoanId = [SELECT Name, Unique_Flow_Identifier__c, Id FROM LLC_BI__Loan__c WHERE Unique_Flow_Identifier__c =: unique_id ORDER BY CreatedDate DESC LIMIT 1].Id;
        // Did we find a Contact?
        if (LoanId == null) {
            // Return Home if no ID
            String url = '/home/home.jsp';
            return new PageReference(url);
        }
        // Redirect to Loan
        String url = '/' + LoanId;
        return new PageReference(url);
    }
}
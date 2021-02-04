/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ApplicationDetailsController extends nRetail.RetailLoanController {
    @RemoteAction
    global static void createAgreements(List<Id> termIds, Id applicationId) {

    }
    @RemoteAction
    global static void createIncome(Id loanId) {

    }
    @RemoteAction
    global static List<Id> getIncompleteTransactionLogIds(List<Id> transactionLogIds) {
        return null;
    }
    @RemoteAction
    global static List<nRetail.OffersController.PricingOptionModel> getPricingOptions(String loanId) {
        return null;
    }
    @RemoteAction
    global static List<nRetail.OffersController.PricingOptionModel> insertPricingOptions(String loanId, List<nRetail.OffersController.PricingOptionModel> options) {
        return null;
    }
    @RemoteAction
    global static List<String> processCreditReports(List<String> transactionLogIds, String loanId) {
        return null;
    }
    @RemoteAction
    global static nRetail.ApplicationDetailsController.ApplicationDetailsConfig refreshApplicationDetailsConfiguration(Id loanId, Id applicationId, Id screenId, Id routeId) {
        return null;
    }
    @RemoteAction
    global static List<String> requestCreditReports(Id loanId) {
        return null;
    }
global class ApplicationDetailsConfig {
}
}

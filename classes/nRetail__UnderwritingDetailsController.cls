/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class UnderwritingDetailsController extends nRetail.RetailLoanController {
    @RemoteAction
    global static nRetail.DecisionOverviewModel buildDecisionOverviewModel(String routeApp, String loanId, String contactId) {
        return null;
    }
    global static List<nRetail.UnderwritingDetailsController.Schedule> buildSchedules(String routeApp, String loanId) {
        return null;
    }
    @RemoteAction
    global static nRetail.UnderwritingOverviewModel buildUnderwritingOverviewModel(String routeApp, String loanId) {
        return null;
    }
    @RemoteAction
    global static List<nRetail.OffersController.PricingOptionModel> calculateDTI(Id loanId) {
        return null;
    }
    @RemoteAction
    global static nRetail.DecisionOverviewModel decisionOverviewModel(String loanId, String contactId) {
        return null;
    }
    @RemoteAction
    global static void deleteSObject(Id sObjectId) {

    }
    @RemoteAction
    global static void filterPricingOptionsByDTI(String loanId) {

    }
    @RemoteAction
    global static void generateAutoDecision(String loanId) {

    }
    @RemoteAction
    global static List<nRetail.OffersController.PricingOptionModel> getPricingOptions(String loanId) {
        return null;
    }
    @RemoteAction
    global static Boolean hasImportedDebts(String loanId) {
        return null;
    }
    @RemoteAction
    global static void importPreviousDebts(String contactId, String loanId) {

    }
    @RemoteAction
    global static List<nRetail.OffersController.PricingOptionModel> insertPricingOptions(String loanId, List<nRetail.OffersController.PricingOptionModel> options) {
        return null;
    }
    @RemoteAction
    global static Boolean isCreditReportOnFile(String contactId) {
        return null;
    }
    @RemoteAction
    global static String refreshSchedules(String routeApp, String loanId) {
        return null;
    }
    @RemoteAction
    global static nRetail.UnderwritingOverviewModel underwritingOverviewModel(String loanId) {
        return null;
    }
    @RemoteAction
    global static void updateSObjectsReferences(Id sObjectId, Id loanId, Id contactId) {

    }
global class FormModalConfig {
    global FormModalConfig() {

    }
}
global class Schedule {
    global Schedule() {

    }
}
}

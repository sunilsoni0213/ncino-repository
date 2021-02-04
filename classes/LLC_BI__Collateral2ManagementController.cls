/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class Collateral2ManagementController extends LLC_BI.SessionController {
    global Collateral2ManagementController() {

    }
    global Collateral2ManagementController(nFORCE.TemplateController controller) {

    }
    @RemoteAction
    global static Id createCollateralOwnership(LLC_BI.Collateral2ManagementController.CollateralOwnershipModel model) {
        return null;
    }
    @RemoteAction
    global static LLC_BI.Collateral2ManagementController.CollateralOwnershipModel createCollateralOwnershipModel(LLC_BI.Collateral2ManagementController.CollateralOwnershipModel model) {
        return null;
    }
    @RemoteAction
    global static Id createLoanAggregate(Id loanId) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI__Loan_Collateral2__c> createPledgeRecordsForCollateral(String collateralId, List<String> loanIds) {
        return null;
    }
    @RemoteAction
    global static Database.DeleteResult deletePledgedCollateral(String pledgedId) {
        return null;
    }
    @RemoteAction
    global static List<Database.DeleteResult> deletePledgedCollaterals(List<String> pledgedIds) {
        return null;
    }
    @RemoteAction
    global static LLC_BI.CollateralEditModel getEditPledgedCollateralModel(LLC_BI.CollateralEditModel editModel) {
        return null;
    }
    @RemoteAction
    global static String getPledgedCollateral(String contextId, String configContext) {
        return null;
    }
    @RemoteAction
    global static LLC_BI.CollateralScheduleModel getRelatedPledgeRecords(String rowId, Id configId) {
        return null;
    }
    @RemoteAction
    global static LLC_BI.CollateralScheduleModel getRelatedPledgeRecordsFromCollateralId(String rowId, Id configId) {
        return null;
    }
    @RemoteAction
    global static nFORCE.IScreenResource loadAdditionalData(nFORCE.IScreenResource resource) {
        return null;
    }
    @RemoteAction
    global static String performTreeGridGlobalAction(String contextId, String option, String rowId, String jsonifiedTree) {
        return null;
    }
    @RemoteAction
    global static LLC_BI.Collateral2ManagementController.SearchResult refreshSuggestedCollateral(String loanId, List<Id> existingCollateralIdsToExclude) {
        return null;
    }
    @RemoteAction
    global static LLC_BI.Collateral2ManagementController.SearchResult searchCollateral(String searchText, String typeFilter, List<Id> idsToExclude, Integer maxResults, Integer offset) {
        return null;
    }
    @RemoteAction
    global static LLC_BI.PledgedCollateralModel updatePledgedCollateral(LLC_BI.PledgedCollateralModel pledgedModel) {
        return null;
    }
    @RemoteAction
    global static LLC_BI.CollateralScheduleModel updateScheduleModel(LLC_BI.CollateralScheduleModel scheduleModel) {
        return null;
    }
    @RemoteAction
    global static LLC_BI.CollateralSummaryModel updateSummaryModel(LLC_BI.CollateralSummaryModel summaryModel) {
        return null;
    }
global class CollateralOwnershipModel {
    global CollateralOwnershipModel() {

    }
    global CollateralOwnershipModel(String loanId, String collateralId) {

    }
}
global class Result {
    global Result() {

    }
}
global class SearchResult {
    global SearchResult() {

    }
}
}

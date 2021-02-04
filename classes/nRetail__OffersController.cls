/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class OffersController extends nRetail.RetailLoanController {
    global OffersController(nFORCE.TemplateController controller) {

    }
    @RemoteAction
    global static List<nRetail.OffersController.PricingOptionModel> getPricingOptions(String loanId) {
        return null;
    }
    @RemoteAction
    global static nRetail.OffersController.ScenariosModel getScenariosModel(String loanId) {
        return null;
    }
    @RemoteAction
    global static nRetail.OffersController.ScenariosModel recalculate(String loanId, nRetail.OffersController.ScenariosModel model) {
        return null;
    }
    @RemoteAction
    global static nRetail.OffersController.PricingOptionModel selectOffer(String loanId, nRetail.OffersController.PricingOptionModel model) {
        return null;
    }
global class FeeModel {
    global FeeModel() {

    }
}
global class PricingOptionModel {
    global PricingOptionModel() {

    }
    global PricingOptionModel(LLC_BI__Pricing_Option__c option) {

    }
    global PricingOptionModel(nRetail__Pricing_Option__c option) {

    }
    global PricingOptionModel(Decimal amount, Decimal rate, Decimal term) {

    }
}
global class ScenariosModel {
    global ScenariosModel(Decimal amount, List<nRetail.OffersController.FeeModel> fees) {

    }
    global ScenariosModel(Decimal amount, Decimal approvedFor, List<nRetail.OffersController.FeeModel> fees) {

    }
}
}

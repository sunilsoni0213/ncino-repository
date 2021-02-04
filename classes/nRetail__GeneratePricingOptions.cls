/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class GeneratePricingOptions {
    global GeneratePricingOptions() {

    }
    @InvocableMethod(label='Generate Pricing Options' description='Generate Pricing Options')
    global static List<nRetail.GeneratePricingOptions.OutputParams> generatePricingOptions(List<nRetail.GeneratePricingOptions.PricingOptionRequest> poRequests) {
        return null;
    }
global class OutputParams {
    @InvocableVariable(label='Pricing Option Ids' description='Ids of the Pricing Options created' required=true)
    global List<String> pricingOptionIds;
    global OutputParams() {

    }
}
global class PricingOptionRequest {
    @InvocableVariable(label='Loan Id' description='The Id of a loan to generate pricing options for.' required=true)
    global Id loanId;
    global PricingOptionRequest() {

    }
}
}

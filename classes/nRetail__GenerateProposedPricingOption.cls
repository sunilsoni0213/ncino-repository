/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class GenerateProposedPricingOption {
    global GenerateProposedPricingOption() {

    }
    @InvocableMethod(label='Generate Proposed Pricing Option' description='Generate Proposed Pricing Option')
    global static List<nRetail.GenerateProposedPricingOption.OutputParams> generateProposedPricingOption(List<nRetail.GenerateProposedPricingOption.InputParams> requests) {
        return null;
    }
global class InputParams {
    @InvocableVariable(label='Loan Id' description='The Id of a loan to generate proposed pricing option for.' required=true)
    global Id loanId;
    global InputParams() {

    }
}
global class OutputParams {
    @InvocableVariable(label='Pricing Option' description='Proposed Pricing Option Returned' required=true)
    global LLC_BI__Pricing_Option__c proposedPricingOption;
    global OutputParams() {

    }
}
}

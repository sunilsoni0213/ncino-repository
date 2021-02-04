/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class LoanAutoDecision {
    global LoanAutoDecision() {

    }
    @InvocableMethod(label='Loan Auto Decision' description='Generate an auto decision for a given loan.')
    global static List<LLC_BI.LoanAutoDecision.OutputParams> invoke(List<LLC_BI.LoanAutoDecision.InputParams> params) {
        return null;
    }
global class InputParams {
    @InvocableVariable(label='Loan Id' description='The Id of a loan to generate a decision for.' required=true)
    global Id loanId;
    global InputParams() {

    }
}
global class OutputParams {
    @InvocableVariable(label='Scorecard Id' description='Id of the scorecard created.' required=true)
    global Id scorecardId;
    @InvocableVariable(label='Status' description='Status of the auto decision.' required=true)
    global String status;
    @InvocableVariable(label='Status Information' description='Additional information about the status.' required=true)
    global String statusInformation;
    global OutputParams() {

    }
}
}

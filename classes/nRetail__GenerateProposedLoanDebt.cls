/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class GenerateProposedLoanDebt {
    global GenerateProposedLoanDebt() {

    }
    @InvocableMethod(label='Generate Proposed Loan Debt' description='Generate Proposed Loan Debt')
    global static List<nRetail.GenerateProposedLoanDebt.OutputParams> generateProposedLoanDebt(List<nRetail.GenerateProposedLoanDebt.InputParams> requests) {
        return null;
    }
global class InputParams {
    @InvocableVariable(label='Account Id' description='The Id of the primary borrower on the loan.' required=true)
    global Id accountId;
    @InvocableVariable(label='Loan Id' description='The Id of a loan to generate proposed loan debt for.' required=true)
    global Id loanId;
    global InputParams() {

    }
}
global class OutputParams {
    @InvocableVariable(label='Debt' description='Proposed Loan Debt Returned' required=true)
    global LLC_BI__Debt__c proposedLoanDebt;
    global OutputParams() {

    }
}
}

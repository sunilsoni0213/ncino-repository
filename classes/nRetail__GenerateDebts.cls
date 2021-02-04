/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class GenerateDebts {
    global GenerateDebts() {

    }
    @InvocableMethod(label='Generate Debts' description='Generates debt records for specified credit reports and loan.')
    global static List<nRetail.GenerateDebts.OutputParams> invoke(List<nRetail.GenerateDebts.InputParams> params) {
        return null;
    }
global class InputParams {
    @InvocableVariable(label='Credit Report Ids' description='The Ids of the credit reports to generate debts from' required=true)
    global List<Id> creditReportIds;
    @InvocableVariable(label='Loan Id' description='The Id of a loan to generate debts for.' required=true)
    global Id loanId;
    global InputParams() {

    }
}
global class OutputParams {
    @InvocableVariable(label='Debt Ids' description='Ids of the debt records created' required=true)
    global List<String> debtIds;
    global OutputParams() {

    }
}
}

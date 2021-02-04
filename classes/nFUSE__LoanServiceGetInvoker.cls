/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class LoanServiceGetInvoker {
    global LoanServiceGetInvoker() {

    }
    @InvocableMethod(label='Get Loan structure' description='Gets the Loan structure for the desired Loan Id')
    global static List<nFUSE.LoanServiceGetInvoker.OutputParams> invoke(List<nFUSE.LoanServiceGetInvoker.InputParams> params) {
        return null;
    }
global class InputParams {
    @InvocableVariable(label='Loan Id List' description='List of loan Ids' required=true)
    global List<Id> loanIds;
    @InvocableVariable(label='Plugin Name' description='The Plugin Name to use for the request.' required=false)
    global String pluginName;
    @InvocableVariable(label='Plugin Version' description='The Plugin Version to use for the request.' required=false)
    global String pluginVersion;
    @InvocableVariable(label='External Transaction Log Id' description='External Transaction Log Id to use for the request.' required=false)
    global String transactionLogId;
    global InputParams() {

    }
}
global class OutputParams {
    @InvocableVariable(label='Loan Payload' description='Serialized list of loan nFORCE.IForce objects' required=true)
    global String loans;
    @InvocableVariable(label='Transaction Log Id' description='The Id of the Transaction created when sending this request' required=false)
    global String logId;
    @InvocableVariable(label='Transaction Log Status' description='Transaction Log Status' required=false)
    global String logStatus;
    @InvocableVariable(label='Transaction Log Vendor Status' description='Transaction Log Vendor Status' required=false)
    global String logVendorStatus;
    global OutputParams() {

    }
}
}

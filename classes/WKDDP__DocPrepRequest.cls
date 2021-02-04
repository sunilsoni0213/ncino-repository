/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class DocPrepRequest {
    global DocPrepRequest() {

    }
    @InvocableMethod(label='DocPrep Request' description='Initiate WK Deposit Account DocPrep')
    global static List<WKDDP.DocPrepRequest.OutputParams> initiateDocPrepRequest(List<WKDDP.DocPrepRequest.InputParams> inputParameters) {
        return null;
    }
global class InputParams {
    @InvocableVariable(label='Deposit Id' description='The Id of the LLC_BI__Deposit__c object.' required=true)
    global String depositId;
    global InputParams() {

    }
}
global class OutputParams {
    @InvocableVariable(label='Transaction Log External Id' description='nFUSE__Transaction_Log__c.nFUSE__External_Id__c value' required=false)
    global String transactionLogExternalId;
    global OutputParams() {

    }
}
}

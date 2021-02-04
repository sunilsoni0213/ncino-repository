/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class RelationshipServiceGetInvoker {
    @InvocableMethod(label='Get relationships' description='Gets relationships by their corresponding sObject Ids')
    global static List<nFUSE.RelationshipServiceGetInvoker.OutputParams> invoke(List<nFUSE.RelationshipServiceGetInvoker.InputParams> params) {
        return null;
    }
global virtual class InputParams {
    @InvocableVariable(label='Account Id List' description='List of account Ids' required=true)
    global List<Id> accountIds;
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
    @InvocableVariable(label='Transaction Log Id' description='The Id of the Transaction created when sending this request' required=false)
    global String logId;
    @InvocableVariable(label='Transaction Log Status' description='Transaction Log Status' required=false)
    global String logStatus;
    @InvocableVariable(label='Transaction Log Vendor Status' description='Transaction Log Vendor Status' required=false)
    global String logVendorStatus;
    @InvocableVariable(label='Relationships' description='Serialized list of nFORCE.IForce objects' required=true)
    global String relationshipsJSON;
    global OutputParams() {

    }
}
}

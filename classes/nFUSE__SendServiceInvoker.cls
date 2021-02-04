/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SendServiceInvoker {
    global SendServiceInvoker() {

    }
    @InvocableMethod(label='Send parameters to middleware' description='Sends the provided parameters to the middleware')
    global static List<nFUSE.SendServiceInvoker.OutputParams> invoke(List<nFUSE.SendServiceInvoker.InputParams> params) {
        return null;
    }
global class InputParams {
    @InvocableVariable(label='Send Service differentiator' description='A differentiating string used for locating specific Send Services' required=false)
    global String locatorDifferentiator;
    @InvocableVariable(label='Plugin Name' description='The Plugin Name to use for the request.' required=false)
    global String pluginName;
    @InvocableVariable(label='Plugin Version' description='The Plugin Version to use for the request.' required=false)
    global String pluginVersion;
    @InvocableVariable(label='Key Value List' description='List of pipe delimited key value pairs (ex. "key|value")' required=false)
    global List<String> propertyMap;
    @InvocableVariable(label='External Transaction Log Id' description='External Transaction Log Id to use for the request.' required=false)
    global String transactionLogId;
    @InvocableVariable(label='Salesforce Session Id' description='Salesforce Session Id' required=false)
    global String userSalesforceSessionId;
    global InputParams() {

    }
}
global class OutputParams {
    @InvocableVariable(label='Transaction Log Id' description='The Id of the Transaction created when sending this request' required=true)
    global String logId;
    @InvocableVariable(label='Transaction Log Status' description='Transaction Log Status' required=true)
    global String logStatus;
    @InvocableVariable(label='Transaction Log Vendor Status' description='Transaction Log Vendor Status' required=true)
    global String logVendorStatus;
    global OutputParams() {

    }
}
}

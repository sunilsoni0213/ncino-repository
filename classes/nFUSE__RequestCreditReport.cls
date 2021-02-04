/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class RequestCreditReport extends nFUSE.AInvocable {
    global RequestCreditReport() {

    }
    @InvocableMethod(label='Request Credit Report' description='Requests a Credit Report for an entity. Returns the Transaction Id.')
    global static List<nFUSE.RequestCreditReport.OutputParams> invoke(List<nFUSE.RequestCreditReport.InputParams> params) {
        return null;
    }
global class InputParams {
    @InvocableVariable(label='Account Id' description='The Account Id to request the Credit Report for.' required=false)
    global String accountId;
    @InvocableVariable(label='Hard Credit Pull' description='Is the Credit request a Hard request.' required=false)
    global Boolean isHardRequest;
    @InvocableVariable(label='Join Key' description='Key used to identify InputParam Accounts that should be run jointly.' required=false)
    global String joinKey;
    @InvocableVariable(label='Plugin Name' description='The Plugin Name to use for the Credit Report request.' required=false)
    global String pluginName;
    @InvocableVariable(label='Key Value List' description='List of pipe delimited key value pairs (ex. "key|value")' required=false)
    global List<String> propertyMap;
    global InputParams() {

    }
}
global class OutputParams {
    @InvocableVariable(label='Transaction Log Id' description='The Id of the Transaction created by the Credit Report request.' required=true)
    global String logId;
    global OutputParams() {

    }
}
}

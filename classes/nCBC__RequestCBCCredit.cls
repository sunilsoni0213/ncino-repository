/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class RequestCBCCredit {
    global RequestCBCCredit() {

    }
    @InvocableMethod(label='Request CBC Credit Report' description='Requests a CBC credit report for a contact. Returns the credit report Id.')
    global static List<nCBC.RequestCBCCredit.OutPutParameter> getCreditReport(List<nCBC.RequestCBCCredit.InputParameter> request) {
        return null;
    }
global class InputParameter {
    @InvocableVariable(label='Account Id' description='Account Id. The primary contact of the Account will be used to request the credit report.' required=false)
    global String accountId;
    @InvocableVariable(label='Contact Id' description='The contact Id to request the credit report for.' required=false)
    global String contactId;
    global InputParameter() {

    }
}
global class OutPutParameter {
    @InvocableVariable(label='Credit Report Id' description='The Id of the credit report that was generated.' required=false)
    global String reportId;
    global OutPutParameter() {

    }
}
}

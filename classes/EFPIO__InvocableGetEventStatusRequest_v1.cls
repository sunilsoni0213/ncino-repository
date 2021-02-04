/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class InvocableGetEventStatusRequest_v1 {
    @InvocableVariable(label='CorrelationId' description='The correlation id this request is tied to - defaults to a new guid if nothing is provided.' required=false)
    global String CorrelationId;
    @InvocableVariable(label='EventLogId' description='The Event Log Id to be used for obtaining the event status.' required=true)
    global String EventLogId;
    @InvocableVariable(label='ObjectId' description='The object id this request is tied to - defaults to the requesting user id if nothing is provided.' required=false)
    global String ObjectId;
    global InvocableGetEventStatusRequest_v1() {

    }
}

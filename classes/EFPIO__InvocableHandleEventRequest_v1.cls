/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class InvocableHandleEventRequest_v1 {
    @InvocableVariable(label='CorrelationId' description='The correlation id this request is tied to - defaults to a new guid if nothing is provided.' required=false)
    global String CorrelationId;
    @InvocableVariable(label='-D EventId' description='(Deprecated) The Event Id to be handled.' required=false)
    global String EventId;
    @InvocableVariable(label='EventLogId' description='The Event Log Id of the event to be handled.' required=true)
    global String EventLogId;
    @InvocableVariable(label='ObjectId' description='The object id this request is tied to - defaults to the requesting user id if nothing is provided.' required=false)
    global String ObjectId;
    @InvocableVariable(label='PerformAsync' description='The indicator whether to perform this handle event synchronously or asynchronously.' required=false)
    global Boolean PerformAsync;
    global InvocableHandleEventRequest_v1() {

    }
}

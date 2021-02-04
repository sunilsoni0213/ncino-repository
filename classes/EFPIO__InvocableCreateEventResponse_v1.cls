/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class InvocableCreateEventResponse_v1 {
    @InvocableVariable(label='CorrelationId' description='The correlation id.' required=false)
    global String CorrelationId;
    @InvocableVariable(label='-D EventId' description='(Deprecated) The Event Id to be handled.' required=false)
    global String EventId;
    @InvocableVariable(label='EventLogId' description='The Event Log Id containing the context of the event to be handled.' required=false)
    global String EventLogId;
    @InvocableVariable(label='IsSuccessful' description='Indicates if the status was obtained successfully.' required=false)
    global Boolean IsSuccessful;
    @InvocableVariable(label='Messages' description='Messages associated with the retrieval of the event status.' required=false)
    global String Messages;
    global InvocableCreateEventResponse_v1() {

    }
}

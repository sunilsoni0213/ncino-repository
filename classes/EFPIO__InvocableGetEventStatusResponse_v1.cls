/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class InvocableGetEventStatusResponse_v1 {
    @InvocableVariable(label='CorrelationId' description='The correlation id.' required=false)
    global String CorrelationId;
    @InvocableVariable(label='-D EventId' description='(Deprecated) The Event Id to be handled.' required=false)
    global String EventId;
    @InvocableVariable(label='EventLogId' description='The Event Log Id containing the context of the event to be handled.' required=false)
    global String EventLogId;
    @InvocableVariable(label='EventMessages' description='' required=false)
    global String EventMessages;
    @InvocableVariable(label='IsSuccessful' description='' required=false)
    global Boolean IsSuccessful;
    @InvocableVariable(label='LastUpdatedTimestamp' description='' required=false)
    global Long LastUpdatedTimestamp;
    @InvocableVariable(label='Messages' description='' required=false)
    global String Messages;
    @InvocableVariable(label='ParentEventLogId' description='' required=false)
    global String ParentEventLogId;
    @InvocableVariable(label='Status' description='' required=false)
    global String Status;
    @InvocableVariable(label='TransactionLogEId' description='' required=false)
    global String TransactionLogEId;
    global InvocableGetEventStatusResponse_v1() {

    }
}

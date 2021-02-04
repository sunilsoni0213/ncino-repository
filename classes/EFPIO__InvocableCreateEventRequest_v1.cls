/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class InvocableCreateEventRequest_v1 {
    @InvocableVariable(label='CorrelationId' description='The correlation id this request is tied to - defaults to a new guid if nothing is provided.' required=false)
    global String CorrelationId;
    @InvocableVariable(label='EventData' description='The Event Data to be used for this event.' required=false)
    global String EventData;
    @InvocableVariable(label='EventLogId' description='The Parent Event Log Id which relates to this event.' required=false)
    global String EventLogId;
    @InvocableVariable(label='FullyQualifiedInvocableClassName' description='The fully qualified invocable class name for this event which will be executed.' required=true)
    global String FullyQualifiedInvocableClassName;
    @InvocableVariable(label='ObjectId' description='The object id this request is tied to - defaults to the requesting user id if nothing is provided.' required=false)
    global String ObjectId;
    @InvocableVariable(label='Registry' description='The Registry associated to this event.' required=false)
    global String Registry;
    @InvocableVariable(label='SessionId' description='The session id intended to be the executor of this event.' required=false)
    global String SessionId;
    @InvocableVariable(label='Status' description='The Status to be used for this event.' required=true)
    global String Status;
    @InvocableVariable(label='TransactionLogEId' description='The Transaction Log External Id to be used for this event.' required=false)
    global String TransactionLogEId;
    @InvocableVariable(label='UserId' description='The user id intended to be the executor of this event.' required=false)
    global String UserId;
    global InvocableCreateEventRequest_v1() {

    }
}

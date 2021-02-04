/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class QueuedFlow implements Database.AllowsCallouts, System.Queueable {
    global QueuedFlow(String flowName, Id stepObjId) {

    }
    @InvocableMethod(label='Enqueue Flow' description='Queues a flow to be run in a new context')
    global static List<LLC_BI.QueuedFlow.OutputParams> invoke(List<LLC_BI.QueuedFlow.InputParams> inputParams) {
        return null;
    }
global class InputParams {
    @InvocableVariable(label='Flow Name' description='Name of the flow to queue.' required=true)
    global String flowName;
    @InvocableVariable(label='Step Object Id' description='The Id of the orchestration step object.' required=true)
    global Id stepObjId;
    global InputParams() {

    }
}
global class OutputParams {
    @InvocableVariable(label='Job Id' description='Id for the queued job' required=false)
    global Id jobId;
    global OutputParams() {

    }
}
}

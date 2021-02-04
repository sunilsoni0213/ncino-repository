/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class ATrigger extends nFORCE.ALifeCycleDataProvider implements nFORCE.IPipelineContainer {
    global ATrigger(List<nFORCE.ATriggerHandler> triggerHandlers, List<SObject> newObjects, List<SObject> oldObjects) {

    }
    global ATrigger(List<nFORCE.ATriggerHandler> triggerHandlers, List<SObject> newObjects, List<SObject> oldObjects, List<nFORCE.IRunnable> postDmlRunnables) {

    }
    global virtual Boolean executePipeline() {
        return null;
    }
    global virtual Boolean executePipeline(nFORCE.IPipelineContext context) {
        return null;
    }
    global virtual nFORCE.IPipelineContext getCurrentContext() {
        return null;
    }
    global virtual List<nFORCE.IPipelineComponent> getPipeline() {
        return null;
    }
    global abstract void performAction(nFORCE.ATriggerHandler param0, List<SObject> param1, List<SObject> param2, Set<Id> param3);
}

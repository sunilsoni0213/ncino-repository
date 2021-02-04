/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class ATrigger extends LLC_BI.ALifeCycleDataProvider {
    global ATrigger(List<LLC_BI.ATriggerHandler> deprecatedHandlers, List<SObject> newObjects, List<SObject> oldObjects) {

    }
    global ATrigger(List<LLC_BI.ATriggerHandler> deprecatedHandlers, List<SObject> newObjects, List<SObject> oldObjects, List<LLC_BI.IRunnable> postDmlRunnables) {

    }
    global abstract void performAction(LLC_BI.ATriggerHandler param0, List<SObject> param1, List<SObject> param2, Set<Id> param3);
}

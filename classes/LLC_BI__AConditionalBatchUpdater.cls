/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class AConditionalBatchUpdater extends LLC_BI.ALifeCycleDataProvider implements Database.Batchable<SObject>, Database.Stateful, LLC_BI.IConditional {
    global AConditionalBatchUpdater() {

    }
    global AConditionalBatchUpdater(LLC_BI.ISchedulable s) {

    }
    global virtual void execute(Database.BatchableContext BC, List<SObject> newObjs) {

    }
    global virtual void finish(Database.BatchableContext BC) {

    }
    global abstract Database.QueryLocator getQuery(Database.BatchableContext param0);
    global abstract void performUpdate(List<SObject> param0);
    global virtual Boolean should() {
        return null;
    }
    global virtual Database.QueryLocator start(Database.BatchableContext bc) {
        return null;
    }
}

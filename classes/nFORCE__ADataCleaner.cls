/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class ADataCleaner implements Database.Batchable<SObject>, nFORCE.IDataCleaner {
    global ADataCleaner() {

    }
    global abstract void clean(List<SObject> param0, nFORCE.ALifeCycleDataProvider param1);
    global void execute(Database.BatchableContext bc, List<SObject> newObjs) {

    }
    global virtual void finish(Database.BatchableContext bc) {

    }
    global abstract Database.QueryLocator getQuery(Database.BatchableContext param0);
    global virtual Database.QueryLocator start(Database.BatchableContext bc) {
        return null;
    }
}

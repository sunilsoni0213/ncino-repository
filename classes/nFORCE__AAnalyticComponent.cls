/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class AAnalyticComponent implements Database.Batchable<SObject> {
    global AAnalyticComponent() {

    }
    global abstract void execute(Database.BatchableContext param0, List<SObject> param1);
    global abstract void finish(Database.BatchableContext param0);
    global abstract Database.QueryLocator getQuery(Database.BatchableContext param0);
    global virtual Database.QueryLocator start(Database.BatchableContext bc) {
        return null;
    }
}

/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class ARelationshipStatisticsGenerator extends LLC_BI.AStatisticsGenerator {
    global ARelationshipStatisticsGenerator() {

    }
    global abstract void computeValue(Map<String,Decimal> param0, LLC_BI__Legal_Entities__c param1, LLC_BI__StatisticsConfiguration__c param2);
    global override Boolean shouldCompute(List<SObject> newObjs, List<SObject> oldObjs, Set<Id> acctIdSet, LLC_BI__StatisticsConfiguration__c configuration) {
        return null;
    }
}

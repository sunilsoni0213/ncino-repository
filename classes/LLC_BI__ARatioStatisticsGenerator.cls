/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class ARatioStatisticsGenerator extends LLC_BI.AStatisticsGenerator {
    global ARatioStatisticsGenerator() {

    }
    global virtual void computeValue(Id loanId, Map<String,Decimal> valuesMap, Map<String,Map<String,LLC_BI__Spread_Statement_Group_Total__c>> groupValues, Map<String,Map<String,LLC_BI__Spread_Statement_Record_Group__c>> lineItemValues, LLC_BI__StatisticsConfiguration__c configuration) {

    }
    global virtual void computeValue(Id loanId, Map<String,Object> dataMap, Map<String,Decimal> valuesMap, Map<String,Map<String,LLC_BI__Spread_Statement_Group_Total__c>> groupValues, Map<String,Map<String,LLC_BI__Spread_Statement_Record_Group__c>> lineItemValues, LLC_BI__StatisticsConfiguration__c configuration) {

    }
    global override virtual Boolean shouldCompute(List<SObject> newObjs, List<SObject> oldObjs, Set<Id> objIds, LLC_BI__StatisticsConfiguration__c configuration) {
        return null;
    }
}

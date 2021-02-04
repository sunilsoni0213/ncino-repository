/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class ARatioCalculator extends LLC_BI.ARatioStatisticsGenerator {
    global ARatioCalculator() {

    }
    global override virtual void computeValue(Id loanId, Map<String,Object> dataMap, Map<String,Decimal> valuesMap, Map<String,Map<String,LLC_BI__Spread_Statement_Group_Total__c>> groupValues, Map<String,Map<String,LLC_BI__Spread_Statement_Record_Group__c>> lineItemValues, LLC_BI__StatisticsConfiguration__c configuration) {

    }
    global abstract Decimal getDenominator(Id param0, Map<String,Object> param1, Map<String,Map<String,LLC_BI__Spread_Statement_Group_Total__c>> param2, Map<String,Map<String,LLC_BI__Spread_Statement_Record_Group__c>> param3, LLC_BI__StatisticsConfiguration__c param4);
    global abstract Decimal getNumerator(Id param0, Map<String,Object> param1, Map<String,Map<String,LLC_BI__Spread_Statement_Group_Total__c>> param2, Map<String,Map<String,LLC_BI__Spread_Statement_Record_Group__c>> param3, LLC_BI__StatisticsConfiguration__c param4);
}

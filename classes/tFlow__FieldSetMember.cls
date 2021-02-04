/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class FieldSetMember {
    global List<String> errors;
    global String fieldPath {
        get;
    }
    global List<tFlow.FieldSetMember> fields {
        get;
    }
    global String label {
        get;
        set;
    }
    global SObject queryData;
    global Map<String,String> requiredFields {
        get;
    }
    global FieldSetMember() {

    }
    global static String buildDynamicQueryFields(Schema.FieldSet fieldSet, String custom) {
        return null;
    }
    global static String buildDynamicQueryFields(List<tFlow.FieldSetMember> dynFields) {
        return null;
    }
    global static Schema.FieldSet getFieldSet(String fieldSetName, String namespace, Schema.DescribeSObjectResult sdResult) {
        return null;
    }
    global static Schema.FieldSet getFieldSet(String fieldSetName, String theObject, String namespace) {
        return null;
    }
    global static Schema.FieldSet getFieldSet(String fieldSetName, String theObject, String namespace, Map<String,Schema.SObjectType> gdCache) {
        return null;
    }
    global static List<String> getGridColumns(Schema.FieldSet fieldSet, List<String> extras) {
        return null;
    }
    global static Map<String,String> getGridLabels(Schema.FieldSet fieldSet, Map<String,String> extras) {
        return null;
    }
    global static SObject queryFieldsetData(Schema.FieldSet fieldSet, String objectId, String objectName, String idColumn, String custom) {
        return null;
    }
    global static SObject queryFieldsetData(Schema.FieldSet fieldSet, String objectId, String objectName, String idColumn, String custom, Map<String,Schema.SObjectType> gdCache) {
        return null;
    }
    global void setFields(Id objectId, String objectName, Schema.FieldSet fieldSet, Map<String,String> customLabels, String customQuery, String customQueryId) {

    }
    global virtual Boolean validate() {
        return null;
    }
}

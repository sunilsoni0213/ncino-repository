/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class Utility {
    global Utility() {

    }
    global Utility(ApexPages.StandardController controller) {

    }
    global static SObject CreateMappedRecord(String sourceObjStr, String targetObjStr, String sourceIdStr) {
        return null;
    }
    global static SObject CreateMappedRecord(String sourceObjStr, String targetObjStr, String sourceIdStr, String relationshipType) {
        return null;
    }
    global static String SelectProductObj(String ProductLine) {
        return null;
    }
    global static Map<Schema.SObjectType,Set<Id>> aggregateBySObjectType(Set<Id> allIds) {
        return null;
    }
    global static List<SObject> cloneObjects(List<SObject> sObjects, Schema.SObjectType objectType, List<String> fieldListToClone) {
        return null;
    }
    global static List<SObject> cloneObjects(List<SObject> sObjects, Schema.SObjectType objectType, List<String> fieldListToClone, Boolean preserve_id) {
        return null;
    }
    global static List<SObject> cloneObjects(List<SObject> sObjects, Schema.SObjectType objectType, List<String> fieldListToClone, Boolean preserve_id, Integer numberOfCopies) {
        return null;
    }
    global static List<SObject> cloneObjects(List<SObject> sObjects, Schema.SObjectType objectType, List<String> fieldListToClone, Boolean preserve_id, Integer numberOfCopies, List<String> fieldListToExclude) {
        return null;
    }
    global static List<SObject> cloneObjects(List<SObject> sObjects, Schema.SObjectType objectType, List<String> fieldListToClone, Integer numberOfCopies) {
        return null;
    }
    global static Schema.SObjectField findField(String fieldName, Map<String,Schema.SObjectField> fieldMap) {
        return null;
    }
    global static List<String> getFieldList(Map<String,Schema.SObjectField> fieldMap, Schema.SObjectField objectField, Boolean useObjectFieldRelationshipId) {
        return null;
    }
    global static List<String> getFieldList(Map<String,Schema.SObjectField> fieldMap, Schema.SObjectField objectField, Boolean useObjectFieldRelationshipId, Boolean enforceAccessibility) {
        return null;
    }
    global static List<LLC_BI__Field_Map__c> getFieldMapping(Schema.SObjectType sourceApiName, Schema.SObjectType targetApiName) {
        return null;
    }
    global static List<LLC_BI__Field_Map__c> getFieldMapping(Schema.SObjectType sourceApiName, Schema.SObjectType targetApiName, String relationshipType) {
        return null;
    }
    global static Set<Id> getObjectIds(List<SObject> objects) {
        return null;
    }
    global static String getQueryString(Schema.SObjectType objectType, Map<String,Schema.SObjectField> fieldMap, Set<Id> idSet, Schema.SObjectField objectField, Boolean useObjectFieldRelationshipId, List<Schema.SObjectField> stdFields) {
        return null;
    }
    global static String getQueryString(Schema.SObjectType objectType, Map<String,Schema.SObjectField> fieldMap, Set<Id> idSet, Schema.SObjectField objectField, Boolean useObjectFieldRelationshipId, List<Schema.SObjectField> stdFields, String orderByField) {
        return null;
    }
    global static String getQueryString(Schema.SObjectType objectType, Map<String,Schema.SObjectField> fieldMap, Set<Id> idSet, Schema.SObjectField objectField, Boolean useObjectFieldRelationshipId, List<Schema.SObjectField> stdFields, String orderByField, Boolean enforceAccessibility) {
        return null;
    }
    global static SObject getSObjectRecord(Id objectId, List<String> sObjectFields) {
        return null;
    }
    global static List<SObject> getSObjectRecords(Schema.SObjectType objectType, List<String> sObjectFields, String whereField, String orderByField, Object whereValue) {
        return null;
    }
    global static List<SObject> getSObjectRecords(Schema.SObjectType objectType, List<String> sObjectFields, String whereField, String orderByField, String whereValue) {
        return null;
    }
    global static List<SObject> getSObjectRecords(String sObjClass, List<String> sObjectFields, String whereField, String orderByField, String whereValue) {
        return null;
    }
    global static Set<String> getSourceFields(String origObj, String targetObj) {
        return null;
    }
    global static Set<Id> getUserIdsWithPemissionSet(List<String> permissionSetList) {
        return null;
    }
    global static Boolean hasPermissionSet(String permissionName) {
        return null;
    }
    global static Boolean hasPermissionSet(Id userId, String permissionName) {
        return null;
    }
    global static Boolean hasPermissionSet(Id userId, List<String> permissionSetList) {
        return null;
    }
    global static Boolean hasPermissionSet(List<String> permissionSetList) {
        return null;
    }
    global static String htmlEncodeJsonSerialize(Object input) {
        return null;
    }
    global static Boolean inList(String passed, String comparison) {
        return null;
    }
    global static Boolean inList(String passed, String Comparison, Boolean CaseSensitive) {
        return null;
    }
    global static Boolean inList(String passed, List<String> comparison) {
        return null;
    }
    global static Boolean inList(String passed, List<String> comparison, Boolean caseSensitive) {
        return null;
    }
    global static void insertIndividual(Account accountInformation, Contact contactInformation) {

    }
    global static Boolean isCompositeField(Schema.DescribeFieldResult fieldDescribe) {
        return null;
    }
    global static void mapObjFields(SObject targetObj, SObject mappedObj, List<LLC_BI__Field_Map__c> fieldMapping) {

    }
    global static void mapObjFields(SObject targetObj, SObject mappedObj, List<LLC_BI__Field_Map__c> fieldMapping, Map<Schema.DisplayType,Object> defaultMap) {

    }
    global static Boolean objectTypesEqual(List<SObject> objectList, Schema.SObjectType objType) {
        return null;
    }
global class utilityException extends Exception {
}
}

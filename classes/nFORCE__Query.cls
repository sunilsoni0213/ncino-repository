/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class Query {
    global Query() {

    }
    global static nFORCE.Query.ConditionPredicate condition(Object leftOperand, String operator, Object rightOperand) {
        return null;
    }
    global static nFORCE.Query.Builder selectFrom(Schema.SObjectType sType) {
        return null;
    }
global virtual class Builder {
    global virtual nFORCE.Query.Builder addField(Schema.SObjectField sField) {
        return null;
    }
    global virtual nFORCE.Query.Builder addFields(Schema.FieldSet fields) {
        return null;
    }
    global virtual nFORCE.Query.Builder addFields(List<Schema.SObjectField> fields) {
        return null;
    }
    global virtual nFORCE.Query.Builder addRelatedFields(Schema.SObjectField relationship, Schema.FieldSet fields) {
        return null;
    }
    global virtual nFORCE.Query.Builder addRelatedFields(Schema.SObjectField relationship, List<Schema.SObjectField> fields) {
        return null;
    }
    global virtual nFORCE.Query.Builder addRelatedFields(nFORCE.FieldPath path, List<Schema.SObjectField> fields) {
        return null;
    }
    global virtual nFORCE.Query.Builder addSubQuery(String relationship, nFORCE.Query.Builder subQuery) {
        return null;
    }
    global virtual nFORCE.Query.Builder addSubQuery(String relationshipName, Schema.SObjectType relationshipType, List<Schema.SObjectField> fields) {
        return null;
    }
    global virtual List<SObject> fetch() {
        return null;
    }
    global nFORCE.Query.ConditionPredicate getCondition() {
        return null;
    }
    global nFORCE.Query.OrderingDefinition getOrdering() {
        return null;
    }
    global virtual nFORCE.Query.SelectionDefinition getSelection() {
        return null;
    }
    global nFORCE.Query.Builder setCondition(nFORCE.Query.ConditionPredicate predicate) {
        return null;
    }
    global nFORCE.Query.Builder setCondition(Object leftOperand, String operator, Object rightOperand) {
        return null;
    }
    global nFORCE.Query.Builder setGrouping(List<Schema.SObjectField> fields) {
        return null;
    }
    global virtual nFORCE.Query.Builder setLimit(Integer pageSize) {
        return null;
    }
    global virtual nFORCE.Query.Builder setOrdering(nFORCE.Query.OrderingDefinition ordering) {
        return null;
    }
    global nFORCE.Query.Builder setOrdering(List<Schema.SObjectField> fields) {
        return null;
    }
    global nFORCE.Query.Builder setPaging(Integer pageSize, Integer pageNumber) {
        return null;
    }
    global virtual nFORCE.Query.Builder setSelection(nFORCE.Query.SelectionDefinition selection) {
        return null;
    }
    global virtual nFORCE.Query.Builder setSelection(nFORCE.Query.SelectionDefinition selection, String relationshipName) {
        return null;
    }
    global virtual nFORCE.Query.Builder setSelection(List<Schema.SObjectField> fields) {
        return null;
    }
    global virtual nFORCE.Query.Builder withPassiveSecurity() {
        return null;
    }
    global virtual nFORCE.Query.Builder withoutSecurity() {
        return null;
    }
    global virtual nFORCE.Query.Builder withoutSharing() {
        return null;
    }
}
global virtual class ConditionPredicate {
    global virtual nFORCE.Query.ConditionPredicate andAlso(nFORCE.Query.ConditionPredicate predicate) {
        return null;
    }
    global virtual nFORCE.Query.ConditionPredicate andAlso(Object leftOperand, String operator, Object rightOperand) {
        return null;
    }
    global virtual nFORCE.Query.ConditionPredicate orElse(nFORCE.Query.ConditionPredicate predicate) {
        return null;
    }
    global virtual nFORCE.Query.ConditionPredicate orElse(Object leftOperand, String operator, Object rightOperand) {
        return null;
    }
}
global virtual class OrderingDefinition {
    global OrderingDefinition() {

    }
    global nFORCE.Query.OrderingDefinition addField(Schema.SObjectField field) {
        return null;
    }
    global nFORCE.Query.OrderingDefinition addField(Schema.SObjectField field, String details) {
        return null;
    }
    global nFORCE.Query.OrderingDefinition addFields(Schema.SObjectField field1, Schema.SObjectField field2) {
        return null;
    }
    global nFORCE.Query.OrderingDefinition addFields(List<Schema.SObjectField> fields) {
        return null;
    }
    global nFORCE.Query.Builder toBuilder() {
        return null;
    }
}
global virtual class SelectionDefinition {
    global virtual nFORCE.Query.SelectionDefinition addField(Schema.SObjectField sField) {
        return null;
    }
    global virtual nFORCE.Query.SelectionDefinition addField(String field) {
        return null;
    }
    global virtual nFORCE.Query.SelectionDefinition addFieldFunction(Schema.DescribeFieldResult describeField, String functionFormat, String alias) {
        return null;
    }
    global virtual nFORCE.Query.SelectionDefinition addFieldTranslation(Schema.SObjectField field, String alias) {
        return null;
    }
    global virtual nFORCE.Query.SelectionDefinition addFields(List<Schema.SObjectField> fields) {
        return null;
    }
    global virtual nFORCE.Query.SelectionDefinition addRelatedField(nFORCE.FieldPath path, String fieldName) {
        return null;
    }
    global virtual nFORCE.Query.SelectionDefinition addRelatedFields(Schema.SObjectField relationship, List<Schema.SObjectField> fields) {
        return null;
    }
    global virtual nFORCE.Query.SelectionDefinition addSubQuery(String relationship, nFORCE.Query.Builder subQuery) {
        return null;
    }
    global virtual nFORCE.Query.SelectionDefinition addSubQuery(String relationshipName, Schema.SObjectType relationshipType, List<Schema.SObjectField> fields) {
        return null;
    }
    global virtual nFORCE.Query.SelectionDefinition addSubQuery(String relationshipName, Schema.SObjectType relationshipType, List<String> fields) {
        return null;
    }
    global virtual void assertIsAccessible() {

    }
}
}

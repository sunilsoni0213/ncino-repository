/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class ARelatedListDataProvider implements nFORCE.IRelatedListDataProvider {
    global Id objId {
        get;
        set;
    }
    global ARelatedListDataProvider() {

    }
    global void applyOverrideSettings(Map<String,Object> settings) {

    }
    global abstract String getFieldSetName();
    global String getFieldSetString(Schema.FieldSet fieldSet) {
        return null;
    }
    global String getFieldString(List<String> additionalFields) {
        return null;
    }
    global virtual List<Schema.FieldSetMember> getFields() {
        return null;
    }
    global Boolean getHasInitialized() {
        return null;
    }
    global abstract Schema.SObjectType getObjType();
    global virtual List<SObject> getObjectList() {
        return null;
    }
    global String getPackagePrefix() {
        return null;
    }
    global virtual Integer getPaginationSize() {
        return null;
    }
    global virtual String getTableTitleLabelName() {
        return null;
    }
    global virtual Integer getTotalObjectCount() {
        return null;
    }
    global void initialize() {

    }
    global virtual List<SObject> initializeData() {
        return null;
    }
    global virtual Boolean pagingSupported() {
        return null;
    }
    global virtual System.PageReference removeLookup(Id objectId, Id recordId) {
        return null;
    }
    global virtual Boolean renderDeleteLink() {
        return null;
    }
    global virtual Boolean renderEditLink() {
        return null;
    }
    global virtual Boolean renderItemLink() {
        return null;
    }
    global void setObjId(Id objectId) {

    }
    global void sortObjectList(String sortField, String sortOrder) {

    }
}

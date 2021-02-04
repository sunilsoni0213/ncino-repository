/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class RelatedListUiWrapController {
    global Boolean displayFullPage {
        get;
    }
    global Integer endRecordNumber {
        get;
        set;
    }
    global List<Schema.FieldSetMember> fieldSetMembers {
        get;
    }
    global Boolean hasInitialized {
        get;
    }
    global List<SObject> objectList {
        get;
        set;
    }
    global Id objId {
        get;
    }
    global String opType {
        get;
        set;
    }
    global Integer pagingSize {
        get;
    }
    global Boolean pagingSupported {
        get;
    }
    global Id recordId {
        get;
        set;
    }
    global String redirectUrl {
        get;
        set;
    }
    global Boolean renderDeleteLink {
        get;
    }
    global Boolean renderEditLink {
        get;
    }
    global Boolean renderItemLink {
        get;
    }
    global Boolean shouldRedirect {
        get;
        set;
    }
    global Boolean showNext {
        get;
    }
    global Boolean showPrevious {
        get;
    }
    global String sortColumnName {
        get;
        set;
    }
    global Integer startRecordNumber {
        get;
        set;
    }
    global String tableTitleLabelName {
        get;
    }
    global Integer totalObjectCount {
        get;
        set;
    }
    global RelatedListUiWrapController() {

    }
    global RelatedListUiWrapController(ApexPages.StandardController controller) {

    }
    global RelatedListUiWrapController(ApexPages.StandardController controller, String providerName, Boolean initializeData) {

    }
    global System.PageReference deleteRecord() {
        return null;
    }
    global System.PageReference editRecord() {
        return null;
    }
    global void initializeData() {

    }
    global System.PageReference navigateToRecord() {
        return null;
    }
    global System.PageReference nextGroupAction() {
        return null;
    }
    global System.PageReference previousGroupAction() {
        return null;
    }
    global System.PageReference removeLookup() {
        return null;
    }
    global System.PageReference showListAction() {
        return null;
    }
    global System.PageReference showListReturnAction() {
        return null;
    }
    global System.PageReference sortAction() {
        return null;
    }
}

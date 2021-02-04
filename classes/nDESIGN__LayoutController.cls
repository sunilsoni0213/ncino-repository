/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class LayoutController {
    global SObject contextObject {
        get;
        set;
    }
    global Id screenSectionId {
        get;
        set;
    }
    global LayoutController() {

    }
    global String getEditableView() {
        return null;
    }
    global String getGuid() {
        return null;
    }
    global String getPreviewView() {
        return null;
    }
    global String getReadOnlyView() {
        return null;
    }
    global String getSObjectJSON() {
        return null;
    }
    global Schema.SObjectType getSObjectType() {
        return null;
    }
    global nDESIGN__Screen_Section__c getScreenSection() {
        return null;
    }
    global nDESIGN__Widget__c getScreenWidget() {
        return null;
    }
    global nDESIGN__View__c getView() {
        return null;
    }
    global String getWidgetView() {
        return null;
    }
    @RemoteAction
    global static nDESIGN.View loadData(Id screenSectionId, String guid, SObject contextObject) {
        return null;
    }
    @RemoteAction
    global static nDESIGN.View saveData(Id screenSectionId, nDESIGN.View viewData, nDESIGN.View prevViewData) {
        return null;
    }
    @RemoteAction
    global static void saveNarrativeData(Id widgetId, String widgetData) {

    }
    @RemoteAction
    global static void saveRenderedView(Id sectionId, String viewData) {

    }
    global void setScreenWidget(nDESIGN__Widget__c value) {

    }
}

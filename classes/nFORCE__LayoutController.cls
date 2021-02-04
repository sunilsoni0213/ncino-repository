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
    global LayoutController(nFORCE.TemplateController controller) {

    }
    @RemoteAction
    global static nFORCE.IScreenResource createNew(nFORCE.IScreenResource resource) {
        return null;
    }
    global String getEditableView() {
        return null;
    }
    global String getGuid() {
        return null;
    }
    global virtual Boolean getIsLocked() {
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
    global nFORCE__Screen_Section__c getScreenSection() {
        return null;
    }
    global nFORCE__Widget__c getScreenWidget() {
        return null;
    }
    global nFORCE__View__c getView() {
        return null;
    }
    global String getWidgetView() {
        return null;
    }
    @RemoteAction
    global static nFORCE.IScreenResource loadAdditionalData(nFORCE.IScreenResource resource) {
        return null;
    }
    @RemoteAction
    global static nFORCE.View loadData(Id screenSectionId, String guid, SObject contextObject) {
        return null;
    }
    @RemoteAction
    global static nFORCE.View loadDataByContextId(Id screenSectionId, String guid, Id contextObjectId) {
        return null;
    }
    @RemoteAction
    global static List<nFORCE.IScreenResource> saveAllData(List<nFORCE.IScreenResource> resources) {
        return null;
    }
    @RemoteAction
    global static nFORCE.IScreenResource saveData(nFORCE.IScreenResource resource) {
        return null;
    }
    @RemoteAction
    global static void saveNarrativeData(Id widgetId, String widgetData) {

    }
    @RemoteAction
    global static nFORCE__Screen_Section__c saveSectionData(nFORCE.View screenSection) {
        return null;
    }
    global void setScreenWidget(nFORCE__Widget__c value) {

    }
}

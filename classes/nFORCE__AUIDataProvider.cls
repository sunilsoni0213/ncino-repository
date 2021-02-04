/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class AUIDataProvider extends nFORCE.ALifeCycleDataProvider {
    global AUIDataProvider() {

    }
    global nFORCE__Section_Configuration__c createChildSectionConfiguration(String sObjectType, String sectionHeader, String fieldSet, Decimal displayOrder, String screenSectionLookupKey, String parentRelationshipName, String parentConfigurationLookupKey) {
        return null;
    }
    global virtual nFORCE__Field_Configuration__c createFieldConfiguration(String screenSectionLookupKey, Boolean isHidden, String fieldName, String sObjectName) {
        return null;
    }
    global nFORCE__Group__c createGroup(List<nFORCE__Route_Group__c> data, String name, String app) {
        return null;
    }
    global virtual nFORCE__Group__c createGroup(List<nFORCE__Route_Group__c> data, String name, String app, Id screenId) {
        return null;
    }
    global nFORCE__Route__c createRoute(String name, String app, System.PageReference topBar, System.PageReference body, System.PageReference navigation, System.PageReference subNavigation, String iconClass, String screenLookupKey) {
        return null;
    }
    global List<nFORCE__Route_Group__c> createRouteGroups(List<nFORCE__Route_Group__c> data, Map<String,nFORCE__Route__c> routes, Id groupId, List<Map<String,Map<String,Object>>> junctions) {
        return null;
    }
    global nFORCE__Screen__c createScreen(String name) {
        return null;
    }
    global nFORCE__Screen_Section__c createScreenSection(String name, String screenLookupKey, String sobjectType, String sectionResource, Decimal displayOrder, Boolean isEditable, Boolean defaultEditable, Boolean defaultRendered) {
        return null;
    }
    global nFORCE__Section_Configuration__c createSectionConfiguration(String sObjectType, String sectionHeader, String fieldSet, Decimal displayOrder, String screenSectionLookupKey, String sectionResource) {
        return null;
    }
    global String getCurrentNamespace() {
        return null;
    }
    global String getCurrentNamespace(String target) {
        return null;
    }
    global virtual Id getGroupId(String groupName) {
        return null;
    }
    global Set<String> getInstalledAppsForGroup(List<nFORCE__Route_Group__c> data, String target) {
        return null;
    }
    global Map<String,nFORCE__Route__c> getInstalledRoutes() {
        return null;
    }
    global virtual Map<String,nFORCE__Screen_Section__c> getInstalledScreenSections() {
        return null;
    }
    global virtual Map<String,nFORCE__Screen__c> getInstalledScreens() {
        return null;
    }
    global String getPageName(System.PageReference pg) {
        return null;
    }
    global static String getPageNameStaticMethod(System.PageReference pg) {
        return null;
    }
    global List<nFORCE__Route_Group__c> getRoutingData() {
        return null;
    }
    global virtual void initialize() {

    }
    global Map<String,Map<String,Object>> routeJunctionConfiguration(String app, String parent, Decimal order, Boolean isHidden, Boolean isForwardNavDisabled) {
        return null;
    }
    global Map<String,Map<String,Object>> routeJunctionConfiguration(String app, String parent, Decimal order, Boolean isHidden, Boolean isForwardNavDisabled, Boolean isDefaultContextChild) {
        return null;
    }
}

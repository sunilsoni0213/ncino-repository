/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class UniversalDocManConfigurationController {
    global UniversalDocManConfigurationController() {

    }
    global UniversalDocManConfigurationController(nFORCE.RouteController ctrl) {

    }
    @RemoteAction
    global static void createChecklistsWithCriteria(String contextObject, List<Map<String,String>> criteria, Map<String,List<String>> categoryToChecklists) {

    }
    @RemoteAction
    global static void createChecklists(String contextObject, Map<String,String> criteria, Map<String,List<String>> categoryToChecklists) {

    }
    @RemoteAction
    global static void deleteChecklists(List<String> checklistIds) {

    }
    @RemoteAction
    global static Map<String,String> getAllRelationships(String typeName) {
        return null;
    }
    @RemoteAction
    global static List<NDOC.ChecklistGroup> getChecklists(String typeName) {
        return null;
    }
    @RemoteAction
    global static List<String> getFieldsForObject(String objectName) {
        return null;
    }
    @RemoteAction
    global static void reconcileAllCategoriesAndChecklists(String contextObject, List<Map<String,String>> criteria, Map<String,Map<String,List<Id>>> initialCategoriesAndChecklists, Map<String,List<String>> categoryToChecklistsAfter, Map<String,String> initialCategoryIdToName, Map<String,String> categoryIdToNameAfter) {

    }
    @RemoteAction
    global static void reconcileAllChecklists(String contextObject, List<Map<String,String>> criteria, Map<String,Map<String,List<Id>>> initialTypesAndChecklists, Map<String,List<String>> categoryToChecklistsAfter) {

    }
    @RemoteAction
    global static void reconcileCategoriesAndChecklists(String contextObject, Map<String,String> criteria, Map<String,Map<String,List<Id>>> initialCategoriesAndChecklists, Map<String,List<String>> categoryToChecklistsAfter, Map<String,String> initialCategoryIdToName, Map<String,String> categoryIdToNameAfter) {

    }
    @RemoteAction
    global static void reconcileChecklists(String contextObject, Map<String,String> criteria, Map<String,Map<String,List<Id>>> initialTypesAndChecklists, Map<String,List<String>> categoryToChecklistsAfter) {

    }
}

/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class ProdPkgUIGridController extends LLC_BI.RelatedListUiWrapController {
    global static String BUTTON_ACTION;
    global static String COLLATERAL_NAMESPACED;
    global static String COLLATERAL_SOBJECT_TYPE_NAME;
    global static String COMMENTS;
    global static String DELETE_FUNCTION;
    global static String DELETE_OPTION_STRING;
    global static String EDIT_FUNCTION;
    global static String EDIT_MARKER;
    global static String EDIT_OPTION_STRING;
    global static String EDIT_URL;
    global static String EMPTY;
    global static String EXCLUDED_SYSTEM_PROP_CATEGORY;
    global static String EXCLUDED_SYSTEM_PROP_KEY;
    global static String FACILITY_ID;
    global static String FIELD_ENDING;
    global static String FIELDS;
    global static String FUNCTION_TAG;
    global static String ID_FIELD;
    global static String IN_REVIEW_FIELD;
    global static String IS_BOOKED_FIELD;
    global static String IS_CLOSED_FIELD;
    global static String LABEL_IDENTIFIER;
    global static String LOAN_COLLATERAL_SOBJECT_TYPE_NAME;
    global static String NAME;
    global static String NAME_FIELD;
    global static String NEUTRAL;
    global static String NONPENDING;
    global static String OBJECT_TYPE;
    global static String PARAM_MARKER;
    global static String PENDING;
    global static String PHASE_OPTION;
    global static String PICKLIST;
    global static String PRODUCT_PACKAGE_ID;
    global static String PRODUCT_PKG_CATEGORY;
    global static String PRODUCT_PKG_KEY;
    global static String REFERENCE_ENDING;
    global static String REMOVE_OPTION_STRING;
    global static String REMOVED;
    global static String RET_URL;
    global static String SLASH;
    global static String STATUS_FIELD;
    global static String STYLE;
    global static String SUCCESS_THEME;
    global static String TARGET_OBJECT_ID;
    global static String USER_DATA;
    global static String USER_RECORD_ACCESS;
    global static String USER_RECORD_DELETE_ACCESS;
    global static String USER_RECORD_EDIT_ACCESS;
    global static String VALUE;
    global ProdPkgUIGridController() {

    }
    global ProdPkgUIGridController(ApexPages.StandardController controller) {

    }
    global ProdPkgUIGridController(ApexPages.StandardController controller, String providerName, Boolean initializeData) {

    }
    @RemoteAction
    global static String deleteRecordAction(String contextId, String rowId, String option, String dataProviderClassName) {
        return null;
    }
    @RemoteAction
    global static String getTreeGridDataQualified(String contextId, String dataProviderClassName) {
        return null;
    }
    @RemoteAction
    global static String getTreeGridDataQualifiedWithHierarchy(String contextId, String dataProviderClassName, String parentIdField) {
        return null;
    }
    @RemoteAction
    global static String getTreeGridDataQualifiedWithHierarchyCustomCell(String contextId, String dataProviderClassName, String parentIdField, String cellFactory) {
        return null;
    }
    @RemoteAction
    global static String getTreeGridFacilitiesWithHierarchy(String contextId, String dataProviderClassName, String parentIdField) {
        return null;
    }
    @RemoteAction
    global static String performTreeGridAction(String contextId, String rowId, String option) {
        return null;
    }
    @RemoteAction
    global static String saveApprovalModalRecordAction(String objectToUpdate, String dataProviderClassName) {
        return null;
    }
    @RemoteAction
    global static String saveRecordAction(String objectToUpdate, String dataProviderClassName) {
        return null;
    }
global class Facility {
    global String facilityId;
    global List<Object> fields;
    global String objectType;
}
}

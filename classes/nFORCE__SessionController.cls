/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class SessionController {
    global static String APEX;
    global static String EMPTY;
    global static String LEFT_PAREN;
    global static String PARAM_ID;
    global static String PARAM_SID;
    global static String PERIOD;
    global static String PRIMARY_RELATIONSHIP_ID;
    global static String PRIMARY_RELATIONSHIP_NAME;
    global static String QUESTION_MARK;
    global static String QUOTE;
    global static String RIGHT_PAREN;
    global static String SEPARATOR;
    global static String SESSION_TYPE;
    global nFORCE.Session sessionInstance;
    global nFORCE__Session__c sessionSObject;
    global String sessionType;
    global static String SPACE;
    global SessionController() {

    }
    global SessionController(nFORCE.TemplateController controller) {

    }
    global SessionController(nFORCE__Session__c session, Map<String,String> params) {

    }
    global virtual String getCurrentPageParam(String key) {
        return null;
    }
    global virtual Object getSessionData(String key) {
        return null;
    }
    global virtual Map<String,Object> getSessionData() {
        return null;
    }
    global virtual nFORCE.Session getSessionInstance() {
        return null;
    }
    global virtual nFORCE__Session__c getSessionSObject() {
        return null;
    }
    global virtual String resolveApp(String groupApp, String routeApp) {
        return null;
    }
    global virtual void setSession() {

    }
    global virtual void setSessionData(String key, Object obj) {

    }
    global virtual void updateSession() {

    }
}

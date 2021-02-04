/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class Route {
    global String app {
        get;
        set;
    }
    global Map<String,String> params;
    global Map<String,Boolean> render {
        get;
        set;
    }
    global tFlow__Route__c route {
        get;
    }
    global Map<String,Map<String,String>> routeAttributes {
        get;
    }
    global Map<String,String> routeLabels {
        get;
    }
    global List<tFlow__Route__c> routes {
        get;
        set;
    }
    global Route() {

    }
    global static List<tFlow__Route__c> getAll(String groupName) {
        return null;
    }
    global List<tFlow__Route__c> getCurrentRoute(String app) {
        return null;
    }
    global static Map<String,String> getRouteLabels(String Id) {
        return null;
    }
    global void setCurrentRoute() {

    }
}

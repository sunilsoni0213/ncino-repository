/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class PackageRegistrationRequest_v1 {
    global String Description {
        get;
        set;
    }
    global String LogStorageSObject {
        get;
        set;
    }
    global String Name {
        get;
        set;
    }
    global String Namespace {
        get;
        set;
    }
    global String PlmVersion {
        get;
        set;
    }
    global String PluginVersion {
        get;
        set;
    }
    global Map<String,EFPIO.ServiceInfo_v1> XPkgServices {
        get;
        set;
    }
    global PackageRegistrationRequest_v1() {

    }
    global PackageRegistrationRequest_v1(String name, String namespace, String pluginVersion, String plmVersion, String description, Map<String,EFPIO.ServiceInfo_v1> xPkgServices, String logStorageSObject) {

    }
}

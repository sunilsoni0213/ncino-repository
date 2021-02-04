/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class ConfigurationBase_v1 implements EFPIO.IConfiguration {
    global static String CROSS_PACKAGE_SERVICE;
    global static String GLOBAL_ABSTRACT_CLASS;
    global static String GLOBAL_ABSTRACT_METHOD;
    global static String GLOBAL_CLASS;
    global static String GLOBAL_INTERFACE;
    global static String GLOBAL_METHOD;
    global static String GLOBAL_VIRTUAL_CLASS;
    global static String GLOBAL_VIRTUAL_METHOD;
    global static String INVOCABLE_METHOD;
    global static String ON_PLATFORM_ORCHESTRATION_EVENT_HANDLER;
    global static String REMOTE_ACTION_ENDPOINT;
    global static String REST_SERVICE;
    global ConfigurationBase_v1() {

    }
    global ConfigurationBase_v1(String pluginName, String pluginVersion, EFPIO.PackageRegistrationRequest_v1 packageInfo) {

    }
    global void AddKeysToOmitFromMessaging(String key) {

    }
    global void AddPluginConfiguration(String key, String value, String dataType, Boolean isEncrypted) {

    }
    global void AddPropertyLabelToApiKeyTranslation(String label, String apiKey) {

    }
    global virtual void DeleteRoutes() {

    }
    global virtual void DeregisterNFORCE() {

    }
    global virtual void DeregisterServices() {

    }
    global virtual void DeregisterTriggers() {

    }
    global virtual Map<String,String> GetConfigurationPropertiesForMessages() {
        return null;
    }
    global virtual void InstallRoutes() {

    }
    global virtual void RegisterNFORCE() {

    }
    global virtual void RegisterServices() {

    }
    global virtual void RegisterTriggers() {

    }
    global virtual void SetApiNamesForMessaging() {

    }
    global virtual void SetKeysToOmitFromMessaging() {

    }
    global virtual void SupplementalDeregistrationEvents() {

    }
    global virtual void SupplementalRegistrationEvents() {

    }
    global void activate() {

    }
    global void deactivate() {

    }
    global Boolean isActiveInRegistry(String packageName) {
        return null;
    }
}

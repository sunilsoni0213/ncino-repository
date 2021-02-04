/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class AFeatureConfigurator {
    global AFeatureConfigurator() {

    }
    global virtual List<nFORCE.AFeatureConfigurator.ConfigurableComponent> getConfigurableFieldSets() {
        return null;
    }
    global virtual List<nFORCE.AFeatureConfigurator.ConfigurableComponent> getConfigurableObjects() {
        return null;
    }
    global virtual List<nFORCE.AFeatureConfigurator.ConfigurableComponent> getConfigurablePermissionSets() {
        return null;
    }
    global virtual List<nFORCE.AFeatureConfigurator.ConfigurableComponent> getConfigurableRecords() {
        return null;
    }
global virtual class ConfigurableComponent {
    global String description {
        get;
    }
    global String id {
        get;
    }
    global Boolean isCustom {
        get;
    }
    global String label {
        get;
    }
    global String name {
        get;
    }
    global nFORCE.AFeatureConfigurator.ConfigurableComponent parent {
        get;
    }
    global ConfigurableComponent(String name, String label, String description, Boolean isCustom) {

    }
    global ConfigurableComponent(String name, String label, String description, Boolean isCustom, nFORCE.AFeatureConfigurator.ConfigurableComponent parent) {

    }
    global ConfigurableComponent(String id, String name, String label, String description, Boolean isCustom) {

    }
    global ConfigurableComponent(String id, String name, String label, String description, Boolean isCustom, nFORCE.AFeatureConfigurator.ConfigurableComponent parent) {

    }
}
}

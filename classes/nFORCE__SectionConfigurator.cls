/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SectionConfigurator {
    global SectionConfigurator(String contentName) {

    }
    global SectionConfigurator(String contentName, nFORCE.AInflator inflator) {

    }
    global virtual void configure(String nameOfSection) {

    }
    global virtual void configure(List<String> nameOfSections) {

    }
    global virtual nFORCE.SectionConfigurator.ConfigurableSection getSectionRecord(String nameOfSection) {
        return null;
    }
    global virtual List<nFORCE.SectionConfigurator.ConfigurableSection> getSectionRecords(List<String> nameOfSections) {
        return null;
    }
    global Map<String,nFORCE.SectionConfigurator.ConfigurableSection> getSections() {
        return null;
    }
global class ConfigurableSection extends nFORCE.AFeatureConfigurator.ConfigurableComponent {
    global String attributes {
        get;
    }
    global String contentName {
        get;
    }
    global Boolean hasResource {
        get;
    }
    global Boolean isActive {
        get;
    }
    global Integer order {
        get;
    }
    global Object staticResource {
        get;
    }
    global ConfigurableSection(String id, String name, String label, Boolean hasResource, Boolean isActive, Decimal order, Object staticResource, String contentName) {

    }
    global ConfigurableSection(String id, String name, String label, String attributes, Boolean hasResource, Boolean isActive, Decimal order, String staticResource) {

    }
}
}

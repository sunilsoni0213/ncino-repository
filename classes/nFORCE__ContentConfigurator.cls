/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ContentConfigurator {
    global ContentConfigurator(String featureName) {

    }
    global ContentConfigurator(String featureName, nFORCE.AInflator inflator, nFORCE.AInflator childInflator) {

    }
    global virtual void configure(String nameOfContent) {

    }
    global virtual void configure(List<String> nameOfContents) {

    }
    global virtual nFORCE.ContentConfigurator.ConfigurableContent getContentRecord(String nameOfContent) {
        return null;
    }
    global virtual List<nFORCE.ContentConfigurator.ConfigurableContent> getContentRecords(List<String> nameOfContents) {
        return null;
    }
    global Map<String,nFORCE.ContentConfigurator.ConfigurableContent> getContents() {
        return null;
    }
global class ConfigurableContent extends nFORCE.AFeatureConfigurator.ConfigurableComponent {
    global String featureName {
        get;
    }
    global Boolean hasResource {
        get;
    }
    global Boolean isActive {
        get;
    }
    global Map<String,nFORCE.SectionConfigurator.ConfigurableSection> sections {
        get;
    }
    global String staticResource {
        get;
    }
    global ConfigurableContent(String id, String name, String label, Boolean hasResource, Boolean isActive, String featureName) {

    }
    global void setSections(Map<String,nFORCE.SectionConfigurator.ConfigurableSection> sections) {

    }
}
}

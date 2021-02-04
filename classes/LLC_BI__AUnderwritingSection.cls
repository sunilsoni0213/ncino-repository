/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class AUnderwritingSection implements System.Comparable {
    global String jsonDataSetter {
        get;
        set;
    }
    global LLC_BI__Underwriting_Summary__c underwritingSummary {
        get;
        set;
    }
    global Integer compareTo(Object compareTo) {
        return null;
    }
    global abstract Id create();
    global abstract Id edit();
    global virtual List<LLC_BI.AUnderwritingSection.LegalEntityContainer> getLegalEntities() {
        return null;
    }
    global virtual Map<LLC_BI__Legal_Entities__c,List<LLC_BI.AUnderwritingSection>> getSubsectionMap() {
        return null;
    }
    global virtual List<LLC_BI.AUnderwritingSection> getSubsections() {
        return null;
    }
    global abstract void load();
    global void loadData() {

    }
    global virtual System.PageReference remove() {
        return null;
    }
    global virtual System.PageReference removeData() {
        return null;
    }
    global virtual System.PageReference renderSection() {
        return null;
    }
    global virtual System.PageReference save() {
        return null;
    }
global class LegalEntityContainer {
    global LegalEntityContainer(LLC_BI__Legal_Entities__c entity) {

    }
    global LegalEntityContainer(LLC_BI__Legal_Entities__c entity, Boolean includeInRatios) {

    }
}
}

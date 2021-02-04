/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SectionConfiguration {
    global List<nDESIGN.FieldSet> availableFieldSets;
    global List<Map<String,String>> availableRelationships;
    global List<nDESIGN.SectionConfiguration> childConfigurations;
    global Integer displayOrder;
    global String fieldSetKey;
    global Id id;
    global String label;
    global String layoutGeneratorClass;
    global String layoutName;
    global String name;
    global Decimal order;
    global nDESIGN.SectionConfiguration parentConfiguration;
    global String parentRelationshipName;
    global Id screenSectionId;
    global String sectionHeader;
    global String sectionResourceClass;
    global String sObjectType;
    global SectionConfiguration() {

    }
    global SectionConfiguration(nDESIGN__Section_Configuration__c config) {

    }
    global SectionConfiguration(Id id, String name, String sectionResourceClass, String sObjectType, Integer order, String fieldSetKey, String layoutName, String layoutGeneratorClass, Id screenSectionId) {

    }
    global SectionConfiguration(Id id, String name, String sObjectType, Decimal order, String fieldSetKey, String layoutName, String layoutGeneratorClass, String parentRelationshipName, Id screenSectionId) {

    }
    global SectionConfiguration(Id id, String name, String sObjectType, Decimal order, String sectionHeader, String fieldSetKey, String layoutName, String layoutGeneratorClass, String parentRelationshipName, Id screenSectionId) {

    }
    global void setLabel() {

    }
    global static String transformNameToLabel(String name) {
        return null;
    }
}

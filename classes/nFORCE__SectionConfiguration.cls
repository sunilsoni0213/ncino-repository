/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SectionConfiguration {
    global List<nFORCE.FieldSet> availableFieldSets;
    global List<Map<String,String>> availableRelationships;
    global List<nFORCE.SectionConfiguration> childConfigurations;
    global Integer displayOrder;
    global nFORCE.SectionFieldConfiguration fieldConfiguration;
    global String fieldSetKey;
    global String filter;
    global List<nFORCE.FilterCriteria> filterCriteria;
    global Id id;
    global String label;
    global String layoutGeneratorClass;
    global String layoutName;
    global Integer limitValue;
    global String name;
    global Boolean offsetByLimit;
    global Decimal order;
    global nFORCE.SectionConfiguration parentConfiguration {
        get;
        set;
    }
    global String parentRelationshipName;
    global String parentSObjectType;
    global Id screenSectionId;
    global String sectionHeader;
    global String sectionResourceClass;
    global String sObjectType;
    global String sortCriteria;
    global List<nFORCE.SortCriteria> sortCriteriaList;
    global Boolean unique;
    global SectionConfiguration() {

    }
    global SectionConfiguration(nFORCE__Section_Configuration__c config) {

    }
    global SectionConfiguration(Id id, String name, String sectionResourceClass, String sObjectType, Integer order, String fieldSetKey, String layoutName, String layoutGeneratorClass, Id screenSectionId) {

    }
    global SectionConfiguration(Id id, String name, String sObjectType, Decimal order, String fieldSetKey, String layoutName, String layoutGeneratorClass, String parentRelationshipName, Id screenSectionId) {

    }
    global SectionConfiguration(Id id, String name, String sObjectType, Decimal order, String sectionHeader, String fieldSetKey, String layoutName, String layoutGeneratorClass, String parentRelationshipName, Id screenSectionId) {

    }
    global SectionConfiguration(Id id, String name, String sObjectType, Decimal order, String sectionHeader, String fieldSetKey, String layoutName, String layoutGeneratorClass, String parentRelationshipName, String filter, Id screenSectionId) {

    }
    global SectionConfiguration(Id id, String name, String sObjectType, Decimal order, String sectionHeader, String fieldSetKey, String layoutName, String layoutGeneratorClass, String parentRelationshipName, String filter, Boolean unique, Id screenSectionId) {

    }
    global SectionConfiguration(Id id, String name, String sObjectType, Decimal order, String sectionHeader, String fieldSetKey, String layoutName, String layoutGeneratorClass, String parentRelationshipName, String filter, Boolean unique, String sortCriteria, Id screenSectionId) {

    }
    global SectionConfiguration(Id id, String name, String sObjectType, Decimal order, String sectionHeader, String fieldSetKey, String layoutName, String layoutGeneratorClass, String parentRelationshipName, String filter, Boolean unique, Integer limitValue, Boolean offsetByLimit, String sortCriteria, Id screenSectionId) {

    }
    global void setFilter(String filter) {

    }
    global void setLabel() {

    }
    global static String transformNameToLabel(String name) {
        return null;
    }
}

/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ProductProgram implements System.Comparable {
    global static String ALL;
    global List<LLC_BI.ProductProgram> childPrograms {
        get;
        set;
    }
    global LLC_BI.ProductProgram.ProductProgramTemplate featureTemplate {
        get;
        set;
    }
    global String featureTemplateName {
        get;
    }
    global List<LLC_BI.ProductProgram.FeatureValue> featureValues {
        get;
        set;
    }
    global Map<String,String> featureValuesCumulative {
        get;
        set;
    }
    global Id parentId {
        get;
        set;
    }
    global Id productProgramHistoryId {
        get;
        set;
    }
    global Id programId {
        get;
        set;
    }
    global String programName {
        get;
        set;
    }
    global static String QUALITATIVE;
    global String qualTemplateName {
        get;
    }
    global static String QUANTITATIVE;
    global Decimal rank {
        get;
        set;
    }
    global ProductProgram(Id programId, Id parentId, String programName, LLC_BI.ProductProgram.ProductProgramTemplate qualificationTemplate, LLC_BI.ProductProgram.ProductProgramTemplate featureTemplate, Decimal rank, List<LLC_BI.ProductProgram> childPrograms) {

    }
    global Integer compareTo(Object compareTo) {
        return null;
    }
global class FeatureValue {
    global String attributeName {
        get;
        set;
    }
    global String attributeValue {
        get;
        set;
    }
    global String programId {
        get;
        set;
    }
    global FeatureValue(String programId, String attributeName, String attributeValue) {

    }
}
global class LifeCycleDataProvider extends LLC_BI.ALifeCycleDataProvider {
    global LifeCycleDataProvider() {

    }
}
global class ProductProgramTemplate {
    global List<LLC_BI.ProductProgram.TemplateCriteria> criteria {
        get;
        set;
    }
    global String name {
        get;
        set;
    }
    global String templateId {
        get;
        set;
    }
}
global class TemplateCell implements System.Comparable {
    global Decimal columnNumber {
        get;
        set;
    }
    global String excactValueToMatch {
        get;
        set;
    }
    global String factorName {
        get;
        set;
    }
    global Decimal High {
        get;
        set;
    }
    global Boolean isQualitative {
        get;
        set;
    }
    global Boolean isQuantitative {
        get;
        set;
    }
    global Decimal Low {
        get;
        set;
    }
    global Decimal riskGrade {
        get;
        set;
    }
    global Integer compareTo(Object compareTo) {
        return null;
    }
}
global class TemplateCriteria implements System.Comparable {
    global List<LLC_BI.ProductProgram.TemplateCell> cellList {
        get;
        set;
    }
    global Map<Decimal,LLC_BI.ProductProgram.TemplateCell> cells {
        get;
        set;
    }
    global String excactValueToMatch {
        get;
        set;
    }
    global Decimal High {
        get;
        set;
    }
    global Decimal Low {
        get;
        set;
    }
    global Decimal riskGrade {
        get;
        set;
    }
    global Integer compareTo(Object compareTo) {
        return null;
    }
}
global class TemplateFactor implements System.Comparable {
    global Decimal columnNumber {
        get;
        set;
    }
    global Boolean hasBeenEvaluated;
    global Boolean isQualitative {
        get;
        set;
    }
    global Boolean isQuantitative {
        get;
        set;
    }
    global String name {
        get;
        set;
    }
    global Integer compareTo(Object compareTo) {
        return null;
    }
}
}

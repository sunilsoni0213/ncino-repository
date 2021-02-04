/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class GuarantorAnalysisUnderwritingSection extends LLC_BI.DebtScheduleUnderwritingSection {
    global GuarantorAnalysisUnderwritingSection(LLC_BI__Underwriting_Summary__c underwritingSummary, LLC_BI__Loan__c loan, String name, Integer sortOrder, Map<Id,List<LLC_BI__Spread__c>> spreadsMap) {

    }
    global GuarantorAnalysisUnderwritingSection(LLC_BI__Underwriting_Summary__c underwritingSummary, LLC_BI__Loan__c loan, String name, Integer sortOrder, List<LLC_BI__Spread__c> spreads, List<LLC_BI__Spread_Statement_Type__c> templates) {

    }
    global override List<LLC_BI.AUnderwritingSection> getSubsections() {
        return null;
    }
    global override void load() {

    }
global class GuarantorAnaylysisSpreadSection extends LLC_BI.SpreadUnderwritingSection {
    global String sectionName {
        get;
    }
    global GuarantorAnaylysisSpreadSection(LLC_BI__Underwriting_Summary__c underwritingSummary, LLC_BI__Loan__c loan, Integer sortOrder, List<LLC_BI__Spread__c> spreads, List<LLC_BI__Spread_Statement_Type__c> templates, LLC_BI__Legal_Entities__c guarantor) {

    }
}
}

public with sharing class UnderwritingSummaryGlanceClass {

    private LLC_BI__Underwriting_Summary__c summary;
    public String underwritingSummaryName {get;set;}
    
    public UnderwritingSummaryGlanceClass(ApexPages.StandardController controller) {
        this.summary = (LLC_BI__Underwriting_Summary__c)controller.getRecord();
        this.underwritingSummaryName = [
                    SELECT
                        LLC_BI__Account__r.Name
                    FROM
                        LLC_BI__Loan__c
                    WHERE
                        LLC_BI__Underwriting_Summary__c =: this.summary.Id].LLC_BI__Account__r.Name;
    }
}
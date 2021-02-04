public class LoanStageDurationController {

    private List<AggregateResult> stages;
    public String closedStage;
    public String completeStage;
    Id recordId = ApexPages.currentPage().getParameters().get('id');
    
    public LoanStageDurationController(ApexPages.StandardController stdController) {
        closedStage = [SELECT LLC_BI__fieldValue__c
                       FROM LLC_BI__CFG_ConfigValue__c
                       WHERE (LLC_BI__Key__c = 'ALL'
                       OR LLC_BI__Key__c = 'Closed')
                       AND LLC_BI__Category__c = 'Loan Stage' LIMIT 1].LLC_BI__fieldValue__c;

        completeStage = [SELECT LLC_BI__fieldValue__c
                       FROM LLC_BI__CFG_ConfigValue__c
                       WHERE LLC_BI__Key__c = 'Complete' LIMIT 1].LLC_BI__fieldValue__c;
        
        stages = [SELECT LLC_BI__StageName__c, MAX(LLC_BI__Stage_Duration__c) stage, MAX(CreatedDate)
                  FROM LLC_BI__Opportunity_History__c
                  WHERE LLC_BI__Loan__r.Id =: recordId 
                  AND LLC_BI__StageName__c !=: closedStage
                  AND LLC_BI__StageName__c !=: completeStage
                  AND LLC_BI__StageName__c != null
                  GROUP BY LLC_BI__StageName__c
                  ORDER BY MAX(CreatedDate) DESC];
    }
 
    public List<AggregateResult> stagesList {
        get {return stages;}
    }
}
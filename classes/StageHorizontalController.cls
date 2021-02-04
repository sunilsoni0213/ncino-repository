public with sharing class StageHorizontalController {

    private Id objectId {get; set;}
    private sObjectType objectType {get; set;}
    public List<AggregateResult> stagesList {get; set;}
    public boolean hide {get {return (stagesList == null)|| (stagesList.size() == 0);}}

    public StageHorizontalController() {
        this.objectId = ApexPages.currentPage().getParameters().get(ID_FIELD);
        this.objectType = this.objectId.getSObjectType();
        getStagesForObject();
    }

    public StageHorizontalController(ApexPages.StandardController controller){
        this.objectId =  controller.getId();
        this.objectType = this.objectId.getSObjectType();
        getStagesForObject();
    }

    private void getStagesForObject(){
        if (this.objectType == LLC_BI__Treasury_Service__c.sObjectType) {
            this.stagesList = [
                SELECT LLC_BI__StageName__c name, MAX(LLC_BI__Stage_Duration__c) duration, MAX(CreatedDate)
                FROM LLC_BI__Opportunity_History__c
                WHERE 
                    LLC_BI__Treasury_Service__r.Id =: this.objectId
                    AND LLC_BI__Is_Excluded_From_Stage_Duration__c = false
                    AND LLC_BI__Stage_Change__c = true
                    AND LLC_BI__Stage_Duration__c <> NULL
                GROUP BY LLC_BI__StageName__c
                ORDER BY MAX(CreatedDate) DESC
            ];
        }
        else if (this.objectType == LLC_BI__Product_Package__c.sObjectType) {
            this.stagesList = [
                SELECT LLC_BI__StageName__c name, MAX(LLC_BI__Stage_Duration__c) duration, MAX(CreatedDate)
                FROM LLC_BI__Opportunity_History__c
                WHERE 
                    LLC_BI__Product_Package__r.Id =: this.objectId
                    AND LLC_BI__Is_Excluded_From_Stage_Duration__c = false
                    AND LLC_BI__Stage_Change__c = true
                    AND LLC_BI__Stage_Duration__c <> NULL
                GROUP BY LLC_BI__StageName__c
                ORDER BY MAX(CreatedDate) DESC
            ];
        }
        else{
            this.stagesList = new List<AggregateResult>();
        }
    }

    transient private static final String ID_FIELD = 'id';
}
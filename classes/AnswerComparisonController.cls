public class AnswerComparisonController{

    public List<nFORCE__Answer__c> answers {get; set;}
    public List<nFORCE__Answer__c> archanswers {get; set;}
    public List<nFORCE__Answer__c> newanswers {get; set;}
    public Id AcctId = Apexpages.currentPage().getParameters().get('id');
    
    public AnswerComparisonController(ApexPages.StandardController stdController) {
        answers = new List<nFORCE__Answer__c>();
        answers = [SELECT Id, nFORCE__option__r.nFORCE__Label__c, nFORCE__question__r.nFORCE__Label__c, nFORCE__Is_Archived__c, nFORCE__Label__c, nFORCE__question__r.Id, nFORCE__Question__c FROM nFORCE__Answer__c WHERE LLC_BI__Account__c =: AcctId];

        archanswers = new List<nFORCE__Answer__c>();
        newanswers = new List<nFORCE__Answer__c>();

        for (nFORCE__Answer__c a : answers) {
            if (a.nFORCE__Is_Archived__c == TRUE) {
                archanswers.add(a);
            } else {
                newanswers.add(a);
            }
        }

    }

}
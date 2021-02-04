public class VF_LifecycleController {

    public List<String> stages  {get; set;}
    public Map<String, String> graphics {get; set;}
    public Id loanId {get; set;}
    public String currentStage {get; set;}
    
    public class lifecycleData {
        public String stageName {get; set;}
        public String url {get; set;}
        public String help {get; set;}
    }
    
    public VF_LifecycleController(ApexPages.StandardController stdController) {
        loanId = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
        LLC_BI__Loan__c loan = [select LLC_BI__Stage__c from LLC_BI__Loan__c where Id=: loanId];
        currentStage = loan.LLC_BI__Stage__c;
    
        List<String> stages;
        stages.add('Qualification');
        stages.add('Proposal');
        
        Map<String, String> graphics;
        graphics.put('Qualification', '/resource/1344609354000/icon_qualify');
        graphics.put('Proposal', '/resource/1344609645000/icon_proposal');
    }
    
    public List<lifecycleData> getLifecycle() {
      List<lifecycleData> lcdata = new List<lifecycleData>();
      
     if(stages != null) {
          for(String s : stages) {
            lifecycleData lc = new lifecycleData();
            lc.stageName = s;
            lc.url = graphics.get(s);
            
            lcdata.add(lc);
            }
     }
        
    return lcdata;
    }
}
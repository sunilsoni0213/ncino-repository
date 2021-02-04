global class BatchLoanAutoDecision implements Database.Batchable<sObject>, Schedulable, Database.Stateful{
    String sessionId;

    global BatchLoanAutoDecision(String sessionId) {
        this.sessionId = sessionId;
    }

    global void execute(SchedulableContext context) {
        Database.executeBatch(new BatchLoanAutoDecision(sessionId), 1);
    }

    global Database.querylocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT ID FROM LLC_BI__Loan__c WHERE LLC_BI__Auto_Decision_Status__c = NULL AND LLC_BI__Application__r.nPortal__Status__c = 'Complete']);
    }
    global void execute(Database.BatchableContext BC, List<sObject> loans){     
       for(sObject loan : loans){
         LLC_BI.LoanAutoDecisionController.generateDecision(loan.Id, UserInfo.getSessionId());
       }
    }
    global void finish(Database.BatchableContext BC){
        BatchLoanAutoDecision.stopSchedule();
        BatchLoanAutoDecision.startSchedule(sessionId);
    }
    
    global static void startSchedule(String sessionId) {
        DateTime d = DateTime.now().addSeconds(10);
        String cronSchedule = d.second() + ' ' + d.minute() + ' ' + d.hour() + ' ' + d.day() + ' ' + d.month() + ' ? ' + d.year();
        System.schedule('BatchLoanAutoDecision', cronSchedule, new BatchLoanAutoDecision(sessionId));
    }
    
    global static void startSchedule() {
        BatchLoanAutoDecision.startSchedule(UserInfo.getSessionId());
    }
    
    global static void stopSchedule() {
        System.abortJob([SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = 'BatchLoanAutoDecision'].Id);
    }
    
    global static void saveSession() {
        nFORCE__System_Properties__c prop = [SELECT ID FROM nFORCE__System_Properties__c WHERE Name='BatchLoanAutoDecisionSessionId'];
        if (prop == null) {
            prop = new nFORCE__System_Properties__c(Name='BatchLoanAutoDecisionSessionId');
        }
        prop.nFORCE__Value__c = UserInfo.getSessionId();
        prop.nFORCE__Is_Active__c = true;
        prop.nFORCE__Category_Name__c = 'BatchLoanAutoDecision';
        prop.nFORCE__Key__c = 'SessionId';
        upsert prop; 
    }
}
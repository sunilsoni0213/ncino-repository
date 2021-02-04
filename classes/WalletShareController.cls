public with sharing class WalletShareController {
    
    public String report1     { get; set; }
    public String report2     { get; set; }
    public Id accountId       { get; set; }
    public String accountName { get; set; }

    public WalletShareController(ApexPages.StandardController stdController) {
        Account a = (Account)stdController.getRecord();
        accountId = a.Id;
        
        Report r1 = [SELECT Id FROM Report WHERE DeveloperName = 'Deposits'];
        Report r2 = [SELECT Id FROM Report WHERE DeveloperName = 'Loans_with_Relationships'];
        
        report1 = String.ValueOf(r1.Id);
        report2 = String.ValueOf(r2.Id);
    }
}
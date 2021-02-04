public with sharing class InstallNewConfigValues{

    public List<LLC_BI__CFG_ConfigValue__c> newValues {get;set;}
    
    public InstallNewConfigValues() {
        newValues = new List<LLC_BI__CFG_ConfigValue__c>();
    }
    
    public PageReference runCode() {
        Boolean NewLoanButton = this.LoanButton();
        
        Boolean NewDepositButton = this.DepositButton();
        
        Boolean NewEntityButton = this.EntityButton();
        
        if(!NewLoanButton) {
            LLC_BI__CFG_ConfigValue__c newCFG = new LLC_BI__CFG_ConfigValue__c();
                newCFG.LLC_BI__Category__c = PRODUCTSERVICES;
                newCFG.LLC_BI__Key__c = SHOWNEWLOANBUTTON;
                newCFG.LLC_BI__fieldValue__c = 'true';
            
            newValues.add(newCFG);
        }
        
        if(!NewDepositButton) {
            LLC_BI__CFG_ConfigValue__c newCFGD = new LLC_BI__CFG_ConfigValue__c();
                newCFGD.LLC_BI__Category__c =PRODUCTSERVICES;
                newCFGD.LLC_BI__Key__c = SHOWNEWDEPOSITBUTTON;
                newCFGD.LLC_BI__fieldValue__c = 'true';
            
            newValues.add(newCFGD);
        }
        
        if(!NewEntityButton) {
            LLC_BI__CFG_ConfigValue__c newCFGE = new LLC_BI__CFG_ConfigValue__c();
                newCFGE.LLC_BI__Category__c =PRODUCTSERVICES;
                newCFGE.LLC_BI__Key__c = SHOWNEWENTITYBUTTON;
                newCFGE.LLC_BI__fieldValue__c = 'true';
            
            newValues.add(newCFGE);
        }
        
        if(newValues.size() > 0){
            insert(newValues);
        }
        
        PageReference pageRef = new PageReference('/apex/LLC_BI__SystemAdministration');
        pageRef.setRedirect(true);
        
        return pageRef;
        
    }
    
    public Boolean LoanButton() {
        Boolean value = false;
        List<LLC_BI__CFG_ConfigValue__c> cfg = [SELECT Id FROM LLC_BI__CFG_ConfigValue__c WHERE LLC_BI__Category__c = :PRODUCTSERVICES  AND LLC_BI__Key__c = :SHOWNEWLOANBUTTON];
        
        if(cfg.size() > 0) {
            value = true;
        }
        return value;
    }
    
    public Boolean DepositButton() {
        Boolean value = false;
        List<LLC_BI__CFG_ConfigValue__c> cfg = [SELECT Id FROM LLC_BI__CFG_ConfigValue__c WHERE LLC_BI__Category__c = :PRODUCTSERVICES  AND LLC_BI__Key__c = :SHOWNEWDEPOSITBUTTON];
        
        if(cfg.size() > 0) {
            value = true;
        }
        return value;
    }
    
    public Boolean EntityButton() {
        Boolean value = false;
        List<LLC_BI__CFG_ConfigValue__c> cfg = [SELECT Id FROM LLC_BI__CFG_ConfigValue__c WHERE LLC_BI__Category__c = :PRODUCTSERVICES AND LLC_BI__Key__c = :SHOWNEWENTITYBUTTON];
        
        if(cfg.size() > 0) {
            value = true;
        }
        return value;
    }
    
    private static final String SHOWNEWLOANBUTTON = 'Show_New_Loan_Button';
    private static final String SHOWNEWDEPOSITBUTTON = 'Show_New_Deposit_Button';
    private static final String SHOWNEWENTITYBUTTON = 'Show_New_Entity_Button';
    private static final String PRODUCTSERVICES = 'Products & Services';
    
}
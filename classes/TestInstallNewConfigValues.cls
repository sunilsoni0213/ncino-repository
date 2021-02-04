@isTest
private class TestInstallNewConfigValues {

    @isTest
    public static void installed() {
        LLC_BI__CFG_ConfigValue__c newCFG1 = createCFGValue();
        LLC_BI__CFG_ConfigValue__c newCFG2 = createCFGValue1();
        LLC_BI__CFG_ConfigValue__c newCFG3 = createCFGValue2();
        
        Test.startTest();
        
        InstallNewConfigValues con = new InstallNewConfigValues();
        
        con.runCode();
        
        Test.stopTest();
    }
    
    @isTest
    public static void Noninstalled() {        
        Test.startTest();
        
        InstallNewConfigValues con = new InstallNewConfigValues();
        
        con.runCode();
        
        Test.stopTest();
    }
    
     private static LLC_BI__CFG_ConfigValue__c createCFGValue() {
        LLC_BI__CFG_ConfigValue__c testCFG = new LLC_BI__CFG_ConfigValue__c(
            LLC_BI__Category__c = 'Products & Services',
            LLC_BI__fieldValue__c = 'true',
            LLC_BI__Key__c = 'Show_New_Loan_Button');
        insert testCFG;
        return testCFG;
    }
    
    private static LLC_BI__CFG_ConfigValue__c createCFGValue1() {
        LLC_BI__CFG_ConfigValue__c testCFG = new LLC_BI__CFG_ConfigValue__c(
            LLC_BI__Category__c = 'Products & Services',
            LLC_BI__fieldValue__c = 'true',
            LLC_BI__Key__c = 'Show_New_Deposit_Button');
        insert testCFG;
        return testCFG;
    }

    private static LLC_BI__CFG_ConfigValue__c createCFGValue2() {
        LLC_BI__CFG_ConfigValue__c testCFG = new LLC_BI__CFG_ConfigValue__c(
            LLC_BI__Category__c = 'Products & Services',
            LLC_BI__fieldValue__c = 'true',
            LLC_BI__Key__c = 'Show_New_Entity_Button');
        insert testCFG;
        return testCFG;
    }

}
@isTest(isParallel=true)
private class csaTestClaimSystemController {

    @isTest
    static void testLoanController() {
        List<LLC_BI__Loan__c> testLoans = new List<LLC_BI__Loan__c>();
        List<String> testRecordIds = new List<String>();
        nCSA_FRAME.csaTestDataFactory.createProductPackageStructure();
        LLC_BI__Loan__c testLoan = [SELECT Id FROM LLC_BI__Loan__c LIMIT 1];
        testLoans.add(testLoan);
        testRecordIds.add(testLoan.Id);

        Test.startTest();

        Test.setCurrentPage(Page.csaLoanClaimSystem);
        ApexPages.StandardSetController stdSetCtrl = new ApexPages.StandardSetController(testLoans);
        stdSetCtrl.setSelected(testLoans);
        csaClaimSystemController ext = new csaClaimSystemController(stdSetCtrl);

        Test.stopTest();

        System.assertEquals(ext.recordIds, testRecordIds);
    }

    @isTest
    static void testProductPackageController() {
        List<LLC_BI__Product_Package__c> testProductPackages = new List<LLC_BI__Product_Package__c>();
        List<String> testRecordIds = new List<String>();
        nCSA_FRAME.csaTestDataFactory.createProductPackageStructure();
        LLC_BI__Product_Package__c testProductPackage = [SELECT Id FROM LLC_BI__Product_Package__c LIMIT 1];
        testProductPackages.add(testProductPackage);
        testRecordIds.add(testProductPackage.Id);

        Test.startTest();

        Test.setCurrentPage(Page.csaProductPackageClaimSystem);
        ApexPages.StandardSetController stdSetCtrl = new ApexPages.StandardSetController(testProductPackages);
        stdSetCtrl.setSelected(testProductPackages);
        csaClaimSystemController ext = new csaClaimSystemController(stdSetCtrl);

        Test.stopTest();

        System.assertEquals(ext.recordIds, testRecordIds);
    }
}
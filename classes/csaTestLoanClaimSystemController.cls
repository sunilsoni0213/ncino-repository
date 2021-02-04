@isTest
private class csaTestLoanClaimSystemController {

    @isTest
    static void testGetLoans() {
        nCSA_FRAME.csaTestDataFactory.createForceSystemProperty(
            csaClaimSystemConstants.PROPERTY_CATEGORY,
            csaClaimSystemConstants.PROPERTY_LOANKEY,
            csaClaimSystemConstants.PROPERTY_LOANVALUE,
            true,
            null
        );
        nCSA_FRAME.csaTestDataFactory.createProductPackageStructure();
        LLC_BI__Loan__c testLoan = [SELECT Id FROM LLC_BI__Loan__c LIMIT 1];

        Test.startTest();

        Map<Id, List<nFORCE.Field>> results = csaLoanClaimSystemController.getLoans('[' + testLoan.Id + ']');

        Test.stopTest();

        System.assertNotEquals(0, results.size());
    }

    @isTest
    static void testClaimLoans() {
        nCSA_FRAME.csaTestDataFactory.createProductPackageStructure();
        LLC_BI__Loan__c testLoan = [SELECT Id FROM LLC_BI__Loan__c LIMIT 1];
        LLC_BI__Role__c testRole = nCSA_FRAME.csaTestDataFactory.createRole('Credit');
        User testUser = nCSA_FRAME.csaTestDataFactory.createUser('testuser123456@ncino.com');

        Test.startTest();

        csaLoanClaimSystemController.claimLoans('[' + testLoan.Id + ']', testRole.Id, testUser.Id);
        LLC_BI__Loan__c loanResult = [SELECT Id, CSA_Queue__c FROM LLC_BI__Loan__c LIMIT 1];
        List<LLC_BI__LoanTeam__c> loanTeamResults = [SELECT Id FROM LLC_BI__LoanTeam__c WHERE LLC_BI__Loan__c = :loanResult.Id];

        Test.stopTest();

        System.assertEquals(null, loanResult.CSA_Queue__c);
        System.assertEquals(1, loanTeamResults.size());
    }

    @isTest
    static void testGetHeaders() {
        nCSA_FRAME.csaTestDataFactory.createForceSystemProperty(
            csaClaimSystemConstants.PROPERTY_CATEGORY,
            csaClaimSystemConstants.PROPERTY_LOANKEY,
            csaClaimSystemConstants.PROPERTY_LOANVALUE,
            true,
            null
        );

        Test.startTest();

        List<String> results = csaLoanClaimSystemController.getHeaders();

        Test.stopTest();

        System.assertNotEquals(0, results.size());
    }

    @isTest
    static void testGetRoles() {
        LLC_BI__Role__c testRole = nCSA_FRAME.csaTestDataFactory.createRole('Credit');

        Test.startTest();

        Map<Id, String> results = csaLoanClaimSystemController.getRoles();

        Test.stopTest();

        System.assertNotEquals(0, results.size());
        System.assertEquals(true, results.containsKey(testRole.Id));
    }

    @isTest
    static void testGetUsers() {
        User testUser = nCSA_FRAME.csaTestDataFactory.createUser('testuser123456@ncino.com');

        Test.startTest();

        Map<Id, String> results = csaLoanClaimSystemController.getUsers();

        Test.stopTest();

        System.assertNotEquals(0, results.size());
        System.assertEquals(true, results.containsKey(testUser.Id));
    }

    @isTest
    static void testGetFieldValueName() {
        nCSA_FRAME.csaTestDataFactory.createLoanBaseStructure();
        LLC_BI__Loan__c testLoan = [SELECT Id, Name FROM LLC_BI__Loan__c LIMIT 1];

        Test.startTest();

        Object result = csaLoanClaimSystemController.getFieldValueName(testLoan.Id);

        Test.stopTest();

        System.assertEquals(testLoan.Name, result);
    }
}
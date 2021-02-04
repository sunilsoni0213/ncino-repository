@isTest
private class csaTestClaimSystemUtilityController {

    @isTest
    static void testGetName() {
        nCSA_FRAME.csaTestDataFactory.createLoanBaseStructure();
        LLC_BI__Loan__c testLoan = [SELECT Id, Name FROM LLC_BI__Loan__c LIMIT 1];

        Test.startTest();

        Object result = csaClaimSystemUtilityController.getName(testLoan.Id);

        Test.stopTest();

        System.assertEquals(testLoan.Name, result);
    }

    @isTest
    static void testGetUsers() {
        User testUser = nCSA_FRAME.csaTestDataFactory.createUser('testuser123456@ncino.com');

        Test.startTest();

        Map<Id, String> results = csaClaimSystemUtilityController.getUsers();

        Test.stopTest();

        System.assertNotEquals(0, results.size());
        System.assertEquals(true, results.containsKey(testUser.Id));
    }

    @isTest
    static void testGetRoles() {
        LLC_BI__Role__c testRole = nCSA_FRAME.csaTestDataFactory.createRole('Credit');

        Test.startTest();

        Map<Id, String> results = csaClaimSystemUtilityController.getRoles();

        Test.stopTest();

        System.assertNotEquals(0, results.size());
        System.assertEquals(true, results.containsKey(testRole.Id));
    }

    @isTest
    static void testGetFieldSetName() {
        nCSA_FRAME.csaTestDataFactory.createForceSystemProperty(
            csaClaimSystemConstants.PROPERTY_CATEGORY,
            csaClaimSystemConstants.PROPERTY_LOANKEY,
            csaClaimSystemConstants.PROPERTY_LOANVALUE,
            true,
            null
        );

        Test.startTest();

        String results = csaClaimSystemUtilityController.getFieldSetName(
            csaClaimSystemConstants.PROPERTY_CATEGORY, csaClaimSystemConstants.PROPERTY_LOANKEY
        );

        Test.stopTest();

        System.assertEquals(csaClaimSystemConstants.PROPERTY_LOANVALUE, results);
    }

    @isTest
    static void testUpdateString() {
        List<String> testRecordIds = new List<String>();
        nCSA_FRAME.csaTestDataFactory.createLoanBaseStructure();
        LLC_BI__Loan__c testLoan = [SELECT Id FROM LLC_BI__Loan__c LIMIT 1];
        testRecordIds.add(testLoan.Id);

        Test.startTest();

        List<String> results = csaClaimSystemUtilityController.updateString('[' + testLoan.Id + ']');

        Test.stopTest();

        System.assertEquals(testRecordIds, results);
    }
}
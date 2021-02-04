@isTest
private class csaTestPPClaimSystemController {

    @isTest
    static void testGetProductPackages() {
        nCSA_FRAME.csaTestDataFactory.createForceSystemProperty(
            csaClaimSystemConstants.PROPERTY_CATEGORY,
            csaClaimSystemConstants.PROPERTY_PRODUCTPACKAGEKEY,
            csaClaimSystemConstants.PROPERTY_PRODUCTPACKAGEVALUE,
            true,
            null
        );
        nCSA_FRAME.csaTestDataFactory.createProductPackageStructure();
        LLC_BI__Product_Package__c testProductPackage = [SELECT Id FROM LLC_BI__Product_Package__c LIMIT 1];

        Test.startTest();

        Map<Id, List<nFORCE.Field>> results = csaProductPackageClaimSystemController.getProductPackages('[' + testProductPackage.Id + ']');

        Test.stopTest();

        System.assertNotEquals(0, results.size());
    }

    @isTest
    static void testClaimProductPackages() {
        nCSA_FRAME.csaTestDataFactory.createProductPackageStructure();
        LLC_BI__Product_Package__c testProductPackage = [SELECT Id FROM LLC_BI__Product_Package__c LIMIT 1];
        LLC_BI__Role__c testRole = nCSA_FRAME.csaTestDataFactory.createRole('Credit');
        User testUser = nCSA_FRAME.csaTestDataFactory.createUser('testuser123456@ncino.com');

        Test.startTest();

        csaProductPackageClaimSystemController.claimProductPackages('[' + testProductPackage.Id + ']', testRole.Id, testUser.Id);
        LLC_BI__Product_Package__c loanResult = [SELECT Id, CSA_Queue__c FROM LLC_BI__Product_Package__c LIMIT 1];
        List<LLC_BI__Product_Package_Team__c> loanTeamResults = [SELECT Id FROM LLC_BI__Product_Package_Team__c WHERE LLC_BI__Product_Package__c = :loanResult.Id];

        Test.stopTest();

        System.assertEquals(null, loanResult.CSA_Queue__c);
        System.assertEquals(1, loanTeamResults.size());
    }

    @isTest
    static void testGetHeaders() {
        nCSA_FRAME.csaTestDataFactory.createForceSystemProperty(
            csaClaimSystemConstants.PROPERTY_CATEGORY,
            csaClaimSystemConstants.PROPERTY_PRODUCTPACKAGEKEY,
            csaClaimSystemConstants.PROPERTY_PRODUCTPACKAGEVALUE,
            true,
            null
        );

        Test.startTest();

        List<String> results = csaProductPackageClaimSystemController.getHeaders();

        Test.stopTest();

        System.assertNotEquals(0, results.size());
    }

    @isTest
    static void testGetRoles() {
        LLC_BI__Role__c testRole = nCSA_FRAME.csaTestDataFactory.createRole('Credit');

        Test.startTest();

        Map<Id, String> results = csaProductPackageClaimSystemController.getRoles();

        Test.stopTest();

        System.assertNotEquals(0, results.size());
        System.assertEquals(true, results.containsKey(testRole.Id));
    }

    @isTest
    static void testGetUsers() {
        User testUser = nCSA_FRAME.csaTestDataFactory.createUser('testuser123456@ncino.com');

        Test.startTest();

        Map<Id, String> results = csaProductPackageClaimSystemController.getUsers();

        Test.stopTest();

        System.assertNotEquals(0, results.size());
        System.assertEquals(true, results.containsKey(testUser.Id));
    }

    @isTest
    static void testGetFieldValueName() {
        nCSA_FRAME.csaTestDataFactory.createProductPackageStructure();
        LLC_BI__Product_Package__c testProductPackage = [SELECT Id, Name FROM LLC_BI__Product_Package__c LIMIT 1];

        Test.startTest();

        Object result = csaProductPackageClaimSystemController.getFieldValueName(testProductPackage.Id);

        Test.stopTest();

        System.assertEquals(testProductPackage.Name, result);
    }
}
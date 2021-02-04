@isTest(IsParallel=true)
private class csaTestClaimSystemInstallerController {

    @isTest
    static void testCheckInstall() {
        nCSA_FRAME.csaTestDataFactory.createForceSystemProperty(
            nCSA_FRAME.csaConstants.CSASYSTEMPROPERTYCATEGORY,
            csaClaimSystemConstants.PROPERTY_INSTALLEDKEY,
            csaClaimSystemConstants.PROPERTY_INSTALLEDVALUE,
            true,
            null
        );

        Test.startTest();

        Boolean result = csaClaimSystemInstallerController.checkInstall();

        Test.stopTest();

        System.assertEquals(true, result);
    }

    @isTest
    static void testInstall() {
        Test.startTest();

        csaClaimSystemInstallerController.install();
        List<nFORCE__System_Properties__c> results = [SELECT Id FROM nFORCE__System_Properties__c LIMIT 3];

        Test.stopTest();

        System.assertEquals(3, results.size());
    }

    @isTest
    static void testUninstall() {
        nCSA_FRAME.csaTestDataFactory.createForceSystemProperty(
            csaClaimSystemConstants.PROPERTY_CATEGORY,
            csaClaimSystemConstants.PROPERTY_LOANKEY,
            csaClaimSystemConstants.PROPERTY_LOANVALUE,
            true,
            null
        );
        nCSA_FRAME.csaTestDataFactory.createForceSystemProperty(
            csaClaimSystemConstants.PROPERTY_CATEGORY,
            csaClaimSystemConstants.PROPERTY_PRODUCTPACKAGEKEY,
            csaClaimSystemConstants.PROPERTY_PRODUCTPACKAGEVALUE,
            true,
            null
        );
        nCSA_FRAME.csaTestDataFactory.createForceSystemProperty(
            nCSA_FRAME.csaConstants.CSASYSTEMPROPERTYCATEGORY,
            csaClaimSystemConstants.PROPERTY_INSTALLEDKEY,
            csaClaimSystemConstants.PROPERTY_INSTALLEDVALUE,
            true,
            null
        );

        Test.startTest();

        csaClaimSystemInstallerController.uninstall();
        List<nFORCE__System_Properties__c> results = [SELECT Id FROM nFORCE__System_Properties__c LIMIT 3];

        Test.stopTest();

        System.assertEquals(0, results.size());
    }
}
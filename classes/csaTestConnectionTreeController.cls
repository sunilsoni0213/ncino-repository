@isTest(isParallel=true)
private class csaTestConnectionTreeController {

    @isTest
    static void runTest() {
        Account a = nCSA_FRAME.csaTestDataFactory.createAccount('Corporation');

        Account c1 = nCSA_FRAME.csaTestDataFactory.createAccount('Individual');
        Account c2 = nCSA_FRAME.csaTestDataFactory.createAccount('Individual');

        LLC_BI__Connection_Role__c firstRole = new LLC_BI__Connection_Role__c(
            LLC_BI__Self_Reciprocating__c = true,
            LLC_BI__Sort_Order__c = 1);
        insert firstRole;

        LLC_BI__Connection_Role__c role = new LLC_BI__Connection_Role__c(
            LLC_BI__Sort_Order__c = 2,
            LLC_BI__Reciprocal_Role__c = firstRole.Id);
        insert role;

        LLC_BI__Connection__c con1 = new LLC_BI__Connection__c(
            LLC_BI__Connected_From__c = a.Id,
            LLC_BI__Connected_To__c = c1.Id,
            LLC_BI__Connection_Role__c = role.Id);
        insert con1;

        LLC_BI__Connection__c con2 = new LLC_BI__Connection__c(
            LLC_BI__Connected_From__c = a.Id,
            LLC_BI__Connected_To__c = c2.Id,
            LLC_BI__Connection_Role__c = role.Id);
        insert con2;

        Test.startTest();

        PageReference pageRef = Page.csaConnectionTree;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController stdController = new ApexPages.StandardController(a);
        csaConnectionTreeController ctrl = new csaConnectionTreeController(stdController);
        String result = ctrl.getConnections();

        Test.stopTest();

        System.assertNotEquals(null, result);

        System.assertEquals(true, firstRole.LLC_BI__Self_Reciprocating__c);
        System.assertEquals(1, firstRole.LLC_BI__Sort_Order__c);

        System.assertEquals(firstRole.Id, role.LLC_BI__Reciprocal_Role__c);
        System.assertEquals(2, role.LLC_BI__Sort_Order__c);

        System.assertEquals(a.Id, con1.LLC_BI__Connected_From__c);
        System.assertEquals(c1.Id, con1.LLC_BI__Connected_To__c);
        System.assertEquals(role.Id, con1.LLC_BI__Connection_Role__c);

        System.assertEquals(a.Id, con2.LLC_BI__Connected_From__c);
        System.assertEquals(c2.Id, con2.LLC_BI__Connected_To__c);
        System.assertEquals(role.Id, con2.LLC_BI__Connection_Role__c);
    }
}
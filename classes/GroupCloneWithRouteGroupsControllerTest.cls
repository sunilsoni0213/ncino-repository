@isTest
private class GroupCloneWithRouteGroupsControllerTest {

    static testMethod void testGroupCloneController() {

       // setup a reference to the page the controller is expecting with the parameters
        PageReference pref = Page.GroupClone;
        Test.setCurrentPage(pref);

        //create a new group record
        nFORCE__Group__c g = new nFORCE__Group__c();
        g.Name = TEST_NAME;
        insert g;

        //create a new route record
        nFORCE__Route__c r = new nFORCE__Route__c();
        r.Name = TEST_NAME;
        insert r;

        //create a route group for the new group
        nFORCE__Route_Group__c rg = new nFORCE__Route_Group__c();
        rg.nFORCE__Route__c = r.Id;
        rg.nFORCE__Group__c = g.Id;
        insert rg;
        
        // Construct the standard controller
        ApexPages.StandardController con = new ApexPages.StandardController(g);
        // create the controller
        GroupCloneWithRouteGroupsController ext = new GroupCloneWithRouteGroupsController(con);
        // Switch to test context
        Test.startTest();

        // call the cloneWithItems method
        PageReference ref = ext.cloneWithRouteGroups();
        // create the matching page reference
        PageReference redir = new PageReference('/' + ext.newRecordId + '/e?retURL=%2F' + ext.newRecordId);

        // make sure the user is sent to the correct url
        System.assertEquals(ref.getUrl(),redir.getUrl());

        // check that the new group was created successfully
        nFORCE__Group__c newGroup = [SELECT Id FROM nFORCE__Group__c WHERE Id =: ext.newRecordId];
        System.assertNotEquals(newGroup, null);

        // check that the line item was created successfully
        List<nFORCE__Route_Group__c> routeGroups = [SELECT Id FROM nFORCE__Route_Group__c WHERE nFORCE__Group__c =: newGroup.Id];
        System.assertEquals(routeGroups.size(), 1);

        // Switch back to runtime context
        Test.stopTest();
    }

    private static final String TEST_NAME = 'Test';
}
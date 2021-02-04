@isTest
public class UserSwitcherControllerTest {

    @isTest
    public static void testUserRetrieval(){
        //setup user
        User u = TestUtility.setupStandardUserWithProfile('UserSwitcherControllerTest@nCinoTest.com', false);
        //identify user as a DemoUser
        u.DemoUser__c = true;
        //insert record
        insert u;

        List<UserMsg> demoUsers;

        System.runAs(u){
            Test.startTest();
            demoUsers = UserSwitcherController.getActiveDemoUsers();
            Test.stopTest();
        }
        
        UserMsg createdUser;

        for(UserMsg du : demoUsers){
            if(du.Id == u.Id){
                createdUser = du;
            }
        }

        Integer activeDemoUsers = [SELECT COUNT() FROM User WHERE DemoUser__c = true AND IsActive = true];
        System.assertEquals(u.Id, createdUser.Id, 'The created user should be present in the list');
        System.assertEquals(activeDemoUsers, demoUsers.size(), 'The method should return all active demo users');
        System.assertEquals(true, createdUser.currentUser, 'The running user should be identified as the current user');
        
    }

    @isTest
    public static void testGetActiveUsers(){
        //setup user
        User u = TestUtility.setupStandardUserWithProfile('UserSwitcherControllerTest@nCinoTest.com', false);
        //identify user as a DemoUser
        u.IsActive = true;
        //insert record
        insert u;

        List<UserMsg> activeUsers;

        System.runAs(u){
            Test.startTest();
            activeUsers = UserSwitcherController.getActiveUsers();
            Test.stopTest();
        }
        
        UserMsg createdUser;

        for(UserMsg du : activeUsers){
            if(du.Id == u.Id){
                createdUser = du;
            }
        }

        Integer activeUserCount = [SELECT COUNT() FROM User WHERE IsActive = true AND Name != 'Automated Process'];
        System.assertEquals(u.Id, createdUser.Id, 'The created user should be present in the list');
        System.assertEquals(activeUserCount, activeUsers.size(), 'The method should return all active users');
        
    }

    @isTest
    public static void testUpdateDemoStatuses(){
        //setup user
        User u = TestUtility.setupStandardUserWithProfile('UserSwitcherControllerTest@nCinoTest.com', false);
        //identify user as a DemoUser
        u.DemoUser__c = true;
        //insert record
        insert u;

        List<UserMsg> activeUsers;

        System.runAs(u){
            activeUsers = UserSwitcherController.getActiveUsers();
        }
        
        UserMsg createdUser;

        for(UserMsg du : activeUsers){
            if(du.Id == u.Id){
                createdUser = du;
            }
        }

        System.assertEquals(u.Id, createdUser.id, 'The updated user should be the original user');
        System.assertEquals(true, createdUser.demoUser, 'The created user should be a demoUser');

        createdUser.demoUser = false;

        List<UserMsg> createdUserList = new List<UserMsg>();

        createdUserList.add(createdUser);

        List<UserMsg> updatedActiveUsers;

        System.runAs(u){
            Test.startTest();
            updatedActiveUsers = UserSwitcherController.updateDemoStatuses(JSON.serialize(createdUserList));
            Test.stopTest();
        }

        UserMsg expectedUsr;

        for (UserMsg usrm : updatedActiveUsers) {
            if (usrm.id == u.Id) {
                expectedUsr = usrm;
            }
        }

        System.assertEquals(u.Id, expectedUsr.id, 'The updated user should be the original user');
        System.assertEquals(false, expectedUsr.demoUser, 'The updated user should now not be a demoUser');
    }

    @isTest
    public static void testGetOrgId() {
        Test.startTest();
        Id orgId = UserSwitcherService.getOrgId();
        Test.stopTest();
        system.assertNotEquals(null, orgId, 'There should be an org Id');
    }

    @isTest
    public static void testCreateUserSwitcherLog() {

        User u = TestUtility.setupStandardUserWithProfile(
            'unit.test.user@' + String.valueOf(Integer.valueOf((Math.random() * 999))) + '.apexanalyticstest.com', 
            false
        );
        insert u;

        User x = TestUtility.setupStandardUserWithProfile(
            'unit.test.user@' + String.valueOf(Integer.valueOf((Math.random() * 999))) + '.apexanalyticstest.com',
            false
        );
        insert x;
        
        String testPayload =  '{"LoginStatus":"Complete","SourceUser":"' + u.Id + '","OriginalUser":"' + u.Id + '","TargetUser":"' + x.Id + '"}';

        Test.startTest();
        UserSwitcherService.createUserSwitcherLog(testPayload);
        Test.stopTest();

        List<UserSwitcherLog__c> pending = [
            SELECT 
            Id, 
            SourceUser__c, 
            TargetUser__c
            FROM UserSwitcherLog__c
        ];

        system.assertEquals(1, pending.size(), 'There should be one pending record');
        system.assertEquals(u.Id, pending[0].SourceUser__c, 'User u should be the source Id');
        system.assertEquals(x.Id, pending[0].TargetUser__c, 'User x should be the target Id');
    }

    @isTest
    public static void testGetMostRecentUserSwitcherLog() {
        User u = TestUtility.setupStandardUserWithProfile(
            'unit.test.user@' + String.valueOf(Integer.valueOf((Math.random() * 999))) + '.apexanalyticstest.com', 
            false
        );
        insert u;

        User x = TestUtility.setupStandardUserWithProfile(
            'unit.test.user@' + String.valueOf(Integer.valueOf((Math.random() * 999))) + '.apexanalyticstest.com',
            false
        );
        insert x;
        
        String testPayload =  '{"LoginStatus":"Complete","SourceUser":"' + u.Id + '","OriginalUser":"' + u.Id + '","TargetUser":"' + x.Id + '"}';
        UserSwitcherService.createUserSwitcherLog(testPayload);

        Test.startTest();
        String testRecentLogString = UserSwitcherService.getMostRecentUserSwitcherLog();
        Test.stopTest();

        Map<String, Object> testRecentLogMap = (Map<String, Object>)JSON.deserializeUntyped(testRecentLogString);

        system.assertNotEquals(null, testRecentLogString, 'There should be a map payload');
        system.assertEquals(u.Id, testRecentLogMap.get('sourceUser'), 'User u should be the source user');
        system.assertEquals(u.Id, testRecentLogMap.get('originalUser'), 'User u should be the original user');
        system.assertEquals(x.Id, testRecentLogMap.get('targetUser'), 'User x should be the target user');
    }

    @isTest
    public static void testUpdateUserSwitcherLogToComplete() {
        User u = TestUtility.setupStandardUserWithProfile(
            'unit.test.user@' + String.valueOf(Integer.valueOf((Math.random() * 999))) + '.apexanalyticstest.com', 
            false
        );
        insert u;

        User x = TestUtility.setupStandardUserWithProfile(
            'unit.test.user@' + String.valueOf(Integer.valueOf((Math.random() * 999))) + '.apexanalyticstest.com',
            false
        );
        insert x;
        
        String testPayload = '{"LoginStatus":"Pending","SourceUser":"' + u.Id + '","OriginalUser":"' + u.Id + '","TargetUser":"' + x.Id + '"}';
        UserSwitcherService.createUserSwitcherLog(testPayload);

        List<UserSwitcherLog__c> logs = [
            SELECT 
            Id,
            LoginStatus__c
            FROM UserSwitcherLog__c
        ];

        system.assertEquals(logs[0].LoginStatus__c, 'Pending', 'The log should be pending before the update');

        Id logToUpdate = logs[0].Id;

        Test.startTest();
        UserSwitcherService.updateUserSwitcherLogToComplete(logToUpdate);
        Test.stopTest();

        List<UserSwitcherLog__c> afterLogs = [
            SELECT 
            Id,
            LoginStatus__c
            FROM UserSwitcherLog__c
            WHERE Id =: logToUpdate
        ];

        system.assertEquals(afterLogs[0].LoginStatus__c, 'Complete', 'The log should be complete after the update');
    }
}
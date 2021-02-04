/****************************************************************************************
Name            : UserSwitcherService
Revision Log    : 2020-03-09 John Kuhl - CodeScience
                :
                :
Use             : Controller Class for User Switcher component
****************************************************************************************/
public class UserSwitcherService {

    /**
     * getActiveDemoUsers
     *
     * Query for all active Users identified as demo users
     *
     * @return users
     **/ 
    public static List<UserMsg> getActiveDemoUsers(){
        List<UserMsg> returnLst = new List<UserMsg>();

        Map<Id, User> demoUsers = new Map<Id, User>(UserSelector.getActiveDemoUsers());

        Id currentUserId = UserInfo.getUserId();
        
        if(!demoUsers.keySet().contains(currentUserId)){
            demoUsers.put(currentUserId, UserSelector.getCurrentUserInfo(currentUserId));
        }

        for(User u : demoUsers.values()){
            UserMsg uMsg = new UserMsg(u);
            if(u.Id == currentUserId){
                uMsg.currentUser = true;
            }
            returnLst.add(uMsg);
        }

        return returnLst;
    }

    /**
     * getActiveUsers
     *
     * Query for all active Users
     *
     * @return users
     **/ 
    public static List<UserMsg> getActiveUsers(){
        List<UserMsg> returnLst = new List<UserMsg>();

        Map<Id, User> activeUsers = new Map<Id, User>(UserSelector.getActiveUsers());

        for(User u : activeUsers.values()){
            UserMsg uMsg = new UserMsg(u);
            returnLst.add(uMsg);
        }

        return returnLst;
    }

    /**
     * updateDemoStatuses
     *
     * Update the active user's demoUser field to match
     * the checkbox on the front end
     *
     * @return users
     **/
    public static List<UserMsg> updateDemoStatuses(String stringifiedUsers) {
        // Example stringifiedUsers: '{currentUser=false, demoUser=true, id=0056g000004erYGAAY, name=Alex Roback}'
        // Deserialize stringifiedUsers and create a map of Id to demo status
        List<Object> usrs = (List<Object>)JSON.deserializeUntyped(stringifiedUsers);

        Map<Id, Boolean> usrDemoMap = new Map<Id, Boolean>();

        for (Object usr : usrs) {
            Map<String, Object> usrMap = (Map<String, Object>)usr;
            usrDemoMap.put((Id)usrMap.get('id'), (Boolean)usrMap.get('demoUser'));
        }

        List<User> userList = new List<User>([SELECT Id, DemoUser__c FROM USER WHERE Id IN : usrDemoMap.keySet()]);

        for (User user : userList) {
            user.demoUser__c = usrDemoMap.get(user.Id);
        }

        update userList;

        addPackageLicense(usrDemoMap.keySet());

        return UserSwitcherService.getActiveDemoUsers();
    }

    /**
     * createUserSwitcherLog
     *
     * Create a userSwitcherLog record from info
     * provided from the front end
     * 
     **/ 
    public static void createUserSwitcherLog(String userSwitcherRecord) {
        // Example userSwitcherRecord: '{LoginStatus=Pending, SourceUser=0056g000003vIV4AAM, TargetUser=0056g000004erZLAAY}'
        Map<String, Object> usrMap = (Map<String, Object>)JSON.deserializeUntyped(userSwitcherRecord);

        Id origUser;

        if (usrMap.get('OriginalUser') == null) {
            List<UserSwitcherLog__c> lastLog = UserSelector.getMostRecentUserSwitcherLog();

            if (!lastLog.isEmpty()) {
                if (lastLog[0].OriginalUser__c != null) {
                    origUser = lastLog[0].OriginalUser__c;

                } else {
                    origUser = lastLog[0].SourceUser__c;
                }

            } else {
                origUser = (Id)usrMap.get('SourceUser');
            }

        } else {
            origUser = (Id)usrMap.get('OriginalUser');
        }

        UserSwitcherLog__c log = new UserSwitcherLog__c(
            LoginStatus__c = (String)usrMap.get('LoginStatus'),
            SourceUser__c = (Id)usrMap.get('SourceUser'),
            TargetUser__c = (Id)usrMap.get('TargetUser'),
            OriginalUser__c = origUser,
            LoginDateTime__c = System.now()
        );

        insert log;
    }

    /**
     * getMostRecentUserSwitcherLog
     *
     * Return the most recent user switcher log to the 
     * front end
     *
     * @return serialized Map
     **/ 
    public static String getMostRecentUserSwitcherLog() {

        Map<String, String> returnMap = new Map<String, String>{
            'sourceUser' => null,
            'targetUser' => null,
            'originalUser' => null,
            'status' => null,
            'id' => null
        };

        List<UserSwitcherLog__c> mostRecentLog = UserSelector.getMostRecentUserSwitcherLog();

        if (!mostRecentLog.isEmpty()) {

            Boolean loggedWithinTheHour = (mostRecentLog[0].LoginDateTime__c > System.now().addHours(-1));

            if (loggedWithinTheHour) {
                returnMap.put('id', mostRecentLog[0].Id);
                returnMap.put('targetUser', mostRecentLog[0].TargetUser__c);
                returnMap.put('sourceUser', mostRecentLog[0].SourceUser__c);
                returnMap.put('status', mostRecentLog[0].LoginStatus__c);
                returnMap.put('originalUser', mostRecentLog[0].OriginalUser__c);

                return JSON.serialize(returnMap);

            } else {
                return null;
            }

        } else {
            return null;
        }
    }

    /**
     * updateUserSwitcherLogToComplete
     *
     * Update the specified log's status
     * to "complete"
     *
     **/ 
    public static void updateUserSwitcherLogToComplete(Id logId) {

        UserSwitcherLog__c log = [ SELECT Id, LoginStatus__c FROM UserSwitcherLog__c WHERE Id =: logId ];
        log.LoginStatus__c = 'Complete';
        update log;
    }

    /**
     * getOrgId
     *
     * Get the user's organization Id
     *
     * @return Organization Id
     **/ 
    public static ID getOrgId() {
        return userInfo.getOrganizationId();
    }

    /**
     * addPackageLicense
     *
     * If a user doesn't have a package license for nCino Platform, grant them one
     *
     **/ 
    @future
    public static void addPackageLicense(Set<Id> userIds){
        //Query for PackageLicense
        PackageLicense packageLicense = [SELECT Id FROM PackageLicense WHERE NamespacePrefix = 'LLC_BI'];

        //Query for UserPackageLicense records related to specified PackageLicense and UserIds
        List<UserPackageLicense> userLicenses = [SELECT Id, UserId, PackageLicenseId FROM UserPackageLicense WHERE PackageLicenseId =: packageLicense.Id AND UserId IN :userIds];

        Set<Id> usersWithLicenses = new Set<Id>();        
        if(!userLicenses.isEmpty()){
            for(UserPackageLicense upl : userLicenses){
                usersWithLicenses.add(upl.UserId);
            }
        }

        List<UserPackageLicense> uplInsert = new List<UserPackageLicense>();
        
        for(Id id : userIds){
            if(!usersWithLicenses.contains(id)){
                //Create and insert UserPackageLicense record for user
                UserPackageLicense upl = new UserPackageLicense();
                upl.UserId = id;
                upl.PackageLicenseId = packageLicense.Id;
                uplInsert.add(upl);
            }
        }

        if(!uplInsert.isEmpty()){
            insert uplInsert;
        }
    }
}
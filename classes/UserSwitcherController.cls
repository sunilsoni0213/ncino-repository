/****************************************************************************************
Name            : UserSwitcherController
Revision Log    : 2020-03-09 John Kuhl - CodeScience
                :
                :
Use             : Controller Class for User Switcher component
****************************************************************************************/
public class UserSwitcherController {
    
    /**
     * getActiveDemoUsers
     *
     * Query for all active Users identified as demo users
     *
     * @return users
     **/ 
    @AuraEnabled
    public static List<UserMsg> getActiveDemoUsers(){
        try{
            return UserSwitcherService.getActiveDemoUsers();
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * getActiveUsers
     *
     * Query for all active Users
     *
     * @return users
     **/ 
    @AuraEnabled
    public static List<UserMsg> getActiveUsers() {
        try{
            return UserSwitcherService.getActiveUsers();
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * updateDemoStatuses
     *
     * Update the active user's demoUser field to match
     * the checkbox on the front end
     *
     * @return users
     **/
    @AuraEnabled
    public static List<UserMsg> updateDemoStatuses(String stringifiedUsers) {
        try {
            return UserSwitcherService.updateDemoStatuses(stringifiedUsers);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * createUserSwitcherLog
     *
     * Create a userSwitcherLog record from info
     * provided from the front end
     * 
     **/  
    @AuraEnabled
    public static void createUserSwitcherLog(String userSwitcherRecord) {
        try {
            UserSwitcherService.createUserSwitcherLog(userSwitcherRecord);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * getMostRecentUserSwitcherLog
     *
     * Return the most recent user switcher log to the 
     * front end
     *
     * @return serialized Map
     **/
    @AuraEnabled
    public static String getMostRecentUserSwitcherLog() {
        try {
            return UserSwitcherService.getMostRecentUserSwitcherLog();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * updateUserSwitcherLogToComplete
     *
     * Update the specified log's status
     * to "complete"
     *
     **/ 
    @AuraEnabled
    public static void updateUserSwitcherLogToComplete(Id logId) {
        try {
            UserSwitcherService.updateUserSwitcherLogToComplete(logId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * getOrgId
     *
     * Get the user's organization Id
     *
     * @return Org Id
     **/ 
    @AuraEnabled (cacheable=true)
    public static String getOrgId() {
        try {
            return UserSwitcherService.getOrgId();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * getCommunityId
     *
     * Returns the user's networkId required to login as community user
     *
     * @return Id
     **/ 
    @AuraEnabled
    public static Id getCommunityId(Id userId) {
        try {
            return UserSelector.getCommunityId(userId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
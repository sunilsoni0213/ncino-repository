/****************************************************************************************
Name            : UserSelector
Revision Log    : 2020-03-02 John Kuhl - CodeScience
                :
                :
Use             : Selector Class for User object
****************************************************************************************/
public class UserSelector {

    private static List<String> invalidLicenses = new List<String>{
        'Chatter Free',
        'Chatter External',
        'Analytics Cloud Integration User'
    };

    /**
     * getActiveDemoUsers
     *
     * Query for all active Users identified as demo users
     *
     * @return users
     **/ 
    public static List<User> getActiveDemoUsers() {

        List<User> users =[SELECT Id, 
                                DemoUser__c,
                                Name, 
                                SmallPhotoURL,
                                IsProfilePhotoActive,
                                Title,
                                Profile.Name,
                                Profile.UserLicense.Name
                                FROM User
                                WHERE IsActive = true
                                AND DemoUser__c = true
                                AND Profile.UserLicense.Name Not In :invalidLicenses
                                ORDER BY Name ASC];

        return users;
    }

    /**
     * getActiveUsers
     *
     * Query for all active Users
     *
     * @return users
     **/ 
    public static List<User> getActiveUsers() {

        List<User> users =  [SELECT Id, 
                                    DemoUser__c,
                                    Name, 
                                    SmallPhotoURL,
                                    IsProfilePhotoActive,
                                    Title,
                                    Profile.Name,
                                    Profile.UserLicense.Name
                                    FROM User
                                    WHERE IsActive = true
                                    AND Profile.UserLicense.Name Not In :invalidLicenses
                                    ORDER BY Name ASC]; 

        return users;
    }

    /**
     * getCurrentUserInfo
     *
     * Query for title/photo/name info for current user
     *
     * @return users
     **/ 
    public static User getCurrentUserInfo(Id userId){
        User user = [SELECT Id, 
                            Name, 
                            DemoUser__c,
                            SmallPhotoURL,
                            IsProfilePhotoActive,
                            Profile.Name,
                            Title
                            FROM User
                            WHERE Id =: userId];

        return user;
    }

    /**
     * getMostRecentUserSwitcherLog
     *
     * Query the most recent user switcher log
     *
     * @return List<UserSwitcherLog__c>
     **/ 
    public static List<UserSwitcherLog__c> getMostRecentUserSwitcherLog() {
        List<UserSwitcherLog__c> mostRecentLog = [SELECT Id,
                                                         SourceUser__c, 
                                                         TargetUser__c,
                                                         OriginalUser__c,
                                                         LoginStatus__c,
                                                         LoginDateTime__c
                                                         FROM UserSwitcherLog__c
                                                         ORDER BY LoginDateTime__c desc
                                                         LIMIT 1];

        return mostRecentLog;
    }

    /**
     * getCommunityId
     *
     * Returns the user's networkId required to login as community user
     *
     * @return Id
     **/ 
    public static Id getCommunityId(Id userId) {
        User usr = [ SELECT Id, Profile.UserLicense.Name FROM User WHERE Id =: userId ];

        if (!usr.Profile.UserLicense.Name.containsIgnoreCase('community')) {
            return null;

        } else {
            List<NetworkMember> commIds = [SELECT memberId, 
                                                  networkId
                                                  FROM NetworkMember 
                                                  WHERE memberID =:userId
                                                  AND Network.Status = 'Live'];

            if (!commIds.isEmpty()) {
                return commIds[0].networkId;
            } else {
                return null;
            }
        }
    }
}
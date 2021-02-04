global with sharing class csaClaimSystemUtilityController {

    global static Object getName(String recordId) {
        String objectAPIName = csaClaimSystemConstants.BLANK;
        String keyPrefix = recordId.substring(0, 3);
        for(Schema.SObjectType obj : Schema.getGlobalDescribe().Values()){
            String prefix = obj.getDescribe().getKeyPrefix();
            if(prefix == keyPrefix){
                objectAPIName = obj.getDescribe().getName();
                break;
            }
        }

        String objectQuery = 'SELECT Name FROM ' + objectAPIName + ' WHERE Id = :recordId LIMIT 1';
        sObject results = Database.query(objectQuery);
        return results.get(NAMEAPIFIELD);
    }

    global static Map<Id, String> getUsers() {
        Map<Id, String> options = new Map<Id, String>();
        List<User> users = [SELECT Id, Name FROM User WHERE isActive = true];

        for(User u: users) {
            options.put(u.Id, u.Name);
        }

        return options;
    }

    global static Map<Id, String> getRoles() {
        Map<Id, String> options = new Map<Id, String>();
        List<LLC_BI__Role__c> roles = [SELECT Id, Name FROM LLC_BI__Role__c];

        for(LLC_BI__Role__c r: roles) {
            options.put(r.Id, r.Name);
        }

        return options;
    }

    global static String getFieldSetName(String category, String key) {
        return nFORCE.SystemProperties.getInstance().getProperty(category, key);
    }

    global static List<String> updateString(String ids) {
        String toReturn = ids.replace(BRACKETLEFT, csaClaimSystemConstants.BLANK);
        toReturn = toReturn.replace(BRACKETRIGHT, csaClaimSystemConstants.BLANK);
        return toReturn.split(csaClaimSystemConstants.COMMA_SPACE);
    }

    private static final String
            BRACKETLEFT = '[',
            BRACKETRIGHT = ']',
            NAMEAPIFIELD = 'Name';
}
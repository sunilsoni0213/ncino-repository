@isTest
public class TestUtility {

    /**
     * Setup Standard User with Profile
     *
     * @param email
     * @param doInsert
     *
     * @return u
     **/
    public static User setupStandardUserWithProfile(String email, Boolean doInsert) {
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id;
		if(email == null) {
			email = 'unit.test.user@' + UserInfo.getOrganizationId() + '.apexanalyticstest.com';
		}

		User u = new User();
        u.FirstName           = 'Test';
        u.LastName            = 'User ';
        u.Email               = email;
        u.Username            = email;
        u.Alias               = 'tuser' + String.valueOf(Integer.valueOf((Math.random() * 999)));
        u.Phone               = '503-555-1212';
        u.ProfileId           = profileId;
        u.TimeZoneSidKey      = 'America/Los_Angeles';
        u.LocaleSidKey        = 'en_US';
        u.EmailEncodingKey    = 'ISO-8859-1';
        u.LanguageLocaleKey   = 'en_US';
		
		if(Userinfo.isMultiCurrencyOrganization()) {
			((SObject)u).put('CurrencyIsoCode','USD');
		}
        if(doInsert){
            insert u;
        }
		return u;
	}

    /**
     * Setup System Admin User with Profile
     *
     * @param email
     * @param doInsert
     *
     * @return u
     **/
    public static User setupSystemAdminUserWithProfile(String email, Boolean doInsert) {
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
		if(email == null) {
			email = 'unit.test.user@' + UserInfo.getOrganizationId() + '.apexanalyticstest.com';
		}

		User u = new User();
        u.FirstName           = 'Test';
        u.LastName            = 'User ';
        u.Email               = email;
        u.Username            = email;
        u.Alias               = 'tuser' + String.valueOf(Integer.valueOf((Math.random() * 999)));
        u.Phone               = '503-555-1212';
        u.ProfileId           = profileId;
        u.TimeZoneSidKey      = 'America/Los_Angeles';
        u.LocaleSidKey        = 'en_US';
        u.EmailEncodingKey    = 'ISO-8859-1';
        u.LanguageLocaleKey   = 'en_US';
		
		if(Userinfo.isMultiCurrencyOrganization()) {
			((SObject)u).put('CurrencyIsoCode','USD');
		}
        if(doInsert){
            insert u;
        }
		return u;
	}

    /**
     * Setup Demo Setup Status record
     *
     * @param stepNumber
     * @param doInsert
     *
     * @return dss
     **/
     public static DemoSetupStatus__c setupDemoSetupStatus(Decimal stepNumber, Boolean doInsert){

        DemoSetupStatus__c dss = new DemoSetupStatus__c();
        dss.StepNumber__c = stepNumber;

        if(doInsert){
            insert dss;
        }

        return dss;
    }


}
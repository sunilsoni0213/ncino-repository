/****************************************************************************************
Name            : DemoStepUtility
Revision Log    : 2020-03-19 John Kuhl - CodeScience
                :
                :
Use             : Utility Class for Demo Step IConfigStep classes
****************************************************************************************/
public class DemoStepUtility {
    /**
     * setupConnectedApp
     *
     * This method creates and populates an instance of a Connected App
     **/
    public static CSMetadataService.ConnectedApp setupConnectedApp(String fullName, String label){
        CSMetadataService.ConnectedApp cApp = new CSMetadataService.ConnectedApp();
        cApp.contactEmail = 'test@test.com';
        cApp.description = 'Portal OAuth';
        cApp.fullName = fullName;
        cApp.label = label;

        return cApp;
    }

    /**
     * setupOAuthConfig
     *
     * This method creates and populates an instance of a Connected App OAuthConfig
     **/
    public static CSMetadataService.ConnectedAppOauthConfig setupOAuthConfig(){
        CSMetadataService.ConnectedAppOauthConfig oaConfig = new CSMetadataService.ConnectedAppOauthConfig();
        oaConfig.callbackUrl = DemoSetupConstants.BASEURL + DemoSetupConstants.CALLBACK_URL;
        oaConfig.consumerSecret = DemoSetupConstants.SECRET_GUID;
        oaConfig.scopes = new String[]{ 'Full','RefreshToken' };
        return oaConfig;
    }

    /**
     * updateSetupStatusToComplete
     *
     * This finds the DemoSetupStatus__c record for the Running Step and updates it to Complete
     **/
    public static void updateSetupStatusToComplete(String className, String errorMessage){
        //Query for DemoSetupStep__mdt record for this class
        DemoSetupStep__mdt dssMdt = DemoSetupStepSelector.getActiveAutomationDemoSetupStep(className);
        //Query for DemoSetupStatus__c record for this step
        DemoSetupStatus__c demoSetupStatus = DemoSetupStepSelector.getDemoSetupStatus(dssMdt.StepNumber__c);

        //Set status to Complete
        demoSetupStatus.ErrorMessage__c = errorMessage;
        demoSetupStatus.StepStatus__c = 'Complete';
        update demoSetupStatus;

        //Create platform event
        DemoStepStatus__e dsse = new DemoStepStatus__e(StepNumber__c = dssMdt.StepNumber__c);
        //Publish update event
        Database.SaveResult results = Eventbus.publish(dsse);
    }

    /**
     * updateStepWithError
     *
     * Updates DemoSetupStep__c with error message
     **/
    public static void updateStepWithError(String className, String errorMessage){
        //Query for DemoSetupStep__mdt record for this class
        DemoSetupStep__mdt dssMdt = DemoSetupStepSelector.getActiveAutomationDemoSetupStep(className);
        //Query for DemoSetupStatus__c record for this step
        DemoSetupStatus__c demoSetupStatus = DemoSetupStepSelector.getDemoSetupStatus(dssMdt.StepNumber__c);
        demoSetupStatus.StepStatus__c = 'Not Started';
        demoSetupStatus.ErrorMessage__c = errorMessage;
        update demoSetupStatus;

        //Create platform event
        DemoStepStatus__e dsse = new DemoStepStatus__e(StepNumber__c = dssMdt.StepNumber__c);
        //Publish update event
        Database.SaveResult results = Eventbus.publish(dsse);
    }

    public static void setSystemProperties(List<nFORCE__System_Properties__c> propertiesUpsert, Set<String> keys, String category) {
        
        String query = 'SELECT Id, '
                        +'Name, '
                        +'nFORCE__Category_Name__c, '
                        +'nFORCE__Key__c, '
                        +'nFORCE__Value__c, '
                        +'nFORCE__Is_Active__c '
                        +'FROM nFORCE__System_Properties__c '
                        +'WHERE nFORCE__Key__c IN :keys ';
        
        if(category != null){
            query += 'AND nFORCE__Category_Name__c =: category';
        }
        
        List<nFORCE__System_Properties__c> existingProperties = Database.query(query);
        
        for(nFORCE__System_Properties__c sp : propertiesUpsert){
            for(nFORCE__System_Properties__c ep : existingProperties){
                if(sp.nFORCE__Key__c == ep.nFORCE__Key__c){
                    sp.Id = ep.Id;
                }
            }
        }

        upsert propertiesUpsert;

        nFORCE.SystemProperties.getInstance().clearCache();
       
    }

    public static nFORCE__System_Properties__c setSystemProperty(String category, String key, String value, Boolean active) {
        nFORCE__System_Properties__c property = new nFORCE__System_Properties__c();
        property.Name = new nFORCE.LifeCycleDataProvider().generateLookupKey();

        property.nFORCE__Category_Name__c = category;
        property.nFORCE__Key__c = key;
        property.nFORCE__Value__c = value;
        property.nFORCE__Is_Active__c = active;

        System.debug(property);

        return property;
    }
}
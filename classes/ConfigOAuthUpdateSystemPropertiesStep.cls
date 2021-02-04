/****************************************************************************************
Name            : ConfigOAuthUpdateSystemPropertiesStep
Revision Log    : 2020-03-17 John Kuhl - CodeScience
                :
                :
Use             : IConfigStep class for upserting System_Properties__c records
****************************************************************************************/
public class ConfigOAuthUpdateSystemPropertiesStep implements IConfigStep{
    
    public static void execute(){
        //Run asynchronus process
        updateSystemProperties();
    }

    /**
     * updateSystemProperties
     *
     * This method asychronously executes the the creation of retrieval of the Customer Key and upsert of System_Propery__c records
     **/
    @future(callout=true)
    private static void updateSystemProperties(){
        //Instantiate a MetadataPort instance from CSMetadataService
        CSMetadataService.MetadataPort service = new CSMetadataService.MetadataPort();
        //Instantiate a SessionHeader_element
        service.SessionHeader = new CSMetadataService.SessionHeader_element();
        //Set the sessionId to that of the running user
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        Boolean success;

        if(!Test.isRunningTest()){
            try{
                //User the CSMetadataService to retrieve the Connect App information
                CSMetadataService.ConnectedApp connectedApp = (CSMetadataService.ConnectedApp)service.readMetadata('ConnectedApp', new String[] { DemoSetupConstants.OAUTH_APP_NAME }).getRecords()[0];
                //Parse the oAuthConfig out to its own object
                CSMetadataService.ConnectedAppOauthConfig oAuthConfig = connectedApp.oAuthConfig;
                System.debug(oAuthConfig.consumerKey);
                
                //Establish collection of nFORCE__System_Properties__c records for upsert
                List<nFORCE__System_Properties__c> systemProperties = new List<nFORCE__System_Properties__c>();
                systemProperties.add(DemoStepUtility.setSystemProperty(DemoSetupConstants.RULES_ENGINE_CATEGORY,'OAUTH2_AUTH_CODE', '', true));
                systemProperties.add(DemoStepUtility.setSystemProperty(DemoSetupConstants.RULES_ENGINE_CATEGORY,'OAUTH2_REFRESH_CODE', '', true));
                systemProperties.add(DemoStepUtility.setSystemProperty(DemoSetupConstants.RULES_ENGINE_CATEGORY,'OAUTH2_AUTH_URL', DemoSetupConstants.BASEURL + '/services/oauth2/authorize', true));
                systemProperties.add(DemoStepUtility.setSystemProperty(DemoSetupConstants.RULES_ENGINE_CATEGORY,'OAUTH2_TOKEN_URL', DemoSetupConstants.BASEURL + '/services/oauth2/token', true));
                systemProperties.add(DemoStepUtility.setSystemProperty(DemoSetupConstants.RULES_ENGINE_CATEGORY,'OAUTH2_REDIRECT_URL', DemoSetupConstants.BASEURL + DemoSetupConstants.CALLBACK_URL, true));
                systemProperties.add(DemoStepUtility.setSystemProperty(DemoSetupConstants.RULES_ENGINE_CATEGORY, 'OAUTH2_CONSUMER_KEY', oAuthConfig.consumerKey, true));
                DemoStepUtility.setSystemProperties(systemProperties, new Set<String>{'OAUTH2_AUTH_CODE','OAUTH2_REFRESH_CODE','OAUTH2_AUTH_URL','OAUTH2_TOKEN_URL','OAUTH2_REDIRECT_URL','OAUTH2_CONSUMER_KEY'}, DemoSetupConstants.RULES_ENGINE_CATEGORY);
                success = true;
            }catch(Exception e){
                DemoStepUtility.updateStepWithError('ConfigOAuthUpdateSystemPropertiesStep', e.getMessage());
            }
        }

        //Update DemoSetupStep__c to 'Complete'
        DemoStepUtility.updateSetupStatusToComplete('ConfigOAuthUpdateSystemPropertiesStep', null);
    }
}
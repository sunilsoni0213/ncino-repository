/****************************************************************************************
Name            : ConfigOAuthConfigurationStep
Revision Log    : 2020-03-19 John Kuhl - CodeScience
                :
                :
Use             : IConfigStep class for Updating Demo Loans and Relationships
****************************************************************************************/
public class ConfigOAuthConfigurationStep implements IConfigStep{

    public static void execute(){
        //Run asynchronus process
        saveApp();
    }

    /**
     * saveApp
     *
     * This method asychronously executes the the creation of the Named Credential and Connected App
     **/
    @future(callout=true)
    private static void saveApp(){
        //Instantiate a MetadataPort instance from CSMetadataService
        CSMetadataService.MetadataPort service = new CSMetadataService.MetadataPort();
        //Instantiate a SessionHeader_element
        service.SessionHeader = new CSMetadataService.SessionHeader_element();
        //Set the sessionId to that of the running user
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        //Setup the Connected App
        CSMetadataService.ConnectedApp oaApp = DemoStepUtility.setupConnectedApp(DemoSetupConstants.OAUTH_APP_NAME, DemoSetupConstants.OAUTH_APP_NAME);
        //Set the OAuthConfig for the app
        oaApp.oauthConfig = DemoStepUtility.setupOAuthConfig();
        oaApp.oauthConfig.callbackUrl = DemoSetupConstants.BASEURL + '/apex/LLC_BI__Admin?app=admin.ruleengineoauth2';

        //Use the CSMetadataService to create the Named Credential and Connected App
        List<CSMetadataService.SaveResult> appResults =
            service.createMetadata(
                new CSMetadataService.Metadata[] { oaApp }
            );
        if(!Test.isRunningTest()){

            handleSaveResults(appResults[0]);
        
            //If the save is successful
            if(appResults[0].success){
                DemoStepUtility.updateSetupStatusToComplete('ConfigOAuthConfigurationStep', null);
            }else{
                DemoStepUtility.updateStepWithError('ConfigOAuthConfigurationStep', appResults[0].errors[0].message);
            }
        }

        //Update consumer secret in Custom Setting
        nFORCE__System_Properties__c sp = DemoStepUtility.setSystemProperty(DemoSetupConstants.RULES_ENGINE_CATEGORY,'OAUTH2_CONSUMER_SECRET', oaApp.oauthConfig.consumerSecret, true);
        DemoStepUtility.setSystemProperties(new List<nFORCE__System_Properties__c>{sp}, new Set<String>{'OAUTH2_CONSUMER_SECRET'}, DemoSetupConstants.RULES_ENGINE_CATEGORY);

    }
    
    public static void handleSaveResults(CSMetadataService.SaveResult r) {
        System.debug(r.errors);
        System.debug('success:' + r.success);
    }
}
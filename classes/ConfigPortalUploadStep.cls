/****************************************************************************************
Name            : ConfigPortalUploadStep
Revision Log    : 2020-03-13 John Kuhl - CodeScience
                :
                :
Use             : IConfigStep class for Creating Named Credential and Portal Upload App
****************************************************************************************/
public class ConfigPortalUploadStep implements IConfigStep{

    /**
     * execute
     *
     * This method executes the the configuration step
     **/
    public static void execute(){
        //Run asynchronus process
        saveAppAndNamedCredential();
    }

    /**
     * saveAppAndNamedCredential
     *
     * This method asychronously executes the the creation of the Connected App
     **/
    @future(callout=true)
    private static void saveAppAndNamedCredential(){
        //Instantiate a MetadataPort instance from CSMetadataService
        CSMetadataService.MetadataPort service = new CSMetadataService.MetadataPort();
        //Instantiate a SessionHeader_element
        service.SessionHeader = new CSMetadataService.SessionHeader_element();
        //Set the sessionId to that of the running user
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        //Setup the Connected App
        CSMetadataService.ConnectedApp cApp = DemoStepUtility.setupConnectedApp(DemoSetupConstants.PORTAL_UPLOAD_APP_NAME, DemoSetupConstants.PORTAL_UPLOAD_APP_NAME);
        //Set the OAuthConfig for the app
        cApp.oauthConfig = DemoStepUtility.setupOAuthConfig();

        String secret = cApp.oauthConfig.consumerSecret;
        
        //Use the CSMetadataService to create the Connected App
        List<CSMetadataService.SaveResult> appResults =
            service.createMetadata(
                new CSMetadataService.Metadata[] { cApp }
            );
        if(!Test.isRunningTest()){

            handleSaveResults(appResults[0]);
        
            //If the save is successful
            if(appResults[0].success){
                //Update the DemoSetupStep__c record for this class to 'Complete'
                DemoStepUtility.updateSetupStatusToComplete('ConfigPortalUploadStep', null);
            }else{
                DemoStepUtility.updateStepWithError('ConfigPortalUploadStep', appResults[0].errors[0].message);
            }
        }

        //Update consumer secret in Custom Setting
        nFORCE__System_Properties__c sp = DemoStepUtility.setSystemProperty(DemoSetupConstants.CUSTOMER_PORTAL_CATEGORY,'Document_Upload_Consumer_Secret', secret, true);
        DemoStepUtility.setSystemProperties(new List<nFORCE__System_Properties__c>{sp}, new Set<String>{'Document_Upload_Consumer_Secret'}, DemoSetupConstants.CUSTOMER_PORTAL_CATEGORY);
    }

    /**
     * handleSaveResults
     *
     * This debugs out any errors during the save process
     **/
    public static void handleSaveResults(CSMetadataService.SaveResult r) {
        System.debug(r.errors);
        System.debug('success:' + r.success);
        System.debug(r.fullName);
    }

}
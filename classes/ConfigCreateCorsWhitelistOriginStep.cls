/****************************************************************************************
Name            : ConfigCreateCorsWhitelistOriginStep
Revision Log    : 2020-03-17 John Kuhl - CodeScience
                :
                :
Use             : IConfigStep class for Creating CORS Whitelist Origin
****************************************************************************************/
public class ConfigCreateCorsWhitelistOriginStep implements IConfigStep{

    public static void execute() {
        //Run asynchronus process
        createCWO();
    }

    /**
     * createCWO
     *
     * This method asychronously executes the the creation of a CORS Whitelist Origin record
     **/
    @future(callout=true)
    private static void createCWO(){

        //Instantiate a MetadataPort instance from CSMetadataService
        CSMetadataService.MetadataPort service = new CSMetadataService.MetadataPort();
        //Instantiate a SessionHeader_element
        service.SessionHeader = new CSMetadataService.SessionHeader_element();
        //Set the sessionId to that of the running user
        service.SessionHeader.sessionId = UserInfo.getSessionId();

        //Setup a CorsWhitelisOrigin record
        CSMetadataService.CorsWhitelistOrigin cwo = setupCorsWhitelistOrigin(service);

        //Use the CSMetadataService to create the CorsWhitelisOrigin
        List<CSMetadataService.SaveResult> cwoResults =
            service.createMetadata(
                new CSMetadataService.Metadata[] { cwo }
            );

        if(!Test.isRunningTest()){

        
            handleSaveResults(cwoResults[0]);

            //If the save is successful
            if(cwoResults[0].success){
                //Update the DemoSetupStep__c record for this class to 'Complete'
                DemoStepUtility.updateSetupStatusToComplete('ConfigCreateCorsWhitelistOriginStep', null);
            }else{
                DemoStepUtility.updateStepWithError('ConfigCreateCorsWhitelistOriginStep', cwoResults[0].errors[0].message);
            }
        }
    }

    /**
     * setupCorsWhitelistOrigin
     *
     * This method creates and populates an instance of a CORS Whitelist Origin record
     **/
    private static CSMetadataService.CorsWhitelistOrigin setupCorsWhitelistOrigin(CSMetadataService.MetadataPort service){
        CSMetadataService.CorsWhitelistOrigin cwo = new CSMetadataService.CorsWhitelistOrigin();
        cwo.fullName = DemoSetupConstants.PORTAL_UPLOAD_APP_NAME;
        cwo.urlPattern = PortalUploadController.getCommunityUrl();

        return cwo;
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
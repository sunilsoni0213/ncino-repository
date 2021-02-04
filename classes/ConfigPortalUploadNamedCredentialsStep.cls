/****************************************************************************************
Name            : ConfigPortalUploadNamedCredentialsStep
Revision Log    : 2020-03-30 John Kuhl - CodeScience
                :
                :
Use             : IConfigStep class for creating a Named Credential for the Portal Upload
****************************************************************************************/
public class ConfigPortalUploadNamedCredentialsStep implements IConfigStep{

    public static void execute(){
        //Run asynchronus process
        saveNamedCredential();
    }

    /**
     * saveAppAndNamedCredential
     *
     * This method asychronously executes the the creation of the Named Credential and Connected App
     **/
    @future(callout=true)
    private static void saveNamedCredential(){
        //Instantiate a MetadataPort instance from CSMetadataService
        CSMetadataService.MetadataPort service = new CSMetadataService.MetadataPort();
        //Instantiate a SessionHeader_element
        service.SessionHeader = new CSMetadataService.SessionHeader_element();
        //Set the sessionId to that of the running user
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        //Setup a Named Credential for the App
        CSMetadataService.NamedCredential nc = setupNamedCredential();
        
        //Use the CSMetadataService to create the Named Credential and Connected App
        List<CSMetadataService.SaveResult> ncResults =
            service.createMetadata(
                new CSMetadataService.Metadata[] { nc }
            );
        if(!Test.isRunningTest()){

            handleSaveResults(ncResults[0]);
        
            //If the save is successful
            if(ncResults[0].success){
                //Update the DemoSetupStep__c record for this class to 'Complete'
                DemoStepUtility.updateSetupStatusToComplete('ConfigPortalUploadNamedCredentialsStep', null);
            }else{
                DemoStepUtility.updateStepWithError('ConfigPortalUploadNamedCredentialsStep', ncResults[0].errors[0].message);
            }
        }
    }

    /**
     * setupNamedCredential
     *
     * This method creates and populates an instance of a Named Credential
     **/
    private static CSMetadataService.NamedCredential setupNamedCredential(){

        CSMetadataService.NamedCredential nc = new CSMetadataService.NamedCredential();
        nc.endpoint = 'https://login.salesforce.com/services/oauth2/token';
        nc.fullName = DemoSetupConstants.PORTAL_CREDENTIAL_NAME;
        nc.label = DemoSetupConstants.PORTAL_CREDENTIAL_NAME;
        nc.principalType = 'NamedUser';
        nc.protocol = 'Password';
        nc.username = PortalUploadController.getUserName();
        nc.password = 'nCino123';
        nc.allowMergeFieldsInBody = true;
        nc.allowMergeFieldsInHeader = true;
        nc.generateAuthorizationHeader = false;
        
        return nc;
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
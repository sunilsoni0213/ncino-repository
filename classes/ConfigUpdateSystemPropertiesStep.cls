/****************************************************************************************
Name            : ConfigUpdateSystemPropertiesStep
Revision Log    : 2020-03-17 John Kuhl - CodeScience
                :
                :
Use             : IConfigStep class for upserting System_Properties__c records
****************************************************************************************/
public class ConfigUpdateSystemPropertiesStep implements IConfigStep{
    
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
        Boolean success = false;

        if(!Test.isRunningTest()){
            try{
                //User the CSMetadataService to retrieve the Connect App information        
                CSMetadataService.ConnectedApp connectedApp = (CSMetadataService.ConnectedApp)service.readMetadata('ConnectedApp', new String[] { DemoSetupConstants.PORTAL_UPLOAD_APP_NAME }).getRecords()[0];
                //Parse the oAuthConfig out to its own object
                CSMetadataService.ConnectedAppOauthConfig oAuthConfig = connectedApp.oAuthConfig;
                
                //Establish collection of nFORCE__System_Properties__c records for upsert
                List<nFORCE__System_Properties__c> systemProperties = new List<nFORCE__System_Properties__c>();
                
                //Establish set of keys for query to find Ids
                Set<String> keys = new Set<String>{'Document_Upload_User_Name', 'Document_Upload_Consumer_Key', 'Document_Upload_Name_Credential_Name'};

                //Setup nFORCE__System_Properties__c records and add to collection                
                systemProperties.add(DemoStepUtility.setSystemProperty(DemoSetupConstants.CUSTOMER_PORTAL_CATEGORY,'Document_Upload_User_Name', PortalUploadController.getUserName(), true));
                systemProperties.add(DemoStepUtility.setSystemProperty(DemoSetupConstants.CUSTOMER_PORTAL_CATEGORY,'Document_Upload_Consumer_Key', oAuthConfig.consumerKey, true));
                systemProperties.add(DemoStepUtility.setSystemProperty(DemoSetupConstants.CUSTOMER_PORTAL_CATEGORY,'Document_Upload_Name_Credential_Name', DemoSetupConstants.PORTAL_CREDENTIAL_NAME, true));

                //Upsert the nFORCE__System_Properties__c records using the utility method
                DemoStepUtility.setSystemProperties(systemProperties, keys, DemoSetupConstants.CUSTOMER_PORTAL_CATEGORY);
                success = true;
            }catch(Exception e){
                DemoStepUtility.updateStepWithError('ConfigUpdateSystemPropertiesStep', e.getMessage());
            }
        }else{
            success = true;
        }
        if(success){
            DemoStepUtility.updateSetupStatusToComplete('ConfigUpdateSystemPropertiesStep', null);
        }
    }
}
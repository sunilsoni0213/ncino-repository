/**
 * Utility class to "reset" the DemoTool to step 1
 */
public class ToolReset {
   
    /**
     * throws DML exception - steps can't run in the same transaction
     */
    public void reset() {
        this.part1();
        this.part2();
    }
    
    public void part1() {
        //Pt.1 
        System.debug('start 1');
        CSMetadataService.MetadataPort service = new CSMetadataService.MetadataPort();
        service.SessionHeader = new CSMetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        
        CSMetadataService.DeleteResult[] dr = service.deleteMetadata('ConnectedApp', new List<String>{'Portal_OAuth66', 'CustomerPortalFileUploadApp'});
        CSMetadataService.DeleteResult[] drNc = service.deleteMetadata('NamedCredential', new List<String>{'CustomerPortalFileUploadApp'});
        CSMetadataService.DeleteResult[] drCwl = service.deleteMetadata('CorsWhitelistOrigin', new List<String>{'CustomerPortalFileUploadApp'});
        CSMetadataService.DeleteResult[] drRss = service.deleteMetadata('RemoteSiteSetting', new List<String>{'Current_Community_Instance','Current_Salesforce_Instance','Current_Salesforce_Instance_Visualforce','nforce_SalesForce_Instance_VisualForce','Retail_Salesforce_Instance_Visualforce','Mortgage_Salesforce_Instance_Visualforce'});
        
        
        List<DemoSetupStatus__c> dsss = [SELECT Id FROM DemoSetupStatus__c];
        
        for(DemoSetupStatus__c dss : dsss){
            dss.StepStatus__c = 'Not Started';
            dss.ErrorMessage__c = null;
        }
        update dsss;
        System.debug('end 1');
    }
    
    public void part2() {
        // Pt.2 **Un-comment and execute after Pt. 1 is completed
        System.debug('start 2');
        User u = new User(Id = UserInfo.getUserId(), AutoRemoveManagedLicense__c = true);
        update u;
        
        PackageLicense packageLicense = [SELECT Id FROM PackageLicense WHERE NamespacePrefix = 'LLC_BI'];
        
        UserPackageLicense upl = new UserPackageLicense();
        upl.UserId = u.Id;
        upl.PackageLicenseId = packageLicense.Id;
        insert upl;
        System.debug('end 2');
    } 
}
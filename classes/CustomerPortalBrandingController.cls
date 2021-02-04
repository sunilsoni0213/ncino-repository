Global with sharing class CustomerPortalBrandingController {
    public List<nFORCE__System_Properties__c> customSetting {get; set;}
    public List<Document> documents {get; set;}
    public String documentId {get; set;}
    public String documentIdFinal {get; set;}
    public List<Customer_Portal_Branding__c> bgd {get; set;}
    public List<Document> background1 {get; set;}
    public List<Document> apphero {get; set;}
    public String backgroundId {get; set;}
    public String backgroundIdFinal {get; set;}
    public String appheroId {get; set;}
    public String appheroIdFinal {get; set;}
    public String Opp {get; set;}
    public Customer_Portal_Branding__c CPBObject;

    ApexPages.StandardController sController;
    
    public CustomerPortalBrandingController(ApexPages.StandardController controller) {
        sController = controller;
        this.CPBObject = (Customer_Portal_Branding__c)controller.getRecord();
        //Appended to url in CustomerPortalBrandingTemplate
        Opp = '&oid';
    }
    

    public Document document {
        get {
            if (document == null)
                document = new Document();
                    return document;
        }
        set;
    }
    public Document document1 {
        get {
            if (document1 == null)
                document1 = new Document();
                    return document1;
        }
        set;
    }
    public Document document2 {
        get {
            if (document2 == null)
                document2 = new Document();
                    return document2;
        }
        set;
    }

    public PageReference getUpload() {
        PageReference pr = sController.save();
       
        document.AuthorId = UserInfo.getUserId();
        document.FolderId = UserInfo.getUserId(); // put it in running user's folder
        document1.AuthorId = UserInfo.getUserId();
        document1.FolderId = UserInfo.getUserId(); // put it in running user's folder
        document2.AuthorId = UserInfo.getUserId();
        document2.FolderId = UserInfo.getUserId(); // put it in running user's folder
        document.name = 'PortalLogo';
        document1.name = 'PortalHero';
        document2.name = 'ApplicationHero';

    if (document.body != null) {
        try {
            insert document;
        } 
        catch (DMLException e) { 
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
                return null;
        }
        finally {
                document.body = null;
                document = new Document();
                
                //gets base URL
                string s = System.URL.getSalesforceBaseUrl().getHost();

                //gets uploaded documents ID
                documents = [SELECT ID FROM Document WHERE name = 'PortalLogo'];
                documentId = String.valueOf(documents);
                documentIdFinal = documentId.substring(14,32);
            
            
                //String to compile URL for custom setting
                string f = 'https://'+s + '/servlet/servlet.FileDownload?file=' + documentIdFinal;

                //inserts URL string into custom setting
                customSetting = [SELECT nFORCE__Value__c FROM nFORCE__System_Properties__c WHERE nFORCE__Key__c = 'Custom_Logo' LIMIT 1];
                customSetting[0].nFORCE__Value__c = f;
                update customSetting[0];
            

        }
    }
    if (document1.body != null) {
        try {
            insert document1;
        }
        catch (DMLException e) { 
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
                return null;
        }
        finally {
                document1.body = null;
                document1 = new Document();

                //gets background image ID and sets Image as Externally Available
                background1 = [SELECT ID, IsPublic FROM Document WHERE name = 'PortalHero'];
                background1[0].IsPublic = True;
                update background1;
                backgroundId = String.valueOf(background1[0]);
                backgroundIdFinal = backgroundId.substring(13,31);

                //Pass background image id to CustomerPortalBrandingTemplate
                bgd = [SELECT BackgroundId__c FROM Customer_Portal_Branding__c order by createdDate DESC limit 1];
                bgd[0].BackgroundId__c = backgroundIdFinal;
                update bgd[0];
        }   
    }
    if (document2.body != null) {
        try {
            insert document2;
        }
        catch (DMLException e) { 
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
                return null;
        }
        finally {
                document2.body = null;
                document2 = new Document();

                //gets background image ID and sets Image as Externally Available
                apphero = [SELECT ID, IsPublic FROM Document WHERE name = 'ApplicationHero'];
                apphero[0].IsPublic = True;
                update apphero;
                appheroId = String.valueOf(apphero[0]);
                appheroIdFinal = appheroId.substring(13,31);

                //Pass background image id to CustomerPortalBrandingTemplate
                bgd = [SELECT Online_Application_Hero_Image__c FROM Customer_Portal_Branding__c order by createdDate DESC limit 1];
                bgd[0].Online_Application_Hero_Image__c = appheroIdFinal;
                update bgd[0];
        }   
    }
                return pr;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
                return null;
                
    }
            webService static blob UpdateSR (String CpBrandingId) {
            PageReference text = Page.CustomerPortalBrandingTemplate;
            text.getParameters().put('id',(String)CpBrandingId);
            Blob branding;
            try{
                branding = text.getContent();
            } catch (VisualforceException e){
                branding = Blob.valueOf('Error:' + e);
            }
            System.debug('******' + branding);
            return branding;
        }
    

    
}
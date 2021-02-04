public with sharing class DocumentPreparationController {

    public DocumentPreparationController() {
    }

    
    public String Page {get; set;}
    public String OpenPageURL {get; set;}
    public DocumentPreparationController(ApexPages.StandardController controller) {
    }

    public void DocumentPreparationController () {
        Page = '' ;
        OpenPageURL = '' ;
    }
    
    public PageReference redirect() {
        if(Page == 'google') {
            OpenPageURL = 'https://c.na14.content.force.com/servlet/servlet.FileDownload?file=015d000000407jK';
        }
        
        return null;
    }
}
public class Web2LeadController {

   private final Lead weblead;
   private Attachment myDocument;
   public Attachment myDoc
      {
        get
        {
            if(myDocument==null)
            {
                myDocument = new Attachment();
            }
            return myDocument;
        }
        set;
      }

   public Web2LeadController(ApexPages.StandardController stdController) {
        weblead = (Lead)stdController.getRecord();
   }
    
   public PageReference saveLead() {
        try {
            weblead.Web_Lead__c = true;
            insert(weblead);
        } catch (System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
        
        if (myDoc.Name != null) {
            myDoc.parentId = weblead.Id;
            insert myDoc;
        }
        
        PageReference p = Page.Web2LeadPage;
        p.setRedirect(true);   
        return p;
   }
}
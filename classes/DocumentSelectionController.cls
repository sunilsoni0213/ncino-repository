public class DocumentSelectionController {

    public String loanId         { get; set; }
    public String attachmentId   { get; set; }
    public String docTabId       { get; set; }
    public String docTypeId      { get; set; }
    public Id docManId           { get; set; }
    public Id entityId           { get; set; }
    public String ACCOUNT_DOC_MANAGER_NAME = 'Account';
    public Id objId = Apexpages.currentPage().getParameters().get('lid');

    public String getProfileName() {
        User user = [SELECT Id, Name FROM User WHERE Id =: userInfo.getUserId()];
        String userName = user.Name;
        return userName;
    }

    public List<SelectOption> getLoans() {
        List<LLC_BI__Loan__c> loans = [SELECT Id, Name FROM LLC_BI__Loan__c WHERE LLC_BI__Account__c =: objId];
        List<SelectOption> options = new List<SelectOption>();
        for (LLC_BI__Loan__c loan : loans) {
            options.add(new SelectOption(loan.Id, loan.Name));
        }
        return options;
    }
/*
    public List<SelectOption> getEntities() {
        system.debug('*** EnttiyId: ' + entityId);
        List<LLC_BI__Loan__c> loans = [SELECT Id, Name FROM LLC_BI__Loan__c WHERE LLC_BI__Account__c =: objId];
        List<LLC_BI__Legal_Entities__c> entities = [SELECT Id, Name, LLC_BI__Account__c, LLC_BI__Account__r.Name, LLC_BI__Loan__c FROM LLC_BI__Legal_Entities__c WHERE LLC_BI__Loan__c IN : loans];
        List<SelectOption> options = new List<SelectOption>();
        for (LLC_BI__Legal_Entities__c ent : entities) {
            options.add(new SelectOption(ent.LLC_BI__Account__r.Id, ent.LLC_BI__Account__r.Name));
        }
        return options;
    }
*/
    public List<SelectOption> getAttachments() {
        List<Attachment> attachments = [SELECT Id, Name, Body, ParentId FROM Attachment WHERE ParentId =: loanId];
        List<SelectOption> options = new List<SelectOption>();
        for (Attachment att : attachments) {
            options.add(new SelectOption(att.Id, att.Name));
        }
        return options;
    }

    public List<SelectOption> getTabs() {
        Account acc = [SELECT Id, NDOC__Document_Manager_Identifier__c FROM Account WHERE Id =: objId];
        LLC_BI__DocManager__c defaultDocMan = [SELECT Id, Name FROM LLC_BI__DocManager__c WHERE Name =: ACCOUNT_DOC_MANAGER_NAME LIMIT 1];
        List<LLC_BI__DocManager__c> accountDocManager = [SELECT Id, Name FROM LLC_BI__DocManager__c WHERE Name =: acc.NDOC__Document_Manager_Identifier__c];

        if (acc.NDOC__Document_Manager_Identifier__c == null) {
            docManId = defaultDocMan.Id;
        } else {
            docManId = accountDocManager[0].Id;
        }

        List<LLC_BI__DocManager__c> docMan = [SELECT Id, Name FROM LLC_BI__DocManager__c WHERE Id =: docManId LIMIT 1];
        List<LLC_BI__DocTab__c> docTabList = [SELECT Id, Name FROM LLC_BI__DocTab__c WHERE LLC_BI__docManager__c IN : docMan ORDER BY Name ASC];
        List<SelectOption> options = new List<SelectOption>();
        for (LLC_BI__DocTab__c doc : docTabList) {
            options.add(new SelectOption(doc.Id, doc.Name));
        }
        return options;
    }

    public List<SelectOption> getTypes() {
        system.debug('*** DocTabId:' + docTabId);
        List<LLC_BI__DocType__c> docTypeList = [SELECT Id, Name FROM LLC_BI__DocType__c WHERE LLC_BI__docTab__c =: docTabId ORDER BY Name ASC];
        List<SelectOption> options = new List<SelectOption>();
        for (LLC_BI__DocType__c dt : docTypeList) {
            options.add(new SelectOption(dt.Id, dt.Name));
        }
        return options;
    }
   
    public String getCurrentAccountName() {
        //List<Account> account = [SELECT Id, Name FROM Account WHERE Id =: objId LIMIT 1];
        //String myAccountName = account[0].Name;
        Account account = [SELECT Id, Name FROM Account WHERE Id =: objId];
        String accountName = account.Name;
        return accountName;
    }

    public String getCurrentAccountId() {
        return objId;
    }

    public PageReference Create() {  
        system.debug('*** EnttiyId: ' + entityId);      
        //System.debug(LoggingLevel.ERROR, 'attach id: ' + this.attachmentId);
        Account acc = [SELECT Id, NDOC__Document_Manager_Identifier__c FROM Account WHERE Id =: objId];
        LLC_BI__DocManager__c defaultDocMan = [SELECT Id, Name FROM LLC_BI__DocManager__c WHERE Name =: ACCOUNT_DOC_MANAGER_NAME LIMIT 1];
        List<LLC_BI__DocManager__c> accountDocManager = [SELECT Id, Name FROM LLC_BI__DocManager__c WHERE Name =: acc.NDOC__Document_Manager_Identifier__c];

        if (acc.NDOC__Document_Manager_Identifier__c == null) {
            docManId = defaultDocMan.Id;
        } else {
            docManId = accountDocManager[0].Id;
        }

        List<LLC_BI__DocManager__c> docMan = [SELECT Id, Name FROM LLC_BI__DocManager__c WHERE Id =: docManId LIMIT 1];
        List<LLC_BI__DocTab__c> docTab = [SELECT Id, Name FROM LLC_BI__DocTab__c WHERE LLC_BI__docManager__c =: docMan[0].Id LIMIT 1];
        List<LLC_BI__DocType__c> docType = [SELECT Id, Name FROM LLC_BI__DocType__c WHERE LLC_BI__docTab__c =: docTab[0].Id LIMIT 1];

        Attachment a = [SELECT Id, Name, Body, ParentId FROM Attachment WHERE Id =: attachmentId];

        LLC_BI__AccountDocument__c newAccountDocument = new LLC_BI__AccountDocument__c(Name = a.Name, LLC_BI__Account__c = objId, LLC_BI__docManager__c = docMan[0].Id, LLC_BI__docTab__c = docTabId, LLC_BI__docType__c = docTypeId, LLC_BI__reviewStatus__c = 'In-File', LLC_BI__version__c = 1);
        insert newAccountDocument;

        Attachment newAttachment = new Attachment(Name = a.Name, Body = a.Body, ParentId = newAccountDocument.Id);
        insert newAttachment;        

        LLC_BI__AccountDocument__c updateAccDoc = [SELECT Id, LLC_BI__attachmentId__c FROM LLC_BI__AccountDocument__c WHERE Id =: newAccountDocument.Id LIMIT 1];
        updateAccDoc.LLC_BI__attachmentId__c = String.valueOf(newAttachment.Id);
        update updateAccDoc;

        return new PageReference('/' + objId);
    }
    /*
        public String getAccounts() {
            //List<Account> accountList = [SELECT Id, Name FROM Account WHERE Id =: objId LIMIT 1];
            Account account = [SELECT Id, Name FROM Account WHERE Id =: objId];
            String accountName = account.Name;
            return accountName;
        }

        public void setIdFromDropdown() {
            System.debug(LoggingLevel.ERROR, 'attach id: ' + this.attachmentId);
        }
    */
}
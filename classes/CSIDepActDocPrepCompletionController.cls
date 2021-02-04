global with sharing class CSIDepActDocPrepCompletionController extends ACSIDepActDocPrepController {
    public String docprepurl { get; private set; }
    public String transactionExternalId { get; private set; }
    public String transactionLogId { get; private set; }
    public String csiPostEndpoint { get; private set; }
    public Boolean errorsPresent { get; private set; }
    public String csiSessionId { get; private set; }
    public String contextId {get; private set;}
    public String sessionId {get; private set;}
    public String currentApp {get; private set;}
    public String vendorStatus {get; private set;}
    public String anchorText{
        get{
            return new DocPrepSessionController().getAnchorText(GENERATE_DOCUMENTS);
        }
    }

    public CSIDepActDocPrepCompletionController(){
        this.errorsPresent = false;
        this.csiPostEndpoint = CSIDepActDocPrepConstants.MIDDLEWARE_ENDPOINT;
        this.transactionExternalId = ApexPages.currentPage().getParameters().get(CSIDepActDocPrepConstants.PARAM_EXTERNAL_LOG_ID);
        this.contextId = ApexPages.currentPage().getParameters().get(CSIDepActDocPrepConstants.PARAM_ID);
        this.sessionId = ApexPages.currentPage().getParameters().get(CSIDepActDocPrepConstants.PARAM_SID);
        this.currentApp = ApexPages.currentPage().getParameters().get(CSIDepActDocPrepConstants.PARAM_APP);
        if(this.transactionExternalId == null){
            this.errorsPresent = true;
            ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.FATAL, Label.CSI_DepAct_DocPrep_Completion_Log_Id_Missing));
        } else {
            this.getRedirectUrl();
            getVendorStatus();
            ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_PROVIDER_SESSIONID, this.csiSessionId);
        }
    }

    private void getVendorStatus(){
        this.vendorStatus = this.getLoggingService().getTransactionLog(this.transactionLogId).nFUSE__Vendor_Status__c;
        if(this.vendorStatus == completeStatus &&
            this.transactionExternalId != null &&
            ApexPages.getMessages().size() > 0){

            ApexPages.getMessages().clear();
            this.errorsPresent = false;
        }
    }

    private void getRedirectUrl() {
        nFUSE__Transaction_Log__c transLog;
        try{
            transLog = this.getLoggingService().getTransactionLog(transactionExternalId);
        } catch(Exception e){
            throw new XCompletionControllerException(CSIDepActDocPrepConstants.X_NO_TRANSACTION_FOUND);
        }

        this.transactionLogId = transLog.Id;
        Attachment docPrepAttachment = this.getLoggingService().getLogAttachment(
                CSIDepActDocPrepConstants.DOCPREP_ATTACHMENT_FILTER,
                (String)transLog.nFUSE__External_Id__c
        );

        if(docPrepAttachment != null){
            Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(docPrepAttachment.Body.toString());
            if(m.get(CSIDepActDocPrepConstants.PARAM_REDIRECT_URL) != null){
                this.docprepurl = (String)m.get(CSIDepActDocPrepConstants.PARAM_REDIRECT_URL);
            }
            if(m.get(CSIDepActDocPrepConstants.PARAM_PROVIDER_SESSIONID) != null){
                this.csiSessionId = (String)m.get(CSIDepActDocPrepConstants.PARAM_PROVIDER_SESSIONID);
            }
        } else{
            this.errorsPresent = true;
            ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.FATAL, Label.CSI_DepAct_DocPrep_Completion_Log_Id_Missing));
        }

        if(this.docprepurl == null){
            errorsPresent = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
                    Label.nFUSE.DocPrep_Redirect_URL_Missing));
        }
    }

    private static PageReference buildNextPageReference(PageReference nextPage, String nextRouteGroup, String sessionId, String entityId){
        Map<String, String> params = new Map<String, String>();
        params.put(CSIDepActDocPrepConstants.PARAM_APP, nextRouteGroup);
        params.put(CSIDepActDocPrepConstants.PARAM_SID, sessionId);
        params.put(CSIDepActDocPrepConstants.PARAM_ID, entityId);
        params.put(CSIDepActDocPrepConstants.PARAM_SESSION_DML, FALSE_STRING);

        nextPage.getParameters().putAll(params);
        return nextPage;
    }

    @RemoteAction
    global static String retryGenerateDocs(String currentApp, String sessionId, String entityId){
        PageReference nextPage;
        if(currentApp.substringBefore('.') == CSIDepActDocPrepConstants.MAINTENANCE_GROUP){
            nextPage = Page.LLC_BI__Product_Maintenance;
            return buildNextPageReference(
                nextPage,
                CSIDepActDocPrepConstants.MAINTENANCE_REVIEW,
                sessionId,
                entityId
            ).getUrl();
        } else {
            nextPage = Page.LLC_BI__Product_Creation;
            return buildNextPageReference(
                nextPage,
                CSIDepActDocPrepConstants.CREATION_REVIEW,
                sessionId,
                entityId
            ).getUrl();
        }
    }

    @RemoteAction
    global static void reSubmitDocuments(String logExternalId, String contextId, String csiSessionId){
        new CSIDepActDocPrepFilingController().retryFilingDocuments(logExternalId, contextId, csiSessionId);
    }

    @RemoteAction
    global static void updateSession(String contextId, String sessionId, String status){
        Map<String, Object> docStatusData = new Map<String, Object>{
                CSIDepActDocPrepConstants.PARAM_SESSION_STATUS => status
        };

        nFUSE.DepActDocPrepLandingPageController.updateSessionContext(
            contextId,
            sessionId,
            (Object)docStatusData
        );
    }

    private class XCompletionControllerException extends Exception {}

    private static final String GENERATE_DOCUMENTS = Label.nFUSE.Generate_Documents;
    private static final String FALSE_STRING = 'false';
}
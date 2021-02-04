public with sharing class CSIDepActDocPrepFilingController extends ACSIDepActDocPrepController{

    public CSIDepActDocPrepFilingController() {
        super();
    }

    public void retryFilingDocuments(String transactionId, String primaryObjectId, String csiSessionId){
        String requestResult = createSendRequest(transactionId, primaryObjectId, csiSessionId);
    }

    public void startFilingDocuments() {
        String transactionExternalId = ApexPages.currentPage().getParameters().get(CSIDepActDocPrepConstants.PARAM_TRANSACTION_ID);
        nFUSE__Transaction_Log__c log;
        String sessionId = ApexPages.currentPage().getParameters().get(CSIDepActDocPrepConstants.PARAM_SESSION_ID);

        if (sessionId == null) {
            ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.FATAL, Label.CSI_DepAct_DocPrep_Completion_Log_Id_Missing));
        }

        if (transactionExternalId == null) {
            ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.FATAL, Label.CSI_DepAct_DocPrep_Completion_Log_Id_Missing));
        } else {
            log = this.getLoggingService().getTransactionLog(transactionExternalId);
            if (log == null) {
                ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.FATAL, Label.CSI_DepAct_DocPrep_Completion_Log_Id_Missing));
            }
        }
        if(log != null && sessionId != null){
            String requestResult = createSendRequest(transactionExternalId, log.nFUSE__Primary_Object_Id__c, sessionId);
        }
    }

    private String createSendRequest(String transactionExternalId, String primaryObjectId, String sessionId){
        nFUSE.DocPrepRequest request = new nFUSE.DocPrepRequest();
        request.messageHeader.action = CSIDepActDocPrepConstants.ACTION_GENDOCANDSAVE;
        request.properties = new Map<String, Object>{
            CSIDepActDocPrepConstants.PARAM_SESSION_ID => sessionId,
            CSIDepActDocPrepConstants.PARAM_PRIMARY_OBJECT_ID => primaryObjectId
        };
        String resultString = this.getCsiDocPrepAppFacade().sendRequest(
            request,
            CSIDepActDocPrepConstants.PROVIDER_CSI_DEPACT_DOCPREP,
            transactionExternalId,
            CSIDepActDocPrepConstants.MIDDLEWARE_ENDPOINT
        );
        this.getLoggingService().updateVendorStatus(transactionExternalId, CSIDepActDocPrepConstants.VENDOR_STATUS_FILING, CSIDepActDocPrepConstants.TRANSACTION_STATUS_COMPLETE);
        return resultString;
    }
}
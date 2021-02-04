public abstract with sharing class ACSIDepActDocPrepController {

    private CSIDepActTransactionLogService logService;
    private nFUSE.DepActDocPrepAppFacade csiDocPrepAppFacade;
    public PageReference landingHref {get; private set;}
    public String filingStatus {get; private set;}
    public String docViewerStatus {get; private set;}
    public String completeStatus {get; private set;}

    public ACSIDepActDocPrepController() {
        this.landingHref = setlandingHref();
        setVendorStatus();
    }

    private void setVendorStatus() {
        this.filingStatus = CSIDepActDocPrepConstants.VENDOR_STATUS_FILING;
        this.docViewerStatus = CSIDepActDocPrepConstants.VENDOR_STATUS_DOCVIEWER;
        this.completeStatus = CSIDepActDocPrepConstants.VENDOR_STATUS_COMPLETE;
    }

    private PageReference setlandingHref(){
        PageReference currentPage = ApexPages.currentPage();
        PageReference pageRef;
        Map<String,String> params = new Map<String, String>();
        if(currentPage != null){
            String appParam =
                currentPage.getParameters().get(CSIDepActDocPrepConstants.PARAM_APP) != null ?
                currentPage.getParameters().get(CSIDepActDocPrepConstants.PARAM_APP).substringBefore('.') :
                null;
            if(appParam == CSIDepActDocPrepConstants.MAINTENANCE_GROUP){
                pageRef = Page.LLC_BI__Product_Maintenance;
                params.put(CSIDepActDocPrepConstants.PARAM_APP, CSIDepActDocPrepConstants.MAINTENANCE_DOCMAN);
            } else {
                pageRef = Page.LLC_BI__Product_Creation;
                params.put(CSIDepActDocPrepConstants.PARAM_APP, CSIDepActDocPrepConstants.CREATION_LANDING);
            }
            params.put(CSIDepActDocPrepConstants.PARAM_ID, currentPage.getParameters().get(CSIDepActDocPrepConstants.PARAM_ID));
            params.put(CSIDepActDocPrepConstants.PARAM_SID, currentPage.getParameters().get(CSIDepActDocPrepConstants.PARAM_SID));
            pageRef.getParameters().putAll(params);
        }

        return pageRef;
    }

    public CSIDepActTransactionLogService getLoggingService(){
        if(this.logService == null){
            this.logService = new CSIDepActTransactionLogService();
        }
        return this.logService;
    }

    public nFUSE.DepActDocPrepAppFacade getCsiDocPrepAppFacade(){
        if(this.csiDocPrepAppFacade == null){
            this.csiDocPrepAppFacade = new CSIDepActDocPrep.AppFacade();
        }
        return this.csiDocPrepAppFacade;
    }

    protected void setLoggingService(CSIDepActTransactionLogService service){
        this.logService = service;
    }

    @TestVisible
    private void setCsiDocPrepAppFacade(nFUSE.DepActDocPrepAppFacade facade){
        this.csiDocPrepAppFacade = facade;
    }

    public class DocPrepSessionController {

        public Id objectId {get; private set;}

        public DocPrepSessionController(){
            if (ApexPages.currentPage().getParameters().containsKey(CSIDepActDocPrepConstants.PARAM_ID)) {
                this.objectId = ApexPages.currentPage().getParameters().get(CSIDepActDocPrepConstants.PARAM_ID);
            }
        }

        public virtual String getAnchorText(String contextAction) {
            String productName;
            String productActNumber;

            List<LLC_BI__Deposit__c> depositObject = getDepositObject(this.objectId);
            if(depositObject.size() > 0){
                productName = depositObject[0].Name;
                productActNumber = depositObject[0].LLC_BI__Account_Number__c;
            } else {
                productName = DOC_PREP;
            }

            String result = String.format('{0} : {1}', new String[]{contextAction, productName});

            if(productActNumber != null) {
                result = String.format(result + ' ({0})', new String[]{productActNumber});
            }
            return result;
        }

        private List<LLC_BI__Deposit__c> getDepositObject(String objId){
            List<LLC_BI__Deposit__c> depositObj = [
                    SELECT
                            Id,
                            Name,
                            LLC_BI__Account_Number__c
                    FROM
                            LLC_BI__Deposit__c
                    WHERE
                            Id =: objId
                    LIMIT 1];
            return depositObj;
        }

        private final String PRIMARY_RELATIONSHIP_NAME = 'primary-relationship-name';
        private final String DOC_PREP = 'DocPrep';
    }
}
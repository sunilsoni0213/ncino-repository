@isTest
public with sharing class TestCSIDepActDocPrepFilingController {

    @isTest
    private static void ValidTransactionAndSession_VendorStatusUpdated() {
        CSIDepActDocPrepFilingController controller = new CSIDepActDocPrepFilingController();
        controller.setCsiDocPrepAppFacade(new TestableCSIDepActDocPrepAppFacate());

        nFUSE__Transaction_Log__c log = createLog();
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_TRANSACTION_ID, log.Id);
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_SESSION_ID, FAKE_CSI_SESSION);

        controller.startFilingDocuments();

        nFUSE__Transaction_Log__c updatedLog = new CSIDepActTransactionLogService().getTransactionLog(log.Id);
        System.assertEquals(CSIDepActDocPrepConstants.VENDOR_STATUS_FILING, updatedLog.nFUSE__Vendor_Status__c);
    }

    @isTest
    private static void InvalidTransaction_VendorStatusNotUpdated() {
        CSIDepActDocPrepFilingController controller = new CSIDepActDocPrepFilingController();
        controller.setCsiDocPrepAppFacade(new TestableCSIDepActDocPrepAppFacate());

        nFUSE__Transaction_Log__c log = createLog();
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_SESSION_ID, FAKE_CSI_SESSION);

        controller.startFilingDocuments();

        System.assertEquals(1, ApexPages.getMessages().size());
        nFUSE__Transaction_Log__c updatedLog = new CSIDepActTransactionLogService().getTransactionLog(log.Id);
        System.assertEquals(FAKE_VENDOR_STATUS, updatedLog.nFUSE__Vendor_Status__c);

    }

    @isTest
    private static void InvalidTransactionAndSession_VendorStatusNotUpdated() {
        CSIDepActDocPrepFilingController controller = new CSIDepActDocPrepFilingController();
        controller.setCsiDocPrepAppFacade(new TestableCSIDepActDocPrepAppFacate());

        nFUSE__Transaction_Log__c log = createLog();

        controller.startFilingDocuments();

        System.assertEquals(1, ApexPages.getMessages().size()); // all error checks throw the same message, Apex counts the label as unique.
        nFUSE__Transaction_Log__c updatedLog = new CSIDepActTransactionLogService().getTransactionLog(log.Id);
        System.assertEquals(FAKE_VENDOR_STATUS, updatedLog.nFUSE__Vendor_Status__c);
    }

    @isTest
    private static void NoLogFound_VendorStatusNotUpdated() {
        CSIDepActDocPrepFilingController controller = new CSIDepActDocPrepFilingController();
        controller.setCsiDocPrepAppFacade(new TestableCSIDepActDocPrepAppFacate());

        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_TRANSACTION_ID, FAKE_LOG_ID);
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_SESSION_ID, FAKE_CSI_SESSION);

        controller.startFilingDocuments();

        System.assertEquals(1, ApexPages.getMessages().size());
    }

    private static nFUSE__Transaction_Log__c createLog() {
        nFUSE__Transaction_Log__c log = new nFUSE__Transaction_Log__c(
                nFUSE__External_Id__c = FAKE_EXTERNAL_ID,
                nFUSE__API_Version__c = '1.0',
                nFUSE__Action__c = 'DocPrep Request',
                nFUSE__Object_Id__c = 'loanId123',
                nFUSE__Primary_Object_Id__c = 'loanId123',
                nFUSE__App_Plugin__c = CSIDepActDocPrepConstants.PROVIDER_CSI_DEPACT_DOCPREP,
                nFUSE__Requesting_User_Id__c = 'userId123',
                nFUSE__Requested_By_User_Id__c = 'userId123',
                nFUSE__Transaction_Status__c = 'Success',
                nFUSE__Vendor_Status__c = FAKE_VENDOR_STATUS
        );
        insert log;
        return log;
    }

    public virtual class TestableCSIDepActDocPrepAppFacate extends nFUSE.DepActDocPrepAppFacade{
        public TestableCSIDepActDocPrepAppFacate(){
            super();
        }

        public override String sendRequest(nFUSE.DocPrepRequest request, String plugingName, String externalId, String endpointURL){
            return 'Request Sent';
        }
    }

    @TestVisible private static final String
            FAKE_CSI_SESSION = '12345679',
            FAKE_EXTERNAL_ID = 'abc',
            FAKE_VENDOR_STATUS = 'something',
            FAKE_LOG_ID = '80u71353g4';
}
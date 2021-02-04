@isTest
public with sharing class TestCSIDepActTransactionLogService {
    @isTest
    private static void testGetTransactionLog(){
        nFUSE__Transaction_Log__c log = createLog();

        Test.startTest();
        nFUSE__Transaction_Log__c getLog = new CSIDepActTransactionLogService().getTransactionLog(log.nFUSE__External_Id__c);
        Test.stopTest();

        System.assertEquals(log.Id, getLog.Id);
        System.assertEquals(log.nFUSE__External_Id__c, getLog.nFUSE__External_Id__c);
    }

    @isTest
    private static void testGetAttachments(){
        nFUSE__Transaction_Log__c log = createLog();

        Test.startTest();
        Attachment attachment = new CSIDepActTransactionLogService().getLogAttachment(CSIDepActDocPrepConstants.DOCPREP_ATTACHMENT_FILTER + log.Id + '.txt', log.Id);
        Test.stopTest();

        System.assertNotEquals(null, attachment);
    }

    @isTest
    private static void testUpdateVendorStatus(){
        nFUSE__Transaction_Log__c log = createLog();
        System.assertEquals(STATUS_IN_PROGRESS, log.nFUSE__Vendor_Status__c);

        Test.startTest();
        new CSIDepActTransactionLogService().updateVendorStatus(log.nFUSE__External_Id__c, STATUS_FILING);
        Test.stopTest();

        log = new CSIDepActTransactionLogService().getTransactionLog(log.nFUSE__External_Id__c);
        System.assertEquals(STATUS_FILING, log.nFUSE__Vendor_Status__c);
    }

    @isTest
    private static void testAnchorTextAccountNumberExists(){
        LLC_BI__Deposit__c deposit = createDeposit(FAKE_PRODUCT_NAME, FAKE_ACCOUNT_NUMBER);
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_ID, deposit.Id);

        ACSIDepActDocPrepController.DocPrepSessionController something = new ACSIDepActDocPrepController.DocPrepSessionController();
        String anchorText = something.getAnchorText('Generate Documents');

        System.assertEquals(String.format('Generate Documents : {0} ({1})', new List<String>{deposit.Name, deposit.LLC_BI__Account_Number__c}), anchorText);
    }

    @isTest
    private static void testAnchorTextNoAccountNumber(){
        LLC_BI__Deposit__c deposit = createDeposit(FAKE_PRODUCT_NAME, null);
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_ID, deposit.Id);

        ACSIDepActDocPrepController.DocPrepSessionController something = new ACSIDepActDocPrepController.DocPrepSessionController();
        String anchorText = something.getAnchorText('Generate Documents');

        System.assertEquals(String.format('Generate Documents : {0}', new List<String>{deposit.Name}), anchorText);
    }

    private static nFUSE__Transaction_Log__c createLog(){
        nFUSE__Transaction_Log__c log = new nFUSE__Transaction_Log__c();
        log.nFUSE__External_Id__c = FAKE_EXTERNAL_ID;
        log.nFUSE__API_Version__c = '1.0';
        log.nFUSE__Action__c = 'DocPrep Request';
        log.nFUSE__Object_Id__c = 'loanId123';
        log.nFUSE__Primary_Object_Id__c = 'loanId123';
        log.nFUSE__App_Plugin__c = 'CSI_DepAct_DocPrep';
        log.nFUSE__Requesting_User_Id__c = 'userId123';
        log.nFUSE__Transaction_Status__c = STATUS_SUCCESS;
        log.nFUSE__Vendor_Status__c = STATUS_IN_PROGRESS;
        log.nFUSE__Requesting_User_Id__c = UserInfo.getUserId();
        log.nFUSE__Requested_By_User_Id__c = UserInfo.getUserId();
        insert log;

        createTestAttachment(log.Id);

        return log;
    }

    private static void createTestAttachment(String logId) {
        Attachment attach = new Attachment();
        attach.Name = CSIDepActDocPrepConstants.DOCPREP_ATTACHMENT_FILTER + logId + '.txt';

        Map<String, Object> msgProperties = new Map<String, Object>();
        msgProperties.put(CSIDepActDocPrepConstants.PARAM_SESSION_TOKEN, '');
        msgProperties.put(CSIDepActDocPrepConstants.PARAM_REDIRECT_URL, FAKE_WORKFLOW_SERVICE_URL + FAKE_EXTERNAL_ID);
        msgProperties.put(CSIDepActDocPrepConstants.PARAM_PROVIDER_SESSIONID, 'abc');
        Blob bodyBlob = Blob.valueOf(JSON.serialize(msgProperties));
        attach.Body = bodyBlob;
        attach.ParentId = logId;
        attach.ContentType = 'application/JSON';

        insert attach;
    }

    private static LLC_BI__Deposit__c createDeposit(String name, String accountNumber){
        LLC_BI__Deposit__c deposit = new LLC_BI__Deposit__c (
            Name = name,
            LLC_BI__Account_Number__c = accountNumber
        );
        insert deposit;
        return deposit;
    }

    private static final String
            STATUS_IN_PROGRESS = 'InProgress',
            STATUS_SUCCESS = 'Success',
            STATUS_FILING = 'Filing',
            FAKE_WORKFLOW_SERVICE_URL = 'https://ncinotest.compliancesystems.com:444/Session/',
            FAKE_EXTERNAL_ID = 'abc',
            FAKE_PRODUCT_NAME = 'Fake Product',
            FAKE_ACCOUNT_NUMBER = '1223';
}
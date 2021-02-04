@isTest
private with sharing class TestCSIDepActDocPrepCompletionController {

    @isTest
    private static void testConstructorWithValidLog(){
        nFUSE__Transaction_Log__c log = createLog();
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_EXTERNAL_LOG_ID, log.nFUSE__External_Id__c);

        createTestAttachment((String)log.Id);

        Test.startTest();
        CSIDepActDocPrepCompletionController controller = new CSIDepActDocPrepCompletionController();
        System.assertEquals((String)log.nFUSE__External_Id__c, controller.transactionExternalId);
        System.assertEquals(false, controller.errorsPresent);
        System.assertEquals(FAKE_WORKFLOW_SERVICE_URL + FAKE_EXTERNAL_ID, controller.docprepurl);

        Test.stopTest();
    }

    @isTest
    private static void testConstructorNoValidLogId_ThrowsApexPageMessage(){
        Test.startTest();
        CSIDepActDocPrepCompletionController controller = new CSIDepActDocPrepCompletionController();
        System.assertEquals(1, ApexPages.getMessages().size());
        System.assertEquals(true, controller.errorsPresent);
        Test.stopTest();
    }

    @isTest
    private static void testNoAttachmentFoundForTransactionLog(){
        nFUSE__Transaction_Log__c log = createLog();
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_EXTERNAL_LOG_ID, log.nFUSE__External_Id__c);

        Test.startTest();
        CSIDepActDocPrepCompletionController controller = new CSIDepActDocPrepCompletionController();
        System.assertEquals((String)log.nFUSE__External_Id__c, controller.transactionExternalId);
        System.assertEquals(1, ApexPages.getMessages().size());
        System.assertEquals(true, controller.errorsPresent);
    }

    @isTest
    private static void testUpdateStatusRemoteAction(){
        LLC_BI__Deposit__c deposit = [
            SELECT
                    Id,
                    LLC_BI__Account__c
            FROM
                    LLC_BI__Deposit__c
            LIMIT 1];

        Account acct = [SELECT Id, Name FROM Account WHERE Id =: deposit.LLC_BI__Account__c];
        nFUSE__Transaction_Log__c log = createLog();
        nFORCE__Session__c session = createSession(acct, deposit.Id, true);
        ApexPages.currentPage().getParameters().putAll(
            new Map<String, String>{
                    CSIDepActDocPrepConstants.PARAM_EXTERNAL_LOG_ID => log.Id,
                    CSIDepActDocPrepConstants.PARAM_ID => deposit.Id,
                    CSIDepActDocPrepConstants.PARAM_SID => session.Id
            }
        );

        Map<String, Object> sessionDataBefore = (Map<String, Object>)JSON.deserializeUntyped(session.nFORCE__Data__c);
        Map<String, Object> contextDataBefore = (Map<String, Object>)sessionDataBefore.get(deposit.Id);

        System.assertEquals(CSIDepActDocPrepConstants.SESSION_STATUS_IN_PROGRESS, contextDataBefore.get(CSIDepActDocPrepConstants.PARAM_SESSION_STATUS));

        CSIDepActDocPrepCompletionController.updateSession((String)deposit.Id, (String)session.Id, CSIDepActDocPrepConstants.SESSION_STATUS_SUCCESS);

        nFORCE__Session__c sessionAfter = [SELECT Id, nFORCE__Data__c FROM nFORCE__Session__c WHERE Id =: session.Id];
        Map<String, Object> sessionDataAfter = (Map<String, Object>)JSON.deserializeUntyped(sessionAfter.nFORCE__Data__c);
        Map<String, Object> contextDataAfter = (Map<String, Object>)sessionDataAfter.get(deposit.Id);

        System.assertEquals(CSIDepActDocPrepConstants.SESSION_STATUS_SUCCESS, contextDataAfter.get(CSIDepActDocPrepConstants.PARAM_SESSION_STATUS));
    }

    @isTest
    private static void testUpdateStatusRemoteAction_NoExistingStatus(){
        LLC_BI__Deposit__c deposit = [
                SELECT
                        Id,
                        LLC_BI__Account__c
                FROM
                        LLC_BI__Deposit__c
                LIMIT 1];

        Account acct = [SELECT Id, Name FROM Account WHERE Id =: deposit.LLC_BI__Account__c];
        nFUSE__Transaction_Log__c log = createLog();
        nFORCE__Session__c session = createSession(acct, deposit.Id, false);
        ApexPages.currentPage().getParameters().putAll(
                new Map<String, String>{
                        CSIDepActDocPrepConstants.PARAM_EXTERNAL_LOG_ID => log.Id,
                        CSIDepActDocPrepConstants.PARAM_ID => deposit.Id,
                        CSIDepActDocPrepConstants.PARAM_SID => session.Id
                }
        );

        Map<String, Object> sessionDataBefore = (Map<String, Object>)JSON.deserializeUntyped(session.nFORCE__Data__c);
        Map<String, Object> contextDataBefore = (Map<String, Object>)sessionDataBefore.get(deposit.Id);

        System.assertEquals(null, contextDataBefore);

        CSIDepActDocPrepCompletionController.updateSession((String)deposit.Id, (String)session.Id, CSIDepActDocPrepConstants.SESSION_STATUS_ERROR);

        nFORCE__Session__c sessionAfter = [SELECT Id, nFORCE__Data__c FROM nFORCE__Session__c WHERE Id =: session.Id];
        Map<String, Object> sessionDataAfter = (Map<String, Object>)JSON.deserializeUntyped(sessionAfter.nFORCE__Data__c);
        Map<String, Object> contextDataAfter = (Map<String, Object>)sessionDataAfter.get(deposit.Id);

        System.assertEquals(CSIDepActDocPrepConstants.SESSION_STATUS_ERROR, contextDataAfter.get(CSIDepActDocPrepConstants.PARAM_SESSION_STATUS));
    }

    @isTest
    private static void testRetryGenDocsCreationReturnsReviewURL(){
        LLC_BI__Deposit__c deposit = [SELECT Id, LLC_BI__Account__c FROM LLC_BI__Deposit__c LIMIT 1];
        Account sAccount = [SELECT Id, Name FROM Account WHERE Id =: deposit.LLC_BI__Account__c LIMIT 1];
        nFUSE__Transaction_Log__c log = createLog();
        nFORCE__Session__c session = createSession(sAccount, deposit.Id, false);
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_EXTERNAL_LOG_ID, log.nFUSE__External_Id__c);
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_TRANSACTION_ID, log.Id);
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_ID, deposit.Id);
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_SESSION_ID, TestCSIDepActDocPrepFilingController.FAKE_CSI_SESSION);

        createTestAttachment((String)log.Id);
        CSIDepActDocPrepCompletionController controller = new CSIDepActDocPrepCompletionController();

        String genDocsReturnURL = CSIDepActDocPrepCompletionController.retryGenerateDocs(
            String.format(
                '{0}.{1}',
                new List<String>{
                    CSIDepActDocPrepConstants.CREATION_GROUP,
                    CSIDepActDocPrepConstants.CREATION_REVIEW.substringAfter('.')}),
            (String)session.Id,
            (String)deposit.Id
        );

        System.assert(genDocsReturnURL.contains(session.Id));
        System.assert(genDocsReturnURL.contains(deposit.Id));
        System.assert(genDocsReturnURL.contains(CSIDepActDocPrepConstants.CREATION_REVIEW));
        System.assert(genDocsReturnURL.contains('sessionDML=false'));

    }

    @isTest
    private static void testRetryGenDocsMaintenanceReturnsReviewURL(){
        LLC_BI__Deposit__c deposit = [SELECT Id, LLC_BI__Account__c FROM LLC_BI__Deposit__c LIMIT 1];
        Account sAccount = [SELECT Id, Name FROM Account WHERE Id =: deposit.LLC_BI__Account__c LIMIT 1];
        nFUSE__Transaction_Log__c log = createLog();
        nFORCE__Session__c session = createSession(sAccount, deposit.Id, false);
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_EXTERNAL_LOG_ID, log.nFUSE__External_Id__c);
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_TRANSACTION_ID, log.Id);
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_ID, deposit.Id);
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_SESSION_ID, TestCSIDepActDocPrepFilingController.FAKE_CSI_SESSION);

        createTestAttachment((String)log.Id);
        CSIDepActDocPrepCompletionController controller = new CSIDepActDocPrepCompletionController();

        String genDocsReturnURL = CSIDepActDocPrepCompletionController.retryGenerateDocs(
                String.format(
                        '{0}.{1}',
                        new List<String>{
                                CSIDepActDocPrepConstants.MAINTENANCE_GROUP,
                                CSIDepActDocPrepConstants.MAINTENANCE_REVIEW.substringAfter('.')}),
                (String)session.Id,
                (String)deposit.Id
        );

        System.assert(genDocsReturnURL.contains(session.Id));
        System.assert(genDocsReturnURL.contains(deposit.Id));
        System.assert(genDocsReturnURL.contains(CSIDepActDocPrepConstants.MAINTENANCE_REVIEW));
        System.assert(genDocsReturnURL.contains('sessionDML=false'));

    }

    @isTest
    private static void testTransactionCompletOnConstruction_SetVendorStatusComplete(){
        LLC_BI__Deposit__c deposit = [SELECT Id, LLC_BI__Account__c FROM LLC_BI__Deposit__c LIMIT 1];
        Account sAccount = [SELECT Id, Name FROM Account WHERE Id =: deposit.LLC_BI__Account__c LIMIT 1];
        nFUSE__Transaction_Log__c log = createLog();

        log.nFUSE__Transaction_Status__c = CSIDepActDocPrepConstants.TRANSACTION_STATUS_COMPLETE;
        log.nFUSE__Vendor_Status__c = CSIDepActDocPrepConstants.VENDOR_STATUS_COMPLETE;
        update log;

        nFORCE__Session__c session = createSession(sAccount, deposit.Id, false);
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_EXTERNAL_LOG_ID, log.nFUSE__External_Id__c);
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_TRANSACTION_ID, log.Id);
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_ID, deposit.Id);
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_SESSION_ID, TestCSIDepActDocPrepFilingController.FAKE_CSI_SESSION);

        CSIDepActDocPrepCompletionController controller = new CSIDepActDocPrepCompletionController();
        System.assertEquals(CSIDepActDocPrepConstants.VENDOR_STATUS_COMPLETE, controller.vendorStatus);
        System.assertEquals(false, controller.errorsPresent);
    }

    @isTest
    private static void testLandingHRefMaintenanceSetToDocPrep(){
        LLC_BI__Deposit__c deposit = [SELECT Id, LLC_BI__Account__c FROM LLC_BI__Deposit__c LIMIT 1];
        Account sAccount = [SELECT Id, Name FROM Account WHERE Id =: deposit.LLC_BI__Account__c LIMIT 1];
        nFUSE__Transaction_Log__c log = createLog();

        nFORCE__Session__c session = createSession(sAccount, deposit.Id, false);
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_EXTERNAL_LOG_ID, log.nFUSE__External_Id__c);
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_TRANSACTION_ID, log.Id);
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_ID, deposit.Id);
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_SESSION_ID, TestCSIDepActDocPrepFilingController.FAKE_CSI_SESSION);
        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_APP, 'dep-pc.doc-completion');

        CSIDepActDocPrepCompletionController controller = new CSIDepActDocPrepCompletionController();
        System.assertEquals(CSIDepActDocPrepConstants.CREATION_LANDING, controller.landingHref.getParameters().get(CSIDepActDocPrepConstants.PARAM_APP));

    }


    @isTest
    private static void testResubmitDocumentsCreatesSendRequest(){
//        LLC_BI__Deposit__c deposit = [SELECT Id FROM LLC_BI__Deposit__c LIMIT 1];
//        nFUSE__Transaction_Log__c log = createLog();
//        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_EXTERNAL_LOG_ID, log.nFUSE__External_Id__c);
//        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_TRANSACTION_ID, log.Id);
//        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_ID, deposit.Id);
//        ApexPages.currentPage().getParameters().put(CSIDepActDocPrepConstants.PARAM_SESSION_ID, TestCSIDepActDocPrepFilingController.FAKE_CSI_SESSION);
//
//
//        createTestAttachment((String)log.Id);
//        CSIDepActDocPrepCompletionController controller = new CSIDepActDocPrepCompletionController();
//        controller.setCsiDocPrepAppFacade(new TestableCSIDepActDocPrepAppFacate());
//        try{
//            controller.reSubmitDocuments();
////            system.assert(true);
//        } catch(Exception e){
////            System.assert(false, 'resubmit documents failed');
//        }
//
//        nFUSE__Transaction_Log__c updatedLog = new CSIDepActTransactionLogService().getTransactionLog(log.Id);
//        System.assertEquals(CSIDepActDocPrepConstants.VENDOR_STATUS_FILING, updatedLog.nFUSE__Vendor_Status__c);


    }

    @TestSetup
    private static void createDeposit(){
        Account acct = new Account(
            Name = 'Test Account'
        );
        insert acct;

        LLC_BI__Deposit__c deposit = new LLC_BI__Deposit__c(
            Name = 'Test Deposit',
            LLC_BI__Account__c = acct.Id
        );
        insert deposit;
    }

    @TestVisible
    private static nFORCE__Session__c createSession(Account sAccount, Id contextId, Boolean setContextStatus){
        nFORCE__Session__c sSession = new nFORCE__Session__c(Name = sAccount.Name);
        if(contextId != null) sSession.nFORCE__Context_Id__c = contextId;
        Map<String, Object> data = new Map<String, Object>();
        data.put(PRIMARY_RELATIONSHIP_ID, sAccount.Id);
        if(setContextStatus){
            data.put(contextId, new Map<String, Object>{
                CSIDepActDocPrepConstants.PARAM_SESSION_STATUS => CSIDepActDocPrepConstants.SESSION_STATUS_IN_PROGRESS
            });
        }
        sSession.nFORCE__Data__c = JSON.serialize(data);
        insert sSession;
        return sSession;
    }

    private static void createTestAttachment(String logId) {
        Attachment attach = new Attachment();
        attach.Name = CSIDepActDocPrepConstants.DOCPREP_ATTACHMENT_FILTER + logId + '.txt';

        Map<String, Object> msgProperties = new Map<String, Object>();
        msgProperties.put(CSIDepActDocPrepConstants.PARAM_REDIRECT_URL, FAKE_WORKFLOW_SERVICE_URL + FAKE_EXTERNAL_ID);
        msgProperties.put(CSIDepActDocPrepConstants.PARAM_PROVIDER_SESSIONID, 'abc');
        Blob bodyBlob = Blob.valueOf(JSON.serialize(msgProperties));
        attach.Body = bodyBlob;
        attach.ParentId = logId;
        attach.ContentType = 'application/JSON';

        insert attach;
    }

    private static nFUSE__Transaction_Log__c createLog(){
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
            nFUSE__Vendor_Status__c = 'something'
        );
        insert log;
        return log;
    }

    private static final String FAKE_WORKFLOW_SERVICE_URL = 'https://ncinotest.compliancesystems.com:444/Session/';
    private static final String FAKE_EXTERNAL_ID = 'abc';
    private static final String PRIMARY_RELATIONSHIP_ID = 'primary-relationship-id';
}
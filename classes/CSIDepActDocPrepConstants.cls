public with sharing class CSIDepActDocPrepConstants {
    public static final String
        PROVIDER_CSI_DEPACT_DOCPREP = 'CSI_DepAct_DocPrep',
        FILING_PAGE = '/apex/c__CSIDepActDocPrepFiling',

        PARAM_APP = 'app',
        PARAM_EXTERNAL_LOG_ID = 'logId',
        PARAM_ORIGIN_WORKFLOW = 'originWorkflow',
        PARAM_CREATE_REQUEST = 'createRequest',
        PARAM_PROVIDER = 'provider',
        PARAM_SESSION_TOKEN = 'sessionToken',
        PARAM_PROVIDER_SESSIONID = 'providerSessionId',
        PARAM_SESSION_ID = 'sessionId',
        PARAM_REDIRECT_URL = 'redirectURL',
        PARAM_TRANSACTION_ID = 'transactionId',
        PARAM_PRIMARY_OBJECT_ID = 'primaryObjectId',
        PARAM_ID = 'id',
        PARAM_SID = 'sid',
        PARAM_SESSION_DML = 'sessionDML',
        PARAM_LICENSE_KEY = 'licenseKey',
        PARAM_SESSION_STATUS = 'status',
        PARAM_DOC_LIBRARY_VERSION = 'docLibraryVersion',
        PARAM_INTERFACE_CUSTOMIZATION = 'interfaceCustomization',
        PARAM_COMPLIANCE_SERVICE_HOST_URI = 'ComplianceServiceHostUri',
        PARAM_SIMPLICITY_HOST_URI = 'SimplicityHostUri',
        PARAM_WORKFLOW_SERVICE_HOST_URI = 'WorkflowServicesHostUri',
		PARAM_WORKFLOW_SERVICES_VERSION = 'workflowServicesVersion',

        PROPERTY_BAG_SESSION_CATEGORY = 'sessionCategory',
        PROPERTY_BAG_ENTITY_ID = 'entityId',

        SESSION_STATUS_SUCCESS = 'Success',
        SESSION_STATUS_ERROR = 'Error',
        SESSION_STATUS_IN_PROGRESS = 'In Progress',
        PARAM_ESIGNATURE_VENDOR = 'eSignatureVendor',

        FILING_URL = 'filingUrl',
        POST = 'POST',
        ACTION = 'action',
        ACTION_NEW = 'new',
        ACTION_CONTINUE = 'continue',
        ACTION_GENDOCANDSAVE = 'genDocAndSave',
        ACTION_SAVEONLY = 'saveOnly',

        ENCODING_SCHEME = 'UTF-8',
        CONTENT_TYPE = 'Content-Type',
        CONTENT_VALUE_URLENCODED = 'application/x-www-form-urlencoded',
        CONTENT_LENGTH = 'Content-Length',
        CONTENT_LENGTH_VALUE = '779',

        VENDOR_STATUS_FILING = 'Filing',
        VENDOR_STATUS_COMPLETE = 'Complete',
        VENDOR_STATUS_DOCVIEWER = 'DocViewerStart',

        TRANSACTION_STATUS_COMPLETE = 'Transaction Complete',

        PROP_PRODUCT_CATEGORY = 'productcategory',
        PROP_PRODUCT_SUB_CATEGORY = 'productsubcategory',

        DEPOSIT_CATEGORY = 'Deposit',
        PC_SUB_CATEGORY = 'Origination',
        PM_SUB_CATEGORY = 'Maintenance',
        LLC_BI_NAMESPACE= 'LLC_BI',
        NO_NAMESPACE= 'c',

        CREATION_GROUP = 'dep-pc',
        MAINTENANCE_GROUP = 'dep-pm',

        CREATION_REVIEW = 'dep-pc.dep-docprep-review',
        MAINTENANCE_REVIEW = 'dep-pm.pm-dep-docprep-review',

        CREATION_LANDING = 'dep-pc.pc-dep-docprep',
        MAINTENANCE_LANDING = 'dep-pm.pm-dep-docprep',

        CREATION_DOCMAN = 'dep-pc.pc-documents',
        MAINTENANCE_DOCMAN = 'dep-pm.pm-documents-maint',

        MIDDLEWARE_ENDPOINT = 'https://ps1w2.rt.informaticacloud.com/active-bpel/rt/ICRTOutboundListener',
        DOCPREP_ATTACHMENT_FILTER = 'DocPrep_%',

        X_NO_TRANSACTION_FOUND = 'No Transaction Found',
        X_NO_ATTACHMENT_FOUND = 'No Attachment Found',

        COMPLIANCE_SERVICE_ENDPOINT = 'https://intelledoc.test.compliancesystems.cloud',
        SIMPLICITY_ENDPOINT = 'https://ncino.simplicity.test.compliancesystems.cloud',
        WORKFLOW_SERVICE_ENDPOINT = 'https://workflow.test.compliancesystems.cloud',
		WORKFLOW_SERVICES_VERSION_ONE_ONE = '1.1',
		WORKFLOW_SERVICES_VERSION = WORKFLOW_SERVICES_VERSION_ONE_ONE;
}
public class DemoSetupConstants {
    public static final String PORTAL_UPLOAD_APP_NAME = 'CustomerPortalFileUploadApp';
    public static final String OAUTH_APP_NAME = 'Portal_OAuth66';
    public static final String SECRET_GUID = new nFORCE.GuidGenerator().randomUUIDNoUnderscores();
    public static final String BASEURL = String.valueOf(URL.getSalesforceBaseUrl().toExternalForm()).substringBefore('--');
    public static final String PORTAL_CREDENTIAL_NAME = 'PortalUploadCredential';
	public static final String CALLBACK_URL = '/apex/LLC_BI__Admin?app=admin.ruleengineoauth2';
    public static final String RULES_ENGINE_CATEGORY = 'Rule_Engine_Communicator';
    public static final String CUSTOMER_PORTAL_CATEGORY = 'CUSTOMER_PORTAL';
    public static final String OAUTH2_CONSUMER_KEY = 'OAUTH2_CONSUMER_KEY';
    public static final String URL_STRING = '/services/oauth2/authorize?client_id=';
    public static final String RESPONSE_TYPE = '&response_type=code ';
    public static final String REDIRECT_URI = 'redirect_uri';
}
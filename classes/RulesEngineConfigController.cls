global class RulesEngineConfigController {
    public String baseUrl;
    public String secretGUID;
    public String callbackUrl;
    public RulesEngineConfigController(){
        this.baseUrl = String.valueOf(URL.getSalesforceBaseUrl().toExternalForm()).substringBefore('--') + '.cloudforce.com';
        //this.secretGUID = new nFORCE.GuidGenerator().randomUUIDNoUnderscores();
    }
    public String getBaseUrl(){
        return BASEURL;
    }
    public String getSecretGUID(){
        return SECRET_GUID;
    }
    public String getcallbackUrl(){
        return CALLBACK_URL;
    }

    
    @RemoteAction
    global static void setSystemProperties(String consumerKey, String consumerSecret){
        List<nFORCE__System_Properties__c> properties = [
            SELECT
                Id,
                Name,
                nFORCE__Category_Name__c,
                nFORCE__Key__c,
                nFORCE__Value__c
            FROM
                nFORCE__System_Properties__c
            WHERE
                nFORCE__Category_Name__c =: RULES_ENGINE_CATEGORY
            AND
                nFORCE__Key__c IN: PROPERTY_MAP.keySet()                
        ];
        for(nFORCE__System_Properties__c prop : properties){
            if(prop.nFORCE__Key__c == 'OAUTH2_CONSUMER_KEY'){
                prop.nFORCE__Value__c = consumerKey;
            } else if(prop.nFORCE__Key__c == 'OAUTH2_CONSUMER_SECRET'){
                prop.nFORCE__Value__c = consumerSecret;
            } else {
                prop.nFORCE__Value__c = PROPERTY_MAP.get(prop.nFORCE__Key__c);            
            }
            prop.nFORCE__Is_Active__c = true;
        }
        update properties;
    }
    
    private static final String BASEURL = String.valueOf(URL.getSalesforceBaseUrl().toExternalForm()).substringBefore('--') + '.cloudforce.com';
    private static final String SECRET_GUID = new nFORCE.GuidGenerator().randomUUIDNoUnderscores();
    private static final String CALLBACK_URL = '/apex/LLC_BI__Admin?app=admin.ruleengineoauth2';
    private static final String RULES_ENGINE_CATEGORY = 'Rule_Engine_Communicator';
    private static final Map<String, String> PROPERTY_MAP = new Map<String, String>{
        'OAUTH2_AUTH_URL' => BASEURL + '/services/oauth2/authorize',
        'OAUTH2_TOKEN_URL' => BASEURL + '/services/oauth2/token',
        'OAUTH2_REDIRECT_URL' => BASEURL + CALLBACK_URL,
        'OAUTH2_CONSUMER_KEY' => '',
        'OAUTH2_CONSUMER_SECRET' => '',
        'OAUTH2_AUTH_CODE' => '',
        'OAUTH2_REFRESH_CODE' => ''
    };
}
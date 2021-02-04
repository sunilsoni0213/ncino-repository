/****************************************************************************************
Name            : OAuthAuthorizeController
Revision Log    : 2020-03-24 John Kuhl - CodeScience
                :
                :
Use             : Controller for OAuth2 Authorize Modal
****************************************************************************************/
public class OAuthAuthorizeController {

    /**
     * getURL
     *
     * Construct URL for Authorization Page
     **/
    @AuraEnabled
    public static String getURL() {

        nFORCE__System_Properties__c systemProperties = [SELECT Id, 
                                                                nFORCE__Value__c
                                                                FROM nFORCE__System_Properties__c
                                                                WHERE nFORCE__Key__c =: DemoSetupConstants.OAUTH2_CONSUMER_KEY 
                                                                LIMIT 1];

        String urlConstruct = 
                DemoSetupConstants.BASEURL +
                DemoSetupConstants.URL_String + 
                systemProperties.nFORCE__Value__c + '&' +
                EncodingUtil.urlEncode(DemoSetupConstants.REDIRECT_URI, 'UTF-8') + '=' + 
                EncodingUtil.urlEncode(DemoSetupConstants.BASEURL, 'UTF-8') +
                EncodingUtil.urlEncode(DemoSetupConstants.CALLBACK_URL, 'UTF-8') + 
                DemoSetupConstants.RESPONSE_TYPE;
        
        return urlConstruct;
    }
}
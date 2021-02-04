/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class HttpCalloutUtility_v1 {
    global HttpCalloutUtility_v1() {

    }
    global HttpCalloutUtility_v1(EFPIO.ILoggingProvider_v1 loggingProvider, EFPIO.HttpCalloutUtility_v1.HttpCalloutSettings_v1 calloutSettings) {

    }
    global virtual void AddDefaultHeaders() {

    }
    global virtual EFPIO.HttpCalloutUtility_v1.HttpCalloutResponse_v1 PerformRequest() {
        return null;
    }
    global void UpsertRequestHeader(String key, String value) {

    }
    global void UpsertRequestHeaders(Map<String,String> requestHeaders) {

    }
global class HttpCalloutResponse_v1 {
    global Blob httpResponseAsBlob {
        get;
        set;
    }
    global dom.Document httpResponseAsDom {
        get;
        set;
    }
    global String httpResponseAsString {
        get;
        set;
    }
    global List<String> httpResponseHeaders {
        get;
        set;
    }
    global Integer httpResponseStatusCode {
        get;
        set;
    }
    global Boolean isSuccessful {
        get;
        set;
    }
    global List<String> Messages {
        get;
        set;
    }
    global HttpCalloutResponse_v1() {

    }
}
global class HttpCalloutSettings_v1 {
    global String certificateName {
        get;
        set;
    }
    global String endpointOrNamedCredential {
        get;
        set;
    }
    global String requestBody {
        get;
        set;
    }
    global Map<String,String> requestHeaders {
        get;
        set;
    }
    global EFPIO.HttpCalloutUtility_v1.RESPONSE_TYPE responseTypeToReturn {
        get;
        set;
    }
    global Integer timeoutInSeconds {
        get;
        set;
    }
    global String verb {
        get;
        set;
    }
    global HttpCalloutSettings_v1() {

    }
}
global enum RESPONSE_TYPE {AS_BLOB, AS_DOM, AS_STRING}
}

/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class LifeCycleHttpCommunicator extends nFORCE.ASynchronousLifeCycleCommunicator {
    global static String HTTP_CONTENT_TYPE;
    global static String HTTP_HEADER;
    global static String HTTP_TIMEOUT;
    global static String HTTP_VERB;
    global Map<String,String> httpHeaders {
        get;
        set;
    }
    global Integer httpTimeOut {
        get;
        set;
    }
    global String httpVerb {
        get;
        set;
    }
    global LifeCycleHttpCommunicator() {

    }
    global virtual void beforeSend(System.HttpRequest request) {

    }
    global override virtual List<String> getUserConfigurableParameters() {
        return null;
    }
    global virtual System.HttpResponse httpSend(nFORCE.ILifeCycleMessage msg) {
        return null;
    }
    global virtual System.HttpResponse httpSend(String msg, String destination) {
        return null;
    }
    global override virtual void initParameters(nFORCE__Communication_Provider__c provider) {

    }
    global virtual nFORCE.HttpWrapper newHttp() {
        return null;
    }
    global override String send(nFORCE.ILifeCycleMessage msg) {
        return null;
    }
}

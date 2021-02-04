/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class AAppFacade extends nFUSE.AController implements nFUSE.SendService.ISendSeam {
    global virtual nFUSE.SendService createSendService(String verb, Integer timeout, Map<String,String> httpHeaders, String endpoint) {
        return null;
    }
    global virtual nFUSE.AMiddlewareMessage preCommAdjustments(nFUSE.AMiddlewareMessage message) {
        return null;
    }
    global virtual nFUSE.AAppFacade.NavigationRequest preNavAdjustments(nFUSE.AAppFacade.NavigationRequest navRequest) {
        return null;
    }
    global virtual Object preSendRequest(Object request) {
        return null;
    }
    global virtual Object preSendRequest(Object request, nFUSE.AMiddlewareMessage message) {
        return null;
    }
    global virtual void storeDocument(String transactionId, String docName, String docContent) {

    }
global class NavigationRequest {
    global System.PageReference requestedRef {
        get;
        set;
    }
    global System.PageReference requestingRef {
        get;
    }
    global NavigationRequest() {

    }
}
}

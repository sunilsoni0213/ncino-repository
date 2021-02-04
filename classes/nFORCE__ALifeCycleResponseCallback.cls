/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class ALifeCycleResponseCallback implements nFORCE.ILifeCycleCommunicatorCallback {
    global ALifeCycleResponseCallback(nFORCE.ILifeCycleMessage req) {

    }
    global void callBack(nFORCE.ILifeCycleMessage rspMsg, Object echoData) {

    }
    global virtual Object getEchoData() {
        return null;
    }
    global nFORCE.ILifeCycleMessage getReqMessage() {
        return null;
    }
    global nFORCE.ILifeCycleMessage getRspMessage() {
        return null;
    }
    global abstract System.Type getRspType();
    global abstract void processResponse(nFORCE.ILifeCycleMessage param0, Object param1);
    global void setEchoData(Object echoData) {

    }
}

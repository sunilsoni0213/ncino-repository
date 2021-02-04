/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class ALifeCycleResponseCallback implements LLC_BI.ILifeCycleCommunicatorCallback {
    global ALifeCycleResponseCallback(LLC_BI.ILifeCycleMessage req) {

    }
    global void callBack(LLC_BI.ILifeCycleMessage rspMsg, Object echoData) {

    }
    global virtual Object getEchoData() {
        return null;
    }
    global LLC_BI.ILifeCycleMessage getReqMessage() {
        return null;
    }
    global LLC_BI.ILifeCycleMessage getRspMessage() {
        return null;
    }
    global abstract System.Type getRspType();
    global abstract void processResponse(LLC_BI.ILifeCycleMessage param0, Object param1);
    global void setEchoData(Object echoData) {

    }
}

/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class ALifeCycleCommunicator implements LLC_BI.ILifeCycleCommunicator {
    global ALifeCycleCommunicator() {

    }
    global virtual String getDestination() {
        return null;
    }
    global Map<String,String> getParameters() {
        return null;
    }
    global String getUniqueName() {
        return null;
    }
    global virtual void initParameters(LLC_BI__Communication_Provider__c config) {

    }
    global abstract void sendToRemote(LLC_BI.ILifeCycleMessage param0, LLC_BI.ILifeCycleCommunicatorCallback param1);
}

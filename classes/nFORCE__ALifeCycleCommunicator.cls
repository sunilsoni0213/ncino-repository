/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class ALifeCycleCommunicator implements nFORCE.IConfigurableCommunicator, nFORCE.ILifeCycleCommunicator {
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
    global virtual List<String> getUserConfigurableParameters() {
        return null;
    }
    global virtual void initParameters(nFORCE__Communication_Provider__c config) {

    }
    global virtual Boolean isActive() {
        return null;
    }
    global virtual void saveParameters(Map<String,String> parameters) {

    }
    global abstract void sendToRemote(nFORCE.ILifeCycleMessage param0, nFORCE.ILifeCycleCommunicatorCallback param1);
    global virtual void setConfiguration(nFORCE__Communication_Provider__c config) {

    }
}

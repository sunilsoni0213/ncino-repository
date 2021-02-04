/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface ILifeCycleCommunicator {
    String getDestination();
    Map<String,String> getParameters();
    String getUniqueName();
    void send(nFORCE.ILifeCycleMessage param0, nFORCE.ILifeCycleCommunicatorCallback param1);
    void setConfiguration(nFORCE__Communication_Provider__c param0);
}

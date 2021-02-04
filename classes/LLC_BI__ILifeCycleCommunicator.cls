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
    void send(LLC_BI.ILifeCycleMessage param0, LLC_BI.ILifeCycleCommunicatorCallback param1);
    void setConfiguration(LLC_BI__Communication_Provider__c param0);
}

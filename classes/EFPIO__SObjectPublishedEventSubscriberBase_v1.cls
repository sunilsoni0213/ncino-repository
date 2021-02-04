/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class SObjectPublishedEventSubscriberBase_v1 extends nFORCE.ATriggerHandler {
    global SObjectPublishedEventSubscriberBase_v1() {

    }
    global abstract void Cleanup(List<EFPIO__OrchestrationEvent__c> param0);
    global abstract EFPIO.ILoggingProvider_v1 GetLoggingProvider();
    global abstract String GetRegistryName();
    global abstract void Handle(List<EFPIO.InvocableHandleEventRequest_v1> param0);
}

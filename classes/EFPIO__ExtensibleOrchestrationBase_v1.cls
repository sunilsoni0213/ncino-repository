/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class ExtensibleOrchestrationBase_v1 {
    global List<EFPIO.ExtensibleOrchestrationBase_v1.EventHandlerWrapper_v1> eventsToChainTogether {
        get;
    }
    global ExtensibleOrchestrationBase_v1(EFPIO.ILoggingProvider_v1 loggingProvider, String correlationId, Boolean stopOnException) {

    }
    global void AddEvent(String registryName, String fullyQualifiedClassName, EFPIO.IEventHandler_v1 eventHandler, EFPIO.State_v1 state, String status) {

    }
    global virtual void Run() {

    }
global abstract class AEventHandlerBase_v1 implements EFPIO.IEventHandler_v1 {
    global EFPIO.ILoggingProvider_v1 loggingProvider {
        get;
    }
    global String priorEventStateData {
        get;
    }
    global AEventHandlerBase_v1(EFPIO.ILoggingProvider_v1 loggingProvider) {

    }
    global abstract EFPIO.HandleEventResponse_v1 Execute(EFPIO.State_v1 param0, String param1);
}
global class EventHandlerWrapper_v1 {
    global EFPIO.HandleEventResponse_v1 eventHandlerResponse {
        get;
    }
}
}

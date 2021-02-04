/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class AMiddlewareMessage implements nFORCE.ILifeCycleMessage {
    global System.HttpResponse httpResponse {
        get;
        set;
    }
    global nFUSE.MessageHeader messageHeader {
        get;
        set;
    }
    global String method {
        get;
        set;
    }
    global Map<String,Object> properties {
        get;
        set;
    }
    global AMiddlewareMessage() {

    }
    global virtual String toMsg() {
        return null;
    }
}

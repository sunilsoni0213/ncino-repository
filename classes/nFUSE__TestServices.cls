/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class TestServices {
    global TestServices() {

    }
global virtual class SendServiceMock extends nFUSE.SendService {
    global SendServiceMock() {

    }
    global List<nFUSE.AMiddlewareMessage> getSentMessages() {
        return null;
    }
    global override virtual nFUSE.AMiddlewareMessage send(nFUSE.ServiceRequest request, nFUSE.AMiddlewareMessage message) {
        return null;
    }
    global nFUSE.TestServices.SendServiceMock setException(Exception ex) {
        return null;
    }
    global nFUSE.TestServices.SendServiceMock setIsDmlMonitoring(Boolean isMonitoring) {
        return null;
    }
}
}

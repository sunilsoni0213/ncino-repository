/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class TestLifeCycleCommunicationsFramework {
    global TestLifeCycleCommunicationsFramework() {

    }
global class NoOpALifeCycleCommunicator extends nFORCE.ALifeCycleCommunicator {
    global NoOpALifeCycleCommunicator() {

    }
    global override void sendToRemote(nFORCE.ILifeCycleMessage msg, nFORCE.ILifeCycleCommunicatorCallback callback) {

    }
}
global class TestASynchronousLifeCycleCommunicator extends nFORCE.ASynchronousLifeCycleCommunicator {
    global TestASynchronousLifeCycleCommunicator() {

    }
}
global class TestHttpCommunicator extends nFORCE.LifeCycleHttpCommunicator {
    global TestHttpCommunicator() {

    }
    global override void beforeSend(System.HttpRequest request) {

    }
    global override nFORCE.HttpWrapper newHttp() {
        return null;
    }
}
}

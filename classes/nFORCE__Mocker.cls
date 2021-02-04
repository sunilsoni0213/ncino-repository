/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class Mocker {
    global Mocker() {

    }
    global static nFORCE.Mocker.ObjectMock mock(System.Type mockType) {
        return null;
    }
global class AggregateException extends Exception {
}
global class ExpectedException extends Exception {
}
global class FailedExpectationsException extends Exception {
}
global class InvalidArgumentException extends Exception {
}
global class MethodCall {
}
global class MethodMock {
    global Integer getCallCount() {
        return null;
    }
    global String getSignature() {
        return null;
    }
    global nFORCE.Mocker.MethodMock setExpectedCallCount(nFORCE.IPredicate condition) {
        return null;
    }
    global nFORCE.Mocker.MethodMock setExpectedReturn(Object returns) {
        return null;
    }
    global nFORCE.Mocker.MethodMock setExpectedReturn(List<Object> expectedArgs, Object returns) {
        return null;
    }
    global nFORCE.Mocker.MethodMock setExpectedThrownException() {
        return null;
    }
    global nFORCE.Mocker.MethodMock setExpectedThrownException(Exception ex) {
        return null;
    }
    global nFORCE.Mocker.MethodMock setParamCondition(Integer position, System.Type dataType, nFORCE.IPredicate rule, String failMessage) {
        return null;
    }
}
global class MethodMockException extends Exception {
}
global virtual class MockException extends Exception {
}
global virtual class ObjectMock implements System.StubProvider {
    global void assertExpectations() {

    }
    global nFORCE.Mocker.MethodMock getMethod(String methodName) {
        return null;
    }
    global nFORCE.Mocker.MethodMock getMethod(String methodName, System.Type param1Type) {
        return null;
    }
    global nFORCE.Mocker.MethodMock getMethod(String methodName, System.Type param1Type, System.Type param2Type) {
        return null;
    }
    global virtual nFORCE.Mocker.MethodMock getMethod(String methodName, List<System.Type> paramTypes) {
        return null;
    }
    global Object getStub() {
        return null;
    }
}
}

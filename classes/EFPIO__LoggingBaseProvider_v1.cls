/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class LoggingBaseProvider_v1 extends nFUSE.DebugLogProvider implements EFPIO.ILoggingProvider_v1 {
    global LoggingBaseProvider_v1() {

    }
    global LoggingBaseProvider_v1(String delimitedListOfLogLevels) {

    }
    global abstract void Add(Object param0);
    global virtual void Add(System.LoggingLevel logLevel, Object logItem) {

    }
    global abstract void Add(System.LoggingLevel param0, String param1, String param2, Boolean param3);
    global virtual void BulkUpdate(List<SObject> items, Integer retryAttemptsRemaining) {

    }
    global abstract Object GetLatest();
    global virtual void Init(Id objectId) {

    }
    global virtual void Init(String correlationId, Id objectId) {

    }
    @TestVisible
    global virtual Boolean LogLevelInConfiguration(System.LoggingLevel logLevelToTest) {
        return null;
    }
    global abstract void Save();
    global virtual void SetLogLevelsToCapture(String delimitedListOfLogLevels) {

    }
    global void SetMaxDeadlockRetryAttempts(Integer maxRetryAttempts) {

    }
    global virtual String getCorrelationId() {
        return null;
    }
    global virtual Boolean isInitialized() {
        return null;
    }
}

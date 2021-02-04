/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ServiceInfo_v1 {
    global String Description {
        get;
        set;
    }
    global String EventFailureStatus {
        get;
        set;
    }
    global String EventSuccessStatus {
        get;
        set;
    }
    global String FullyQualifiedClassName {
        get;
        set;
    }
    global String InformationUrl {
        get;
        set;
    }
    global Map<String,EFPIO.ServiceParameterInfo_v1> InputParameters {
        get;
        set;
    }
    global String Name {
        get;
        set;
    }
    global String nFORCEBeanName {
        get;
        set;
    }
    global Map<String,EFPIO.ServiceParameterInfo_v1> OutputParameters {
        get;
        set;
    }
    global String ServiceType {
        get;
        set;
    }
    global String SignatureMethodName {
        get;
        set;
    }
    global ServiceInfo_v1(String fullyQualifiedClassName, String nForceBeanName, String name, String description, String serviceType, Map<String,EFPIO.ServiceParameterInfo_v1> inputParameters, Map<String,EFPIO.ServiceParameterInfo_v1> outputParameters, String eventSuccessStatus, String eventFailureStatus) {

    }
    global ServiceInfo_v1(String fullyQualifiedClassName, String nForceBeanName, String name, String description, String serviceType, Map<String,EFPIO.ServiceParameterInfo_v1> inputParameters, Map<String,EFPIO.ServiceParameterInfo_v1> outputParameters, String eventSuccessStatus, String eventFailureStatus, String informationUrl, String signatureMethodName) {

    }
}

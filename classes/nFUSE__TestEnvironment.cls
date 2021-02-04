/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class TestEnvironment {
    global TestEnvironment() {

    }
    global static nFUSE.TestEnvironment getInstance() {
        return null;
    }
    global nFUSE.TestEnvironment registerAcmeIdVerificationPlugin() {
        return null;
    }
    global nFUSE.TestEnvironment registerAcmeIdVerificationPlugin(String pluginName, Boolean isActive) {
        return null;
    }
    global nFUSE.TestEnvironment registerAcmeIdVerificationPlugin(String pluginName, Boolean isActive, String beanName, System.Type beanType) {
        return null;
    }
global class AcmeCommercialDocPrepAppFacade extends nFUSE.CommLoanDocPrepAppFacade {
    global AcmeCommercialDocPrepAppFacade() {

    }
}
global class AcmeCreditAppFacade extends nFUSE.CreditAppFacade {
    global AcmeCreditAppFacade() {

    }
    global override void storeDocument(String transactionId, String docName, String docContent) {

    }
}
global class AcmeCreditPassReviewDecision extends nFUSE.ACreditPassReviewDecision {
    global AcmeCreditPassReviewDecision() {

    }
    global override Flow.Interview create(Map<String,Object> inputs) {
        return null;
    }
}
global class AcmeCreditReportTypeDecision extends nFUSE.ACreditReportTypeDecision {
    global AcmeCreditReportTypeDecision() {

    }
    global override Flow.Interview create(Map<String,Object> inputs) {
        return null;
    }
}
global class AcmeDocPrepAppFacade extends nFUSE.DocPrepAppFacade {
    global AcmeDocPrepAppFacade() {

    }
}
global class AcmeIdVerificationSendService extends nFUSE.SendService {
    global AcmeIdVerificationSendService() {

    }
}
global class AcmeRetailDocPrepAppFacade extends nFUSE.RetailLoanDocPrepAppFacade {
    global AcmeRetailDocPrepAppFacade() {

    }
}
global class TempPlugin {
    global TempPlugin(String name, String pluginType) {

    }
    global nFUSE.TestEnvironment.TempPlugin configFieldSet(Schema.SObjectType sType, String fsName, String context, List<Schema.SObjectField> fields) {
        return null;
    }
    global Boolean getIsActive() {
        return null;
    }
    global String getName() {
        return null;
    }
    global String getPluginType() {
        return null;
    }
    global nFUSE.TestEnvironment.TempPlugin register() {
        return null;
    }
    global nFUSE.TestEnvironment.TempPlugin setIsActive(Boolean isActive) {
        return null;
    }
}
global class XESignatureService extends nFUSE.ESignatureService {
    global XESignatureService() {

    }
}
global class xAcmeCreditAppFacade extends nFUSE.CreditAppFacade {
    global xAcmeCreditAppFacade() {

    }
    global override void storeDocument(String transactionId, String docName, String docContent) {

    }
}
}

/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SFDCAccessController {
    global SFDCAccessController() {

    }
    global SFDCAccessController(LLC_BI.SFDCAccessController.SharingMode p1, LLC_BI.SFDCAccessController.OperationMode p2) {

    }
    global SFDCAccessController(LLC_BI.SFDCAccessController.SharingMode p1, LLC_BI.SFDCAccessController.OperationMode p2, LLC_BI.SFDCAccessController.OperationMode p3) {

    }
    global void deleteAsUser(SObject p1) {

    }
    global LLC_BI.SFDCAccessControlResults.DeleteResults deleteAsUser(List<SObject> p1) {
        return null;
    }
    global LLC_BI.SFDCAccessControlResults.InsertResults insertAsUser(List<SObject> p1, List<Schema.SObjectField> p2) {
        return null;
    }
    global LLC_BI.SFDCAccessControlResults.InsertResults insertAsUser(List<SObject> p1, List<String> p2) {
        return null;
    }
    global SObject insertAsUser(SObject p1, List<Schema.SObjectField> p2) {
        return null;
    }
    global SObject insertAsUser(SObject p1, List<String> p2) {
        return null;
    }
    global void setArrayOperationMode(LLC_BI.SFDCAccessController.OperationMode p1) {

    }
    global void setOperationMode(LLC_BI.SFDCAccessController.OperationMode p1) {

    }
    global void setSharingMode(LLC_BI.SFDCAccessController.SharingMode p1) {

    }
    global LLC_BI.SFDCAccessControlResults.UpdateResults updateAsUser(Map<Id,SObject> p1, List<Schema.SObjectField> p2) {
        return null;
    }
    global LLC_BI.SFDCAccessControlResults.UpdateResults updateAsUser(Map<Id,SObject> p1, List<String> p2) {
        return null;
    }
    global SObject updateAsUser(SObject p1, List<Schema.SObjectField> p2) {
        return null;
    }
    global SObject updateAsUser(SObject p1, List<String> p2) {
        return null;
    }
global class AccessControlDmlException extends Exception {
}
global enum OperationMode {ALL_OR_NONE, BEST_EFFORT}
global enum SharingMode {INHERIT, WITH, WITHOUT}
}

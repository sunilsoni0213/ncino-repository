/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class LifeCycleService {
    global LifeCycleService() {

    }
    @RemoteAction
    global static String cleanAttachments(String parentId, String prefix, String fileName) {
        return null;
    }
    @RemoteAction
    global static nFORCE.ALifeCycleAttachment retrieveAttachment(Id parentId, String fileName) {
        return null;
    }
    @RemoteAction
    global static nFORCE.IForce retrieveIForce(Id recordId) {
        return null;
    }
    @RemoteAction
    global static List<nFORCE.IForce> retrieveIForces(List<Id> recordIds) {
        return null;
    }
    global static Id saveAttachment(Id parentId, String fileName, String contentType, String body, Boolean overwriteExisting) {
        return null;
    }
    @RemoteAction
    global static nFORCE.IForce saveIForce(nFORCE.IForce obj) {
        return null;
    }
    global static String saveSlice(Id parentId, String attachmentId, String fileName, String contentType, String base64Value, Boolean overwriteExisting) {
        return null;
    }
}

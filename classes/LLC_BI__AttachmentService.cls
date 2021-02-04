/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AttachmentService {
    global AttachmentService() {

    }
    @RemoteAction
    global static String cleanAttachments(String parentId, String prefix, String fileName) {
        return null;
    }
    @RemoteAction
    global static void cloneScreenSectionAttachments(String templateScreenId, String cloneScreenId) {

    }
    @RemoteAction
    global static LLC_BI.ALifeCycleAttachment retrieveAttachment(Id parentId, String fileName) {
        return null;
    }
    @RemoteAction
    global static Id saveAttachment(Id parentId, String fileName, String contentType, String body, Boolean overwriteExisting) {
        return null;
    }
    @RemoteAction
    global static String saveChunk(Id parentId, String attachmentId, String fileName, String contentType, String base64Value, Boolean overwriteExisting, Boolean decodeBody) {
        return null;
    }
    @RemoteAction
    global static String saveSlice(Id parentId, String attachmentId, String fileName, String contentType, String base64Value, Boolean overwriteExisting) {
        return null;
    }
}

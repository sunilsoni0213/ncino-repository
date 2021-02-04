/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ProductDetailController {
    global ProductDetailController() {

    }
    @RemoteAction
    global static void deleteDocument(Id objectId, Id documentId, Id docStoreIndexId) {

    }
    @RemoteAction
    global static void deleteDocumentStoreIndex(Id docStoreIndexId) {

    }
    global System.PageReference forwardToCustomAuthPage() {
        return null;
    }
    global List<nPortal.ALifeCycleDocument> getApprovedDocuments() {
        return null;
    }
    @RemoteAction
    global static LLC_BI__Document_Store_Index__c getDocumentStoreIndexForUpload() {
        return null;
    }
    global List<nPortal.ALifeCycleDocument> getExceptionDocuments() {
        return null;
    }
    global nPortal.LifeCycleInvolvement getInvolvement() {
        return null;
    }
    global List<nPortal.ALifeCycleDocument> getOpenDocuments() {
        return null;
    }
    global List<nPortal.ALifeCycleDocument> getRejectedDocuments() {
        return null;
    }
    global List<nPortal.ALifeCycleDocument> getReviewDocuments() {
        return null;
    }
    global Integer getToDoDocumentsCount() {
        return null;
    }
    global Integer getUploadSizeLimit() {
        return null;
    }
    global String getUploadSizeLimitDisplay() {
        return null;
    }
    @RemoteAction
    global static void handleUploadFailure(nPortal.PortalLifeCycleDocument document) {

    }
    global void initPage() {

    }
    @RemoteAction
    global static nPortal.PortalLifeCycleDocument initializeUpload() {
        return null;
    }
    @RemoteAction
    global static void removeAttachment(Id loanDocId, Id docStoreIndexId) {

    }
    @RemoteAction
    global static void replaceDocument(Id objectId, Id documentId, Id docStoreIndexId) {

    }
    @RemoteAction
    global static void submitAllDocuments(List<Id> documentIds) {

    }
    @RemoteAction
    global static void submitDocuments(Id objectId, List<Id> documentIds) {

    }
    @RemoteAction
    global static void updateDocument(Id objectId, Id documentId, Id docStoreIndexId) {

    }
    @RemoteAction
    global static void updateDocumentAfterUpload(Id loanDocId, Id newDocStoreIndexId) {

    }
    @RemoteAction
    global static void uploadFailed(Id objectId, nPortal.PortalLifeCycleDocument document) {

    }
    @RemoteAction
    global static Id uploadFileSlice(Id attachmentId, String base64FileChunk, String contentType, String name, String parentId) {
        return null;
    }
}

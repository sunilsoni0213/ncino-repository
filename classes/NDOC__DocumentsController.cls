/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class DocumentsController {
    global DocumentsController(ApexPages.StandardController stdController) {

    }
    @RemoteAction
    global static Map<String,Object> addBankComments(String documentId, String comments) {
        return null;
    }
    @RemoteAction
    global static Set<Map<String,Object>> autoUpdateDocumentAttachment(Id objectId, Id documentId) {
        return null;
    }
    @RemoteAction
    global static Set<Map<String,Object>> autoUpdatePortalDocumentAttachment(Id documentId, Id docStoreIndexId) {
        return null;
    }
    @RemoteAction
    global static void bulkFlagForReview(List<Id> documentIds) {

    }
    @RemoteAction
    global static List<Map<String,Object>> changeDocTypeForDocument(Id associatedObjectId, Id docTypeId, Id documentId) {
        return null;
    }
    @RemoteAction
    global static List<Map<String,Object>> changeDocTypeForDocuments(Id associatedObjectId, Id docTypeId, List<Id> documentIds) {
        return null;
    }
    @RemoteAction
    global static List<Map<String,Object>> cloneDoc(Id associatedObjectId, Id documentId) {
        return null;
    }
    @RemoteAction
    global static LLC_BI__Document_Store_Index__c createDocumentStoreStructure() {
        return null;
    }
    @RemoteAction
    global static List<Map<String,Object>> createDocumentWithOwner(Id associatedObjectId, String name, Id docTabId, Id docTypeId, String year, String legalEntity, String needByStage, String owner) {
        return null;
    }
    @RemoteAction
    global static List<Map<String,Object>> createDocument(Id associatedObjectId, String name, Id docTabId, Id docTypeId, String year, String legalEntity, String needByStage) {
        return null;
    }
    @RemoteAction
    global static List<Map<String,Object>> deleteDocAndRollBackOldDoc(Id docId, Id oldDocId, Id associatedObjectId) {
        return null;
    }
    @RemoteAction
    global static void deleteDocumentStoreIndex(Id docStoreIndexId) {

    }
    @RemoteAction
    global static Map<String,Object> deleteDocuments(List<Id> closingDocumentIds) {
        return null;
    }
    @RemoteAction
    global static void deleteSFDCAttachment(Id documentId) {

    }
    @RemoteAction
    global static List<Map<String,Object>> deleteUploadedAttachment(List<Id> documentIds) {
        return null;
    }
    @RemoteAction
    global static List<Map<String,Object>> duplicateDocument(List<Id> documentIds) {
        return null;
    }
    @RemoteAction
    global static void emptyStagingArea(Id objectId) {

    }
    @RemoteAction
    global static List<Map<String,String>> getAllDocTypes(String objectId) {
        return null;
    }
    @RemoteAction
    global static List<String> getAllowedFileExtensions() {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI__Account_Collateral__c> getCollateralOwners(Id id) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI__Loan_Collateral2__c> getCollateral(Id id) {
        return null;
    }
    global static NDOC.IDocumentManager getDocumentManager(Id objectId) {
        return null;
    }
    @RemoteAction
    global static Id getDocumentStoreIdForDocument(Id associatedObjectId, Id documentId) {
        return null;
    }
    @RemoteAction
    global static Map<String,Object> getDocument(Id objectId, Id documentId) {
        return null;
    }
    @RemoteAction
    global static List<Map<String,Object>> getDocumentsByLoanIdAndDocumentId(Id objectId, List<Id> closingDocumentIds) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI__AccountDocument__c> getDocumentsForAccount(Id accountId) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI__Document_Placeholder__c> getDocumentsForCollateral(Id collateralId) {
        return null;
    }
    @RemoteAction
    global static List<Map<String,Object>> getDocuments(Id objectId) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI__Legal_Entities__c> getLegalEntities(Id id) {
        return null;
    }
    @RemoteAction
    global static String getNamespacePrefix() {
        return null;
    }
    @RemoteAction
    global static List<SObject> getPortalDocuments(Id objectId) {
        return null;
    }
    @RemoteAction
    global static List<Map<String,String>> getUnmatchedAttachments(Id associatedObjectId) {
        return null;
    }
    @RemoteAction
    global static void hardDeleteDocs(List<String> docIds) {

    }
    @RemoteAction
    global static List<Map<String,Object>> importSelectedCollateralDocs(Id loanId, Map<Id,Map<String,Id>> selectedDocs) {
        return null;
    }
    @RemoteAction
    global static List<Map<String,Object>> importSelectedRelationshipDocs(Id loanId, Map<Id,Map<String,Id>> selectedDocs) {
        return null;
    }
    @RemoteAction
    global static void initializeDocTabFromDefaultChecklists(Id objectId, Id docTabId) {

    }
    @RemoteAction
    global static void initializeFromDefaultChecklists(Id objectId) {

    }
    @RemoteAction
    global static void initializeIfNeeded(Id objectId) {

    }
    @RemoteAction
    global static List<Map<String,Object>> rejectPortalDocument(Id objectId, Id docId, String reason) {
        return null;
    }
    @RemoteAction
    global static void removePortalAttachment(Id documentId, Id docStoreIndexId) {

    }
    @RemoteAction
    global static void removeUnmatchedDocument(Id documentId) {

    }
    @RemoteAction
    global static void resetDocType(Id objectId, Id docTabId, Id docTypeId) {

    }
    @RemoteAction
    global static Set<Map<String,Object>> retrieveExternalDocumentIds(Id objectId, String response, String params) {
        return null;
    }
    @RemoteAction
    global static Map<String,String> retrieveMimeTypeShort() {
        return null;
    }
    @RemoteAction
    global static String retrieveTIN(Id objectId) {
        return null;
    }
    @RemoteAction
    global static void saveUserPreferences(String name, String columns) {

    }
    @RemoteAction
    global static List<Map<String,Object>> setAttachmentUsingDocument(Id associatedObjectId, Id targetDocumentId, Id sourceDocumentId) {
        return null;
    }
    @RemoteAction
    global static void setDocumentName(Id documentId, String documentName, String year, String legalEntity) {

    }
    @RemoteAction
    global static List<Map<String,Object>> undeleteDocs(Id objectId, List<Id> docIds) {
        return null;
    }
    @RemoteAction
    global static List<Map<String,Object>> undeleteTrashDocument(Id associatedObjectId, Id documentId) {
        return null;
    }
    @RemoteAction
    global static List<Map<String,Object>> updateClosingDocument(Map<String,Object> closingDocumentInfo, Id associatedObjectId) {
        return null;
    }
    @RemoteAction
    global static void updateDescription(String docId, String description) {

    }
    global static void updateDocumentStoreForExternalFile(Id docStoreId, String storageType, String lookupKey, String externalId, Boolean isDeleted) {

    }
    @RemoteAction
    global static Set<Map<String,Object>> updateExternalFileId(String objectId, Id documentId, String externalId) {
        return null;
    }
    @RemoteAction
    global static Set<Map<String,Object>> updateMetadataExternalFile(Id objectId, String fileWrapper) {
        return null;
    }
    @RemoteAction
    global static Set<Map<String,Object>> updateOfflineFileDescription(String objectId, Id documentId, String description) {
        return null;
    }
    @RemoteAction
    global static List<Map<String,Object>> updatePortalDescription(String objectId, String docId, String description) {
        return null;
    }
    @RemoteAction
    global static List<Map<String,Object>> updatePortalName(String objectId, String docId, String name) {
        return null;
    }
global class XDocumentsException extends Exception {
}
}

/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class UniversalDocManController {
    global UniversalDocManController() {

    }
    @RemoteAction
    global static void addChatterComment(Id placeholderId, String comment) {

    }
    @RemoteAction
    global static void archiveExistingDocument(Id contextObjectId, Id placeholderId, Id fileId) {

    }
    @RemoteAction
    global static void archivePlaceholderFromFileStaging(Id contextObjectId, Id placeholderId) {

    }
    @RemoteAction
    global static void archivePlaceholdersFromFileStaging(Id contextObjectId, List<Id> placeholderIds) {

    }
    @RemoteAction
    global static Set<Id> cancelSignatureCollection(Id collectionId) {
        return null;
    }
    @RemoteAction
    global static Map<String,Object> configureContextObject(Id contextObjectId) {
        return null;
    }
    @RemoteAction
    global static Boolean contextObjectTypeIsLoan(Id contextObjectId) {
        return null;
    }
    @RemoteAction
    global static String createCollection(List<String> storeIdStrings) {
        return null;
    }
    global static Object createDocumentStorageMetadata(Id contentVerisonId, Id placeholderId) {
        return null;
    }
    @RemoteAction
    global static Object createDocumentStorageMetadata(Id contentVerisonId, Id placeholderId, Id docStore) {
        return null;
    }
    global static Object createDocumentStorageMetadata(Id contentVerisonId, Id placeholderId, String additionalProperties) {
        return null;
    }
    @RemoteAction
    global static Object createDocumentStorageMetadataWithAdditionalParameters(Id contentVersionId, Id placeholderId, Id docStoreId, String additionalProperties) {
        return null;
    }
    @RemoteAction
    global static List<NDOC.IUniversalDocument> createFileStagingPlaceholder(Id contextObjectId) {
        return null;
    }
    @RemoteAction
    global static void deletePlaceholder(Id contextObjectId, Id placeholderId) {

    }
    @RemoteAction
    global static void deletePlaceholderIndex(Id contextObjectId, Id placeholderId) {

    }
    @RemoteAction
    global static NDOC.IUniversalDocument duplicatePlaceholder(Id contextObjectId, Id placeholderId) {
        return null;
    }
    @RemoteAction
    global static Set<Id> getCollectionIds(List<String> storeIdStrings) {
        return null;
    }
    @RemoteAction
    global static ContentDocumentLink getContentDocumentLink(Id documentStoreId) {
        return null;
    }
    @RemoteAction
    global static List<ContentDocumentLink> getContentDocumentLinks(List<Id> documentStoreIds) {
        return null;
    }
    @RemoteAction
    global static List<NDOC.ContentVersionHistory> getContentVersionHistory(Id placeholderId) {
        return null;
    }
    @RemoteAction
    global static String getNamespacePrefix() {
        return null;
    }
    @RemoteAction
    global static String getUserRoleName() {
        return null;
    }
    @RemoteAction
    global static Boolean isDocStoreShared(Id docStoreId) {
        return null;
    }
    @RemoteAction
    global static Object linkRelationshipDocument(Id docStoreId, Id placeholderId) {
        return null;
    }
    @RemoteAction
    global static Object linkRelationshipDocuments(Id docStoreId, Id placeholderId, Boolean isImported) {
        return null;
    }
    @RemoteAction
    global static Object linkRelationshipDocumentsWithAddtionalProperties(Id sourceDocStoreId, Id targetPlaceholderId, Boolean isImported, String additionalProperties) {
        return null;
    }
    global static List<Object> removeFileFromPlaceholder(Id contextObjectId, Id placeholderId) {
        return null;
    }
    global static void removeFileFromPlaceholders(Id contextObjectId, List<Id> placeholderIds) {

    }
    @RemoteAction
    global static List<Object> removeFilesFromPlaceholders(Id contextObjectId, List<Id> placeholderIds) {
        return null;
    }
    @RemoteAction
    global static void renameMultipleContentDocuments(Map<Id,String> placeholderList) {

    }
    @RemoteAction
    global static List<NDOC.IUniversalDocument> retrieveArchivedDocumentsWithAttachments(Id contextObjectId) {
        return null;
    }
    @RemoteAction
    global static List<NDOC.ChatterComment> retrieveChatterComments(Id placeholderId) {
        return null;
    }
    @RemoteAction
    global static String retrieveConfigurableColumns(String contextObjectType) {
        return null;
    }
    @RemoteAction
    global static List<NDOC.IUniversalDocument> retrieveDocumentsWithAttachments(Id contextObjectId) {
        return null;
    }
    @RemoteAction
    global static List<NDOC.IUniversalDocument> retrieveDocumentsWithoutSharing(Id contextObjectId) {
        return null;
    }
    @RemoteAction
    global static List<NDOC.IUniversalDocument> retrieveDocuments(Id contextObjectId) {
        return null;
    }
    @RemoteAction
    global static List<NDOC.IUniversalDocument> retrieveFileStagingPlaceholders(Id contextObjectId) {
        return null;
    }
    @RemoteAction
    global static List<NDOC.LegalEntity> retrieveLegalEntities(Id contextObjectId) {
        return null;
    }
    global static List<NDOC.ProductPackageProduct> retrieveProductsFromProductPackage(Id contextObjectId) {
        return null;
    }
    @RemoteAction
    global static String retrieveSystemProperty(String category, String key) {
        return null;
    }
    @RemoteAction
    global static Boolean retrieveSystemPropertyAsBoolean(String category, String key) {
        return null;
    }
    @RemoteAction
    global static List<PermissionSetAssignment> retrieveUserAssignedPermissions() {
        return null;
    }
    @RemoteAction
    global static void savePortalRejectionReasons(Id contextObjectId, Id placeholderId, Map<String,String> reasons) {

    }
    @RemoteAction
    global static String sendCollectionForSignature(Id collectionId) {
        return null;
    }
    @RemoteAction
    global static void updateAccountOnPlaceholder(Id placeholderId, Id accountId, Id contextObjectId) {

    }
    @RemoteAction
    global static void updateFileTitle(Id fileId, String fileName, Boolean isContent) {

    }
    @RemoteAction
    global static void updatePlaceholderFields(Id contextObjectId, Id sourcePlaceholder, Id targetPlaceholder) {

    }
}

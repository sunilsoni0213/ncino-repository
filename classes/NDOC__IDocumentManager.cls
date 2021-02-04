/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface IDocumentManager {
    void copyDocumentFields(Id param0, Id param1);
    void createClosingDocuments(List<Id> param0, Id param1);
    Id createDocument(String param0, Id param1, Id param2, String param3, String param4, String param5, String param6);
    LLC_BI__Document_Store_Index__c createDocumentStoreandIndex(Id param0);
    Id getAssociatedObjectId();
    Id getAttachmentParentId(Id param0);
    List<SObject> getClosingDocuments();
    List<SObject> getClosingDocuments(List<Id> param0);
    List<LLC_BI__DocTab__c> getDocTabs();
    List<LLC_BI__DocType__c> getDocTypes();
    SObject getDocumentById(Id param0);
    LLC_BI__DocManager__c getDocumentManager();
    Id getDocumentStoreIdForDocument(Id param0);
    Map<Id,Id> getDocumentStoreIdsForDocuments(List<Id> param0);
    List<SObject> getDocumentsById(List<Id> param0);
    String getDocumentsObjectType();
    List<SObject> getDocumentsWithAttachmentsById(List<Id> param0, Boolean param1);
    List<SObject> getDocuments();
    List<SObject> getDocuments(List<Id> param0);
    List<SObject> getDocuments(List<Id> param0, Id param1);
    void setDocumentFieldsFromAttachment(Id param0, Attachment param1);
}

/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface IDocumentStore {
    Boolean deleteDocument(nPortal.PortalLifeCycleDocument param0);
    List<String> getAllowedFileExtensions();
    List<nPortal.PortalLifeCycleDocument> getDocuments(Id param0);
    Schema.SObjectType getUploadSObjectType();
    nPortal.PortalLifeCycleDocument handleUploadFailure(nPortal.PortalLifeCycleDocument param0);
    nPortal.PortalLifeCycleDocument initializeUpload(nPortal.PortalLifeCycleDocument param0);
    nPortal.PortalLifeCycleDocument uploadDocument(nPortal.PortalLifeCycleDocument param0);
}

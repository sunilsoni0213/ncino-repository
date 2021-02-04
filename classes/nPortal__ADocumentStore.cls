/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class ADocumentStore {
    global ADocumentStore() {

    }
    global abstract Boolean deleteDocument(Id param0, nPortal.PortalLifeCycleDocument param1);
    global abstract List<String> getAllowedFileExtensions();
    global abstract List<nPortal.PortalLifeCycleDocument> getDocuments(Id param0);
    global abstract Schema.SObjectType getUploadSObjectType();
    global abstract nPortal.PortalLifeCycleDocument handleUploadFailure(Id param0, nPortal.PortalLifeCycleDocument param1);
    global abstract nPortal.PortalLifeCycleDocument initializeUpload(Id param0, nPortal.PortalLifeCycleDocument param1);
    global abstract void submitDocuments(Id param0, List<Id> param1);
    global abstract nPortal.PortalLifeCycleDocument uploadDocument(Id param0, nPortal.PortalLifeCycleDocument param1);
}

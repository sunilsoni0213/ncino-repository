/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class AScreenViewConverter {
    global static String KEY_EDIT;
    global static Map<String,String> KEY_FIELDS;
    global static String KEY_PREVIEW;
    global static String KEY_READ_ONLY;
    global AScreenViewConverter() {

    }
    global virtual nDESIGN__View__c convertDocumentsToView(Map<String,Document> documents) {
        return null;
    }
    global virtual Map<String,Document> convertViewToDocuments(nDESIGN__View__c view, String name) {
        return null;
    }
    global virtual Document createDocument() {
        return null;
    }
    global virtual Id getFolderId() {
        return null;
    }
    global abstract String getFolderName();
    global virtual String getNamespacePrefix() {
        return null;
    }
    global abstract System.Type getType();
    global virtual String replaceNamespaceWithPlaceholder(String content) {
        return null;
    }
    global virtual String replacePlaceholderWithNamespace(String content) {
        return null;
    }
    global void setFolderId(Id folderId) {

    }
    global void setNamespacePrefix(String namespacePrefix) {

    }
global class XScreenViewConverterException extends Exception {
}
}

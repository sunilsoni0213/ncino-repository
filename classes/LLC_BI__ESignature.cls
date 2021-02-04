/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ESignature {
    global static void deregisterImplementation() {

    }
    global static LLC_BI.ESignature.AESignature getInstance() {
        return null;
    }
    global static void registerImplementation(System.Type beanType) {

    }
global abstract class AESignature {
    global AESignature() {

    }
    global virtual String sendAddDocument(String pluginName, String pluginVersion, Id documentCollectionIndex, Map<String,Object> properties) {
        return null;
    }
    global virtual void sendCancelCollectionTransaction(Id collectionId) {

    }
    global virtual void sendCancelCollectionTransaction(Id collectionId, Map<String,Object> properties) {

    }
    global abstract void sendCollection(String param0, String param1, Id param2);
    global virtual String sendCollectionTransaction(String pluginName, String pluginVersion, Id collectionId) {
        return null;
    }
    global virtual String sendCollectionTransaction(String pluginName, String pluginVersion, Id collectionId, Map<String,Object> properties) {
        return null;
    }
    global virtual String sendCreateCollection(String pluginName, String pluginVersion, Id documentCollectionId, Id contextId, Map<String,Object> properties) {
        return null;
    }
    global virtual String sendGetTaggingUrl(String pluginName, String pluginVersion, Id documentCollectionId, Map<String,Object> properties) {
        return null;
    }
    global virtual String sendRetrieveCollectionMetadata(String pluginName, String pluginVersion, Id documentCollectionId, Map<String,Object> properties) {
        return null;
    }
}
}

/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class AXmlResponse {
    global dom.Document getResponseDocument() {
        return null;
    }
    global abstract Map<String,Map<String,String>> getResponseMap();
    global virtual Map<String,String> getSpecialElements() {
        return null;
    }
    global virtual dom.Document loadDomDocument(String xml) {
        return null;
    }
    global void parseResponse() {

    }
    global virtual void processData(Schema.FieldSet fs, SObject obj) {

    }
}

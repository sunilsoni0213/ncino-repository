/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class ADocmanService {
    global ADocmanService() {

    }
    global abstract SObject createDocumentPlaceholder(Id param0, Id param1);
    global virtual List<LLC_BI.IDocmanDocument> getDocuments(Id contextId) {
        return null;
    }
    global abstract void linkContentWithPlaceholder(Id param0, Id param1);
}

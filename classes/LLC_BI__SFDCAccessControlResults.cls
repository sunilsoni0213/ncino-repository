/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class SFDCAccessControlResults {
    global SFDCAccessControlResults() {

    }
global class AccessControlResultsException extends Exception {
}
global class DeleteResults extends LLC_BI.SFDCAccessControlResults {
    global DeleteResults(List<Database.DeleteResult> p1) {

    }
    global List<Database.DeleteResult> getResults() {
        return null;
    }
    global Boolean wasSuccessful() {
        return null;
    }
}
global class InsertResults extends LLC_BI.SFDCAccessControlResults {
    global InsertResults(List<SObject> p1, List<Database.SaveResult> p2) {

    }
    global List<SObject> getInsertedObjects() {
        return null;
    }
    global List<Database.SaveResult> getResults() {
        return null;
    }
    global Boolean wasSuccessful() {
        return null;
    }
}
global class UpdateResults extends LLC_BI.SFDCAccessControlResults {
    global UpdateResults(List<SObject> p1, List<Database.SaveResult> p2) {

    }
    global List<Database.SaveResult> getResults() {
        return null;
    }
    global List<SObject> getUpdatedObjects() {
        return null;
    }
    global Boolean wasSuccessful() {
        return null;
    }
}
}

/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class AForce implements nFORCE.IForce {
    global AForce() {

    }
    global virtual String getApexType() {
        return null;
    }
    global virtual SObject getDbObject() {
        return null;
    }
    global Id getId() {
        return null;
    }
    global String getName() {
        return null;
    }
    global abstract Schema.SObjectType getSObjectType();
    global virtual System.Type getType() {
        return null;
    }
    global Boolean isNew() {
        return null;
    }
    global virtual Boolean isSaved() {
        return null;
    }
    global virtual void mapFromDb() {

    }
    global virtual void mapFromDb(SObject obj) {

    }
    global virtual void mapToDb() {

    }
    global virtual void mapToDb(SObject obj) {

    }
    global virtual nFORCE.IForce newRecord() {
        return null;
    }
    global virtual void saveRecord() {

    }
    global virtual void setDbObject(SObject dbObject) {

    }
    global void setId(Id id) {

    }
    global void setName(String name) {

    }
global class XForceTypeNotImplementedException extends Exception {
}
}

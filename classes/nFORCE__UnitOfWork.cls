/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class UnitOfWork {
    global UnitOfWork() {

    }
    global UnitOfWork(List<Schema.SObjectType> supportedTypes) {

    }
    global UnitOfWork(nFORCE.APersistenceStrategy persistStrategy) {

    }
    global virtual void commitWork() {

    }
    global virtual void registerDirty(SObject record) {

    }
    global virtual void registerDirty(List<SObject> records) {

    }
    global virtual void registerNew(SObject record) {

    }
    global virtual void registerNew(List<SObject> records) {

    }
    global virtual void registerRelationship(SObject record, Schema.SObjectField recordField, SObject relatedTo) {

    }
    global virtual void registerRelationship(SObject record, Schema.SObjectField recordField, SObject relatedTo, Schema.SObjectField relatedToField) {

    }
    global virtual void registerRelationships(List<SObject> records, Schema.SObjectField recordField, SObject relatedTo) {

    }
    global virtual void registerRemove(SObject record) {

    }
    global virtual void registerRemove(List<SObject> records) {

    }
}

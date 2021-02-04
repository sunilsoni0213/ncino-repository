/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class APersistenceStrategy {
    global virtual void commitWork() {

    }
    global abstract System.Type getType();
    global abstract void performPersist();
    global abstract void registerDirty(SObject param0);
    global abstract void registerNew(SObject param0);
    global abstract void registerRelationship(SObject param0, Schema.SObjectField param1, SObject param2, Schema.SObjectField param3);
    global abstract void registerRemove(SObject param0);
}

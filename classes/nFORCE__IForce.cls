/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface IForce {
    SObject getDbObject();
    Id getId();
    String getName();
    Schema.SObjectType getSObjectType();
    System.Type getType();
    void mapFromDb();
    void mapToDb();
    nFORCE.IForce newRecord();
    void saveRecord();
    void setDbObject(SObject param0);
    void setId(Id param0);
    void setName(String param0);
}

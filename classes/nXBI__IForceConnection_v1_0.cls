/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface IForceConnection_v1_0 extends LLC_BI.IForce {
    nXBI.IForceRelationship_v1_0 getConnectedFrom();
    nXBI.IForceRelationship_v1_0 getConnectedTo();
    String getConnectedToStatus();
    String getConnectedToType();
    nXBI.IForceConnectionRole_v1_0 getConnectionRole();
    String getDescription();
    String getUid();
    void setConnectedFrom(nXBI.IForceRelationship_v1_0 param0);
    void setConnectedTo(nXBI.IForceRelationship_v1_0 param0);
    void setConnectionRole(nXBI.IForceConnectionRole_v1_0 param0);
    void setDescription(String param0);
    void setUid(String param0);
}

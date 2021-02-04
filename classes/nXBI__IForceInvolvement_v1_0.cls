/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface IForceInvolvement_v1_0 extends LLC_BI.IForce {
    String getBorrowerType();
    Decimal getContingentPercentage();
    String getContingentType();
    nXBI.IForceRelationship_v1_0 getRelationship();
    List<nXBI.IForceSigner_v1_0> getSigners();
    Boolean isBorrower();
    Boolean isCoborrower();
    Boolean isGuarantor();
    Boolean isRelatedEntity();
    void setBorrowerType(String param0);
    void setContingentPercentage(Decimal param0);
    void setContingentType(String param0);
    void setIsBorrower(Boolean param0);
    void setIsCoborrower(Boolean param0);
    void setIsGuarantor(Boolean param0);
    void setIsRelatedEntity(Boolean param0);
    void setRelationship(nXBI.IForceRelationship_v1_0 param0);
    void setSigners(List<nXBI.IForceSigner_v1_0> param0);
}

/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface ILifeCycleInvolvement extends LLC_BI.IForce {
    Decimal getContingentPercentage();
    String getContingentType();
    LLC_BI.ILifeCycleLoan getLoan();
    LLC_BI.ILifeCycleRelationship getRelationship();
    List<LLC_BI.ILifeCycleSigner> getSigners();
    Boolean isCo();
}

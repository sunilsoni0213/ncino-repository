/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface ILifeCycleLoan extends LLC_BI.IForce {
    Decimal getAmount();
    List<LLC_BI.ILifeCycleBorrower> getBorrowers();
    List<LLC_BI.ILifeCycleGuarantor> getGuarantors();
    LLC_BI.ILifeCycleRelationship getRelationship();
}

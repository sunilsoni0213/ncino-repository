/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface ILifeCycleContact extends LLC_BI.IForce {
    Long getBirthDate();
    String getFirstName();
    String getLastName();
    String getMiddleName();
    LLC_BI.ILifeCycleRelationship getRelationship();
    String getSSN();
    List<LLC_BI.ILifeCycleSigner> getSignings();
}

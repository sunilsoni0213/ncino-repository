/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface ILifeCycleRelationship extends LLC_BI.ILifeCycleSearchable {
    LLC_BI.ILifeCycleAddress getBillingAddress();
    List<LLC_BI.ILifeCycleContact> getContacts();
    List<String> getCountryOptions();
    String getEntityType();
    List<String> getEntityTypeOptions();
    List<LLC_BI.ILifeCycleInvolvement> getInvolvements();
    List<LLC_BI.ILifeCycleLoan> getLoans();
    LLC_BI.ILifeCycleRelationship getParent();
    LLC_BI.ILifeCycleAddress getShippingAddress();
    List<String> getStateOptions();
    String getTaxIdentificationNumber();
    Boolean hasParent();
    Boolean isIndividual();
}

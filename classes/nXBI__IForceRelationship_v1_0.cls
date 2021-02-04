/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface IForceRelationship_v1_0 extends LLC_BI.IForce {
    nXBI.IForcePhysicalAddress_v1_0 getBillingAddress();
    List<nXBI.IForceContact_v1_0> getContacts();
    List<nXBI.IBusinessCreditReport_v1_0> getCreditReports();
    String getEntityType();
    String getFax();
    Integer getFicoScore();
    Long getFicoTimestamp();
    String getPartnershipType();
    String getPhone();
    nXBI.IForceContact_v1_0 getPrimaryContact();
    nXBI.IForcePhysicalAddress_v1_0 getShippingAddress();
    String getTaxIdentificationNumber();
    String getWebsite();
    Boolean isIndividual();
    void setBillingAddress(nXBI.IForcePhysicalAddress_v1_0 param0);
    void setContacts(List<nXBI.IForceContact_v1_0> param0);
    void setCreditReports(List<nXBI.IBusinessCreditReport_v1_0> param0);
    void setEntityType(String param0);
    void setFax(String param0);
    void setFicoScore(Integer param0);
    void setFicoTimestamp(Long param0);
    void setIsIndividual(Boolean param0);
    void setPartnershipType(String param0);
    void setPhone(String param0);
    void setPrimaryContact(nXBI.IForceContact_v1_0 param0);
    void setShippingAddress(nXBI.IForcePhysicalAddress_v1_0 param0);
    void setTaxIdentificationNumber(String param0);
    void setWebsite(String param0);
}

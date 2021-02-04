/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface IBusinessCreditReport_v1_0 extends LLC_BI.IForce {
    List<nXBI.IBusinessCreditAlert_v1_0> getAlerts();
    List<nXBI.IBusinessCreditBankruptcyInfo_v1_0> getBankruptcyInfo();
    List<nXBI.IBusinessCreditDemographics_v1_0> getBusinessDemographics();
    List<nXBI.IBusinessCreditBusinessInfo_v1_0> getBusinessInfo();
    String getCreditBureauId();
    String getCreditBureauName();
    String getCustomerNumber();
    List<nXBI.IBusinessCreditDaysBeyondTerms_v1_0> getDaysBeyondTerms();
    Long getFileCreationDate();
    List<nXBI.IBusinessCreditScore_v1_0> getScore();
    void setAlerts(List<nXBI.IBusinessCreditAlert_v1_0> param0);
    void setBankruptcyInfo(List<nXBI.IBusinessCreditBankruptcyInfo_v1_0> param0);
    void setBusinessDemographics(List<nXBI.IBusinessCreditDemographics_v1_0> param0);
    void setBusinessInfo(List<nXBI.IBusinessCreditBusinessInfo_v1_0> param0);
    void setCreditBureauId(String param0);
    void setCreditBureauName(String param0);
    void setCustomerNumber(String param0);
    void setDaysBeyondTerms(List<nXBI.IBusinessCreditDaysBeyondTerms_v1_0> param0);
    void setFileCreationDate(Long param0);
    void setScore(List<nXBI.IBusinessCreditScore_v1_0> param0);
}

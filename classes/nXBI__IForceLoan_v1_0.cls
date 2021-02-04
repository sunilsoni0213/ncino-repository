/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface IForceLoan_v1_0 extends LLC_BI.IForce {
    Integer getAmortizedTermMonths();
    Decimal getAmount();
    Decimal getBalloonPayment();
    String getBranchId();
    String getCIFNumber();
    Long getCloseTimestamp();
    List<nXBI.IForceCollateral_v1_0> getCollateral();
    Decimal getInterestRate();
    String getInterestRateAdjustmentFrequency();
    List<nXBI.IForceInvolvement_v1_0> getInvolvements();
    String getLoanNumber();
    Long getMaturityTimestamp();
    Decimal getMonthlyPayment();
    Long getNextInterestPaymentTimestamp();
    Long getNextPaymentDueTimestamp();
    String getOfficerComments();
    String getOfficerName();
    String getPaymentSchedule();
    String getPaymentType();
    String getPricingBasis();
    String getProductName();
    String getPurpose();
    Decimal getRateCeiling();
    Decimal getRateFloor();
    nXBI.IForceRelationship_v1_0 getRelationship();
    List<nXBI.IForceRenewedLoan_v1_0> getRenewedLoans();
    Decimal getSpread();
    String getStatus();
    Integer getTermMonths();
    Decimal getTotalMonthlyPayment();
    String getTypeCode();
    Long getWireTimestamp();
    Boolean isBalloon();
    void setAmortizedTermMonths(Integer param0);
    void setAmount(Decimal param0);
    void setBalloonPayment(Decimal param0);
    void setBranchId(String param0);
    void setCIFNumber(String param0);
    void setCloseTimestamp(Long param0);
    void setCollateral(List<nXBI.IForceCollateral_v1_0> param0);
    void setInterestRate(Decimal param0);
    void setInterestRateAdjustmentFrequency(String param0);
    void setInvolvements(List<nXBI.IForceInvolvement_v1_0> param0);
    void setIsBalloon(Boolean param0);
    void setLoanNumber(String param0);
    void setMaturityTimestamp(Long param0);
    void setMonthlyPayment(Decimal param0);
    void setNextInterestPaymentTimestamp(Long param0);
    void setNextPaymentDueTimestamp(Long param0);
    void setOfficerComments(String param0);
    void setOfficerName(String param0);
    void setPaymentSchedule(String param0);
    void setPaymentType(String param0);
    void setPricingBasis(String param0);
    void setProductName(String param0);
    void setPurpose(String param0);
    void setRateCeiling(Decimal param0);
    void setRateFloor(Decimal param0);
    void setRelationship(nXBI.IForceRelationship_v1_0 param0);
    void setRenewedLoans(List<nXBI.IForceRenewedLoan_v1_0> param0);
    void setSpread(Decimal param0);
    void setStatus(String param0);
    void setTermMonths(Integer param0);
    void setTotalMonthlyPayment(Decimal param0);
    void setTypeCode(String param0);
    void setWireTimestamp(Long param0);
}

/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class DebtSchedule {
    global DebtSchedule(Account relationship, LLC_BI__Loan__c underwritingLoan, LLC_BI__Underwriting_Summary__c underwritingSummary, LLC_BI.DebtSchedule.DebtScheduleContainer container) {

    }
    global List<LLC_BI__Legal_Entities__c> getGuarantors() {
        return null;
    }
    global void loadDebtSchedule() {

    }
global class DebtScheduleContainer {
    global Boolean canBeLocked {
        get;
        set;
    }
    global List<LLC_BI.DebtSchedule.LoanInformation> creditFacilities {
        get;
        set;
    }
    global String creditFacilitiesLabel;
    global List<String> creditFacilitiesLabels;
    global List<LLC_BI.DebtSchedule.LoanInformation> indirectDebt {
        get;
        set;
    }
    global String indirectDebtLabel;
    global List<String> indirectDebtLabels;
    global Boolean isLoaded {
        get;
        set;
    }
    global Boolean isLocked {
        get;
        set;
    }
    global String lockedByUser {
        get;
        set;
    }
    global Datetime lockedDate {
        get;
        set;
    }
    global String name {
        get;
        set;
    }
    global List<LLC_BI.DebtSchedule.LoanInformation> otherObligations {
        get;
        set;
    }
    global String otherObligationsLabel;
    global List<String> otherObligationsLabels;
    global String participationsLabel;
    global String payoffsLabel;
    global List<LLC_BI.DebtSchedule.LoanInformation> proposedLoans {
        get;
        set;
    }
    global String proposedLoansLabel;
    global List<String> proposedLoansLabels;
    global Boolean showFootnotes {
        get;
        set;
    }
    global DebtScheduleContainer() {

    }
    global void disableAllLoans() {

    }
    global void disableLoans(List<LLC_BI.DebtSchedule.LoanInformation> loans) {

    }
    global void mergeContainer(LLC_BI.DebtSchedule.DebtScheduleContainer container) {

    }
}
global class EntityContainer {
    global EntityContainer(LLC_BI__Loan__c loan, LLC_BI__Legal_Entities__c entity) {

    }
}
global class LoanInformation {
    global String commentInput {
        get;
        set;
    }
    global List<LLC_BI.DebtComment> comments {
        get;
        set;
    }
    global List<LLC_BI.ALifeCycleComment> dsComments {
        get;
        set;
    }
    global String institution {
        get;
        set;
    }
    global Boolean isOveridden {
        get;
        set;
    }
    global Boolean isRemoved {
        get;
        set;
    }
    global Id loanId {
        get;
        set;
    }
    global String loanNr {
        get;
        set;
    }
    global Datetime maturityDate {
        get;
        set;
    }
    global Long maturityDateLong {
        get;
        set;
    }
    global String maturityDateStr {
        get;
        set;
    }
    global String name {
        get;
        set;
    }
    global Decimal originalAmount {
        get;
        set;
    }
    global Decimal ownershipPercentage {
        get;
        set;
    }
    global Decimal participatedAmount {
        get;
        set;
    }
    global String participatedEntity {
        get;
        set;
    }
    global Decimal paymentAmount {
        get;
        set;
    }
    global String paymentFrequency {
        get;
        set;
    }
    global Integer payments {
        get;
        set;
    }
    global Decimal payoffAmount {
        get;
        set;
    }
    global Decimal principalAmount {
        get;
        set;
    }
    global String product {
        get;
        set;
    }
    global Decimal proposedPaymentAmount {
        get;
        set;
    }
    global Decimal rate {
        get;
        set;
    }
    global String relationshipId {
        get;
        set;
    }
    global String relationshipName {
        get;
        set;
    }
    global String source {
        get;
        set;
    }
    global Decimal unfundedAmount {
        get;
        set;
    }
    global LoanInformation() {

    }
}
}

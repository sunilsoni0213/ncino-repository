/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class csaTestDataFactory {
    global csaTestDataFactory() {

    }
    global static Account createAccount(String type) {
        return null;
    }
    global static LLC_BI__Account_Covenant__c createAccountCovenant(Id covenantId, Id acctId) {
        return null;
    }
    global static Account createAccountWithFields(String type, Map<String,Object> fieldValues) {
        return null;
    }
    global static void createApprovalProcessWorkflow(User testUser, SObject testRecord) {

    }
    global static LLC_BI__ClosingChecklist__c createClosingChecklist(Id docManId, Id docTypeId, Id docClassId) {
        return null;
    }
    global static LLC_BI__Collateral__c createCollateral(Id collateralTypeId) {
        return null;
    }
    global static LLC_BI__Account_Collateral__c createCollateralOwnership(Id collateralId, Id acctId) {
        return null;
    }
    global static LLC_BI__Loan_Collateral2__c createCollateralPledged(Id collateralId, Id loanId, Id loanCollateralAggId) {
        return null;
    }
    global static void createCollateralStructure(Id loanId, Id acctId) {

    }
    global static LLC_BI__Collateral_Type__c createCollateralType() {
        return null;
    }
    global static Contact createContact(Id acctId) {
        return null;
    }
    global static Contact createContactWithFields(Id acctId, Map<String,Object> fieldValues) {
        return null;
    }
    global static LLC_BI__Covenant2__c createCovenant(Id covenantTypeId) {
        return null;
    }
    global static void createCovenantStructure(Id loanId, Id acctId) {

    }
    global static LLC_BI__Covenant_Type__c createCovenantType() {
        return null;
    }
    global static LLC_BI__Credit_Memo__c createCreditMemo(Id screenId, String type) {
        return null;
    }
    global static void createCreditMemoStruture(String type, String sectionResource) {

    }
    global static LLC_BI__DocClass__c createDocClass(Id docManId, Id docTypeId) {
        return null;
    }
    global static LLC_BI__DocManager__c createDocManager(String type) {
        return null;
    }
    global static LLC_BI__DocType__c createDocType(Id docManId) {
        return null;
    }
    global static void createDocumentManagerStructure(String type) {

    }
    global static LLC_BI__Entity_Compliance__c createEntityCompliance(Id acctId, Map<String,Object> fieldValues) {
        return null;
    }
    global static nFORCE__System_Properties__c createForceSystemProperty(String category, String key, String value, Boolean active, String description) {
        return null;
    }
    global static nFORCE__Group__c createGroup(String app) {
        return null;
    }
    global static LLC_BI__Legal_Entities__c createLegalEntity(Id acctId, Id loanId, Id ppId, String borrowerType) {
        return null;
    }
    global static LLC_BI__Legal_Entities__c createLegalEntityWithFields(Id acctId, Id loanId, Id ppId, String borrowerType, Map<String,Object> fieldValues) {
        return null;
    }
    global static LLC_BI__Loan__c createLoan(Id acctId, Id ppId, Id productId) {
        return null;
    }
    global static void createLoanBaseStructure() {

    }
    global static LLC_BI__Loan_Collateral_Aggregate__c createLoanCollateralAggregate() {
        return null;
    }
    global static LLC_BI__Loan_Compliance__c createLoanCompliance(Id loanId, Map<String,Object> fieldValues) {
        return null;
    }
    global static LLC_BI__Loan_Covenant__c createLoanCovenant(Id covenantId, Id loanId) {
        return null;
    }
    global static LLC_BI__Loan__c createLoanWithFields(Id acctId, Id ppId, Id productId, Map<String,Object> fieldValues) {
        return null;
    }
    global static LLC_BI__Pricing_Rate_Component__c createPricingRateComponent(Id pricingStreamId) {
        return null;
    }
    global static LLC_BI__Pricing_Stream__c createPricingStream(String recordId, Boolean isRate, Boolean isPayment) {
        return null;
    }
    global static LLC_BI__Product__c createProduct(String productName, Id productTypeId) {
        return null;
    }
    global static void createProductHierarchy() {

    }
    global static LLC_BI__Product_Line__c createProductLine() {
        return null;
    }
    global static LLC_BI__Product_Package__c createProductPackage(Id acctId) {
        return null;
    }
    global static void createProductPackageStructure() {

    }
    global static LLC_BI__Product_Package__c createProductPackageWithFields(Id acctId, Map<String,Object> fieldValues) {
        return null;
    }
    global static LLC_BI__Product_Type__c createProductType(Id productLineId) {
        return null;
    }
    global static void createRateAndPaymentStreams(Id loanId, Boolean isRate) {

    }
    global static LLC_BI__Role__c createRole(String name) {
        return null;
    }
    global static nFORCE__Route__c createRoute(Id screenId, String body, String app, String lookupKey) {
        return null;
    }
    global static nFORCE__Route_Group__c createRouteGroup(Decimal order, Id groupId, Id routeId, Id parentId) {
        return null;
    }
    global static nFORCE__Screen__c createScreen() {
        return null;
    }
    global static nFORCE__Screen_Section__c createScreenSection(Id screenId, Id widgetId, Id viewId, String sectionResource) {
        return null;
    }
    global static nFORCE__Section_Configuration__c createSectionConfiguration(Id screenSectionId) {
        return null;
    }
    global static User createUser(String username) {
        return null;
    }
    global static void createUserInterface() {

    }
    global static nFORCE__View__c createView() {
        return null;
    }
    global static nFORCE__Widget__c createWidget() {
        return null;
    }
    global static Id getSystemAdministrationUserProfileId() {
        return null;
    }
    global static LLC_BI__Loan__c updateLoan(Id loanId, Id loanCollateralAggId) {
        return null;
    }
}

/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class LoanApprovalController {
    global static String ADD_TEAM_MEMBERS_CATEGORY;
    global static String APP_PARAM;
    global static String APPROVAL_TEAM_MEMBERS_KEY;
    global String approvalPage {
        get;
        set;
    }
    global static String CONTINUE_MARK;
    global static String DUMMY_SOBJECT_USER_FIELD;
    global SObject dummySObject {
        get;
        set;
    }
    global String dummyUserField {
        get;
        set;
    }
    global static String EXCEPTION_MESSAGE;
    global static String GROUP_OBJECT_NAME;
    global static String ID_PARAM;
    global static String INDIVIDUAL_APPROVAL;
    global String ItemName {
        get;
        set;
    }
    global static String LOAN_APPROVER;
    global static String LOAN_APPROVER_QUEUE;
    global static String LOAN_APPROVERS_TEAM_MEMBERS_SETTING;
    global static String LOAN_PAGE;
    global static String LOAN_TEAM_VALUE;
    global static String MANUAL;
    global static String NEW_WORK_ITEM_IDS;
    global static String NEXT_APPROVER_IDS;
    global static String PRODUCT_PACKAGE_PAGE;
    global static String QUEUE;
    global static String QUEUE_APPROVAL;
    global String QueueName {
        get;
        set;
    }
    global static String SELECT_ONE;
    global static LLC_BI.SystemProperties SYSTEM_PROPERTIES;
    global static String USER;
    global static String USER_OBJECT_NAME;
    global String UserName {
        get;
        set;
    }
    global LoanApprovalController(Id objectId) {

    }
    global LoanApprovalController(ApexPages.StandardController controller) {

    }
    global void continueToApprovalProcess() {

    }
    global System.PageReference continueToApprovalWithManualUserId() {
        return null;
    }
    global LLC_BI__LoanTeam__c createLoanTeam(Id assigneeId, Id loanId, Id roleId) {
        return null;
    }
    global void createLoanTeamMembers(Id assigneeId) {

    }
    global void createRoles() {

    }
    global Map<Id,List<GroupMember>> getGroupMemberList(Id groupId) {
        return null;
    }
    global List<System.SelectOption> getItems() {
        return null;
    }
    global LLC_BI__Loan__c getLoan() {
        return null;
    }
    global System.PageReference getObjectPage() {
        return null;
    }
    global List<System.SelectOption> getQueues() {
        return null;
    }
    global Map<String,LLC_BI__Role__c> getRolesList() {
        return null;
    }
    global System.PageReference getUrlRedirect(Id redirectId) {
        return null;
    }
    global List<System.SelectOption> getUsers() {
        return null;
    }
    global System.PageReference returnToLoan() {
        return null;
    }
    global System.PageReference test() {
        return null;
    }
}

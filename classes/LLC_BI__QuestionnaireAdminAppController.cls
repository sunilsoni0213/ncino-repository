/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class QuestionnaireAdminAppController {
    @RemoteAction
    global static nFORCE__Group__c addGroup(nFORCE__Group__c newGroup) {
        return null;
    }
    @RemoteAction
    global static nFORCE__Option_Rule__c addNewRule(Id questionId, String condition, Id optionId, Id conditionalQuestionId) {
        return null;
    }
    @RemoteAction
    global static void addPicklistQuestion(nFORCE__Question__c question, String options) {

    }
    @RemoteAction
    global static nFORCE__Question__c addQuestion(nFORCE__Question__c question) {
        return null;
    }
    @RemoteAction
    global static nFORCE__Option_Rule__c addRule(String condition, Id optionId, Id questionId) {
        return null;
    }
    @RemoteAction
    global static nFORCE__Question__c archiveQuestion(nFORCE__Question__c question) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI.QuestionnaireAdminAppController.GroupList> getGroups() {
        return null;
    }
    @RemoteAction
    global static nFORCE.Question getQuestion(Id groupId, Id questionId) {
        return null;
    }
    @RemoteAction
    global static nFORCE.Questionnaire getQuestionnaire(Id groupId) {
        return null;
    }
    @RemoteAction
    global static void removeGroup(Id groupId) {

    }
    @RemoteAction
    global static void removeRule(Id ruleId) {

    }
    @RemoteAction
    global static void setQuestionOrder(List<nFORCE__Question__c> inQuestionOrder) {

    }
    @RemoteAction
    global static void updateGroupName(Id groupId, String name) {

    }
global class GroupList {
}
}

/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class RuleEngineAdminController {
    global RuleEngineAdminController() {

    }
    @RemoteAction
    global static List<nFORCE.RuleEngineAdminController.RuleInformation> deleteRuleEngineRule(Id ruleEngineRuleId) {
        return null;
    }
    @RemoteAction
    global static nFORCE.RuleEngineResult executeRule(String ruleName, Map<String,Object> inputParameters) {
        return null;
    }
    @RemoteAction
    global static String exportRuleEngineRuleVersion(String ruleEngineUniqueName, String externalVersionReference) {
        return null;
    }
    @RemoteAction
    global static void importRuleEngineRule(String ruleEngineUniqueName, String ruleName, String ruleContent) {

    }
    @RemoteAction
    global static void importRuleEngineRuleVersion(String ruleEngineUniqueName, String ruleName, String ruleContent, String version) {

    }
    @RemoteAction
    global static List<nFORCE.RuleEngineAdminController.ContextInformation> retrieveRuleEngineContextInformation() {
        return null;
    }
    @RemoteAction
    global static nFORCE.RuleEngineAdminController.RuleInformation retrieveRuleEngineRule(Id ruleEngineRuleId) {
        return null;
    }
    @RemoteAction
    global static List<nFORCE.RuleEngineAdminController.RuleInformation> retrieveRuleEngineRules() {
        return null;
    }
    @RemoteAction
    global static Map<String,nFORCE.RuleEngineAdminController.RuleEngineInfo> retrieveRuleEngines() {
        return null;
    }
    @RemoteAction
    global static List<nFORCE.RuleEngineAdminController.RuleInformation> upsertRuleEngineRule(nFORCE.RuleEngineAdminController.RuleInformation ruleEngineRule) {
        return null;
    }
global class ContextInformation {
    global ContextInformation() {

    }
}
global class ContextRuleInformation {
    global ContextRuleInformation() {

    }
}
global class RuleEngineInfo {
    global RuleEngineInfo() {

    }
}
global class RuleInformation {
}
}

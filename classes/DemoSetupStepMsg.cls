public with sharing class DemoSetupStepMsg {
    @AuraEnabled public Boolean active;
    @AuraEnabled public String automationClass;
    @AuraEnabled public String errorMessage;
    @AuraEnabled public Decimal stepDependsOn;
    @AuraEnabled public String stepDescription;
    @AuraEnabled public String stepHyperlink;
    @AuraEnabled public Decimal stepNumber;
    @AuraEnabled public String stepStatus;
    @AuraEnabled public String stepTitle;
    @AuraEnabled public String stepType;
    @AuraEnabled public String modalPath;

    public DemoSetupStepMsg(DemoSetupStep__mdt demoSetupStep, DemoSetupStatus__c demoSetupStatus) {
        this.active = demoSetupStep.Active__c;
        this.automationClass = demoSetupStep.AutomationClass__c;
        this.errorMessage = demoSetupStatus.ErrorMessage__c;
        this.stepDependsOn = demoSetupStep.StepDependsOn__c;
        this.stepDescription = demoSetupStep.StepDescription__c;
        this.stepHyperlink = demoSetupStep.StepHyperlink__c;
        this.stepNumber = demoSetupStep.StepNumber__c;
        this.stepStatus = demoSetupStatus.StepStatus__c;
        this.stepTitle = demoSetupStep.StepTitle__c;
        this.stepType = demoSetupStep.StepType__c;
        this.modalPath = demoSetupStep.ModalPath__c;
    }
}
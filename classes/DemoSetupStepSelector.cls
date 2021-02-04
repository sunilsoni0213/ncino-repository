/****************************************************************************************
Name            : DemoSetupStepSelector
Revision Log    : 2020-03-02 John Kuhl - CodeScience
                :
                :
Use             : Selector Class for DemoSetupStep__mdt Custom Metadata Type
****************************************************************************************/
public with sharing class DemoSetupStepSelector {
    
    /**
     * getActiveDemoSetupSteps
     *
     * Query for all active DemoSetupStep__mdt records
     *
     * @return demoSetupSteps
     **/    
    public static List<DemoSetupStep__mdt> getActiveDemoSetupSteps(){
        List<DemoSetupStep__mdt> demoSetupSteps = [SELECT Id,
                                                            Active__c,
                                                            AutomationClass__c,
                                                            StepDependsOn__c, 
                                                            StepDescription__c, 
                                                            StepHyperlink__c,
                                                            StepNumber__c,
                                                            StepTitle__c,
                                                            StepType__c,
                                                            ModalPath__c
                                                            FROM DemoSetupStep__mdt
                                                            WHERE Active__c = true
                                                            ORDER BY StepNumber__c];
        
        return demoSetupSteps;
    }

    /**
     * getActiveDemoSetupStep
     *
     * Query for an active DemoSetupStep__mdt record with specified Step Number
     *
     * @param stepNumber
     *
     * @return demoSetupSteps
     **/
    public static DemoSetupStep__mdt getActiveDemoSetupStep(Decimal stepNumber){
        List<DemoSetupStep__mdt> demoSetupSteps = [SELECT Id,
                                                            DeveloperName,
                                                            MasterLabel,
                                                            Active__c,
                                                            AutomationClass__c,
                                                            StepDependsOn__c, 
                                                            StepDescription__c, 
                                                            StepHyperlink__c,
                                                            StepNumber__c,
                                                            StepTitle__c,
                                                            StepType__c,
                                                            ModalPath__c
                                                            FROM DemoSetupStep__mdt
                                                            WHERE Active__c = true
                                                            AND StepNumber__c =: stepNumber];

        if(!demoSetupSteps.isEmpty() && demoSetupSteps.size() == 1){
            return demoSetupSteps[0];
        }else if(demoSetupSteps.size() > 1){
            throw new DemoSetupException('More than one step exists for this step number');
        }else{
            throw new DemoSetupException('There are no Active Demo Setup Steps matching this step number');
        }
    }

    /**
     * getActiveAutomationDemoSetupStep
     *
     * Query for an active DemoSetupStep__mdt record with specified Step Number
     *
     * @param stepNumber
     *
     * @return demoSetupSteps
     **/
    public static DemoSetupStep__mdt getActiveAutomationDemoSetupStep(Decimal stepNumber){
        List<DemoSetupStep__mdt> demoSetupSteps = [SELECT Id,
                                                            DeveloperName,
                                                            MasterLabel,
                                                            Active__c,
                                                            AutomationClass__c,
                                                            StepDependsOn__c, 
                                                            StepDescription__c, 
                                                            StepHyperlink__c,
                                                            StepNumber__c,
                                                            StepTitle__c,
                                                            StepType__c,
                                                            ModalPath__c
                                                            FROM DemoSetupStep__mdt
                                                            WHERE Active__c = true
                                                            AND StepNumber__c =: stepNumber
                                                            AND AutomationClass__c != null];

        if(!demoSetupSteps.isEmpty() && demoSetupSteps.size() == 1){
            return demoSetupSteps[0];
        }else if(demoSetupSteps.size() > 1){
            throw new DemoSetupException('More than one step exists for this step number');
        }else{
            throw new DemoSetupException('There are no Active Automatic Demo Setup Steps with an Automation Class matching this step number');
        }
    }

    /**
     * getStepNumberForAutomationClass
     *
     * Query for an active DemoSetupStep__mdt record with specified AutomationClass
     *
     * @param stepNumber
     *
     * @return demoSetupSteps
     **/
    public static DemoSetupStep__mdt getActiveAutomationDemoSetupStep(String automationClass){
        List<DemoSetupStep__mdt> demoSetupSteps = [SELECT Id,
                                                            DeveloperName,
                                                            MasterLabel,
                                                            Active__c,
                                                            AutomationClass__c,
                                                            StepDependsOn__c, 
                                                            StepDescription__c, 
                                                            StepHyperlink__c,
                                                            StepNumber__c,
                                                            StepTitle__c,
                                                            StepType__c,
                                                            ModalPath__c
                                                            FROM DemoSetupStep__mdt
                                                            WHERE Active__c = true
                                                            AND AutomationClass__c = :automationClass];

        if(!demoSetupSteps.isEmpty() && demoSetupSteps.size() == 1){
            return demoSetupSteps[0];
        }else if(demoSetupSteps.size() > 1){
            throw new DemoSetupException('More than one step exists for this class');
        }else{
            throw new DemoSetupException('There are no Active Automatic Demo Setup Steps with this Automation Class');
        }
    }

    /**
     * getDemoSetupStatuses
     *
     * Query for all getDemoStatuse__c records
     *
     * @return demoSetupSteps
     **/    
    public static List<DemoSetupStatus__c> getDemoSetupStatuses(){
        List<DemoSetupStatus__c> demoSetupStatuses = [SELECT Id,
                                                            StepNumber__c, 
                                                            StepStatus__c,
                                                            ErrorMessage__c
                                                            FROM DemoSetupStatus__c];
        
        return demoSetupStatuses;
    }

    /**
     * getDemoSetupStatusesMap
     *
     * Query for all getDemoStatuse__c records and return map of StepNumber => DemoSetupStatus__c
     *
     * @return demoSetupSteps
     **/ 
    public static Map<Decimal, DemoSetupStatus__c> getDemoSetupStatusesMap(){
        //Create map for return
        Map<Decimal, DemoSetupStatus__c> dssMap = new Map<Decimal, DemoSetupStatus__c>();
        //Query for records
        List<DemoSetupStatus__c> demoSetupStatuses = getDemoSetupStatuses();
        //Loop through records and populate map
        for(DemoSetupStatus__c dss : demoSetupStatuses){
            dssMap.put(dss.StepNumber__c, dss);
        }
        //Return populated map
        return dssMap;
    }

    /**
     * getDemoSetupStatus
     *
     * Query for a DemoSetupStatus__c record with specified Step Number
     *
     * @param stepNumber
     *
     * @return demoSetupSteps
     **/
    public static DemoSetupStatus__c getDemoSetupStatus(Decimal stepNumber){
        List<DemoSetupStatus__c> demoSetupStatus = [SELECT Id, 
                                                        StepNumber__c, 
                                                        StepStatus__c,
                                                        ErrorMessage__c 
                                                        FROM DemoSetupStatus__c 
                                                        WHERE StepNumber__c =: stepNumber];

        if(!demoSetupStatus.isEmpty() && demoSetupStatus.size() == 1){
            return demoSetupStatus[0];
        }else if(demoSetupStatus.size() > 1){
            throw new DemoSetupException('More than one step exists for this step number');
        }else{
            throw new DemoSetupException('There is no Demo Setup matching this step number');
        }
    }
}
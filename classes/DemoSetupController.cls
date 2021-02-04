/****************************************************************************************
Name            : DemoSetupController
Revision Log    : 2020-03-02 John Kuhl - CodeScience
                :
                :
Use             : Controller for DemoSetup LWC
****************************************************************************************/
public with sharing class DemoSetupController {
    
    /**
     * getActiveSteps
     *
     * Get configured Demo Setup Steps for front end display and action
     **/
    @AuraEnabled
    public static List<DemoSetupStepMsg> getActiveSteps(){
        try{
            return DemoSetupService.getActiveSteps();
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * getActiveStep
     *
     * Get single Demo Setup Step for front end display and action
     **/
    @AuraEnabled
    public static DemoSetupStepMsg getActiveStep(Decimal stepNumber){
        try{
            return DemoSetupService.getActiveStep(stepNumber);
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * runStep
     *
     * Run automated step
     **/
    @AuraEnabled
    public static void runStep(Decimal stepNumber){
        try{
            DemoSetupService.runStep(stepNumber);
        }catch(Exception e){
            updateStepWithError(e.getMessage(), stepNumber);
        }
    }

    @future
    private static void updateStepWithError(String error, Decimal stepNumber){
        DemoSetupStatus__c demoSetupStatus = DemoSetupStepSelector.getDemoSetupStatus(stepNumber);
        demoSetupStatus.StepStatus__c = 'Not Started';
        demoSetupStatus.ErrorMessage__c = error;
        update demoSetupStatus;

        //Create platform event number 2
        DemoStepStatus__e dsse = new DemoStepStatus__e(StepNumber__c = stepNumber);
        //Publish update event
        Database.SaveResult results = Eventbus.publish(dsse);
    }

    /**
     * runStep
     *
     * Run Manual step
     **/
    @AuraEnabled
    public static DemoSetupStepMsg runManualStep(Decimal stepNumber){
        try{
            return DemoSetupService.runManualStep(stepNumber);
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * skipStep
     *
     * Skip step
     **/
    @AuraEnabled
    public static DemoSetupStepMsg skipStep(Decimal stepNumber){
        try{
            return DemoSetupService.skipStep(stepNumber);
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * errStep
     *
     * Err step
     **/
    @AuraEnabled
    public static DemoSetupStepMsg errStep(Decimal stepNumber, String errMsg){
        try{
            return DemoSetupService.errStep(stepNumber, errMsg);
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

}
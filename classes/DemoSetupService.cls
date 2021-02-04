/****************************************************************************************
Name            : DemoSetupService
Revision Log    : 2020-03-02 John Kuhl - CodeScience
                :
                :
Use             : Service Class for DemoSetup LWC
****************************************************************************************/
public with sharing class DemoSetupService {

    /**
     * getActiveSteps
     *
     * Get configured Demo Setup Steps for front end display and action
     **/
    public static List<DemoSetupStepMsg> getActiveSteps(){
        //Query for Active DemoSetupStep__mdt records
        List<DemoSetupStep__mdt> demoSetupSteps = DemoSetupStepSelector.getActiveDemoSetupSteps();

        //Query for map of DemoSetupStatus__c by Step Number
        Map<Decimal, DemoSetupStatus__c> dssMap = DemoSetupStepSelector.getDemoSetupStatusesMap();

        //Create collection for return
        List<DemoSetupStepMsg> returnMsg = new List<DemoSetupStepMsg>();

        //Create a collection for insert
        List<DemoSetupStatus__c> dssInsert = new List<DemoSetupStatus__c>();

        //Loop through active DemoSetupStep__mdt records
        for(DemoSetupStep__mdt dss : demoSetupSteps){
            DemoSetupStatus__c statusRecord;
            if(dssMap.get(Integer.valueOf(dss.StepNumber__c)) != null){
                statusRecord = dssMap.get(Integer.valueOf(dss.StepNumber__c));
            }else{
                statusRecord = new DemoSetupStatus__c(StepNumber__c = dss.StepNumber__c, StepStatus__c = 'Not Started');
                dssInsert.add(statusRecord);
            }
            //Add new DemoSetupStepMsg instances to collection by passing DemoSetupStep__mdt to constructor
            returnMsg.add(new DemoSetupStepMsg(dss, statusRecord));
        }
        if(!dssInsert.isEmpty()){
            insert dssInsert;
        }
        
        //Return collection
        return returnMsg;
    }

    /**
     * getActiveStep
     *
     * Get single Demo Setup Step for front end display and action
     **/
    public static DemoSetupStepMsg getActiveStep(Decimal stepNumber){
        //Query for DemoSetupStep__mdt record with provided stepNumber
        DemoSetupStep__mdt demoSetupStep = DemoSetupStepSelector.getActiveDemoSetupStep(stepNumber);
        //Get the status record
        DemoSetupStatus__c demoSetupStatus = DemoSetupStepSelector.getDemoSetupStatus(stepNumber);

        //Return wrapped record
        return new DemoSetupStepMsg(demoSetupStep, demoSetupStatus);
    }

    /**
     * runStep
     *
     * Run automated step
     **/
    public static void runStep(Decimal stepNumber){
        //Query for DemoSetupStep__mdt record with provided stepNumber
        DemoSetupStep__mdt demoSetupStep = DemoSetupStepSelector.getActiveAutomationDemoSetupStep(stepNumber);

        updateStatusToRunning(stepNumber);

        //Instanciate the Automation Class Type specified in the Custom Setting
        Type t = Type.forName(demoSetupStep.AutomationClass__c);

        //Create an instance of the Automation Class
        IConfigStep ics = (IConfigStep)t.newInstance();
        
        //Execute the step
        ics.execute();
    }

    @future
    public static void updateStatusToRunning(Decimal stepNumber){
        //Get the status record
        DemoSetupStatus__c demoSetupStatus = DemoSetupStepSelector.getDemoSetupStatus(stepNumber);

        if(demoSetupStatus.StepStatus__c == 'Not Started' && demoSetupStatus.ErrorMessage__c == null){
            //Set status to running
            demoSetupStatus.StepStatus__c = 'Running';
            //Update record
            update demoSetupStatus;
            
            //Publish update event
            DemoStepStatus__e dsse = new DemoStepStatus__e(StepNumber__c = stepNumber, StepStatus__c = demoSetupStatus.StepStatus__c);
            Database.SaveResult results = Eventbus.publish(dsse);
        }
        
    }
  
  /**
     * runManualStep
     *
     * Run manual step
     **/
    public static DemoSetupStepMsg runManualStep(Decimal stepNumber) {

        DemoSetupStep__mdt demoSetupStep = DemoSetupStepSelector.getActiveDemoSetupStep(stepNumber);

        DemoSetupStatus__c demoSetupStatus = DemoSetupStepSelector.getDemoSetupStatus(stepNumber);

        demoSetupStatus.StepStatus__c = 'Complete';

        update demoSetupStatus;

        return new DemoSetupStepMsg(demoSetupStep, demoSetupStatus);
    }

    /**
     * skipStep
     *
     * Skip step
     **/
    public static DemoSetupStepMsg skipStep(Decimal stepNumber) {

        DemoSetupStep__mdt demoSetupStep = DemoSetupStepSelector.getActiveDemoSetupStep(stepNumber);

        DemoSetupStatus__c demoSetupStatus = DemoSetupStepSelector.getDemoSetupStatus(stepNumber);

        demoSetupStatus.StepStatus__c = 'Skipped';

        update demoSetupStatus;

        return new DemoSetupStepMsg(demoSetupStep, demoSetupStatus);
    }

    /**
     * errStep
     *
     * Err step
     **/
    public static DemoSetupStepMsg errStep(Decimal stepNumber, String errMsg) {

        DemoSetupStep__mdt demoSetupStep = DemoSetupStepSelector.getActiveDemoSetupStep(stepNumber);

        DemoSetupStatus__c demoSetupStatus = DemoSetupStepSelector.getDemoSetupStatus(stepNumber);

        demoSetupStatus.ErrorMessage__c = errMsg;

        update demoSetupStatus;

        return new DemoSetupStepMsg(demoSetupStep, demoSetupStatus);
    }
}
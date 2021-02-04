/****************************************************************************************
Name            : ConfigUpdateRemoteSiteSettingsStep
Revision Log    : 2020-03-17 John Kuhl - CodeScience
                :
                :
Use             : IConfigStep class for creating Remote Site Settings
****************************************************************************************/
public class ConfigUpdateRemoteSiteSettingsStep implements IConfigStep {
    public static void execute(){
        //Run asynchronus process
        createRemoteSiteSettingsAsync();
    }

    /**
     * createRemoteSiteSettingsAsync
     *
     * This method asychronously executes the the creation of Remote Site Settings
     **/
    @future(callout=true)
    private static void createRemoteSiteSettingsAsync(){
        Boolean success = false;
        
        if(!Test.isRunningTest()){
            try{
                MetadataAPIUtility.createRemoteSiteSettings();
                success = true;
            }catch(Exception e){
                DemoStepUtility.updateStepWithError('ConfigUpdateRemoteSiteSettingsStep', e.getMessage());
            }
        }else{
            success = true;
        }

        if(success){
            DemoStepUtility.updateSetupStatusToComplete('ConfigUpdateRemoteSiteSettingsStep', null);
        }
    }
}
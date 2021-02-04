/****************************************************************************************
Name            : ConfigRemoveLicenseStep
Revision Log    : 2020-02-27 John Kuhl - CodeScience
                :
                :
Use             : IConfigStep class for removing Package Licenses from identified users
****************************************************************************************/
public class ConfigRemoveLicenseStep implements IConfigStep{

    /**
     * execute
     *
     * Execute the UserPackageLicense delete
     **/
    public static void execute() {

        //Query for PackageLicense
        PackageLicense packageLicense = [SELECT Id FROM PackageLicense WHERE NamespacePrefix = 'LLC_BI'];

        Map<Id, User> users = new Map<Id, User>([SELECT Id, Name FROM User WHERE AutoRemoveManagedLicense__c = true]);

        //Query for Users with AutoRemoveManagedLicense checked
        Set<Id> userIds = new Set<Id>(users.keySet());

        //Query for UserPackageLicense records related to specified PackageLicense and UserIds
        Map<Id, UserPackageLicense> userLicenses = new Map<Id, UserPackageLicense>([SELECT Id, UserId, PackageLicenseId FROM UserPackageLicense WHERE PackageLicenseId =: packageLicense.Id AND UserId IN : userIds]);

        //Execute delete
        List<Database.DeleteResult> deletes = Database.delete(userLicenses.values(), false);

        //Boolean to track overall success
        Boolean success = true;
        
        //Create a list of User's Names successfully removed
        List<String> successes = new List<String>();

        //Create a Map of User's Name => Error Message for failures
        Map<String, String> failures = new Map<String, String>();
        
        //Loop through DeleteResults
        for(Database.DeleteResult del : deletes){
            //Get UserId from UserLicense query
            Id userId = userLicenses.get(del.getId()).UserId;
            //If the delete was successful
            if(del.isSuccess()){
                //Add user name to success list
                successes.add(users.get(userId).Name);
            }else{
                //Set overall success to false
                success = false;
                //Get Error list
                List<Database.Error> errors = del.getErrors();
                //Create a string to concatenate errors
                String errorStrings = '';
                for(Database.Error de : errors){
                    //If this is the first error
                    if(errorStrings == ''){
                        //Add error message to concatenated String
                        errorStrings += de.getMessage();
                    }else{
                        //Add new message after a line bread
                        errorStrings += '; ' + de.getMessage();
                    }
                }
                //Add User's name and concatenated string to Map
                failures.put(users.get(userId).Name, errorStrings);
            }
        }

        //Build error message
        String errorMessages;

        if(!successes.isEmpty()){
            errorMessages = 'User Licenses Succesfully Removed from the following: \n'
                            + String.join(successes, '\n');
        }

        if(!failures.keySet().isEmpty()){
            if(errorMessages != null){
                errorMessages += '\n \n';
            }
            errorMessages += 'User License Removal Failed for the following: \n';
            for(String fl : failures.keySet()){
                errorMessages += fl + ': ' + failures.get(fl) + '\n';
            }
            if(!successes.isEmpty()){
                DemoStepUtility.updateStepWithError('ConfigRemoveLicenseStep', errorMessages);
            }
        }else{
            errorMessages = null;
        }
        //Update DemoSetupStep__c record
        updateDemoSetupStatus(errorMessages);
    }

    @future
    public static void updateDemoSetupStatus(String error){
        //Update DemoSetupStep__c record to complete
        DemoStepUtility.updateSetupStatusToComplete('ConfigRemoveLicenseStep', error);
    }
}
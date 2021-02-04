public class GroupCloneWithRouteGroupsController {

    private ApexPages.StandardController controller { get; set; }
    private nFORCE__Group__c currentGroup           { get; set; }
    public Id newRecordId                           { get; set; }

    public GroupCloneWithRouteGroupsController(ApexPages.StandardController controller) {

        this.controller = controller;
        currentGroup = (nFORCE__Group__c)controller.getRecord();

    }

    public PageReference cloneWithRouteGroups() {

        Savepoint sp = Database.setSavepoint();
        nFORCE__Group__c newGroup;

        try {

            currentGroup = [SELECT Id FROM nFORCE__Group__c WHERE Id =: currentGroup.Id];
            newGroup = currentGroup.clone(false);
            insert newGroup;

            newRecordId = newGroup.Id;

            List<nFORCE__Route_Group__c> routeGroups = new List<nFORCE__Route_Group__c>();
            for (nFORCE__Route_Group__c rg : [SELECT nFORCE__Group__c, nFORCE__Is_Hidden__c, nFORCE__Order__c, nFORCE__Parent_Route__c, nFORCE__Route__c FROM nFORCE__Route_Group__c p WHERE nFORCE__Group__c =: currentGroup.Id]) {
                nFORCE__Route_Group__c newRG = rg.clone(false);
                newRG.nFORCE__Group__c = newGroup.id;
                routeGroups.add(newRG);
            }
            insert routeGroups;

        } catch (Exception e){
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
        }

        return new PageReference('/' + newGroup.Id + '/e?retURL=%2F' + newGroup.Id);
    }

}
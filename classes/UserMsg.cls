public class UserMsg {
    @AuraEnabled public String name;
    @AuraEnabled public String title;
    @AuraEnabled public String imageURL;
    @AuraEnabled public String id;
    @AuraEnabled public Boolean demoUser;
    @AuraEnabled public Boolean currentUser;
    @AuraEnabled public String profile;
    @AuraEnabled public String communityId;

    public UserMsg(User u){
        this.name = u.Name;
        this.title = u.Title;
        this.imageURL = u.IsProfilePhotoActive ? u.SmallPhotoURL : null;
        this.id = u.id;
        this.demoUser = u.DemoUser__c;
        this.currentUser = false;
        this.profile = u.Profile.Name;
        this.communityId = null;
    }
}
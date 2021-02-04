public class CategoryWrapper {

    public Boolean checked{ get; set; }
    public LLC_BI__Legal_Entities__c ent { get; set; }

    public CategoryWrapper(){
        ent = new LLC_BI__Legal_Entities__c();
        checked = false;
    }

    public CategoryWrapper(LLC_BI__Legal_Entities__c e){
        ent = e;
        checked = false;
    }
}
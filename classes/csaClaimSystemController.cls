public with sharing class csaClaimSystemController {
    ApexPages.StandardSetController ctrl;
    public List<String> recordIds {get;set;}

    public csaClaimSystemController(ApexPages.StandardSetController controller) {
        this.ctrl = controller;
        this.recordIds = new List<String>();
        for(sObject obj: ctrl.getSelected()) {
            this.recordIds.add(obj.Id);
        }
    }
}
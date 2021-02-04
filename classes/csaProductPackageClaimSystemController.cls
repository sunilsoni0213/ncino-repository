global with sharing class csaProductPackageClaimSystemController {

    @RemoteAction
    global static Map<Id, List<nFORCE.Field>> getProductPackages(String ids) {
        List<String> recordIds = csaClaimSystemUtilityController.updateString(ids);
        Map<Id, List<nFORCE.Field>> toReturn = new Map<Id, List<nFORCE.Field>>();
        List<Schema.FieldSetMember> fieldset = SObjectType.LLC_BI__Product_Package__c.fieldSets.getMap().get(csaClaimSystemUtilityController.getFieldSetName(
            csaClaimSystemConstants.PROPERTY_CATEGORY,
            csaClaimSystemConstants.PROPERTY_PRODUCTPACKAGEKEY
        )).getFields();
        Schema.SObjectType sObjType = Schema.getGlobalDescribe().get(PRODUCTPACKAGEAPI);
        Map<String, Schema.SObjectField> objectFields = sObjType.getDescribe().fields.getMap();
        List<String> ppFields = new List<String>(objectFields.keySet());

        String ppQuery =
                'SELECT '+
                        String.join(ppFields, csaClaimSystemConstants.COMMA_SPACE) +
                ' FROM '+
                        'LLC_BI__Product_Package__c '+
                'WHERE '+
                        'Id IN :recordIds';
        List<LLC_BI__Product_Package__c> productPackages = Database.query(ppQuery);

        for(LLC_BI__Product_Package__c p: productPackages) {
            List<nFORCE.Field> fields = new List<nFORCE.Field>();
            for(Schema.FieldSetMember field: fieldset) {
                fields.add(new nFORCE.Field(
                    sObjType, objectFields.get(field.getFieldPath()),
                    p.get(field.getFieldPath())
                ));
            }
            toReturn.put(p.Id, fields);
        }

        return toReturn;
    }

    @RemoteAction
    global static void claimProductPackages(String productPackageIds, String roleId, String userId) {
        List<String> recordIds = csaClaimSystemUtilityController.updateString(productPackageIds);
        List<LLC_BI__Product_Package__c> toBeUpdateProductPackages = new List<LLC_BI__Product_Package__c>();
        List<LLC_BI__Product_Package_Team__c> loanTeams = new List<LLC_BI__Product_Package_Team__c>();

        for(String productPackageId: recordIds) {
            toBeUpdateProductPackages.add(new LLC_BI__Product_Package__c(
                Id = productPackageId,
                CSA_Queue__c = csaClaimSystemConstants.BLANK
            ));
            loanTeams.add(new LLC_BI__Product_Package_Team__c(
                LLC_BI__Product_Package__c = productPackageId,
                LLC_BI__Assigned_Role__c = roleId,
                LLC_BI__User__c = userId
            ));
        }

        Database.update(toBeUpdateProductPackages);
        Database.insert(loanTeams);
    }

    @RemoteAction
    global static List<String> getHeaders() {
        List<String> toReturn = new List<String>();
        List<Schema.FieldSetMember> fieldset = SObjectType.LLC_BI__Product_Package__c.fieldSets.getMap().get(csaClaimSystemUtilityController.getFieldSetName(
            csaClaimSystemConstants.PROPERTY_CATEGORY,
            csaClaimSystemConstants.PROPERTY_PRODUCTPACKAGEKEY
        )).getFields();

        for(Schema.FieldSetMember f: fieldset) {
            toReturn.add(f.getLabel());
        }

        return toReturn;
    }

    @RemoteAction
    global static Map<Id, String> getRoles() {
        return csaClaimSystemUtilityController.getRoles();
    }

    @RemoteAction
    global static Map<Id, String> getUsers() {
        return csaClaimSystemUtilityController.getUsers();
    }

    @RemoteAction
    global static Object getFieldValueName(String recordId) {
        return csaClaimSystemUtilityController.getName(recordId);
    }

    private static final String PRODUCTPACKAGEAPI = 'LLC_BI__Product_Package__c';
}
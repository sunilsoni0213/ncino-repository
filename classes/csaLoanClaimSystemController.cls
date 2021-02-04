global with sharing class csaLoanClaimSystemController {

    @RemoteAction
    global static Map<Id, List<nFORCE.Field>> getLoans(String ids) {
        List<String> recordIds = csaClaimSystemUtilityController.updateString(ids);
        Map<Id, List<nFORCE.Field>> toReturn = new Map<Id, List<nFORCE.Field>>();
        List<Schema.FieldSetMember> fieldset = SObjectType.LLC_BI__Loan__c.fieldSets.getMap().get(csaClaimSystemUtilityController.getFieldSetName(
            csaClaimSystemConstants.PROPERTY_CATEGORY,
            csaClaimSystemConstants.PROPERTY_LOANKEY
        )).getFields();
        Schema.SObjectType sObjType = Schema.getGlobalDescribe().get(LOANAPI);
        Map<String, Schema.SObjectField> objectFields = sObjType.getDescribe().fields.getMap();
        List<String> loanFields = new List<String>(objectFields.keySet());

        String loanQuery =
    				'SELECT '+
    						String.join(loanFields, csaClaimSystemConstants.COMMA_SPACE) +
    				' FROM '+
    						'LLC_BI__Loan__c '+
    				'WHERE '+
    						'Id IN :recordIds';
    		List<LLC_BI__Loan__c> loans = Database.query(loanQuery);

        for(LLC_BI__Loan__c l: loans) {
            List<nFORCE.Field> fields = new List<nFORCE.Field>();
            for(Schema.FieldSetMember field: fieldset) {
                fields.add(new nFORCE.Field(
                    sObjType, objectFields.get(field.getFieldPath()),
                    l.get(field.getFieldPath())
                ));
            }
            toReturn.put(l.Id, fields);
        }

        return toReturn;
    }

    @RemoteAction
    global static void claimLoans(String loanIds, String roleId, String userId) {
        List<String> recordIds = csaClaimSystemUtilityController.updateString(loanIds);
        List<LLC_BI__Loan__c> toBeUpdateLoans = new List<LLC_BI__Loan__c>();
        List<LLC_BI__LoanTeam__c> loanTeams = new List<LLC_BI__LoanTeam__c>();

        for(String loanId: recordIds) {
            toBeUpdateLoans.add(new LLC_BI__Loan__c(
                Id = loanId,
                CSA_Queue__c = csaClaimSystemConstants.BLANK
            ));
            loanTeams.add(new LLC_BI__LoanTeam__c(
                LLC_BI__Loan__c = loanId,
                LLC_BI__Assigned_Role__c = roleId,
                LLC_BI__User__c = userId
            ));
        }

        update(toBeUpdateLoans);
        insert(loanTeams);
    }

    @RemoteAction
    global static List<String> getHeaders() {
        List<String> toReturn = new List<String>();
        List<Schema.FieldSetMember> fieldset = SObjectType.LLC_BI__Loan__c.fieldSets.getMap().get(csaClaimSystemUtilityController.getFieldSetName(
            csaClaimSystemConstants.PROPERTY_CATEGORY,
            csaClaimSystemConstants.PROPERTY_LOANKEY
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

    private static final String LOANAPI = 'LLC_BI__Loan__c';
}
/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class LoanFactory_v1_0 implements LLC_BI.IForceBulkFactory, LLC_BI.IForceFactory {
    global LoanFactory_v1_0() {

    }
    global virtual LLC_BI.IForce buildForce(SObject dObj, System.Type fType, Map<Id,LLC_BI.IForce> fCache, Boolean fLoad) {
        return null;
    }
    global static Boolean collateralMigrationComplete() {
        return null;
    }
    global LLC_BI.IForce generateNew(Id recordId) {
        return null;
    }
    global List<LLC_BI.IForce> generateNew(Set<Id> recordIds) {
        return null;
    }
    global virtual List<LLC_BI__Collateral__c> retrieveCollateral(Set<Id> loanColIds) {
        return null;
    }
    global virtual List<LLC_BI__Legal_Entities__c> retrieveInvolvements(Set<Id> involvementIds) {
        return null;
    }
    global virtual List<LLC_BI__Lien__c> retrieveLiens(Set<Id> loanColIds) {
        return null;
    }
    global virtual List<LLC_BI__Loan__c> retrieveLoans(Set<Id> recordIds) {
        return null;
    }
    global virtual List<Account> retrieveRelationships(Set<Id> relationshipIds) {
        return null;
    }
}

/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CovenantManagerService {
    global CovenantManagerService() {

    }
    @RemoteAction
    global static void createLoanCovenants(Id loanId, List<Id> covenantIds) {

    }
    @RemoteAction
    global static List<nFORCE.IForce> getAccountCovenants(Id accountId, Id loanId) {
        return null;
    }
    @RemoteAction
    global static LLC_BI.CovenantManagerContainer loadCovenantManagerContainer(Id contextObjectId) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI.LifeCycleUnderwritingBundle> loadUnderwritingBundle(Id accountId) {
        return null;
    }
    @RemoteAction
    global static nFORCE.IForce saveCovenant(Id accountId, Id loanId, nFORCE.IForce covenant) {
        return null;
    }
}

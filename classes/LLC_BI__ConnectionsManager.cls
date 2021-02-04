/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ConnectionsManager {
    global Map<String,LLC_BI__Connection__c> buildUidMap(List<LLC_BI__Connection__c> connections) {
        return null;
    }
    global LLC_BI__Connection__c createConnection(Id connectedFrom, Id connectedTo, LLC_BI__Connection_Role__c role, String description) {
        return null;
    }
    global Map<String,LLC_BI__Connection__c> findMatching(Set<String> uids) {
        return null;
    }
    global LLC_BI__Connection__c generateReciprocalConnection(LLC_BI__Connection__c connection) {
        return null;
    }
    global Map<String,LLC_BI__Connection__c> generateReciprocalConnections(List<LLC_BI__Connection__c> connections) {
        return null;
    }
    global Map<String,LLC_BI__Connection__c> generateReciprocatedConnections(LLC_BI__Connection__c connection) {
        return null;
    }
    global Map<String,Map<String,LLC_BI__Connection__c>> generateReciprocatedConnections(List<LLC_BI__Connection__c> connections) {
        return null;
    }
    global static LLC_BI.ConnectionsManager getInstance() {
        return null;
    }
    global LLC_BI__Connection_Role__c getReciprocalRole(LLC_BI__Connection_Role__c role) {
        return null;
    }
    global List<LLC_BI__Connection_Role__c> getReciprocatedRoles(LLC_BI__Connection_Role__c role) {
        return null;
    }
    global LLC_BI__Connection_Role__c getRole(Id roleId) {
        return null;
    }
    global LLC_BI__Connection_Role__c getRole(String roleName) {
        return null;
    }
    global List<LLC_BI__Connection_Role__c> getRoles() {
        return null;
    }
    global String getUid(LLC_BI__Connection__c connection) {
        return null;
    }
    global Boolean isExisting(LLC_BI__Connection__c comparison, LLC_BI__Connection__c test) {
        return null;
    }
    global Boolean isSame(LLC_BI__Connection__c comparison, LLC_BI__Connection__c test) {
        return null;
    }
    global LLC_BI__Connection__c mergeConnection(LLC_BI__Connection__c mergeFrom, LLC_BI__Connection__c mergeTo) {
        return null;
    }
}

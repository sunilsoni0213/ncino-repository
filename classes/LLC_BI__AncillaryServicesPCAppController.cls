/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AncillaryServicesPCAppController extends LLC_BI.ProductCreationBaseController {
    @RemoteAction
    global static void associateRecords(Id treasuryServiceId, Id accountId, Id productId, Id depositId) {

    }
    @RemoteAction
    global static Id createSession() {
        return null;
    }
    @RemoteAction
    global static String deleteAllBackwards(Map<String,String> params) {
        return null;
    }
    @RemoteAction
    global static void deleteService(List<Id> toDelete) {

    }
    @RemoteAction
    global static List<List<LLC_BI.AncillaryService>> getAncillaryServices(Id depositId, List<LLC_BI.AncillaryService> products) {
        return null;
    }
    @RemoteAction
    global static LLC_BI.AncillaryServicesPCAppController.AncillaryProduct getProductInformation(Id productId) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI.AncillaryServicesPCAppController.Relationship> getRelationships(Id depositId, Id primaryRelationshipId) {
        return null;
    }
    @RemoteAction
    global static Id saveAncillaryService(nFORCE.IScreenResource screenResource, Id relationshipId, LLC_BI.AncillaryService serviceDetails, Id sessionId) {
        return null;
    }
global class AncillaryProduct {
    global AncillaryProduct() {

    }
}
global class Relationship {
}
global class Service {
}
}

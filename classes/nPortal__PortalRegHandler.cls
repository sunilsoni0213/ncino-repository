/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class PortalRegHandler implements Auth.SamlJitHandler {
    global Map<String,String> userFieldMap;
    global PortalRegHandler() {

    }
    global virtual void buildFieldMapping() {

    }
    global virtual User buildUserFromFieldMapping(User usr, Map<String,String> attributes) {
        return null;
    }
    global virtual nPortal.UserWrapper createUserWrapper(User usr, Map<String,String> attributes, String federationId) {
        return null;
    }
    global virtual User createUser(Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String,String> attributes, String assertion) {
        return null;
    }
    @Future(callout=false)
    global static void declarePasswordSet(Id userId) {

    }
    global virtual List<User> findExistingUsers(String federationIdentifier, User usr) {
        return null;
    }
    @Future(callout=false)
    global static void handleUserAssociations(Id userId) {

    }
    global virtual User register(nPortal.UserWrapper userData, String productId, Contact existingContact) {
        return null;
    }
    global virtual User updateUser(Id userId, Map<String,String> attributes, String federationId) {
        return null;
    }
    global virtual void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String,String> attributes, String assertion) {

    }
}

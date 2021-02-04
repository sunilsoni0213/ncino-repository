global with sharing class csaClaimSystemInstallerController {

    @RemoteAction
    global static Boolean checkInstall() {
        nFORCE.SystemProperties properties = nFORCE.SystemProperties.getInstance();
        return properties.getPropertyAsBoolean(
            nCSA_FRAME.csaConstants.CSASYSTEMPROPERTYCATEGORY,
            csaClaimSystemConstants.PROPERTY_INSTALLEDKEY,
            false
        );
    }

    @RemoteAction
    global static void install() {
        List<nFORCE__System_Properties__c> propertiesList = new List<nFORCE__System_Properties__c>();

        propertiesList.add(nFORCE.SystemProperties.createProperty(
            csaClaimSystemConstants.PROPERTY_CATEGORY,
            csaClaimSystemConstants.PROPERTY_LOANKEY,
            csaClaimSystemConstants.PROPERTY_LOANVALUE,
            true
        ));

        propertiesList.add(nFORCE.SystemProperties.createProperty(
            csaClaimSystemConstants.PROPERTY_CATEGORY,
            csaClaimSystemConstants.PROPERTY_PRODUCTPACKAGEKEY,
            csaClaimSystemConstants.PROPERTY_PRODUCTPACKAGEVALUE,
            true
        ));

        propertiesList.add(nFORCE.SystemProperties.createProperty(
            nCSA_FRAME.csaConstants.CSASYSTEMPROPERTYCATEGORY,
            csaClaimSystemConstants.PROPERTY_INSTALLEDKEY,
            csaClaimSystemConstants.PROPERTY_INSTALLEDVALUE,
            true
        ));

        insert propertiesList;
    }

    @RemoteAction
    global static void uninstall() {
        List<nFORCE__System_Properties__c> propertiesList = [SELECT
                                                                    Id
                                                            FROM
                                                                    nFORCE__System_Properties__c
                                                            WHERE
                                                                    nFORCE__Category_Name__c = :csaClaimSystemConstants.PROPERTY_CATEGORY
                                                            OR
                                                                    nFORCE__Category_Name__c = :nCSA_FRAME.csaConstants.CSASYSTEMPROPERTYCATEGORY
                                                            LIMIT 100];

        if(!propertiesList.isEmpty()) {
            delete propertiesList;
        }
    }
}
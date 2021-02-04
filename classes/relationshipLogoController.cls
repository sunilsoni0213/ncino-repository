public with sharing class relationshipLogoController {
    
    //Get customer relationships
    @AuraEnabled(cacheable=true)
    public static List<sObject> getCustomerLogos(String userId){
        return [SELECT Id, Name, Industry, Phone, Logo__c FROM Account WHERE OwnerId = :userId AND Type = 'Corporate Client' AND LLC_BI__Status__c = 'Customer'];
    }

    //Get prospect relationships
    @AuraEnabled(cacheable=true)
    public static List<sObject> getProspectLogos(String userId){
        return [SELECT Id, Name, Industry, Phone, Logo__c FROM Account WHERE OwnerId = :userId AND Type = 'Corporate Client' AND LLC_BI__Status__c = 'Prospect'];
    }

}
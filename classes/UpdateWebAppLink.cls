public with sharing class UpdateWebAppLink {
        public String domainString {get; set;}
        public String productId {get; set;}
        public String domainStringAfter {get; set;}
    	public String domainStringBefore {get; set;}
        public String productIdFinal {get; set;}
        public List<Domain> domain {get; set;}
        public List<LLC_BI__Product__c> product {get; set;}
    public UpdateWebAppLink() {
       domain = [SELECT Domain FROM Domain];
       
       domainString = String.valueOf(domain);
     System.debug('**********' + domainString);
       domainStringAfter = domainString.substringafter('Domain:{Domain=');
     System.debug('**********' + domainStringAfter);
       domainStringBefore = domainStringAfter.substringbefore(',');
     System.debug('**********' + domainStringBefore);
       product = [SELECT Id FROM LLC_BI__Product__c WHERE Name = 'Line of Credit' AND nPortal__Online_Application_Enabled__c = TRUE];
       
       productId = String.valueOf(product);
       
    	productIdFinal = productId.substring(24,39);

    }
}
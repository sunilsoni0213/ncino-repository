public with sharing class CallYahooQuotesImageController {

    public String imageURL {get;set;}

    public CallYahooQuotesImageController(ApexPages.StandardController controller) {
    
        Id objId = ApexPages.currentPage().getParameters().get('id');
        system.debug('*** objId: ' + objId);
        
        Holding__c h = [SELECT Id, Ticker_Symbol__c FROM Holding__c WHERE Id =: objId];
        system.debug('*** h: ' + h.Id);
        imageURL = 'https://finance.yahoo.com/chart/'+h.Ticker_Symbol__c+'?p='+h.Ticker_Symbol__c;
        system.debug('*** imageURL: ' + imageURL);

    }
}
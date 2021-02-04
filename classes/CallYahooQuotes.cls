global class CallYahooQuotes {

   @InvocableMethod(label='Update Stock Quotes' description='Updates holdings associated with the collateral record')
    public static void callGetQuotes(List<Id> ids) {
        System.debug(ids);
        for (Id anId : ids) {
            getQuotes(anId);
        }
        
    }
   webservice static void getQuotes(Id collateral) {
      
      List<Holding__c> holdingsList = [SELECT 
            Id, 
            Ticker_Symbol__c, 
            Stock_Price__c 
         FROM 
            Holding__c 
         WHERE 
            Collateral__c =: collateral];

      for (Holding__c hold : holdingsList) {

         //String url = 'http://download.finance.yahoo.com/d/quotes.csv?s='+hold.Ticker_Symbol__c+'&f=l1&e=.csv';
		 String url = 'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol='+hold.Ticker_Symbol__c+'&apikey=521G0XTS6JC8X5DB&datatype=json';
          System.debug(url);
         Http h = new Http();  
         HttpRequest req = new HttpRequest();
         req.setEndpoint(url);
         req.setMethod('GET');
         HttpResponse res = h.send(req);
          System.debug(res.getBody());
		 Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
         Object unstructedStockPrices = responseMap.get('Global Quote');
         if (unstructedStockPrices != null) {
             List<String> closePriceList = String.valueOf(unstructedStockPrices).split(',');
             String rawClosePrice = closePriceList[4];
             System.debug(rawClosePrice);
             List<String> closePrice = rawClosePrice.split('\\=');
             System.debug(closePrice[1]);
             hold.Stock_Price__c = Decimal.valueof(closePrice[1]);
             if (hold.Yahoo_Finance_Link__c == null) {
                 hold.Yahoo_Finance_Link__c = 'http://finance.yahoo.com/q?s='+hold.Ticker_Symbol__c;
             }
         }
         
      }

      update holdingsList;

      LLC_BI__Collateral__c col = [SELECT
            Id,
            LLC_BI__Value__c,
            Total_Holdings_Value__c
         FROM
            LLC_BI__Collateral__c
         WHERE
             Id =: collateral];

      col.LLC_BI__Value__c = col.Total_Holdings_Value__c;
      update col;

      List<LLC_BI__Loan_Collateral2__c> collateralList = [SELECT 
            Id,
            LLC_BI__Collateral__c,
            LLC_BI__Collateral_Value__c 
         FROM 
            LLC_BI__Loan_Collateral2__c 
         WHERE 
            LLC_BI__Collateral__c =: col.Id];

      for (LLC_BI__Loan_Collateral2__c c : collateralList) {
         c.LLC_BI__Collateral_Value__c = col.Total_Holdings_Value__c;
      }

      update collateralList;
   }
}
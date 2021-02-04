global with sharing class LocationCallouts {

   webservice static void getLocation(Id account){

      Account a = [SELECT BillingLatitude, BillingLongitude, BillingCity, BillingCountry,BillingPostalCode,BillingState,BillingStreet FROM Account WHERE Id =: account];
      String key = 'AIzaSyDYTK6Ho-9bN3U48ZydCpujjmdMVJZiE5U';
      String address = '';

      if (a.BillingStreet != null) {
         address += a.BillingStreet +', ';
      }
      if (a.BillingCity != null) {
         address += a.BillingCity +', ';
      }
      if (a.BillingState != null) {
         address += a.BillingState +' ';
      }
      if (a.BillingPostalCode != null) {
         address += a.BillingPostalCode +', ';
      }
      if (a.BillingCountry != null) {
         address += a.BillingCountry;
      }

      address = EncodingUtil.urlEncode(address, 'UTF-8');
      Http h = new Http();
      HttpRequest req = new HttpRequest();

      req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address='+address+'&key='+key);
      req.setMethod('GET');
      req.setTimeout(60000);

      try {

         HttpResponse res = h.send(req);
         JSONParser parser = JSON.createParser(res.getBody());
         double lat = null;
         double lon = null;
         
         while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'location')) {
               parser.nextToken();
               while (parser.nextToken() != JSONToken.END_OBJECT) {
                  String txt = parser.getText();
                  parser.nextToken();
                  if (txt == 'lat') {
                     lat = parser.getDoubleValue();
                  } else if (txt == 'lng')
                     lon = parser.getDoubleValue();   
                  }
            }
         }

         /*
         if ((lat != null && lon != null) && (a.Location__Latitude__s != lat && a.Location__Longitude__s != lon)) {
            a.BillingLatitude = lat;
            a.BillingLongitude = lon;
            update a;
         }
         */

         if (lat != null) {
            a.BillingLatitude = lat;
            a.BillingLongitude = lon;
            update a;
         }

      } catch (DmlException e) {
         System.debug('The following exception has occurred: ' + e.getMessage());   
      }
   }
}
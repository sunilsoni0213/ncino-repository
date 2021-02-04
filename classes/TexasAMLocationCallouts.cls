global with sharing class TexasAMLocationCallouts {

   webservice static void getLocation(Id account){

      Account a = [SELECT BillingLatitude, BillingLongitude, BillingCity, BillingCountry,BillingPostalCode,BillingState,BillingStreet FROM Account WHERE Id =: account];
      String apiKey = 'demo';
      String street;
      String city;
      String state;
      String zip;

      if (a.BillingStreet != null) {
         street = a.BillingStreet;
      }
      if (a.BillingCity != null) {
         city = a.BillingCity;
      }
      if (a.BillingState != null) {
         state = a.BillingState;
      }
      if (a.BillingPostalCode != null) {
         zip = a.BillingPostalCode;
      }

      if (a.Id != null && apiKey != null && street != null && city != null && state != null && zip != null) {

         street = EncodingUtil.urlEncode(street, 'UTF-8');
         Http h = new Http();
         HttpRequest req = new HttpRequest();

         req.setEndpoint('http://geoservices.tamu.edu/Services/Geocode/WebService/GeocoderWebServiceHttpNonParsed_V04_01.aspx?streetAddress='+street+'&city='+city+'&state='+state+'&zip='+zip+'&apikey='+apiKey+'&format=json&version=4.01');
         req.setMethod('GET');
         req.setTimeout(60000);

         try {

            HttpResponse res = h.send(req);
            JSONParser parser = JSON.createParser(res.getBody());
            String lat = null;
            String lon = null;
            Decimal latFinal;
            Decimal lonFinal;

            while (parser.nextToken() != null) {
               if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'OutputGeocode')) {
                  parser.nextToken();
                  while (parser.nextToken() != JSONToken.END_OBJECT) {
                     String txt = parser.getText();
                     parser.nextToken();
                     if (txt == 'Latitude') {
                        lat = parser.getText();
                        latFinal = Decimal.ValueOf(lat);
                     } else if (txt == 'Longitude') {
                        lon = parser.getText();
                        lonFinal = Decimal.ValueOf(lon);
                     }
                  }
               }
            }

            if (latFinal != null && lonFinal != null) {
               a.BillingLatitude = latFinal;
               a.BillingLongitude = lonFinal;
               update a;
            }

         } catch (DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());   
         }
      } else {
         system.debug('*** Required data not found.');
      }
   }
}
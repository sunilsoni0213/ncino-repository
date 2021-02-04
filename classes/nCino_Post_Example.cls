public class nCino_Post_Example {
    @InvocableMethod(label='nCino POST Example' description='Example method for calling out to an external URL')
    public static List<String> searchData(List<FlowData> inputDataList) {
        // collect params
        Map<String, String> body = new Map<String, String>();
        String endpointURL;
        for (FlowData inputData : inputDataList) {
            // get the data, assumption we will have only one elememt in inputDataList
            body.put('Loan Amount', inputData.loanAmount);
            body.put('Relationship Exposure', inputData.relationshipExposure);
            body.put('Credit Score', inputData.creditScore);
            body.put('LTV', inputData.ltv);
            endpointURL = inputData.endpointURL;
        }
        
        String sbody = JSON.serialize(body);
        // Instantiate a new HTTP object
        Http h = new Http();
        // Instantiate a new HTTP POST request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointURL);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setBody(sbody);
        // in case we need to pull back response from 3rd party to flow
        List<String> response = new List<String>();
        try {
            // Send the request, and return a response
            HttpResponse res = h.send(req);
            response.add(res.getBody());
        }
        catch (Exception e) {
            response.add('error');
        }
        return response;
    }
    
    public class FlowData {
        @InvocableVariable(label = 'Loan Amount' required = true)
        public String loanAmount;
        @InvocableVariable(label = 'Relationship Exposure' required = true)
        public String relationshipExposure;
        @InvocableVariable(label = 'Credit Score' required = true)
        public String creditScore;
        @InvocableVariable(label = 'LTV' required = true)
        public String ltv;
        @InvocableVariable(label = 'URL Endpoint' required = true)
        public String endpointURL;
    }
}
global with sharing class NIQRemoter2 {
    private static String accessKeyId = 'AKIAJ7FLSJUZT5HZBDDQ';
	private static String secretKey = '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';
	private static String region = 'us-east-1';

	private final String ALGORITHM = 'AWS4-HMAC-SHA256';
	private final String SERVICE = 'execute-api';
	private final String CONTENT_TYPE = 'application/json';

	private String fakeAuthBody = '{"Authorization": "1234","botAlias": "niqdemo","botName": "NIQDEMO","inputText":"{0}","userId": "'+(100*Math.random()+1)+'","sessionAttributes": {}}';
    public String targetCloseDate {get;set;}
    private Date dateGrabber = null;
    public String projectedCloseDate {get;set;}
    public Id navigationId {get;set;}
    public String loanName {get;set;}
    
    public NIQRemoter2() {
        String builder = null;
        LLC_BI__Loan__c[] loans = [SELECT Name, Id, LLC_BI__CloseDate__c from LLC_BI__Loan__c where Name =: 'Port City Coffee - CRE Purchase2'];
		loanName = loans[0].Name;
        navigationId = loans[0].Id;
        dateGrabber = loans[0].LLC_BI__CloseDate__c;

        builder = '' + dateGrabber.month();
        builder = builder + '/' + dateGrabber.day();
        builder = builder + '/' + dateGrabber.year();
        targetCloseDate = builder;
        
        dateGrabber = dateGrabber.addDays(9);
        builder = '' + dateGrabber.month();
        builder = builder + '/' + dateGrabber.day();
        builder = builder + '/' + dateGrabber.year();
        projectedCloseDate = builder;
    }
    
    @RemoteAction
    global static String talk(String message) {
        String unauth = 'https://niq-sales.hosted.ncino.com/sales/Test';
        //URL authd = new URL('https://niq-lab.hosted.ncino.com/lab');
        
        Map<String,String> httpHeaders = new Map<String,String>{
			'Content-Type' => 'application/json'
		};
            
        Blob payload = Blob.valueOf(JSON.serialize(
                new Map<String,String>{
                    'sessionAttributes' => '{"tenant_id" => "DemoBank"}',
                        'userId' => 'nIQ-demo-user"',
                        'inputText' => message,
                        'botName' => 'NIQDEMO',
                        'botAlias' => 'niqdemo',
                        'Authorization' => '1234',
                        'retryOnMissedIntent' => 'false',
                        'logLevel' => 'DB'
                        }));
        
        //HttpRequest req = signedRequest('POST', unauth, httpHeaders, payload, false);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(unauth);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setBody('{"sessionAttributes": {"tenant_id": "Kickoff_Demo"}, "userId": "nIQ-00D1N000002tFcX", "inputText": "' + message + '","botName": "NIQDEMO", "botAlias": "niqdemo", "Authorization": "1234"}');
		
        Http http = new Http();
		HttpResponse response = http.send(req);
        System.debug(response.getStatusCode() + ' ---- ' + response.getStatus());

        if(response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            //I don't know enough about apex to make this work, but i'll return the message only for now
            return response.getBody();
        }
        return response.getStatusCode() + ' ---- ' + response.getStatus();
    }
    
    
    public static HttpRequest signedRequest(String method, URL endpoint, Map<String,String> headers, Blob payload, Boolean presign) {

        //defaults
        if (headers == null) headers = new Map<String,String>();
        if (payload == null) payload = Blob.valueOf('');
        if (presign == null) presign = false;

        //assemble

        String termination = 'aws4_request';
        String iso8601date = Datetime.now().formatGmt('YYYYMMdd');
        String iso8601time = Datetime.now().formatGmt('YYYYMMdd\'T\'HHmmss\'Z\'');
        String credentialScope = iso8601date + '/' + region + '/' + 'execute-api' + '/' + termination;

        //prepare headers
        headers.put('Host', endpoint.getHost());
        String signedHeaders = signedHeadersFor(headers);

		String specRequestEndpoint = '';
		specRequestEndpoint += endpoint.getProtocol() + '://';
		specRequestEndpoint += endpoint.getHost();
		specRequestEndpoint += rfc3986For(endpoint.getPath(), false);
		if (endpoint.getQuery() != null) {
			specRequestEndpoint += '?' + endpoint.getQuery();
		}

        //prepare parameters
        PageReference pr = new PageReference(specRequestEndpoint);
        Map<String,String> parameters = pr.getParameters();
        parameters.put('X-Amz-Algorithm', 'AWS4-HMAC-SHA256');
        parameters.put('X-Amz-Credential', accessKeyId + '/' + credentialScope);
        parameters.put('X-Amz-Date', iso8601time);
        parameters.put('X-Amz-Expires', '86400');
        parameters.put('X-Amz-SignedHeaders', signedHeaders);

        //Task 1: Create a Canonical Request for Signature Version 4
        //https://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
        String canonicalRequest = method.toUpperCase()
            + '\n' + canonicalUriFor(endpoint.toExternalForm())
            + '\n' + canonicalQueryStringFor(parameters)
            + '\n' + canonicalHeadersFor(headers)
            + '\n' + signedHeadersFor(headers)
            + '\n' + (presign ? 'UNSIGNED-PAYLOAD' : hexEncodedHashFor(payload));


		System.debug('cannonical request '+canonicalRequest);


        //Task 2: Create a String to Sign for Signature Version 4
        //https://docs.aws.amazon.com/general/latest/gr/sigv4-create-string-to-sign.html
        String algorithm = 'AWS4-HMAC-SHA256';
        String canonicalRequestHash = hexEncodedHashFor(Blob.valueOf(canonicalRequest));
        String stringToSign = algorithm + '\n' + iso8601time + '\n' + credentialScope + '\n' + canonicalRequestHash;

		System.debug('string to sign '+stringToSign);

        //Task 3: Calculate the AWS Signature Version 4
        //https://docs.aws.amazon.com/general/latest/gr/sigv4-calculate-signature.html
        Blob keySecret = Blob.valueOf('AWS4' + secretKey);
        Blob keyDate = Crypto.generateMac('hmacSHA256', Blob.valueOf(iso8601date), keySecret);
        Blob keyRegion = Crypto.generateMac('hmacSHA256', Blob.valueOf(region), keyDate);
        Blob keyService = Crypto.generateMac('hmacSHA256', Blob.valueOf('execute-api'), keyRegion);
        Blob keySigning = Crypto.generateMac('hmacSHA256', Blob.valueOf('aws4_request'), keyService);
        Blob blobToSign = Blob.valueOf(stringToSign);
        Blob hmac = Crypto.generateMac('hmacSHA256', blobToSign, keySigning);

        //Task 4: Add the Signing Information to the Request
        //https://docs.aws.amazon.com/general/latest/gr/sigv4-add-signature-to-request.html
        if (!presign) headers.put('X-Amz-Content-Sha256', hexEncodedHashFor(payload));
        String signature = EncodingUtil.convertToHex(hmac);
        parameters.put('X-Amz-Signature', signature);

        //prepare request
        HttpRequest request = new HttpRequest();
        request.setMethod(method);
		System.debug('Endpoint'+pr.getUrl());
        request.setEndpoint(pr.getUrl());
        if (payload != Blob.valueOf('')) request.setBodyAsBlob(payload); //affects http method
        for (String header : headers.keySet()) request.setHeader(header, headers.get(header));

        return request;
    }
    
    static String signedHeadersFor(Map<String,String> headers) {
        
        //lowercase header keys
        List<String> keys = new List<String>(headers.keySet());
        for (Integer i = 0; i < keys.size(); i++) keys.set(i, keys[i].toLowerCase());
        
        //sort ascii
        keys.sort();
        
        //prepare values
        List<String> signedHeaders = new List<String>();
        for (String key : keys) signedHeaders.add(key);
        
        return String.join(signedHeaders, ';');
    }
    
    static String hexEncodedHashFor(Blob data) {
        Blob hash = Crypto.generateDigest('SHA256', data);
        return EncodingUtil.convertToHex(hash);
    }

	static String canonicalUriFor(String endpoint) {
        Url uri = new Url(endpoint);
        return rfc3986For(uri.getPath(), false);
    }

	static String canonicalHeadersFor(Map<String,String> key2value) {
        
        //lowercase header keys
        Map<String,String> lower2value = new Map<String,String>();
        for (String key : key2value.keySet()) lower2value.put(key.toLowerCase(), key2value.get(key).trim().replaceAll('\\s+', ' '));
        
        //sort canonical keys by ascii code
        List<String> sortedKeys = new List<String>(lower2value.keySet());
        sortedKeys.sort();
        
        //prepare values
        List<String> canonicalHeaders = new List<String>();
        for (String sortedKey : sortedKeys) canonicalHeaders.add(sortedKey + ':' + lower2value.get(sortedKey) + '\n');
        
        return String.join(canonicalHeaders, '');
    }

    static String canonicalQueryStringFor(Map<String,String> parameters) {
        
        //sort keys by ascii code
        List<String> sortedKeys = new List<String>(parameters.keySet());
        sortedKeys.sort();
        
        //prepare values
        List<String> canonicalParameters = new List<String>();
        for (String sortedKey : sortedKeys) canonicalParameters.add(
            sortedKey + 
            '=' + 
            rfc3986For(parameters.get(sortedKey), true)
        );
        
        return String.join(canonicalParameters, '&');
    }



	static String rfc3986For(String characters, Boolean encodeSlash) {
        String result = '';
        for (Integer i = 0; i < characters.length(); i++) {
            String character = characters.substring(i, i + 1);
            
            if (
                (character >= 'A' && character <= 'Z') || 
                (character >= 'a' && character <= 'z') || 
                (character >= '0' && character <= '9') || 
                character == '_' || 
                character == '-' || 
                character == '~' || 
                character == '.'
            ) {
                result += character;
            } else if (character == '/') {
                result += encodeSlash ? '%2F' : character;
            } else {
                result += '%' + EncodingUtil.convertToHex(Blob.valueOf(character)).toUpperCase();
            }
        }
        
        return result;
    }
}
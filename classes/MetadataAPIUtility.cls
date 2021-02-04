global class MetadataAPIUtility{
   @remoteaction
  webservice static boolean createRemoteSiteSettings(){
        boolean isSucessfull=false;
      	List<Domain> newDomain = new List<Domain>();
      	newDomain = [SELECT Domain FROM Domain];
        System.debug('**********' + newDomain);
      	string domainString = String.valueOf(newDomain);
        string domainStringAfter = domainString.substringafter('Domain:{Domain=');
     System.debug('**********' + domainStringAfter);
        string domainStringBefore = 'https://' + domainStringAfter.substringbefore(',');
     System.debug('**********' + domainStringBefore);
      	string getURL = URL.getSalesforceBaseUrl().toExternalForm();
      	string getURLFinal = getURL.substringbefore('.cloudforce.com') + '--llc-bi.visualforce.com';
      	string getURLnForce = getURL.substringbefore('.cloudforce.com') + '--nforce.visualforce.com';
        string getURLnRetail = getURL.substringbefore('.cloudforce.com') + '--nretail.visualforce.com';
     	string getURLnMortgage = getURL.substringbefore('.cloudforce.com') + '--rmor.visualforce.com';
        Map<string,string> RemoteSiteMap = new Map<string,string>();
        //specify the remote site name and url in RemoteSiteMap
        RemoteSiteMap.put('Current_Community_Instance',domainStringBefore);
      	RemoteSiteMap.put('Current_Salesforce_Instance', URL.getSalesforceBaseUrl().toExternalForm());
      	RemoteSiteMap.put('Current_Salesforce_Instance_Visualforce',getURLfinal);
      	RemoteSiteMap.put('nforce_SalesForce_Instance_VisualForce', getURLnForce);
        RemoteSiteMap.put('Retail_Salesforce_Instance_Visualforce', getURLnRetail);
      	RemoteSiteMap.put('Mortgage_Salesforce_Instance_Visualforce', getURLnMortgage);
       //String PageURL1 = URL.getCurrentRequestUrl().toExternalForm();
        //RemoteSiteMap.put('Current_Salesforce_Instance',URL.getCurrentRequestUrl().toExternalForm());
        
      
      
        List<MetadataService.Metadata> allMetadataList = new List<MetadataService.Metadata>();
        for(string ss: RemoteSiteMap.keyset()){
            MetadataService.RemoteSiteSetting remoteSiteDetails = new MetadataService.RemoteSiteSetting();
            remoteSiteDetails.fullName = ss;
            remoteSiteDetails.description = ss+'-created through apex';
            remoteSiteDetails.disableProtocolSecurity  = false;
            remoteSiteDetails.isActive  = true;
            remoteSiteDetails.url=RemoteSiteMap.get(ss);
            allMetadataList.add(remoteSiteDetails);
        }        
        if(allMetadataList.size()>0){
            system.debug('****RemoteSiteSettings allMetadataList:'+allMetadataList);
            MetadataService.MetadataPort service = createService();
            List<MetadataService.UpsertResult> results = service.upsertMetadata(allMetadataList);
            for(MetadataService.UpsertResult result: results){
                    if(result.success){
                        system.debug('added remote site setting success='+result);
                        isSucessfull=true;
                    }else{
                        system.debug('****error while adding remote site settings:'+result.errors[0].message);
                    }

            }

        }
        return isSucessfull;
    }  
  
    private static MetadataService.MetadataPort createService(){ 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;     
    }
}
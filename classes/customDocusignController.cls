public class customDocusignController {
    
    private final LLC_BI__Loan__c myLoan;
    public String selectedDocco {get;set;}
    public List<docusignCollection> dscol {get;set;}
    
    public customDocusignController(ApexPages.StandardController stdController) {
        this.myLoan = (LLC_BI__Loan__c)stdController.getRecord();
        if(dscol == null) {
            dscol = customDocusignController();
        }
    }
    
    //Get the Entities and create the list for the table
    Public List <docusignCollection> customDocusignController(){
        List <docusignCollection> dscolList = new List<docusignCollection>();

        
        //GET INDIVIDUAL ENTITY INVOLVEMENT
        List<LLC_BI__Legal_Entities__c> lstEntities = [SELECT Id, LLC_BI__Account__c, LLC_BI__Account__r.name, LLC_BI__Borrower_Type__c
                                                       FROM LLC_BI__Legal_Entities__c
                                                       WHERE LLC_BI__Loan__c = :myLoan.Id
                                                       AND LLC_BI__Account__r.type = 'Individual'
                                                       ORDER BY LLC_BI__Borrower_Type__c ASC];        
        
        Map<String, Object> wrapper = new Map<String, Object>();
        List<Id> accIds = new List<Id>();
        
        for(LLC_BI__Legal_Entities__c l : lstEntities){
            Map<String, Object> info = new Map<String, Object>();
            info.put('name', l.LLC_BI__Account__r.name);
            info.put('borrowerType', l.LLC_BI__Borrower_Type__c);
            wrapper.put(l.LLC_BI__Account__c, info);
            accIds.add(l.LLC_BI__Account__c);
        }
        system.debug(wrapper);
        
        //GET EMAILS FROM THE CONTACT OBJECT
        List<Contact> cons = [SELECT Id, AccountId, Email
                              FROM Contact
                              WHERE LLC_BI__Primary_Contact__c = true AND AccountId IN : accIds];
        
        for(Integer i=0;i<cons.size();i++){
            if(cons[i].email != null)
                ((Map<String,Object>)wrapper.get(cons[i].accountId)).put('email', cons[i].email);    
            else{
                ((Map<String,Object>)wrapper.get(cons[i].accountId)).put('email', 'No Email Specified!');            
            }
        }
        
        // system.debug(wrapper);
            
        if(wrapper.size()>0){
            for(Id key : wrapper.keySet()){
                Map<string,object> innerMap = (Map<String,Object>)wrapper.get(key);
                system.debug(innerMap);
                docusignCollection dcIndBorrowers = new docusignCollection(
                                                                           (String)innerMap.get('name'), 
                                                                           (String)innerMap.get('email'), 
                                                                           (String)innerMap.get('borrowerType'),
                                                                           null,
                                                                           'Signer',
                                                                           (String)key);
                dscolList.add(dcIndBorrowers);
                innerMap.clear();
            }
        }
        
        
        //GET AUTHORIZED SIGNERS
        List<LLC_BI__Contingent_Liabilty__c> lstSigners = [SELECT Id, LLC_BI__Contact__r.name, LLC_BI__Contact__r.Email, LLC_BI__Entity__r.LLC_BI__Account__r.name, LLC_BI__Role__c, LLC_BI__Entity__r.LLC_BI__Borrower_Type__c
                                                           FROM LLC_BI__Contingent_Liabilty__c
                                                           WHERE LLC_BI__Entity__r.LLC_BI__Loan__c = :myLoan.Id];
        
        if(lstSigners.size()>0){
            for(Integer j=0;j<lstSigners.size();j++){
                docusignCollection dcAuthSigner = new docusignCollection(lstSigners[j].LLC_BI__Contact__r.name, 
                                                                         lstSigners[j].LLC_BI__Contact__r.Email, 
                                                                         lstSigners[j].LLC_BI__Entity__r.LLC_BI__Account__r.name + ' - ' + lstSigners[j].LLC_BI__Entity__r.LLC_BI__Borrower_Type__c +': '+ lstSigners[j].LLC_BI__Role__c,
                                                                         null,
                                                                         'Signer',
                                                                         lstSigners[j].LLC_BI__Contact__c);
                dscolList.add(dcAuthSigner);
            }
        }
        
        
        return dscolList;
    }
    
    
    //Get the Loan Docs Associated with this Loan
    Public List<Selectoption> getPlaceholders(){
        List<Selectoption> lstPlaceholders = new List<selectoption>();
        lstPlaceholders.add(new selectOption('', 'Select a Placeholder'));
        
        for(LLC_BI__LLC_LoanDocument__c lDoc :[SELECT Id, Name
                                               FROM LLC_BI__LLC_LoanDocument__c
                                               WHERE LLC_BI__Loan__c = :myLoan.Id
                                               AND NDOC__Is_Staged__c != true
                                               AND LLC_BI__reviewStatus__c = 'In-File'
                                               AND LLC_BI__attachmentId__c != null]){
                                                   
                                                   lstPlaceholders.add(new selectoption(lDoc.id, lDoc.name));
                                               }
        return lstPlaceholders; 
    }
    
    //Define List of options for Docusign
    Public List<Selectoption> getSignerRoles(){
        List<Selectoption> lstSignerRoles = new List<selectoption>();
        lstSignerRoles.add(new selectOption('', 'NA'));
        lstSignerRoles.add(new selectOption('Signer', 'Signer'));
        lstSignerRoles.add(new selectOption('Carbon Copy', 'Carbon Copy'));
        
        return lstSignerRoles; 
    }
    
    
    //BUTTON CLICK TO INVOKE FUTURE METHOD AND RETURN TO THE LOAN
    public PageReference sendToDocusign(){
        
        // Serialize the list
        String JSONString = JSON.serialize(dscol);
        sendToDocusignAsync(JSONString, selectedDocco, myLoan.id);
        
        //ADD A LOANDOC COMMENT
        //CHANGE THE REVIEW STATUS OF THE PLACEHOLDER
        //MAKE THE DOCUMENT SHOW IN THE E-SIG TAB IN DOCMAN
        
        LLC_BI__LLC_LoanDocComment__c ldCommentREQUEST = new LLC_BI__LLC_LoanDocComment__c();
        ldCommentREQUEST.LLC_BI__LLC_LoanDocument__c = selectedDocco;
        ldCommentREQUEST.LLC_BI__comment__c = 'Docusign Requested';
        insert ldCommentREQUEST;
        
        LLC_BI__LLC_LoanDocument__c ldToUpdate = new LLC_BI__LLC_LoanDocument__c();
        ldToUpdate.id = selectedDocco;
        ldToUpdate.LLC_BI__reviewStatus__c = 'E-Sig Pending';
        update ldToUpdate;
        
        LLC_BI__Document_Store__c ds = new LLC_BI__Document_Store__c();
        ds.id = [SELECT Id, LLC_BI__Document_Store_Index__r.LLC_BI__Document_Store__c
                 FROM LLC_BI__LLC_LoanDocument__c WHERE Id = :selectedDocco LIMIT 1].LLC_BI__Document_Store_Index__r.LLC_BI__Document_Store__c;
        ds.LLC_BI__Ready_For_Esignature__c = true;
        update ds;
        
        PageReference pageRef = new PageReference('/'+myLoan.id); 
        pageRef.setRedirect(true); 
        return pageRef;
    }   
    
    
    @future (callout=true)
    Public static void sendToDocusignAsync(String serializedDSCOL, String placeholderID, String LoanID){
        
        // Deserialize the list DSCOL
        List<docusignCollection> DSCOL = 
            (List<docusignCollection>)JSON.deserialize(serializedDSCOL, List<docusignCollection>.class);
        
        
        //GET THE PLACEHOLDER, LOAN, AND DOCSTORE INFO POPULATE THE DOCUMENT AND EMAIL METADATA AND USE LATER ON FOR THE DOC COLLECTION
        LLC_BI__LLC_LoanDocument__c placeholderRecord = [SELECT Id, Name, LLC_BI__Loan__r.Name, LLC_BI__attachmentId__c, LLC_BI__Document_Store_Index__r.LLC_BI__Document_Store__c
                                                         FROM LLC_BI__LLC_LoanDocument__c 
                                                         WHERE Id = :placeholderID];
        
        
        List<docusignCollection> signersList = new List<docusignCollection>();
        List<docusignCollection> carbonCopyList = new List<docusignCollection>();
        
        
        for(docusignCollection dsc : DSCOL){
            
            if(dsc.signerRole == 'Signer'){
                signersList.add(dsc);
            } 
            
            if(dsc.signerRole == 'Carbon Copy'){
                carbonCopyList.add(dsc);
            }
        }
        
        //SET THE SIGNER ORDER AUTOMATICALLY BASED ON THE INDEX IN THE SIGNERS LIST
        for(docusignCollection dscSigner : signersList){
            dscSigner.signerOrder = signersList.indexOf(dscSigner)+1;
        }
        
        // system.debug('**************signersList: ' + signersList);

        //COMPOSE THE PAYLOAD BODY
        Map<String,Object> baseLevel = new Map<String,Object>();
        
        List<Map<String,Object>> documents = new List<Map<String,Object>>();
        Map<String,Object> document = new Map<String,Object>();
        
        Map<String,Object> signersAndCarbonCopiesContainer = new Map<String,Object>();
        List<Map<String,Object>> signersAndCarbonCopies = new List<Map<String,Object>>();        
        
        Map<String,Object> signersContainer = new Map<String,Object>();
        List<Map<String,Object>> signers = new List<Map<String,Object>>();
        
        Map<String,Object> carbonCopiesContainer = new Map<String,Object>();
        List<Map<String,Object>> carbonCopies = new List<Map<String,Object>>();
        
        
        if(signersList.size() > 0){
            for(Integer i = 0;i<signersList.size();i++){
                Integer j = i+1;
                
                Map<String,Object> signer = new Map<String,Object>();
                Map<String,Object> tabsContainer = new Map<String,Object>();
                
                List<Map<String,Object>> signhereTabs = new List<Map<String,Object>>();
                List<Map<String,Object>> fullnameTabs = new List<Map<String,Object>>();
                List<Map<String,Object>> dateSignedTabs = new List<Map<String,Object>>();
                
                Map<String,Object> signHereTab = new Map<String,Object>();
                Map<String,Object> fullnameTab = new Map<String,Object>();
                Map<String,Object> dateSignedTab = new Map<String,Object>();
                
                signHereTab.put('anchorString', 's'+signersList[i].signerOrder);
                signHereTab.put('anchorXOffset', '0');
                signHereTab.put('anchorYOffset', '0');
                signHereTab.put('anchorIgnoreIfNotPresent', 'true');
                signHereTab.put('anchorUnits', 'mms');
                signheretabs.add(signHereTab);
                tabsContainer.put('signHereTabs', signheretabs);
                
                fullnametab.put('anchorString', 'n'+signersList[i].signerOrder);
                fullnametab.put('anchorXOffset', '0');
                fullnametab.put('anchorYOffset', '0');
                fullnametab.put('anchorIgnoreIfNotPresent', 'true');
                fullnametab.put('anchorUnits', 'mms');
                fullnametabs.add(fullnameTab);
                tabsContainer.put('fullnameTabs', fullnametabs);
                
                dateSignedTab.put('anchorString', 'd'+signersList[i].signerOrder);
                dateSignedTab.put('anchorXOffset', '0');
                dateSignedTab.put('anchorYOffset', '0');
                dateSignedTab.put('anchorIgnoreIfNotPresent', 'true');
                dateSignedTab.put('anchorUnits', 'mms');
                dateSignedTabs.add(dateSignedTab);
                tabsContainer.put('dateSignedTabs', dateSignedTabs);
                
                signer.put('email', signersList[i].email);
                signer.put('name', signersList[i].name);
                signer.put('recipientId', string.valueOf(j));   //NB - CANNOT USE THE RECORD ID OF THE RECIPIENTS FOR THE ID
                signer.put('routingOrder', signersList[i].signerOrder);
                signer.put('tabs', tabsContainer);
                
                signers.add(signer);             
                
            }
        }
        
        if(signersList.size() > 0 && carbonCopyList.size() > 0){
            Integer signersListSize = signersList.size()+1;
            Integer signersSizeAddOne = signersList.size() + 1;
            //NEED TO REWORK THIS - THE ROUTING ORDER IS ADDING AN ADDITIONAL EACH LOOP
            
            for(Integer k = 0;k<carbonCopyList.size();k++){
                Integer recipientIdAddition = signersSizeAddOne++;
                
                Map<String,Object> carbonCopy = new Map<String,Object>();
                
                carbonCopy.put('email', carbonCopyList[k].email);
                carbonCopy.put('name', carbonCopyList[k].name);
                carbonCopy.put('recipientId', String.valueOf(recipientIdAddition));
                carbonCopy.put('routingOrder', String.valueOf(signersListSize));
                
                carbonCopies.add(carbonCopy);
            }
            
            signersContainer.put('carbonCopies', carbonCopies);
        }
        
        
        signersContainer.put('signers', signers);
        //system.debug(JSON.serializePretty(signersContainer));
        
        String contentDoc = [SELECT Id, LatestPublishedVersionId FROM contentDocument WHERE Id = :placeholderRecord.LLC_BI__attachmentId__c LIMIT 1].LatestPublishedVersionId;
        Blob blobDocco = [SELECT id, VersionData FROM contentversion WHERE id = :contentDoc].VersionData;
        String stringOfDoc = EncodingUtil.base64Encode(blobDocco);
        
        document.put('documentId', '1');
        document.put('name', placeholderRecord.Name+'.pdf');
        document.put('documentBase64', stringOfDoc);
        documents.add(document);
        
        baseLevel.put('recipients', signersContainer);        
        baseLevel.put('documents', documents);
        baseLevel.put('status', 'sent');
        baseLevel.put('emailSubject', 'nCino Docusign required for '+placeholderRecord.Name);
        baseLevel.put('emailBlurb', 'Docusign for the nCino Application: '+placeholderRecord.LLC_BI__Loan__r.Name);
        


        //COMPILE AND SEND THE REQUEST 
        
        Map<String, DocuSignRESTSettings__mdt> settingsMap = new Map<String, DocuSignRESTSettings__mdt>();
        
        for (DocuSignRESTSettings__mdt setting : [Select DeveloperName,MasterLabel, Value__c from DocuSignRESTSettings__mdt]) {
                    settingsMap.put(setting.MasterLabel, setting);
                    }
        
                
        Map<String, String> returnValues = DocuSignRestUtility.getAccessTokenAndCalloutInfo();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(returnValues.get('RequestEnvelopeEndpoint')+returnValues.get('DSAccountID')+'/envelopes');
        //request.setEndpoint('https://demo.docusign.net/restapi/v2/accounts/1b6c055e-fbd6-401a-b7d8-b7e49504058c/envelopes');
        request.setMethod('POST');
        //set Authentication Header
        request.setHeader('grant_type', 'Bearer');
        request.setHeader('Authorization', 'Bearer ' + returnValues.get('access_token'));
        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-type', 'application/json');
        
        request.setBody(JSON.serialize(baseLevel));
        
        Http http = new Http();
        HTTPResponse res = http.send(request);
        System.debug(res.getBody());
        
        if(res.getStatusCode()==201){
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            String envelopeId = (String) results.get('envelopeId');
            String status = (String) results.get('status');
            
            // DML
            // NEW VERSION WITHOUT THE CUSTOM OBJECT    
            LLC_BI__Document_Collection__c dc = new LLC_BI__Document_Collection__c();
            dc.LLC_BI__Vendor_Collection_Id__c = envelopeId;
            dc.LLC_BI__Status__c = status;
            dc.LLC_BI__Type__c = 'Docusign';
            upsert dc;
            
            LLC_BI__Document_Collection_Index__c dci = new LLC_BI__Document_Collection_Index__c();
            dci.LLC_BI__Document_Store__c = placeholderRecord.LLC_BI__Document_Store_Index__r.LLC_BI__Document_Store__c;
            dci.LLC_BI__Document_Collection_Reference__c = dc.id;
            dci.LLC_BI__Document_Metadata__c = JSON.serialize(signersContainer);
            insert dci;
            
            LLC_BI__LLC_LoanDocComment__c ldCommentSUCCESS = new LLC_BI__LLC_LoanDocComment__c();
            ldCommentSUCCESS.LLC_BI__LLC_LoanDocument__c = placeholderRecord.id;
            ldCommentSUCCESS.LLC_BI__comment__c = 'Successfully Sent to Docusign';
            insert ldCommentSUCCESS;
            
        }
        
    }
    

    //Constructor for the wrapper
    public class docusignCollection{
        
        public String name {get; set;}
        public String email {get; set;}
        public String involvementType {get; set;}
        public Integer signerOrder {get; set;}
        public string signerRole {get; set;}
        public String signerId {get; set;}
        
        
        public docusignCollection(String name, String email, String involvementType, Integer signerOrder, String signerRole, String signerId) {
            this.name = name;
            this.email = email;
            this.involvementType = involvementType;
            this.signerOrder = signerOrder;
            this.signerRole = signerRole;
            this.signerId = signerId;
        }
    } 
}
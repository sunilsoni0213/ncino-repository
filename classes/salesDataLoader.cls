public class salesDataLoader {
    
    public String docStatus	{get; set;}
    
    public PageReference initDocMan() {
    	salesDataLoader.initLoan2();   
        salesDataLoader.initLoan3();
    	docStatus = 'Documents have been loaded into document manager for Kristin Shelton 1, 2, and 3';
        
        return null;
    }
    
       public static void initLoan2() {
        //Kristin Shelton2
        LLC_BI__Loan__c loan2 = [select Id, Name from LLC_BI__Loan__c where Name = 'Kristin Shelton2'];
        Date thisDay = date.Today();
        Date laterDay = date.newinstance(2013, 1, 18);
        
        //Personal Tax Return / BTR
        Document sourceDoc1 = [select Id, Body from Document where Name = 'Personal Tax Return'];
        Attachment ptrA = new Attachment();
        ptrA.Name = 'PTR.pdf';
        ptrA.Body = sourceDoc1.Body;
        ptrA.ContentType = 'pdf';
        ptrA.ParentId = loan2.Id;
        insert ptrA;
        
        List<LLC_BI__LLC_LoanDocument__c> ptrDocs = [select Name, Id, LLC_BI__mimeType__c, LLC_BI__attachmentId__c, LLC_BI__reviewStatus__c from LLC_BI__LLC_LoanDocument__c where Name like '%Tax%' and LLC_BI__Loan__r.Id =: loan2.Id];
        for(LLC_BI__LLC_LoanDocument__c doc : ptrDocs) {
            doc.LLC_BI__attachmentId__c = ptrA.Id;
            doc.LLC_BI__mimeType__c  = 'pdf';
            //doc.LLC_BI__comments__c = '('+thisDay+'2:44 PM) bryan.whittenton@demomaster.ncino.com: [In-File]';
            //doc.LLC_BI__reviewStatus__c = 'In-File';
        }
        update ptrDocs;
        
        //Document - Title Commitment
        Document sourceDoc2 = [select Id, Body from Document where Name = 'Title Commitment'];
        Attachment tcom = new Attachment();
        tcom.Name = 'TitleInsurance.pdf';
        tcom.Body = sourceDoc2.Body;
        tcom.ContentType ='pdf';
        tcom.ParentId = loan2.Id;
        insert tcom;
        
        List<LLC_BI__LLC_LoanDocument__c> titleCommits = [select Name, Id, LLC_BI__mimeType__c, LLC_BI__attachmentId__c, LLC_BI__reviewStatus__c from LLC_BI__LLC_LoanDocument__c where Name like '%Title%' and LLC_BI__Loan__r.Id =: loan2.Id];
        for(LLC_BI__LLC_LoanDocument__c doc : titleCommits) {
            doc.LLC_BI__attachmentId__c = tcom.Id;
            doc.LLC_BI__mimeType__c  = 'pdf';
        }
        update titleCommits;
        
        //Document - License
        Document sourceDoc3 = [select Id, Body from Document where Name = 'License'];
        Attachment licenseDoc = new Attachment();
        licenseDoc.Name = 'License.pdf';
        licenseDoc.Body = sourceDoc3.Body;
        licenseDoc.ContentType ='pdf';
        licenseDoc.ParentId = loan2.Id;
        insert licenseDoc;
        
        List<LLC_BI__LLC_LoanDocument__c> licenseList = [select Name, Id, LLC_BI__mimeType__c, LLC_BI__attachmentId__c, LLC_BI__reviewStatus__c from LLC_BI__LLC_LoanDocument__c where Name like '%Identification%' and LLC_BI__Loan__r.Id =: loan2.Id];
        for(LLC_BI__LLC_LoanDocument__c doc : licenseList) {
            doc.LLC_BI__attachmentId__c = licenseDoc.Id;
            doc.LLC_BI__mimeType__c  = 'pdf';
        }
        update licenseList;
        
        //Document - Articles of Incorporation
        Document sourceDoc4 = [select Id, Body from Document where Name = 'Articles of Incorporation'];
        Attachment articlesDoc = new Attachment();
        articlesDoc.Name = 'Articles.pdf';
        articlesDoc.Body = sourceDoc4.Body;
        articlesDoc.ContentType ='pdf';
        articlesDoc.ParentId = loan2.Id;
        insert articlesDoc;
        
        List<LLC_BI__LLC_LoanDocument__c> articlesList = [select Name, Id, LLC_BI__mimeType__c, LLC_BI__attachmentId__c, LLC_BI__reviewStatus__c from LLC_BI__LLC_LoanDocument__c where Name like '%Articles%' and LLC_BI__Loan__r.Id =: loan2.Id];
        for(LLC_BI__LLC_LoanDocument__c doc : articlesList) {
            doc.LLC_BI__attachmentId__c = articlesDoc.Id;
            doc.LLC_BI__mimeType__c  = 'pdf';
        }
        update articlesList;
        
        //Document - UCC Search
        Document sourceDoc5 = [select Id, Body from Document where Name = 'UCC'];
        Attachment uccDoc = new Attachment();
        uccDoc.Name = 'UCC.pdf';
        uccDoc.Body = sourceDoc5.Body;
        uccDoc.ContentType ='pdf';
        uccDoc.ParentId = loan2.Id;
        insert uccDoc;
        
        List<LLC_BI__LLC_LoanDocument__c> uccList = [select Name, Id, LLC_BI__mimeType__c, LLC_BI__attachmentId__c, LLC_BI__reviewStatus__c from LLC_BI__LLC_LoanDocument__c where Name like '%UCC%' and LLC_BI__Loan__r.Id =: loan2.Id];
        for(LLC_BI__LLC_LoanDocument__c doc : uccList) {
            doc.LLC_BI__attachmentId__c = uccDoc.Id;
            doc.LLC_BI__mimeType__c  = 'pdf';
            doc.LLC_BI__comments__c = '('+laterDay+'2:44 PM) bryan.whittenton@demomaster.ncino.com: [In-File]';
            doc.LLC_BI__reviewStatus__c = 'In-File';
        }
        update uccList;
        
        //Document - Proposal
        Document sourceDoc6 = [select Id, Body from Document where Name like '%Proposal%'];
        Attachment proposalDoc = new Attachment();
        proposalDoc.Name = 'Proposal.pdf';
        proposalDoc.Body = sourceDoc6.Body;
        proposalDoc.ContentType ='pdf';
        proposalDoc.ParentId = loan2.Id;
        insert proposalDoc;
        
        List<LLC_BI__LLC_LoanDocument__c> proposalList = [select Name, Id, LLC_BI__mimeType__c, LLC_BI__attachmentId__c, LLC_BI__reviewStatus__c from LLC_BI__LLC_LoanDocument__c where Name like '%Proposal%' and LLC_BI__Loan__r.Id =: loan2.Id];
        for(LLC_BI__LLC_LoanDocument__c doc : proposalList) {
            doc.LLC_BI__attachmentId__c = proposalDoc.Id;
            doc.LLC_BI__mimeType__c  = 'pdf';
            doc.LLC_BI__comments__c = '('+laterDay+'2:44 PM) bryan.whittenton@demomaster.ncino.com: [In-File]';
            doc.LLC_BI__reviewStatus__c = 'In-File';
        }
        update proposalList;
	}
    
    //Kristin Shelton 3
    public static void initLoan3() {
        LLC_BI__Loan__c loan2 = [select Id, Name from LLC_BI__Loan__c where Name like '%Shelton3%' and LLC_BI__Stage__c = 'Closed Funded'];
        Date thisDay = date.Today();
        Date laterDay = date.newinstance(2013, 1, 18);
        
        //Personal Tax Return / BTR
        Document sourceDoc1 = [select Id, Body from Document where Name = 'Personal Tax Return'];
        Attachment ptrA = new Attachment();
        ptrA.Name = 'PTR.pdf';
        ptrA.Body = sourceDoc1.Body;
        ptrA.ContentType = 'pdf';
        ptrA.ParentId = loan2.Id;
        insert ptrA;
        
        List<LLC_BI__LLC_LoanDocument__c> ptrDocs = [select Name, Id, LLC_BI__mimeType__c, LLC_BI__attachmentId__c, LLC_BI__reviewStatus__c from LLC_BI__LLC_LoanDocument__c where Name like '%Tax%' and LLC_BI__Loan__r.Id =: loan2.Id];
        for(LLC_BI__LLC_LoanDocument__c doc : ptrDocs) {
            doc.LLC_BI__attachmentId__c = ptrA.Id;
            doc.LLC_BI__mimeType__c  = 'pdf';
            doc.LLC_BI__comments__c = '('+laterDay+'2:44 PM) bryan.whittenton@demomaster.ncino.com: [Approved]';
            doc.LLC_BI__reviewStatus__c = 'Approved';
        }
        update ptrDocs;
        
        //Document - Title Commitment
        Document sourceDoc2 = [select Id, Body from Document where Name = 'Title Commitment'];
        Attachment tcom = new Attachment();
        tcom.Name = 'TitleInsurance.pdf';
        tcom.Body = sourceDoc2.Body;
        tcom.ContentType ='pdf';
        tcom.ParentId = loan2.Id;
        insert tcom;
        
        List<LLC_BI__LLC_LoanDocument__c> titleCommits = [select Name, Id, LLC_BI__mimeType__c, LLC_BI__attachmentId__c, LLC_BI__reviewStatus__c from LLC_BI__LLC_LoanDocument__c where Name like '%Title%' and LLC_BI__Loan__r.Id =: loan2.Id];
        for(LLC_BI__LLC_LoanDocument__c doc : titleCommits) {
            doc.LLC_BI__attachmentId__c = tcom.Id;
            doc.LLC_BI__mimeType__c  = 'pdf';
            doc.LLC_BI__comments__c = '('+laterDay+'2:44 PM) bryan.whittenton@demomaster.ncino.com: [In-File]';
            doc.LLC_BI__reviewStatus__c = 'In-File';
        }
        update titleCommits;
        
        //Document - License
        Document sourceDoc3 = [select Id, Body from Document where Name = 'License'];
        Attachment licenseDoc = new Attachment();
        licenseDoc.Name = 'License.pdf';
        licenseDoc.Body = sourceDoc3.Body;
        licenseDoc.ContentType ='pdf';
        licenseDoc.ParentId = loan2.Id;
        insert licenseDoc;
        
        List<LLC_BI__LLC_LoanDocument__c> licenseList = [select Name, Id, LLC_BI__mimeType__c, LLC_BI__attachmentId__c, LLC_BI__reviewStatus__c from LLC_BI__LLC_LoanDocument__c where Name like '%Identification%' and LLC_BI__Loan__r.Id =: loan2.Id];
        for(LLC_BI__LLC_LoanDocument__c doc : licenseList) {
            doc.LLC_BI__attachmentId__c = licenseDoc.Id;
            doc.LLC_BI__mimeType__c  = 'pdf';
            //doc.LLC_BI__comments__c = '('+thisDay+'2:44 PM) bryan.whittenton@demomaster.ncino.com: [Exception] Please see if you can make a copy that is easier to read.';
            doc.LLC_BI__reviewStatus__c = 'Exception';
            doc.LLC_BI__exceptionDate__c = thisDay;
        }
        update licenseList;
        
        //Document - Articles of Incorporation
        Document sourceDoc4 = [select Id, Body from Document where Name = 'Articles of Incorporation'];
        Attachment articlesDoc = new Attachment();
        articlesDoc.Name = 'Articles.pdf';
        articlesDoc.Body = sourceDoc4.Body;
        articlesDoc.ContentType ='pdf';
        articlesDoc.ParentId = loan2.Id;
        insert articlesDoc;
        
        List<LLC_BI__LLC_LoanDocument__c> articlesList = [select Name, Id, LLC_BI__mimeType__c, LLC_BI__attachmentId__c, LLC_BI__reviewStatus__c from LLC_BI__LLC_LoanDocument__c where Name like '%Articles%' and LLC_BI__Loan__r.Id =: loan2.Id];
        for(LLC_BI__LLC_LoanDocument__c doc : articlesList) {
            doc.LLC_BI__attachmentId__c = articlesDoc.Id;
            doc.LLC_BI__mimeType__c  = 'pdf';
            doc.LLC_BI__comments__c = '('+laterDay+'2:44 PM) bryan.whittenton@demomaster.ncino.com: [In-File]';
            doc.LLC_BI__reviewStatus__c = 'In-File';
        }
        update articlesList;
        
        //Document - UCC Search
        Document sourceDoc5 = [select Id, Body from Document where Name = 'UCC'];
        Attachment uccDoc = new Attachment();
        uccDoc.Name = 'UCC.pdf';
        uccDoc.Body = sourceDoc5.Body;
        uccDoc.ContentType ='pdf';
        uccDoc.ParentId = loan2.Id;
        insert uccDoc;
        
        List<LLC_BI__LLC_LoanDocument__c> uccList = [select Name, Id, LLC_BI__mimeType__c, LLC_BI__attachmentId__c, LLC_BI__reviewStatus__c from LLC_BI__LLC_LoanDocument__c where Name like '%UCC%' and LLC_BI__Loan__r.Id =: loan2.Id];
        for(LLC_BI__LLC_LoanDocument__c doc : uccList) {
            doc.LLC_BI__attachmentId__c = uccDoc.Id;
            doc.LLC_BI__mimeType__c  = 'pdf';
            doc.LLC_BI__comments__c = '('+laterDay+'2:44 PM) bryan.whittenton@demomaster.ncino.com: [In-File]';
            doc.LLC_BI__reviewStatus__c = 'In-File';
        }
        update uccList;
        
        //Document - Proposal
        Document sourceDoc6 = [select Id, Body from Document where Name like '%Proposal%'];
        Attachment proposalDoc = new Attachment();
        proposalDoc.Name = 'Proposal.pdf';
        proposalDoc.Body = sourceDoc6.Body;
        proposalDoc.ContentType ='pdf';
        proposalDoc.ParentId = loan2.Id;
        insert proposalDoc;
        
        List<LLC_BI__LLC_LoanDocument__c> proposalList = [select Name, Id, LLC_BI__mimeType__c, LLC_BI__attachmentId__c, LLC_BI__reviewStatus__c from LLC_BI__LLC_LoanDocument__c where Name like '%Proposal%' and LLC_BI__Loan__r.Id =: loan2.Id];
        for(LLC_BI__LLC_LoanDocument__c doc : proposalList) {
            doc.LLC_BI__attachmentId__c = proposalDoc.Id;
            doc.LLC_BI__mimeType__c  = 'pdf';
            doc.LLC_BI__comments__c = '('+laterDay+'2:44 PM) bryan.whittenton@demomaster.ncino.com: [In-File]';
            doc.LLC_BI__reviewStatus__c = 'In-File';
        }
        update proposalList; 
    }
    
    //*****
    //Stage History
    //*****
    
    public String historyStatus	{get; set;}
    
    public PageReference initAllHistory() {
    	salesDataLoader.initHistory1();
        salesDataLoader.initHistory2();
        salesDataLoader.initHistory3();
    	historyStatus = 'Kristin Shelton Loans 1, 2, and 3 have had their history loaded.';    
        return null;
    }
    
    public static void initHistory1() {
        LLC_BI__Loan__c loan2 = [select Id, Name from LLC_BI__Loan__c where Name = 'Kristin Shelton1'];
        Datetime thisDayTime = datetime.newinstance(2013, 1, 1, 9, 20, 0);
    
        LLC_BI__Opportunity_History__c hist1 = new LLC_BI__Opportunity_History__c();
        hist1.LLC_BI__Loan__c = loan2.Id;
        hist1.LLC_BI__OpportunityId__c = loan2.Id;
        hist1.LLC_BI__Amount__c = 700000;
        hist1.LLC_BI__StageName__c = 'Qualification';
        hist1.LLC_BI__StatusName__c = 'Open';
        hist1.LLC_BI__User__c = UserInfo.getUserId();
        hist1.LLC_BI__Stage_Change__c = true;
        hist1.LLC_BI__Change_Time__c = thisDayTime; 		//start time
        hist1.LLC_BI__End_Time__c = thisDayTime;			//end time
        insert hist1;
        
        LLC_BI__Opportunity_History__c hist2 = new LLC_BI__Opportunity_History__c();
        hist2.LLC_BI__Loan__c = loan2.Id;
        hist2.LLC_BI__OpportunityId__c = loan2.Id;
        hist2.LLC_BI__Amount__c = 792000;
        hist2.LLC_BI__StageName__c = 'Qualification';
        hist2.LLC_BI__StatusName__c = 'Open';
        hist2.LLC_BI__User__c = UserInfo.getUserId();
        hist2.LLC_BI__Stage_Change__c = false;
        hist2.LLC_BI__Change_Time__c = thisDayTime.addHours(4);
        insert hist2;
    }
    
    public static void initHistory2() {
        LLC_BI__Loan__c loan2 = [select Id, Name from LLC_BI__Loan__c where Name = 'Kristin Shelton2'];
        Datetime thisDayTime = datetime.newinstance(2013, 1, 1, 9, 20, 0);
    
        LLC_BI__Opportunity_History__c hist1 = new LLC_BI__Opportunity_History__c();
        hist1.LLC_BI__Loan__c = loan2.Id;
        hist1.LLC_BI__OpportunityId__c = loan2.Id;
        hist1.LLC_BI__Amount__c = 700000;
        hist1.LLC_BI__StageName__c = 'Qualification';
        hist1.LLC_BI__StatusName__c = 'Open';
        hist1.LLC_BI__User__c = UserInfo.getUserId();
        hist1.LLC_BI__Stage_Change__c = true;
        hist1.LLC_BI__Change_Time__c = thisDayTime; 		//start time
        hist1.LLC_BI__End_Time__c = thisDayTime;			//end time
        insert hist1;
        
        LLC_BI__Opportunity_History__c hist2 = new LLC_BI__Opportunity_History__c();
        hist2.LLC_BI__Loan__c = loan2.Id;
        hist2.LLC_BI__OpportunityId__c = loan2.Id;
        hist2.LLC_BI__Amount__c = 792000;
        hist2.LLC_BI__StageName__c = 'Qualification';
        hist2.LLC_BI__StatusName__c = 'Open';
        hist2.LLC_BI__User__c = UserInfo.getUserId();
        hist2.LLC_BI__Stage_Change__c = false;
        hist2.LLC_BI__Change_Time__c = thisDayTime.addHours(4);
        hist2.LLC_BI__End_Time__c = thisDayTime.addHours(4);
        insert hist2;
        
        LLC_BI__Opportunity_History__c hist3 = new LLC_BI__Opportunity_History__c();
        hist3.LLC_BI__Loan__c = loan2.Id;
        hist3.LLC_BI__OpportunityId__c = loan2.Id;
        hist3.LLC_BI__Amount__c = 792000;
        hist3.LLC_BI__StageName__c = 'Credit Analysis';
        hist3.LLC_BI__StatusName__c = 'Open';
        hist3.LLC_BI__User__c = UserInfo.getUserId();
        hist3.LLC_BI__Stage_Change__c = true;
        hist3.LLC_BI__Change_Time__c = thisDayTime.addHours(4);
        hist3.LLC_BI__End_Time__c = thisDayTime.addDays(4);
        insert hist3;
        
        LLC_BI__Opportunity_History__c hist4 = new LLC_BI__Opportunity_History__c();
        hist4.LLC_BI__Loan__c = loan2.Id;
        hist4.LLC_BI__OpportunityId__c = loan2.Id;
        hist4.LLC_BI__Amount__c = 792000;
        hist4.LLC_BI__StageName__c = 'Proposal';
        hist4.LLC_BI__StatusName__c = 'Open';
        hist4.LLC_BI__User__c = UserInfo.getUserId();
        hist4.LLC_BI__Stage_Change__c = true;
        hist4.LLC_BI__Change_Time__c = thisDayTime.addDays(4);
        hist4.LLC_BI__End_Time__c = thisDayTime.addDays(6);
        insert hist4;
        
        LLC_BI__Opportunity_History__c hist5 = new LLC_BI__Opportunity_History__c();
        hist5.LLC_BI__Loan__c = loan2.Id;
        hist5.LLC_BI__OpportunityId__c = loan2.Id;
        hist5.LLC_BI__Amount__c = 792000;
        hist5.LLC_BI__StageName__c = 'Loan Committee';
        hist5.LLC_BI__StatusName__c = 'Open';
        hist5.LLC_BI__User__c = UserInfo.getUserId();
        hist5.LLC_BI__Stage_Change__c = true;
        hist5.LLC_BI__Change_Time__c = thisDayTime.addDays(6);
        hist5.LLC_BI__End_Time__c = thisDayTime.addDays(8);
        insert hist5;
        
        LLC_BI__Opportunity_History__c hist6 = new LLC_BI__Opportunity_History__c();
        hist6.LLC_BI__Loan__c = loan2.Id;
        hist6.LLC_BI__OpportunityId__c = loan2.Id;
        hist6.LLC_BI__Amount__c = 792000;
        hist6.LLC_BI__StageName__c = 'Processing';
        hist6.LLC_BI__StatusName__c = 'Open';
        hist6.LLC_BI__User__c = UserInfo.getUserId();
        hist6.LLC_BI__Stage_Change__c = true;
        hist6.LLC_BI__Change_Time__c = thisDayTime.addDays(8);
        hist6.LLC_BI__End_Time__c = thisDayTime.addDays(13);
        insert hist6;
        
        LLC_BI__Opportunity_History__c hist7 = new LLC_BI__Opportunity_History__c();
        hist7.LLC_BI__Loan__c = loan2.Id;
        hist7.LLC_BI__OpportunityId__c = loan2.Id;
        hist7.LLC_BI__Amount__c = 792000;
        hist7.LLC_BI__StageName__c = 'Doc Prep';
        hist7.LLC_BI__StatusName__c = 'Open';
        hist7.LLC_BI__User__c = UserInfo.getUserId();
        hist7.LLC_BI__Stage_Change__c = true;
        hist7.LLC_BI__Change_Time__c = thisDayTime.addDays(12);
        hist7.LLC_BI__End_Time__c = thisDayTime.addDays(14);
        insert hist7;
        
        LLC_BI__Opportunity_History__c hist8 = new LLC_BI__Opportunity_History__c();
        hist8.LLC_BI__Loan__c = loan2.Id;
        hist8.LLC_BI__OpportunityId__c = loan2.Id;
        hist8.LLC_BI__Amount__c = 792000;
        hist8.LLC_BI__StageName__c = 'Doc Review';
        hist8.LLC_BI__StatusName__c = 'Open';
        hist8.LLC_BI__User__c = UserInfo.getUserId();
        hist8.LLC_BI__Stage_Change__c = true;
        hist8.LLC_BI__Change_Time__c = thisDayTime.addDays(14);
        hist8.LLC_BI__End_Time__c = thisDayTime.addDays(16);
        insert hist8;
        
        LLC_BI__Opportunity_History__c hist9 = new LLC_BI__Opportunity_History__c();
        hist9.LLC_BI__Loan__c = loan2.Id;
        hist9.LLC_BI__OpportunityId__c = loan2.Id;
        hist9.LLC_BI__Amount__c = 792000;
        hist9.LLC_BI__StageName__c = 'Closing';
        hist9.LLC_BI__StatusName__c = 'Open';
        hist9.LLC_BI__User__c = UserInfo.getUserId();
        hist9.LLC_BI__Stage_Change__c = true;
        hist9.LLC_BI__Change_Time__c = thisDayTime.addDays(16);
        //hist9.LLC_BI__End_Time__c = thisDayTime.addDays(16);
        insert hist9;
    }
    
    public static void initHistory3() {
        LLC_BI__Loan__c loan2 = [select Id, Name from LLC_BI__Loan__c where Name like '%Shelton3%' and LLC_BI__Stage__c = 'Closed Funded'];
        Datetime thisDayTime = datetime.newinstance(2013, 1, 1, 9, 20, 0);
    
        LLC_BI__Opportunity_History__c hist1 = new LLC_BI__Opportunity_History__c();
        hist1.LLC_BI__Loan__c = loan2.Id;
        hist1.LLC_BI__OpportunityId__c = loan2.Id;
        hist1.LLC_BI__Amount__c = 700000;
        hist1.LLC_BI__StageName__c = 'Qualification';
        hist1.LLC_BI__StatusName__c = 'Open';
        hist1.LLC_BI__User__c = UserInfo.getUserId();
        hist1.LLC_BI__Stage_Change__c = true;
        hist1.LLC_BI__Change_Time__c = thisDayTime; 		//start time
        hist1.LLC_BI__End_Time__c = thisDayTime;			//end time
        insert hist1;
        
        LLC_BI__Opportunity_History__c hist2 = new LLC_BI__Opportunity_History__c();
        hist2.LLC_BI__Loan__c = loan2.Id;
        hist2.LLC_BI__OpportunityId__c = loan2.Id;
        hist2.LLC_BI__Amount__c = 792000;
        hist2.LLC_BI__StageName__c = 'Qualification';
        hist2.LLC_BI__StatusName__c = 'Open';
        hist2.LLC_BI__User__c = UserInfo.getUserId();
        hist2.LLC_BI__Stage_Change__c = false;
        hist2.LLC_BI__Change_Time__c = thisDayTime.addHours(4);
        hist2.LLC_BI__End_Time__c = thisDayTime.addHours(4);
        insert hist2;
        
        LLC_BI__Opportunity_History__c hist3 = new LLC_BI__Opportunity_History__c();
        hist3.LLC_BI__Loan__c = loan2.Id;
        hist3.LLC_BI__OpportunityId__c = loan2.Id;
        hist3.LLC_BI__Amount__c = 792000;
        hist3.LLC_BI__StageName__c = 'Credit Analysis';
        hist3.LLC_BI__StatusName__c = 'Open';
        hist3.LLC_BI__User__c = UserInfo.getUserId();
        hist3.LLC_BI__Stage_Change__c = true;
        hist3.LLC_BI__Change_Time__c = thisDayTime.addHours(4);
        hist3.LLC_BI__End_Time__c = thisDayTime.addDays(4);
        insert hist3;
        
        LLC_BI__Opportunity_History__c hist4 = new LLC_BI__Opportunity_History__c();
        hist4.LLC_BI__Loan__c = loan2.Id;
        hist4.LLC_BI__OpportunityId__c = loan2.Id;
        hist4.LLC_BI__Amount__c = 792000;
        hist4.LLC_BI__StageName__c = 'Proposal';
        hist4.LLC_BI__StatusName__c = 'Open';
        hist4.LLC_BI__User__c = UserInfo.getUserId();
        hist4.LLC_BI__Stage_Change__c = true;
        hist4.LLC_BI__Change_Time__c = thisDayTime.addDays(4);
        hist4.LLC_BI__End_Time__c = thisDayTime.addDays(6);
        insert hist4;
        
        LLC_BI__Opportunity_History__c hist5 = new LLC_BI__Opportunity_History__c();
        hist5.LLC_BI__Loan__c = loan2.Id;
        hist5.LLC_BI__OpportunityId__c = loan2.Id;
        hist5.LLC_BI__Amount__c = 792000;
        hist5.LLC_BI__StageName__c = 'Loan Committee';
        hist5.LLC_BI__StatusName__c = 'Open';
        hist5.LLC_BI__User__c = UserInfo.getUserId();
        hist5.LLC_BI__Stage_Change__c = true;
        hist5.LLC_BI__Change_Time__c = thisDayTime.addDays(6);
        hist5.LLC_BI__End_Time__c = thisDayTime.addDays(8);
        insert hist5;
        
        LLC_BI__Opportunity_History__c hist6 = new LLC_BI__Opportunity_History__c();
        hist6.LLC_BI__Loan__c = loan2.Id;
        hist6.LLC_BI__OpportunityId__c = loan2.Id;
        hist6.LLC_BI__Amount__c = 792000;
        hist6.LLC_BI__StageName__c = 'Processing';
        hist6.LLC_BI__StatusName__c = 'Open';
        hist6.LLC_BI__User__c = UserInfo.getUserId();
        hist6.LLC_BI__Stage_Change__c = true;
        hist6.LLC_BI__Change_Time__c = thisDayTime.addDays(8);
        hist6.LLC_BI__End_Time__c = thisDayTime.addDays(13);
        insert hist6;
        
        LLC_BI__Opportunity_History__c hist7 = new LLC_BI__Opportunity_History__c();
        hist7.LLC_BI__Loan__c = loan2.Id;
        hist7.LLC_BI__OpportunityId__c = loan2.Id;
        hist7.LLC_BI__Amount__c = 792000;
        hist7.LLC_BI__StageName__c = 'Doc Prep';
        hist7.LLC_BI__StatusName__c = 'Open';
        hist7.LLC_BI__User__c = UserInfo.getUserId();
        hist7.LLC_BI__Stage_Change__c = true;
        hist7.LLC_BI__Change_Time__c = thisDayTime.addDays(12);
        hist7.LLC_BI__End_Time__c = thisDayTime.addDays(14);
        insert hist7;
        
        LLC_BI__Opportunity_History__c hist8 = new LLC_BI__Opportunity_History__c();
        hist8.LLC_BI__Loan__c = loan2.Id;
        hist8.LLC_BI__OpportunityId__c = loan2.Id;
        hist8.LLC_BI__Amount__c = 792000;
        hist8.LLC_BI__StageName__c = 'Doc Review';
        hist8.LLC_BI__StatusName__c = 'Open';
        hist8.LLC_BI__User__c = UserInfo.getUserId();
        hist8.LLC_BI__Stage_Change__c = true;
        hist8.LLC_BI__Change_Time__c = thisDayTime.addDays(14);
        hist8.LLC_BI__End_Time__c = thisDayTime.addDays(16);
        insert hist8;
        
        LLC_BI__Opportunity_History__c hist9 = new LLC_BI__Opportunity_History__c();
        hist9.LLC_BI__Loan__c = loan2.Id;
        hist9.LLC_BI__OpportunityId__c = loan2.Id;
        hist9.LLC_BI__Amount__c = 792000;
        hist9.LLC_BI__StageName__c = 'Closing';
        hist9.LLC_BI__StatusName__c = 'Open';
        hist9.LLC_BI__User__c = UserInfo.getUserId();
        hist9.LLC_BI__Stage_Change__c = true;
        hist9.LLC_BI__Change_Time__c = thisDayTime.addDays(16);
        hist9.LLC_BI__End_Time__c = thisDayTime.addDays(19);
        insert hist9;
        
        LLC_BI__Opportunity_History__c hist10 = new LLC_BI__Opportunity_History__c();
        hist10.LLC_BI__Loan__c = loan2.Id;
        hist10.LLC_BI__OpportunityId__c = loan2.Id;
        hist10.LLC_BI__Amount__c = 792000;
        hist10.LLC_BI__StageName__c = 'Closed Funded';
        hist10.LLC_BI__StatusName__c = 'Open';
        hist10.LLC_BI__User__c = UserInfo.getUserId();
        hist10.LLC_BI__Stage_Change__c = true;
        hist10.LLC_BI__Change_Time__c = thisDayTime.addDays(19);
        hist10.LLC_BI__End_Time__c = thisDayTime.addDays(19);
        insert hist10;
    }
}
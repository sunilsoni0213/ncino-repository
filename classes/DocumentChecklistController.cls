public with sharing class DocumentChecklistController {

	public ApexPages.StandardController stdCtrl {get; set;}
    public Boolean refreshPage {get; set;}
    public Id loanID {get;set;}

	public DocumentChecklistController(ApexPages.StandardController controller) {
        stdCtrl=controller;
        refreshPage=true;

        loanID = controller.getId();
    }

    Public String getNumberApproved() {
    	String num;

    	AggregateResult[] groupedResults1 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Approved' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Borrower Details' ];
    		Decimal thenewnum1 = (Decimal)groupedResults1[0].get('TheNum');

    	AggregateResult[] groupedResults2 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Approved' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Entity Docs' ];
    		Decimal thenewnum2 = (Decimal)groupedResults2[0].get('TheNum');

    	AggregateResult[] groupedResults3 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Approved' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Insurance' ];
    		Decimal thenewnum3 = (Decimal)groupedResults3[0].get('TheNum');

    	AggregateResult[] groupedResults4 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Approved' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Other' ];
    		Decimal thenewnum4 = (Decimal)groupedResults4[0].get('TheNum');

    	AggregateResult[] groupedResults5 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Approved' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Real Estate' ];
    		Decimal thenewnum5 = (Decimal)groupedResults5[0].get('TheNum');

    	AggregateResult[] groupedResults6 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Approved' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Underwriting' ];
    		Decimal thenewnum6 = (Decimal)groupedResults6[0].get('TheNum');

    	AggregateResult[] groupedResults7 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Approved' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Coporate' ];
    		Decimal thenewnum7 = (Decimal)groupedResults7[0].get('TheNum');

    	AggregateResult[] groupedResults8 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Approved' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Financials' ];
    		Decimal thenewnum8 = (Decimal)groupedResults8[0].get('TheNum');

    	AggregateResult[] groupedResults9 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Approved' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Leases' ];
    		Decimal thenewnum9 = (Decimal)groupedResults9[0].get('TheNum');

    	AggregateResult[] groupedResults10 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Approved' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Purchase Contracts' ];
    		Decimal thenewnum10 = (Decimal)groupedResults10[0].get('TheNum');

    	AggregateResult[] groupedResults11 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Approved' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'UCC' ];
    		Decimal thenewnum11 = (Decimal)groupedResults11[0].get('TheNum');

    	AggregateResult[] groupedResults12 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Approved' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Unused' ];
    		Decimal thenewnum12 = (Decimal)groupedResults12[0].get('TheNum');

    		num = thenewnum1 + ',' + thenewnum2 + ',' + thenewnum3 + ',' + thenewnum4 + ',' + thenewnum5 + ',' + thenewnum6 + ',' + thenewnum7 + ',' + thenewnum8 + ',' + thenewnum9 + ',' + thenewnum10 + ',' + thenewnum11 + ',' + thenewnum12;

    	return num;
    }

    Public String getNumberReviewed() {
    	String num;

    	AggregateResult[] groupedResults1 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Reviewed' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Borrower Details' ];
    		Decimal thenewnum1 = (Decimal)groupedResults1[0].get('TheNum');

    	AggregateResult[] groupedResults2 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Reviewed' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Entity Docs' ];
    		Decimal thenewnum2 = (Decimal)groupedResults2[0].get('TheNum');

    	AggregateResult[] groupedResults3 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Reviewed' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Insurance' ];
    		Decimal thenewnum3 = (Decimal)groupedResults3[0].get('TheNum');

    	AggregateResult[] groupedResults4 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Reviewed' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Other' ];
    		Decimal thenewnum4 = (Decimal)groupedResults4[0].get('TheNum');

    	AggregateResult[] groupedResults5 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Reviewed' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Real Estate' ];
    		Decimal thenewnum5 = (Decimal)groupedResults5[0].get('TheNum');

    	AggregateResult[] groupedResults6 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Reviewed' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Underwriting' ];
    		Decimal thenewnum6 = (Decimal)groupedResults6[0].get('TheNum');

    	AggregateResult[] groupedResults7 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Reviewed' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Coporate' ];
    		Decimal thenewnum7 = (Decimal)groupedResults7[0].get('TheNum');

    	AggregateResult[] groupedResults8 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Reviewed' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Financials' ];
    		Decimal thenewnum8 = (Decimal)groupedResults8[0].get('TheNum');

    	AggregateResult[] groupedResults9 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Reviewed' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Leases' ];
    		Decimal thenewnum9 = (Decimal)groupedResults9[0].get('TheNum');

    	AggregateResult[] groupedResults10 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Reviewed' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Purchase Contracts' ];
    		Decimal thenewnum10 = (Decimal)groupedResults10[0].get('TheNum');

    	AggregateResult[] groupedResults11 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Reviewed' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'UCC' ];
    		Decimal thenewnum11 = (Decimal)groupedResults11[0].get('TheNum');

    	AggregateResult[] groupedResults12 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Reviewed' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Unused' ];
    		Decimal thenewnum12 = (Decimal)groupedResults12[0].get('TheNum');

    		num = thenewnum1 + ',' + thenewnum2 + ',' + thenewnum3 + ',' + thenewnum4 + ',' + thenewnum5 + ',' + thenewnum6 + ',' + thenewnum7 + ',' + thenewnum8 + ',' + thenewnum9 + ',' + thenewnum10 + ',' + thenewnum11 + ',' + thenewnum12;

    	return num;
    }

    Public String getNumberInFile() {
    	String num;

    	AggregateResult[] groupedResults1 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'In-File' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Borrower Details' ];
    		Decimal thenewnum1 = (Decimal)groupedResults1[0].get('TheNum');

    	AggregateResult[] groupedResults2 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'In-File' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Entity Docs' ];
    		Decimal thenewnum2 = (Decimal)groupedResults2[0].get('TheNum');

    	AggregateResult[] groupedResults3 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'In-File' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Insurance' ];
    		Decimal thenewnum3 = (Decimal)groupedResults3[0].get('TheNum');

    	AggregateResult[] groupedResults4 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'In-File' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Other' ];
    		Decimal thenewnum4 = (Decimal)groupedResults4[0].get('TheNum');

    	AggregateResult[] groupedResults5 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'In-File' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Real Estate' ];
    		Decimal thenewnum5 = (Decimal)groupedResults5[0].get('TheNum');

    	AggregateResult[] groupedResults6 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'In-File' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Underwriting' ];
    		Decimal thenewnum6 = (Decimal)groupedResults6[0].get('TheNum');

    	AggregateResult[] groupedResults7 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'In-File' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Coporate' ];
    		Decimal thenewnum7 = (Decimal)groupedResults7[0].get('TheNum');

    	AggregateResult[] groupedResults8 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'In-File' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Financials' ];
    		Decimal thenewnum8 = (Decimal)groupedResults8[0].get('TheNum');

    	AggregateResult[] groupedResults9 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'In-File' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Leases' ];
    		Decimal thenewnum9 = (Decimal)groupedResults9[0].get('TheNum');

    	AggregateResult[] groupedResults10 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'In-File' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Purchase Contracts' ];
    		Decimal thenewnum10 = (Decimal)groupedResults10[0].get('TheNum');

    	AggregateResult[] groupedResults11 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'In-File' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'UCC' ];
    		Decimal thenewnum11 = (Decimal)groupedResults11[0].get('TheNum');

    	AggregateResult[] groupedResults12 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'In-File' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Unused' ];
    		Decimal thenewnum12 = (Decimal)groupedResults12[0].get('TheNum');

    		num = thenewnum1 + ',' + thenewnum2 + ',' + thenewnum3 + ',' + thenewnum4 + ',' + thenewnum5 + ',' + thenewnum6 + ',' + thenewnum7 + ',' + thenewnum8 + ',' + thenewnum9 + ',' + thenewnum10 + ',' + thenewnum11 + ',' + thenewnum12;

    	return num;
    }

    Public String getNumberOpen() {
    	String num;

    	AggregateResult[] groupedResults1 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Open' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Borrower Details' ];
    		Decimal thenewnum1 = (Decimal)groupedResults1[0].get('TheNum');

    	AggregateResult[] groupedResults2 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Open' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Entity Docs' ];
    		Decimal thenewnum2 = (Decimal)groupedResults2[0].get('TheNum');

    	AggregateResult[] groupedResults3 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Open' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Insurance' ];
    		Decimal thenewnum3 = (Decimal)groupedResults3[0].get('TheNum');

    	AggregateResult[] groupedResults4 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Open' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Other' ];
    		Decimal thenewnum4 = (Decimal)groupedResults4[0].get('TheNum');

    	AggregateResult[] groupedResults5 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Open' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Real Estate' ];
    		Decimal thenewnum5 = (Decimal)groupedResults5[0].get('TheNum');

    	AggregateResult[] groupedResults6 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Open' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Underwriting' ];
    		Decimal thenewnum6 = (Decimal)groupedResults6[0].get('TheNum');

    	AggregateResult[] groupedResults7 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Open' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Coporate' ];
    		Decimal thenewnum7 = (Decimal)groupedResults7[0].get('TheNum');

    	AggregateResult[] groupedResults8 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Open' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Financials' ];
    		Decimal thenewnum8 = (Decimal)groupedResults8[0].get('TheNum');

    	AggregateResult[] groupedResults9 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Open' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Leases' ];
    		Decimal thenewnum9 = (Decimal)groupedResults9[0].get('TheNum');

    	AggregateResult[] groupedResults10 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Open' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Purchase Contracts' ];
    		Decimal thenewnum10 = (Decimal)groupedResults10[0].get('TheNum');

    	AggregateResult[] groupedResults11 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Open' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'UCC' ];
    		Decimal thenewnum11 = (Decimal)groupedResults11[0].get('TheNum');

    	AggregateResult[] groupedResults12 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Open' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Unused' ];
    		Decimal thenewnum12 = (Decimal)groupedResults12[0].get('TheNum');

    		num = thenewnum1 + ',' + thenewnum2 + ',' + thenewnum3 + ',' + thenewnum4 + ',' + thenewnum5 + ',' + thenewnum6 + ',' + thenewnum7 + ',' + thenewnum8 + ',' + thenewnum9 + ',' + thenewnum10 + ',' + thenewnum11 + ',' + thenewnum12;

    	return num;
    }

    Public String getNumberWavied() {
    	String num;

    	AggregateResult[] groupedResults1 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Waived' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Borrower Details' ];
    		Decimal thenewnum1 = (Decimal)groupedResults1[0].get('TheNum');

    	AggregateResult[] groupedResults2 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Waived' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Entity Docs' ];
    		Decimal thenewnum2 = (Decimal)groupedResults2[0].get('TheNum');

    	AggregateResult[] groupedResults3 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Waived' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Insurance' ];
    		Decimal thenewnum3 = (Decimal)groupedResults3[0].get('TheNum');

    	AggregateResult[] groupedResults4 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Waived' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Other' ];
    		Decimal thenewnum4 = (Decimal)groupedResults4[0].get('TheNum');

    	AggregateResult[] groupedResults5 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Waived' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Real Estate' ];
    		Decimal thenewnum5 = (Decimal)groupedResults5[0].get('TheNum');

    	AggregateResult[] groupedResults6 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Waived' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Underwriting' ];
    		Decimal thenewnum6 = (Decimal)groupedResults6[0].get('TheNum');

    	AggregateResult[] groupedResults7 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Waived' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Coporate' ];
    		Decimal thenewnum7 = (Decimal)groupedResults7[0].get('TheNum');

    	AggregateResult[] groupedResults8 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Waived' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Financials' ];
    		Decimal thenewnum8 = (Decimal)groupedResults8[0].get('TheNum');

    	AggregateResult[] groupedResults9 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Waived' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Leases' ];
    		Decimal thenewnum9 = (Decimal)groupedResults9[0].get('TheNum');

    	AggregateResult[] groupedResults10 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Waived' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Purchase Contracts' ];
    		Decimal thenewnum10 = (Decimal)groupedResults10[0].get('TheNum');

    	AggregateResult[] groupedResults11 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Waived' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'UCC' ];
    		Decimal thenewnum11 = (Decimal)groupedResults11[0].get('TheNum');

    	AggregateResult[] groupedResults12 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Waived' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Unused' ];
    		Decimal thenewnum12 = (Decimal)groupedResults12[0].get('TheNum');

    		num = thenewnum1 + ',' + thenewnum2 + ',' + thenewnum3 + ',' + thenewnum4 + ',' + thenewnum5 + ',' + thenewnum6 + ',' + thenewnum7 + ',' + thenewnum8 + ',' + thenewnum9 + ',' + thenewnum10 + ',' + thenewnum11 + ',' + thenewnum12;

    	return num;
    }

    Public String getNumberException() {
    	String num;

    	AggregateResult[] groupedResults1 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Exception' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Borrower Details' ];
    		Decimal thenewnum1 = (Decimal)groupedResults1[0].get('TheNum');

    	AggregateResult[] groupedResults2 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Exception' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Entity Docs' ];
    		Decimal thenewnum2 = (Decimal)groupedResults2[0].get('TheNum');

    	AggregateResult[] groupedResults3 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Exception' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Insurance' ];
    		Decimal thenewnum3 = (Decimal)groupedResults3[0].get('TheNum');

    	AggregateResult[] groupedResults4 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Exception' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Other' ];
    		Decimal thenewnum4 = (Decimal)groupedResults4[0].get('TheNum');

    	AggregateResult[] groupedResults5 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Exception' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Real Estate' ];
    		Decimal thenewnum5 = (Decimal)groupedResults5[0].get('TheNum');

    	AggregateResult[] groupedResults6 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Exception' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Underwriting' ];
    		Decimal thenewnum6 = (Decimal)groupedResults6[0].get('TheNum');

    	AggregateResult[] groupedResults7 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Exception' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Coporate' ];
    		Decimal thenewnum7 = (Decimal)groupedResults7[0].get('TheNum');

    	AggregateResult[] groupedResults8 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Exception' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Financials' ];
    		Decimal thenewnum8 = (Decimal)groupedResults8[0].get('TheNum');

    	AggregateResult[] groupedResults9 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Exception' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Leases' ];
    		Decimal thenewnum9 = (Decimal)groupedResults9[0].get('TheNum');

    	AggregateResult[] groupedResults10 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Exception' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Purchase Contracts' ];
    		Decimal thenewnum10 = (Decimal)groupedResults10[0].get('TheNum');

    	AggregateResult[] groupedResults11 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Exception' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'UCC' ];
    		Decimal thenewnum11 = (Decimal)groupedResults11[0].get('TheNum');

    	AggregateResult[] groupedResults12 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Exception' AND LLC_BI__Loan__c =:loanID AND LLC_BI__docType__r.Name = 'Unused' ];
    		Decimal thenewnum12 = (Decimal)groupedResults12[0].get('TheNum');

    		num = thenewnum1 + ',' + thenewnum2 + ',' + thenewnum3 + ',' + thenewnum4 + ',' + thenewnum5 + ',' + thenewnum6 + ',' + thenewnum7 + ',' + thenewnum8 + ',' + thenewnum9 + ',' + thenewnum10 + ',' + thenewnum11 + ',' + thenewnum12;

    	return num;
    }

    Public Decimal getTotalApproved() {
    	Decimal num;

    	AggregateResult[] groupedResults1 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Approved' AND LLC_BI__Loan__c =:loanID];
    		Decimal thenewnum1 = (Decimal)groupedResults1[0].get('TheNum');

    		num = thenewnum1;

    	return num;
    }

    Public Decimal getTotalReviewed() {
    	Decimal num;

    	AggregateResult[] groupedResults1 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Reviewed' AND LLC_BI__Loan__c =:loanID];
    		Decimal thenewnum1 = (Decimal)groupedResults1[0].get('TheNum');

    		num = thenewnum1;

    	return num;
    }

    Public Decimal getTotalInFile() {
    	Decimal num;

    	AggregateResult[] groupedResults1 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'In-File' AND LLC_BI__Loan__c =:loanID];
    		Decimal thenewnum1 = (Decimal)groupedResults1[0].get('TheNum');

    		num = thenewnum1;

    	return num;
    }

    Public Decimal getTotalOpen() {
    	Decimal num;

    	AggregateResult[] groupedResults1 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Open' AND LLC_BI__Loan__c =:loanID];
    		Decimal thenewnum1 = (Decimal)groupedResults1[0].get('TheNum');

    		num = thenewnum1;

    	return num;
    }

    Public Decimal getTotalWaived() {
    	Decimal num;

    	AggregateResult[] groupedResults1 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Waived' AND LLC_BI__Loan__c =:loanID];
    		Decimal thenewnum1 = (Decimal)groupedResults1[0].get('TheNum');

    		num = thenewnum1;

    	return num;
    }

    Public Decimal getTotalException() {
    	Decimal num;

    	AggregateResult[] groupedResults1 = [SELECT Count(Id)TheNum FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Exception' AND LLC_BI__Loan__c =:loanID];
    		Decimal thenewnum1 = (Decimal)groupedResults1[0].get('TheNum');

    		num = thenewnum1;

    	return num;
    }

    Public List<LLC_BI__LLC_LoanDocument__c> getApprovedList() {

    	List<LLC_BI__LLC_LoanDocument__c> thelist = [SELECT Id, Name FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Approved' AND LLC_BI__Loan__c =:loanID];
    		

    	return thelist;
    }

    Public List<LLC_BI__LLC_LoanDocument__c> getReviewedList() {

    	List<LLC_BI__LLC_LoanDocument__c> thelist = [SELECT Id, Name FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Reviewed' AND LLC_BI__Loan__c =:loanID];
    		

    	return thelist;
    }

    Public List<LLC_BI__LLC_LoanDocument__c> getInFileList() {

    	List<LLC_BI__LLC_LoanDocument__c> thelist = [SELECT Id, Name FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'In-File' AND LLC_BI__Loan__c =:loanID];
    		

    	return thelist;
    }

    Public List<LLC_BI__LLC_LoanDocument__c> getOpenList() {

    	List<LLC_BI__LLC_LoanDocument__c> thelist = [SELECT Id, Name FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Open' AND LLC_BI__Loan__c =:loanID];
    		

    	return thelist;
    }

    Public List<LLC_BI__LLC_LoanDocument__c> getWaivedList() {

    	List<LLC_BI__LLC_LoanDocument__c> thelist = [SELECT Id, Name FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Waived' AND LLC_BI__Loan__c =:loanID];
    		

    	return thelist;
    }

    Public List<LLC_BI__LLC_LoanDocument__c> getExceptionList() {

    	List<LLC_BI__LLC_LoanDocument__c> thelist = [SELECT Id, Name FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__reviewStatus__c = 'Exception' AND LLC_BI__Loan__c =:loanID];
    		

    	return thelist;
    }
}
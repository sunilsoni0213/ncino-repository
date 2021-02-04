public with sharing class LoanPathGetGuide {

    
    //set variables for the Loan Record, current loan Record Type and Stage, and 
    //set up lp to return Loan Path Guide information
	private final LLC_BI__Loan__c loan;
    private string RecType;
    private string StageStep;
    public Loan_Path_Admin__c lp {set;get;}
   
    //Get record type and stage of current loan
    public LoanPathGetGuide(ApexPages.StandardController cont) {
        this.loan = (LLC_BI__Loan__c)cont.getRecord();
        RecType = loan.RecordType.Name;
        StageStep = loan.LLC_BI__Stage__c;


        //Use current record record type and stage to grab all the fields from Loan Path Admin
        lp = [Select Id, Name, Loan_Stage__c, Closer__c, Important_Fields__c, Objectives__c, Relationship_Manager__c, Underwriter__c from Loan_Path_Admin__c where Record_Type__c = :RecType and Loan_Stage__c = :Stagestep LIMIT 1];
        
        
        
       
    }
        
    
}
public with sharing class VF_ProcessHomepageController {

  private final LLC_BI__Loan__c l;
  public Integer Qualification  {get; set;}
  public Integer CreditAnalysis	{get; set;}
  public Integer Proposal      	{get; set;}
  public Integer LoanCommittee  {get; set;}
  public Integer Processing     {get; set;}
  public Integer DocPrep      	{get; set;}
  public Integer DocReview      {get; set;}
  public Integer Closing      	{get; set;}
  public Integer Won       		{get; set;}
  public Integer Lost        	{get; set;}
  public Integer Hold       	{get; set;}
  public String UserName     	{get; set;}
  //Links pulled from custom settings
  public String Qualification_Link	{get; set;}
  public String CreditAnalysis_Link	{get; set;}
  public String Proposal_Link   	{get; set;}
  public String LoanCommittee_Link	{get; set;}
  public String Processing_Link		{get; set;}
  public String DocPrep_Link		{get; set;}
  public String DocReview_Link		{get; set;}
  public String Closing_Link   		{get; set;}
  
    public VF_ProcessHomepageController(ApexPages.StandardController stdController) {
      Date CompDate = date.newinstance(2011, 1, 1);
      UserName = Userinfo.getName();
      
      //Run our query for all of our stage types to get the numbers
        List<LLC_BI__Loan__c> Qual = [select Id, LLC_BI__Stage__c, Name from LLC_BI__Loan__c where LLC_BI__Stage__c = 'Qualification / Application' and LLC_BI__Status__c = 'Open' and LLC_BI__CloseDate__c = THIS_YEAR];
        Qualification = Qual.size();

        List<LLC_BI__Loan__c> Prop = [select Id, LLC_BI__Stage__c, Name from LLC_BI__Loan__c where LLC_BI__Stage__c = 'Proposal' and LLC_BI__Status__c = 'Open' and LLC_BI__CloseDate__c = THIS_YEAR];
        Proposal = Prop.size();

        List<LLC_BI__Loan__c> CA = [select Id, LLC_BI__Stage__c, Name from LLC_BI__Loan__c where LLC_BI__Stage__c = 'Underwriting' and LLC_BI__Status__c = 'Open' and LLC_BI__CloseDate__c = THIS_YEAR];
        CreditAnalysis = CA.size();
        
        List<LLC_BI__Loan__c> LC = [select Id, LLC_BI__Stage__c, Name from LLC_BI__Loan__c where LLC_BI__Stage__c = 'Approval / Loan Committee' and LLC_BI__Status__c = 'Open' and LLC_BI__CloseDate__c = THIS_YEAR];
        LoanCommittee = LC.size();
        
        List<LLC_BI__Loan__c> Proc = [select Id, LLC_BI__Stage__c, Name from LLC_BI__Loan__c where LLC_BI__Stage__c = 'Processing' and LLC_BI__Status__c = 'Open' and LLC_BI__CloseDate__c = THIS_YEAR];
        Processing = Proc.size();
        
        List<LLC_BI__Loan__c> DP = [select Id, LLC_BI__Stage__c, Name from LLC_BI__Loan__c where LLC_BI__Stage__c = 'Doc Prep' and LLC_BI__Status__c = 'Open' and LLC_BI__CloseDate__c = THIS_YEAR];
        DocPrep = DP.size();
        
        List<LLC_BI__Loan__c> DR = [select Id, LLC_BI__Stage__c, Name from LLC_BI__Loan__c where LLC_BI__Stage__c = 'Doc Review' and LLC_BI__Status__c = 'Open' and LLC_BI__CloseDate__c = THIS_YEAR];
        DocReview = DR.size();

        List<LLC_BI__Loan__c> CL = [select Id, LLC_BI__Stage__c, Name from LLC_BI__Loan__c where LLC_BI__Stage__c = 'Closing' and LLC_BI__Status__c = 'Open' and LLC_BI__CloseDate__c = THIS_YEAR];
        Closing = CL.size();
                
        List<LLC_BI__Loan__c> WonList = [select Id, LLC_BI__Stage__c, Name from LLC_BI__Loan__c where LLC_BI__Stage__c = 'Booked' and LLC_BI__Status__c = 'Open' and LLC_BI__CloseDate__c = THIS_YEAR];
        Won = WonList.size();
        
        List<LLC_BI__Loan__c> LostList = [select Id, LLC_BI__Stage__c, Name from LLC_BI__Loan__c where LLC_BI__Stage__c = 'Complete' AND LLC_BI__Lost_To__c != null and LLC_BI__Status__c = 'Lost' and LLC_BI__CloseDate__c = THIS_YEAR];
        Lost = LostList.size();
        
        List<LLC_BI__Loan__c> HoldList = [select Id, LLC_BI__Stage__c, Name from LLC_BI__Loan__c where LLC_BI__Stage__c != 'Booked' and LLC_BI__Status__c = 'Hold' and LLC_BI__CloseDate__c = THIS_YEAR];
        Hold = HoldList.size();
        
        //Use our custom settings to set each of our stage links to point to the proper loan list View (created view "Create New View" under loans)
        /*
		  Qualification_Link
		  CreditAnalysis_Link
		  Proposal_Link
		  LoanCommittee_Link
		  Processing_Link
		  DocPrep_Link
		  DocReview_Link
		  Closing_Link */ 
    }

}
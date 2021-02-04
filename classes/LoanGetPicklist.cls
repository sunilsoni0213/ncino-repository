public class LoanGetPicklist {



public List<String> options{get; set;}
public string opts {get; set;}

private final LLC_BI__Loan__c loan;
private string RecType;


 
    public LoanGetPicklist(ApexPages.StandardController cont) {

        // Get the current loan record, get it's record type and instantiate the options variable
        // so it can be sent to the VF page into the jquery code 
        this.loan = (LLC_BI__Loan__c)cont.getRecord();
        RecType = loan.RecordType.Name;
        options = new List<String>(); 

                
        List<Loan_Path_Admin__c> lp = [Select Id, Name, Loan_Stage__c from Loan_Path_Admin__c where Record_Type__c = :RecType Order by Order__c ];
                 
                             //If it is, load up the stages from the Loan Path Admin object
                            if(!lp.isEmpty()) {
                                         for(Loan_Path_Admin__c ln : lp) {
                                         options.add(ln.Loan_Stage__c);
                                         //System.debug('*********************************** Label ******' + ln.Loan_Stage__c);
                                       }
                            //If it doesn't exist, just pull all the stages anyway 
                            } else {
                                         //Getting The Object's Picklist's Values     
                                      Schema.DescribeFieldResult fieldResult = LLC_BI__Loan__c.LLC_BI__Stage__c.getDescribe();
                                      List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                                      
                                      //Adding the Picklist Values into An Array           
                                       for(Schema.PicklistEntry f : ple){
                                          options.add(f.getLabel());
                                          //System.debug('*********************************** Label ******' + f.getLabel());
                                         }      
                            }
         
        //Stringifying The Array and Assigning It To A String 
                opts = JSON.serialize(options);       
            }
}
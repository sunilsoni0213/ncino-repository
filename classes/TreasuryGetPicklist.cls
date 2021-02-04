public class TreasuryGetPicklist {



public List<String> options{get; set;}
public string opts {get; set;}

private final LLC_BI__Treasury_Service__c treasury;
//private string RecType;

 
    public TreasuryGetPicklist(ApexPages.StandardController cont) {

        // Get the current treasury record, get it's record type and instantiate the options variable
        // so it can be sent to the VF page into the jquery code 
        this.treasury = (LLC_BI__Treasury_Service__c)cont.getRecord();
        //RecType = treasury.RecordType.Name;
        options = new List<String>(); 

       
                                         //Getting The Object's Picklist's Values     
                                      Schema.DescribeFieldResult fieldResult = LLC_BI__Treasury_Service__c.LLC_BI__Stage__c.getDescribe();
                                      List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                                      
                                      //Adding the Picklist Values into An Array           
                                       for(Schema.PicklistEntry f : ple){
                                          options.add(f.getLabel());
                                          //System.debug('*********************************** Label ******' + f.getLabel());
                                         }      
                            
         
        //Stringifying The Array and Assigning It To A String 
                opts = JSON.serialize(options);       
            }
}
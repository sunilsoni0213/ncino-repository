public class LoanWrapper {

    public Boolean checked{ get; set; }
    public LLC_BI__Loan__c loan { get; set; }

    public LoanWrapper(){
        loan = new LLC_BI__Loan__c();
        checked = false;
    }

    public LoanWrapper(LLC_BI__Loan__c l){
        loan = l;
        checked = false;
    }
}
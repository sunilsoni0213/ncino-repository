global virtual class LoanPricingScreenResourcev2
    extends nDESIGN.SObjectScreenResource{
    
    global virtual override void load(){
        LLC_BI__Loan__c loan = [
            SELECT
                Id,
                Name,
                LLC_BI__Description__c,
                LLC_BI__Risk_Grade__c,
                LLC_BI__Product__c,
                LLC_BI__Term_Months__c,
                LLC_BI__Amount__c,
                LLC_BI__Amortized_Term_Months__c,
                LLC_BI__Loan_Officer__r.Name,
                LLC_BI__Pricing_Basis__c,
                LLC_BI__Payment_Schedule__c,
                LLC_BI__Interest_Rate_Adjustment_Frequency__c,
                LLC_BI__Balloon__c,
                LLC_BI__Index__c,
                LLC_BI__CloseDate__c,
                LLC_BI__Spread__c,
                LLC_BI__Maturity_Date__c,
                LLC_BI__Rate_Ceiling__c,
                LLC_BI__Rate_Floor__c,
                LLC_BI__Payment_Type__c,
                LLC_BI__InterestRate__c,
                LLC_BI__Interest_Only_Months__c,
                LLC_BI__Underwriting_Summary__r.LLC_BI__Primary_Proposed_Exposure__c,
                LLC_BI__Underwriting_Summary__r.LLC_BI__Proposed_Exposure__c,
                LLC_BI__Product_Line__c,
                LLC_BI__SBA_Guarantee__c,
                LLC_BI__GTD_Balance__c
            FROM
                LLC_BI__Loan__c
            WHERE
                Id = :getSObject().Id];
        
        setSObject(loan);
        super.load();
        
        // order of children must be underwriting summary then loan officer
        getChildren().clear();
        
        // add underwriting summary
        nDESIGN.IScreenResource r = new nDESIGN.SObjectScreenResource();
        r.setSObject(((LLC_BI__Loan__c) getSObject()).LLC_BI__Underwriting_Summary__r);
        r.load();
        getChildren().add(r);
        
        // add loan officer
        r = new nDESIGN.SObjectScreenResource();
        r.setSObject(((LLC_BI__Loan__c) getSObject()).LLC_BI__Loan_Officer__r);
        r.load();
        getChildren().add(r);
    }
    global virtual override String getUniqueResourceIdentifier(){
        return LoanPricingScreenResourcev2.class.toString()
                + '_' + getSObjectType().getDescribe().getName();
    }
    global override Type getType(){
        return LoanPricingScreenResourcev2.class;
    }
}
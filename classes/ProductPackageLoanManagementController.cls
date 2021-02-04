public with sharing class ProductPackageLoanManagementController {
    
    public List<LLC_BI__Loan__c> loanList                            { get; set; }
    public List<LLC_BI__Legal_Entities__c> entList                   { get; set; }
    public String productPackageName                                 { get; set; }
    public Id objId                                                  { get; set; }
    public Id accId                                                  { get; set; }
    public Id productPackageRelationshipId;

    public ProductPackageLoanManagementController() {
        Map<String,String> getParameters = ApexPages.currentPage().getParameters();
        this.objId = getParameters.get(OBJECT_ID);
        this.productPackageName = getParameters.get(PACKAGE_NAME);
        this.loanList = new List<LLC_BI__Loan__c>();
        this.entList = new List<LLC_BI__Legal_Entities__c>();

        LLC_BI__Product_Package__c p = [SELECT 
                Id, 
                LLC_BI__Account__c 
            FROM 
                LLC_BI__Product_Package__c
            WHERE
                Id =: objId];

        productPackageRelationshipId = p.LLC_BI__Account__c;
    }

    public void addLoanRow() {
        this.loanList.add(getInitializedLoanObject(objId));
    }

    public void addEntityRow() {
        this.entList.add(getInitializedLegalEntityObject(objId,accId));
    }

    public void removeLastLoanRow() {
        if (this.loanList != null && this.loanList.size() > 0) {
            this.loanList.remove(this.loanList.size() - 1);
        }
    }

    public void removeLastEntityRow() {
        if (this.entList != null && this.entList.size() > 0) {
            this.entList.remove(this.entList.size() - 1);
        }
    }
    
    private LLC_BI__Loan__c getInitializedLoanObject(Id objId) {
        return new LLC_BI__Loan__c (
            LLC_BI__Product_Package__c = objId,
            LLC_BI__Product_Line__c = '',
            LLC_BI__Product_Type__c = '',
            LLC_BI__Product__c = ''
        );
    }

    private LLC_BI__Legal_Entities__c getInitializedLegalEntityObject(Id objId, Id accId) {
        return new LLC_BI__Legal_Entities__c (
            LLC_BI__Product_Package__c = objId,
            LLC_BI__Account__c = accId,
            LLC_BI__Ownership__c = DEFAULT_OWNERSHIP_PERCENTAGE,
            LLC_BI__Contingent_Type__c = DEFAULT_CONTINGENCY_TYPE,
            LLC_BI__Borrower_Type__c = DEFAULT_BORROWER_TYPE
        );
    }

    public PageReference step1() {
        return Page.ProductPackageLoanManagementPage1;
    }

    public PageReference step2() {
        return Page.ProductPackageLoanManagementPage2;
    }

    public PageReference createLoansAndEntities() {

        Id relationshipId;
        List<LLC_BI__Loan__c> newLoans = new List<LLC_BI__Loan__c>();
        List<LLC_BI__Legal_Entities__c> newEntities = new List<LLC_BI__Legal_Entities__c>();

        for (LLC_BI__Loan__c l : loanList) {
            if (l.Name != null && l.LLC_BI__Product_Line__c != null && l.LLC_BI__Product_Type__c != null && l.LLC_BI__Product__c != null) {
                newLoans.add(l);
            }
        }
        insert newLoans;

        for (LLC_BI__Loan__c l : loanList) {
            for (LLC_BI__Legal_Entities__c e : entList) {
               if (e.LLC_BI__Account__c != null && e.LLC_BI__Borrower_Type__c != null && e.LLC_BI__Contingent_Type__c != null && e.LLC_BI__Ownership__c != null) {
                  LLC_BI__Legal_Entities__c entity = cloneEntityInvolvement(e);
                  entity.LLC_BI__Loan__c = l.Id;
                  //system.debug('*** JSON:' + JSON.serializePretty(newEntities));
                  newEntities.add(entity);
               }
            }
         }
        insert newEntities;

        List<LLC_BI__Legal_Entities__c> entityList = [SELECT 
                Id, 
                LLC_BI__Account__c 
            FROM 
                LLC_BI__Legal_Entities__c 
            WHERE 
                Id IN : newEntities 
            AND 
                LLC_BI__Borrower_Type__c = 'Borrower' LIMIT 1];
        
        if (entityList.size() > 0) {
            relationshipId = entityList[0].LLC_BI__Account__c;
            for (LLC_BI__Loan__c l : newLoans) {
                l.LLC_BI__Account__c = relationshipId;
            }
            update newLoans;
        } else if (entityList.size() == 0 && productPackageRelationshipId != null) {
            relationshipId = productPackageRelationshipId;
            for (LLC_BI__Loan__c l : newLoans) {
                l.LLC_BI__Account__c = relationshipId;
            }
            update newLoans;
        }
        
        return new PageReference('/' + objId);
    }

    public PageReference saveNewRecords() {
        return null;
    }

    private LLC_BI__Legal_Entities__c cloneEntityInvolvement(LLC_BI__Legal_Entities__c entity) {
        return 
            new LLC_BI__Legal_Entities__c(
                Name = entity.Name,
                Id = null,
                LLC_BI__Address__c = entity.LLC_BI__Address__c,
                LLC_BI__Borrower_Type__c = entity.LLC_BI__Borrower_Type__c,
                LLC_BI__Ownership__c = entity.LLC_BI__Ownership__c,
                LLC_BI__Contingent_Type__c = entity.LLC_BI__Contingent_Type__c,
                LLC_BI__Deposit__c = entity.LLC_BI__Deposit__c,
                LLC_BI__Entity_Type__c = entity.LLC_BI__Entity_Type__c,
                LLC_BI__HMDA_Ethnicity__c = entity.LLC_BI__HMDA_Ethnicity__c,
                LLC_BI__Guarantee_Effective_Date__c = entity.LLC_BI__Guarantee_Effective_Date__c,
                LLC_BI__Guarantee_End_Date__c = entity.LLC_BI__Guarantee_End_Date__c,
                LLC_BI__Guaranty_Amount__c = entity.LLC_BI__Guaranty_Amount__c,
                LLC_BI__HMDA_Applicant_Type__c = entity.LLC_BI__HMDA_Applicant_Type__c,
                LLC_BI__HMDA_Not_Provided__c = entity.LLC_BI__HMDA_Not_Provided__c,
                LLC_BI__HMDA_Income__c = entity.LLC_BI__HMDA_Income__c,
                LLC_BI__Is_Included_In_Global_Analysis__c = entity.LLC_BI__Is_Included_In_Global_Analysis__c,
                LLC_BI__Guarantee_Limit__c = entity.LLC_BI__Guarantee_Limit__c,
                LLC_BI__Loan__c = entity.LLC_BI__Loan__c,
                LLC_BI__Loan_Collateral__c = entity.LLC_BI__Loan_Collateral__c,
                LLC_BI__Monthly_Debt_Service__c = entity.LLC_BI__Monthly_Debt_Service__c,
                LLC_BI__Notes__c = entity.LLC_BI__Notes__c,
                LLC_BI__Product_Package__c = entity.LLC_BI__Product_Package__c,
                LLC_BI__HMDA_Race__c = entity.LLC_BI__HMDA_Race__c,
                LLC_BI__Realestate__c = entity.LLC_BI__Realestate__c,
                LLC_BI__Account__c = entity.LLC_BI__Account__c,
                LLC_BI__Relationship_Type__c = entity.LLC_BI__Relationship_Type__c,
                LLC_BI__HMDA_Sex__c = entity.LLC_BI__HMDA_Sex__c,
                LLC_BI__Tax_ID__c = entity.LLC_BI__Tax_ID__c,
                LLC_BI__Treasury_Service__c = entity.LLC_BI__Treasury_Service__c
            );
    }

    private static final String OBJECT_ID = 'Id';
    private static final String PACKAGE_NAME = 'Name';
    private static final String DEFAULT_CONTINGENCY_TYPE = 'Joint & Several';
    private static final String DEFAULT_BORROWER_TYPE = 'Borrower';
    private static final Integer DEFAULT_OWNERSHIP_PERCENTAGE = 100;
}
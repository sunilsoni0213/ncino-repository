public with sharing class NewProductViewController {
    
    public List<LLC_BI__Legal_Entities__c> loans    { get; set; }
    public List<LLC_BI__Legal_Entities__c> deposits { get; set; }
    public List<LLC_BI__Legal_Entities__c> treasury { get; set; }
    public String showNewLoan                       { get; set; }
    public String showNewDeposit                    { get; set; }
    public String showNewEntity                     { get; set; }
    public String showNewTreasury                   { get; set; }
    public String accountName                       { get; set; }
    public Id objId = ApexPages.currentPage().getParameters().get('id');
    private final Account acct;

    public NewProductViewController(ApexPages.StandardController controller) {
        this.acct = (Account)controller.getRecord();

        Account a = [SELECT
                Name
            FROM
                Account
            WHERE
                Id =: objId];

        accountName = a.Name;

        LLC_BI__CFG_ConfigValue__c loanbutton = [SELECT LLC_BI__fieldValue__c FROM LLC_BI__CFG_ConfigValue__c WHERE LLC_BI__Category__c = 'Products & Services' AND LLC_BI__Key__c = 'Show_New_Loan_Button' LIMIT 1];
        showNewLoan = loanbutton.LLC_BI__fieldValue__c;

        LLC_BI__CFG_ConfigValue__c depositbutton = [SELECT LLC_BI__fieldValue__c FROM LLC_BI__CFG_ConfigValue__c WHERE LLC_BI__Category__c = 'Products & Services' AND LLC_BI__Key__c = 'Show_New_Deposit_Button' LIMIT 1];
        showNewDeposit = depositbutton.LLC_BI__fieldValue__c;

        LLC_BI__CFG_ConfigValue__c treasurybutton = [SELECT LLC_BI__fieldValue__c FROM LLC_BI__CFG_ConfigValue__c WHERE LLC_BI__Category__c = 'Products & Services' AND LLC_BI__Key__c = 'Show_New_Treasury_Button' LIMIT 1];
        showNewTreasury = treasurybutton.LLC_BI__fieldValue__c;

        LLC_BI__CFG_ConfigValue__c entitybutton = [SELECT LLC_BI__fieldValue__c FROM LLC_BI__CFG_ConfigValue__c WHERE LLC_BI__Category__c = 'Products & Services' AND LLC_BI__Key__c = 'Show_New_Entity_Button' LIMIT 1];
        showNewEntity = entitybutton.LLC_BI__fieldValue__c;

        this.loans = getLoanProducts();
        system.debug('*** this.loans.size: ' + this.loans.size());

        this.deposits = getDepositProducts();
        system.debug('*** this.deposits.size: ' + this.deposits.size());

        this.treasury = getTreasuryProducts();
        system.debug('*** this.deposits.size: ' + this.deposits.size());
    }

    public List<Schema.FieldSetMember> getLoanFields() {
        return SObjectType.LLC_BI__Legal_Entities__c.FieldSets.LLC_BI__UI_Loan_Products.getFields();
    }

    public List<Schema.FieldSetMember> getDepositFields() {
        return SObjectType.LLC_BI__Legal_Entities__c.FieldSets.LLC_BI__UI_Deposit_Products.getFields();
    }

    public List<Schema.FieldSetMember> getTreasuryFields() {
        return SObjectType.LLC_BI__Legal_Entities__c.FieldSets.LLC_BI__UI_Treasury_Products.getFields();
    }

    private List<LLC_BI__Legal_Entities__c> getLoanProducts() {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getLoanFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id FROM LLC_BI__Legal_Entities__c WHERE LLC_BI__Account__c=\'' + acct.Id + '\' AND LLC_BI__Loan__c != null AND LLC_BI__Deposit__c = null AND LLC_BI__Loan_Collateral__c = null AND LLC_BI__Treasury_Service__c = null ORDER BY LLC_BI__Borrower_Type__c ASC';
        return Database.query(query);
    }

    private List<LLC_BI__Legal_Entities__c> getDepositProducts() {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getDepositFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id FROM LLC_BI__Legal_Entities__c WHERE LLC_BI__Account__c=\'' + acct.Id + '\' AND LLC_BI__Loan__c = null AND LLC_BI__Deposit__c != null AND LLC_BI__Loan_Collateral__c = null AND LLC_BI__Treasury_Service__c = null ORDER BY LLC_BI__Relationship_Type__c ASC';
        return Database.query(query);
    }

    private List<LLC_BI__Legal_Entities__c> getTreasuryProducts() {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getTreasuryFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id FROM LLC_BI__Legal_Entities__c WHERE LLC_BI__Account__c=\'' + acct.Id + '\' AND LLC_BI__Loan__c = null AND LLC_BI__Deposit__c = null AND LLC_BI__Loan_Collateral__c = null AND LLC_BI__Treasury_Service__c != null ORDER BY LLC_BI__Relationship_Type__c ASC';
        return Database.query(query);
    }

    public String getNewLoanLink() {
        PageReference productPage = Page.LLC_BI__LoanProducts;
        productPage.getParameters().put('a', acct.Id);
        return productPage.getUrl();
    }

    public String getNewDepositLink() {
        PageReference productPage = Page.LLC_BI__DepositProducts;
        productPage.getParameters().put('a', acct.Id);
        return productPage.getUrl();
    }

    public String getNewTreasuryLink() {
        //PageReference productPage = Page.LLC_BI__DepositProducts;
        String productPage = '/006/e?opp4=' + accountName;
        return productPage;
    }

    public String getNewEntityInvolvementLink() {
        PageReference entitySearchPage = Page.LLC_BI__Search_Entity_Account;
        entitySearchPage.getParameters().put('retURL', acct.Id);
        entitySearchPage.getParameters().put('wrapMassAction', '1');
        entitySearchPage.getParameters().put('scontrolCaching', '1');
        entitySearchPage.getParameters().put('id', acct.Id);
        return entitySearchPage.getUrl();
    }
}
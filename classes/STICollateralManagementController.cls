public with sharing class STICollateralManagementController {

    public String searchText {get; set;}
    public List<LLC_BI__Collateral__c> searchResults {get; set;}
    public String collateralId {get; set;}
    public LLC_BI__Collateral__c collateralObject {get; set;}
    public LLC_BI__Loan_Collateral2__c loanCollateralObject {get; set;}
    public LLC_BI__Account_Collateral__c accountCollateralObject {get; set;}
    public Boolean loanCollateral {get; set;}
    public Boolean collateral {get; set;}
    public Boolean collateralType {get; set;}
    public Boolean collateralSearch {get; set;}
    public String collateralTypeId {get; set;}
    public List<Schema.FieldSetMember> fields {get; set;}
    public ID objectId {get; set;}
    public String loanId {get; set;}
    public String loanName {get; set;}

    private LLC_BI__Loan__c loan {
        get{
            if(this.loan == null && this.loanId != null){
                this.loan = [
                    SELECT
                        Id,
                        Name,
                        LLC_BI__Loan_Collateral_Aggregate__c,
                        (
                            SELECT
                                Id,
                                LLC_BI__Collateral__c
                            FROM
                                LLC_BI__Loan_Collateral__r
                        )
                    FROM
                        LLC_BI__Loan__c
                    WHERE
                        Id = :this.loanId];
            }
            return this.loan;
        }
        set;}

    public STICollateralManagementController(ApexPages.StandardSetController setCtrl){
        Map<String,String> params = ApexPages.currentPage().getParameters();
        this.loanId = params.get(ID_PARAM);
        getLoanName();
        this.collateralId = params.get(COLLATERAL_PARAM);
        this.loanCollateral = false;
        this.collateral = false;
        this.collateralType = false;
        this.collateralSearch = true;
        if (collateralId != null) {
            renderLoanCollateral();
        }
    }
    

    public PageReference executeSearch(){
        this.searchResults = search();
        return null;
    }

    public List<LLC_BI__Collateral__c> search(){

        String initialSearchText = this.searchText;
        initialSearchText = initialSearchText.replaceAll('\'', '');
        initialSearchText = initialSearchText.replaceAll('\\\\', '');

        this.searchText = String.escapeSingleQuotes(this.searchText);
        this.searchText = this.searchText.replaceAll(
            '([\\?\\&\\|\\!\\{\\}\\[\\]\\(\\)\\^\\~\\*\\:\\"\\+\\-])','\\\\$1'
        );

        if(this.searchText == null || this.searchText.length() < 3) {
            ApexPages.Message error = new ApexPages.Message(
                ApexPages.Severity.ERROR, 'You must use more than 2 characters to search.'); //Label.Search_Min_Chars);
            ApexPages.addMessage(error);
            return null;
        }
        String queryString = 'FIND {' + this.searchText + '*} IN ALL FIELDS RETURNING ' + 
        LLC_BI__Collateral__c.getSObjectType().getDescribe().getName() + COLLATERAL_FIELDS;
        List<List<sObject>> results = search.query(queryString);

        String searchString = '%' + initialSearchText + '%';

        List<LLC_BI__Account_Collateral__c> ownerResults = [
            SELECT
                Id,
                LLC_BI__Collateral__c,
                LLC_BI__Collateral__r.Id,
                LLC_BI__Collateral__r.Name,
                LLC_BI__Collateral__r.LLC_BI__Street_Address__c,
                LLC_BI__Collateral__r.LLC_BI__Value__c,
                LLC_BI__Collateral__r.LLC_BI__VIN__c,
                LLC_BI__Collateral__r.LLC_BI__Collateral_Type__r.Name,
                LLC_BI__Collateral__r.LLC_BI__Appraisal_Date__c
            FROM
                LLC_BI__Account_Collateral__c
            WHERE
                LLC_BI__Account__r.Name
            LIKE:
                searchString];

        if(ownerResults != null && ownerResults.size() > 0) {
            for(LLC_BI__Account_Collateral__c owner : ownerResults) {
                results[0].add(owner.LLC_BI__Collateral__r);
            }
        }

        return results[0];
    }

    private Boolean isPledged(Id collateralId){
        if(collateralId != null){
            for(LLC_BI__Loan_Collateral2__c lc2: this.loan.LLC_BI__Loan_Collateral__r){
                if(lc2.LLC_BI__Collateral__c == collateralId){
                    return true;
                }
            }
        }
        return false;
    }
    public PageReference selectCollateral() {
        String collateralId = ApexPages.currentPage().getParameters().get(COLLATERAL_ID_PARAM);
        this.objectId = ID.valueOf(collateralId);

        if(this.isPledged(this.objectId)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This collateral has already been pledged to this loan.')); //Label.Collateral_Already_Pledged));
            return null;
        }else{
            return redirectLoanCollateral();
        }
    }
    
    public SelectOption[] getCollateralTypeOptions() {
        SelectOption[] options = new SelectOption[] { new SelectOption('', '') };
        List<LLC_BI__Collateral_Type__c> collateralTypes = [
            SELECT 
                Id,
                Name,
                LLC_BI__Type__c,
                LLC_BI__Subtype__c 
            FROM 
                LLC_BI__Collateral_Type__c 
            WHERE
                LLC_BI__Active__c = true
            ORDER BY 
                Name ASC];

        Map<String, Map<String, LLC_BI__Collateral_Type__c>> typeMap = 
            new Map<String, Map<String, LLC_BI__Collateral_Type__c>>();
            
        for (LLC_BI__Collateral_Type__c typeOption : collateralTypes) {
            
        }
                
        for (LLC_BI__Collateral_Type__c typeOption : collateralTypes) {
            options.add(new SelectOption(String.valueOf(typeOption.Id), typeOption.LLC_BI__Type__c));
        }
        return options;
    }
    
    public SelectOption[] getCollateralTypes() {
        SelectOption[] options = new SelectOption[] { new SelectOption('', '') };
        List<LLC_BI__Collateral_Type__c> collateralTypes = [
            SELECT 
                Id,
                Name 
            FROM 
                LLC_BI__Collateral_Type__c 
            WHERE
                LLC_BI__Active__c = true
            ORDER BY 
                Name ASC];

        for (LLC_BI__Collateral_Type__c typeOption : collateralTypes) {
            options.add(new SelectOption(String.valueOf(typeOption.Id), typeOption.Name));
        }
        return options;
    }

    public void addNewCollateral() {
        this.collateralSearch = false;
        this.collateralType = true;
    }

    public void renderCollateral() {
        this.collateralObject = new LLC_BI__Collateral__c(LLC_BI__Collateral_Type__c = this.collateralTypeId);
        this.collateral = true;
        setCollateralFields();
    }

    public PageReference saveLoanCollateral() {
        if (validate((SObject) this.loanCollateralObject) 
            && (accountCollateralObject.LLC_BI__Account__c == null 
            || validate((SObject) this.accountCollateralObject))) {

            initializeLoanCollateral();

            if (save((SObject) this.loanCollateralObject)
                && (accountCollateralObject.LLC_BI__Account__c == null 
                || save((SObject) this.accountCollateralObject))) {
                
                PageReference redirect = new PageReference('/' + this.collateralId);
                redirect.setRedirect(true);
                return redirect;
            }
        }
        return null;
    }

    public PageReference saveCollateral() {
        if (validate((SObject) collateralObject)) {
            if (save((SObject) collateralObject)) {
                return redirectLoanCollateral();
            }
        }
        return null;
    }

    public PageReference redirectLoanCollateral() {
        PageReference redirect = Page.STICollateralManagement;
        Map<String,String> params = redirect.getParameters();
        params.put(COLLATERAL_PARAM, this.objectId);
        params.put(ID_PARAM, this.loanId);
        redirect.setRedirect(true);
        return redirect;
    }

    public PageReference restart() {
        PageReference redirect = Page.STICollateralManagement;
        Map<String,String> params = redirect.getParameters();
        params.put(ID_PARAM, this.loanId);
        redirect.setRedirect(true);
        return redirect;
    }

    private void setCollateralFields() {
        List<LLC_BI__Collateral_Type__c> colType = [
            SELECT 
                LLC_BI__Field_Set__c
            FROM
                LLC_BI__Collateral_Type__c
            WHERE
                ID =: this.collateralTypeId];
        MAP<String, Schema.FieldSet> fieldSets = Schema.SObjectType.LLC_BI__Collateral__c.fieldSets.getMap();
        if(colType == null
                || colType.size() == 0
                || String.isBlank(colType[0].LLC_BI__Field_Set__c)
                || fieldSets.get(colType[0].LLC_BI__Field_Set__c) == null) {
            this.fields = COLLATERAL_FIELD_SET.getFields();
        }
        else {
            this.fields = fieldSets.get(colType[0].LLC_BI__Field_Set__c).getFields();
        }
    }

    private void renderLoanCollateral() {
        this.loanCollateralObject = new LLC_BI__Loan_Collateral2__c(
                LLC_BI__Collateral__c = this.collateralId,
                LLC_BI__Loan__c = this.loanId);
        this.accountCollateralObject = new LLC_BI__Account_Collateral__c(
            LLC_BI__Collateral__c = this.collateralId);
        this.loanCollateral = true;
        this.collateralSearch = false;
        this.collateralObject = getAdvanceRate();
        this.fields = LC_FIELD_SET.getFields();
    }

    private void initializeLoanCollateral() {
        if(this.loan.LLC_BI__Loan_Collateral_Aggregate__c != null){
            this.loanCollateralObject.LLC_BI__Loan_Collateral_Aggregate__c =
                this.loan.LLC_BI__Loan_Collateral_Aggregate__c;
        }
        else {
            LLC_BI__Loan_Collateral_Aggregate__c collateralAggregate = new LLC_BI__Loan_Collateral_Aggregate__c();
            insert collateralAggregate;
            this.loan.LLC_BI__Loan_Collateral_Aggregate__c = collateralAggregate.Id;
            update this.loan;
            this.loanCollateralObject.LLC_BI__Loan_Collateral_Aggregate__c = collateralAggregate.Id;
        }
    }
    private LLC_BI__Collateral__c getAdvanceRate() {
        return [
            SELECT
                LLC_BI__Advance_Rate__c
            FROM
                LLC_BI__Collateral__c
            WHERE
                Id = :this.collateralId];
    }

    private void getLoanName(){
        this.loanName = this.loan.Name;
    }

    private Boolean save(SObject data) {
        try {
            upsert(data);
        } catch(System.DMLException e) {
            return false;
        }
        this.objectId = data.Id;
        return true;
    }

    private Boolean validate(SObject data) {
        if (this.fields == null && this.fields.size() == 0) {
            return true;
        }
        for (Schema.FieldSetMember field : this.fields) {
            if (!field.getRequired()) {
                continue;
            }
            if (data.get(field.getFieldPath()) == null) {
                ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.ERROR, 
                    'Required Field Missing:' + //System.Label.Covenant_Management_Required_Field + 
                    ' ' + field.getLabel()));
            }
        }
        return !ApexPages.hasMessages();
    }

    transient private static final Schema.FieldSet LC_FIELD_SET =
        SObjectType.LLC_BI__Loan_Collateral2__c.FieldSets.LLC_BI__Manage_Loan_Collateral;
    transient private static final Schema.FieldSet COLLATERAL_FIELD_SET =
        SObjectType.LLC_BI__Collateral__c.FieldSets.LLC_BI__Manage_Collateral;
    transient private static final String ID_PARAM = 'id';
    transient private static final String COLLATERAL_PARAM = 'collateral';
    transient private static final String COLLATERAL_ID_PARAM = 'collateralId';
    private static final String COLLATERAL_FIELDS =
        '(Name, LLC_BI__Street_Address__c, LLC_BI__Value__c, LLC_BI__VIN__c, ' +
        'LLC_BI__Collateral_Type__r.Name, LLC_BI__Appraisal_Date__c)';
}
public with sharing class CollateralManagementController {
    // Product Package Id passed to controller
    private Id productPackageId;
    
    // Collateral type/subtype selection and control
    public SelectOption[] collateralTypeOptions {get; private set;}
    public Map<String, SelectOption[]> collateralSubTypeOptions {get; private set;}
    public String collateralTypeName {get; set;}
    public String collateralSubtypeName {get; set;}
    public Boolean subTypeDisabled {get; set;}
    public Boolean collateralTypeIsSelected {get; set;}
    public Boolean collateralSubtypeIsSelected {get; set;}
    
    // processing control variables 
    
    // page display variables
    public LLC_BI__Collateral__c[] collateralRecords {get; set;}
    public String collateralTypeId {get; set;}
    public List<Schema.FieldSetMember> collateralFieldList {get; set;}
    
    // collateral ownership
    public sObjectWrapper[] collateralOwnershipList {get; set;}
    public sObjectWrapper[] collateralPledgedList {get; set;}
    
    public String[] loanFieldNames {get; set;}
    public String[] accountFieldNames {get; set;}
    public Schema.FieldSetMember[] fieldSetMembers {get; set;}
    // remember to turn this into field list
    public String[] ownershipFieldNames {get; private set;}
    public String[] pledgeFieldNames {get; private set;}
    public Map<String,String> ownershipTitleMap {get; private set;}
    public Map<String,String> pledgeTitleMap {get; private set;}
        
    private Map<Id,LLC_BI__Legal_Entities__c> legalEntityMap;
    private Map<Id, LLC_BI__Loan__c> loanMap;
    private Map<Id, Account> accountMap;
    /*
    * Constructor
    */
    public CollateralManagementController() {
        Map<String,String> params = ApexPages.currentPage().getParameters();
        this.productPackageId = params.get(PRODUCT_PACKAGE_ID_PARAM);
        this.subTypeDisabled = true;
        this.collateralSubtypeIsSelected = false;
        this.collateralTypeOptions = loadCollateralTypeOptions();
        this.collateralSubTypeOptions = loadCollateralSubTypeOptions();
        
        // load account and loan lists
        this.legalEntityMap = loadLegalEntityMap(productPackageId);
        this.loanMap = loadLoanMap(this.legalEntityMap);
        this.accountMap = loadAccountMap(this.legalEntityMap);
        
        // initialize Collataral records
        this.collateralRecords = initializeCollateralRecords();
        
        // initialize ownership
        this.collateralOwnershipList = setCollateralOwnershipList();
        this.ownershipFieldNames = 
            new List<String>{
                    'LLC_BI__Account__c','LLC_BI__Primary_Owner__c',
                    'LLC_BI__Ownership_Percentage__c','LLC_BI__Pledging_Authority__c',                  
                    'LLC_BI__Start_Date__c','LLC_BI__End_Date__c'};
        this.collateralPledgedList = setCollateralPledgedList();
        this.pledgeFieldNames = 
            new List<String>{
                    'LLC_BI__Loan__c','LLC_BI__Amount_Pledged__c',
                    'LLC_BI__Collateral_Value__c','LLC_BI__Current_Lendable_Value__c',                  
                    'LLC_BI__Start_Date__c','LLC_BI__End_Date__c'};
        this.ownershipTitleMap = new Map<String,String>{
            'LLC_BI__Account__c'=>'Relationship',
            'LLC_BI__Primary_Owner__c'=>'Primary Owner',
            'LLC_BI__Ownership_Percentage__c'=>'Ownership Percentage',
            'LLC_BI__Pledging_Authority__c'=>'Pledging Authority',
            'LLC_BI__Start_Date__c'=>'Start Date',
            'LLC_BI__End_Date__c'=>'End Date'
        };                  
        this.pledgeTitleMap = new Map<String,String>{
            'LLC_BI__Loan__c'=>'Loan',
            'LLC_BI__Amount_Pledged__c'=>'Amount Pledged',
            'LLC_BI__Collateral_Value__c'=>'Collateral Value',
            'LLC_BI__Current_Lendable_Value__c'=>'Current Lendable Value',
            'LLC_BI__Start_Date__c'=>'Start Date',
            'LLC_BI__End_Date__c'=>'End Date'
        };                  
    }

    // process methods for UI
    public void processCollateralTypeChange() {
        if (this.collateralTypeName == SELECT_ONE) {
            this.collateralTypeIsSelected = false;
            this.subTypeDisabled = true;
        } else {
            this.subTypeDisabled = false;
            this.collateralTypeIsSelected = true;
        }       
        this.collateralRecords[0].id = null;
        this.collateralSubtypeIsSelected = false;
    }

    public void processCollateralSubtypeChange() {
        if (this.collateralTypeName == SELECT_ONE || this.collateralSubtypeName == SELECT_ONE || this.collateralSubtypeName == SELECT_TYPE_FIRST) {
            this.collateralRecords[0].id = null;
            this.collateralSubtypeIsSelected = false;
        } else {
            LLC_BI__Collateral_Type__c selectedCollateralTypeRecord = this.typeSubTypeMap.get(this.collateralTypeName).get(this.collateralSubTypeName);
            this.collateralRecords[0].LLC_BI__Collateral_Type__c = selectedCollateralTypeRecord.Id;
            setCollateralFields();
            this.collateralSubtypeIsSelected = true;
        }
    
    }

    /* Support functions
    *   void setCollateralFields()
    *   private Map<String, Map<String, LLC_BI__Collateral_Type__c>> typeSubTypeMap
    *   private SelectOption[] loadCollateralTypeOptions()
    *   private Map<String, List<SelectOption>> loadCollateralSubTypeOptions()
    */
    private void setCollateralFields() {
        LLC_BI__Collateral_Type__c selectedCollateralTypeRecord = this.typeSubTypeMap.get(this.collateralTypeName).get(this.collateralSubTypeName);
        MAP<String, Schema.FieldSet> fieldSets = Schema.SObjectType.LLC_BI__Collateral__c.fieldSets.getMap();
        if(
            String.isBlank(selectedCollateralTypeRecord.LLC_BI__Field_Set__c)
                || fieldSets.get(selectedCollateralTypeRecord.LLC_BI__Field_Set__c) == null) {
            this.collateralFieldList = COLLATERAL_FIELD_SET.getFields();
        }
        else {
            this.collateralFieldList = fieldSets.get(selectedCollateralTypeRecord.LLC_BI__Field_Set__c).getFields();
        }
    }

    // Map<type name, Map<subTypeName, collateral type record>>
    private Map<String, Map<String, LLC_BI__Collateral_Type__c>> typeSubTypeMap {
        get {
            if (this.typeSubTypeMap == null) {
                this.typeSubTypeMap = new Map<String, Map<String, LLC_BI__Collateral_Type__c>>();
                
                List<LLC_BI__Collateral_Type__c> collateralTypes = [
                    SELECT 
                        Id,
                        Name,
                        LLC_BI__Advance_Rate__c,
                        LLC_BI__Collateral_Code__c,
                        LLC_BI__Condo_PUD__c,
                        LLC_BI__Expire_Date__c,
                        LLC_BI__Field_Set__c,
                        LLC_BI__Manufactured_Home__c,
                        LLC_BI__Regulatory_Rate__c,
                        LLC_BI__Start_Date__c,
                        LLC_BI__Type__c,
                        LLC_BI__Subtype__c 
                    FROM 
                        LLC_BI__Collateral_Type__c 
                    WHERE
                        LLC_BI__Active__c = true
                    ORDER BY 
                        Name ASC];
        
                for (LLC_BI__Collateral_Type__c colType : collateralTypes) {
                    Map<String, LLC_BI__Collateral_Type__c> subTypeMap = typeSubTypeMap.get(colType.LLC_BI__Type__c);
                    if (subTypeMap == null) {
                        subTypeMap = new Map<String, LLC_BI__Collateral_Type__c>();
                        typeSubTypeMap.put(colType.LLC_BI__Type__c, subTypeMap);
                    }
                    subTypeMap.put(colType.LLC_BI__Subtype__c, colType);
                }
            }
            return this.typeSubTypeMap;
        }
        set;
    }
    
    private SelectOption[] loadCollateralTypeOptions() {
        SelectOption[] options = new SelectOption[] { new SelectOption(SELECT_ONE, SELECT_ONE) };

        List<String> typeNames = new List<String>(this.typeSubTypeMap.keySet());
        typeNames.sort();
        
        for (String typeName : typeNames) {
            options.add(new SelectOption(typeName, typeName));
        }
        this.collateralTypeName = SELECT_ONE;

        return options;
    }

    private Map<String, List<SelectOption>> loadCollateralSubTypeOptions() {
        Map<String, SelectOption[]> subTypeOptionsMap = new Map<String, SelectOption[]>();
        
        String[] typeNames = new List<String>(this.typeSubTypeMap.keySet());
        typeNames.sort();
        
        SelectOption[] defaultOptions = new SelectOption[] { new SelectOption(SELECT_TYPE_FIRST, SELECT_TYPE_FIRST) };
        subTypeOptionsMap.put(SELECT_ONE, defaultOptions);
        
        for (String typeName : typeNames) {
            
            Map<String, LLC_BI__Collateral_Type__c> subTypeMap = this.typeSubTypeMap.get(typeName);
            String[] subTypeNames = new List<String>(subTypeMap.keySet());
            subTypeNames.sort();
            SelectOption[] subTypeOptions = new SelectOption[] { new SelectOption(SELECT_ONE, SELECT_ONE) };
            
            for (String subTypeName : subTypeNames) {
                subTypeOptions.add(new SelectOption(subTypeName,subTypeName));
            }
            subTypeOptionsMap.put(typeName, subTypeOptions);
        }
        return subTypeOptionsMap;
    }
    
    private LLC_BI__Collateral__c[] initializeCollateralRecords() {
        LLC_BI__Collateral__c[] collateralList = new List<LLC_BI__Collateral__c>();
        collateralList.add(new LLC_BI__Collateral__c());
        return collateralList;
    }

    /*
    *
    * SUPPORTING METHODS FOR LOAN AND ACCOUNT LISTS
    *
    */
    public Map<Id,LLC_BI__Legal_Entities__c> loadLegalEntityMap(Id productPackageId) {
        String fldString = 
            getFieldString(
                new List<String>{'Id','Name','LLC_BI__Loan__c','LLC_BI__Loan__r.Id','LLC_BI__Loan__r.name','LLC_BI__Account__c','LLC_BI__Account__r.Id','LLC_BI__Account__r.name'},
                Schema.LLC_BI__Legal_Entities__c.SObjectType,
                'LLC_BI__UI_Entity_Involvement_Fieldset'
                );
        String queryString = 
            'SELECT ' + 
                fldString + 
            ' FROM ' + 
                LEGAL_ENTITIES_TABLE_NAME + 
            ' WHERE ' + 
                LEGAL_ENTITY_LOAN_REFERENCE_FIELD + 
            ' IN (' + 
                'SELECT  ID FROM ' + 
                    LOAN_TABLE_NAME +
                ' WHERE ' + 
                    LOAN_PRODUCT_PACKAGE_FIELD_NAME + 
                ' =: productPackageId' +
            ') ' + 
            ' ORDER BY Name';
        return 
            new Map<Id, LLC_BI__Legal_Entities__c>((List<LLC_BI__Legal_Entities__c>)database.query(queryString));
    }

    public Map<Id,LLC_BI__Loan__c> loadLoanMap(Map<Id,LLC_BI__Legal_Entities__c> legalEntities) {
        this.loanMap = new Map<Id, LLC_BI__Loan__c>();
        for (LLC_BI__Legal_Entities__c legalEntity : legalEntities.values()) {
            LLC_BI__Loan__c loan = (LLC_BI__Loan__c)legalEntity.getSObject('LLC_BI__Loan__r');          
            loanMap.put(loan.Id, loan);
        }
        String fldString = 
            getFieldString(
                new List<String>{'Id','Name'},
                Schema.LLC_BI__Loan__c.SObjectType,
                'My_Test_Set'
            );
        Set<Id> ids = loanMap.keySet();
        String queryString = 
            'SELECT ' + 
                fldString + 
            ' FROM ' + 
                'LLC_BI__Loan__c ' + 
            ' WHERE ID IN :ids ORDER BY Name';
        this.loanFieldNames = fldString.split(',');
        for (Integer i = 0; i < this.loanFieldNames.size(); i++) {
            this.loanFieldNames[i] = this.loanFieldNames[i].trim();
        }
        return 
            new Map<Id,LLC_BI__Loan__c>((LLC_BI__Loan__c[])database.query(queryString)); 
    }

    public Map<Id, Account> loadAccountMap(Map<Id,LLC_BI__Legal_Entities__c> legalEntities) {
        this.accountMap = new Map<Id, Account>();
        for (LLC_BI__Legal_Entities__c legalEntity : legalEntities.values()) {
            Account account = (Account)legalEntity.getSObject('LLC_BI__Account__r');
            accountMap.put(account.Id, account);
        }
        Set<Id> ids = accountMap.keySet();
        String fldString = 
            getFieldString(
                new List<String>{'Id','Name'},
                Schema.Account.SObjectType,
                'My_Test_Set'
            );
        String queryString = 
            'SELECT ' + 
                fldString + 
            ' FROM ' + 
                'Account ' + 
            ' WHERE ID IN :ids ORDER BY Name';
        this.accountFieldNames = fldString.split(',');
        for (Integer i = 0; i < this.accountFieldNames.size(); i++) {
            this.accountFieldNames[i] = this.accountFieldNames[i].trim();
        }
        
        return new Map<Id,Account>((Account[])database.query(queryString));
    }
    
    private sObjectWrapper[] setCollateralOwnershipList() {
        sObjectWrapper[] collateralOwnershipList = new List<sObjectWrapper>();
        for (Id acctId : this.accountMap.keySet()) {
            LLC_BI__Account_Collateral__c ownership = new LLC_BI__Account_Collateral__c();
            ownership.LLC_BI__Account__c = acctId;
            collateralOwnershipList.add(new sObjectWrapper(ownership));
        }
        return collateralOwnershipList;
    }

    private sObjectWrapper[] setCollateralPledgedList() {
        sObjectWrapper[] collateralPledgedList = new List<sObjectWrapper>();
        for (Id loanId : this.loanMap.keySet()) {
            LLC_BI__Loan_Collateral2__c loanToCollateral = new LLC_BI__Loan_Collateral2__c();
            loanToCollateral.LLC_BI__Loan__c = loanId;
            collateralPledgedList.add(new sObjectWrapper(loanToCollateral));
        }
        return collateralPledgedList;
    }

    /**
    * getFieldString - formats query string field list
    *
    * @param  List<String> additional fields added to field set defined fields
    * @return String comprised of all fields in field set with non-duplicated additional fields formatted for use in query string
    */
    public String getFieldString(List<String> additionalFields, SObjectType objType, String fieldSetName) {
        Map<String, String> fieldPaths = new Map<String,String>();

        for (Schema.FieldSetMember fld : getFields(objType, fieldSetName)) {
            fieldPaths.put(fld.fieldPath,fld.fieldPath);
            if (Schema.DisplayType.reference == fld.getType()) {
                String namePath = fld.fieldPath.subString(0,fld.fieldPath.length()-1) + 'r.name';
                fieldPaths.put(namePath,namePath);
            }
        }

        for (String fld : additionalFields) {
            fieldPaths.put(fld, fld);
        }
        String fieldString = '';
        Boolean firstTime = true;
        for (String fld : fieldPaths.values()) {
            fieldString += (firstTime ? fld :  ', ' + fld);
            firstTime = false;
        }
        return fieldString;
    }

    /**
    * getFields - virtual method that returns field set members list from specified field set
    *
    * @param  None
    * @return Schema.FieldSetMember[] of field set members within the specified fieldset
    */
    public Schema.FieldSetMember[] getFields(SObjectType objType, String fieldSetName) {
        this.fieldSetMembers = null;
        if (this.fieldSetMembers == null || this.fieldSetMembers.size() == 0) {
            if (objType != null) {
                Schema.DescribeSObjectResult describe = objType.getDescribe();
                if (describe != null) {
                    MAP<String, Schema.FieldSet> fieldSets = describe.fieldSets.getMap();
                    if (fieldSets != null && (fieldSetName != null && fieldSetName.length() > 0)) {
                        if (fieldSets.get(fieldSetName) != null) {
                            this.fieldSetMembers = fieldSets.get(fieldSetName).getFields();
                        }
                    }
                }
            } 
        }
        
        if (this.fieldSetMembers == null) {
            this.fieldSetMembers = new List<Schema.FieldSetMember>();
        }
        return this.fieldSetMembers;
    }

    public class SObjectWrapper {
        public sObject obj {get; set;}
        public Boolean selected {get; set;}
        
        public SObjectWrapper (sObject obj) {
            this.obj = obj;
            this.selected = false;
        }
    }

    public PageReference saveCollateral() {
        Savepoint sp = Database.setSavepoint();
        try {
            this.collateralRecords[0].Id = null;        
            insert this.collateralRecords[0];
            Id colId = this.collateralRecords[0].Id;
            
            LLC_BI__Account_Collateral__c[] accountCollateralList = new List<LLC_BI__Account_Collateral__c>();
             
            for (sObjectWrapper colOwnWrap: collateralOwnershipList) {
                accountCollateralList.add((LLC_BI__Account_Collateral__c)colOwnWrap.obj);
                colOwnWrap.obj.put('LLC_BI__Collateral__c',colId);
                colOwnWrap.obj.put('Id',null);
            }
            insert accountCollateralList;
            
            LLC_BI__Loan_Collateral_Aggregate__c colAg = new LLC_BI__Loan_Collateral_Aggregate__c();
            insert colAg;
            
            LLC_BI__Loan_Collateral2__c colPledge = (LLC_BI__Loan_Collateral2__c)collateralPledgedList[0].obj;
            colPledge.LLC_BI__Collateral__c = colId;
            colPledge.LLC_BI__Loan_Collateral_Aggregate__c = colAg.Id;
            colPledge.LLC_BI__Authorize__c = true;
            colPledge.Id = null;
            insert colPledge;            
            
        } catch (Exception ex) {
            Database.rollback(sp);
            ApexPages.addMessages(ex);
            return null;
        }
        
        return new PageReference( '/' + this.productPackageId);     
    }
    public PageReference cancel() {
        return new PageReference('/' + this.productPackageId);
    }

    /*
    *
    * CONSTANTS
    *
    */
    private static final SObjectType LEGAL_ENTITIES_TYPE = Schema.LLC_BI__Legal_Entities__c.SObjectType;
    private static final String LEGAL_ENTITIES_TABLE_NAME = LEGAL_ENTITIES_TYPE.getDescribe().getName();
    private static final SObjectType LOAN_TYPE = Schema.LLC_BI__Loan__c.sObjectType;
    private static final String LOAN_TABLE_NAME = LOAN_TYPE.getDescribe().getName();
    private static final String LOAN_PRODUCT_PACKAGE_FIELD_NAME = Schema.LLC_BI__Loan__c.LLC_BI__Product_Package__c.getDescribe().getName();
    private static final String PRODUCT_PACKAGE_FIELD_NAME = Schema.LLC_BI__Legal_Entities__c.LLC_BI__Product_Package__c.getDescribe().getName();
    private static final String LEGAL_ENTITY_LOAN_REFERENCE_FIELD = Schema.LLC_BI__Legal_Entities__c.LLC_BI__Loan__c.getDescribe().getName();


    private static String SELECT_ONE = '-- SELECT ONE --';
    private static String SELECT_TYPE_FIRST = '-- SELECT TYPE FIRST --';
    public static String PRODUCT_PACKAGE_ID_PARAM = 'ppid';
    transient private static final Schema.FieldSet COLLATERAL_FIELD_SET =
        SObjectType.LLC_BI__Collateral__c.FieldSets.LLC_BI__Manage_Collateral;
}
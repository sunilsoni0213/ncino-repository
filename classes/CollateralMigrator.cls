global class CollateralMigrator extends LLC_BI.AConditionalBatchUpdater{
     global Map<String, Id> collateralTypeMap = new Map<String, Id>();
     global Map<Id, String> collateralAggregateMap = new Map<Id, String>();

     public CollateralMigrator(LLC_BI.ISchedulable s) {
          super(s);
     }
     
     global override Database.Querylocator getQuery(Database.BatchableContext BC) {
          return Database.getQueryLocator([SELECT
                Id,
                Name,
                LLC_BI__Agricultural_Use__c,
                LLC_BI__Airframe_Engine_Log_Books_Description__c,
                LLC_BI__Airport_Home_Base__c,
                LLC_BI__Avionics_Engines_Description__c,
                LLC_BI__Book_Entry__c,
                LLC_BI__Collateral_Affixed_to_a_Permanent_Site__c,
                LLC_BI__Collateral_City__c,
                LLC_BI__Collateral_Code__c,
                LLC_BI__Collateral_Issued_By__c,
                LLC_BI__Collateral_Issuer__c,
                LLC_BI__Collateral_State__c,
                LLC_BI__Collateral_Address__c,
                LLC_BI__Collateral_Value__c,
                LLC_BI__Collateral_Zip_Code__c,
                LLC_BI__Commercial_Use__c,
                LLC_BI__Contract_Date__c,
                LLC_BI__Contract_Number__c,
                LLC_BI__Contract_Type__c,
                LLC_BI__CUSIP_Number__c,
                LLC_BI__Description__c,
                LLC_BI__Dwelling__c,
                LLC_BI__Engines_Equipment_Description__c,
                LLC_BI__Existing_Beneficiaries__c,
                LLC_BI__FAA_Registration__c,
                LLC_BI__Gross_Tonnage__c,
                LLC_BI__Held_By__c,
                LLC_BI__Hull_and_Engine_Log_Books_Description__c,
                LLC_BI__Include_Land_As_Collateral__c,
                LLC_BI__Leasehold__c,
                LLC_BI__Letter_of_Credit_Date__c,
                LLC_BI__Lien__c,
                LLC_BI__Life_Insurance_Amount__c,
                LLC_BI__Life_Insurance_Company_City__c,
                LLC_BI__Life_Insurance_Agency__c,
                LLC_BI__Life_Insurance_Policy_Number__c,
                LLC_BI__Life_Insurance_Company_State__c,
                LLC_BI__Life_Insurance_Company_Street_Address__c,
                LLC_BI__Life_Insurance_Company_ZipCode__c,
                LLC_BI__Lot__c,
                LLC_BI__Make__c,
                LLC_BI__Manufactured_Home__c,
                LLC_BI__Manufacturer__c,
                LLC_BI__Marina_Port_Name__c,
                LLC_BI__Model__c,
                LLC_BI__Name_of_Insured__c,
                LLC_BI__Net_Tonnage__c,
                LLC_BI__Number_of_Units__c,
                LLC_BI__Owner_Occupied__c,
                LLC_BI__Owners_Interest__c,
                LLC_BI__Parcel_Number__c,
                LLC_BI__Possessory_Current_Balance__c,
                LLC_BI__Principal_Dwelling__c,
                LLC_BI__Property_Tax_Id__c,
                LLC_BI__Property_Type__c,
                LLC_BI__Purchase_Money__c,
                LLC_BI__Refinance__c,
                LLC_BI__Residential_Property__c,
                LLC_BI__Secures_Future_Advances__c,
                LLC_BI__State_Registered__c,
                LLC_BI__Third_Party_City__c,
                LLC_BI__Third_Party_Company__c,
                LLC_BI__Third_Party_State__c,
                LLC_BI__Third_Party_Street_Address__c,
                LLC_BI__Third_Party_Zip_Code__c,
                LLC_BI__UCC_County_Filing__c,
                LLC_BI__UCC_Expiration_County__c,
                LLC_BI__UCC_Expiration_State__c,
                LLC_BI__UCC_Financing_Statement__c,
                LLC_BI__UCC_State_Filing__c,
                LLC_BI__VIN__c,
                LLC_BI__Vessel_Name__c,
                LLC_BI__Year__c,
                LLC_BI__Year_Built__c,
                LLC_BI__Appraisal_Date__c,
                LLC_BI__Block__c,
                LLC_BI__Body__c,
                LLC_BI__Collateral_Insurance_Agent__c,
                LLC_BI__Collateral_Insurance_City__c,
                LLC_BI__Collateral_Insurance_Company__c,
                LLC_BI__Collateral_Insurance_Phone__c,
                LLC_BI__Collateral_Insurance_Policy_Number__c,
                LLC_BI__Collateral_Insurance_State__c,
                LLC_BI__Collateral_Insurance_Street__c,
                LLC_BI__Collateral_Insurance_Zipcode__c,
                LLC_BI__Collateral_Location__Latitude__s,
                LLC_BI__Collateral_Location__Longitude__s,
                LLC_BI__Legal_Entity__r.LLC_BI__Account__c,
                LLC_BI__Legal_Entity_2__r.LLC_BI__Account__c,
                LLC_BI__Deposit_Account_Number__c,
                LLC_BI__isFutureContext__c,
                LLC_BI__Notes__c,
                LLC_BI__Number_of_Shares__c,
                LLC_BI__Possessory_Account_Number__c,
                LLC_BI__Prior_Lien_Amount__c,
                LLC_BI__Prior_Lien_Holder__c,
                LLC_BI__Subdivision__c,
                LLC_BI__Loan__r.Id,
                LLC_BI__Loan__r.LLC_BI__Booked_Date__c,
                LLC_BI__Loan__r.LLC_BI__Is_Booked__c,
                LLC_BI__Loan__r.LLC_BI__Loan_Collateral_Aggregate__c,
                LLC_BI__Type__c,
                LLC_BI__Sub_Type__c,
                LLC_BI__UCC_Type__c,
              CreatedBy.Id,
                CreatedBy.IsActive
          FROM
                LLC_BI__Loan_Collateral__c
            WHERE
            LLC_BI__Loan__r.Id = 'a0Ud0000002bDBW' AND LLC_BI__Loan__r.LLC_BI__Loan_Collateral_Aggregate__c = null]);
     }

     global override void performUpdate(List<sObject> newObjs) {
          
          if(collateralTypeMap.size() == 0) {
                collateralTypeMap = getCollateralTypes();
          }

          for(LLC_BI__Loan_Collateral__c oldCollateral : (List<LLC_BI__Loan_Collateral__c>)newObjs) {
                LLC_BI__Collateral__c newCol = createCollateral(oldCollateral);
                Id collateralTypeId = getCollateralType(
                     oldCollateral.LLC_BI__Type__c,
                     oldCollateral.LLC_BI__Sub_Type__c,
                     oldCollateral.LLC_BI__UCC_Type__c);
                if(collateralTypeId == null) {
                     System.debug(LoggingLevel.DEBUG, String.format(TYPE_ERROR_MSG, new String[] {oldCollateral.Id}));
                     continue;
                }
                newCol.LLC_BI__Collateral_Type__c = collateralTypeId;
                addInsert(newCol);

                if(oldCollateral.LLC_BI__Loan__c != null) {
                    if(collateralAggregateMap.get(oldCollateral.LLC_BI__Loan__c) == null && 
                            oldCollateral.LLC_BI__Loan__r.LLC_BI__Loan_Collateral_Aggregate__c == null) {
                        LLC_BI__Loan_Collateral_Aggregate__c lcAggregate = createLoanCollateralAggregate();
                        collateralAggregateMap.put(oldCollateral.LLC_BI__Loan__c, lcAggregate.LLC_BI__lookupKey__c);
                        addInsert(lcAggregate);
                        oldCollateral.LLC_BI__Loan__r.LLC_BI__Loan_Collateral_Aggregate__r =
                            new LLC_BI__Loan_Collateral_Aggregate__c(LLC_BI__lookupKey__c = collateralAggregateMap.get(oldCollateral.LLC_BI__Loan__c));
                        addUpdate(oldCollateral.LLC_BI__Loan__r);
                    }
                    addInsert(createLoanCollateral(
                        oldCollateral,
                        newCol.LLC_BI__lookupKey__c,
                        collateralAggregateMap.get(oldCollateral.LLC_BI__Loan__c)));
                }
                if(oldCollateral.LLC_BI__Legal_Entity__r.LLC_BI__Account__c != null) {
                     addInsert(
                          createAccountCollateral(
                                newCol.LLC_BI__lookupKey__c,
                                oldCollateral.LLC_BI__Legal_Entity__r.LLC_BI__Account__c));
                }
                if(oldCollateral.LLC_BI__Legal_Entity_2__r.LLC_BI__Account__c != null) {
                     addInsert(
                          createAccountCollateral(
                                newCol.LLC_BI__lookupKey__c,
                                oldCollateral.LLC_BI__Legal_Entity_2__r.LLC_BI__Account__c));
                }
                if(oldCollateral.LLC_BI__Loan__r.LLC_BI__Is_Booked__c) {
                     addInsert(createLien(newCol.LLC_BI__lookupKey__c, oldCollateral));
                }
                if(oldCollateral.LLC_BI__Prior_Lien_Amount__c !=null
                     || oldCollateral.LLC_BI__Prior_Lien_Holder__c != null) {
                     addInsert(createPriorLien(newCol.LLC_BI__lookupKey__c, oldCollateral));
                }
          }
     }

     public static String generateGuid(){
        String returnVal = Math.random() + '';
        returnVal = returnVal.replace('0.', '42');
        return returnVal.substring(0,Math.min(returnVal.length(),17));
    }

     private Map<String, Id> getCollateralTypes() {
          Map<String, Id> mapping = new Map<String, Id>();
          List<LLC_BI__Collateral_Type__c> collateralTypes = [
                SELECT
                     Id,
                     LLC_BI__Type__c,
                     LLC_BI__Subtype__c
                FROM
                     LLC_BI__Collateral_Type__c];
          for(LLC_BI__Collateral_Type__c collateralType : collateralTypes) {
                mapping.put(
                     collateralType.LLC_BI__Type__c + collateralType.LLC_BI__Subtype__c,
                     collateralType.Id);
          }
          return mapping;
     }

     private LLC_BI__Loan_Collateral_Aggregate__c createLoanCollateralAggregate() {
          return new LLC_BI__Loan_Collateral_Aggregate__c (LLC_BI__lookupKey__c = generateGuid());
     }

     private LLC_BI__Lien__c createLien(String newColLookup, LLC_BI__Loan_Collateral__c oldCollateral) {
          LLC_BI__Lien__C lien = new LLC_BI__Lien__c(
                LLC_BI__Collateral__r = new LLC_BI__Collateral__c(LLC_BI__lookupKey__c = newColLookup),
                LLC_BI__Loan__c = oldCollateral.LLC_BI__Loan__r.Id,
                LLC_BI__Position__c = oldCollateral.LLC_BI__Lien__c,
                LLC_BI__Amount__c = oldCollateral.LLC_BI__Collateral_Value__c);

          return lien;
     }

     private LLC_BI__Lien__c createPriorLien(String newColLookup, LLC_BI__Loan_Collateral__c oldCollateral) {
          LLC_BI__Lien__C lien = new LLC_BI__Lien__c(
                LLC_BI__Collateral__r = new LLC_BI__Collateral__c(LLC_BI__lookupKey__c = newColLookup),
                LLC_BI__Institution__c = oldCollateral.LLC_BI__Prior_Lien_Holder__c);
          
          try {
                String numeric = oldCollateral.LLC_BI__Prior_Lien_Amount__c.replaceAll('[^\\d]','');
                Decimal amount = Decimal.valueOf(numeric);
                lien.LLC_BI__Amount__c = amount;
          }
          catch(Exception e) {
                System.debug(LoggingLevel.DEBUG,
                     String.format(CONVERT_ERROR_MSG, new String[] {oldCollateral.Id}));
          }
          return lien;
     }

     private LLC_BI__Loan_Collateral2__c createLoanCollateral(
          LLC_BI__Loan_Collateral__c oldCollateral,
          String newColLookup,
          String newLCAggLookup) {

          LLC_BI__Loan_Collateral2__c loanCollateral = new LLC_BI__Loan_Collateral2__c(
                LLC_BI__Collateral__r = new LLC_BI__Collateral__c(LLC_BI__lookupKey__c = newColLookup),
                LLC_BI__Loan_Collateral_Aggregate__r = 
                     new LLC_BI__Loan_Collateral_Aggregate__c(LLC_BI__lookupKey__c = newLCAggLookup),
                LLC_BI__Loan__c = oldCollateral.LLC_BI__Loan__r.Id,
                LLC_BI__Amount_Pledged__c = oldCollateral.LLC_BI__Collateral_Value__c,
                LLC_BI__Lien_Position__c = oldCollateral.LLC_BI__Lien__c,
                LLC_BI__Advance_Rate_Override__c = 100,
                LLC_BI__Override_Reason__c = 'Collateral Migration');
          loanCollateral.LLC_BI__Start_Date__c = 
                oldCollateral.LLC_BI__Loan__r.LLC_BI__Booked_Date__c == null
                     ? date.today() : oldCollateral.LLC_BI__Loan__r.LLC_BI__Booked_Date__c;
          return loanCollateral;
     }

     private LLC_BI__Account_Collateral__c createAccountCollateral(String newColLookup, Id accountId) {
          return new LLC_BI__Account_Collateral__c(
                LLC_BI__Collateral__r = new LLC_BI__Collateral__c(LLC_BI__lookupKey__c = newColLookup),
                LLC_BI__Account__c = accountId);
     }

     private LLC_BI__Collateral__c createCollateral(LLC_BI__Loan_Collateral__c oldCollateral) {
          String description = this.joinText(oldCollateral.LLC_BI__Description__c, oldCollateral.LLC_BI__Notes__c);
          String yearBuilt;

          if (oldCollateral.LLC_BI__Year_Built__c != null) {
                yearBuilt = (Integer)oldCollateral.LLC_BI__Year_Built__c + '';
          }

          LLC_BI__Collateral__c collateral = new LLC_BI__Collateral__c(
                LLC_BI__Agricultural_Use__c = oldCollateral.LLC_BI__Agricultural_Use__c,
                LLC_BI__Airframe_Engine_Log_Books_Description__c =
                     oldCollateral.LLC_BI__Airframe_Engine_Log_Books_Description__c,
                LLC_BI__Airport_Home_Base__c = oldCollateral.LLC_BI__Airport_Home_Base__c,
                LLC_BI__Avionics_Engines_Description__c = oldCollateral.LLC_BI__Avionics_Engines_Description__c,
                LLC_BI__Book_Entry__c = oldCollateral.LLC_BI__Book_Entry__c,
                LLC_BI__Collateral_Affixed_to_a_Permanent_Site__c =
                     oldCollateral.LLC_BI__Collateral_Affixed_to_a_Permanent_Site__c,
                LLC_BI__City__c = oldCollateral.LLC_BI__Collateral_City__c,
                LLC_BI__Collateral_Issued_By__c = oldCollateral.LLC_BI__Collateral_Issued_By__c,
                LLC_BI__Collateral_Issuer__c = oldCollateral.LLC_BI__Collateral_Issuer__c,
                LLC_BI__State__c = oldCollateral.LLC_BI__Collateral_State__c,
                LLC_BI__Street_Address__c = oldCollateral.LLC_BI__Collateral_Address__c,
                LLC_BI__Value__c = oldCollateral.LLC_BI__Collateral_Value__c,
                LLC_BI__Zip_Code__c = oldCollateral.LLC_BI__Collateral_Zip_Code__c,
                LLC_BI__Commercial_Use__c = oldCollateral.LLC_BI__Commercial_Use__c,
                LLC_BI__Contract_Date__c = oldCollateral.LLC_BI__Contract_Date__c,
                LLC_BI__Contract_Number__c = oldCollateral.LLC_BI__Contract_Number__c,
                LLC_BI__Contract_Type__c = oldCollateral.LLC_BI__Contract_Type__c,
                LLC_BI__CUSIP_Number__c = oldCollateral.LLC_BI__CUSIP_Number__c,
                LLC_BI__Description__c = description,
                LLC_BI__Dwelling__c = oldCollateral.LLC_BI__Dwelling__c,
                LLC_BI__Engines_Equipment_Description__c = oldCollateral.LLC_BI__Engines_Equipment_Description__c,
                LLC_BI__Existing_Beneficiaries__c = oldCollateral.LLC_BI__Existing_Beneficiaries__c,
                LLC_BI__FAA_Registration_Number__c = oldCollateral.LLC_BI__FAA_Registration__c,
                LLC_BI__Gross_Tonnage__c = oldCollateral.LLC_BI__Gross_Tonnage__c,
                LLC_BI__Held_By__c = oldCollateral.LLC_BI__Held_By__c,
                LLC_BI__Hull_and_Engine_Log_Books_Description__c =
                     oldCollateral.LLC_BI__Hull_and_Engine_Log_Books_Description__c,
                LLC_BI__Include_Land_As_Collateral__c = oldCollateral.LLC_BI__Include_Land_As_Collateral__c,
                LLC_BI__Leasehold__c = oldCollateral.LLC_BI__Leasehold__c,
                LLC_BI__Letter_of_Credit_Date__c = oldCollateral.LLC_BI__Letter_of_Credit_Date__c,
                LLC_BI__Life_Insurance_Benefit_Amount__c = oldCollateral.LLC_BI__Life_Insurance_Amount__c,
                LLC_BI__Life_Insurance_Company_City__c = oldCollateral.LLC_BI__Life_Insurance_Company_City__c,
                LLC_BI__Life_Insurance_Company__c = oldCollateral.LLC_BI__Life_Insurance_Agency__c,
                LLC_BI__Life_Insurance_Policy_Number__c = oldCollateral.LLC_BI__Life_Insurance_Policy_Number__c,
                LLC_BI__Life_Insurance_Company_State__c = oldCollateral.LLC_BI__Life_Insurance_Company_State__c,
                LLC_BI__Life_Insurance_Company_Street_Address__c =
                oldCollateral.LLC_BI__Life_Insurance_Company_Street_Address__c,
                LLC_BI__Life_Insurance_Company_ZipCode__c = oldCollateral.LLC_BI__Life_Insurance_Company_ZipCode__c,
                LLC_BI__Lot__c = oldCollateral.LLC_BI__Lot__c,
                LLC_BI__Make__c = oldCollateral.LLC_BI__Make__c,
                LLC_BI__Manufacturer__c = oldCollateral.LLC_BI__Manufacturer__c,
                LLC_BI__Marina_Port_Name__c = oldCollateral.LLC_BI__Marina_Port_Name__c,
                LLC_BI__Model__c = oldCollateral.LLC_BI__Model__c,
                LLC_BI__Name_of_Insured__c = oldCollateral.LLC_BI__Name_of_Insured__c,
                LLC_BI__Net_Tonnage__c = oldCollateral.LLC_BI__Net_Tonnage__c,
                LLC_BI__Number_of_Units__c = oldCollateral.LLC_BI__Number_of_Units__c,
                LLC_BI__Owner_Occupied__c = oldCollateral.LLC_BI__Owner_Occupied__c,
                LLC_BI__Owners_Interest__c = oldCollateral.LLC_BI__Owners_Interest__c,
                LLC_BI__Parcel_Number__c = oldCollateral.LLC_BI__Parcel_Number__c,
                LLC_BI__Possessory_Current_Balance__c = oldCollateral.LLC_BI__Possessory_Current_Balance__c,
                LLC_BI__Principal_Dwelling__c = oldCollateral.LLC_BI__Principal_Dwelling__c,
                LLC_BI__Property_Tax_Id__c = oldCollateral.LLC_BI__Property_Tax_Id__c,
                LLC_BI__Property_Type__c = oldCollateral.LLC_BI__Property_Type__c,
                LLC_BI__Purchase_Money__c = oldCollateral.LLC_BI__Purchase_Money__c,
                LLC_BI__Refinance__c = oldCollateral.LLC_BI__Refinance__c,
                LLC_BI__Residential_Property__c = oldCollateral.LLC_BI__Residential_Property__c,
                LLC_BI__Secures_Future_Advances__c = oldCollateral.LLC_BI__Secures_Future_Advances__c,
                LLC_BI__State_Registered__c = oldCollateral.LLC_BI__State_Registered__c,
                LLC_BI__Third_Party_City__c = oldCollateral.LLC_BI__Third_Party_City__c,
                LLC_BI__Third_Party_Company__c = oldCollateral.LLC_BI__Third_Party_Company__c,
                LLC_BI__Third_Party_State__c = oldCollateral.LLC_BI__Third_Party_State__c,
                LLC_BI__Third_Party_Street_Address__c = oldCollateral.LLC_BI__Third_Party_Street_Address__c,
                LLC_BI__Third_Party_Zip_Code__c = oldCollateral.LLC_BI__Third_Party_Zip_Code__c,
                LLC_BI__UCC_County_Filing__c = oldCollateral.LLC_BI__UCC_County_Filing__c,
                LLC_BI__UCC_Expiration_County__c = oldCollateral.LLC_BI__UCC_Expiration_County__c,
                LLC_BI__UCC_Expiration_State__c = oldCollateral.LLC_BI__UCC_Expiration_State__c,
                LLC_BI__UCC_Financing_Statement__c = oldCollateral.LLC_BI__UCC_Financing_Statement__c,
                LLC_BI__UCC_State_Filing__c = oldCollateral.LLC_BI__UCC_State_Filing__c,
                LLC_BI__VIN__c = oldCollateral.LLC_BI__VIN__c,
                LLC_BI__Vessel_Name__c = oldCollateral.LLC_BI__Vessel_Name__c,
                LLC_BI__Year__c = oldCollateral.LLC_BI__Year__c,
                LLC_BI__Year_Built__c = yearBuilt,
                LLC_BI__Appraisal_Date__c = oldCollateral.LLC_BI__Appraisal_Date__c,
                LLC_BI__Block__c = oldCollateral.LLC_BI__Block__c,
                LLC_BI__Body_Style__c = oldCollateral.LLC_BI__Body__c,
                LLC_BI__Collateral_Insurance_Agent__c = oldCollateral.LLC_BI__Collateral_Insurance_Agent__c,
                LLC_BI__Collateral_Insurance_City__c = oldCollateral.LLC_BI__Collateral_Insurance_City__c,
                LLC_BI__Collateral_Insurance_Company__c = oldCollateral.LLC_BI__Collateral_Insurance_Company__c,
                LLC_BI__Collateral_Insurance_Phone__c = oldCollateral.LLC_BI__Collateral_Insurance_Phone__c,
                LLC_BI__Collateral_Insurance_Policy_Number__c = oldCollateral.LLC_BI__Collateral_Insurance_Policy_Number__c,
                LLC_BI__Collateral_Insurance_State__c = oldCollateral.LLC_BI__Collateral_Insurance_State__c,
                LLC_BI__Collateral_Insurance_Street__c = oldCollateral.LLC_BI__Collateral_Insurance_Street__c,
                LLC_BI__Collateral_Insurance_Zipcode__c = oldCollateral.LLC_BI__Collateral_Insurance_Zipcode__c,
                LLC_BI__Collateral_Location__Latitude__s = oldCollateral.LLC_BI__Collateral_Location__Latitude__s,
                LLC_BI__Collateral_Location__Longitude__s = oldCollateral.LLC_BI__Collateral_Location__Longitude__s,
                LLC_BI__Deposit_Account_Number__c = oldCollateral.LLC_BI__Deposit_Account_Number__c,
                LLC_BI__isFutureContext__c = oldCollateral.LLC_BI__isFutureContext__c,
                LLC_BI__Number_of_Shares__c = oldCollateral.LLC_BI__Number_of_Shares__c,
                LLC_BI__Possessory_Account_Number__c = oldCollateral.LLC_BI__Possessory_Account_Number__c,
                LLC_BI__Subdivision__c = oldCollateral.LLC_BI__Subdivision__c,
                LLC_BI__lookupKey__c = generateGuid(),
                OwnerId = getUserId(oldCollateral.CreatedBy));

              String collateralTypeKey = oldCollateral.LLC_BI__Type__c;
                return collateral;
     }

     private Id getCollateralType(String type, String subtype, String uccType) {
          type = type == null ? Label.Pick_List_None_Text : type.trim();
          if(type == UCC){
                subtype = uccType == null ? Label.Pick_List_None_Text : uccType.split(';')[0].trim();
          } else {
                subtype = subtype == null ? Label.Pick_List_None_Text : subtype.trim();
          }
          return collateralTypeMap.get(type+subtype);
     }

     private String joinText(String text1, String text2) {
          if (String.isBlank(text1)) {
                text1 = '';
          }

          if (String.isBlank(text2)) {
                text2 = '';
          }

          if (String.isNotBlank(text1) && String.isNotBlank(text2)) {
                return text1 + NEW_LINE + text2;
          } else {
                return text1 + text2;
          }
     }

     private Id getUserId(User collateralCreator) {
          if(collateralCreator != null && collateralCreator.IsActive) {
                return collateralCreator.Id;
          }
          return UserInfo.getUserId();
     }

     transient private static final String CONVERT_ERROR_MSG = 'Could not convert Lien Amount on {0}';
     transient private static final String TYPE_ERROR_MSG = 'Could not find type on {0}';
     transient private static final String UCC = 'UCC';
     transient private static final String NEW_LINE = '\r\n';
}
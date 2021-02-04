global class CSA_ConfigValueDataInstaller implements InstallHandler, UninstallHandler {	
    global void onInstall(InstallContext context) {
        LLC_BI__System_Properties__c property = this.getCreateSystemProperty(PROPERTYCATEGORY, 
																			 PROPERTYACTIVE, 
																			 PROPERTYKEY, 
																			 PROPERTYVALUE);

		Database.insert(property);

		List<LLC_BI__CFG_ConfigValue__c> configValues = getConfigValues(getExistingConfigValues());
		Database.insert(configValues);

		List<LLC_BI__CFG_ConfigKey__c> configKeys = getConfigKeys(getExistingConfigKeys());
		Database.insert(configKeys);
    }

	global void onUninstall(UninstallContext context) {
		List<LLC_BI__System_Properties__c> systemProperties = this.getSystemProperties(PROPERTYCATEGORY, 
																					   PROPERTYKEY);

		if (!systemProperties.isEmpty()) {
			Database.delete(systemProperties);
		}
	}

	private List<LLC_BI__System_Properties__c> getSystemProperties(String category, String key) {
		return [SELECT
					Id
				FROM
					LLC_BI__System_Properties__c
				WHERE 
					LLC_BI__Category_Name__c = :category
				AND
					LLC_BI__Key__c = :key];
	}

	private LLC_BI__System_Properties__c getCreateSystemProperty(String category, 
																 Boolean active, 
																 String key, 
																 String value) {
		LLC_BI__System_Properties__c newSP = new LLC_BI__System_Properties__c(
			Name = generateRandomString(18),
			LLC_BI__Category_Name__c = category,
			LLC_BI__Is_Active__c = active,
			LLC_BI__Key__c = key,
			LLC_BI__Value__c = value);

		return newSP;
	}

	private List<LLC_BI__CFG_ConfigValue__c> getExistingConfigValues() {
		return [SELECT
					Id,
					LLC_BI__lookupKey__c
				FROM
					LLC_BI__CFG_ConfigValue__c];
	}

	private List<LLC_BI__CFG_ConfigKey__c> getExistingConfigKeys() {
		return [SELECT
					Id,
					LLC_BI__lookupKey__c
				FROM 
					LLC_BI__CFG_ConfigKey__c];
	}

	public List<LLC_BI__CFG_ConfigKey__c> getConfigKeys(List<LLC_BI__CFG_ConfigKey__c> existingConfigKeyList) {
		List<LLC_BI__CFG_ConfigKey__c> configKeyCreateList = new List<LLC_BI__CFG_ConfigKey__c>();
		LLC_BI__CFG_ConfigKey__c newCK = new LLC_BI__CFG_ConfigKey__c();

		newCK = new LLC_BI__CFG_ConfigKey__c(
			Name = 'KY_DM_ReviewerRoles',
			LLC_BI__lookupKey__c = 'KY_DM_ReviewerRole');
		if (checkConfigKeyExists(existingConfigKeyList, newCK.LLC_BI__lookupKey__c)) {
			configKeyCreateList.add(newCK);
		}
		newCK = new LLC_BI__CFG_ConfigKey__c(
			Name = 'KY_GBL_ChangeMemo',
			LLC_BI__lookupKey__c = 'KY_GBL_ChangeMemo');
		if (checkConfigKeyExists(existingConfigKeyList, newCK.LLC_BI__lookupKey__c)) {
			configKeyCreateList.add(newCK);
		}
		newCK = new LLC_BI__CFG_ConfigKey__c(
			Name = 'KY_GBL_CreditRole',
			LLC_BI__lookupKey__c = 'KY_GBL_CreditRole');
		if (checkConfigKeyExists(existingConfigKeyList, newCK.LLC_BI__lookupKey__c)) {
			configKeyCreateList.add(newCK);
		}
		newCK = new LLC_BI__CFG_ConfigKey__c(
			Name = 'KY_GBL_NamespacePrefixBI',
			LLC_BI__lookupKey__c = 'KY_GBL_NS_PrefixBI');
		if (checkConfigKeyExists(existingConfigKeyList, newCK.LLC_BI__lookupKey__c)) {
			configKeyCreateList.add(newCK);
		}
		newCK = new LLC_BI__CFG_ConfigKey__c(
			Name = 'KY_VER_Configuration',
			LLC_BI__lookupKey__c = 'KY_VER_Config');
		if (checkConfigKeyExists(existingConfigKeyList, newCK.LLC_BI__lookupKey__c)) {
			configKeyCreateList.add(newCK);
		}
		newCK = new LLC_BI__CFG_ConfigKey__c(
			Name = 'KY_VER_Config',
			LLC_BI__lookupKey__c = 'KY_VER_Config');
		if (checkConfigKeyExists(existingConfigKeyList, newCK.LLC_BI__lookupKey__c)) {
			configKeyCreateList.add(newCK);
		}

		return configKeyCreateList;
	}

	public List<LLC_BI__CFG_ConfigValue__c> getConfigValues(List<LLC_BI__CFG_ConfigValue__c> existingConfigValueList) {
		List<LLC_BI__CFG_ConfigValue__c> configValuesCreateList = new List<LLC_BI__CFG_ConfigValue__c>();
		LLC_BI__CFG_ConfigValue__c newCV = new LLC_BI__CFG_ConfigValue__c();

		//Classic (HTML) Document Manager Configuration
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE9,
			LLC_BI__fieldValue__c = 'Chief Credit Officer,Loan Team Leader,Chief Operations Officer,Senior Credit Officer',
			LLC_BI__Key__c = 'DM_ReviewerRoles',
			LLC_BI__lookupKey__c = 'DM_ReviewerRoles');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}

		//Deletion Configuration
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE14,
			LLC_BI__fieldValue__c = 'Enabled',
			LLC_BI__Key__c = ALLKEY,
			LLC_BI__lookupKey__c = 'DEL_FEATURE_ENABLE');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE25,
			LLC_BI__fieldValue__c = 'Booked',
			LLC_BI__Key__c = ALLKEY,
			LLC_BI__lookupKey__c = 'DEL_STAGES_ALLOWED');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE26,
			LLC_BI__fieldValue__c = 'Closed',
			LLC_BI__Key__c = ALLKEY,
			LLC_BI__lookupKey__c = 'DEL_STATUS_ALLOWED');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE32,
			LLC_BI__fieldValue__c = 'Management,IT',
			LLC_BI__Key__c = ALLKEY,
			LLC_BI__lookupKey__c = 'ROLES_LOAN_DELETE');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE13,
			LLC_BI__fieldValue__c = 'ALL',
			LLC_BI__Key__c = ALLKEY,
			LLC_BI__lookupKey__c = 'DELETE_VER_ALLOWED');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}

		//General
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE8,
			LLC_BI__fieldValue__c = 'Credit',
			LLC_BI__Key__c = 'Bankr_BI_Prefix',
			LLC_BI__lookupKey__c = 'Bankr_BI_Prefix');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE8,
			LLC_BI__fieldValue__c = 'LLC_BI',
			LLC_BI__Key__c = 'CreditRole',
			LLC_BI__lookupKey__c = 'CreditRole');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}

		//Loan Configuration
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE2,
			LLC_BI__fieldValue__c = 'Declined',
			LLC_BI__Key__c = 'Declined',
			LLC_BI__lookupKey__c = 'Declined');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE1,
			LLC_BI__fieldValue__c = 'Complete',
			LLC_BI__Key__c = 'Complete',
			LLC_BI__lookupKey__c = 'Complete');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE1,
			LLC_BI__fieldValue__c = 'Booked',
			LLC_BI__Key__c = 'Closed',
			LLC_BI__lookupKey__c = 'Closed');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}

		//Memo (Formerly Known as Change Memo) Configuration
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE7,
			LLC_BI__fieldValue__c = 'No',
			LLC_BI__Key__c = 'CM_Enabled',
			LLC_BI__lookupKey__c = 'CM_Enabled');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE7,
			LLC_BI__fieldValue__c = 'Change Memo',
			LLC_BI__Key__c = 'CM_Name',
			LLC_BI__lookupKey__c = 'CM_Name');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE7,
			LLC_BI__fieldValue__c = 'TB-LOAN-CREDIT',
			LLC_BI__Key__c = 'CM_DocTabLookupKey',
			LLC_BI__lookupKey__c = 'CM_DocTabLookupKey');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE7,
			LLC_BI__fieldValue__c = 'TY024',
			LLC_BI__Key__c = 'CM_DocTypeLookupKey',
			LLC_BI__lookupKey__c = 'CM_DocTypLookupKey');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE7,
			LLC_BI__fieldValue__c = 'LLC_Loan',
			LLC_BI__Key__c = 'CM_DocManLookupKey',
			LLC_BI__lookupKey__c = 'CM_DocManLookupKey');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}

		//Renewal and Modifying Configuration
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE19,
			LLC_BI__fieldValue__c = '_R',
			LLC_BI__Key__c = ALLKEY,
			LLC_BI__lookupKey__c = 'REN_NAME_FORMAT');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE27,
			LLC_BI__fieldValue__c = '_M',
			LLC_BI__Key__c = ALLKEY,
			LLC_BI__lookupKey__c = 'MOD_NAME_FORMAT');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE28,
			LLC_BI__fieldValue__c = '_ORG',
			LLC_BI__Key__c = ALLKEY,
			LLC_BI__lookupKey__c = 'ORG_NAME_FORMAT');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE21,
			LLC_BI__fieldValue__c = 'Open',
			LLC_BI__Key__c = ALLKEY,
			LLC_BI__lookupKey__c = 'REN_STATUS_ALLOWED');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE22,
			LLC_BI__fieldValue__c = 'Booked',
			LLC_BI__Key__c = ALLKEY,
			LLC_BI__lookupKey__c = 'REN_STAGES_ALLOWED');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE17,
			LLC_BI__fieldValue__c = 'Qualification',
			LLC_BI__Key__c = ALLKEY,
			LLC_BI__lookupKey__c = 'REN_STARTING_STAGE');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE18,
			LLC_BI__fieldValue__c = 'Open',
			LLC_BI__Key__c = ALLKEY,
			LLC_BI__lookupKey__c = 'REN_STRTING_STATUS');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE15,
			LLC_BI__fieldValue__c = 'Enabled',
			LLC_BI__Key__c = ALLKEY,
			LLC_BI__lookupKey__c = 'REN_SUPPORTED');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE10,
			LLC_BI__fieldValue__c = 'Enabled',
			LLC_BI__Key__c = ALLKEY,
			LLC_BI__lookupKey__c = 'REN_FEATURE_ENABLE');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE29,
			LLC_BI__fieldValue__c = 'In Progress',
			LLC_BI__Key__c = ALLKEY,
			LLC_BI__lookupKey__c = 'REN_HIST_PROG_STR');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE30,
			LLC_BI__fieldValue__c = 'Available',
			LLC_BI__Key__c = ALLKEY,
			LLC_BI__lookupKey__c = 'REN_HIST_AVAIL_STR');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE31,
			LLC_BI__fieldValue__c = 'Superseded',
			LLC_BI__Key__c = ALLKEY,
			LLC_BI__lookupKey__c = 'REN_HIST_SUPER_STR');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE33,
			LLC_BI__fieldValue__c = 'Superseded',
			LLC_BI__Key__c = ALLKEY,
			LLC_BI__lookupKey__c = 'REN_STAT_SUPER_STR');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE34,
			LLC_BI__fieldValue__c = 'Booked',
			LLC_BI__Key__c = ALLKEY,
			LLC_BI__lookupKey__c = 'REN_STAG_SUPER_STR');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE35,
			LLC_BI__fieldValue__c = 'Deleted',
			LLC_BI__Key__c = ALLKEY,
			LLC_BI__lookupKey__c = 'REN_STATUS_DEL_STR');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE12,
			LLC_BI__fieldValue__c = 'Management,IT',
			LLC_BI__Key__c = ALLKEY,
			LLC_BI__lookupKey__c = 'ROLES_MULTI_DELETE');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE20,
			LLC_BI__fieldValue__c = '',
			LLC_BI__Key__c = ALLKEY,
			LLC_BI__lookupKey__c = 'FIELDS_TO_CLONE');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE11,
			LLC_BI__fieldValue__c = 'LLC_BI__Legal_Entities__c,LLC_BI__Covenant__c',
			LLC_BI__Key__c = ALLKEY,
			LLC_BI__lookupKey__c = 'RELATIVES_TO_CLONE');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}

		//Other: Config Values Not In Use
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE9,
			LLC_BI__fieldValue__c = '',
			LLC_BI__Key__c = 'DM_AmzOrgBucketName',
			LLC_BI__lookupKey__c = 'DM_OrgBucketName');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE23,
			LLC_BI__fieldValue__c = '',
			LLC_BI__Key__c = ALLKEY,
			LLC_BI__lookupKey__c = 'REN_ENTITY_CHECK');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}

		//Change Product
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE3,
			LLC_BI__fieldValue__c = 'Qualification,Proposal,Credit Underwriting',
			LLC_BI__Key__c = 'Allowed_Stages',
			LLC_BI__lookupKey__c = 'Allowed_Stages');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}
		newCV = new LLC_BI__CFG_ConfigValue__c(
			LLC_BI__Category__c = CATEGORYPICKLISTVALUE3,
			LLC_BI__fieldValue__c = 'Open',
			LLC_BI__Key__c = 'Allowed_Status',
			LLC_BI__lookupKey__c = 'Allowed_Status');
		if (checkConfigValueExists(existingConfigValueList, newCV.LLC_BI__lookupKey__c)) {
			configValuesCreateList.add(newCV);
		}

		return configValuesCreateList;
	}

	private static Boolean checkConfigValueExists(List<LLC_BI__CFG_ConfigValue__c> existingConfigValue, String lookupKey) {
		Boolean checked = true;

		for (LLC_BI__CFG_ConfigValue__c cv: existingConfigValue) {
			if (cv.LLC_BI__lookupKey__c == lookupKey) {
				checked = false;
			}
		}

		return checked;
	}

	private static Boolean checkConfigKeyExists(List<LLC_BI__CFG_ConfigKey__c> existingConfigKey, String lookupKey) {
		Boolean checked = true;

		for (LLC_BI__CFG_ConfigKey__c ck: existingConfigKey) {
			if (ck.LLC_BI__lookupKey__c == lookupKey) {
				checked = false;
			}
		}

		return checked;
	}

	public static String generateRandomString(Integer len) {
		final String chars = NUMBERSFORRANDOMIZER;
		String randStr = BLANK;
		while (randStr.length() < len) {
			Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
			randStr += chars.substring(idx, idx + 1);
		}
		return randStr; 
	}

	private static final String PROPERTYCATEGORY = 'CSA Config Admin';
	private static final Boolean PROPERTYACTIVE = true;
	private static final String PROPERTYKEY = 'Is_Installed_Config_Values';
	private static final String PROPERTYVALUE = 'true';
	private static final String NUMBERSFORRANDOMIZER = '0123456789';
	private static final String BLANK = '';

	/**
	* Config Value Category Picklist Values
	**/

	private static final String CATEGORYPICKLISTVALUE1  = 'Loan Stage';
	private static final String CATEGORYPICKLISTVALUE2  = 'Loan Status';
	private static final String CATEGORYPICKLISTVALUE3  = 'Change Product';
	private static final String CATEGORYPICKLISTVALUE4  = 'Deposit Stage';
	private static final String CATEGORYPICKLISTVALUE5  = 'Deposit Status';
	private static final String CATEGORYPICKLISTVALUE6  = 'Label';
	private static final String CATEGORYPICKLISTVALUE7  = 'Change Memo';
	private static final String CATEGORYPICKLISTVALUE8  = 'General';
	private static final String CATEGORYPICKLISTVALUE9  = 'Document Manager';
	private static final String CATEGORYPICKLISTVALUE10 = 'Renewal_Feature_Enabled';
	private static final String CATEGORYPICKLISTVALUE11 = 'Relatives_To_Clone';
	private static final String CATEGORYPICKLISTVALUE12 = 'Roles_For_Multi-Renewal_Delete';
	private static final String CATEGORYPICKLISTVALUE13 = 'Delete_Versions_Allowed';
	private static final String CATEGORYPICKLISTVALUE14 = 'Delete_Feature_Enabled';
	private static final String CATEGORYPICKLISTVALUE15 = 'Renewal_Supported';
	private static final String CATEGORYPICKLISTVALUE16 = 'Roles_For_Loan_Renewal';
	private static final String CATEGORYPICKLISTVALUE17 = 'Renewal_Starting_Stage';
	private static final String CATEGORYPICKLISTVALUE18 = 'Renewal_Starting_Status';
	private static final String CATEGORYPICKLISTVALUE19 = 'Renewal_Name_Format';
	private static final String CATEGORYPICKLISTVALUE20 = 'Renewal_Fields_To_Clone';
	private static final String CATEGORYPICKLISTVALUE21 = 'Status_Renewal_Allowed';
	private static final String CATEGORYPICKLISTVALUE22 = 'Stages_Renewal_Allowed';
	private static final String CATEGORYPICKLISTVALUE23 = 'Entity_Check_Enabled';
	private static final String CATEGORYPICKLISTVALUE24 = 'PRODUCT_PACKAGE';

	private static final String CATEGORYPICKLISTVALUE25 = 'Stages_Deletion_Allowed';
	private static final String CATEGORYPICKLISTVALUE26 = 'Status_Deletion_Allowed';
	private static final String CATEGORYPICKLISTVALUE27 = 'Modification_Name_Format';
	private static final String CATEGORYPICKLISTVALUE28 = 'Original_Name_Format';
	private static final String CATEGORYPICKLISTVALUE29 = 'Renewal_History_In_Progress_String';
	private static final String CATEGORYPICKLISTVALUE30 = 'Renewal_History_Available_String';
	private static final String CATEGORYPICKLISTVALUE31 = 'Renewal_History_Superceded_String';
	private static final String CATEGORYPICKLISTVALUE32 = 'Roles_For_Loan_Deletion';
	private static final String CATEGORYPICKLISTVALUE33 = 'Renewal_Status_Superceded_String';
	private static final String CATEGORYPICKLISTVALUE34 = 'Renewal_Stage_Superceded_String';
	private static final String CATEGORYPICKLISTVALUE35 = 'Renewal_Status_Deleted_String';

	private static final String ALLKEY = 'ALL';
}
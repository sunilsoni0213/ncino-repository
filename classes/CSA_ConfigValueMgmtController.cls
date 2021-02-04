public class CSA_ConfigValueMgmtController {
	public Boolean showHome {get;Set;}
	public Boolean showNew {get;Set;}
	public Boolean showEdit {get;Set;}
	public Boolean isSaveNew {get;Set;}
	public Id configValueId {get;Set;}
	public String[] selectedFieldValues {get;Set;}
	public String category {get;Set;}
	public String[] selectedAvailableKeys {get;Set;}
	public String[] selectedUsedKeys {get;Set;}
	public String successMessage {get;Set;}
	public String errorMessage {get;Set;}

	public List<LLC_BI__CFG_ConfigValue__c> configValues {get;Set;}
	public LLC_BI__CFG_ConfigValue__c configValue {get;Set;}

	public List<Schema.FieldSetMember> configValueListViewFieldSet {get;Set;}
	public List<Schema.FieldSetMember> configValueNewEditFieldSet {get;Set;}

	public List<SelectOption> availableConfigKeys {get;Set;}
	public List<SelectOption> usedConfigKeys {get;Set;}

	public CSA_ConfigValueMgmtController() {
		this.configValues = getConfigValues();
		this.renderedPanels(true, false, false);
		this.configValueListViewFieldSet = getConfigValueListViewFieldSet();
		this.configValueNewEditFieldSet = getConfigValueNewEditFieldSet();
	}

	public void configValueNew() {
		this.renderedPanels(false, true, false);
		this.selectedAvailableKeys = new List<String>();
		this.configValue = new LLC_BI__CFG_ConfigValue__c();
		this.availableConfigKeys = new List<SelectOption>();
		this.usedConfigKeys = new List<SelectOption>();

		for (LLC_BI__CFG_ConfigKey__c ck: getConfigKeysAll()) {
			this.availableConfigKeys.add(new SelectOption(ck.Id, ck.Name));
		}

		resetMessages();
	}

	public void configValueEdit() {
		this.availableConfigKeys = new List<SelectOption>();
		this.usedConfigKeys = new List<SelectOption>();
		this.selectedAvailableKeys = new List<String>();
		this.selectedUsedKeys = new List<String>();
		this.selectedFieldValues = new List<String>();
		this.renderedPanels(false, false, true);
		this.configValue = getConfigValue(this.configValueId);
		this.category = getCategory(this.configValue.LLC_BI__Category__c, this.configValue.LLC_BI__lookupKey__c);
		if (this.category != null && String.isNotBlank(this.configValue.LLC_BI__fieldValue__c)) {
			this.selectedFieldValues = this.configValue.LLC_BI__fieldValue__c.split(COMMA);
		}

		for (LLC_BI__CFG_ConfigKey__c ck: getConfigKeysAvailable(this.configValueId)) {
			this.availableConfigKeys.add(new SelectOption(ck.Id, ck.Name));
		}

		for (LLC_BI__CFG_ConfigKey__c ck: getConfigKeysUsed(this.configValueId)) {
			this.usedConfigKeys.add(new SelectOption(ck.Id, ck.Name));
		}

		resetMessages();
	}

	public void back() {
		this.renderedPanels(true, false, false);
		resetMessages();
	}

	public void configValueDelete() {
		this.configValue = getConfigValue(this.configValueId);

		try  {	        
			Database.delete(this.configValue);
			this.configValues = getConfigValues();
			this.successMessage = System.Label.Config_Value_Mgmt_Success_Delete;
		} catch (Exception ex) {
			this.errorMessage = ex.getMessage();
		}
	}

	public void configValueSaveNew() {
		List<LLC_BI__CFG_CKJ__c> configJoinsCreate = new List<LLC_BI__CFG_CKJ__c>();
		try {	        
			Database.insert(this.configValue);

			for (String s: selectedAvailableKeys) {
				configJoinsCreate.add(new LLC_BI__CFG_CKJ__c(
											LLC_BI__CFG_ConfigKeys__c = s, 
											LLC_BI__CFG_ConfigValue__c = this.configValue.Id));
			}

			Database.insert(configJoinsCreate);
			if (isSaveNew) {
				this.configValueNew();
			} else {
				this.renderedPanels(true, false, false);
				this.configValues = getConfigValues();
				this.successMessage = System.Label.Config_Value_Mgmt_Success_Created;
			}
		} catch(Exception ex) {
			this.errorMessage = ex.getMessage();
		}
	}

	public void configValueSaveEdit() {
		List<LLC_BI__CFG_CKJ__c> configJoinsCreate = new List<LLC_BI__CFG_CKJ__c>();
		List<LLC_BI__CFG_CKJ__c> configJoinsDelete = new List<LLC_BI__CFG_CKJ__c>();
		
		configJoinsDelete = getConfigJoinsDelete(this.configValue.Id, this.selectedUsedKeys);

		for(String s: this.selectedAvailableKeys) {
			configJoinsCreate.add(new LLC_BI__CFG_CKJ__c(
										  LLC_BI__CFG_ConfigValue__c = this.configValue.Id,
										  LLC_BI__CFG_ConfigKeys__c = s));
		}

		String fieldValue = BLANK;

		if (getUsage(this.configValue.LLC_BI__lookupKey__c, this.configValue.LLC_BI__Category__c)) {
			for (String s: this.selectedFieldValues) {
				fieldValue += s + COMMA;
			}

			fieldValue = fieldValue.removeEnd(COMMA);

			this.configValue.LLC_BI__fieldValue__c = fieldValue;
		}

		try {
			Database.update(this.configValue);
			Database.insert(configJoinsCreate);
			Database.delete(configJoinsDelete);

			this.renderedPanels(true, false, false);
			this.configValues = getConfigValues();
			this.successMessage = System.Label.Config_Value_Mgmt_Success_Updated;
		} catch (Exception ex) {
			this.errorMessage = ex.getMessage();
		}
	}

	private List<LLC_BI__CFG_ConfigKey__c> getConfigKeysAvailable(Id recordId) {
		return [SELECT 
					Id, 
					Name 
				FROM 
					LLC_BI__CFG_ConfigKey__c 
				WHERE 
					Id NOT IN (SELECT 
									LLC_BI__CFG_ConfigKeys__c 
								FROM 
									LLC_BI__CFG_CKJ__c 
								WHERE 
									LLC_BI__CFG_ConfigValue__c = :recordId)];
	}

	private List<LLC_BI__CFG_CKJ__c> getConfigJoinsDelete(Id recordId, List<String> usedIds) {
		return [SELECT 
					Id
				FROM 
					LLC_BI__CFG_CKJ__c 
				WHERE 
					LLC_BI__CFG_ConfigValue__c = :recordId
				AND
					LLC_BI__CFG_ConfigKeys__c IN :usedIds];
	}

	private List<LLC_BI__CFG_ConfigKey__c> getConfigKeysUsed(Id recordId) {
		return [SELECT 
					Id, 
					Name 
				FROM 
					LLC_BI__CFG_ConfigKey__c 
				WHERE 
					Id IN (SELECT 
								LLC_BI__CFG_ConfigKeys__c 
							FROM 
								LLC_BI__CFG_CKJ__c 
							WHERE 
								LLC_BI__CFG_ConfigValue__c = :recordId)];
	}

	private List<LLC_BI__CFG_ConfigKey__c> getConfigKeysAll() {
		return [SELECT 
					Id, 
					Name 
				FROM 
					LLC_BI__CFG_ConfigKey__c];
	}

	private List<LLC_BI__CFG_ConfigValue__c> getConfigValues() {
		return [SELECT
					Id,
					Name,
					LLC_BI__Category__c,
					LLC_BI__fieldValue__c,
					LLC_BI__Key__c,
					LLC_BI__lookupKey__c
				FROM 
					LLC_BI__CFG_ConfigValue__c
				ORDER BY
					LLC_BI__Category__c ASC];
	}

	private LLC_BI__CFG_ConfigValue__c getConfigValue(Id recordId) {
		return [SELECT
					Id,
					Name,
					LLC_BI__Category__c,
					LLC_BI__fieldValue__c,
					LLC_BI__Key__c,
					LLC_BI__lookupKey__c
				FROM 
					LLC_BI__CFG_ConfigValue__c
				WHERE
					Id = :recordId];
	}

	 public List<SelectOption> getStagePicklist() {
        List<SelectOption> newSO = new List<SelectOption>();
        for (Schema.PicklistEntry p: LLC_BI__Loan__c.LLC_BI__Stage__c.getDescribe().getPicklistValues()) {
            newSO.add(new SelectOption(p.value, p.label));
        }

        return newSO;
    }

    public List<SelectOption> getStatusPicklist() {
        List<SelectOption> newSO = new List<SelectOption>();
        for (Schema.PicklistEntry p: LLC_BI__Loan__c.LLC_BI__Status__c.getDescribe().getPicklistValues()) {
            newSO.add(new SelectOption(p.value, p.label));
        }

        return newSO;
    }

	public List<SelectOption> getRolesPicklist() {
        List<SelectOption> newSO = new List<SelectOption>();
        for (UserRole r: getRoles()) {
            newSO.add(new SelectOption(r.Name, r.Name));
        }
        return newSO;
    }

	private List<UserRole> getRoles() {
		return [SELECT
					Id,
					Name
				FROM 
					UserRole];
	}

	public List<SelectOption> getFieldAPIPickList() {
		List<Schema.SObjectType> objects = new List<Schema.SObjectType>{LLC_BI__Loan__c.SObjectType};
		List<SelectOption> fieldList = new List<SelectOption>();
		for(Schema.SObjectType objType: objects){
			for(Schema.SObjectField fld: objType.getDescribe().fields.getMap().values()){
				if (fld.getDescribe().isCreateable()) {
					fieldList.add(new SelectOption(fld.getDescribe().getName(), fld.getDescribe().getName()));
				}
			}
		}
		return fieldList;
    }

	private List<Schema.FieldSetMember> getConfigValueListViewFieldSet() {
		return SObjectType.LLC_BI__CFG_ConfigValue__c.FieldSets.CSA_Config_Value_List_View.getFields();
	}

	private List<Schema.FieldSetMember> getConfigValueNewEditFieldSet() {
		return SObjectType.LLC_BI__CFG_ConfigValue__c.FieldSets.CSA_Config_Value_New_Edit.getFields();
	}

	private void renderedPanels(Boolean home, Boolean cvNew, Boolean edit) {
		this.showHome = home;
		this.showNew = cvNew;
		this.showEdit = edit;
	}

	private Boolean getUsage(String lookupkey, String category) {
		if (lookupkey.contains(STAGE) || 
			category.contains(STAGE) ||
			lookupkey.contains(STATUS) ||
			category.contains(STATUS) ||
			lookupkey.contains(ROLE) || 
			category.contains(ROLE) ||
			lookupkey.contains(FIELD) ||
			category.contains(FIELD)) {

			if (category == RENEWALSTATUSDELETEDSTRING || category == RENEWALSTATUSSUPERCEDEDSTRING) {
				return false;
			} else {
				return true;
			}
		} else {
			return false;
		}
	}

	private String getCategory(String cat, String lookupKey) {
		if(cat == RENEWALSTATUSDELETEDSTRING || cat == RENEWALSTATUSSUPERCEDEDSTRING) {
			return null;
		} else if (cat.contains(STAGE) || lookupKey.contains(STAGE)) {
			return STAGE;
		} else if(cat.contains(STATUS) || lookupKey.contains(STATUS)) {
			return STATUS;
		} else if(cat.contains(ROLE) || lookupKey.contains(ROLE)) {
			return ROLE;
		} else if(cat.contains(FIELD) || lookupKey.contains(FIELD)) {
			return FIELD;
		} else {
			return null;
		}
	}

	private void resetMessages() {
		this.successMessage = null;
		this.errorMessage = null;
	}

	private final static String STAGE = 'Stage';
    private final static String STATUS = 'Status';
    private final static String ROLE = 'Role';
    private final static String FIELD = 'Field';
	private final static String COMMA = ',';
	
	private final static String BLANK = '';
	private final static String RENEWALSTATUSDELETEDSTRING = 'Renewal_Status_Deleted_String';
	private final static String RENEWALSTATUSSUPERCEDEDSTRING = 'Renewal_Status_Superceded_String';
}
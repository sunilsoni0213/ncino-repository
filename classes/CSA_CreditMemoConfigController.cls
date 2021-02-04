public class CSA_CreditMemoConfigController {
	public Id creditMemoId {get;Set;}
	public Id screenSectionId {get;Set;}
	public Boolean isHeadless {get;Set;}
	public Decimal displayOrder {get;Set;}
	public String widgetType {get;Set;}
	public String successMessage {get;Set;}
	public String errorMessage {get;Set;}
  
	public LLC_BI__Credit_Memo__c creditMemo {get;Set;}
	public List<LLC_BI__Credit_Memo__c> creditMemoTempaltes {get;Set;}
	public List<CSA_ScreenSectionList> screenSections {get;Set;}
	public nFORCE__Screen_Section__c screenSection {get;Set;}

	public Boolean showHome {get;Set;}
	public Boolean showCreditMemoNew {get;Set;}
	public Boolean showCreditMemoEdit {get;Set;}
	public Boolean showCreditMemoView {get;Set;}
	public Boolean showScreenSectionEdit {get;Set;}
	public Boolean showScreenSectionNew {get;Set;}

	public List<Schema.FieldSetMember> creditMemoListFieldSet {get;Set;}
	public List<Schema.FieldSetMember> creditMemoViewFieldSet {get;Set;}
	public List<Schema.FieldSetMember> creditMemoNewEditFieldSet {get;Set;}
	public List<Schema.FieldSetMember> screenSectionListFieldSet {get;Set;}
	public List<Schema.FieldSetMember> screenSectionNewEditFieldSet {get;Set;}
  
    public CSA_CreditMemoConfigController() {
		this.rerenderPanels(true, false, false, false, false, false);
		this.creditMemoTempaltes = getCreditMemoTemplates();
		this.creditMemoListFieldSet = getCreditMemoListFieldSet();
		this.creditMemoNewEditFieldSet = getCreditMemoNewEditFieldSet();
		this.screenSectionListFieldSet = getScreenSectionListFieldSet();
		this.creditMemoViewFieldSet = getCreditMemoViewFieldSet();
		this.screenSectionNewEditFieldSet = getScreenSectionNewEditFieldSet();
    }

	public void back() {
		this.rerenderPanels(true, false, false, false, false, false);
		this.creditMemoTempaltes = getCreditMemoTemplates();
	}

	public void backSecondary() {
		this.rerenderPanels(false, false, false, true, false, false);
		resetMessages();
	}

	public void creditMemoNew() {
		this.rerenderPanels(false, true, false, false, false, false);

		this.creditMemo = new LLC_BI__Credit_Memo__c(
			LLC_BI__Is_Template__c = true,
			LLC_BI__lookupKey__c = generateRandomString(18));

		resetMessages();
	}

	public void creditMemoSaveNew() {
		try {
			nFORCE__Screen__c newS = new nFORCE__Screen__c(
				Name = this.creditMemo.Name,
				nFORCE__Disable_Print__c = true,
				nFORCE__lookupKey__c = generateRandomString(18),
				nFORCE__Show_Link_To_Context_Object__c = true);

			Database.insert(newS);
			this.creditMemo.LLC_BI__FScreen__c = newS.Id;

			try {
				Database.insert(this.creditMemo);
				this.creditMemoId = this.creditMemo.Id;
				this.creditMemoViewEdit();
				this.successMessage = System.Label.Credit_Memo_Wizard_Success_Create;
			} catch (Exception ex) {
				errorMessage = ex.getMessage();
			}
		} catch (Exception ex) {
			errorMessage = ex.getMessage();
		}
	}

	public void creditMemoDelete() {
		this.creditMemo = getCreditMemo(this.creditMemoId);
		nFORCE__Screen__c screenDelete = getScreenDelete(this.creditMemo.LLC_BI__FScreen__c);
		List<Id> sectionConfigIds = new List<Id>();
		
		List<nFORCE__Section_Configuration__c> sectionConfigRef = getSectionConfigRef(this.creditMemo.LLC_BI__FScreen__c);
		for (nFORCE__Section_Configuration__c sc: sectionConfigRef) {
			sectionConfigIds.add(sc.nFORCE__Layout__c);
		}

		List<nFORCE__Widget__c> widgetsDelete = getWidgetsDelete(this.creditMemo.LLC_BI__FScreen__c);
		List<nFORCE__View__c> viewsDelete = getViewsDelete(this.creditMemo.LLC_BI__FScreen__c);
		List<nFORCE__Layout__c> layoutsDelete = [SELECT Id FROM nFORCE__Layout__c WHERE Id IN :sectionConfigIds];

		try {
			Database.delete(this.creditMemo);
			Database.delete(screenDelete);
			Database.delete(widgetsDelete);
			Database.delete(viewsDelete);
			Database.delete(layoutsDelete);
			this.creditMemoTempaltes = getCreditMemoTemplates();
			this.successMessage = System.Label.Credit_Memo_Wizard_Success_Delete;
		} catch (Exception ex) {
			errorMessage = ex.getMessage();
		}
	}

	public void creditMemoEdit() {
		this.rerenderPanels(false, false, true, false, false, false);
		resetMessages();
	}

	public void creditMemoSaveEdit() {
		try  {
			Database.update(this.creditMemo);
			this.creditMemoViewEdit();
			this.successMessage = System.Label.Credit_Memo_Wizard_Success_Update;
		} catch (Exception ex) {
			errorMessage = ex.getMessage();
		}
	}

	public void creditMemoViewEdit() {
		this.rerenderPanels(false, false, false, true, false, false);
		this.creditMemo = getCreditMemo(this.creditMemoId);
		this.screenSections = getScreenSections(this.creditMemo.LLC_BI__FScreen__c);
		resetMessages();
	}

	public void screenSectionEdit() {
		this.rerenderPanels(false, false, false, false, true, false);
		this.screenSection = getscreenSection(this.screenSectionId);
		resetMessages();
	}

	public void screenSectionNew() {
		this.rerenderPanels(false, false, false, false, false, true);
		this.widgetType = BLANK;
		if (this.displayOrder == null && !this.isHeadless) {
			this.screenSection = new nFORCE__Screen_Section__c(
				nFORCE__Screen__c = this.creditMemo.LLC_BI__FScreen__c,
				nFORCE__sObject_Type__c = this.creditMemo.LLC_BI__Object_API_Name__c,
				nFORCE__Display_Order__c = 10,
				nFORCE__Headless__c = this.isHeadless);
		} else if(this.displayOrder != null && this.isHeadless) {
			this.screenSection = new nFORCE__Screen_Section__c(
				nFORCE__Screen__c = this.creditMemo.LLC_BI__FScreen__c,
				nFORCE__sObject_Type__c = this.creditMemo.LLC_BI__Object_API_Name__c,
				nFORCE__Display_Order__c = this.displayOrder + 1,
				nFORCE__Headless__c = this.isHeadless);
		} else if(this.displayOrder != null && !this.isHeadless) {
			this.screenSection = new nFORCE__Screen_Section__c(
				nFORCE__Screen__c = this.creditMemo.LLC_BI__FScreen__c,
				nFORCE__sObject_Type__c = this.creditMemo.LLC_BI__Object_API_Name__c,
				nFORCE__Display_Order__c = this.displayOrder + 10,
				nFORCE__Headless__c = this.isHeadless);
		}
		resetMessages();
	}

	public void screenSectionSaveNew() {
		List<nFORCE__Screen_Section__c> screenSectionDOUpdate = new List<nFORCE__Screen_Section__c>();
		if (!this.screenSection.nFORCE__Headless__c) {
			screenSectionDOUpdate = getScreenSectionNonHeadless(
				getUsableDisplayOrder(this.displayOrder, this.isHeadless), 
				this.screenSection.nFORCE__Screen__c);

			for (nFORCE__Screen_Section__c ss: screenSectionDOUpdate) {
				ss.nFORCE__Display_Order__c = ss.nFORCE__Display_Order__c + 10;
			}
		} else {
			screenSectionDOUpdate = getScreenSectionHeadless(
				this.displayOrder, 
				getUsableDisplayOrder(this.displayOrder, this.isHeadless), 
				this.screenSection.nFORCE__Screen__c);

			for (nFORCE__Screen_Section__c ss: screenSectionDOUpdate) {
				ss.nFORCE__Display_Order__c = ss.nFORCE__Display_Order__c + 1;
			}
		}
		
		try {
			Database.update(screenSectionDOUpdate);
			this.screenSection.nFORCE__Widget__c = createWidget(this.widgetType);
			this.screenSection.nFORCE__Screen_View__c = createScreenView(this.widgetType);
			Database.insert(this.screenSection);

			if (this.screenSection.nForce__Widget__c != null && this.widgetType == Spreads_Appendix) {
				createSectionConfiguration(this.screenSection.Id);
			}
			
			creditMemoViewEdit();
			this.successMessage = System.Label.Credit_Memo_Wizard_SS_Success_Create;
		} catch(Exception ex) {
			errorMessage = ex.getMessage();
		}
	}

	public void screenSectionSaveEdit() {
		try {	        
			Database.update(this.screenSection);
			creditMemoViewEdit();
			this.successMessage = System.Label.Credit_Memo_Wizard_SS_Success_Update;
		} catch (Exception ex) {
			errorMessage = ex.getMessage();
		}
	}

	public void screenSectionDelete() {
		this.screenSection = getscreenSection(this.screenSectionId);
		List<nFORCE__Screen_Section__c> screenSectionDOUpdate = new List<nFORCE__Screen_Section__c>();
		List<nFORCE__Widget__c> deleteW = new List<nFORCE__Widget__c>();
		List<nFORCE__View__c> deleteV = new List<nFORCE__View__c>();

		try {
			if (!this.screenSection.nFORCE__Headless__c) {
				screenSectionDOUpdate = getScreenSectionNonHeadless(
					getUsableDisplayOrder(this.screenSection.nFORCE__Display_Order__c, this.screenSection.nFORCE__Headless__c), 
					this.screenSection.nFORCE__Screen__c);

				for (nFORCE__Screen_Section__c ss: screenSectionDOUpdate) {
					ss.nFORCE__Display_Order__c = ss.nFORCE__Display_Order__c - 10;
				}
			} else {
				screenSectionDOUpdate = getScreenSectionHeadless(
					this.screenSection.nFORCE__Display_Order__c, 
					getUsableDisplayOrder(this.screenSection.nFORCE__Display_Order__c, this.screenSection.nFORCE__Headless__c), 
					this.screenSection.nFORCE__Screen__c);

				for (nFORCE__Screen_Section__c ss: screenSectionDOUpdate) {
					ss.nFORCE__Display_Order__c = ss.nFORCE__Display_Order__c - 1;
				}
			}

			if (this.screenSection.nFORCE__Widget__c != null) {
				deleteW = getDeleteW(this.screenSection.nFORCE__Widget__c);
			}

			if (this.screenSection.nFORCE__Screen_View__c != null) {
				deleteV = getDeleteV(this.screenSection.nFORCE__Screen_View__c);
			}

			Database.delete(screenSection);
			Database.delete(deleteW);
			Database.delete(deleteV);

			Database.update(screenSectionDOUpdate);
			creditMemoViewEdit();
			this.successMessage = System.Label.Credit_Memo_Wizard_SS_Success_Delete;
		} catch (Exception ex) {
			errorMessage = ex.getMessage();
		}
	}

	public List<Schema.FieldSetMember> getCreditMemoListFieldSet() {
		return SObjectType.LLC_BI__Credit_Memo__c.FieldSets.CSA_Credit_Memo_List_View.getFields();
	}

	public List<Schema.FieldSetMember> getCreditMemoNewEditFieldSet() {
		return SObjectType.LLC_BI__Credit_Memo__c.FieldSets.CSA_Credit_Memo_New_Edit.getFields();
	}

	public List<Schema.FieldSetMember> getCreditMemoViewFieldSet() {
		return SObjectType.LLC_BI__Credit_Memo__c.FieldSets.CSA_Credit_Memo_View.getFields();
	}

	public List<Schema.FieldSetMember> getScreenSectionListFieldSet() {
		return SObjectType.nFORCE__Screen_Section__c.FieldSets.CSA_Screen_Section_List_View.getFields();
	}

	public List<Schema.FieldSetMember> getScreenSectionNewEditFieldSet() {
		return SObjectType.nFORCE__Screen_Section__c.FieldSets.CSA_Screen_Section_New_Edit.getFields();
	}

	private List<LLC_BI__Credit_Memo__c> getCreditMemoTemplates() {
		return [SELECT
					Id,
					Name,
					LLC_BI__Description__c, 
					LLC_BI__Object_API_Name__c, 
					LLC_BI__FScreen__c, 
					LLC_BI__Is_Disabled__c,
					LLC_BI__Is_Template__c,
					LLC_BI__lookupKey__c 
				FROM
					LLC_BI__Credit_Memo__c
				WHERE
					LLC_BI__Is_Template__c = True
				ORDER BY
					LLC_BI__Object_API_Name__c ASC];
	}

	private LLC_BI__Credit_Memo__c getCreditMemo(Id recordId) {
		return [SELECT
					Id,
					Name,
					LLC_BI__Description__c, 
					LLC_BI__Object_API_Name__c,
					LLC_BI__Is_Disabled__c,
					LLC_BI__FScreen__c
				FROM
					LLC_BI__Credit_Memo__c
				WHERE
					Id = :recordId LIMIT 1];
	}

	private List<CSA_ScreenSectionList> getScreenSections(Id recordId) {
		List<CSA_ScreenSectionList> newSSL = new List<CSA_ScreenSectionList>();
		List<nFORCE__Screen_Section__c> listScreenSections = getAvailableScreenSections(recordId);
		for (nFORCE__Screen_Section__c ss: listScreenSections) {
			newSSL.add(new CSA_ScreenSectionList(ss));
		}

		return newSSL;
	}

	private List<nFORCE__Screen_Section__c> getAvailableScreenSections(Id recordId) {
		return [SELECT 
					Id,
					Name,
					nFORCE__Break_Page_After__c,
					nFORCE__Break_Page_Before__c,
					nFORCE__Default_Editable__c,
					nFORCE__Default_Rendered__c,
					nFORCE__Disable_Print__c,
					nFORCE__Display_Order__c,
					nFORCE__Display_Toggle_Effect__c,
					nFORCE__Display_Toggle_Header__c,
					nFORCE__Display_Toggle_Link__c,
					nFORCE__Headless__c,
					nFORCE__Inactive__c,
					nFORCE__Instructions_Text__c,
					nFORCE__Is_Editable__c,
					nFORCE__Layout__c,
					nFORCE__lookupKey__c,
					nFORCE__Screen__c,
					nFORCE__Screen_View__c,
					nFORCE__Section_Resource__c,
					nFORCE__sObject_Type__c,
					nFORCE__Widget__c
				FROM 
					nFORCE__Screen_Section__c
				WHERE
					nFORCE__Screen__c = :recordId
				ORDER BY
					nFORCE__Display_Order__c ASC];
	}

	private nFORCE__Screen_Section__c getscreenSection(Id recordId) {
		return [SELECT 
					Id,
					Name,
					nFORCE__Break_Page_After__c,
					nFORCE__Break_Page_Before__c,
					nFORCE__Default_Editable__c,
					nFORCE__Default_Rendered__c,
					nFORCE__Disable_Print__c,
					nFORCE__Display_Order__c,
					nFORCE__Display_Toggle_Effect__c,
					nFORCE__Display_Toggle_Header__c,
					nFORCE__Display_Toggle_Link__c,
					nFORCE__Headless__c,
					nFORCE__Inactive__c,
					nFORCE__Instructions_Text__c,
					nFORCE__Is_Editable__c,
					nFORCE__Layout__c,
					nFORCE__lookupKey__c,
					nFORCE__Screen__c,
					nFORCE__Screen_View__c,
					nFORCE__Section_Resource__c,
					nFORCE__sObject_Type__c,
					nFORCE__Widget__c
				FROM 
					nFORCE__Screen_Section__c
				WHERE
					Id = :recordId LIMIT 1];
	}

	private List<nFORCE__Screen_Section__c> getScreenSectionNonHeadless(Decimal displayOrder, Id screenId) {
		return [SELECT 
					Id,
					nFORCE__Display_Order__c
				FROM
					nFORCE__Screen_Section__c
				WHERE
					nFORCE__Screen__c = :screenId
				AND
					nFORCE__Display_Order__c >= :displayOrder];
	}

	private List<nFORCE__Screen_Section__c> getScreenSectionHeadless(Decimal displayOrder, Decimal maxDisplayOrder, Id screenId) {
		return [SELECT 
					Id,
					nFORCE__Display_Order__c
				FROM
					nFORCE__Screen_Section__c
				WHERE
					nFORCE__Screen__c = :screenId
				AND
					nFORCE__Display_Order__c > :displayOrder
				AND 
					nFORCE__Display_Order__c < :maxDisplayOrder];
	}

	private List<nFORCE__Widget__c> getDeleteW(Id recordId) {
		return [SELECT
					Id
				FROM 
					nFORCE__Widget__c
				WHERE
					Id = :recordId];
	}

	private List<nFORCE__View__c> getDeleteV(Id recordId) {
		return [SELECT
					Id
				FROM 
					nFORCE__View__c
				WHERE
					Id = :recordId];
	}

	private List<nFORCE__Widget__c> getWidgetsDelete(Id recordId) {
		return [SELECT 
					Id 
				FROM 
					nFORCE__Widget__c 
				WHERE 
					Id IN (SELECT 
								nFORCE__Widget__c 
							FROM 
								nFORCE__Screen_Section__c 
							WHERE 
								nFORCE__Screen__c = :recordId)];
	}

	private List<nFORCE__View__c> getViewsDelete(Id recordId) {
		return [SELECT 
					Id 
				FROM 
					nFORCE__View__c 
				WHERE 
					Id IN (SELECT 
								nFORCE__Screen_View__c 
							FROM 
								nFORCE__Screen_Section__c 
							WHERE 
								nFORCE__Screen__c = :recordId)];
	}

	private List<nFORCE__Section_Configuration__c> getSectionConfigRef(Id recordId) {
		return [SELECT 
					Id, 
					nFORCE__Layout__c 
				FROM 
					nFORCE__Section_Configuration__c 
				WHERE 
					nFORCE__Screen_Section__c IN (SELECT 
														Id 
													FROM 
														nFORCE__Screen_Section__c 
													WHERE 
														nFORCE__Screen__c = :recordId)];
	}

	private nFORCE__Screen__c getScreenDelete(Id recordId) {
		return [SELECT 
					Id
				FROM 
					nFORCE__Screen__c
				WHERE
					Id = :recordId LIMIT 1];
	}

	private static Decimal getUsableDisplayOrder(Decimal num, Boolean headless) {
		if (headless) {
			String strNum = String.valueOf(num);
			Integer strLength = strNum.length();
			strNum = strNum.left(strLength - 1) + '0';
			return Decimal.valueOf(strNum) + 10;
		} else {
			return num + 10;
		}
	}

	public PageReference buildLayoutLink() {
		PageReference pageRef = new PageReference(LAYOUTBUILDERURL);
		pageRef.setRedirect(true);
		pageRef.getParameters().put(PARAMETER_NAME, screenSectionId);
		return pageRef;
	}

	private void rerenderPanels(Boolean home, Boolean cmNew, Boolean cmEdit, Boolean cmView, Boolean ssEdit, Boolean ssNew) {
		this.showHome = home;
		this.showCreditMemoNew = cmNew;
		this.showCreditMemoEdit = cmEdit;
		this.showCreditMemoView = cmView;
		this.showScreenSectionEdit = ssEdit;
		this.showScreenSectionNew = ssNew;
	}

	public List<SelectOption> getWidgetOptions() {
		List<SelectOption> newS = new List<SelectOption>();
    
		newS.add(new SelectOption(BLANK, System.Label.Credit_Memo_Wizard_None_Optoin));
		newS.add(new SelectOption(Approval_Process, System.Label.Credit_Memo_Wizard_Approval_Process_Option));
		newS.add(new SelectOption(Narrative, System.Label.Credit_Memo_Wizard_Narrative_Option));
		newS.add(new SelectOption(Spreads_Appendix, System.Label.Credit_Memo_Wizard_Spreads_Appendix_Option));
		newS.add(new SelectOption(Global_Analysis, System.Label.Credit_Memo_Wizard_Global_Analysis_Option));
		newS.add(new SelectOption(Debt_Schedule, System.Label.Credit_Memo_Wizard_Debt_Schedule_Option));

		return newS;
	}
	
	private static Id createWidget(String wType) {
		nFORCE__Widget__c newW = new nFORCE__Widget__c();

		if (wType == Approval_Process) {
			newW = new nFORCE__Widget__c(
				Name = WIDGETNAME_FIELD_APPROVAL,
				nFORCE__Type__c = WIDGETTYPE_FIELD,
				nFORCE__View__c = getWidgetViewCode(wType).escapeHtml3(),
				nFORCE__Script_Resource_One__c = WIDGETSCRIPTONE_APPROVAL,
				nFORCE__Script_Resource_Two__c = WIDGETSCRIPTTWO_APPROVAL);

			Database.insert(newW);
			return newW.Id;

		} else if(wType == Narrative) {
				newW = new nFORCE__Widget__c(
				Name = WIDGETNAME_FIELD_NARRATIVE,
				nFORCE__Type__c = WIDGETTYPE_FIELD,
                nFORCE__Parameters__c = WIDGETPARAMETERS_NARRATIVE,
				nFORCE__View__c = getWidgetViewCode(wType).escapeHtml3(),
				nFORCE__Script_Resource_One__c = WIDGETSCRIPTONE_NARRATIVE,
				nFORCE__Script_Resource_Two__c = WIDGETSCRIPTTWO_NARRATIVE,
				nFORCE__Script_Resource_Three__c = WIDGETSCRIPTTHREE_NARRATIVE);

			Database.insert(newW);
			return newW.Id;

		} else if(wType == Spreads_Appendix) {
			newW = new nFORCE__Widget__c(
				Name = WIDGETNAME_FIELD_SPREAD,
				nFORCE__Type__c = WIDGETTYPE_FIELD,
				nFORCE__Parameters__c = WIDGETPARAMETERS_SPREAD,
				nFORCE__Script_Resource_One__c = WIDGETSCRIPTONE_SPREAD,
				nFORCE__Script_Resource_Two__c = WIDGETSCRIPTTWO_SPREAD,
				nFORCE__Script_Resource_Three__c = WIDGETSCRIPTTHREE_SPREAD,
				nFORCE__Script_Resource_Four__c = WIDGETSCRIPTFOUR_SPREAD,
				nFORCE__Script_Resource_Five__c = WIDGETSCRIPTFIVE_SPREAD,
				nFORCE__Script_Resource_Six__c = WIDGETSCRIPTSIX_SPREAD);

			Database.insert(newW);
			return newW.Id;

		} else if(wType == Global_Analysis) {
			newW = new nFORCE__Widget__c(
				Name = WIDGETNAME_FIELD_GLOBAL,
				nFORCE__Type__c = WIDGETTYPE_FIELD,
				nFORCE__View__c = getWidgetViewCode(wType).escapeHtml3(),
				nFORCE__Script_Resource_One__c = WIDGETSCRIPTONE_GLOBAL,
				nFORCE__Script_Resource_Two__c = WIDGETSCRIPTTWO_GLOBAL,
				nFORCE__Script_Resource_Three__c = WIDGETSCRIPTTHREE_GLOBAL);

			Database.insert(newW);
			return newW.Id;

		} else if(wType == Debt_Schedule) {
			newW = new nFORCE__Widget__c(
				Name = WIDGETNAME_FIELD_DEBT,
				nFORCE__Type__c = WIDGETTYPE_FIELD,
				nFORCE__Script_Resource_One__c = WIDGETSCRIPTONE_DEBT,
				nFORCE__Script_Resource_Two__c = WIDGETSCRIPTTWO_DEBT,
				nFORCE__Script_Resource_Three__c = WIDGETSCRIPTTHREE_DEBT,
				nFORCE__Script_Resource_Four__c = WIDGETSCRIPTFOUR_DEBT);

			Database.insert(newW);
			return newW.Id;

		} else {
			return null;
		}
	}

	private static String getWidgetViewCode(String wType) {
		if (wType == Approval_Process) {
			return WIDGET_APPROVALPROCESS;
		} else if(wType == Narrative) {
			return WIDGET_NARRATIVE;
		} else if(wType == Global_Analysis) {
			return WIDGET_GLOBALANALYSIS;
		} else {
			return null;
		}
	}

	private static Id createScreenView(String wType) {
		nFORCE__View__c newView = new nFORCE__View__c();

		if(wType == Spreads_Appendix) {
			newView = new nFORCE__View__c(
				nFORCE__Read_Only__c = VIEW_SPREADSAPPENDIX.escapeHtml3());

			Database.insert(newView);
			return newView.Id;
		} else {
			return null;
		}
	}

	private void createSectionConfiguration(Id screenSectionId) {

		nFORCE__Section_Configuration__c newSC1 = new nFORCE__Section_Configuration__c(
			nFORCE__Display_Order__c = 1.01,
			nFORCE__Screen_Section__c = screenSectionId,
			nFORCE__sObject_Type__c = SECTIONCONFIG_OBJECT_LOAN,
			nFORCE__lookupKey__c = generateRandomString(18));

		Database.insert(newSC1);

		nFORCE__Section_Configuration__c newSC2 = new nFORCE__Section_Configuration__c(
			nFORCE__Display_Order__c = 2.01,
			nFORCE__Field_Set_Key__c = SECTIONCONFIG_FIELDSET_ENTITIY,
			nFORCE__Parent_Configuration__c = newSC1.Id,
			nFORCE__Parent_Relationship_Name__c = SECTIONCONFIG_OBJECT_ENTITY,
			nFORCE__Screen_Section__c = screenSectionId,
			nFORCE__sObject_Type__c = SECTIONCONFIG_OBJECT_ENTITY,
			nFORCE__lookupKey__c = generateRandomString(18));

		Database.insert(newSC2);

		nFORCE__Section_Configuration__c newSC3 = new nFORCE__Section_Configuration__c(
			nFORCE__Display_Order__c = 3.01,
			nFORCE__Parent_Configuration__c = newSC2.Id,
			nFORCE__Parent_Relationship_Name__c = SECTIONCONFIG_RELATIONSHIP_ACCOUNT,
			nFORCE__Screen_Section__c = screenSectionId,
			nFORCE__sObject_Type__c = SECTIONCONFIG_OBJECT_ACCOUNT,
			nFORCE__lookupKey__c = generateRandomString(18));

		Database.insert(newSC3);

		nFORCE__Section_Configuration__c newSC4 = new nFORCE__Section_Configuration__c(
			nFORCE__Display_Order__c = 4.01,
			nFORCE__Field_Set_Key__c = SECTIONCONFIG_FIELDSET_UNDERWRITING,
			nFORCE__Parent_Configuration__c = newSC3.Id,
			nFORCE__Parent_Relationship_Name__c = SECTIONCONFIG_OBJECT_UNDERWRITING,
			nFORCE__Screen_Section__c = screenSectionId,
			nFORCE__sObject_Type__c = SECTIONCONFIG_OBJECT_UNDERWRITING,
			nFORCE__lookupKey__c = generateRandomString(18));

		Database.insert(newSC4);
	}

	/******************************************
	* @description Generate LookupKey
	* @param len 
	* @return String 
	******************************************/
	public static String generateRandomString(Integer len) {
		final String chars = NUMBERSFORRANDOMIZER;
		String randStr = BLANK;
		while (randStr.length() < len) {
			Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
			randStr += chars.substring(idx, idx + 1);
		}
		return randStr; 
	}

	private void resetMessages() {
		this.successMessage = null;
		this.errorMessage = null;
	}

	/******************************************
	* Basic Static Variables				  *
	******************************************/
	private static final String PARAMETER_NAME = 'id';
	private static final String NUMBERSFORRANDOMIZER = '0123456789';
	private static final String BLANK = '';
	private static final String LAYOUTBUILDERURL = '/apex/nFORCE__LayoutBuilder';

	/******************************************
	* Section Configuration Static Variables  *
	******************************************/
	private static final String SECTIONCONFIG_FIELDSET_UNDERWRITING = 'LLC_BI__Bundle_ID';
	private static final String SECTIONCONFIG_OBJECT_UNDERWRITING = 'LLC_BI__Underwriting_Bundle__c';
	private static final String SECTIONCONFIG_OBJECT_ACCOUNT = 'Account';
	private static final String SECTIONCONFIG_RELATIONSHIP_ACCOUNT = 'LLC_BI__Account__r';
	private static final String SECTIONCONFIG_FIELDSET_ENTITIY = 'LLC_BI__Entity_ID';
	private static final String SECTIONCONFIG_OBJECT_ENTITY = 'LLC_BI__Legal_Entities__r';
	private static final String SECTIONCONFIG_OBJECT_LOAN = 'LLC_BI__Loan__c';

	/******************************************
	* Widget Related Narrative Code			  *
	******************************************/
	private static final String WIDGET_APPROVALPROCESS = '<table class="table"> <tr> <th>Date</th> <th>Assigned To</th> <th>Actual Approver</th> ' +
														 '<th>Status</th> <th>Comments</th> </tr> <!-- ko foreach: approvalHistory --> ' +
														 '<!-- ko foreach: steps --> <tr> <td data-bind="dateText: theDate" /> <td> ' +
														 '<span data-bind="text: originalActor.name" /> </td> <td> <span data-bind="text: assignedActor.name" /> ' +
														 '</td> <td data-bind="text: status" /> <td data-bind="text: comments" /> </tr> <!-- /ko --> ' +
														 '<!-- /ko --> </table>';
	private static final String WIDGET_NARRATIVE = '<div data-bind="template: { name: \'narrative-template\' }"></div>';
	private static final String WIDGET_GLOBALANALYSIS = '<div data-bind="template: { name: \'globalAnalysisPrintTemplate\' }" />';
	private static final String VIEW_SPREADSAPPENDIX = '<div id="spread_print_main" /> <div data-bind="stopBinding: true" style="display: none;"> ' +
													   '<div id="debt_schedule_container"> <div data-bind="foreach: { data: debtSchedules, as: \'debtSchedule\' }" > ' +
													   '<div data-bind="template: {name: \'debtschedule-template\', data: debtSchedule}" /> </div> </div> </div>';

	/******************************************
	* Widget Related Static Variables		  *
	******************************************/
	private static final String Spreads_Appendix = 'Spreads_Appendix';
	private static final String Global_Analysis = 'Global_Analysis';
	private static final String Debt_Schedule = 'Debt_Schedule';
	private static final String Narrative = 'Narrative';
	private static final String Approval_Process = 'Approval_Process';
	private static final String WIDGETTYPE_FIELD = 'Knockout';
	private static final String WIDGETNAME_FIELD_APPROVAL = 'LifeCycle.Default_Widget';
	private static final String WIDGETNAME_FIELD_NARRATIVE = 'LifeCycle.KO_Narrative';
	private static final String WIDGETNAME_FIELD_SPREAD = 'LifeCycle.Spread_Base';
	private static final String WIDGETNAME_FIELD_GLOBAL = 'LifeCycle.GlobalAnalysis';
	private static final String WIDGETNAME_FIELD_DEBT = 'LifeCycle.DebtSchedule';
	private static final String WIDGETSCRIPTONE_APPROVAL = 'nFORCE__default_widget_app';
	private static final String WIDGETSCRIPTTWO_APPROVAL = 'nFORCE__default_widget_viewModel';
	private static final String WIDGETSCRIPTONE_NARRATIVE = 'nFORCE__ko_narrative_app';
	private static final String WIDGETSCRIPTTWO_NARRATIVE = 'nFORCE__screen_models';
    private static final String WIDGETPARAMETERS_NARRATIVE = 'maxSize: 12000000;';
	private static final String WIDGETSCRIPTTHREE_NARRATIVE = 'nFORCE__ko_narrative_viewModel';
	private static final String WIDGETSCRIPTONE_SPREAD = 'LLC_BI__spread_base_app';
	private static final String WIDGETSCRIPTTWO_SPREAD = 'LLC_BI__spread_base_viewModel';
	private static final String WIDGETSCRIPTTHREE_SPREAD = 'LLC_BI__spread_base_view';
	private static final String WIDGETSCRIPTFOUR_SPREAD = 'LLC_BI__spreads_models';
	private static final String WIDGETSCRIPTFIVE_SPREAD = 'LLC_BI__relationship_models';
	private static final String WIDGETSCRIPTSIX_SPREAD = 'LLC_BI__underwriting_models';
	private static final String WIDGETPARAMETERS_SPREAD = 'filterSpreadsByLoanId:true';
	private static final String WIDGETSCRIPTONE_GLOBAL = 'LLC_BI__global_analysis_app';
	private static final String WIDGETSCRIPTTWO_GLOBAL = 'LLC_BI__global_analysis_models';
	private static final String WIDGETSCRIPTTHREE_GLOBAL = 'LLC_BI__global_analysis_viewModel';
	private static final String WIDGETSCRIPTONE_DEBT = 'LLC_BI__debt_schedule_app';
	private static final String WIDGETSCRIPTTWO_DEBT = 'LLC_BI__debt_schedule_viewModel';
	private static final String WIDGETSCRIPTTHREE_DEBT = 'LLC_BI__debt_schedule_models';
	private static final String WIDGETSCRIPTFOUR_DEBT = 'LLC_BI__keymaster';
}
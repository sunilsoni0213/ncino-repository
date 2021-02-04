public class CSA_OverviewConfigAdminController {
	public List<Overview_Properties__c> overviewList {get;Set;}
	public Id overviewId {get;Set;}
	public Overview_Properties__c overview {get;Set;}
	public String successMessage {get;Set;}
	public String ErrorMessage {get;Set;}
	public Boolean showHome {get;Set;}
	public Boolean showNew {get;Set;}
	public Boolean showEdit {get;Set;}
	public Boolean isSaveNew {get;Set;}
	public Map<String, String> reportsList {get;Set;}

	public CSA_OverviewConfigAdminController() {
		this.overviewList = getOverviews();
		this.renderViews(true, false, false);
		this.reportsList = new Map<String, String>();
	}

	public void back() {
		this.renderViews(true, false, false);
		this.resetMessages();
	}

	public void overviewNew() {
		this.renderViews(false, true, false);
		this.overview = new Overview_Properties__c(
			Name = generateRandomString(18),
			Is_Active__c = true);
		this.resetMessages();
	}

	public void overviewSaveNew() {
		this.overview.Report_Name__c = reportsList.get(this.overview.Report_Id__c);
		try {
			Database.insert(overview);
			this.successMessage = System.Label.Overview_Success_Create;
			
			if (isSaveNew) {
				this.overview = new Overview_Properties__c(
					Name = generateRandomString(18),
					Is_Active__c = true);
			} else {
				this.overviewList = getOverviews();
				this.renderViews(true, false, false);
			}
		} catch (Exception ex) {
			this.errorMessage = ex.getMessage();
		}
	}

	public void overviewSaveEdit() {
		this.overview.Report_Name__c = reportsList.get(this.overview.Report_Id__c);
		try {
			Database.update(overview);
			this.overviewList = getOverviews();
			this.renderViews(true, false, false);
			this.successMessage = System.Label.Overview_Success_Update;
		} catch (Exception ex) {
			this.errorMessage = ex.getMessage();
		}
	}

	public void overviewDelete() {
		this.overview = getOverview(this.overviewId);
		try {
			Database.delete(overview);
			this.overviewList = getOverviews();
			this.successMessage = System.Label.Overview_Success_Delete;
		} catch (Exception ex) {
			this.errorMessage = ex.getMessage();
		}
	}

	public void overviewEdit() {
		this.renderViews(false, false, true);
		this.overview = getOverview(this.overviewId);
		this.resetMessages();
	}

	public void overviewActivate() {
		this.overview = getOverview(this.overviewId);
		overview.Is_Active__c = true;

		try {
			Database.update(overview);
			this.overviewList = getOverviews();
			this.successMessage = System.Label.Overview_Activated_Msg;
		} catch (Exception ex) {
			this.errorMessage = ex.getMessage();
		}
	}

	public void overviewDeactivate() {
		this.overview = getOverview(this.overviewId);
		overview.Is_Active__c = false;

		try {
			Database.update(overview);
			this.overviewList = getOverviews();
			this.successMessage = System.Label.Overview_Deactivated_Msg;
		} catch (Exception ex) {
			this.errorMessage = ex.getMessage();
		}
	}

	public List<SelectOption> getCategoryPicklist() {
		List<SelectOption> newSO = new List<SelectOption>();

		newSO.add(new SelectOption(BLANK, NONESELECT));
		newSO.add(new SelectOption(USABLEPRODUCTLINE, USABLEPRODUCTLINE));
		newSO.add(new SelectOption(USABLESTAGE, USABLESTAGE));
		newSO.add(new SelectOption(USABLESTATUS, USABLESTATUS));

		return newSO;
	}

	public List<SelectOption> getStagePicklist() {
        List<SelectOption> newSO = new List<SelectOption>();
		newSO.add(new SelectOption(BLANK, NONESELECT));
        for (Schema.PicklistEntry p: LLC_BI__Loan__c.LLC_BI__Stage__c.getDescribe().getPicklistValues()) {
            newSO.add(new SelectOption(p.value, p.label));
        }

        return newSO;
    }

    public List<SelectOption> getStatusPicklist() {
        List<SelectOption> newSO = new List<SelectOption>();
		newSO.add(new SelectOption(BLANK, NONESELECT));
        for (Schema.PicklistEntry p: LLC_BI__Loan__c.LLC_BI__Status__c.getDescribe().getPicklistValues()) {
            newSO.add(new SelectOption(p.value, p.label));
        }

        return newSO;
    }

	public List<SelectOption> getProductLinePicklist() {
        List<SelectOption> newSO = new List<SelectOption>();
		newSO.add(new SelectOption(BLANK, NONESELECT));
        for (Schema.PicklistEntry p: LLC_BI__Loan__c.LLC_BI__Product_Line__c.getDescribe().getPicklistValues()) {
            newSO.add(new SelectOption(p.value, p.label));
        }

        return newSO;
    }

	public List<SelectOption> getReportsPicklist() {
        List<SelectOption> newSO = new List<SelectOption>();
		newSO.add(new SelectOption(BLANK, NONESELECT));
        for (Report r: getReports()) {
			reportsList.put(r.Id, r.DeveloperName);
            newSO.add(new SelectOption(r.Id, r.Name));
        }

        return newSO;
    }

	private List<Report> getReports() {
		return [SELECT 
					Id,
					Name,
					DeveloperName 
				FROM
					Report];
	}

	private Overview_Properties__c getOverview(Id recordId) {
		return [SELECT
					Id,
					Name,
					Category_Name__c,
					Is_Active__c,
					Order__c,
					Report_Id__c,
					Report_Name__c,
					Stage_Status_Product_Line_Name__c
				FROM
					Overview_Properties__c 
				WHERE
					Id = :recordId LIMIT 1];
	}

	private List<Overview_Properties__c> getOverviews() {
		return [SELECT
					Id,
					Name,
					Category_Name__c,
					Is_Active__c,
					Order__c,
					Report_Id__c,
					Report_Name__c,
					Stage_Status_Product_Line_Name__c
				FROM
					Overview_Properties__c
				ORDER BY
					Category_Name__c ASC,
					Order__c ASC];
	}

	private void renderViews(Boolean home, Boolean nw, Boolean edt) {
		this.showHome = home;
		this.showNew = nw;
		this.showEdit = edt;
	}

	private void resetMessages() {
		this.successMessage = null;
		this.errorMessage = null;
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

	private static final String NUMBERSFORRANDOMIZER = '1234567890';
	private static final String BLANK = '';
	private static final String NONESELECT = '-- None --';
	private static final String USABLEPRODUCTLINE = 'Usable_Product_Line';
	private static final String USABLESTAGE = 'Usable_Stage';
	private static final String USABLESTATUS = 'Usable_Status';
}
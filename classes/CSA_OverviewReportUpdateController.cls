public class CSA_OverviewReportUpdateController {
	public Map<String, String> reportsList {get;Set;}
	public List<Overview_Properties__c> overviewList {get;Set;}
	public String successMessage {get;Set;}
	public String ErrorMessage {get;Set;}

	public void overviewUpdate() {
		this.reportsList = new Map<String, String>();
		this.overviewList = getOverviews();

		for (Report r: getReports()) {
			this.reportsList.put(r.DeveloperName, r.Id);
		}

		for (Overview_Properties__c op: this.overviewList) {
			op.Report_Id__c = this.reportsList.get(op.Report_Name__c);
		}

		try {
			Database.update(this.overviewList);
			this.successMessage = System.Label.Overview_Success_Report_Update;
		} catch (Exception ex) {
			this.errorMessage = ex.getMessage();
		}
	}

	private List<Report> getReports() {
		return [SELECT 
					Id,
					Name,
					DeveloperName 
				FROM
					Report];
	}

	private List<Overview_Properties__c> getOverviews() {
		return [SELECT
					Id,
					Category_Name__c,
					Is_Active__c,
					Report_Id__c,
					Report_Name__c
				FROM
					Overview_Properties__c
				WHERE 
					Category_Name__c = :USABLESTAGE];
	}

	private static final String USABLESTAGE = 'Usable_Stage';
}
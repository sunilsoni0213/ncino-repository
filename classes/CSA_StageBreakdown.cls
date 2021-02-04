public with sharing class CSA_StageBreakdown {

	public String stageName {get;Set;}
	public Decimal stageCount {get;Set;}
	public List<CSA_StatusBreakdown> statusList {get;Set;}
	public String classActive {get;Set;}
	public String classActive2 {get;Set;}
	public String reportid {get;Set;}

	public CSA_StageBreakdown(AggregateResult[] loans, String stage, String[] status, Integer count, Map<String, Overview_Properties__c> properties, String productLine) {
		this.stageName = stage;
		this.stageCount = 0;
		this.statusList = new List<CSA_StatusBreakdown>();
		this.reportId = HASHTAG;
		if (count == 1) {
			this.classActive = TABPANELACTIVECLASS;
			this.classActive2 = TABACTIVECLASS;
		} else {
			this.classActive2 = TABINACTIVECLASS;
		}

		for (AggregateResult l: loans) {
			if (l.get('LLC_BI__Product_Line__c') == productLine && l.get('LLC_BI__Stage__c') == stage) {
				this.stageCount += (Decimal)l.get('total');
			}
		}

		if (properties.get(stage).Report_Id__c != null) {
			this.reportId = SLASH + properties.get(stage).Report_Id__c;
		}

		for (String s: status) {
			statusList.add(new CSA_StatusBreakdown(s, loans, stage, productLine));
		}
	}

	private static final String HASHTAG = '#';
	private static final String TABPANELACTIVECLASS = 'in active';
	private static final String TABACTIVECLASS = 'slds-is-active';
	private static final String TABINACTIVECLASS = 'slds-is-incomplete';
	private static final STRING SLASH = '/';
}
public with sharing class CSA_StatusBreakdown {
	public String statusName {get;Set;}
	public Decimal statusCount {get;Set;}

	public CSA_StatusBreakdown(String status, AggregateResult[] loans, String stage, String productLine) {
		this.statusName = status;
		this.statusCount = 0;

		for (AggregateResult l: loans) {
			if (l.get('LLC_BI__Status__c') == status && l.get('LLC_BI__Stage__c') == stage && l.get('LLC_BI__Product_Line__c') == productLine) {
				this.statusCount += (Decimal)l.get('total');
			}
		}
	}
}
public class CSA_ConfigValueSummaryController { 
	public Decimal getNumConfigValues() {
		return [SELECT 
					Count()
				FROM 
					LLC_BI__CFG_ConfigValue__c];
	}

	public Decimal getKYConfigKeys() {
		return [SELECT
					Count()
				FROM
					LLC_BI__CFG_ConfigKey__c
				WHERE
					Name LIKE 'KY%'];
	}

	public Decimal getPTConfigKeys() {
		return [SELECT
					Count()
				FROM
					LLC_BI__CFG_ConfigKey__c
				WHERE
					Name LIKE 'PT%'];
	}
}
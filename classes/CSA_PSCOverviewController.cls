public class CSA_PSCOverviewController { 
	public Decimal getNumProductTypes() {
		return [SELECT
					Count()
				FROM 
					LLC_BI__Product_Type__c
				WHERE 
					LLC_BI__Is_Loan__c = true];
	}

	public Decimal getNumBookedConfig() {
		return [SELECT
					Count()
				FROM 
					LLC_BI__Product_State_Config__c
				WHERE
					LLC_BI__Is_Booked__c = True];
	}

	public Decimal getNumClosedConfig() {
		return [SELECT
					Count()
				FROM 
					LLC_BI__Product_State_Config__c
				WHERE
					LLC_BI__Is_Closed__c = True];
	}

	public Decimal getNumExcludedConfig() {
		return [SELECT
					Count()
				FROM 
					LLC_BI__Product_State_Config__c
				WHERE
					LLC_BI__Is_Excluded_From_Stage_Duration__c = True];
	}

	public Decimal getNumTransmitConfig() {
		return [SELECT
					Count()
				FROM 
					LLC_BI__Product_State_Config__c
				WHERE
					LLC_BI__Is_Ready_To_Transmit__c = True];
	}

	public List<LLC_BI__Product_Type__c> getProductTypes() {
		return [SELECT
					Id, 
					Name, 
					LLC_BI__Product_Line__c,
					LLC_BI__Product_State_Booked_Config_Count__c,
					LLC_BI__Product_State_Closed_Config_Count__c,
					LLC_BI__Product_State_Excluded_Config_Count__c,
					LLC_BI__Product_State_Rdy_To_Trans_Confg_Cnt__c,
					LLC_BI__Product_Count__c
				FROM
					LLC_BI__Product_Type__c
				WHERE 
					LLC_BI__Is_Loan__c = true];
	}

	public List<Schema.FieldSetMember> getProductTypeFieldSetList() {
		return SObjectType.LLC_BI__Product_Type__c.FieldSets.CSA_PSC_Overview.getFields();
	}
}
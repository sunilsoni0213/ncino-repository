public class CSA_PSCMgmtConfigController {
	public String successMessage {get;Set;}
	public String errorMessage {get;Set;}

	public void remove() {
		List<LLC_BI__Product_State_Config__c> psc = getProductStateConfigRecords();
		try {	        
			Database.delete(psc);
			this.successMessage = System.Label.PSC_Config_Success_Delete;
		} catch (Exception ex) {
			this.errorMessage = ex.getMessage();
		}
	}

	public PageReference finish() {
		PageReference pageRef = new PageReference(INSTALLEDPACKAGEURL);
		return pageRef;
	}

	private List<LLC_BI__Product_State_Config__c> getProductStateConfigRecords() {
		return [SELECT
					Id
				FROM 
					LLC_BI__Product_State_Config__c];
	}

	private static final String INSTALLEDPACKAGEURL= '/0A3';
}
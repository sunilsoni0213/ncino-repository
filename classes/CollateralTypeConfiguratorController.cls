public class CollateralTypeConfiguratorController {

	public CollateralTypeConfiguratorController() {
        updateTypeConfiguration();
    }
    public CollateralTypeConfiguratorController(ApexPages.StandardController controller) {}
    
    public CollateralTypeConfiguratorController(nFORCE.TemplateController controller) {}

	public static void updateTypeConfiguration() {
		List<LLC_BI__Collateral_Type__c> currentTypes = [
			SELECT
				Id,
				LLC_BI__Collateral_Configuration__c
			FROM
				LLC_BI__Collateral_Type__c];

		String defaultCreationId = [
			SELECT
				Id
			FROM
				nFORCE__Screen__c
			WHERE
				Name LIKE 'Collateral Creation Screen' LIMIT 1].Id;

		String defaultEditId = [
			SELECT
				Id
			FROM
				nFORCE__Screen__c
			WHERE
				Name LIKE 'Default Collateral Edit Screen' LIMIT 1].Id;

		List<LLC_BI__Collateral_Type__c> toUpdate = new List<LLC_BI__Collateral_Type__c>();

		CollateralCreationConfiguration config;
		for (LLC_BI__Collateral_Type__c type : currentTypes) {
			config = (CollateralCreationConfiguration)JSON.deserialize(
				type.LLC_BI__Collateral_Configuration__c,
				CollateralCreationConfiguration.class);

			config.prodPkgEditScreen = defaultEditId;
			config.addCollateralScreen = defaultCreationId;
			config.addChildCollateralScreen = defaultCreationId;
			config.copyCollateralScreen = defaultCreationId;
			config.editCollateralScreen = defaultCreationId;

			type.LLC_BI__Collateral_Configuration__c = JSON.serialize(config);
			toUpdate.add(type);
		}

		update toUpdate;
        
        //PageReference redirect = new PageReference('/apex/LLC_BI__Admin');

		//return redirect;
	}

	public with sharing class CollateralCreationConfiguration {
		public String collateralScreenName { get; set; }
		public String addCollateralScreen{ get; set; }
		public String addChildCollateralScreen { get; set; }
		public String copyCollateralScreen { get; set; }
		public String editCollateralScreen { get; set; }
		public String collateralCopyFieldSetName { get; set; }
		public String collateralCloneFieldSetName { get; set; }
		public String prodPkgEditScreen { get; set; }
	}
}
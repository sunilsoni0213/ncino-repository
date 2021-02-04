public with sharing class ConfigurationController {
	public String namespace {get; set;}
	public Boolean isProduction {get; set;}
	private String query;

	public ConfigurationController() {
		this.namespace = TMCUtility.getCoreNamespace();
		this.isProduction = TMCUtility.isProduction();
		this.query = URL.getCurrentRequestUrl().getQuery();
	}

	public PageReference save(){
		TMCUtility.updateSystemProperty(
			null,
			TreasuryConfigurationConstants.TM_CONFIG_CATEGORY,
			TreasuryConfigurationConstants.TM_CONFIG_IS_PRODUCTION_KEY,
			String.valueOf(this.isProduction),
			true
		);
		TreasuryConfigurationConstants.SYSTEM_PROPERTIES.clearCache();
		return new PageReference(URL.getCurrentRequestUrl().toExternalForm() + '?' + this.query);
	}
}
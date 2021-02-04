public with sharing class PluginConfigurationService {

	private List<nFUSE.PluginConfigurationManager.PluginConfiguration> properties;

	public nFUSE.PluginConfigurationManager.PluginConfiguration getPluginProperty(String key) {
		getPluginProperties();

		for (nFUSE.PluginConfigurationManager.PluginConfiguration prop : properties) {
			if (prop.key == key) {
				return prop;
			}
		}

		return new nFUSE.PluginConfigurationManager.PluginConfiguration();
	}

	public String getPluginPropertyValue(String key) {
		getPluginProperties();

		for (nFUSE.PluginConfigurationManager.PluginConfiguration prop : properties) {
			if (prop.key == key) {
				return prop.value;
			}
		}

		return '';
	}

	public nFUSE.PluginConfigurationManager.PluginConfiguration createConfig(String key, String value, Boolean isEncrypted) {
		nFUSE.PluginConfigurationManager.PluginConfiguration config = new nFUSE.PluginConfigurationManager.PluginConfiguration();
		config.pluginName = OneSpanESignature.PLUGIN_NAME;
		config.pluginVersion = OneSpanESignature.PLUGIN_VERSION;
		config.category = OneSpanESignature.PLUGIN_NAME;
		config.key = key;
		config.value = value;
		config.valueDataType = 'String';
		config.isEncrypted = isEncrypted;

		return config;
	}

	public String getApiKey() {
		nFUSE.PluginConfigurationManager.PluginConfiguration apiKey = getPluginProperty(OneSpanESignature.KEY_CONFIG_API_KEY);
		if (apiKey != null && apiKey.value != null) {
			return apiKey.value;
		}

		return '';
	}

	@TestVisible
	private List<nFUSE.PluginConfigurationManager.PluginConfiguration> getPluginProperties() {
		if (properties == null) {
			properties = new nFUSE.PluginConfigurationManager(OneSpanESignature.PLUGIN_NAME, OneSpanESignature.PLUGIN_VERSION).getConfigurations();
		}

		return properties;
	}

}
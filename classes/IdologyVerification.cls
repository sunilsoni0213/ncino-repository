global with sharing class IdologyVerification {

	global class IdologyVerificationActivator implements nFUSE.IPluginActivator {

		private nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();

		public void onActivate() {
			nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(PLUGIN_NAME, PLUGIN_VERSION, null);
			locator.register(request, nFUSE.SendService.class, IdologyVerification.IdologyVerificationSendService.class);

			updateProperty(PLUGIN_CONFIG_NAME, PLUGIN_NAME, PLUGIN_CONFIG_CATEGORY);
			updateProperty(PLUGIN_CONFIG_VERSION, PLUGIN_VERSION, PLUGIN_CONFIG_CATEGORY);

			addPluginConfigs();
		}

		public void onDeactivate() {
			nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(PLUGIN_NAME, PLUGIN_VERSION, null);
			locator.deregister(request, nFUSE.SendService.class);

			updateProperty(PLUGIN_CONFIG_NAME, null, PLUGIN_CONFIG_CATEGORY);
			updateProperty(PLUGIN_CONFIG_VERSION, null, PLUGIN_CONFIG_CATEGORY);
			updateProperty(SYS_PROP_KEY_ENVIRONMENT, null, PLUGIN_CATEGORY);
		}

		@TestVisible
		private void updateProperty(String key, String value, String category) {
			List<nFORCE__System_Properties__c> props = [
				SELECT
					Id
				FROM
					nFORCE__System_Properties__c
				WHERE
					nFORCE__Category_Name__c = :category
				AND
					nFORCE__Key__c = :key
				AND
					nFORCE__Is_Active__c = true
			];

			if (props.size() > 0) {
				props[0].nFORCE__Value__c = value;

				nFORCE.DmlUtility.updateObj(props[0]);
			}
		}

		@TestVisible
		public void addPluginConfigs() {
			List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs = new List<nFUSE.PluginConfigurationManager.PluginConfiguration> {};

			configs.add(createConfig(SYS_PROP_KEY_USERNAME, 'String', false));
			configs.add(createConfig(SYS_PROP_KEY_PASSWORD, 'String', true));
			configs.add(createConfig(SYS_PROP_KEY_ENVIRONMENT, 'String', false));

			new nFUSE.PluginConfigurationManager(PLUGIN_NAME, PLUGIN_VERSION).softInsertConfigurations(configs);
		}

		@TestVisible
		private nFUSE.PluginConfigurationManager.PluginConfiguration createConfig(
				String key,
				String value,
				String valueDataType,
				Boolean isEncrypted) {
			nFUSE.PluginConfigurationManager.PluginConfiguration config = new nFUSE.PluginConfigurationManager.PluginConfiguration();
			config.pluginName = PLUGIN_NAME;
			config.pluginVersion = PLUGIN_VERSION;
			config.category = PLUGIN_NAME;
			config.key = key;
			config.value = value;
			config.valueDataType = valueDataType;
			config.isEncrypted = isEncrypted;

			return config;
		}

		private nFUSE.PluginConfigurationManager.PluginConfiguration createConfig(
				String key,
				String valueDataType,
				Boolean isEncrypted) {
			return createConfig(key, null, valueDataType, isEncrypted);
		}
	}

	global class IdologyVerificationSendService extends nFUSE.SendService {
		public protected override nFUSE.AMiddlewareMessage preSendSeam(nFUSE.AMiddlewareMessage message) {
			nFUSE.AMiddlewareMessage m = super.preSendSeam(message);
			List<nFUSE.PluginConfigurationManager.PluginConfiguration> properties = new nFUSE.PluginConfigurationManager(PLUGIN_NAME, PLUGIN_VERSION).getConfigurations();

			for (nFUSE.PluginConfigurationManager.PluginConfiguration config : properties) {
				if (config.key == SYS_PROP_KEY_USERNAME) {
					m.properties.put('expectIdUsername', config.value);
				} else if (config.key == SYS_PROP_KEY_PASSWORD) {
					m.properties.put('expectIdPassword', config.value);
				} else if (config.key == SYS_PROP_KEY_ENVIRONMENT) {
					m.properties.put('environment', config.value);
				}
			}

			return m;
		}
	}

	@TestVisible
	private static final String
		PLUGIN_NAME = 'Idology_Verification',
		PLUGIN_CATEGORY = 'Idology_VerificationConfiguration',
		PLUGIN_VERSION = '1.0',
		PLUGIN_CONFIG_NAME = 'ID Verification Name',
		PLUGIN_CONFIG_VERSION = 'ID Verification Version',
		PLUGIN_CONFIG_CATEGORY = 'ID Verification',
		PLUGIN_HELP_TEXT = 'Idology Verification Plugin KBA questions',
		SYS_PROP_KEY_USERNAME = 'Expect ID Username',
		SYS_PROP_KEY_PASSWORD = 'Expect ID Password',
		SYS_PROP_KEY_ENVIRONMENT = 'Environment';
}
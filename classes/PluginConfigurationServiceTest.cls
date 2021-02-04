@isTest(IsParallel=true)
public with sharing class PluginConfigurationServiceTest {

	@isTest
	private static void shouldCreateConfig() {
		PluginConfigurationService service = new PluginConfigurationService();
		nFUSE.PluginConfigurationManager.PluginConfiguration config = null;

		Test.startTest();
		config = service.createConfig('LGTM_Key', 'LGTM', false);
		Test.stopTest();

		System.assertEquals('LGTM_Key', config.key);
		System.assertEquals('LGTM', config.value);
		System.assertEquals(OneSpanESignature.PLUGIN_NAME, config.category);
		System.assertEquals(OneSpanESignature.PLUGIN_NAME, config.pluginName);
	}

	@isTest
	private static void shouldReturnPluginConfig_WhenKeyExists() {
		PluginConfigurationService service = new PluginConfigurationService();
		List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs
			= new List<nFUSE.PluginConfigurationManager.PluginConfiguration>{
				service.createConfig(OneSpanESignature.KEY_CONFIG_API_KEY, '123456', false)
			};
		new nFUSE.PluginConfigurationManager(OneSpanESignature.PLUGIN_NAME, OneSpanESignature.PLUGIN_VERSION).softInsertConfigurations(configs);

		nFUSE.PluginConfigurationManager.PluginConfiguration APIKeyConfig;

		Test.startTest();
		APIKeyConfig = service.getPluginProperty(OneSpanESignature.KEY_CONFIG_API_KEY);
		Test.stopTest();

		System.assertEquals('123456', APIKeyConfig.value);
	}

	@isTest
	private static void shouldReturnEmptyPluginConfig_WhenKeyNotExists() {
		PluginConfigurationService service = new PluginConfigurationService();
		nFUSE.PluginConfigurationManager.PluginConfiguration APIKeyConfig;

		Test.startTest();
		APIKeyConfig = service.getPluginProperty('Blah');
		Test.stopTest();

		System.assertEquals(null, APIKeyConfig.key);
	}
}
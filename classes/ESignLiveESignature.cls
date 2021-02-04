/**
 * NOTES: Implements the IPlugin Activator Interface and creates SystemProperties,
 * SystemConfiguration, and registers a bean for the CreditAppFacade on Activate.
 * Then does nothing on deactivate.
 */
global with sharing class ESignLiveESignature implements nFUSE.IPluginActivator {

	/**
	* Register, initialize & configure plugin dependencies to make available
	* in product workflow(s)
	*
	* NOTES:
	* - Executes when a plugin is activated (checked) in the Plugin Configuration Dashboard
	* - This function should be idempotence meaning that it could be called repeatedly
	*	while producing the same result.
	*/
	private nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();


	global with sharing class EsignLiveService extends nFUSE.ESignatureService{

		global EsignLiveService() {
			super();
		}

		global override nFUSE.AMiddlewareMessage preSendSeam(nFUSE.AMiddlewareMessage message) {
			Map<String, String> keyValueMap = getESignLivePropertyMap();
			String apiKey = keyValueMap.get(ESignLiveESignature.SYS_PROP_KEY_API_KEY);
			String eSignatureVendor = keyValueMap.get(ESignLiveESignature.SYS_PROP_KEY_E_SIGNATURE_VENDOR);
			String eSignatureEnabled = keyValueMap.get(ESignLiveESignature.SYS_PROP_KEY_E_SIGNATURE_ENABLED);
			String eSignLiveEnvironment = keyValueMap.get(ESignLiveESignature.SYS_PROP_KEY_ESIGNLIVE_ENVIRONMENT);
			statusSignedValue = keyValueMap.get(ESignLiveESignature.SYS_PROP_KEY_SIGNED_STATUS);

			message.properties.put(SYS_PROP_KEY_API_KEY, apiKey);
			message.properties.put(SYS_PROP_KEY_E_SIGNATURE_VENDOR, eSignatureVendor);
			message.properties.put(SYS_PROP_KEY_E_SIGNATURE_ENABLED, eSignatureEnabled);
			message.properties.put(SYS_PROP_KEY_ESIGNLIVE_ENVIRONMENT, eSignLiveEnvironment);

			message.properties.put(STATUS_SIGNED_KEY, statusSignedValue);
			message.properties.put(STATUS_EXCEPTION_KEY, STATUS_EXCEPTION_VALUE);
			message.properties.put(STATUS_SUCCESSFUL_CANCELLATION_KEY, STATUS_SUCCESSFUL_CANCELLATION_VALUE);

			return message;
		}

		private Map<String, String> getESignLivePropertyMap() {
			nFUSE.PluginConfigurationManager configManager = new nFUSE.PluginConfigurationManager(PLUGIN_NAME, PLUGIN_VERSION);

			List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs = configManager.getConfigurations();

			Map<String, String> keyValueMap = new Map<String, String>();
			for(nFUSE.PluginConfigurationManager.PluginConfiguration config : configs) {
				keyValueMap.put(config.key, config.value);
			}

			return keyValueMap;
		}
	}

	public void onActivate() {
		nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(PLUGIN_NAME, PLUGIN_VERSION, null);

		locator.register(request, nFUSE.ESignatureService.class, ESignLiveESignature.EsignLiveService.class);

		addPluginConfigurations();
	}

	/**
	*
	* NOTES:
	* - Executes when a plugin is deactivated (unchecked) in the Plugin Configuration Dashboard
	* - This function should be idempotence meaning that it could be called repeatedly
	*   while producing the same result.
	* - If System Properties (etc.) are removed on deactivation their values will have to
	*   re-entered with every activation.  Deactivation should NOT be treated like an uninstall.
	*/
	public void onDeactivate() {
		nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(PLUGIN_NAME, PLUGIN_VERSION, null);
		locator.deregister(request, nFUSE.ESignatureService.class);

	}

	private void addPluginConfigurations() {
		List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs = new List<nFUSE.PluginConfigurationManager.PluginConfiguration> {};

		nFORCE.SystemProperties sysPropInstance = nFORCE.SystemProperties.getInstance();

		configs.add(createProperty(SYS_PROP_KEY_E_SIGNATURE_VENDOR, PLUGIN_NAME));
		configs.add(createProperty(SYS_PROP_KEY_API_KEY, ''));
		configs.add(createProperty(SYS_PROP_KEY_E_SIGNATURE_ENABLED, ''));
		configs.add(createProperty(SYS_PROP_KEY_ESIGNLIVE_ENVIRONMENT, ''));
		configs.add(createProperty(SYS_PROP_KEY_E_SIGNATURE_PLUGIN_VERSION, PLUGIN_VERSION));

		new nFUSE.PluginConfigurationManager(PLUGIN_NAME, PLUGIN_VERSION).softInsertConfigurations(configs);
	}

	private nFUSE.PluginConfigurationManager.PluginConfiguration createProperty(String key, String value){
		nFUSE.PluginConfigurationManager.PluginConfiguration config = new nFUSE.PluginConfigurationManager.PluginConfiguration();
		config.pluginName = PLUGIN_NAME;
		config.pluginVersion = PLUGIN_VERSION;
		config.category = PLUGIN_NAME;
		config.key = key;
		config.value = value;
		config.valueDataType = 'String';
		config.isEncrypted = false;

		return config;
	}

	private static final String NFUSE_CONFIGURATION_KEYWORD = 'Configuration';

	public static String statusSignedValue = '';

	public static final String
		PLUGIN_NAME = 'E_Sign_Live_Esignature',
		PLUGIN_VERSION = '1.0',
		PLUGIN_CONFIG_NAME ='E_Sign_Live_Esignature' + NFUSE_CONFIGURATION_KEYWORD,
		PLUGIN_HELP_TEXT = 'eSignLive E-Signature Plugin Category for Property Configuration',
		SYS_PROP_KEY_E_SIGNATURE_PLUGIN_VERSION = 'E_Signature_Plugin_Version',
		SYS_PROP_KEY_E_SIGNATURE_VENDOR = 'eSignature Vendor',
		SYS_PROP_KEY_API_KEY = 'eSign_Live_API_Key',
		SYS_PROP_KEY_E_SIGNATURE_ENABLED = 'E_Signature_Enabled',
		SYS_PROP_KEY_ESIGNLIVE_ENVIRONMENT = 'E_Sign_Live_Environtment',
		SYS_PROP_KEY_SIGNED_STATUS = 'E-Signed document status',
		SYS_PROP_CATEGORY_DOC_MAN = 'document manager',
		STATUS_SIGNED_KEY = 'STATUS_SIGNED',
		STATUS_EXCEPTION_KEY = 'STATUS_EXCEPTION',
		STATUS_SUCCESSFUL_CANCELLATION_KEY = 'STATUS_SUCCESSFUL_CANCELLATION',
		STATUS_EXCEPTION_VALUE = 'E-Signature Exception',
		STATUS_SUCCESSFUL_CANCELLATION_VALUE = 'E-signature Needed';
}
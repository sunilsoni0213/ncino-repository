global virtual with sharing class OneSpanESignature {

	global with sharing class Activator implements nFUSE.IPluginActivator {

		public void onActivate() {
			//NOTE: This needs to be removed if/when this plug-in goes managed
			new PackageDataInstaller().authorizeDependencyInjectionFramework();
			createPluginProperties();
			registerESignatureVendor();
			registerServices();
		}

		public void onDeactivate() {
			deregisterServices();
		}

		private void createPluginProperties() {
			PluginConfigurationService pluginConfigService = new PluginConfigurationService();

			List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs =
				new List<nFUSE.PluginConfigurationManager.PluginConfiguration>();

			configs.add(pluginConfigService.createConfig(KEY_PLUGIN_NAME, PLUGIN_NAME, false));
			configs.add(pluginConfigService.createConfig(KEY_PLUGIN_VERSION, PLUGIN_VERSION, false));
			configs.add(pluginConfigService.createConfig(KEY_CONFIG_API_KEY, '', true));
			configs.add(pluginConfigService.createConfig(KEY_CREATE_PACKAGE_ENDPOINT, '', false));
			configs.add(pluginConfigService.createConfig(KEY_ADD_DOCUMENT_ENDPOINT, '', false));
			configs.add(pluginConfigService.createConfig(KEY_GET_DESIGNER_URL_ENDPOINT, '', false));
			configs.add(pluginConfigService.createConfig(KEY_DESIGNER_SESSION_URL, '', false));
			configs.add(pluginConfigService.createConfig(KEY_RETRIEVE_PACKAGE_METADATA_ENDPOINT, '', false));

			new nFUSE.PluginConfigurationManager(PLUGIN_NAME, PLUGIN_VERSION).softInsertConfigurations(configs);
		}

		private void registerServices() {
			nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(PLUGIN_NAME, PLUGIN_VERSION, null);
			new nFUSE.ServiceLocator().register(request, nFUSE.SendService.class, CreatePackageSendService.class, CREATE_COLLECTION_DIFFERENTIATOR);
			new nFUSE.ServiceLocator().register(request, nFUSE.SendService.class, AddDocumentSendService.class, ADD_DOCUMENT_DIFFERENTIATOR);
			new nFUSE.ServiceLocator().register(request, nFUSE.SendService.class, GetDesignerUrlSendService.class, GET_TAGGING_URL_DIFFERENTIATOR);
			new nFUSE.ServiceLocator().register(request, nFUSE.SendService.class, RetrievePackageMetadataSendService.class, RETRIEVE_PACKAGE_METADATA_DIFFERENTIATOR);
		}

		private void deregisterServices() {
			nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(PLUGIN_NAME, PLUGIN_VERSION, null);
			new nFUSE.ServiceLocator().deregister(request, nFUSE.SendService.class, CREATE_COLLECTION_DIFFERENTIATOR);
			new nFUSE.ServiceLocator().deregister(request, nFUSE.SendService.class, ADD_DOCUMENT_DIFFERENTIATOR);
			new nFUSE.ServiceLocator().deregister(request, nFUSE.SendService.class, GET_TAGGING_URL_DIFFERENTIATOR);
			new nFUSE.ServiceLocator().deregister(request, nFUSE.SendService.class, RETRIEVE_PACKAGE_METADATA_DIFFERENTIATOR);
		}

		private void registerESignatureVendor() {
			nFORCE.SystemProperties.updateProperty(
				ESIGN_PROPERTY_CATEGORY,
				ESIGN_VENDOR_KEY,
				PLUGIN_NAME,
				true
			);

			nFORCE.SystemProperties.updateProperty(
				ESIGN_PROPERTY_CATEGORY,
				ESIGN_VENDOR_VERSION_KEY,
				PLUGIN_VERSION,
				true
			);
		}
	}

	public static final String
		ADD_DOCUMENT_DIFFERENTIATOR = 'ADD_DOCUMENT',
		CREATE_COLLECTION_DIFFERENTIATOR = 'CREATE_COLLECTION',
		ESIGN_PROPERTY_CATEGORY = 'document manager',
		ESIGN_VENDOR_KEY = 'Ad Hoc E-Signature Vendor',
		ESIGN_VENDOR_VERSION_KEY = 'Ad Hoc E-Signature Vendor Version',
		GET_TAGGING_URL_DIFFERENTIATOR = 'GET_TAGGING_URL',
		KEY_ADD_DOCUMENT_ENDPOINT ='OneSpan_Add_Document_Endpoint',
		KEY_CONFIG_API_KEY = 'OneSpan_Client_API_Key',
		KEY_CREATE_PACKAGE_ENDPOINT = 'OneSpan_Create_Package_Endpoint',
		KEY_DESIGNER_SESSION_URL = 'OneSpan_Designer_Session_Url',
		KEY_GET_DESIGNER_URL_ENDPOINT = 'OneSpan_Get_Designer_Url_Endpoint',
		KEY_PLUGIN_NAME = 'pluginName',
		KEY_PLUGIN_VERSION = 'pluginVersion',
		KEY_RETRIEVE_PACKAGE_METADATA_ENDPOINT ='OneSpan_Retrieve_Package_Metadata_Endpoint',
		PLUGIN_NAME = 'OneSpan_ESignature',
		PLUGIN_VERSION = '1.0',
		RETRIEVE_PACKAGE_METADATA_DIFFERENTIATOR = 'RETRIEVE_COLLECTION_METADATA';
}
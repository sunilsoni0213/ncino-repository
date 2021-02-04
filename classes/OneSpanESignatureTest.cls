@isTest(IsParallel=true)
public with sharing class OneSpanESignatureTest {

	@isTest
	private static void shouldAddProperties_OnActivatePlugin() {
		OneSpanESignature.Activator activator = new OneSpanESignature.Activator();
		activator.onActivate();

		Test.startTest();
		Integer numConfigs = new nFUSE.PluginConfigurationManager(PLUGIN_NAME, PLUGIN_VERSION).getConfigurations().size();
		Test.stopTest();

		System.assertEquals(8, numConfigs);
	}

	@isTest
	private static void shouldNotRemovePluginConfigs_WhenDeactivatePlugin() {
		OneSpanESignature.Activator activator = new OneSpanESignature.Activator();
		activator.onActivate();
		activator.onDeactivate();

		Test.startTest();
		Integer numConfigs = new nFUSE.PluginConfigurationManager(PLUGIN_NAME, PLUGIN_VERSION).getConfigurations().size();
		Test.stopTest();

		System.assertEquals(8, numConfigs);
	}

	@isTest
	private static void shouldLocatePackageSendService_WhenActivatePlugin() {
		PackageDataInstaller dataInstaller = new PackageDataInstaller();
		dataInstaller.start(null);

		OneSpanESignature.Activator activator = new OneSpanESignature.Activator();
		activator.onActivate();

		Test.startTest();
		nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(PLUGIN_NAME, PLUGIN_VERSION, null);
		Object locatedService = new nFUSE.ServiceLocator().locate(request, nFUSE.SendService.class, OneSpanESignature.CREATE_COLLECTION_DIFFERENTIATOR);
		Test.stopTest();

		System.assertEquals(true, locatedService instanceof CreatePackageSendService);
	}

	@isTest
	private static void shouldLocateAddDocumentSendService_WhenActivatePlugin() {
		PackageDataInstaller dataInstaller = new PackageDataInstaller();
		dataInstaller.start(null);

		OneSpanESignature.Activator activator = new OneSpanESignature.Activator();
		activator.onActivate();

		Test.startTest();
		nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(PLUGIN_NAME, PLUGIN_VERSION, null);
		Object locatedService = new nFUSE.ServiceLocator().locate(request, nFUSE.SendService.class, OneSpanESignature.ADD_DOCUMENT_DIFFERENTIATOR);
		Test.stopTest();

		System.assertEquals(true, locatedService instanceof AddDocumentSendService);
	}

	@isTest
	private static void shouldLocateGetDesignerUrl_WhenActivatePlugin() {
		PackageDataInstaller dataInstaller = new PackageDataInstaller();
		dataInstaller.start(null);

		OneSpanESignature.Activator activator = new OneSpanESignature.Activator();
		activator.onActivate();

		Test.startTest();
		nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(PLUGIN_NAME, PLUGIN_VERSION, null);
		Object locatedService = new nFUSE.ServiceLocator().locate(request, nFUSE.SendService.class, OneSpanESignature.GET_TAGGING_URL_DIFFERENTIATOR);
		Test.stopTest();

		System.assertEquals(true, locatedService instanceof GetDesignerUrlSendService);
	}

	@isTest
	private static void shouldLocateRetrievePackageMetadata_WhenActivatePlugin() {
		PackageDataInstaller dataInstaller = new PackageDataInstaller();
		dataInstaller.start(null);

		OneSpanESignature.Activator activator = new OneSpanESignature.Activator();
		activator.onActivate();

		Test.startTest();
		nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(PLUGIN_NAME, PLUGIN_VERSION, null);
		Object locatedService = new nFUSE.ServiceLocator().locate(request, nFUSE.SendService.class, OneSpanESignature.RETRIEVE_PACKAGE_METADATA_DIFFERENTIATOR);
		Test.stopTest();

		System.assertEquals(true, locatedService instanceof RetrievePackageMetadataSendService);
	}

	@isTest
	private static void shouldNotLocatePackageSendService_WhenDeactivatePlugin() {
		OneSpanESignature.Activator activator = new OneSpanESignature.Activator();
		activator.onActivate();
		activator.onDeactivate();

		nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(PLUGIN_NAME, PLUGIN_VERSION, null);
		try {
			Object locatedService = new nFUSE.ServiceLocator().locate(request, nFUSE.SendService.class, OneSpanESignature.CREATE_COLLECTION_DIFFERENTIATOR);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith('Unable to locate service'));
		}
	}

	@isTest
	private static void shouldNotLocateAddDocumentSendService_WhenDeactivatePlugin() {
		OneSpanESignature.Activator activator = new OneSpanESignature.Activator();
		activator.onActivate();
		activator.onDeactivate();

		nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(PLUGIN_NAME, PLUGIN_VERSION, null);
		try {
			Object locatedService = new nFUSE.ServiceLocator().locate(request, nFUSE.SendService.class, OneSpanESignature.ADD_DOCUMENT_DIFFERENTIATOR);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith('Unable to locate service'));
		}
	}

	@isTest
	private static void shouldNotLocateGetDesignerUrlSendService_WhenDeactivatePlugin() {
		OneSpanESignature.Activator activator = new OneSpanESignature.Activator();
		activator.onActivate();
		activator.onDeactivate();

		nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(PLUGIN_NAME, PLUGIN_VERSION, null);
		try {
			Object locatedService = new nFUSE.ServiceLocator().locate(request, nFUSE.SendService.class, OneSpanESignature.GET_TAGGING_URL_DIFFERENTIATOR);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith('Unable to locate service'));
		}
	}

	@isTest
	private static void shouldNotLocateRetrievePackageMetadataSendService_WhenDeactivatePlugin() {
		OneSpanESignature.Activator activator = new OneSpanESignature.Activator();
		activator.onActivate();
		activator.onDeactivate();

		nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(PLUGIN_NAME, PLUGIN_VERSION, null);
		try {
			Object locatedService = new nFUSE.ServiceLocator().locate(request, nFUSE.SendService.class, OneSpanESignature.RETRIEVE_PACKAGE_METADATA_DIFFERENTIATOR);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith('Unable to locate service'));
		}
	}

	@isTest
	private static void shouldAddESignatureSysProperty() {
		OneSpanESignature.Activator activator = new OneSpanESignature.Activator();

		Test.startTest();
		activator.onActivate();
		Test.stopTest();

		nFORCE__System_Properties__c eSignVendor = getProperty(
			OneSpanESignature.ESIGN_PROPERTY_CATEGORY,
			OneSpanESignature.ESIGN_VENDOR_KEY
		);

		nFORCE__System_Properties__c eSignVendorVersion = getProperty(
			OneSpanESignature.ESIGN_PROPERTY_CATEGORY,
			OneSpanESignature.ESIGN_VENDOR_VERSION_KEY
		);

		System.assertEquals(OneSpanESignature.PLUGIN_NAME, eSignVendor.nFORCE__Value__c);
		System.assert(eSignVendor.nFORCE__Is_Active__c);

		System.assertEquals(OneSpanESignature.PLUGIN_VERSION, eSignVendorVersion.nFORCE__Value__c);
		System.assert(eSignVendorVersion.nFORCE__Is_Active__c);

	}

	@isTest
	private static void shouldUpdateESignatureSysProperty() {
		OneSpanESignature.Activator activator = new OneSpanESignature.Activator();
		activator.onActivate();

		nFORCE__System_Properties__c eSignVendor = getProperty(
			OneSpanESignature.ESIGN_PROPERTY_CATEGORY,
			OneSpanESignature.ESIGN_VENDOR_KEY
		);

		eSignVendor.nFORCE__Value__c = '🚬Vape Nation🚬';
		eSignVendor.nFORCE__Is_Active__c = false;
		nFORCE.DmlUtility.updateObj(eSignVendor);

		nFORCE__System_Properties__c eSignVendorVersion = getProperty(
			OneSpanESignature.ESIGN_PROPERTY_CATEGORY,
			OneSpanESignature.ESIGN_VENDOR_VERSION_KEY
		);

		eSignVendorVersion.nFORCE__Value__c = '🚭';
		eSignVendorVersion.nFORCE__Is_Active__c = false;
		nFORCE.DmlUtility.updateObj(eSignVendorVersion);



		Test.startTest();
		activator.onActivate();
		Test.stopTest();

		eSignVendor = getProperty(
			OneSpanESignature.ESIGN_PROPERTY_CATEGORY,
			OneSpanESignature.ESIGN_VENDOR_KEY
		);

		eSignVendorVersion = getProperty(
			OneSpanESignature.ESIGN_PROPERTY_CATEGORY,
			OneSpanESignature.ESIGN_VENDOR_VERSION_KEY
		);

		System.assertEquals(OneSpanESignature.PLUGIN_NAME, eSignVendor.nFORCE__Value__c);
		System.assert(eSignVendor.nFORCE__Is_Active__c);

		System.assertEquals(OneSpanESignature.PLUGIN_VERSION, eSignVendorVersion.nFORCE__Value__c);
		System.assert(eSignVendorVersion.nFORCE__Is_Active__c);
	}

	private static nFORCE__System_Properties__c getProperty(String category, String key) {
		List<nFORCE__System_Properties__c> props = [
			SELECT
				nFORCE__Category_Name__c,
				nFORCE__Key__c,
				nFORCE__Value__c,
				nFORCE__Is_Active__c
			FROM
				nFORCE__System_Properties__c
			WHERE
			nFORCE__Category_Name__c = :category
			AND
			nFORCE__Key__c = :key
		];
		if (props != null && props.size() > 0) {
			return props[0];
		}
		return new nFORCE__System_Properties__c();
	}

	public static final String
		PLUGIN_NAME = 'OneSpan_ESignature',
		PLUGIN_VERSION = '1.0';
}
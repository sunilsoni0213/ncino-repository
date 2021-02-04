/**
 * Test DocPrep Plugin
 **/
@isTest
global with sharing class TestCSIDepActDocPrep extends nFUSE.DepActDocPrepAppFacade {

	@TestSetup
	static void setup() {
		new nFUSE.DataInstaller().onInstall(null);
		CSIDepActDocPrep.Activator act = new CSIDepActDocPrep.Activator();
		act.onActivate();
	}

	@isTest
	private static void testActivation_onActivate_installProperties() {
		nFUSE.PluginConfigurationManager configManager = new nFUSE.PluginConfigurationManager(CSIDepActDocPrep.PLUGIN_NAME, CSIDepActDocPrep.PLUGIN_VERSION);
		List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs = configManager.getConfigurations();

		List<String> keysToCheck = expectedProperties.clone();
		System.assertEquals(8, keysToCheck.size());
		for(nFUSE.PluginConfigurationManager.PluginConfiguration currentConfig : configs) {
			removeValueFromList(keysToCheck, currentConfig.key);
		}
		System.assertEquals(0, keysToCheck.size());
	}

	@isTest
	private static void testActivation_onActivateTwice_installProperties() {
		Test.startTest();
		CSIDepActDocPrep.Activator act = new CSIDepActDocPrep.Activator();
		nFORCE.SystemProperties.getInstance().clearCache();
		act.onDeactivate();
		act.onActivate();
		nFORCE.SystemProperties.getInstance().clearCache();
		Test.stopTest();

		nFUSE.PluginConfigurationManager configManager = new nFUSE.PluginConfigurationManager(CSIDepActDocPrep.PLUGIN_NAME, CSIDepActDocPrep.PLUGIN_VERSION);
		List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs = configManager.getConfigurations();

		List<String> keysToCheck = expectedProperties.clone();
		System.assertEquals(8, keysToCheck.size());
		for(nFUSE.PluginConfigurationManager.PluginConfiguration currentConfig : configs) {
			removeValueFromList(keysToCheck, currentConfig.key);
		}
		System.assertEquals(0, keysToCheck.size());
	}

	@isTest
	private static void testBeanRegistered() {
		Test.startTest();

		System.assert(true, nFORCE.BeanRegistry.getInstance().isRegistered(
			CSIDepActDocPrep.AppFacade.class.getName()));
		//TODO: add assertion for deactivate
		Test.stopTest();
	}

	@isTest
	private static void testStoreDocuments_hasImplementation() {
		CSIDepActDocPrep.AppFacade facade = new CSIDepActDocPrep.AppFacade();
		MockDocManAttachmentHandler attachmentHandler = new MockDocManAttachmentHandler();
		facade.attachmentHandler = attachmentHandler;
		Account acct = new Account(Name = 'Test');
		insert acct;
		nFUSE__Transaction_Log__c tLog = new nFUSE__Transaction_Log__c(
			nFUSE__Action__c = 'test',
			nFUSE__Api_Version__c = '1.0',
			nFUSE__Requesting_User_Id__c = UserInfo.getUserId(),
			nFUSE__Requested_By_User_Id__c = UserInfo.getUserId(),
			nFUSE__Transaction_Status__c = 'INPROGRESS',
			nFUSE__Object_Id__c = acct.Id,
			nFUSE__Primary_Object_Id__c = acct.Id,
			nFUSE__App_Plugin__c = 'Equifax_Credit',
			nFUSE__External_Id__c = new nFORCE.GuidGenerator().randomUUID()
		);
		insert tLog;
		Test.startTest();
		facade.storeDocument(tLog.nFUSE__External_Id__c, 'test', 'some doc content');
		Test.stopTest();
		System.assertEquals(EncodingUtil.base64Decode('some doc content'), attachmentHandler.storeDocumentBlob);
	}

	@isTest
	private static void testActivation_ActivateTwice_UIRoutesInstalledOnce() {
		CSIDepActDocPrep.Activator act = new CSIDepActDocPrep.Activator();
		nFORCE__Group__c depGroup_PC = createGroup('someName pc', CSIDepActDocPrep.DEP_PC_GROUP_APP);
		nFORCE__Group__c depGroup_PM = createGroup('someName pm', CSIDepActDocPrep.DEP_PM_GROUP_APP);

		nFORCE__Route__c docRoute_PC = act.createRoute(
			'Documents',
			CSIDepActDocPrep.PC_DEP_DOCPREP_APP,
			'nFORCE__ncTopbar',
			'nFORCE__Blank',
			'nFORCE__Navigation',
			'nFORCE__Sub_Navigation',
			CSIDepActDocPrep.DOCUMENT_ICON);
		insert docRoute_PC;

		nFORCE__Route__c docRoute_PM = act.createRoute(
			'Documents',
			CSIDepActDocPrep.PM_DEP_DOCPREP_APP,
			'nFORCE__ncTopbar',
			'nFORCE__Blank',
			'nFORCE__Navigation',
			'nFORCE__Sub_Navigation',
			CSIDepActDocPrep.DOCUMENT_ICON);
		insert docRoute_PM;

		System.assertEquals(null, act.retrieveRouteGroup(CSIDepActDocPrep.COMPLETION_APP, depGroup_PC.Id));
		System.assertEquals(null, act.retrieveRouteGroup(CSIDepActDocPrep.COMPLETION_APP, depGroup_PM.Id));

		act.onActivate();
		Map<String, nFORCE__Route__c> installedRoutes = act.getInstalledRoutes();

		System.assertNotEquals(null, installedRoutes.get(CSIDepActDocPrep.COMPLETION_APP));
		System.assertNotEquals(null, act.retrieveRouteGroup(CSIDepActDocPrep.COMPLETION_APP, depGroup_PC.Id));
		System.assertNotEquals(null, act.retrieveRouteGroup(CSIDepActDocPrep.COMPLETION_APP, depGroup_PM.Id));

	}

	@isTest
	private static void testActivation_onDeactivate_UIRoutesRemoved() {
		CSIDepActDocPrep.Activator act = new CSIDepActDocPrep.Activator();
		nFORCE__Group__c depGroup_PC = createGroup('someName pc', CSIDepActDocPrep.DEP_PC_GROUP_APP);
		nFORCE__Group__c depGroup_PM = createGroup('someName pm', CSIDepActDocPrep.DEP_PM_GROUP_APP);

		nFORCE__Route__c docRoute_PC = act.createRoute(
			'Documents',
			CSIDepActDocPrep.PC_DEP_DOCPREP_APP,
			'nFORCE__ncTopbar',
			'nFORCE__Blank',
			'nFORCE__Navigation',
			'nFORCE__Sub_Navigation',
			CSIDepActDocPrep.DOCUMENT_ICON);
		insert docRoute_PC;

		nFORCE__Route__c docRoute_PM = act.createRoute(
			'Documents',
			CSIDepActDocPrep.PM_DEP_DOCPREP_APP,
			'nFORCE__ncTopbar',
			'nFORCE__Blank',
			'nFORCE__Navigation',
			'nFORCE__Sub_Navigation',
			CSIDepActDocPrep.DOCUMENT_ICON);
		insert docRoute_PM;

		act.onActivate();
		Map<String, nFORCE__Route__c> installedRoutes = act.getInstalledRoutes();

		System.assertNotEquals(null, installedRoutes.get(CSIDepActDocPrep.COMPLETION_APP));
		System.assertNotEquals(null, act.retrieveRouteGroup(CSIDepActDocPrep.COMPLETION_APP, depGroup_PC.Id));
		System.assertNotEquals(null, act.retrieveRouteGroup(CSIDepActDocPrep.COMPLETION_APP, depGroup_PM.Id));

		act.onDeactivate();
		installedRoutes = act.getInstalledRoutes();

		System.assertEquals(null, installedRoutes.get(CSIDepActDocPrep.COMPLETION_APP));
		System.assertEquals(null, act.retrieveRouteGroup(CSIDepActDocPrep.COMPLETION_APP, depGroup_PC.Id));
		System.assertEquals(null, act.retrieveRouteGroup(CSIDepActDocPrep.COMPLETION_APP, depGroup_PM.Id));

	}

	@isTest
	private static void testPreNavAdjustmentsDocsToCompletion() {
		CSIDepActDocPrep.AppFacade facade = new CSIDepActDocPrep.AppFacade();
		TestableCSIDepActDocPrepAppFacate mockFacade = new TestableCSIDepActDocPrepAppFacate();
		Map<String, String> params = new Map<String, String> {
			CSIDepActDocPrepConstants.PARAM_ID => '123456',
			CSIDepActDocPrepConstants.PARAM_SID => '56789',
			CSIDepActDocPrepConstants.PARAM_PROVIDER => CSIDepActDocPrepConstants.PROVIDER_CSI_DEPACT_DOCPREP,
			CSIDepActDocPrepConstants.PARAM_APP => CSIDepActDocPrep.DEP_PC_GROUP_APP + '.' + CSIDepActDocPrep.PC_DOCUMENTS_APP,
			CSIDepActDocPrepConstants.PARAM_EXTERNAL_LOG_ID => 'transactionLogId'
		};
		NavigationRequest navRequest = mockFacade.getTestNavRequest();
		navRequest.requestedRef.getParameters().putAll(params);

		NavigationRequest navRequestAdjusted = facade.preNavAdjustments(navRequest);

		System.assertEquals(CSIDepActDocPrep.DEP_PC_GROUP_APP + '.' + CSIDepActDocPrep.COMPLETION_APP,
			navRequestAdjusted.requestedRef.getParameters().get(CSIDepActDocPrepConstants.PARAM_APP));
	}

	@isTest
	private static void testPreNavNoAdjustments() {
		CSIDepActDocPrep.AppFacade facade = new CSIDepActDocPrep.AppFacade();
		TestableCSIDepActDocPrepAppFacate mockFacade = new TestableCSIDepActDocPrepAppFacate();
		Map<String, String> params = new Map<String, String> {
			CSIDepActDocPrepConstants.PARAM_ID => '123456',
			CSIDepActDocPrepConstants.PARAM_SID => '56789',
			CSIDepActDocPrepConstants.PARAM_PROVIDER => CSIDepActDocPrepConstants.PROVIDER_CSI_DEPACT_DOCPREP,
			CSIDepActDocPrepConstants.PARAM_APP => CSIDepActDocPrep.DEP_PC_GROUP_APP + '.dep-docprep-review',
			CSIDepActDocPrepConstants.PARAM_EXTERNAL_LOG_ID => 'transactionLogId'
		};
		NavigationRequest navRequest = mockFacade.getTestNavRequest();
		navRequest.requestedRef.getParameters().putAll(params);

		NavigationRequest navRequestAdjusted = facade.preNavAdjustments(navRequest);

		System.assertEquals(CSIDepActDocPrep.DEP_PC_GROUP_APP + '.dep-docprep-review',
			navRequestAdjusted.requestedRef.getParameters().get(CSIDepActDocPrepConstants.PARAM_APP));
	}

	@isTest
	private static void testPreCommAdjustments() {
		Test.setCurrentPage(new PageReference(FAKE_URL));
		String redirectURL = URL.getSalesforceBaseUrl().toExternalForm() + CSIDepActDocPrepConstants.FILING_PAGE;

		DummyMiddlewareMessage message = new DummyMiddlewareMessage();
		CSIDepActDocPrep.AppFacade facade = new CSIDepActDocPrep.AppFacade();
		facade.preCommAdjustments(message);

		System.assertEquals(CSIDepActDocPrepConstants.DEPOSIT_CATEGORY,
			message.properties.get(CSIDepActDocPrepConstants.PROP_PRODUCT_CATEGORY));
		System.assertEquals(CSIDepActDocPrepConstants.PC_SUB_CATEGORY,
			message.properties.get(CSIDepActDocPrepConstants.PROP_PRODUCT_SUB_CATEGORY));

		System.assertEquals(redirectURL.replace(CSIDepActDocPrepConstants.LLC_BI_NAMESPACE,
			CSIDepActDocPrepConstants.NO_NAMESPACE),
			message.properties.get(CSIDepActDocPrepConstants.FILING_URL));

		System.assertEquals(CSIDepActDocPrepConstants.COMPLIANCE_SERVICE_ENDPOINT,
			message.properties.get(CSIDepActDocPrepConstants.PARAM_COMPLIANCE_SERVICE_HOST_URI));
		System.assertEquals(CSIDepActDocPrepConstants.SIMPLICITY_ENDPOINT,
			message.properties.get(CSIDepActDocPrepConstants.PARAM_SIMPLICITY_HOST_URI));
		System.assertEquals(CSIDepActDocPrepConstants.WORKFLOW_SERVICE_ENDPOINT,
			message.properties.get(CSIDepActDocPrepConstants.PARAM_WORKFLOW_SERVICE_HOST_URI));
		System.assertEquals(CSIDepActDocPrepConstants.WORKFLOW_SERVICES_VERSION_ONE_ONE,
			message.properties.get(CSIDepActDocPrepConstants.PARAM_WORKFLOW_SERVICES_VERSION));

	}

	@isTest
	private static void testPropertyNotPopulatedSendsNull() {
		DummyMiddlewareMessage message = new DummyMiddlewareMessage();
		CSIDepActDocPrep.AppFacade facade = new CSIDepActDocPrep.AppFacade();
		facade.preCommAdjustments(message);

		System.assertEquals(null, message.properties.get(CSIDepActDocPrepConstants.PARAM_ESIGNATURE_VENDOR));
		System.assertEquals(null, message.properties.get(CSIDepActDocPrepConstants.PARAM_DOC_LIBRARY_VERSION));
		System.assertEquals(null, message.properties.get(CSIDepActDocPrepConstants.PARAM_INTERFACE_CUSTOMIZATION));
	}

	@isTest
	private static void testValidPropertyExistsSendValue() {
		nFUSE.PluginConfigurationManager configManager = new nFUSE.PluginConfigurationManager(CSIDepActDocPrep.PLUGIN_NAME, CSIDepActDocPrep.PLUGIN_VERSION);
		List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs = configManager.getConfigurations();
		CSIDepActDocPrep.getPluginConfig(configs, CSIDepActDocPrep.SYS_PRP_ESIGN_VENDOR).value = 'Test Vendor';
		CSIDepActDocPrep.getPluginConfig(configs, CSIDepActDocPrep.SYS_PRP_DOC_LIBRARY_VERSION).value = 'Test Library Version';
		CSIDepActDocPrep.getPluginConfig(configs, CSIDepActDocPrep.SYS_PRP_INTERFACE_CUSTOMIZATION).value = 'Test Interface Customization';
		configManager.updateConfigurations(configs);

		DummyMiddlewareMessage message = new DummyMiddlewareMessage();
		CSIDepActDocPrep.AppFacade facade = new CSIDepActDocPrep.AppFacade();
		facade.preCommAdjustments(message);

		System.assertEquals('Test Vendor', message.properties.get(CSIDepActDocPrepConstants.PARAM_ESIGNATURE_VENDOR));
		System.assertEquals('Test Library Version', message.properties.get(CSIDepActDocPrepConstants.PARAM_DOC_LIBRARY_VERSION));
		System.assertEquals('Test Interface Customization', message.properties.get(CSIDepActDocPrepConstants.PARAM_INTERFACE_CUSTOMIZATION));
	}

	@isTest
	private static void testLicenseKeysConcatenateInOrder() {
		nFUSE.PluginConfigurationManager configManager = new nFUSE.PluginConfigurationManager(CSIDepActDocPrep.PLUGIN_NAME, CSIDepActDocPrep.PLUGIN_VERSION);
		List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs = configManager.getConfigurations();
		for(Integer i = 0; i < CSIDepActDocPrep.CSI_LICENSE_KEYS.size(); i++) {
			CSIDepActDocPrep.getPluginConfig(configs, CSIDepActDocPrep.CSI_LICENSE_KEYS[i]).value = 'test' + i;
		}
		configManager.updateConfigurations(configs);

		DummyMiddlewareMessage message = new DummyMiddlewareMessage();
		CSIDepActDocPrep.AppFacade facade = new CSIDepActDocPrep.AppFacade();
		facade.preCommAdjustments(message);

		System.assertEquals('test0test1test2test3test4', message.properties.get(CSIDepActDocPrepConstants.PARAM_LICENSE_KEY));
	}

	@isTest
	private static void testLicenseKeysConcatonateInOrderLastKeyMissing() {
		nFUSE.PluginConfigurationManager configManager = new nFUSE.PluginConfigurationManager(CSIDepActDocPrep.PLUGIN_NAME, CSIDepActDocPrep.PLUGIN_VERSION);
		List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs = configManager.getConfigurations();
		for(Integer i = 0; i < CSIDepActDocPrep.CSI_LICENSE_KEYS.size() - 1; i++) {
			CSIDepActDocPrep.getPluginConfig(configs, CSIDepActDocPrep.CSI_LICENSE_KEYS[i]).value = 'test' + i;
		}
		configManager.updateConfigurations(configs);

		DummyMiddlewareMessage message = new DummyMiddlewareMessage();
		CSIDepActDocPrep.AppFacade facade = new CSIDepActDocPrep.AppFacade();
		facade.preCommAdjustments(message);

		System.assertEquals('test0test1test2test3', message.properties.get(CSIDepActDocPrepConstants.PARAM_LICENSE_KEY));
	}

	private static void removeValueFromList(List<Object> theList, Object theValue) {
		for(Integer i = 0; i < theList.size(); i++) {
			if(theList.get(i) == theValue) {
				theList.remove(i);
				return;
			}
		}
	}

	private static nFORCE__Group__c createGroup(String name, String app) {
		nFORCE__Group__c depGroup = new nFORCE__Group__c(
			Name = name,
			nFORCE__App__c = app
		);
		insert depGroup;
		return depGroup;
	}

	private virtual class TestableCSIDepActDocPrepAppFacate extends nFUSE.DepActDocPrepAppFacade {
		public TestableCSIDepActDocPrepAppFacate() {
			super();
		}

		public NavigationRequest getTestNavRequest() {
			NavigationRequest navRequest = new NavigationRequest();
			navRequest.requestedRef = new PageReference('/');
			return navRequest;
		}
	}

	private class DummyMiddlewareMessage extends nFUSE.DocPrepRequest {
		public DummyMiddlewareMessage() {
		}
	}

	private static String FAKE_URL = 'apex/product_creation?app=dep-pc.doc-completion&id=a1L0Y0000001RT0UAM&provider=CSI_DepAct_DocPrep&sid=a0O0Y000000APnIUAW';
	private static List<String> expectedProperties = new List<String> {
		CSIDepActDocPrep.LICENSE_KEY_ONE,
		CSIDepActDocPrep.LICENSE_KEY_TWO,
		CSIDepActDocPrep.LICENSE_KEY_THREE,
		CSIDepActDocPrep.LICENSE_KEY_FOUR,
		CSIDepActDocPrep.LICENSE_KEY_FIVE,
		CSIDepActDocPrep.SYS_PRP_ESIGN_VENDOR,
		CSIDepActDocPrep.SYS_PRP_DOC_LIBRARY_VERSION,
		CSIDepActDocPrep.SYS_PRP_INTERFACE_CUSTOMIZATION
	};

	private class MockDocManAttachmentHandler extends CSIDepActDocPrep.DocManAttachmentHandler {

		public Blob storeDocumentBlob { get; private set; }

		public override void storeDocument(String transactionId, String templateName, Blob docContent) {
			storeDocumentBlob = docContent;
		}

		public override void storeDocument(String transactionId, String templateName, String templateFileName, Blob docContent) {
			storeDocumentBlob = docContent;
		}
	}
}
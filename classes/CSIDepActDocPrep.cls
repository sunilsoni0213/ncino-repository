/**
 * DocPrep Plugin
 **/
global with sharing class CSIDepActDocPrep {
	/**
	 * DocPrep AppFacade
	 **/
	global with sharing class AppFacade extends nFUSE.DepActDocPrepAppFacade {

		@TestVisible private DocManAttachmentHandler attachmentHandler = new DocManAttachmentHandler();

		global override void storeDocument(String transactionId, String docName, String docContent) {
			Integer fieldMaxLegnth = Schema.SObjectType.LLC_BI__Document_Placeholder__c.fields.Name.getLength();
			fieldMaxLegnth -= SPACE_WITH_DATETIME_NOW_FORMAT.length();

			if(docName.length() > fieldMaxLegnth) {
				docName = docName.substringBeforeLast(PERIOD).substring(0, fieldMaxLegnth) +
					PERIOD + docName.substringAfterLast(PERIOD);
			}

			Blob content = EncodingUtil.base64Decode(docContent);
			attachmentHandler.storeDocument(transactionId, CSIDepActDocPrepConstants.PROVIDER_CSI_DEPACT_DOCPREP, docName, content);
		}

		global protected override NavigationRequest preNavAdjustments(NavigationRequest navRequest) {
			if(navRequest != null &&
				navRequest.requestedRef.getParameters().get(CSIDepActDocPrepConstants.PARAM_PROVIDER) ==
					CSIDepActDocPrepConstants.PROVIDER_CSI_DEPACT_DOCPREP) {

				Map<String, String> requestedParams = navRequest.requestedRef.getParameters();
				Map<String, String> origParams = navRequest.requestingRef.getParameters();
				if(requestedParams.get(CSIDepActDocPrepConstants.PARAM_APP) == DEP_PC_GROUP_APP + PERIOD + PC_DOCUMENTS_APP) {
					requestedParams.put(CSIDepActDocPrepConstants.PARAM_APP, DEP_PC_GROUP_APP + PERIOD + COMPLETION_APP);

				}
				else if(requestedParams.get(CSIDepActDocPrepConstants.PARAM_APP) == DEP_PM_GROUP_APP + PERIOD + PM_DOCUMENTS_APP) {
					requestedParams.put(CSIDepActDocPrepConstants.PARAM_APP, DEP_PM_GROUP_APP + PERIOD + COMPLETION_APP);

				}
			}
			return navRequest;
		}

		global override nFUSE.AMiddlewareMessage preCommAdjustments(nFUSE.AMiddlewareMessage message) {

			if(message instanceOf nFUSE.DocPrepRequest) {

				if(message.messageHeader.action == null) {
					message.messageHeader.action = CSIDepActDocPrepConstants.ACTION_NEW;
				}

				message.properties.put(CSIDepActDocPrepConstants.PROP_PRODUCT_CATEGORY,
					CSIDepActDocPrepConstants.DEPOSIT_CATEGORY);

				if(message.properties.get(CSIDepActDocPrepConstants.PROPERTY_BAG_SESSION_CATEGORY) ==
					LLC_BI.SessionCategory.DEPOSIT_MAINTENANCE) {

					message.properties.put(CSIDepActDocPrepConstants.PROP_PRODUCT_SUB_CATEGORY,
						CSIDepActDocPrepConstants.PM_SUB_CATEGORY);
				}
				else {
					message.properties.put(CSIDepActDocPrepConstants.PROP_PRODUCT_SUB_CATEGORY,
						CSIDepActDocPrepConstants.PC_SUB_CATEGORY);
				}

				String redirectURL = URL.getSalesforceBaseUrl().toExternalForm() + CSIDepActDocPrepConstants.FILING_PAGE;

				message.properties.put(CSIDepActDocPrepConstants.FILING_URL, redirectURL);

				nFUSE.PluginConfigurationManager configManager = new nFUSE.PluginConfigurationManager(PLUGIN_NAME, PLUGIN_VERSION);
				List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs = configManager.getConfigurations();

				message.properties.put(
					CSIDepActDocPrepConstants.PARAM_LICENSE_KEY,
					concatenateLicenseKeys(configs));
				message.properties.put(
					CSIDepActDocPrepConstants.PARAM_ESIGNATURE_VENDOR,
					getPluginConfig(configs, SYS_PRP_ESIGN_VENDOR).value);
				message.properties.put(
					CSIDepActDocPrepConstants.PARAM_DOC_LIBRARY_VERSION,
					getPluginConfig(configs, SYS_PRP_DOC_LIBRARY_VERSION).value);
				message.properties.put(
					CSIDepActDocPrepConstants.PARAM_INTERFACE_CUSTOMIZATION,
					getPluginConfig(configs, SYS_PRP_INTERFACE_CUSTOMIZATION).value);
				message.properties.put(
					CSIDepActDocPrepConstants.PARAM_COMPLIANCE_SERVICE_HOST_URI,
					getPluginConfig(configs, COMPLIANCE_SERVICE_HOST_URI).value);
				message.properties.put(
					CSIDepActDocPrepConstants.PARAM_SIMPLICITY_HOST_URI,
					getPluginConfig(configs, SIMPLICITY_HOST_URI).value);
				message.properties.put(
					CSIDepActDocPrepConstants.PARAM_WORKFLOW_SERVICE_HOST_URI,
					getPluginConfig(configs, WORKFLOW_SERVICE_HOST_URI).value);
				message.properties.put(
					CSIDepActDocPrepConstants.PARAM_WORKFLOW_SERVICES_VERSION,
					getPluginConfig(configs, WORKFLOW_SERVICES_VERSION).value);
			}
			return message;
		}

		@TestVisible
		private String concatenateLicenseKeys(List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs) {
			String concatProperty = EMPTY_STRING;
			for(String prop : CSI_LICENSE_KEYS) {
				String propValue = getPluginConfig(configs, prop).value;
				if(propValue != null) {
					concatProperty += propValue;
				}
			}
			return concatProperty;
		}
	}
	/**
	 * DocPrep Activator
	 **/
	global with sharing class Activator implements nFUSE.IPluginActivator {

		public void onActivate() {
			// register DocPrep app facade
			nFORCE.BeanRegistry.getInstance().registerBean(
				CSIDepActDocPrep.AppFacade.class.getName(),
				nFUSE.DepActDocPrepAppFacade.class,
				CSIDepActDocPrep.AppFacade.class,
				new Map<String, Object> {},
				true);

			createPluginConfigs();
			registerTriggers();
			processDepActCompletionUiSetup();
		}

		private void registerTriggers() {
			nFORCE.BeanRegistry.getInstance().registerBean(
				EntityDocPrepTriggerHandler.BEAN_NAME,
				nFORCE.IPipelineComponent.class,
				EntityDocPrepTriggerHandler.class,
				new Map<String, Object>{},
				true
			);
			nFORCE.BeanRegistry.getInstance().registerBean(
				DEPOSIT_ENTITY_INVOLVEMENT_AFTER_INSERT_TRIGGERS_BEAN,
				nFORCE.IPipelineContainer.class,
				nFORCE.TriggerPipeline.class,
				new Map<String, Object>{
					nFORCE.PipelineContainer.PIPELINE_BEAN_UNIQUE_NAMES => new String[]{
						EntityDocPrepTriggerHandler.BEAN_NAME
					}
				},
				true
			);
			nFORCE.BeanRegistry.getInstance().registerBean(
				AuthorizedSignerDocPrepTriggerHandler.BEAN_NAME,
				nFORCE.IPipelineComponent.class,
				AuthorizedSignerDocPrepTriggerHandler.class,
				new Map<String, Object>{},
				true
			);
			nFORCE.BeanRegistry.getInstance().registerBean(
				DEPOSIT_AUTHORIZED_SIGNER_AFTER_INSERT_TRIGGERS_BEAN,
				nFORCE.IPipelineContainer.class,
				nFORCE.TriggerPipeline.class,
				new Map<String, Object>{
					nFORCE.PipelineContainer.PIPELINE_BEAN_UNIQUE_NAMES => new String[]{
						AuthorizedSignerDocPrepTriggerHandler.BEAN_NAME
					}
				},
				true
			);
		}
		
		public void onDeactivate() {
			// deregister DocPrep app facade
			nFORCE.BeanRegistry.getInstance().deregisterBean(CSIDepActDocPrep.AppFacade.class.getName());
			deregisterTriggers();
			processDepActCompletionUiRemoval();
		}

		private void deregisterTriggers() {
			nFORCE.BeanRegistry.getInstance().deregisterBean(EntityDocPrepTriggerHandler.BEAN_NAME, true);
			nFORCE.BeanRegistry.getInstance().deregisterBean(DEPOSIT_ENTITY_INVOLVEMENT_AFTER_INSERT_TRIGGERS_BEAN, true);
		}
		private void createPluginConfigs() {
			List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs = new List<nFUSE.PluginConfigurationManager.PluginConfiguration> {};

			for(String sysPropKey : CSI_LICENSE_KEYS) {
				configs.add(createPluginConfig(sysPropKey));
			}

			configs.add(createPluginConfig(SYS_PRP_ESIGN_VENDOR));
			configs.add(createPluginConfig(SYS_PRP_DOC_LIBRARY_VERSION));
			configs.add(createPluginConfig(SYS_PRP_INTERFACE_CUSTOMIZATION));
			configs.add(createPluginConfig(COMPLIANCE_SERVICE_HOST_URI, CSIDepActDocPrepConstants.COMPLIANCE_SERVICE_ENDPOINT));
			configs.add(createPluginConfig(SIMPLICITY_HOST_URI, CSIDepActDocPrepConstants.SIMPLICITY_ENDPOINT));
			configs.add(createPluginConfig(WORKFLOW_SERVICE_HOST_URI, CSIDepActDocPrepConstants.WORKFLOW_SERVICE_ENDPOINT));
			configs.add(createPluginConfig(WORKFLOW_SERVICES_VERSION, CSIDepActDocPrepConstants.WORKFLOW_SERVICES_VERSION));

			new nFUSE.PluginConfigurationManager(PLUGIN_NAME, PLUGIN_VERSION).softInsertConfigurations(configs);
		}

		private nFUSE.PluginConfigurationManager.PluginConfiguration createPluginConfig(String key) {
			return createPluginConfig(key, null);
		}

		private nFUSE.PluginConfigurationManager.PluginConfiguration createPluginConfig(String key, String value) {
			nFUSE.PluginConfigurationManager.PluginConfiguration pluginConfig = new nFUSE.PluginConfigurationManager.PluginConfiguration();
			pluginConfig.pluginName = PLUGIN_NAME;
			pluginConfig.pluginVersion = PLUGIN_VERSION;
			pluginConfig.category = PLUGIN_NAME;
			pluginConfig.key = key;
			pluginConfig.valueDataType = 'String';
			pluginConfig.isEncrypted = false;
			pluginConfig.value = value;

			return pluginConfig;
		}

		private Boolean containsCategory(String category) {
			Decimal count = [
				SELECT
					count()
				FROM
					nFORCE__System_Configuration__c
				WHERE
					NAME = :category
			];
			return count > 0 ? true : false;
		}

		private void processDepActCompletionUiSetup() {
			processPCUI();
			processPMUI();
		}

		private void processDepActCompletionUiRemoval() {
			List<sObject> toDelete = new List<sObject>();

			Map<String, nFORCE__Route__c> installedRoutes = getInstalledRoutes();

			nFORCE__Group__c depPCgroup = retrieveGroupByAppName(DEP_PC_GROUP_APP);
			if(depPCgroup != null) {
				nFORCE__Route_Group__c pcRouteGroup = retrieveRouteGroup(COMPLETION_APP, depPCgroup.Id);
				if(pcRouteGroup != null) {
					toDelete.add(pcRouteGroup);
				}
			}

			nFORCE__Group__c depPMgroup = retrieveGroupByAppName(DEP_PM_GROUP_APP);
			if(depPMgroup != null) {
				nFORCE__Route_Group__c pmRouteGroup = retrieveRouteGroup(COMPLETION_APP, depPMgroup.Id);
				if(pmRouteGroup != null) {
					toDelete.add(pmRouteGroup);
				}
			}

			nFORCE__Route__c completionRoute = installedRoutes.get(COMPLETION_APP);
			if(completionRoute != null) {
				toDelete.add(completionRoute);
			}

			nFORCE.DmlUtility.deleteObj(toDelete);
		}

		private void processPCUI() {
			Map<String, nFORCE__Route__c> installedRoutes = getInstalledRoutes();

			nFORCE__Group__c depPCgroup = retrieveGroupByAppName(DEP_PC_GROUP_APP);
			if(depPCgroup == null) return;

			nFORCE__Route__c pcGenDocsRoute = installedRoutes.get(PC_DEP_DOCPREP_APP);
			if(pcGenDocsRoute == null) return;

			nFORCE__Route__c compRoutePC = installedRoutes.get(COMPLETION_APP);

			if(compRoutePC == null) {
				compRoutePC = createRoute(
					COMPLETION_ROUTE_NAME,
					COMPLETION_APP,
					getPageName(Page.nFORCE__ncTopbar),
					getPageName(Page.CSIDepActDocPrepCompletion),
					getPageName(Page.nFORCE__Navigation),
					getPageName(Page.nFORCE__Sub_Navigation),
					''
				);
				nFORCE.DmlUtility.insertObj(compRoutePC);
			}

			if(retrieveRouteGroup(COMPLETION_APP, depPCgroup.Id) == null) {
				nFORCE__Route_Group__c pcCompRouteGroup = createRouteGroup(
					depPCgroup,
					compRoutePC,
					pcGenDocsRoute,
					4,
					false,
					true,
					false
				);
				nFORCE.DmlUtility.insertObj(pcCompRouteGroup);
			}
		}

		private void processPMUI() {
			Map<String, nFORCE__Route__c> installedRoutes = getInstalledRoutes();

			nFORCE__Group__c depPMgroup = retrieveGroupByAppName(DEP_PM_GROUP_APP);
			if(depPMgroup == null) return;

			nFORCE__Route__c pmGenDocsRoute = installedRoutes.get(PM_DEP_DOCPREP_APP);
			if(pmGenDocsRoute == null) return;

			nFORCE__Route__c compRoutePM = installedRoutes.get(COMPLETION_APP);

			if(compRoutePM == null) {
				compRoutePM = createRoute(
					COMPLETION_ROUTE_NAME,
					COMPLETION_APP,
					getPageName(Page.nFORCE__ncTopbar),
					getPageName(Page.CSIDepActDocPrepCompletion),
					getPageName(Page.nFORCE__Navigation),
					getPageName(Page.nFORCE__Sub_Navigation),
					'');
				nFORCE.DmlUtility.insertObj(compRoutePM);
			}

			if(retrieveRouteGroup(COMPLETION_APP, depPMgroup.Id) == null) {

				nFORCE__Route_Group__c pmCompRouteGroup = createRouteGroup(
					depPMgroup,
					compRoutePM,
					pmGenDocsRoute,
					4,
					false,
					true,
					false
				);
				nFORCE.DmlUtility.insertObj(pmCompRouteGroup);
			}
		}

		@TestVisible
		private nFORCE__Route__c createRoute(
			String name,
			String app,
			String topBar,
			String body,
			String navigation,
			String subNavigation,
			String iconClass) {

			nFORCE__Route__c route = new nFORCE__Route__c(
				Name = name,
				nFORCE__App__c = app,
				nFORCE__Topbar__c = topBar,
				nFORCE__Body__c = body,
				nFORCE__Navigation__c = navigation,
				nFORCE__Sub_Navigation__c = subNavigation,
				nFORCE__Icon_Class__c = iconClass);

			return route;
		}

		private nFORCE__Route_Group__c createRouteGroup(
			nFORCE__Group__c prodGroup,
			nFORCE__Route__c route,
			nFORCE__Route__c parent,
			Integer order,
			Boolean isHidden,
			Boolean isFwdNavDisabled,
			Boolean isDefaultContext) {
			nFORCE__Route_Group__c routeGroup = new nFORCE__Route_Group__c(
				nFORCE__Group__c = prodGroup.Id,
				nFORCE__Route__c = route.Id,
				nFORCE__Order__c = order,
				nFORCE__Is_Hidden__c = isHidden,
				nFORCE__Is_Forward_Navigation_Disabled__c = isFwdNavDisabled,
				nFORCE__Is_Default_Context_Child__c = isDefaultContext);
			if(parent != null) {
				routeGroup.nFORCE__Parent_Route__c = parent.Id;
			}

			return routeGroup;
		}

		private nFORCE__Group__c retrieveGroupByAppName(String app) {
			List<nFORCE__Group__c> groups = [
				SELECT
					Id,
					Name,
					nFORCE__App__c,
					nFORCE__Lookupkey__c
				FROM
					nFORCE__Group__c
				WHERE
					nFORCE__App__c = :app
				LIMIT 1
			];
			if(groups.size() > 0) {
				return groups[0];
			}
			return null;
		}

		@TestVisible
		private nFORCE__Route_Group__c retrieveRouteGroup(String app, Id groupId) {
			List<nFORCE__Route_Group__c> rgs = [
				SELECT
					Id,
					Name,
					nFORCE__Route__c,
					nFORCE__Route__r.nFORCE__App__c,
					nFORCE__Parent_Route__c,
					nFORCE__Group__c,
					nFORCE__Is_Hidden__c,
					nFORCE__Order__c,
					nFORCE__Is_Forward_Navigation_Disabled__c,
					nFORCE__Is_Default_Context_Child__c,
					nFORCE__Lookupkey__c
				FROM
					nFORCE__Route_Group__c
				WHERE
				nFORCE__Group__c = :groupId
				AND
				nFORCE__Route__r.nFORCE__App__c = :app
			];

			if(rgs.size() > 0) {
				return rgs[0];
			}
			return null;
		}

		@TestVisible
		private Map<String, nFORCE__Route__c> getInstalledRoutes() {
			Map<String, nFORCE__Route__c> toReturn = new Map<String, nFORCE__Route__c>();
			List<nFORCE__Route__c> routes = [SELECT Id, nFORCE__App__c FROM nFORCE__Route__c];
			if(routes != null && routes.size() > 0) {
				for(nFORCE__Route__c route : routes) {
					toReturn.put(route.nFORCE__App__c, route);
				}
			}
			return toReturn;
		}

		private String getPageName(PageReference pgRef) {
			String pageName = pgRef.getUrl();
			pageName = pageName.replaceFirst('/apex/', '');
			pageName = EncodingUtil.urlEncode(pageName, 'UTF-8');
			string[] pageNameExtra = pageName.split('%3F', 0);
			pageName = pageNameExtra[0];
			if(pageNameExtra[0].contains('__') == false) {
				pageName = CSIDepActDocPrepConstants.NO_NAMESPACE + '__' + pageName;
			}
			return pageName;
		}
	}

	@TestVisible
	private class DataContainer extends nFORCE.ALifeCycleDataProvider {
	}

	@TestVisible
	private class XAppFacadeException extends Exception {
	}

	@TestVisible
	private virtual class DocManAttachmentHandler {

		public virtual void storeDocument(String transactionId, String templateName, Blob docContent) {
			nFUSE.DocManAttachment att = new nFUSE.DocManAttachment(transactionId, templateName);
			att.storeDocument(docContent);
		}

		public virtual void storeDocument(String transactionId, String templateName, String templateFileName, Blob docContent) {
			nFUSE.DocManAttachment att = new nFUSE.DocManAttachment(transactionId, templateName, templateFileName);
			att.storeDocument(docContent);
		}
	}

	@TestVisible
	private static nFUSE.PluginConfigurationManager.PluginConfiguration getPluginConfig(List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs, String key) {
		for(nFUSE.PluginConfigurationManager.PluginConfiguration config : configs) {
			if(config.key.equals(key)) {
				return config;
			}
		}
		return null;
	}

	@TestVisible private static final String
		PERIOD = '.',
		EMPTY_STRING = '',
		CLASS_NAME_STRING = 'CSIDepActDocPrep',
		PLUGIN_NAME = 'CSI_DepAct_DocPrep',
		PLUGIN_VERSION = '1.0',
		PLUGIN_CONFIG_NAME = 'CSI_DepAct_DocPrepConfiguration',
		PLUGIN_HELP_TEXT = 'CSI DepAct DocPrep Plugin Category for Property Configuration',
		X_MISSING_REQUIRED_PROPERTY = 'Missing CSI DepAct DocPrep configured property',
		DOCMAN_TEMPLATE_NAME = 'CSI_DepAct_DocPrep',
		DEP_PC_GROUP_APP = 'dep-pc',
		DEP_PM_GROUP_APP = 'dep-pm',
		COMPLETION_APP = 'doc-completion',
		COMPLETION_ROUTE_NAME = 'Review Documents',
		PC_DEP_DOCPREP_APP = 'pc-dep-docprep',
		PM_DEP_DOCPREP_APP = 'pm-dep-docprep',
		PC_DOCUMENTS_APP = 'pc-documents',
		PM_DOCUMENTS_APP = 'pm-documents-maint',
		DOCMAN_APP = 'dep-docprep-docs',
		PM_DOCMAN_APP = 'pm-dep-docprep-docs',
		DOCUMENT_ICON = 'n-icon-document',
		SPACE_WITH_DATETIME_NOW_FORMAT = ' (MM/dd/yyyy HH:mm)',
		LICENSE_KEY_ONE = 'License Key One',
		LICENSE_KEY_TWO = 'License Key Two',
		LICENSE_KEY_THREE = 'License Key Three',
		LICENSE_KEY_FOUR = 'License Key Four',
		LICENSE_KEY_FIVE = 'License Key Five',
		SYS_PRP_ESIGN_VENDOR = 'eSignature Vendor',
		SYS_PRP_DOC_LIBRARY_VERSION = 'Document Library Version',
		SYS_PRP_INTERFACE_CUSTOMIZATION = 'Interface Customization',
		COMPLIANCE_SERVICE_HOST_URI = 'Compliance Service Host Uri',
		SIMPLICITY_HOST_URI = 'Simplicity Host Uri',
		WORKFLOW_SERVICE_HOST_URI = 'WorkflowServices Host Uri',
		WORKFLOW_SERVICES_VERSION = 'Workflow Services Version';
	public static final String
		DEPOSIT_ENTITY_INVOLVEMENT_AFTER_INSERT_TRIGGERS_BEAN = 'deposit-entity-involvement-dp-bean',
		DEPOSIT_AUTHORIZED_SIGNER_AFTER_INSERT_TRIGGERS_BEAN = 'deposit-authorized-signer-dp-bean';

	@TestVisible private static final List<String> CSI_LICENSE_KEYS = new List<String> {
		LICENSE_KEY_ONE,
		LICENSE_KEY_TWO,
		LICENSE_KEY_THREE,
		LICENSE_KEY_FOUR,
		LICENSE_KEY_FIVE
	};
}
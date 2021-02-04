global with sharing class PrecisionLender {

	public static nFUSE.SendService getPluginSendService(nFUSE.PackageServiceRequest request) {
		nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();
		nFUSE.SendService service;

		try {
			service = (nFUSE.SendService) locator.locate(request, nFUSE.SendService.class);
		} catch (Exception e) {
			if (e.getMessage().startsWith(PL_SENDSERVICE_ERROR_MESSAGE)) {
				return null;
			} else {
				throw e;
			}
		}
		return service;
	}

	global with sharing class Activator implements nFUSE.IPluginActivator {

		private nFUSE.ServiceLocator locator = new nFUSE.ServiceLocator();

		public void onActivate() {
			configureSystemProperties();
			configurePluginProperties();
			registerTriggers();
			registerServices();
		}

		public void onDeactivate() {
			deregisterTriggers();
			deregisterServices();
		}

		private void registerTriggers() {
			nFORCE.BeanRegistry.getInstance().registerBean(
				PrecisionLenderTriggerHandler.BEAN_NAME,
				nFORCE.IPipelineComponent.class,
				PrecisionLenderTriggerHandler.class,
				new Map<String, Object>{},
				true
			);

			nFORCE.BeanRegistry.getInstance().registerBean(
				LOAN_RENEWAL_AFTER_INSERT_TRIGGERS_BEAN,
				nFORCE.IPipelineContainer.class,
				nFORCE.TriggerPipeline.class,
				new Map<String, Object>{
					nFORCE.PipelineContainer.PIPELINE_BEAN_UNIQUE_NAMES => new String[]{
						PrecisionLenderTriggerHandler.BEAN_NAME
					}
				},
				true
			);

			nFORCE.BeanRegistry.getInstance().registerBean(
				LOAN_AFTER_UPDATE_TRIGGERS_BEAN,
				nFORCE.IPipelineContainer.class,
				nFORCE.TriggerPipeline.class,
				new Map<String, Object>{
					nFORCE.PipelineContainer.PIPELINE_BEAN_UNIQUE_NAMES => new String[]{
						PrecisionLenderLoanTriggerHandler.BEAN_NAME
					}
				},
				true
			);

			nFORCE.BeanRegistry.getInstance().registerBean(
				TRANSACTION_LOG_AFTER_UPDATE_TRIGGERS_BEAN,
				nFORCE.IPipelineContainer.class,
				nFORCE.TriggerPipeline.class,
				new Map<String, Object>{
					nFORCE.PipelineContainer.PIPELINE_BEAN_UNIQUE_NAMES => new String[]{
						PrecisionLenderTransactionTriggerHandler.BEAN_NAME
					}
				},
				true
			);
		}

		private void deregisterTriggers() {
			nFORCE.BeanRegistry.getInstance().deregisterBean(PrecisionLenderTriggerHandler.BEAN_NAME, true);
			nFORCE.BeanRegistry.getInstance().deregisterBean(PrecisionLenderLoanTriggerHandler.BEAN_NAME, true);
			nFORCE.BeanRegistry.getInstance().deregisterBean(PrecisionLenderTransactionTriggerHandler.BEAN_NAME, true);
			nFORCE.BeanRegistry.getInstance().deregisterBean(LOAN_AFTER_UPDATE_TRIGGERS_BEAN, true);
			nFORCE.BeanRegistry.getInstance().deregisterBean(LOAN_RENEWAL_AFTER_INSERT_TRIGGERS_BEAN, true);
			nFORCE.BeanRegistry.getInstance().deregisterBean(TRANSACTION_LOG_AFTER_UPDATE_TRIGGERS_BEAN, true);
		}

		private void configureSystemProperties() {
			List<nFORCE__System_Properties__c> toInsert = new List<nFORCE__System_Properties__c>();
			Map<String, nFORCE__System_Properties__c> installedProperties = nFORCE__System_Properties__c.getAll();

			if(installedProperties == null || installedProperties.get(PLUGIN_NAME) == null) {
				toInsert.add(new nFORCE__System_Properties__c(
					Name = PLUGIN_NAME,
					nFORCE__Category_Name__c = PLUGIN_CONFIG_CATEGORY,
					nFORCE__Key__c = PLUGIN_CONFIG_NAME,
					nFORCE__Value__c = null,
					nFORCE__Is_Active__c = true
				));
			}

			if(installedProperties == null || installedProperties.get(PLUGIN_NAME + PLUGIN_VERSION) == null) {
				toInsert.add(new nFORCE__System_Properties__c(
					Name = PLUGIN_NAME + PLUGIN_VERSION,
					nFORCE__Category_Name__c = PLUGIN_CONFIG_CATEGORY,
					nFORCE__Key__c = PLUGIN_CONFIG_VERSION,
					nFORCE__Is_Active__c = true
				));
			}
			nFORCE.DmlUtility.insertObj(toInsert);
		}

		private void registerServices() {
			nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(PLUGIN_NAME, PLUGIN_VERSION, null);
			locator.register(request, nFUSE.SendService.class, PrecisionLender.PLSendService.class);
			locator.register(request, nFUSE.LoanService.class, PrecisionLender.PLLoanService.class);
			locator.register(request, nFUSE.ProductPackageService.class, PrecisionLender.PLProductPackageService.class);
			updateProperty(PLUGIN_CONFIG_NAME, PLUGIN_NAME);
			updateProperty(PLUGIN_CONFIG_VERSION, PLUGIN_VERSION);
		}

		private void deregisterServices() {
			nFUSE.PackageServiceRequest request = new nFUSE.PackageServiceRequest(PLUGIN_NAME, PLUGIN_VERSION, null);
			locator.deregister(request, nFUSE.SendService.class);
			updateProperty(PLUGIN_CONFIG_NAME, null);
			updateProperty(PLUGIN_CONFIG_VERSION, null);
		}

		private void configurePluginProperties() {
			nFUSE.PluginConfigurationManager.PluginConfiguration configUsername = new nFUSE.PluginConfigurationManager.PluginConfiguration();
			configUsername.pluginName = PLUGIN_NAME;
			configUsername.pluginVersion = PLUGIN_VERSION;
			configUsername.category = PLUGIN_NAME;
			configUsername.key = CONFIG_PROP_KEY_USERNAME;
			configUsername.valueDataType = STRING_CONST;
			configUsername.isEncrypted = true;

			nFUSE.PluginConfigurationManager.PluginConfiguration configKey = new nFUSE.PluginConfigurationManager.PluginConfiguration();
			configKey.pluginName = PLUGIN_NAME;
			configKey.pluginVersion = PLUGIN_VERSION;
			configKey.category = PLUGIN_NAME;
			configKey.key = CONFIG_PROP_KEY_CLIENT_API_KEY;
			configKey.valueDataType = STRING_CONST;
			configKey.isEncrypted = true;

			nFUSE.PluginConfigurationManager.PluginConfiguration configClientId = new nFUSE.PluginConfigurationManager.PluginConfiguration();
			configClientId.pluginName = PLUGIN_NAME;
			configClientId.pluginVersion = PLUGIN_VERSION;
			configClientId.category = PLUGIN_NAME;
			configClientId.key = CONFIG_PROP_KEY_CLIENT_ID;
			configClientId.valueDataType = STRING_CONST;
			configClientId.isEncrypted = true;

			nFUSE.PluginConfigurationManager.PluginConfiguration configURL = new nFUSE.PluginConfigurationManager.PluginConfiguration();
			configURL.pluginName = PLUGIN_NAME;
			configURL.pluginVersion = PLUGIN_VERSION;
			configURL.category = PLUGIN_NAME;
			configURL.key = CONFIG_PROP_KEY_URL;
			configURL.valueDataType = STRING_CONST;
			configURL.isEncrypted = false;

			nFUSE.PluginConfigurationManager.PluginConfiguration configHostEnvironment = new nFUSE.PluginConfigurationManager.PluginConfiguration();
			configHostEnvironment.pluginName = PLUGIN_NAME;
			configHostEnvironment.pluginVersion = PLUGIN_VERSION;
			configHostEnvironment.category = PLUGIN_NAME;
			configHostEnvironment.key = CONFIG_PROP_KEY_HOST_ENVIRONMENT;
			configHostEnvironment.valueDataType = STRING_CONST;
			configHostEnvironment.isEncrypted = false;

			nFUSE.PluginConfigurationManager.PluginConfiguration serviceUserName = new nFUSE.PluginConfigurationManager.PluginConfiguration();
			serviceUserName.pluginName = PLUGIN_NAME;
			serviceUserName.pluginVersion = PLUGIN_VERSION;
			serviceUserName.category = PLUGIN_NAME;
			serviceUserName.key = CONFIG_PROP_KEY_CLIENT_SERVICE_USERNAME;
			serviceUserName.valueDataType = STRING_CONST;
			serviceUserName.isEncrypted = false;

			List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs =
				new List<nFUSE.PluginConfigurationManager.PluginConfiguration>{
					configUsername,
					configKey,
					configClientId,
					configURL,
					configHostEnvironment,
					serviceUserName
				};

			new nFUSE.PluginConfigurationManager(PLUGIN_NAME, PLUGIN_VERSION).softInsertConfigurations(configs);
		}

		private void updateProperty(String key, String value) {
			nFORCE__System_Properties__c prop = [
				SELECT
					Id
				FROM
					nFORCE__System_Properties__c
				WHERE
					nFORCE__Category_Name__c = :PLUGIN_CONFIG_CATEGORY
				AND
					nFORCE__Key__c = :key
				AND
					nFORCE__Is_Active__c = true
				LIMIT 1
			];

			prop.nFORCE__Value__c = value;

			nFORCE.DmlUtility.updateObj(prop);
		}
	}

	global class PLSendService extends nFUSE.SendService {
		public protected override nFUSE.AMiddlewareMessage preSendSeam(nFUSE.AMiddlewareMessage message) {

			nFUSE.AMiddlewareMessage m = super.preSendSeam(message);

			List<nFUSE.PluginConfigurationManager.PluginConfiguration> properties = new nFUSE.PluginConfigurationManager(PLUGIN_NAME, PLUGIN_VERSION).getConfigurations();

			for (nFUSE.PluginConfigurationManager.PluginConfiguration config : properties) {
				if (config.key == CONFIG_PROP_KEY_USERNAME) {
					m.properties.put(KEY_USERNAME, config.value);
				} else if (config.key == CONFIG_PROP_KEY_CLIENT_ID) {
					m.properties.put(KEY_CLIENT_ID, config.value);
				} else if (config.key == CONFIG_PROP_KEY_CLIENT_API_KEY) {
					m.properties.put(KEY_CLIENT_API_KEY, config.value);
				} else if (config.key == CONFIG_PROP_KEY_URL) {
					m.properties.put(KEY_URL, config.value);
				} else if (config.key == CONFIG_PROP_KEY_HOST_ENVIRONMENT) {
					m.properties.put(KEY_HOST_ENVIRONMENT, config.value);
				} else if (config.key == CONFIG_PROP_KEY_CLIENT_SERVICE_USERNAME) {
					m.properties.put(KEY_CLIENT_SERVICE_USERNAME, config.value);
				}
			}

			return m;
		}
	}

	global class PLLoanService extends nFUSE.LoanService {

		public override List<LLC_BI__Loan__c> beforeInsertLoanSeam(List<LLC_BI__Loan__c> loans) {
			processLoanChanges(loans);
			return loans;
		}

		private List<LLC_BI__Loan__c> processLoanChanges(List<LLC_BI__Loan__c> loans) {
			Set<Id> loanIds = new Set<Id>();
			if (loans.size() > 0) {
				for (LLC_BI__Loan__c loan : loans) {
					loanIds.add(loan.Id);
				}
			}

			Map<Id, LLC_BI__Loan__c> mappedLoans = mapLoans(loanIds);

			for (LLC_BI__Loan__c loan : loans) {
				loan.name = mappedLoans.get(loan.Id).LLC_BI__Account__r.Name + ' ' +
					mappedLoans.get(loan.Id).LLC_BI__Product_Type__c + ' ' +
					mappedLoans.get(loan.Id).LLC_BI__Product__c;
			}

			return loans;
		}

		private Map<Id, LLC_BI__Loan__c> mapLoans(Set<Id> ids) {
			Map<Id, LLC_BI__Loan__c> mappedLoans = new Map<Id, LLC_BI__Loan__c>([
				SELECT
					LLC_BI__Account__c,
					LLC_BI__Product_Type__c,
					LLC_BI__Product__c,
					LLC_BI__Account__r.Name
				FROM
					LLC_BI__Loan__c
				WHERE
					Id = :ids
			]);

			return mappedLoans;
		}

	}

	global class PLProductPackageService extends nFUSE.ProductPackageService {
		public override List<LLC_BI__Product_Package__c> beforeInsertProductPackageSeam(List<LLC_BI__Product_Package__c> productPackages) {
			for (LLC_BI__Product_Package__c productPackage: productPackages) {
				productPackage.name = productPackage.name + ' ' + PRODUCT_PACKAGE_CONST;
			}

			return productPackages;
		}
	}

	public static final String
		PLUGIN_NAME = 'PrecisionLender_Pricing',
		PLUGIN_VERSION = '1.0',
		PLUGIN_CONFIG_NAME = 'PrecisionLender Pricing',
		PLUGIN_CONFIG_VERSION = 'PrecisionLender Pricing Version',
		PLUGIN_CONFIG_CATEGORY = 'PrecisionLender Pricing',
		PLUGIN_HELP_TEXT = 'PrecisionLender Pricing Tool',

		CONFIG_PROP_KEY_USERNAME = 'Client User Name',
		CONFIG_PROP_KEY_CLIENT_ID = 'Client ID',
		CONFIG_PROP_KEY_CLIENT_API_KEY = 'Client API Key',
		CONFIG_PROP_KEY_URL = 'Client Service URL',
		CONFIG_PROP_KEY_HOST_ENVIRONMENT = 'Client Host Environment',
		CONFIG_PROP_KEY_CLIENT_SERVICE_USERNAME = 'Client Service User Name',

		KEY_USERNAME = 'ClientUserName',
		KEY_CLIENT_ID = 'ClientId',
		KEY_CLIENT_API_KEY = 'ClientAPIKey',
		KEY_HOST_ENVIRONMENT = 'ClientHostEnvironment',
		KEY_URL = 'ClientServiceURL',
		KEY_CLIENT_SERVICE_USERNAME = 'ClientServiceUserName',
		KEY_UPDATED_LOANS = 'UpdatedLoans',

		STRING_CONST = 'String',
		SCENARIO_CONST = 'Scenario',
		RELATIONSHIPS_CONST = 'relationships',
		PRODUCT_PACKAGE_CONST = 'Product Package',

		PL_SENDSERVICE_ERROR_MESSAGE = 'Unable to locate',

		ACTION_PRICING = 'Pricing',
		ACTION_REPRICING = 'Repricing',
		ACTION_STAGE_STATUS_UPDATE = 'UpdateStageStatus',
		ACTION_REN_MOD_LOANS = 'RenewModifyLoans',

		REQUEST_PARAM = 'request',
		RELATIONSHIPS_PARAM = 'relationship_ids',

		LOAN_AFTER_UPDATE_TRIGGERS_BEAN = 'loan-pl-bean',
		TRANSACTION_LOG_AFTER_UPDATE_TRIGGERS_BEAN = 'transaction-log-pl-bean',
		LOAN_RENEWAL_AFTER_INSERT_TRIGGERS_BEAN = 'loan-renewal-pl-bean',


		EXT_APP_ID = 'externalApplicationId',
		NEW_LOAN_ID = 'newLoanId',
		EXT_APP_NAME = 'extAppName',

		PROP_EXT_LOAN_ID = 'ExternalCoreLoanId',
		PROD_EXT_REL_ID = 'ExternalRelationshipId',
		PROP_RENEWAL_ID = 'RenewalLoanId',
		PROP_REN_MOD_LOANS = 'RenewalLoanInformation',
		PROP_PL_ID = 'precisionLenderId',
		PROP_STAGE = 'newStage',
		PROP_STATUS = 'newStatus',

		LOAN_SUFFIX = 'Loan',
		OPP_SUFFIX = 'Opp',

		EXT_OPP_KEY = 'PrecisionLenderOpportunityId',
		EXT_LOAN_KEY = 'PrecisionLenderLoanId';
}
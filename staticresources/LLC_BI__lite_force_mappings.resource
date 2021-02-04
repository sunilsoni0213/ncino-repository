(function loadLiteforceMappings() {
	/* local LifeCycle mappings */
	var spreadsTypeMappings = {
		Account: 'c.LifeCycleRelationship',
		LLC_BI__Account_Covenant__c: 'c.LifeCycleAccountCovenant',
		LLC_BI__Loan__c: 'c.LifeCycleLoan',
		LLC_BI__Loan_Covenant__c: 'c.LifeCycleLoanCovenant',
		LLC_BI__Covenant2__c: 'c.CovenantMgmt',
		LLC_BI__Covenant_Compliance2__c: 'c.LifeCycleCovenantCompliance2',
		LLC_BI__Covenant_Type__c: 'c.LifeCycleCovenantType',
		LLC_BI__Covenant_Rule__c: 'c.LifeCycleCovenantRule'


	};
	for (var sObjectType in spreadsTypeMappings) {
		if (spreadsTypeMappings.hasOwnProperty(sObjectType)) {
			LifeCycle.IForceData.LiteForceUtils.sObjectTypeMapping[sObjectType] = spreadsTypeMappings[sObjectType];
		}
	}

	/* Map From Db */
	var spreadsFieldTranslations = {

		CovenantMgmt: {
			effectiveDate: function(sObject) {
				var dateValue = sObject.get('Effective_Date__c');
				if (isNaN(Number(dateValue))) {
					return dateValue;
				} else {
					var parsedDate = new Date(dateValue);
					var jsDate = new Date(parsedDate.getTime() + (parsedDate.getTimezoneOffset() * 60 * 1000) );
					return window.LifeCycle.Internationalize.format(jsDate, 'd');
				}
			},
			nextEvalDate: function(sObject) {
				var dateValue = sObject.get('Next_Evaluation_Date__c');
				if (isNaN(Number(dateValue))) {
					return dateValue;
				} else {
					var parsedDate = new Date(dateValue);
					var jsDate = new Date(parsedDate.getTime() + (parsedDate.getTimezoneOffset() * 60 * 1000) );
					return window.LifeCycle.Internationalize.format(jsDate, 'd');
				}
			},
			_renameProperties: [
				{ sObject: 'Active__c', js: 'isActive' },
				{ sObject: 'Next_Evaluation_Date__c', js: 'nextEvalDate' },
				{ sObject: 'Effective_Date__c', js: 'effectiveDate' }
			],
			_deleteSObjectFields: [
				"Category__c",
				"Id__c",
				"Saved__c",
				"Frequency_Label__c",
				"Is_Financial_Indicator__c"
			],
			_keepJSProperties: [
				'complianceDaysPrior',
				'covenantType',
				'frequency',
				'id',
				'isActive',
				'nextEvalDate',
				'relatedCovenant',
				'linkedSpreadStatementRecord',
				'linkedSpreadStatementRecordTotal',
				'effectiveDate'
			],
			_targetToSourceRelationships: [
				{
					targetToSourcePropertyName: 'accountCovenants',
					sourceType: 'LLC_BI__Account_Covenant__c',
					sourceToTargetFieldName: 'LLC_BI__Covenant2__c',
					isOneToOne: false
				},
				{
					targetToSourcePropertyName: 'relatedCovenants',
					sourceType: 'LLC_BI__Covenant2__c',
					sourceToTargetFieldName: 'LLC_BI__Related_Covenant__c',
					isOneToOne: false
				},
				{
					targetToSourcePropertyName: 'covenantCompliances',
					sourceType: 'LLC_BI__Covenant_Compliance2__c',
					sourceToTargetFieldName: 'LLC_BI__Covenant__c',
					isOneToOne: false
				},
				// {
				//   "targetToSourcePropertyName": "",
				//   "sourceType": "LLC_BI__Covenant_Product__c",
				//   "sourceToTargetFieldName": "LLC_BI__Covenant2__c",
				//   "isOneToOne": false
				// },
				{
					targetToSourcePropertyName: 'covenantRules',
					sourceType: 'LLC_BI__Covenant_Rule__c',
					sourceToTargetFieldName: 'LLC_BI__Covenant__c',
					isOneToOne: false
				},
				{
					targetToSourcePropertyName: 'loanCovenants',
					sourceType: 'LLC_BI__Loan_Covenant__c',
					sourceToTargetFieldName: 'LLC_BI__Covenant2__c',
					isOneToOne: false
				},
				{
					targetToSourcePropertyName: 'policyExceptions',
					sourceType: 'LLC_BI__Policy_Exception__c',
					sourceToTargetFieldName: 'LLC_BI__Covenant_Mgmt__c',
					isOneToOne: false
				}
				// {
				//   "targetToSourcePropertyName": "",
				//   "sourceType": "LLC_BI__Pricing_Covenant__c",
				//   "sourceToTargetFieldName": "LLC_BI__Covenant2__c",
				//   "isOneToOne": false
				// }
			]
		},
		LifeCycleAccountCovenant: {
			accountId: function (sObject) {
				return sObject.get('Account__c');
			},
			covenantId: function (sObject) {
				return sObject.get('Covenant2__c');
			},
			_renameProperties: [
				{sObject: 'Covenant2__c', js: 'covenant'}
			],
			_keepJSProperties: [
				"account",
				"covenant"
			]
		},
		LifeCycleCovenantCompliance2: {
			associatedStatementPeriodId: function (sObject) {
				return sObject.get('Associated_Spread_Statement_Period__c');
			},
			Associated_Spread_Statement_Period__c: function (jsLiteForce) {
				return jsLiteForce.period.recordId;
			},
			_renameProperties: [
				{sObject: 'Associated_Spread_Statement_Period__c', js: 'period'}
			],
			_deleteJSProperties: ['associatedStatementPeriod']
		},
		LifeCycleCovenantType: {
			_keepJSProperties: [
				"category"
			]
		},
		LifeCycleLoan: {
			_renameProperties: [
				{sObject: 'Amortized_Term_Months__c', js: 'amortization'},
				{sObject: 'Account__c', js: 'primaryAccount'},
				{sObject: 'Account__c', js: 'relationship'},
				{sObject: 'Product__c', js: '(delete)'},
				{sObject: 'Product_Reference__c', js: 'product'}
			],
			_keepJSProperties: [
				"amount",
				"interestRate",
				"product",
				"relationship"
			]
		},
		LifeCycleLoanCovenant: {
			loanId: function (sObject) {
				return sObject.get('Loan__c');
			},
			covenantId: function (sObject) {
				return sObject.get('Covenant2__c');
			},
			_renameProperties: [
				{sObject: 'Covenant2__c', js: 'covenant'}
			],
			_deleteJSProperties: ['covenant2']
		},
		LifeCycleCovenantRule: {
			Financial_Indicator_Value__c: function (jsLiteForce) {
				return +jsLiteForce.financialIndicatorValue;
			},
			_keepJSProperties: [
				'covenant',
				'endDate',
				'operator',
				'financialIndicatorValue'
			],
			_deleteSObjectFields: [
				"Saved__c"
			]
		},
		LifeCycleRelationship: {
			isIndividual: function (sObject) {
				return !!sObject.get('Is_Individual__c');
			},
			countryOptions: function () {
				return [];
			},
			entityTypeOptions: function () {
				return [];
			},
			stateOptions: function () {
				return [];
			},
			_renameProperties: [
				{sObject: 'LLC_BI__Naics_Code__c', js: 'naicsCode'},
				{sObject: 'LLC_BI__Type__c', js: 'entityType'},
				{sObject: 'LLC_BI__Parent_Id__c', js: 'parentRelationship'}
			],
			_keepJSProperties: [
				"countryOptions",
				"entityType",
				"entityTypeOptions",
				"fiscalYearEnd",
				"isIndividual",
				"stateOptions",
				"naicsCode"
			]
		},

	};

	for (var apexType in spreadsFieldTranslations) {
		if (spreadsFieldTranslations.hasOwnProperty(apexType)) {
			LifeCycle.IForceData.LiteForceUtils.sObjectFieldTranslations[apexType] = spreadsFieldTranslations[apexType];
		}
	}
})();
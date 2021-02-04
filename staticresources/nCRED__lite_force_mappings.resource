/* local LifeCycle mappings */
var spreadsTypeMappings = {
	Account: 'c.LifeCycleRelationship',
	Account_Covenant__c: 'c.LifeCycleAccountCovenant',
	Annual_Review__c: 'LLC_BI.LifeCycleRiskRatingReview',
	Loan__c: 'c.LifeCycleLoan',
	Loan_Covenant__c: 'c.LifeCycleLoanCovenant',
	Legal_Entities__c: 'c.ALifeCycleInvolvement',
	Classification__c: 'c.Classification',
	Collateral__c: 'c.LifeCycleCollateral',
	Contact: 'c.LifeCycleContact',
	Contingent_Liabilty__c: 'c.LifeCycleSigner',
	Covenant2__c: 'c.CovenantMgmt',
	Covenant_Compliance2__c: 'c.LifeCycleCovenantCompliance2',
	Covenant_Type__c: 'c.LifeCycleCovenantType',
	Credit_Memo__c: 'LLC_BI.LifeCycleCreditMemo',
	Product__c: 'LLC_BI.LifeCycleProduct',
	Product_Package__c: 'LLC_BI.LifeCycleProductPackage',
	Risk_Grade_Template__c: 'LLC_BI.LifeCycleRiskGradeTemplate',
	Screen__c: 'LLC_BI.LifeCycleScreen',
	Screen_Section__c: 'nFORCE.LifeCycleScreenSection',
	Spread__c: 'c.LifeCycleSpread',
	Spread_Record_Classification__c: 'c.SpreadRecordClassification',
	Spread_Record_Total_Classification__c: 'c.SpreadRecordTotalClassification',
	Spread_Statement_Period_Total__c: 'c.LifeCycleSpreadStatementPeriodTotal',
	Spread_Statement_Period__c: 'c.LifeCycleSpreadStatementPeriod',
	Spread_Statement_Record_Total__c: 'c.LifeCycleSpreadStatementRecordTotal',
	Spread_Statement_Record_Value__c: 'c.LifeCycleSpreadStatementRecordValue',
	Spread_Statement_Record__c: 'c.LifeCycleSpreadStatementRecord',
	Spread_Statement_Type__c: 'c.LifeCycleSpreadStatement',
	Spread_Statement_View__c: 'c.LifeCycleSpreadStatementView',
	Underwriting_Bundle__c: 'c.LifeCycleUnderwritingBundle',
	Underwriting_Summary__c: 'c.LifeCycleUnderwriting',
	User: 'c.LifeCycleUser',
	Widget__c: 'nFORCE.LifeCycleWidget'
};
for (var sObjectType in spreadsTypeMappings) {
	if (spreadsTypeMappings.hasOwnProperty(sObjectType)) {
		LifeCycle.IForceData.LiteForceUtils.sObjectTypeMapping[sObjectType] = spreadsTypeMappings[sObjectType];
	}
}

/* Map From Db */
var spreadsFieldTranslations = {
	ALifeCycleInvolvement: {
		borrowerTypeOptions: function () { return []; },
		contingentTypeOptions: function () { return []; },
		_renameProperties: [
			{ sObject: 'Ownership__c', js: 'contingentPercentage' },
			{ sObject: 'Account__c', js: 'relationship' },
			{ sObject: 'Type__c', js: 'entityType' }
		],
		_keepJSProperties: [
			"borrowerType",
			"borrowerTypeOptions",
			"contingentPercentage",
			"contingentType",
			"contingentTypeOptions",
			"isIncludedInGlobalAnalysis",
			"loan",
			"monthlyDebtService",
			"relationship"
		]
	},
	Classification: {
		_keepJSProperties: [
			"category",
			"name"
		]
	},
	CovenantMgmt: {
		covenantRules: function () { return []; },
		relatedCovenants: function () { return []; },
		_renameProperties: [
			{ sObject: 'Active__c', js: 'isActive' },
			{ sObject: 'Next_Evaluation_Date__c', js: 'nextEvalDate' }
		],
		_keepJSProperties: [
			"complianceDaysPrior",
			"covenantRules",
			"covenantType",
			"frequency",
			"id",
			"isActive",
			"nextEvalDate",
			"relatedCovenants",
			"linkedSpreadStatementRecord",
			"effectiveDate"
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
			{ sObject: 'Covenant2__c', js: 'covenant' }
		],
		_keepJSProperties: [
			"account",
			"covenant"
		]
	},
	LifeCycleCollateralType: {
		_renameProperties: [
			{ sObject: 'Regulatory_Rate__c', js: 'regulatoryDate' }
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
			{ sObject: 'Associated_Spread_Statement_Period__c', js: 'period' }
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
			{ sObject: 'Amortized_Term_Months__c', js: 'amortization' },
			{ sObject: 'Account__c', js: 'primaryAccount' },
			{ sObject: 'Account__c', js: 'relationship' },
			{ sObject: 'Product__c', js: '(delete)' },
			{ sObject: 'Product_Reference__c', js: 'product' }
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
			{ sObject: 'Covenant2__c', js: 'covenant' }
		],
		_deleteJSProperties: ['covenant2']
	},
	LifeCycleRelationship: {
		isIndividual: function (sObject) { return !!sObject.get('Is_Individual__c'); },
		countryOptions: function () { return []; },
		entityTypeOptions: function () { return []; },
		stateOptions: function () { return []; },
		_renameProperties: [
			{ sObject: 'Type__c', js: 'entityType' },
			{ sObject: 'Parent_Id__c', js: 'parentRelationship' }
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
	LifeCycleSigner: {
		_renameProperties: [
			{ sObject: 'Role__c', js: 'capacity' },
			{ sObject: 'Contingent_Percentage__c', js: 'ownershipPercentage' },
			{ sObject: 'Entity__c', js: 'involvement' }
		],
		_deleteJSProperties: ['contingentPercentage', 'entity', 'role']
	},
	LifeCycleSpread: {
		_renameProperties: [
			{ sObject: 'Entity_Involvement__c', js: 'involvement' },
			{ sObject: 'Spread_Statement_Template__c', js: 'statement' },
			{ sObject: 'Spread_Identifier__c', js: 'identifier' },
			{ sObject: 'Include_In_Ratios__c', js: 'includeInGlobalAnalysis' },
			{ sObject: 'Underwriting_Summary__c', js: 'underwriting' },
		],
		collateralMgmt: function (sObject) {
			return sObject.get('Collateral__c');
		},
		_keepJSProperties: [
			'collateralMgmt',
			"identifier",
			"includeInGlobalAnalysis",
			"involvement",
			"loan",
			"statement",
			"underwriting"
		]
	},
	LifeCycleSpreadStatement: {
		analystOptions: function () { return []; },
		calcCommonSizingDivisorId: function (sObject) {
			return (
				sObject.get('Calc_Common_Sizing_Total_Group__c') ||
				sObject.get('Calc_Common_Sizing_Record__c') ||
				''
			);
		},
		Calc_Common_Sizing_Record__c: function (liteForce) {
			if (LifeCycle.SpreadData.lookupRecordById(liteForce.calcCommonSizingDivisorId)) {
				return liteForce.calcCommonSizingDivisorId;
			}
		},
		Calc_Common_Sizing_Total_Group__c: function (liteForce) {
			if (LifeCycle.SpreadData.lookupRecordTotalById(liteForce.calcCommonSizingDivisorId)) {
				return liteForce.calcCommonSizingDivisorId;
			}
		},
		isBalanceSheet: function (sObject) { return !!sObject.get('Is_Balance_Sheet__c'); },
		isIncomeStatement: function (sObject) { return !!sObject.get('Is_Income_Statement__c'); },
		_renameProperties: [
			{ sObject: 'Type__c', js: 'statementType' },
			{ sObject: 'Static_Periods__c', js: 'isStaticPeriods' }
		],
		_keepJSProperties: [
			"analystOptions",
			"bundle",
			"displayCommonSizing",
			"displayTrend",
			"isBalanceSheet",
			"isIncomeStatement",
			"isStaticPeriods",
			"isTemplate",
			"sortOrder",
			"statementType",
			"supportsCommonSizing",
			"supportsTrend",
			"totalRowName",
			"calcCommonSizingDivisorId"
		]
	},
	LifeCycleSpreadStatementPeriod: {
		statementId: function (sObject) {
			return sObject.get('Spread_Statement_Type__c');
		},
		quarter: function () { return 1; },
		_renameProperties: [
			{ sObject: 'Spread_Statement_Type__c', js: 'statement' },
			{ sObject: 'Accumulate__c', js: 'accumulates' },
			{ sObject: 'externalLookupKey__c', js: 'lookupKey' },
			{ sObject: 'Type__c', js: 'periodType' }
		],
		_keepJSProperties: [
			"accumulates",
			"analyst",
			"columnNumber",
			"isFiscalYear",
			"isGlobalAnalysisYear",
			"month",
			"numberOfPeriods",
			"periodKey",
			"quarter",
			"selected",
			"selectedInGlobal",
			"source",
			"statement",
			"statementDate",
			"statementId",
			"year",
			"nameOverride",
			"periodType",
			"fiscalYearTTMPeriod",
			"initialInterimTTMPeriod",
			"trailingInterimTTMPeriod"
		]
	},
	LifeCycleSpreadStatementPeriodTotal: {
		_renameProperties: [
			{ sObject: 'Spread_Statement_Period__c', js: 'period' },
			{ sObject: 'Spread_Statement_Record_Total__c', js: 'recordTotal' }
		],
		_keepJSProperties: [
			"period",
			"recordTotal",
			"value"
		]
	},
	LifeCycleSpreadStatementRecord: {
		kpiType: function (sObject) { return (sObject.get('KPI_Type__c') || ''); },
		linkedRecord: function (sObject, utils) {
			var totalId = sObject.get('Linked_Spread_Statement_Total_Group__c');
			var recordId = sObject.get('Linked_Spread_Statement_Record__c');
			
			if (recordId) {
				return utils.generateLiteForceRelationshipPointer(recordId, 'LifeCycleSpreadStatementRecord');
			} else if (totalId) {
				return utils.generateLiteForceRelationshipPointer(totalId, 'LifeCycleSpreadStatementRecordTotal');
			}
		},
		_renameProperties: [
			{ sObject: 'KPI_Type__c', js: 'kpiType' },
			{ sObject: 'Debit__c', js: 'isDebit' },
			{ sObject: 'Spread_Statement_Type__c', js: 'statement' },
			{ sObject: 'Spread_Statement_Record_Total__c', js: 'recordTotal' }
		],
		_keepJSProperties: [
			"displayType",
			"operation",
			"periodOverPeriodChange",
			"priorFiscalYear",
			"recordTotal",
			"recordType",
			"includeInTotal",
			"isDebit",
			"isLinked",
			"kpiType",
			"records",
			"rowNumber",
			"statement",
			"linkedRecord"
		],
		_deleteSObjectFields: [
			'Global_Analysis_Type__c'
		]
	},
	LifeCycleSpreadStatementRecordValue: {
		_renameProperties: [
			{ sObject: 'Spread_Statement_Record__c', js: 'record' },
			{ sObject: 'Spread_Statement_Period__c', js: 'period' }
		],
		_keepJSProperties: [
			"formula",
			"isLinked",
			"period",
			"record",
			"value"
		]
	},
	LifeCycleSpreadStatementTotal: {
		kpiType: function (sObject) { return (sObject.get('KPI_Type__c') || ''); },
		_renameProperties: [
			{ sObject: 'KPI_Type__c', js: 'kpiType' },
			{ sObject: 'Debit__c', js: 'isDebit' },
			{ sObject: 'Spread_Statement_Type__c', js: 'statement' },
			{ sObject: 'Hide_All_Records__c', js: 'isHideAllRecords' },
			{ sObject: 'Hide_Currency_Symbol__c', js: 'isHideCurrencySymbol' }
		],
		_keepJSProperties: [
			"hideColumnTotals",
			"globalAnalysisType",
			"groupType",
			"includeInTotal",
			"isDebit",
			"isHideAllRecords",
			"isHideCurrencySymbol",
			"isSummaryGroup",
			"kpiType",
			"rowNumber",
			"statement",
			"title",
			"totalType"
		]
	},
	LifeCycleSpreadStatementView: {
		_renameProperties: [
			{sObject: 'Spread_Statement_Type__c', js: 'statement'},
			{sObject: 'Filter_JSON__c', js: 'viewFilter'}
		],
		_keepJSProperties: [
			'statement',
			'viewFilter'
		],
		_deleteSObjectFields: [
			'Bundle__c'
		]
	},
	LifeCycleUnderwritingBundle: {
		_renameProperties: [
			{ sObject: 'Selected_Scale__c', js: 'scale' },
			{ sObject: 'Relationship__c', js: 'container' }
		],
		_keepJSProperties: [
			"container",
			"isTemplate",
			"scale",
			"showFootnotes"
		]
	},
	LifeCycleUser: {
		_keepJSProperties: [
			"email",
			"firstName",
			"lastName",
			"username"
		]
	},
	SpreadRecordClassification: {
		_renameProperties: [
			{ sObject: 'Spread_Statement_Record__c', js: 'record' }
		],
		_keepJSProperties: [
			'classification',
			'record'
		]
	},
	SpreadRecordTotalClassification: {
		_renameProperties: [
			{ sObject: 'Spread_Statement_Total_Group__c', js: 'recordTotal' }
		],
		_keepJSProperties: [
			'classification',
			'recordTotal'
		]
	}
};
spreadsFieldTranslations.LifeCycleBorrower = spreadsFieldTranslations.ALifeCycleInvolvement;
spreadsFieldTranslations.LifeCycleGuarantor = spreadsFieldTranslations.ALifeCycleInvolvement;
spreadsFieldTranslations.LifeCycleCustomTypeEntity = spreadsFieldTranslations.ALifeCycleInvolvement;
spreadsFieldTranslations.LifeCycleSpreadStatementTemplate = spreadsFieldTranslations.LifeCycleSpreadStatement;
spreadsFieldTranslations.LifeCycleSpreadStatementRecordTotal = spreadsFieldTranslations.LifeCycleSpreadStatementTotal;

for (var apexType in spreadsFieldTranslations) {
	if (spreadsFieldTranslations.hasOwnProperty(apexType)) {
		LifeCycle.IForceData.LiteForceUtils.sObjectFieldTranslations[apexType] = spreadsFieldTranslations[apexType];
	}
}

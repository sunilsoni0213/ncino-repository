(function(){
	var Models = function(event, app){
		var defaultModelData = {
			recordId : null,
			name : '',
			isLoaded : false,
			isSaved : false,
			disabled: false
		};
		
		/**
		 * @typedef {app.Spread} KOSpread
		 * @implements IForceKO
		 * @type Object
		 *
		 * @property {function(): string} apexType
		 * @property {function(): string} identifier
		 * @property {function(): boolean} includeInGlobalAnalysis
		 * @property {function(): KOCollateral} collateralMgmt
		 * @property {KOBorrower} involvement
		 * @property {KOLoan} loan
		 * @property {KOStatement} statement
		 * @property {KOUnderwritingSummary} underwriting
		 * @property {function(): string} recordId
		 * @property {function(): string} name
		 * @property {function(): boolean} isLoaded
		 * @property {function(): boolean} isSaved
		 * @property {function(): boolean} disabled
		 * @property {function(): boolean} __shallow
		 * @property {function(): string} freeTextSearchField
		 * @property {function(): boolean} isLLCBI
		 * @property {function(): boolean} isRelationshipPointer
		 * @property {function(): boolean} saved
		 * @property {Object} __ko_mapping__
		 * @property {Object} __changeTracking
		 * @property {boolean} __cached
		 * @property {function} __retrieve
		 *
		 * @returns {KOSpread}
		 * @constructor
		 */
		app.Spread = function(data, shallow){
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('spread'),
				identifier: '',
				includeInGlobalAnalysis: true,
				involvement: {},
				loan: {},
				statement: {},
				underwriting: {}
			}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, app.getMapping(), self);
			}
			
			return self;
		};
		
		/**
		 * @typedef {app.SpreadStatement} KOStatement
		 * @implements IForceKO
		 * @type Object
		 *
		 * @property {function(): string} apexType
		 * @property {function(): string} statementType
		 * @property {function(): Array<Object>} analystOptions
		 * @property {function(): boolean} displayTrend
		 * @property {function(): boolean} displayCommonSizing
		 * @property {function(): string} calcCommonSizingDivisorId
		 * @property {KOUnderwritingBundle} bundle
		 * @property {function(): Array<KOSpread>} spreads
		 * @property {function(): Array<KOPeriod>} periods
		 * @property {function(): Array<KORecordTotal>} recordTotals
		 * @property {function(): boolean} isTemplate
		 * @property {function(): number} sortOrder
		 * @property {function(): string} recordId
		 * @property {function(): string} name
		 * @property {function(): boolean} isLoaded
		 * @property {function(): boolean} isSaved
		 * @property {function(): boolean} disabled
		 * @property {function(): boolean} __shallow
		 * @property {boolean} __placeholder
		 * @property {function} save
		 * @property {function(): boolean} isFilled
		 * @property {function(): boolean} saveEnabled
		 * @property {Object} __ko_mapping__
		 * @property {Object} __changeTracking
		 * @property {boolean} __cached
		 * @property {function} __retrieve
		 * @property {function(): boolean} isBalanceSheet
		 * @property {function(): boolean} isIncomeStatement
		 * @property {function(): boolean} isStaticPeriods
		 * @property {function(): boolean} supportsCommonSizing
		 * @property {function(): boolean} supportsTrend
		 * @property {function(): string} totalRowName
		 * @property {function(): string} freeTextSearchField
		 * @property {function(): boolean} isLLCBI
		 * @property {function(): boolean} isRelationshipPointer
		 * @property {function(): boolean} saved
		 *
		 * @returns {KOStatement}
		 * @constructor
		 */
		app.SpreadStatement = function(data, shallow){
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('spreadStatement'),
				statementType: null,
				analystOptions: [],
				displayTrend: false,
				displayCommonSizing: false,
				calcCommonSizingDivisorId: null,
				bundle: {},
				spreads: [],
				periods: [],//ko.observableArray(),
				recordTotals: [],
				isTemplate: false,
				sortOrder: null
			}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, app.getMapping(), self);
			}

			var _saveSpreadStatement = function(){
					LifeCycle.SpreadsService.saveIForce(app.mapToJS(self, { useOptimizedMapper: true, maxDepth: 0 }), function(){}, function(){});
			};

			self.save = function(){
				if(self.saveEnabled()){
					if(!self.isLoaded()){
						LifeCycle.SpreadsService.retrieveIForce(
							self,
							self.recordId(),
							function(result){
								var spreadStatement = result;
								app.performingAjax(false);
								self.saveEnabled(false);
								spreadStatement.displayCommonSizing = self.displayCommonSizing();
								spreadStatement.displayTrend = self.displayTrend();
								app.mapFromJS(spreadStatement, app.getMapping(), self);
								_saveSpreadStatement();
								self.saveEnabled(true);
							},
							app.log.failure);
					}else{
						_saveSpreadStatement();
					}
				}
			};

			
			self.isFilled = ko.observable(false);
			self.saveEnabled = ko.observable(true);
			
			// sort periods in place
			var periodSubscription = self.periods.subscribe(_subscribeSorter);
			function _subscribeSorter () {
				periodSubscription.dispose();
				self.periods.sort(_periodSorter);
				periodSubscription = self.periods.subscribe(_subscribeSorter);
			}
			
			return self;
		};
		
		/**
		 * @typedef {app.SpreadStatementRecordValue} KORecordValue
		 * @implements IForceKO
		 * @type Object
		 *
		 * @property {function(): string} apexType
		 * @property {function(): string} name
		 * @property {function(): number} value
		 * @property {function(): boolean} isLinked
		 * @property {KORecord} record
		 * @property {KOPeriod} period
		 * @property {function(): string} formula
		 * @property {function(): string} recordId
		 * @property {function(): boolean} isLoaded
		 * @property {function(): boolean} isSaved
		 * @property {function(): boolean} disabled
		 * @property {function(): boolean} __shallow
		 * @property {function(): string} lookupKey
		 * @property {function(): string} freeTextSearchField
		 * @property {function(): boolean} isLLCBI
		 * @property {function(): boolean} isRelationshipPointer
		 * @property {function(): boolean} saved
		 * @property {Object} __ko_mapping__
		 * @property {Object} __changeTracking
		 * @property {boolean} __cached
		 * @property {function} __retrieve
		 *
		 * @class KORecordValue
		 * @constructor
		 * @returns {KORecordValue}
		 */
		app.SpreadStatementRecordValue = function(data, shallow){
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('spreadStatementRecordValue'),
				name: '',
				value: null,
				isLinked: null,
				record: {},
				period: {},
				formula: null
			}, defaultModelData);

			if(data != undefined){
				_.extend(defaultData, data);
			}
			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, app.getMapping(), self);
			}
			
			self.formula.subscribe(function () {
				if (self.formula.__changeTracking && !self.formula.__changeTracking.isDirty()) {
					return;
				}

				var derivedValue = LifeCycle.SpreadData.FormulaService.evaluateRecordValueFormula(self);
				if (self.value() == derivedValue) {
					app.publish('SPREAD.Spreads.RecordValue_Updated', {
						recordId: ko.unwrap(self.record.recordId),
						periodId: ko.unwrap(self.period.recordId),
						value: derivedValue
					});
				} else {
					self.value(derivedValue);
				}

			});
			
			self.value.subscribe(function (newValue) {
				if (
					self.period &&
					ko.unwrap(self.period.recordId) &&
					self.record &&
					ko.unwrap(self.record.recordId) &&
					(
						!self.__changeTracking ||
						self.__changeTracking && self.__changeTracking.isDirty()
					)
				) {
					app.publish('SPREAD.Spreads.RecordValue_Updated', {
						recordId: ko.unwrap(self.record.recordId),
						periodId: ko.unwrap(self.period.recordId),
						value: newValue
					});
				}
			});
			
			return self;
		};
		
		/**
		 * @typedef {app.SpreadStatementPeriod} KOPeriod
		 * @implements IForceKO
		 * @type Object
		 *
		 * @property {function(): string} apexType
		 * @property {function(): string} name
		 * @property {function(): string} periodKey
		 * @property {KOStatement} statement
		 * @property {function(): string} statementId
		 * @property {function(): number} statementDate
		 * @property {function(): number} numberOfPeriods
		 * @property {function(): string} source
		 * @property {function(): string} analyst
		 * @property {function(): number} month
		 * @property {function(): number} quarter
		 * @property {function(): number} year
		 * @property {function(): string} nameOverride
		 * @property {function(): boolean} isGlobalAnalysisYear
		 * @property {function(): boolean} isFiscalYear
		 * @property {function(): boolean} selected
		 * @property {function(): string} lookupKey
		 * @property {function(): Array<KOCovenantCompliance>} covenantCompliances
		 * @property {function(): string} recordId
		 * @property {function(): boolean} isLoaded
		 * @property {function(): boolean} isSaved
		 * @property {function(): boolean} disabled
		 * @property {function(): boolean} __shallow
		 * @property {function(): boolean} accumulates
		 * @property {function(): number} columnNumber
		 * @property {function(): boolean} selectedInGlobal
		 * @property {function(): string} freeTextSearchField
		 * @property {function(): boolean} isLLCBI
		 * @property {function(): boolean} isRelationshipPointer
		 * @property {function(): boolean} saved
		 * @property {function(): Array<KORecordValue>} recordValues
		 * @property {function(): Array<KOPeriodTotal>} periodTotals
		 * @property {function(): boolean} hasLoadedRecordValues
		 * @property {function(): string} displayNumberOfPeriods
		 * @property {function(): string} displayStatementDate
		 * @property {function(): boolean} isNewPeriod
		 * @property {string} statementDatePlaceholder
		 * @property {function()} errorMsg
		 * @property {function(): boolean} errorExists
		 * @property {string} sourceOptionsCaption
		 * @property {string} analystOptionsCaption
		 * @property {string} complianceOptionsCaption
		 * @property {string} numberOfPeriodsOptionsCaption
		 * @property {Array<number>} numberOfPeriodsOptions
		 * @property {function} applyValidationModel
		 * @property {Object} __ko_mapping__
		 * @property {Object} __changeTracking
		 * @property {boolean} __cached
		 * @property {function} __retrieve
		 * @property {string} periodType
		 *
		 * @returns {KOPeriod}
		 * @constructor
		 */
		app.SpreadStatementPeriod = function(data, shallow){
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('spreadStatementPeriod'),
				name: '',
				periodKey: '',
				statement: {},
				statementId: null,
				statementDate: null,
				numberOfPeriods: null,
				source: null,
				analyst: null,
				month: null,
				quarter: null,
				year: null,
				nameOverride: '',
				isGlobalAnalysisYear: false,
				isFiscalYear: false,
				selected: true,
				lookupKey: null,
				covenantCompliances: [],
				periodType: '',
				fiscalYearTTMPeriod: null,
				initialInterimTTMPeriod: null,
				trailingInterimTTMPeriod: null
			}, defaultModelData);

			if(data != undefined){
				_.extend(defaultData, data);
			}

			self.mapping = jQuery.extend(true, {}, app.getMapping());
			self.mapping.ignore = ['statement'];

			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, self.mapping, self);
			}

			
			self.recordValues = ko.observableArray();
			self.periodTotals = ko.observableArray();
			
			self.hasLoadedRecordValues = ko.observable(false);
			
			self.displayNumberOfPeriods = ko.computed(function() {
				var numberOfPeriods = self.numberOfPeriods();
				if (numberOfPeriods > 0) {
					if (numberOfPeriods > 1) {
						return numberOfPeriods + ' ' + LifeCycle.msgs.msg_months;
					}

					return numberOfPeriods + ' ' + LifeCycle.msgs.msg_month;
				}

				return '';
			});

			self.displayStatementDate = ko.computed({
				read: function () {
					if (_.isNumber(self.statementDate()) && self.statementDate() != 0) {
						return _toDisplay(self.statementDate());
					} else {
						return null;
					}
				},
				write: function (time) {
					time = _setTimezoneOffset(time.replace(/\u200E/g,''));
					self.statementDate(time.getTime());
				}
			});

			self.isNewPeriod = ko.computed(function() {
				return (_.isUndefined(self.recordId) || self.recordId() == null);
			});

			self.statementDatePlaceholder = LifeCycle.msgs.msg_spread_config_statement_date_placeholder;
			self.errorMsg = ko.observable();
			self.errorExists = ko.computed(function() {
				return (!_.isUndefined(self.errorMsg) && !_.isUndefined(self.errorMsg()));
			});
			self.sourceOptionsCaption = LifeCycle.msgs.msg_spread_config_source_options_caption; 
			self.analystOptionsCaption = LifeCycle.msgs.msg_spread_config_analyst_options_caption;
			self.complianceOptionsCaption = LifeCycle.msgs.msg_spread_config_compliance_options_caption;
			self.numberOfPeriodsOptionsCaption = LifeCycle.msgs.msg_spread_config_number_of_periods_options_caption;
			self.numberOfPeriodsOptions = JSON.parse(
				LifeCycle.msgs.msg_spread_config_number_of_periods_options == undefined 
				? '[]' : LifeCycle.msgs.msg_spread_config_number_of_periods_options
			);
			
			self.applyValidationModel = function(){
				
				self.validationModel = ko.validatedObservable({
					displayStatementDate: self.displayStatementDate.extend({
						required: {
							params: true,
							message: 'You must select a date for the statement.'
						}
					}),
					numberOfPeriods: self.numberOfPeriods.extend({
						required: {
							params: true,
							message: 'You must select the number of periods for the statment.'
						}
					}),
					analyst: self.analyst.extend({
						required: {
							params: true,
							message: 'You must select an analyst.'
						}
					}),
					source: self.source.extend({
						required: {
							params: true,
							message: 'You must select a source for the data.'
						}
					})
				});
				
				self.validationModel.errors.showAllMessages();
				
				return self.validationModel;
				
			};

			function _setTimezoneOffset(time) {
				time = new Date(time);
				var newDate = new Date(time.getTime()+time.getTimezoneOffset()*60*1000);

				var offset = time.getTimezoneOffset() / 60;
				var hours = time.getHours();

				newDate.setHours(hours - offset);
				return newDate;
			}

			function _toDisplay(time) {
				time = _setTimezoneOffset(time);
				return time.toLocaleDateString().replace(/[^\w\s\/\-,]/g, '');
			}
			
			self.covenantCompliances.subscribe(function (newSet) {
				var theHaves = LifeCycle.SpreadData.lookupCovenantCompliancesByPeriod(self);
				
				var theHaveNotsThatShouldHave = _.difference(newSet, theHaves);
				var theHavesThatShouldntHave = _.difference(theHaves, newSet);
				
				theHaveNotsThatShouldHave.forEach(function (haveNot) {
					if (!haveNot) { return; }
					haveNot.period = self;
				});
				
				theHavesThatShouldntHave.forEach(function (have) {
					if (!have) { return; }
					have.period = null;
				});
			});

			return self;
		};
		
		/**
		 * @typedef {app.SpreadStatementPeriodTotal} KOPeriodTotal
		 * @implements IForceKO
		 * @type Object
		 *
		 * @property {function(): string} apexType
		 * @property {function(): string} name
		 * @property {function(): number} value
		 * @property {KOPeriod} period
		 * @property {KORecordTotal} recordTotal
		 * @property {function(): string} recordId
		 * @property {function(): boolean} isLoaded
		 * @property {function(): boolean} isSaved
		 * @property {function(): boolean} disabled
		 * @property {function(): boolean} __shallow
		 * @property {function(): string} lookupKey
		 * @property {function(): string} freeTextSearchField
		 * @property {function(): boolean} isLLCBI
		 * @property {function(): boolean} isRelationshipPointer
		 * @property {Object} __ko_mapping__
		 * @property {Object} __changeTracking
		 * @property {boolean} __cached
		 * @property {function} __retrieve
		 *
		 * @returns {KOPeriodTotal}
		 * @constructor
		 */
		app.SpreadStatementPeriodTotal = function(data, shallow){
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('spreadStatementPeriodTotal'),
				name: '',
				value: null,
				period: {},
				recordTotal: {},
				lookupKey : Utils.generateUUID()
			}, defaultModelData);

			if(data != undefined){
				_.extend(defaultData, data);
			}
			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, app.getMapping(), self);
			}


			return self;
		};
		
		/**
		 * @typedef {app.SpreadStatementRecord} KORecord
		 * @implements IForceKO
		 * @type Object
		 *
		 * @property {function(): string} apexType
		 * @property {function(): number} rowNumber
		 * @property {function(): boolean} isLinked
		 * @property {(KORecordTotal|KORecord)} linkedRecord
		 * @property {KORecordTotal} recordTotal
		 * @property {function(): Array<KORecordValue>} recordValues
		 * @property {KOStatement} statement
		 * @property {function(): string} recordId
		 * @property {function(): string} name
		 * @property {function(): boolean} isLoaded
		 * @property {function(): boolean} isSaved
		 * @property {function(): boolean} disabled
		 * @property {function(): boolean} __shallow
		 * @property {function(): string} displayType
		 * @property {function(): string} operation
		 * @property {function(): boolean} periodOverPeriodChange
		 * @property {function(): boolean} priorFiscalYear
		 * @property {function(): string} recordType
		 * @property {function(): boolean} includeInTotal
		 * @property {function(): boolean} isDebit
		 * @property {function(): string} kpiType
		 * @property {function(): Array<KORecord>} records
		 * @property {function(): string} freeTextSearchField
		 * @property {function(): boolean} isLLCBI
		 * @property {function(): boolean} isRelationshipPointer
		 * @property {function(): boolean} saved
		 * @property {function(): Array<KOSpreadRecordClassification>} spreadRecordClassifications
		 * @property {Object} __ko_mapping__
		 * @property {Object} __changeTracking
		 * @property {boolean} __cached
		 * @property {function} __retrieve
		 *
		 * @returns {KORecord}
		 * @constructor
		 */
		app.SpreadStatementRecord = function(data, shallow){
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('spreadStatementRecord'),
				rowNumber: 0,
				isLinked: null,
				linkedRecord: {},
				recordTotal: {},
				recordValues: [],
				statement: {}
			}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, app.getMapping(), self);
			}
			
			self.spreadRecordClassifications = ko.observableArray();

			// Sort record values in place
			var recordValueSubscription = self.recordValues.subscribe(_subscribeSorter);
			function _subscribeSorter () {
				recordValueSubscription.dispose();
				self.recordValues.sort(_periodValueSorter);
				recordValueSubscription = self.recordValues.subscribe(_subscribeSorter);
			}
			
			return self;
		};
		
		/**
		 * @typedef {app.SpreadStatementRecordTotal} KORecordTotal
		 * @implements IForceKO
		 * @type Object
		 *
		 * @property {function(): string} apexType
		 * @property {function(): string} name
		 * @property {function(): string} groupType
		 * @property {function(): string} globalAnalysisType
		 * @property {function(): Array<KORecord>} records
		 * @property {function(): Array<KOPeriodTotal>} periodTotals
		 * @property {function(): number} rowNumber
		 * @property {function(): string} publishOnInitEvent
		 * @property {function(): string} publishOnUpdateEvent
		 * @property {KOStatement} statement
		 * @property {function(): string} recordId
		 * @property {function(): boolean} isLoaded
		 * @property {function(): boolean} isSaved
		 * @property {function(): boolean} disabled
		 * @property {function(): boolean} __shallow
		 * @property {function(): boolean} hideColumnTotals
		 * @property {function(): boolean} includeInTotal
		 * @property {function(): boolean} isDebit
		 * @property {function(): boolean} isHideAllRecords
		 * @property {function(): boolean} isHideCurrencySymbol
		 * @property {function(): boolean} isSummaryGroup
		 * @property {function(): string} kpiType
		 * @property {function(): string} title
		 * @property {function(): string} totalType
		 * @property {function(): string} freeTextSearchField
		 * @property {function(): boolean} isLLCBI
		 * @property {function(): boolean} isRelationshipPointer
		 * @property {function(): boolean} saved
		 * @property {function(): Array<KOSpreadRecordTotalClassification>} spreadRecordTotalClassifications
		 * @property {Object} __ko_mapping__
		 * @property {Object} __changeTracking
		 * @property {boolean} __cached
		 * @property {function} __retrieve
		 *
		 * @returns {KORecordTotal}
		 * @constructor
		 */
		app.SpreadStatementRecordTotal = function(data, shallow){
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('spreadStatementRecordTotal'),
				name: '',
				groupType: null,
				globalAnalysisType: null,
				records: [],
				periodTotals: [],
				rowNumber: 0,
				publishOnInitEvent: '',
				publishOnUpdateEvent: '',
				statement: {}
			}, defaultModelData);

			if(data != undefined){
				_.extend(defaultData, data);
			}
			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, app.getMapping(), self);
			}
			
			self.spreadRecordTotalClassifications = ko.observableArray();
			
			// sort period totals in place
			var periodTotalSubscription = self.periodTotals.subscribe(_subscribeSorter);
			function _subscribeSorter () {
				periodTotalSubscription.dispose();
				self.periodTotals.sort(_periodValueSorter);
				periodTotalSubscription = self.periodTotals.subscribe(_subscribeSorter);
			}
			
			
			return self;
		};
		
		function _periodValueSorter (left, right) {
			if (!left.period && !right.period) {
				return 0;
			} else if (!left.period && right.period) {
				return -1;
			} else if (left.period && !right.period) {
				return 1;
			}
			
			return _periodSorter(left.period, right.period);
		}
		
		function _periodSorter (left, right) {
			var leftPeriodKey = ko.unwrap(left.periodKey);
			var rightPeriodKey = ko.unwrap(right.periodKey);
			
			if (leftPeriodKey < rightPeriodKey) {
				return -1;
			}
			if (leftPeriodKey > rightPeriodKey) {
				return 1;
			}
			return 0;
		}
		
		/**
		 *
		 * @param data
		 * @param shallow
		 * @returns {KOStatement}
		 * @constructor
		 */
		app.SpreadStatementTemplate = function(data, shallow){
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('spreadStatementTemplate'),
				statementType: null,
				bundle: {},
				spreads: []
			}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, app.getMapping(), self);
			}

			self.underwritingBundle = ko.observable();
			
			return self;
		};
		app.setMapping({
			'ignore' : ['hasLoadedRecordValues'],
			'copy': [],
			'period' : {
				create: function(options){
					return new app.SpreadStatementPeriod(options.data, options.useViewModelPlugin);
				}
			},
			'periods' : {
				key: function(period){
					ko.utils.unwrapObservable(period.lookupKey);
				},
				create: function(options){
					return new app.SpreadStatementPeriod(options.data, options.useViewModelPlugin);
				}
			},
			'periodTotals' : {
				create: function(options){
					return new app.SpreadStatementPeriodTotal(options.data, options.useViewModelPlugin);
				}
			},
			'record': {
				create: function(options){
					return new app.SpreadStatementRecord(options.data, options.useViewModelPlugin);
				}
			},
			'records': {
				create: function(options){
					return new app.SpreadStatementRecord(options.data, options.useViewModelPlugin);
				}
			},
			'linkedSpreadStatementRecord':  {
				create: function(options){
					if (_.isEmpty(options.data)) {
						return ko.observable(null);
					}
					return ko.observable(new app.SpreadStatementRecord(options.data, options.useViewModelPlugin));
				}
			},
			'recordTotal' : {
				create: function(options){
					return new app.SpreadStatementRecordTotal(options.data, options.useViewModelPlugin);
				}
			},
			'recordTotals' : {
				create: function(options){
					return new app.SpreadStatementRecordTotal(options.data, options.useViewModelPlugin);
				}
			},
			'linkedSpreadStatementRecordTotal' : {
				create: function(options){
					if (_.isEmpty(options.data)) {
						return ko.observable(null);
					}
					return ko.observable(new app.SpreadStatementRecordTotal(options.data, options.useViewModelPlugin));
				}
			},
			'recordValues' : {
				create: function(options){
					return new app.SpreadStatementRecordValue(options.data, options.useViewModelPlugin);
				}
			},
			'statement': {
				create: function(options){
					if(options.data != undefined && options.data.isTemplate == true){
						return new app.SpreadStatementTemplate(options.data, options.useViewModelPlugin);
					}else{
						return new app.SpreadStatement(options.data, options.useViewModelPlugin);
					}
				}
			},
			'spread': {
				create: function(options){
					return new app.Spread(options.data, options.useViewModelPlugin);
				}
			},
			'spreads': {
				create: function(options){
					return new app.Spread(options.data, options.useViewModelPlugin);
				}
			},
			'spreadStatement': {
				create: function(options){
					return new app.SpreadStatement(options.data, options.useViewModelPlugin);
				}
			},
			'spreadStatements': {
				create: function(options){
					return new app.SpreadStatement(options.data, options.useViewModelPlugin);
				}
			},
			'spreadStatementPeriod' : {
				key: function(period){
					ko.utils.unwrapObservable(period.lookupKey);
				},
				create: function(options){
					return new app.SpreadStatementPeriod(options.data, options.useViewModelPlugin);
				}
			},
			'trailingInterimTTMPeriod' : {
				key: function(period){
					ko.utils.unwrapObservable(period.lookupKey);
				},
				create: function(options){
					if (_.isEmpty(options.data)) {
						return ko.observable(null);
					}
					return ko.observable(new app.SpreadStatementPeriod(options.data, options.useViewModelPlugin));
				}
			},
			'fiscalYearTTMPeriod' : {
				key: function(period){
					ko.utils.unwrapObservable(period.lookupKey);
				},
				create: function(options){
					if (_.isEmpty(options.data)) {
						return ko.observable(null);
					}
					return ko.observable(new app.SpreadStatementPeriod(options.data, options.useViewModelPlugin));
				}
			},
			'initialInterimTTMPeriod' : {
				key: function(period){
					ko.utils.unwrapObservable(period.lookupKey);
				},
				create: function(options){
					if (_.isEmpty(options.data)) {
						return ko.observable(null);
					}
					return ko.observable(new app.SpreadStatementPeriod(options.data, options.useViewModelPlugin));
				}
			},
			'spreadStatementPeriodTotal' : {
				create: function(options){
					return new app.SpreadStatementPeriodTotal(options.data, options.useViewModelPlugin);
				}
			},
			'spreadStatementRecord': {
				create: function(options){
					return new app.SpreadStatementRecord(options.data, options.useViewModelPlugin);
				}
			},
			'spreadStatementRecordTotal' : {
				create: function(options){
					return new app.SpreadStatementRecordTotal(options.data, options.useViewModelPlugin);
				}
			},
			'spreadStatementRecordValue': {
				create: function(options){
					return new app.SpreadStatementRecordValue(options.data, options.useViewModelPlugin);
				}
			},
			'spreadStatementTemplate': {
				create: function(options){
					return new app.SpreadStatementTemplate(options.data, options.useViewModelPlugin);
				}
			},
			'spreadStatementTemplates': {
				create: function(options){
					return new app.SpreadStatementTemplate(options.data, options.useViewModelPlugin);
				}
			},
			'statements': {
				create: function(options){
					if(options.data != undefined && options.data.isTemplate == true){
						return new app.SpreadStatementTemplate(options.data, options.useViewModelPlugin);
					}else{
						return new app.SpreadStatement(options.data, options.useViewModelPlugin);
					}
				}
			}
		});
		app.setTypesMap({
			LifeCycleSpread: 'spread',
			LifeCycleSpreadStatement: 'spreadStatement',
			LifeCycleSpreadStatementPeriod: 'spreadStatementPeriod',
			LifeCycleSpreadStatementPeriodTotal:'spreadStatementPeriodTotal',
			LifeCycleSpreadStatementRecord: 'spreadStatementRecord',
			LifeCycleSpreadStatementTotal: 'spreadStatementRecordTotal',
			LifeCycleSpreadStatementRecordTotal: 'spreadStatementRecordTotal',
			LifeCycleSpreadStatementRecordValue: 'spreadStatementRecordValue',
			LifeCycleSpreadStatementTemplate: 'spreadStatementTemplate'
		});
		
		app.log('Spreading Models initialized.');
	};
	if(LifeCycle.Spreading == undefined){
		LifeCycle.Spreading = {};
	}
	if(LifeCycle.Spreading.Models == undefined){
		LifeCycle.Spreading.Models = Models;
	}
})();

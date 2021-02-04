(function(){
	var Models = function(event, app){
		var defaultModelData = {
			recordId : null,
			name : '',
			isLLCBI: false,
			isLoaded : false,
			isSaved: false
		};
		var defaultForceModelData = {
			recordId : null,
			name : ''
		};

		/**
		 * @typedef {app.Covenant} KOCovenant
		 * @implements IForceKO
		 * @type Object
		 *
		 * @property {Object} mapping
		 * @property {function(): string} apexType
		 * @property {function(): boolean} isActive
		 * @property {function(): string} frequency
		 * @property {function(): string} nextEvalDate
		 * @property {function(): string} effectiveDate
		 * @property {function(): string} category
		 * @property {function(): string} complianceDaysPrior
		 * @property {KOCovenantType} covenantType
		 * @property {function(): Array<KOCovenant>} relatedCovenants
		 * @property {function(): Array<KOAccountCovenant>} accountCovenants
		 * @property {function(): Array<KOCovenantRule>} covenantRules
		 * @property {function(): KORecord} linkedSpreadStatementRecord
		 * @property {function(): KORecordTotal} linkedSpreadStatementRecordTotal
		 * @property {function(): string} recordId
		 * @property {function(): string} name
		 * @property {function(): boolean} __shallow
		 * @property {function(): boolean} isRelationshipPointer
		 * @property {function(): boolean} saved
		 * @property {function(): boolean} isLoaded
		 * @property {Object} __ko_mapping__
		 * @property {function(): KOCovenantType} relatedCovenant
		 * @property {function(): boolean} selected
		 * @property {function(): boolean} isEditing
		 * @property {function(): boolean} editingRelatedSpreadRecord
		 * @property {function(): boolean} showPanel
		 * @property {function(): KOStatement} selectedStatement
		 * @property {function(): KORecordTotal} selectedRecordTotal
		 * @property {function(): KORecord} selectedRecord
		 * @property {function} cancelEditRelatedSpreadRecord
		 * @property {function} selectStatement
		 * @property {function} selectStatementRecordTotal
		 * @property {function} selectStatementRecord
		 * @property {function(): undefined} setLinkedSpreadRecords
		 * @property {function(): boolean} covenantRulesAreValid
		 * @property {function} addNewCovenantRule
		 * @property {function} saveCovenantRules
		 * @property {function(): Array<KOLoanCovenant>} loanCovenants
		 * @property {function(): Array<KOCovenantCompliance>} covenantCompliances
		 * @property {Object} __changeTracking
		 * @property {boolean} __cached
		 * @property {function} __retrieve
		 * @property {boolean} __placeholder
		 *
		 * @returns {KOCovenant}
		 * @constructor
		 */
		app.Covenant = function(data, shallow) {
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('covenant'),
				isActive: null,
				frequency: '',
				frequencyLabel: '',
				nextEvalDate: '',
				effectiveDate: '',
				category: null,
				complianceDaysPrior: '',
				covenantType: undefined,
				relatedCovenants: [],
				accountCovenants: [],
				covenantRules: [],
				comments: '',
				linkedSpreadStatementRecord: null,
				linkedSpreadStatementRecordTotal: null
			}, defaultForceModelData);

			if(data){
				_.extend(defaultData, data);
			}

			self.mapping = app.getMapping();
			self.mapping['include'] = ['relatedCovenant'];

			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, self.mapping, self);
			}

			self.relatedCovenant = data ? ko.observable(data.relatedCovenant) : ko.observable();
			self.selected = ko.observable(false);
			self.isEditing = ko.observable(false);
			self.editingRelatedSpreadRecord = ko.observable(false);
			self.showPanel = ko.observable(false);
			self.selectedStatement = ko.observable(undefined);
			self.selectedRecordTotal = ko.observable(undefined);
			self.selectedRecord = ko.observable(undefined);
			self.isFinancialIndicator = ko.observable(false);

			self.relatedCovenant.subscribe(function(relatedCovenant) {
				if (relatedCovenant) {
					self.nextEvalDate(relatedCovenant.nextEvalDate());
					self.frequency(relatedCovenant.frequency());
				}
			});

			self.category.subscribe(function(category) {
				if ((category != LifeCycle.msgs.msg_financial_indicators && !self.isFinancialIndicator())
					&& !_.isUndefined(self.relatedCovenant)) {
					self.relatedCovenant(undefined);
				}
			});

			self.editingRelatedSpreadRecord.subscribe(function(editingRelatedSpreadRecord) {
				if (editingRelatedSpreadRecord) {
					_cacheRelatedRecord();
				}
			});

			self.cancelEditRelatedSpreadRecord = function() {
				self.editingRelatedSpreadRecord(false);
				_restoreRelatedRecord();
			};

			self.selectStatement = function(statement) {
				self.selectedStatement(statement);
				LifeCycle.SpreadData.getEntireStatement(statement.recordId());
				self.selectedRecordTotal(undefined);
				self.selectedRecord(undefined);
			};
			self.selectStatementRecordTotal = function(recordTotal) {
				self.selectedRecordTotal(recordTotal);
				self.selectedRecord(undefined);
			};
			self.selectStatementRecord = function(record) {
				self.selectedRecord(record);
			};
			self.setLinkedSpreadRecords = ko.computed(function() {
				if (!_.isUndefined(self.selectedRecordTotal()) && _.isUndefined(self.selectedRecord())) {
					self.linkedSpreadStatementRecord(null);
					self.linkedSpreadStatementRecordTotal(self.selectedRecordTotal());
				} else if (!_.isUndefined(self.selectedRecordTotal()) && !_.isUndefined(self.selectedRecord())) {
					self.linkedSpreadStatementRecordTotal(null);
					self.linkedSpreadStatementRecord(self.selectedRecord());
				} else if (_.isUndefined(self.selectedRecordTotal()) && _.isUndefined(self.selectedRecord())
					&& !_.isUndefined(self.selectedStatement())) {
					self.linkedSpreadStatementRecordTotal(null);
					self.linkedSpreadStatementRecord(null);
				}
			});

			self.covenantRulesAreValid = ko.computed(function() {
				var isValid = true;
				_.each(self.covenantRules(), function(covenantRule) {
					if (!covenantRule.validationModel.isValid()) {
						isValid = false;
					}
				});
				return isValid;
			});

			self.addNewCovenantRule = function() {
				var newRule = new app.CovenantRule();
				newRule.covenant = new app.Covenant({ recordId: self.recordId() });
				self.covenantRules.push(newRule);
			}

			self.saveCovenantRules = function() {
				_.each(self.covenantRules(), function(covenantRule) {
					LifeCycle.LiteForceService.saveIForce(
						app.mapToJS(covenantRule),
						function(result) {
							app.mapFromJS(result, app.getMapping(), covenantRule)
						});
					if (self.covenantRules().indexOf(covenantRule) == self.covenantRules().length - 1) {
						self.showPanel(false);
					}
				});
				LifeCycle.LiteForceService.saveIForce(
					app.mapToJS(self),
					function(result) {
						app.mapFromJS(result, app.getMapping(), self)
					});
			};

			self.loanCovenants = ko.observableArray();
			self.covenantCompliances = ko.observableArray();

			var _cacheRelatedRecord = function() {
				if (!self.cachedSpreadRecordInfo) {
					self.cachedSpreadRecordInfo = {};
				}
				self.cachedSpreadRecordInfo.selectedStatement = self.selectedStatement();
				self.cachedSpreadRecordInfo.selectedRecordTotal = self.selectedRecordTotal();
				self.cachedSpreadRecordInfo.selectedRecord = self.selectedRecord();
			};

			var _restoreRelatedRecord = function() {
				self.selectedStatement(self.cachedSpreadRecordInfo.selectedStatement);
				self.selectedRecordTotal(self.cachedSpreadRecordInfo.selectedRecordTotal);
				self.selectedRecord(self.cachedSpreadRecordInfo.selectedRecord);
			};

			return self;
		};

		/**
		 * @typedef {app.AccountCovenant} KOAccountCovenant
		 * @implements IForceKO
		 * @type Object
		 *
		 * @property {function(): string} apexType
		 * @property {KORelationship} account
		 * @property {KOCovenant} covenant
		 * @property {function(): Object} id
		 * @property {function(): string} recordId
		 * @property {function(): string} name
		 * @property {function(): boolean} __shallow
		 * @property {function(): boolean} isRelationshipPointer
		 * @property {function(): boolean} saved
		 * @property {function(): boolean} isLoaded
		 * @property {Object} __ko_mapping__
		 * @property {Object} __changeTracking
		 * @property {boolean} __cached
		 * @property {function} __retrieve
		 *
		 * @returns {KOAccountCovenant}
		 * @constructor
		 */
		app.AccountCovenant = function (data, shallow) {
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('accountCovenant'),
				account: {},
				covenant: {}
			}, defaultForceModelData);

			if(data != undefined){
				_.extend(defaultData, data);
			}

			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, self.mapping, self);
			}

			return self;
		};

		/**
		 * @typedef {app.LoanCovenant} KOLoanCovenant
		 * @implements IForceKO
		 * @type Object
		 *
		 * @property {function(): string} apexType
		 * @property {KOLoan} loan
		 * @property {KOCovenant} covenant
		 * @property {function(): Object} id
		 * @property {function(): string} recordId
		 * @property {function(): string} name
		 * @property {function(): boolean} __shallow
		 * @property {function(): boolean} isRelationshipPointer
		 * @property {function(): boolean} saved
		 * @property {function(): boolean} isLoaded
		 * @property {Object} __ko_mapping__
		 * @property {Object} __changeTracking
		 * @property {boolean} __cached
		 * @property {function} __retrieve
		 *
		 * @returns {KOLoanCovenant}
		 * @constructor
		 */
		app.LoanCovenant = function (data, shallow) {
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('loanCovenant'),
				loan: {},
				covenant: {}
			}, defaultForceModelData);

			if(data != undefined){
				_.extend(defaultData, data);
			}

			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, self.mapping, self);
			}

			return self;
		};

		/**
		 * @typedef {app.CovenantCompliance} KOCovenantCompliance
		 * @implements IForceKO
		 * @type Object
		 *
		 * @property {function(): string} apexType
		 * @property {KOCovenant} covenant
		 * @property {function(): string} associatedStatementPeriodId
		 * @property {KOUnderwritingBundle} bundle
		 * @property {KOPeriod} period
		 * @property {function(): Date} effectiveDate
		 * @property {function(): string} status
		 * @property {function(): string} recordId
		 * @property {function(): string} name
		 * @property {function(): boolean} isLLCBI
		 * @property {function(): boolean} isLoaded
		 * @property {function(): boolean} isSaved
		 * @property {function(): boolean} __shallow
		 * @property {function(): boolean} disabled
		 * @property {function(): string} freeTextSearchField
		 * @property {function(): boolean} isRelationshipPointer
		 * @property {Object} __ko_mapping__
		 * @property {Object} __changeTracking
		 * @property {boolean} __cached
		 * @property {function} __retrieve
		 *
		 * @returns {app.CovenantCompliance}
		 * @constructor
		 */
		app.CovenantCompliance = function(data, shallow) {
			var self = this;
			//properties coming from LifeCycleCovenantCompliance2
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('covenantCompliance'),
				covenant: {},
				associatedStatementPeriodId: '',
				bundle: {},
				period: {},
				effectiveDate: null,
				status: ''
			}, defaultModelData);

			if(data){
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
		 * @typedef {app.CovenantRule} KOCovenantRule
		 * @implements IForceKO
		 * @type Object
		 *
		 * @property {Object} mapping
		 * @property {function(): string} apexType
		 * @property {KOCovenant} covenant
		 * @property {function(): number} endDate
		 * @property {function(): number} financialIndicatorValue
		 * @property {function(): string} operator
		 * @property {Object} __ko_mapping__
		 * @property {function(): Date} displayEndDate
		 * @property {function(): Object} validationModel
		 *
		 * @returns {app.CovenantRule}
		 * @constructor
		 */
		app.CovenantRule = function(data, shallow) {
			var self = this;
			//properties coming from LifeCycleCovenantCompliance2
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('covenantRule'),
				covenant: '',
				endDate: 0,
				financialIndicatorValue: undefined,
				operator: ''
			}, {});

			if(data){
				_.extend(defaultData, data);
			}

			self.mapping = app.getMapping();
			self.mapping['ignore'] = [
				'id'
			];

			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, self.mapping, self);
			}

			self.displayEndDate = ko.computed({
				read: function () {
					if (_.isNumber(self.endDate()) && self.endDate() != 0) {
						return _toDisplay(self.endDate());
					} else {
						return null;
					}
				},
				write: function (time) {
					self.endDate(time.getTime());
				}
			});

			var _setTimezoneOffset = function(time) {
				time = new Date(time);
				var newDate = new Date(time.getTime()+time.getTimezoneOffset()*60*1000);

				var offset = time.getTimezoneOffset() / 60;
				var hours = time.getHours();

				newDate.setHours(hours - offset);
				return newDate;
			};

			var _toDisplay = function(time) {
				time = _setTimezoneOffset(time);
				return window.LifeCycle.Internationalize.format(time, intl.formats.datetime.SHORT_DATE);
			};

			self.validationModel = ko.validatedObservable({
				endDate: self.endDate.extend({
					required: true
				}),
				financialIndicatorValue: self.financialIndicatorValue.extend({
					required: true
				}),
				operator: self.operator.extend({
					required: true
				})
			});

			return self;
		};

		/**
		 * @typedef {app.CovenantType} KOCovenantType
		 * @implements IForceKO
		 * @type Object
		 *
		 * @property {function(): string} apexType
		 * @property {function(): string} category
		 * @property {function(): string} recordId
		 * @property {function(): string} name
		 * @property {function(): boolean} __shallow
		 * @property {function(): boolean} isRelationshipPointer
		 * @property {function(): boolean} saved
		 * @property {function(): boolean} isLoaded
		 * @property {Object} __ko_mapping__
		 * @property {Object} __changeTracking
		 * @property {boolean} __cached
		 * @property {function} __retrieve
		 *
		 * @returns {app.CovenantType}
		 * @constructor
		 */
		app.CovenantType = function(data, shallow) {
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('covenantType'),
				category: ''
			}, defaultForceModelData);

			if(data){
				_.extend(defaultData, data);
			}

			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, self.mapping, self);
			}

			return self;
		};

		app.setMapping({
			'covenant': {
				create: function(options){
					return new app.Covenant(options.data);
				}
			},
			'covenants': {
				create: function(options){
					return new app.Covenant(options.data);
				}
			},
			'relatedCovenant': {
				create: function(options){
					return new app.Covenant(options.data);
				}
			},
			'relatedCovenants': {
				create: function(options){
					return new app.Covenant(options.data);
				}
			},
			'accountCovenant': {
				create: function (options) {
					return new app.AccountCovenant(options.data);
				}
			},
			'accountCovenants': {
				create: function (options) {
					return new app.AccountCovenant(options.data);
				}
			},
			'loanCovenant': {
				create: function (options) {
					return new app.LoanCovenant(options.data);
				}
			},
			'loanCovenants': {
				create: function (options) {
					return new app.LoanCovenant(options.data);
				}
			},
			'covenantCompliance': {
				create: function(options){
					return new app.CovenantCompliance(options.data, options.useViewModelPlugin);
				}
			},
			'covenantCompliances': {
				create: function(options){
					return new app.CovenantCompliance(options.data, options.useViewModelPlugin);
				}
			},
			'covenantRules': {
				create: function(options){
					return new app.CovenantRule(options.data, options.useViewModelPlugin);
				}
			},
			'covenantType': {
				create: function(options){
					return new app.CovenantType(options.data, options.useViewModelPlugin);
				}
			},
			'covenantTypes': {
				create: function(options){
					return new app.CovenantType(options.data, options.useViewModelPlugin);
				}
			}
		});
		app.setTypesMap({
			'LifeCycleCovenantCompliance2' : 'covenantCompliance',
			'LifeCycleAccountCovenant' : 'accountCovenant',
			'LifeCycleLoanCovenant' : 'loanCovenant',
			'CovenantMgmt' : 'covenant',
			'CovenantType' : 'covenantType',
			'LifeCycleCovenantRule' : 'covenantRule',
			'LifeCycleCovenantType' : 'covenantType'
		});
		app.log('Covenant Models initialized.');
	};
	if(LifeCycle.Covenant == undefined){
		LifeCycle.Covenant = {};
	}
	if(LifeCycle.Covenant.Models == undefined){
		LifeCycle.Covenant.Models = Models;
	}
})();

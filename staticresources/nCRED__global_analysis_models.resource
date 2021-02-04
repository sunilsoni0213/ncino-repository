(function(){
	var Models = function(event, app){
		var defaultModelData = {
			recordId : null,
			name : '',
			isLoaded : false,
			disabled: false
		};

		app.GlobalEntity = function(data){
			var self = this;
			var defaultData = _.extend({
				isBundleEntity: true,
				accountId: null,
				entityType: null,
				globalPeriods: [],
				showDetails: true,
				selected: true
			}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			
			delete defaultData.model;
			app.mapFromJS(defaultData, {}, self);

			if (!_.isUndefined(data) && !_.isUndefined(data.model)) {
				self.model = app.mapToJS(data.model);
			} else {
				self.model = {isIncludedInGlobalAnalysis: true};
			}
			self.selected(self.model.isIncludedInGlobalAnalysis && (self.isBundleEntity() !== false));


			self.selected.subscribe(function(value) {
				if (!_.isUndefined(self.model) && self.model.isIncludedInGlobalAnalysis != value) {
					self.model.isIncludedInGlobalAnalysis = value;
					_save();
				}
			});

			self.isVisible = ko.computed(function() {
				return self.selected();
			});

			self.selectedPeriods = ko.computed(function() {
				return _.filter(self.globalPeriods(), function(period) {
					return period.isVisible();
				});
			});

			function _save() {
				var entity = self.model;
				if (!_.isUndefined(entity)) {
					LifeCycle.blockUI('300px');

					LifeCycle.SpreadsService.saveIForce(entity, function(){
						LifeCycle.unblockUI();
					});
				}
			};

			return self;
		};

		app.GlobalPeriod = function(data){
			var self = this;
			var defaultData = _.extend({
				year: '',
				source: LifeCycle.msgs.msg_na,
				cashFlow: 0,
				debtService: 0,
				totalAssets: 0,
				totalLiabilities: 0,
				totalEquity: 0,
				adjustedTotalAssets: 0,
				adjustedTotalLiabilities: 0,
				adjustedTotalEquity: 0,
				isVisible: true,
				selected: true,
				isTTM: false
			}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}

			delete defaultData.model;
			app.mapFromJS(defaultData, {}, self);

			if (!_.isUndefined(data) && !_.isUndefined(data.model)) {
				self.model = data.model;
			}
			self.availableSources = ko.observableArray();
			self.selectedSource = ko.observable();

			// Loads the period's data, but not its selected property.
			self.loadPeriodData = function(period) {
				if (!_.isUndefined(period)) {
					self.model = period.model;
					self.source(period.source());
					self.cashFlow(period.cashFlow());
					self.debtService(period.debtService());
					self.totalAssets(period.totalAssets());
					self.totalLiabilities(period.totalLiabilities());
					self.totalEquity(period.totalEquity());
					self.adjustedTotalAssets(period.adjustedTotalAssets());
					self.adjustedTotalLiabilities(period.adjustedTotalLiabilities());
					self.adjustedTotalEquity(period.adjustedTotalEquity());
					self.selected(period.selected());
					// This should not copy the selectedInGlobal attribute, because it will be assigned by the ui.
				}
			};

			self.isGlobalAnalysisYear = ko.computed({
				read: function() {
					if (!_.isUndefined(self.model)) {
						return self.model.isGlobalAnalysisYear;
					}

					return null;
				},
				write: function(value) {
					if (!_.isUndefined(self.model)) {
						self.model.isGlobalAnalysisYear(value);
					}
				}
			});

			// This logic should fire whenever a different source is selected
			self.sourceSelectedEvent = ko.computed(function() {
				var source = self.selectedSource();

				if (!_.isUndefined(source)) {
					// Load the selected period's data.
					self.loadPeriodData(source);
					// Set the selected period as the global year.
					if (!_.isUndefined(self.model) && !self.model.isGlobalAnalysisYear()) {
						_.each(self.availableSources(), function(childSource) {
							if (childSource.source() != source.source()) {
								childSource.isGlobalAnalysisYear(false);
							}
						})

						// Save the changes.
						self.isGlobalAnalysisYear(true);
						self.model.selectedInGlobal(true);
						_save();
					}
				}
			});

			self.isVisible.subscribe(function(value) {
				self.isGlobalAnalysisYear(value);
			});

			// Calculates the excess cash flow.
			self.excessCashFlow = ko.computed(function() {
				var cashFlow = self.cashFlow();
				var debtService = self.debtService();
				if (_.isNumber(cashFlow) &&
					_.isNumber(debtService)
				) {
					return cashFlow - debtService;
				}

				return null;
			});

			// Calculates the entity cash flow coverage.
			self.entityCashFlowCoverage = ko.computed(function() {
				if (_.isNumber(self.cashFlow()) &&
					_.isNumber(self.debtService()) &&
					self.debtService() > 0
				) {
					var result = self.cashFlow() / self.debtService();
					return result.toFixed(2);
				}

				return null;
			});

			// Calculates Entity Net Worth
			self.entityNetWorth = ko.computed(_fnCalcEntityNetWorth);

			// Calculates Adjusted Entity Net Worth
			self.entityAdjustedNetWorth = ko.computed(_fnCalcAdjustedEntityNetWorth);

			// Calculates the entity Global Leverage
			self.entityGlobalLeverage = ko.computed(function() {
				if (_.isNumber(self.totalLiabilities()) &&
					_.isNumber(self.totalEquity()) &&
					self.totalEquity() > 0
				) {
					var result = self.totalLiabilities() / self.totalEquity();
					return result.toFixed(2);
				}

				return null;
			});

			// Calculates the entity Adjusted Global Leverage
			self.entityAdjustedGlobalLeverage = ko.computed(function() {
				if (_.isNumber(self.adjustedTotalLiabilities()) &&
					_.isNumber(self.adjustedTotalEquity()) &&
					self.adjustedTotalEquity() > 0
				) {
					var result = self.adjustedTotalLiabilities() / self.adjustedTotalEquity();
					return result.toFixed(2);
				}

				return null;
			});

			function _fnCalcEntityNetWorth(){
				var totalAssets = self.totalAssets();
				var totalLiabilities = self.totalLiabilities();
				if (_.isNumber(totalAssets) &&
					_.isNumber(totalLiabilities)
				) {
					return totalAssets - totalLiabilities;
				}
				return null;
			}

			function _fnCalcAdjustedEntityNetWorth(){
				var adjustedTotalAssets = self.adjustedTotalAssets();
				var adjustedTotalLiabilities = self.adjustedTotalLiabilities();
				if (_.isNumber(adjustedTotalAssets) &&
					_.isNumber(adjustedTotalLiabilities)
				) {
					return adjustedTotalAssets - adjustedTotalLiabilities;
				}
				return null;
			}

			function _save() {
				var period = self.model;
				if (!_.isUndefined(period)) {
					LifeCycle.blockUI('300px');

					LifeCycle.SpreadsService.saveIForce(app.mapToJS(period), function(){
						LifeCycle.unblockUI();
					});
				}
			};

			return self;
		};

		app.GlobalPeriodTotal = function(data) {
			var self = this;
			var defaultData = _.extend({
				year: '',
				globalPeriods: [],
				totalCombinedCash: 0,
				totalCombinedDebtService: 0,
				totalCombinedTotalAssets: 0,
				totalCombinedTotalLiabilities: 0,
				totalCombinedTotalEquity: 0,
				totalCombinedAdjustedTotalAssets: 0,
				totalCombinedAdjustedTotalLiabilities: 0,
				totalCombinedAdjustedTotalEquity: 0,
				globalNetWorth: 0,
				globalLeverage: 0,
				globalAdjustedNetWorth: 0,
				globalAdjustedLeverage: 0,
				globalExcessCashFlow: 0,
				globalCashFlowCoverage: 0,
				isVisible: true
			}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, {}, self);

			self.totalCalculation = ko.computed(function() {
				var periods = self.globalPeriods();
				var combinedCash = 0;
				var combinedDebtService = 0;
				var combinedTotalAssets = 0;
				var combinedTotalLiabilities = 0;
				var combinedTotalEquity = 0;
				var combinedAdjustedTotalAssets = 0;
				var combinedAdjustedTotalLiabilities = 0;
				var combinedAdjustedTotalEquity = 0;

				_.each(periods, function(period) {
					if (period.isVisible()) {
						if (_.isNumber(period.cashFlow())) {
							combinedCash += period.cashFlow();
						}
						if (_.isNumber(period.debtService())) {
							combinedDebtService += period.debtService();
						}
						if (_.isNumber(period.totalAssets())) {
							combinedTotalAssets += period.totalAssets();
						}
						if (_.isNumber(period.totalLiabilities())) {
							combinedTotalLiabilities += period.totalLiabilities();
						}
						if (_.isNumber(period.totalEquity())) {
							combinedTotalEquity += period.totalEquity();
						}
						if (_.isNumber(period.adjustedTotalAssets())) {
							combinedAdjustedTotalAssets += period.adjustedTotalAssets();
						}
						if (_.isNumber(period.adjustedTotalLiabilities())) {
							combinedAdjustedTotalLiabilities += period.adjustedTotalLiabilities();
						}
						if (_.isNumber(period.adjustedTotalEquity())) {
							combinedAdjustedTotalEquity += period.adjustedTotalEquity();
						}
					}
				});

				self.totalCombinedCash(combinedCash);
				self.totalCombinedDebtService(combinedDebtService);
				self.totalCombinedTotalAssets(combinedTotalAssets);
				self.totalCombinedTotalLiabilities(combinedTotalLiabilities);
				self.totalCombinedTotalEquity(combinedTotalEquity);
				self.totalCombinedAdjustedTotalAssets(combinedAdjustedTotalAssets);
				self.totalCombinedAdjustedTotalLiabilities(combinedAdjustedTotalLiabilities);
				self.totalCombinedAdjustedTotalEquity(combinedAdjustedTotalEquity);
				self.globalExcessCashFlow(combinedCash - combinedDebtService);
				self.globalNetWorth(combinedTotalEquity);
				self.globalAdjustedNetWorth(combinedAdjustedTotalEquity);

				if (combinedDebtService > 0) {
					var result = combinedCash / combinedDebtService;
					self.globalCashFlowCoverage(result.toFixed(2));
				} else {
					self.globalCashFlowCoverage(0);
				}

				if(combinedTotalEquity > 0){
					var result = combinedTotalLiabilities / combinedTotalEquity;
					self.globalLeverage(result.toFixed(2));
				} else {
					self.globalLeverage(0);
				}

				if(combinedAdjustedTotalEquity > 0){
					var result = combinedAdjustedTotalLiabilities / combinedAdjustedTotalEquity;
					self.globalAdjustedLeverage(result.toFixed(2));
				} else {
					self.globalAdjustedLeverage(0);
				}

				return null;
			});
		};

		app.GlobalYear = function(data){
			var self = this;
			var defaultData = _.extend({
				year: '',
				selected: true,
				hasFullDate: false,
				month: '',
				date: '',
				isTTM: false
			}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, {}, self);

			self.isVisible = ko.computed(function() {
				return self.selected();
			});

			return self;
		};

		app.DisplaySettings = function(data){
			var self = this;
			var defaultData = _.extend({
				maximumColumnWidth: 100,
				columnCount: 0,
				titleColumnWidth: 100,
				spreadColumnWidth: 120
			}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, {}, self);

			self.tableWidth = ko.computed(function() {
				var calculatedTableWidth = '100%';

				var windowWidth = jQuery(window).width();
				var newWidth = (self.columnCount() * self.spreadColumnWidth()) + self.titleColumnWidth();
				newWidth = Math.min(self.maximumColumnWidth(), newWidth / windowWidth * 100);
				calculatedTableWidth = newWidth + '%';

				return calculatedTableWidth;
			});

			return self;
		};
	};

	if(LifeCycle.GlobalAnalysis == undefined){
		LifeCycle.GlobalAnalysis = {};
	}

	if(LifeCycle.GlobalAnalysis.Models == undefined){
		LifeCycle.GlobalAnalysis.Models = Models;
	}
})();

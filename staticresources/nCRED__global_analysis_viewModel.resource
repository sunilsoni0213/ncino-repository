(function () {
	var ViewModel;
	ViewModel = function (event, app) {
		app.ViewModel = function (data) {
			var self = this;
			self.app = app;

			if (!data.loan) {
				data.loan = {};
			}
			if (
				!data.loan.recordId && (
					data.contextObjectId ||
					data.contextObject && data.contextObject.recordId
				)
			) {
				data.loan.recordId = (data.contextObject.recordId || data.contextObjectId);
			}

			var defaultData = {
				loan: '',
				bundles: [],
				relatedEntities: [],
				mode: '',
				showOperations: false,
				showCashFlowDetails: true,
				showLeverageDetails: true,
				showCombinedAssets: true,
				showCombinedLiabilities: true,
				showCombinedNetWorth: true,
				showCombinedAdjustedWorth: true,
				showCombinedLeverage: true,
				showDebtServiceDetails: true,
				showGlobalCashFlowDetails: true,
				isOpen: false,
				displaySettings: new app.DisplaySettings()
			};
			self.globalScaleString = ko.observable();
			if (data) {
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.loan = LifeCycle.IForceCache.lookupIForceById(self.loan.recordId(), {
				placeholderType: 'c.LifeCycleLoan',
				generatePlaceholder: true,
				alwaysReturnModel: true
			});

			/**
			 * @typedef {Object}
			 * @property {function} promptSave
			 */
			self.spread = data.spread;

			self.isConfiguredForGlobalCashFlow = ko.observable(false);
			self.isConfiguredForGlobalLeverage = ko.observable(false);

			self.loaded = ko.observable(false);
			self.loadingComplete = ko.observable(false);

			self.load = function () {
				app.subscribe('SPREAD.Spreads.Fullscreen_App_Opened', self.closeApp);
				app.subscribe('SPREAD.Spreads.Scale_Updated', function () {
					self.loadGlobalAnalysis(self.bundles());
				});

				LifeCycle.SpreadData.getGlobalAnalysis(
					self.loan.recordId(),
					{},
					function (gaBundles) {
						self.bundles(gaBundles);
						self.loadingComplete(true);
						self.loadGlobalAnalysis(self.bundles());
					}
				);

				app.subscribe('SPREAD.Spreads.Saved', function () {
					self.loadingComplete(false);
					self.loaded(false);

					LifeCycle.SpreadData.loadGlobalAnalysis(
						self.loan.recordId(),
						{},
						function (gaBundles) {
							self.bundles(gaBundles);
							self.loadingComplete(true);
							self.loadGlobalAnalysis(self.bundles());
						}
					);
				});
			};

			self.cashFlowLabel = LifeCycle.msgs.msg_global_analysis_type_cash_flow;
			self.debtServiceLabel = LifeCycle.msgs.msg_global_analysis_type_debt_service;
			self.totalAssetsLabel = LifeCycle.msgs.msg_global_analysis_type_total_assets;
			self.totalLiabilitiesLabel = LifeCycle.msgs.msg_global_analysis_type_total_liabilities;
			self.totalEquityLabel = LifeCycle.msgs.msg_global_analysis_type_total_equity;
			self.adjustedTotalAssestsLabel = LifeCycle.msgs.msg_global_analysis_type_adjusted_total_assets;
			self.adjustedTotalLiabilitiesLabel = LifeCycle.msgs.msg_global_analysis_type_adjusted_total_liabilities;
			self.adjustedTotalEquityLabel = LifeCycle.msgs.msg_global_analysis_type_adjusted_total_equity;

			self.isPrintView = ko.computed(function () {
				return (self.mode() == LifeCycle.msgs.msg_mode_print);
			});

			self.isExportView = ko.computed(function () {
				return (self.mode() == LifeCycle.msgs.msg_mode_export);
			});

			self.isStandardView = ko.computed(function () {
				return (!self.isPrintView() && !self.isExportView());
			});

			self.isGlobalLeverage = ko.observable(false);

			self.showGlobalLeverage = function () {
				self.isGlobalLeverage(true);
			};

			self.showCashFlow = function () {
				self.isGlobalLeverage(false);
			};

			self.globalEntities = ko.observableArray();

			self.globalYears = ko.observableArray();
			self.globalPeriodTotals = ko.observableArray();
			self.selectedPeriodTotals = ko.observable();

			self.selectedEntities = ko.computed(function () {
				return _.filter(self.globalEntities(), function (entity) {
					return entity.isVisible();
				});
			});

			self.selectedYears = ko.computed(function () {
				return _.filter(self.globalYears(), function (year) {
					return year.isVisible();
				});
			});

			self.toggle = function (data, e) {
				if (!self.spread.navApp.viewModel.savePending()) {
					app.publish('SPREAD.Spreads.Fullscreen_App_Opened', self.app.appId);
					if (!_.isUndefined(key)) {
						if (self.isOpen()) {
							key.setScope('nav');
						} else {
							key.setScope('global');
						}
					}
					self.isOpen(!self.isOpen());
					var mainSpreading = jQuery('.main_spreading');
					if (self.isOpen() && mainSpreading.is(':visible')) {
						jQuery('.main_spreading, .spread-footnotes').hide();
						jQuery('.nav .current-spread').removeClass('active');
					} else if (!self.isOpen() && mainSpreading.is(':hidden')) {
						jQuery('.main_spreading, .spread-footnotes').show();
						jQuery('.nav .current-spread').addClass('active');
					}
				} else {
					if (e) {
						e.cancelBubble = true;
						if (e.stopPropagation) e.stopPropagation();
						if (e.stopImmediatePropagation) e.stopImmediatePropagation();
					}
					self.spread.promptSave();
				}
			};

			self.closeApp = function (e) {
				if (e != self.app.appId) {
					self.isOpen(false);
				}
			};

			self.selectedYears.subscribe(function (value) {
				self.displaySettings.columnCount(value.length);
			});

			self.isOpen.subscribe(function (value) {
				self.app.publish('SPREAD.Spreads.Global_Analysis_Active', value);
			});

			self.periodVisibilityEvent = ko.computed(function () {
				var entities = self.globalEntities();
				var years = self.selectedYears();

				_.each(entities, function (entity) {
					if (!ko.unwrap(entity.isBundleEntity)) {
						return;
					}
					
					_.each(entity.globalPeriods(), function (period) {
						var matchYear = _.filter(years, function (year) {
							return (year.year() == period.year());
						});

						period.isVisible(entity.isVisible() && matchYear.length > 0);
					});
				});
			});

			self.periodTotalVisibilityEvent = ko.computed(function () {
				var periodTotals = self.globalPeriodTotals();
				var years = self.selectedYears();

				_.each(periodTotals, function (periodTotal) {
					var matchYear = _.filter(years, function (year) {
						return (year.year() == periodTotal.year());
					});

					periodTotal.isVisible(matchYear.length > 0);
				});

				var visiblePeriodTotals = _.filter(periodTotals, function (periodTotal) {
					return periodTotal.isVisible();
				});
				self.selectedPeriodTotals(visiblePeriodTotals);
			});

			self.computeGlobalPeriodTotals = ko.computed(function () {
				self.globalPeriodTotals = new ko.observableArray();
				var entities = self.globalEntities();
				var years = self.globalYears();

				_.each(years, function (year) {
					var currentYear = year;
					var periodTotal = new app.GlobalPeriodTotal({
						year: currentYear.year()
					});

					_.each(entities, function (entity) {
						var matchPeriod = _.find(entity.globalPeriods(), function (period) {
							return period.year() == currentYear.year();
						});

						if (!_.isUndefined(matchPeriod)) {
							periodTotal.globalPeriods.push(matchPeriod);
						}
					});

					self.globalPeriodTotals.push(periodTotal);
				});

				_sortGlobalPeriodTotals();
			});

			self.globalScaleDivisor = ko.computed(function () {
				var globalScaleDivisor = 1;
				_.each(self.bundles(), function (bundle) {
					if (bundle.scaleDivisor() > globalScaleDivisor) {
						globalScaleDivisor = bundle.scaleDivisor();
					}
				});
				return globalScaleDivisor;
			});

			function _getInvolvement(bundle) {
				if (bundle.statements().length > 0) {
					for (var i = 0; i < bundle.statements().length; i++) {
						var statement = bundle.statements()[i];
						if (
							statement.spreads().length > 0 && !_.isUndefined(statement.spreads()[0].involvement)
						) {
							return statement.spreads()[0].involvement;
						}
					}
				}
			}

			function _getRecordTotalByGlobalAnalysisType(globalAnalysisType, bundle) {
				var selectedRecordTotal = LifeCycle.SpreadData.lookupRecordTotalsByProperty(
					'globalAnalysisType',
					globalAnalysisType,
					{
						filter: function (obj) {
							return obj.statement.bundle == bundle;
						}
					}
				);
				if (selectedRecordTotal.length > 1) {
					throw 'Multiple GA:' + globalAnalysisType + ' record totals in one bundle, unable to continue';
				} else if (selectedRecordTotal.length == 1) {
					return selectedRecordTotal[0];
				} else if (!selectedRecordTotal.length) {
					return null;
				}
			}

			function _generateGlobalAnalysis() {
				var gaEntities = [];
				var bundles = self.bundles();
				
				var service = new LifeCycle.SpreadData.GlobalAnalysisServices.TTMService(bundles);
				self.globalYears.push.apply(self.globalYears, service.ttmGlobalYears.filter(function (x) {
					return self.globalYears()
						.map(function (y) { return y.recordId(); })
						.indexOf(x.recordId()) === -1;
				}));
				
				self.globalScaleString(LifeCycle.SpreadData.FormattingService.formatScaleInToDisplayString(self.globalScaleDivisor(), true));
				_.each(bundles, function (bundle) {
					// Create the entity.

					var involvement = _getInvolvement(bundle);
					if (!involvement) {
						return;
					}

					var entityKey = involvement.recordId();
					var entityName = involvement.relationship.name();
					var globalEntity = gaEntities[entityKey];

					if (
						_.isUndefined(globalEntity) || !globalEntity
					) {
						globalEntity = new app.GlobalEntity({
							name: entityName,
							entityType: involvement.borrowerType(),
							model: involvement,
							accountId: bundle.container.recordId(),
							isBundleEntity: true
						});
						gaEntities[entityKey] = globalEntity;
					}

					var cashFlowRecordTotal = _getRecordTotalByGlobalAnalysisType(self.cashFlowLabel, bundle);
					var debtServiceRecordTotal = _getRecordTotalByGlobalAnalysisType(self.debtServiceLabel, bundle);

					self.isConfiguredForGlobalCashFlow(cashFlowRecordTotal && debtServiceRecordTotal);

					var totalAssetsRecordTotal = _getRecordTotalByGlobalAnalysisType(self.totalAssetsLabel, bundle);
					var totalLiabilitiesRecordTotal = _getRecordTotalByGlobalAnalysisType(self.totalLiabilitiesLabel, bundle);
					var totalEquityRecordTotal = _getRecordTotalByGlobalAnalysisType(self.totalEquityLabel, bundle);

					self.isConfiguredForGlobalLeverage(totalAssetsRecordTotal && totalLiabilitiesRecordTotal && totalEquityRecordTotal);

					var adjustedTotalAssetsRecordTotal = (_getRecordTotalByGlobalAnalysisType(self.adjustedTotalAssestsLabel, bundle)
														|| _getRecordTotalByGlobalAnalysisType(self.totalAssetsLabel, bundle));

					var adjustedTotalLiabilitiesRecordTotal = (_getRecordTotalByGlobalAnalysisType(self.adjustedTotalLiabilitiesLabel, bundle)
														|| _getRecordTotalByGlobalAnalysisType(self.totalLiabilitiesLabel, bundle));

					var adjustedTotalEquityRecordTotal = (_getRecordTotalByGlobalAnalysisType(self.adjustedTotalEquityLabel, bundle)
														|| _getRecordTotalByGlobalAnalysisType(self.totalEquityLabel, bundle));

					var periods = [];

					if(self.isConfiguredForGlobalLeverage()) {
						periods  = (totalAssetsRecordTotal.statement.periods() || totalLiabilitiesRecordTotal.statement.periods()
							|| totalEquityRecordTotal.statement.periods() || adjustedTotalAssetsRecordTotal.statement.periods()
							|| adjustedTotalLiabilitiesRecordTotal.statement.periods() || adjustedTotalEquityRecordTotal.statement.periods());
					} else if(self.isConfiguredForGlobalCashFlow()) {
						periods = (cashFlowRecordTotal.statement.periods() || debtServiceRecordTotal.statement.periods());
					}
					
					var ttmPeriods = service.getTTMGlobalPeriodsForBundle(bundle);
					_.each(periods, function (currentPeriod) {
							var globalYear;
							if (currentPeriod.isFiscalYear() || currentPeriod.periodType() == 'Trailing Twelve Month') {
								// Add a year if it doesn't exist yet
								var matchingYear = _.find(self.globalYears(), function (year) {
									return (
										year.year() == currentPeriod.year() &&
										!ko.unwrap(year.isTTM)
									) || (
										ko.unwrap(year.isTTM) &&
										LifeCycle.SpreadData.GlobalAnalysisServices.TTMService.getTTMKey(currentPeriod) &&
										year.recordId() == LifeCycle.SpreadData.GlobalAnalysisServices.TTMService.getTTMKey(currentPeriod)
									);
								});
								if (!_.isUndefined(matchingYear)) {
									globalYear = matchingYear;
									if (globalYear.selectedInGlobal() == false) {
										globalYear.selectedInGlobal(ko.unwrap(currentPeriod.isGlobalAnalysisYear));
									}
								} else {
									globalYear = new app.GlobalYear({
										year: currentPeriod.year(),
										selectedInGlobal: ko.unwrap(currentPeriod.isGlobalAnalysisYear)
									});
									self.globalYears.push(globalYear);
								}

								// If the current period is a fiscal year, then check to see if a period exists for it.
								var globalPeriod = null;
								var matchGlobalPeriod = _.find(globalEntity.globalPeriods(), function (period) {
									return (
										period.year() == currentPeriod.year() &&
										!ko.unwrap(period.isTTM)
									) || (
										ko.unwrap(period.isTTM) &&
										ko.unwrap(period.model.periodKey()) == currentPeriod.periodKey()
									);
								});
								if (!_.isUndefined(matchGlobalPeriod)) {
									globalPeriod = matchGlobalPeriod;
								} else {
									if (currentPeriod.periodType() == 'Trailing Twelve Month') {
										globalPeriod = ttmPeriods.find(function (x) {
											return x.model.periodKey() == currentPeriod.periodKey();
										});

										globalPeriod.selected(false);
										globalPeriod.selected = globalPeriod.isVisible = globalYear.selected = ko.computed({
											read: function () {
												return true;
											},
											write: function () {}
										});
									} else {
										globalPeriod = new app.GlobalPeriod({
											model: currentPeriod,
											year: globalYear.year(),
											source: currentPeriod.source(),
											recordId: currentPeriod.recordId(),
											statementDate: currentPeriod.statementDate()
										});
									}
									
									globalEntity.globalPeriods.push(globalPeriod);
								}

								// Check to see if the period exists within the global period.
								var fiscalPeriod = null;
								var matchFiscalPeriod = _.find(globalPeriod.availableSources(), function (period) {
									return period.source() == currentPeriod.source();
								});
								
								if (!_.isUndefined(matchFiscalPeriod)) {
									fiscalPeriod = matchFiscalPeriod;
								} else {
									fiscalPeriod = new app.GlobalPeriod({
										model: currentPeriod,
										year: globalYear.year(),
										source: currentPeriod.source(),
										recordId: currentPeriod.recordId()
									});
									globalPeriod.availableSources().push(fiscalPeriod);
									
									if (currentPeriod.isGlobalAnalysisYear()) {
										globalPeriod.selectedSource(fiscalPeriod);
									}
								}


								var scaledValue;
								if (self.isConfiguredForGlobalCashFlow()) {

									var cashFlowPeriodTotals = LifeCycle.SpreadData.lookupPeriodTotalByPeriodKey(
										currentPeriod.periodKey(),
										cashFlowRecordTotal.periodTotals()
									);
									var debtServicePeriodTotals = LifeCycle.SpreadData.lookupPeriodTotalByPeriodKey(
										currentPeriod.periodKey(),
										debtServiceRecordTotal.periodTotals()
									);


									if (cashFlowPeriodTotals.length) {
										scaledValue = LifeCycle.SpreadData.FormattingService.scaleValue(
											cashFlowPeriodTotals[0].value(),
											self.globalScaleDivisor()
										);
										globalPeriod.cashFlow(scaledValue);
										fiscalPeriod.cashFlow(scaledValue);
										cashFlowPeriodTotals[0].value.subscribe(function () {
											scaledValue = LifeCycle.SpreadData.FormattingService.scaleValue(
												cashFlowPeriodTotals[0].value(),
												self.globalScaleDivisor()
											);
											globalPeriod.cashFlow(scaledValue);
											fiscalPeriod.cashFlow(scaledValue);
										});
									}

									if (debtServicePeriodTotals.length) {
										scaledValue = LifeCycle.SpreadData.FormattingService.scaleValue(
											debtServicePeriodTotals[0].value(),
											self.globalScaleDivisor()
										);
										globalPeriod.debtService(scaledValue);
										fiscalPeriod.debtService(scaledValue);
										debtServicePeriodTotals[0].value.subscribe(function () {
											scaledValue = LifeCycle.SpreadData.FormattingService.scaleValue(
												debtServicePeriodTotals[0].value(),
												self.globalScaleDivisor()
											);
											globalPeriod.debtService(scaledValue);
											fiscalPeriod.debtService(scaledValue);
										});
									}
								}

								if (self.isConfiguredForGlobalLeverage()) {
									var totalAssetsPeriodTotals = LifeCycle.SpreadData.lookupPeriodTotalByPeriodKey(
										currentPeriod.periodKey(),
										totalAssetsRecordTotal.periodTotals()
									);

									var totalLiabilitiesPeriodTotals = LifeCycle.SpreadData.lookupPeriodTotalByPeriodKey(
										currentPeriod.periodKey(),
										totalLiabilitiesRecordTotal.periodTotals()
									)

									var totalEquityPeriodTotals = LifeCycle.SpreadData.lookupPeriodTotalByPeriodKey(
										currentPeriod.periodKey(),
										totalEquityRecordTotal.periodTotals()
									);


									if (totalAssetsPeriodTotals.length) {
										scaledValue = LifeCycle.SpreadData.FormattingService.scaleValue(
											totalAssetsPeriodTotals[0].value(),
											self.globalScaleDivisor()
										);
										globalPeriod.totalAssets(scaledValue);
										fiscalPeriod.totalAssets(scaledValue);
										totalAssetsPeriodTotals[0].value.subscribe(function () {
											scaledValue = LifeCycle.SpreadData.FormattingService.scaleValue(
												totalAssetsPeriodTotals[0].value(),
												self.globalScaleDivisor()
											);
											globalPeriod.totalAssets(scaledValue);
											fiscalPeriod.totalAssets(scaledValue);
										});
									}

									if (totalLiabilitiesPeriodTotals.length) {
										scaledValue = LifeCycle.SpreadData.FormattingService.scaleValue(
											totalLiabilitiesPeriodTotals[0].value(),
											self.globalScaleDivisor()
										);
										globalPeriod.totalLiabilities(scaledValue);
										fiscalPeriod.totalLiabilities(scaledValue);
										totalLiabilitiesPeriodTotals[0].value.subscribe(function () {
											scaledValue = LifeCycle.SpreadData.FormattingService.scaleValue(
												totalLiabilitiesPeriodTotals[0].value(),
												self.globalScaleDivisor()
											);
											globalPeriod.totalLiabilities(scaledValue);
											fiscalPeriod.totalLiabilities(scaledValue);
										});
									}

									if (totalEquityPeriodTotals.length) {
										scaledValue = LifeCycle.SpreadData.FormattingService.scaleValue(
											totalEquityPeriodTotals[0].value(),
											self.globalScaleDivisor()
										);
										globalPeriod.totalEquity(scaledValue);
										fiscalPeriod.totalEquity(scaledValue);
										totalEquityPeriodTotals[0].value.subscribe(function () {
											scaledValue = LifeCycle.SpreadData.FormattingService.scaleValue(
												totalEquityPeriodTotals[0].value(),
												self.globalScaleDivisor()
											);
											globalPeriod.totalEquity(scaledValue);
											fiscalPeriod.totalEquity(scaledValue);
										});
									}

									var adjustedTotalAssetsPeriodTotals = LifeCycle.SpreadData.lookupPeriodTotalByPeriodKey(
										currentPeriod.periodKey(),
										adjustedTotalAssetsRecordTotal.periodTotals()
									);

									var adjustedTotalLiabilitiesPeriodTotals = LifeCycle.SpreadData.lookupPeriodTotalByPeriodKey(
										currentPeriod.periodKey(),
										adjustedTotalLiabilitiesRecordTotal.periodTotals()
									);

									var adjustedTotalEquityPeriodTotals = LifeCycle.SpreadData.lookupPeriodTotalByPeriodKey(
										currentPeriod.periodKey(),
										adjustedTotalEquityRecordTotal.periodTotals()
									);

									if (adjustedTotalAssetsPeriodTotals.length) {
										scaledValue = LifeCycle.SpreadData.FormattingService.scaleValue(
											adjustedTotalAssetsPeriodTotals[0].value(),
											self.globalScaleDivisor()
										);
										globalPeriod.adjustedTotalAssets(scaledValue);
										fiscalPeriod.adjustedTotalAssets(scaledValue);
										adjustedTotalAssetsPeriodTotals[0].value.subscribe(function () {
											scaledValue = LifeCycle.SpreadData.FormattingService.scaleValue(
												adjustedTotalAssetsPeriodTotals[0].value(),
												self.globalScaleDivisor()
											);
											globalPeriod.adjustedTotalAssets(scaledValue);
											fiscalPeriod.adjustedTotalAssets(scaledValue);
										});
									}


									if (adjustedTotalLiabilitiesPeriodTotals.length) {
										scaledValue = LifeCycle.SpreadData.FormattingService.scaleValue(
											adjustedTotalLiabilitiesPeriodTotals[0].value(),
											self.globalScaleDivisor()
										);
										globalPeriod.adjustedTotalLiabilities(scaledValue);
										fiscalPeriod.adjustedTotalLiabilities(scaledValue);
										adjustedTotalLiabilitiesPeriodTotals[0].value.subscribe(function () {
											scaledValue = LifeCycle.SpreadData.FormattingService.scaleValue(
												adjustedTotalLiabilitiesPeriodTotals[0].value(),
												self.globalScaleDivisor()
											);
											globalPeriod.adjustedTotalLiabilities(scaledValue);
											fiscalPeriod.adjustedTotalLiabilities(scaledValue);
										});
									}


									if (adjustedTotalEquityPeriodTotals.length) {
										scaledValue = LifeCycle.SpreadData.FormattingService.scaleValue(
											adjustedTotalEquityPeriodTotals[0].value(),
											self.globalScaleDivisor()
										);
										globalPeriod.adjustedTotalEquity(scaledValue);
										fiscalPeriod.adjustedTotalEquity(scaledValue);
										adjustedTotalEquityPeriodTotals[0].value.subscribe(function () {
											scaledValue = LifeCycle.SpreadData.FormattingService.scaleValue(
												adjustedTotalEquityPeriodTotals[0].value(),
												self.globalScaleDivisor()
											);
											globalPeriod.adjustedTotalEquity(scaledValue);
											fiscalPeriod.adjustedTotalEquity(scaledValue);
										});
									}

								}

							}
						}
					);
				});
				
				// Update the observable arrays
				self.globalEntities.removeAll();
				for (var property in gaEntities) {
					if (gaEntities.hasOwnProperty(property)) {
						self.globalEntities.push(gaEntities[property]);
					}
				}

				//Insert related non-bundle entities
				for (var i = 0; i < self.relatedEntities().length; i++) {
					var entity = self.relatedEntities()[i];

					var exists = false;
					for (var j = 0; j < self.globalEntities().length; j++) {
						var existingEntity = self.globalEntities()[j];
						if (existingEntity.accountId() === ko.utils.unwrapObservable(entity.accountId)) {
							exists = true;
							break;
						}
					}
					if (exists) {
						continue;
					}

					self.globalEntities().push(new app.GlobalEntity({
						recordId: entity.recordId,
						accountId: entity.accountId,
						name: entity.name,
						selected: false,
						entityType: entity.borrowerType,
						isBundleEntity: false
					}));
				}

				// Backfill any years that weren't found in the statements.
				_backfillEntityPeriods();

				_sortGlobalEntities();
				_sortGlobalYears();
				self.loaded(true);
				if (!_.isUndefined(self.screenSection)) {
					ko.applyBindings(self, document.getElementById(self.screenSection.recordId()));
				}
			}

			function _backfillEntityPeriods() {
				_.each(self.globalYears(), function (year) {
					_.each(self.globalEntities(), function (entity) {
						var matchPeriod = _.find(entity.globalPeriods(), function (period) {
							return (
								year.year() == period.year() &&
								!ko.unwrap(year.isTTM) && !ko.unwrap(period.isTTM)
							) || (
								ko.unwrap(year.isTTM) &&
								LifeCycle.SpreadData.GlobalAnalysisServices.TTMService.getTTMKey(ko.unwrap(period.model)) &&
								year.recordId() == LifeCycle.SpreadData.GlobalAnalysisServices.TTMService.getTTMKey(ko.unwrap(period.model))
							);
						});

						// If a period was not found, then one needs to be created.
						if (_.isUndefined(matchPeriod)) {
							var newPeriod = new app.GlobalPeriod({
								year: year.year(),
								isTTM: ko.unwrap(year.isTTM),
								statementDate: ko.unwrap(year.statementDate)
							});
							
							newPeriod.selected = year.selected;
							newPeriod.isVisible = year.selected;
							
							entity.globalPeriods.push(newPeriod);
						}
					});
				});
			}

			// Exposed Entity Sorter
			self.entitySorter = function (a, b) {
				// First sort by bundle or non-bundle entity
				if (a.isBundleEntity() && !b.isBundleEntity()) {
					return -1;
				}
				if (b.isBundleEntity() && !a.isBundleEntity()) {
					return 1;
				}
				// Then sort by entity name
				return (a.name() < b.name() ? -1 : 1);
			};

			function _sortGlobalEntities() {
				self.globalEntities.sort(self.entitySorter);

				_.each(self.globalEntities(), function (entity) {
					_sortGlobalPeriods(entity);

					_.each(entity.globalPeriods(), function (globalPeriod) {
						_sortGlobalPeriodSources(globalPeriod);
					});
				});
			}

			function _sortGlobalPeriods(entity) {
				entity.globalPeriods.sort(function (a, b) {
					if (ko.unwrap(a.year) == ko.unwrap(b.year)) {
						if (b.isTTM() != a.isTTM()) {
							return b.isTTM() -  a.isTTM();
						}
						
						var aDate = new Date(ko.unwrap(a.statementDate));
						var bDate = new Date(ko.unwrap(b.statementDate));
						if (aDate.getMonth() == bDate.getMonth()) {
							return aDate.getDate() - bDate.getDate();
						} else {
							return aDate.getMonth() - bDate.getMonth();
						}
					}
					
					return a.year() - b.year();
				});
			}

			function _sortGlobalPeriodSources(globalPeriod) {
				globalPeriod.availableSources.sort(function (a, b) {
					return (a.source() < b.source() ? -1 : 1);
				});
			}

			function _sortGlobalYears() {
				self.globalYears.sort(function (a, b) {
					if (ko.unwrap(a.year) == ko.unwrap(b.year)) {
						if (b.isTTM() != a.isTTM()) {
							return b.isTTM() - a.isTTM();
						}
						
						if (ko.unwrap(a.month) == ko.unwrap(b.month)) {
							return ko.unwrap(a.date) - ko.unwrap(b.date);
						} else {
							return ko.unwrap(a.month) - ko.unwrap(b.month);
						}
					}
					
					return ko.unwrap(a.year) - ko.unwrap(b.year);
				});
			}

			function _sortGlobalPeriodTotals() {
				self.globalPeriodTotals.sort(function (a, b) {
					return (a.year() < b.year() ? -1 : 1);
				});
			}

			self.retrieve = function (data, success, remotingOptions) {
				self.remotingCallCount(self.remotingCallCount() + 1);
				LifeCycle.SpreadsService.retrieveIForce(
					data,
					data.recordId(),
					function (result, event) {
						app.mapFromJS(result, app.getMapping(), data);
						if (_.isFunction(success)) {
							self.remotingCallSuccessCount(self.remotingCallSuccessCount() + 1);
							success.apply(this, [result, event, data]);
						}
					},
					app.log.failure, remotingOptions, false);
			};

			self.loadGlobalAnalysis = function (bundles) {
				self.bundles(bundles);
				_generateGlobalAnalysis();
			};

			return self;
		};
	};
	if(!LifeCycle.GlobalAnalysis.ViewModel){
		LifeCycle.GlobalAnalysis.ViewModel = ViewModel;
	}
})();

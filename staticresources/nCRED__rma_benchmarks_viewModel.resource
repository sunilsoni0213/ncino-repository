(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			self.app = app;
			var defaultData = {
				bundle: '',
				selectedPeriodKey: '',
				rmaTable: '',
				industryBenchmarks: [],
				enableRMAButton: false,
				relationship: {},
				rmaKey: '',
				rmaURL: ''
			};
			if (data != undefined) {
				_.extend(defaultData, data);
			}

			app.mapFromJS(defaultData, app.getMapping(), self);

			self.spread = data.spread;
			self.open = ko.observable(false);
			self.viewType = ko.observable('sales');

			app.subscribeOnce('SPREAD.Spreads.Load_RMA_Statement', function (rmaBenchmarksParams) {
				var rmaBenchmarksVM = new app.ViewModel(rmaBenchmarksParams);
				rmaBenchmarksVM.loadRMABenchmarks(function(){
					app.publish('SPREAD.Spreads.RMA_Statement_Loaded', rmaBenchmarksVM);
				});
			});

			self.load = function() {
				app.subscribe('SPREAD.Spreads.Fullscreen_App_Opened', self.closeApp);
				app.subscribe('SPREAD.Spreads.Saved', self.loadRMABenchmarks);
				app.subscribe('SPREAD.Spreads.Fullscreen_App_Opened', self.removeToolTips);
				self.loadRMABenchmarks();
			};

			self.loadRMABenchmarks = function(callback) {
				if (ko.unwrap(self.relationship.recordId)) {
					LifeCycle.SpreadData.getRMA(
						ko.unwrap(self.relationship.recordId),
						undefined,
						function (result) {
							self.bundle(result);
							LifeCycle.SpreadData.getIForceById(self.relationship.recordId(), {}, function(relationship) {
								self.relationship = relationship;
								self.selectedPeriodKey(_getLatestFiscalYear(self.bundle()));
								if (self.relationship.naicsCode()) {
									self.enableRMAButton(true);
									self.loadRMAData(callback);
								} else {
									jQuery('#rma_button_label').tooltip({
										trigger: 'hover',
										placement: 'left',
										title: 'NAICS code is not set on ' + self.relationship.name(),
										container: 'body'
									});
								}
							});
						}
					);
				}
			};

			self.toggle = function(data, e){
				if (!self.spread.navApp.viewModel.savePending()) {
					app.publish("SPREAD.Spreads.Fullscreen_App_Opened", self.app.appId);
					if ( typeof key !== "undefined") {
						if(self.open()){
							key.setScope('nav');
						}else{
							key.setScope('rma');
						}
					}
					self.open(!self.open());
					if (self.open()) {
						if(jQuery('.main_spreading').is(':visible')){
							jQuery('.main_spreading, .spread-footnotes').hide();
							jQuery('.nav .current-spread').removeClass('active');
						}
						self.setTooltips();
					} else if (!self.open() && jQuery('.main_spreading').is(':hidden')) {
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

			self.showRmaByType = function(selectedViewType){

				if(!self.open()) {
					self.toggle();
				} else {
					if(self.viewType() == selectedViewType){
						self.toggle();
					}
				}
				self.viewType(selectedViewType);

				setTimeout(function(){
					jQuery(".rma_warning").each( function(index, element){
						jQuery(element).mouseenter();
					});
				}, 3000);
			};

			self.removeToolTips = function () {
				jQuery('.rma-tooltip').remove();
			};

			self.loadRMAData = function(callback) {
				LifeCycle.SpreadData.RMAServices.DataService.getBenchmarkData(
					self.relationship.naicsCode(),
					2016,
					0,
					self.rmaURL(),
					self.rmaKey()
				).then(function (result) {
					var data = {};
					data.industryBenchmarks = result;
					app.mapFromJS(data, app.getMapping(), self);
					self.rmaTable(_generateRMATable(
						self.industryBenchmarks(), self.bundle().recordId(), self.selectedPeriodKey()));
					self.generateWarnings();
					if(_.isFunction(callback)){
						callback.apply();
					}
				});
			};

			self.setTooltips = function() {
				var table = self.rmaTable();
				if(table){
					_addTooltip(jQuery('#rel_cash'), table.cashAndEquivalentsWarnings());
					_addTooltip(jQuery('#rel_tca'), table.totalCurrentAssetsWarnings());
					_addTooltip(jQuery('#rel_total_assets'), table.totalAssetsWarnings());
					_addTooltip(jQuery('#rel_tcl'), table.totalCurrentLiabilitiesWarnings());
					_addTooltip(jQuery('#rel_net_worth'), table.totalEquityWarnings());
					_addTooltip(jQuery('#rel_total_liabilities'), table.totalLiabilitiesAndNetWorthWarnings());
					_addTooltip(jQuery('#rel_profit_before_taxes'), table.profitBeforeTaxesWarnings());
					_addTooltip(jQuery('#rel_current'), table.currentRatioWarnings());
					_addTooltip(jQuery('#rel_quick'), table.quickRatioWarnings());
					_addTooltip(jQuery('#rel_sales_receivables'), table.salesToReceivablesWarnings());
					_addTooltip(jQuery('#rel_sales_cost_inventory'), table.costOfSalesToInventoryWarnings());
					_addTooltip(jQuery('#rel_sales_cost_payables'), table.costOfSalesToPayablesWarnings());
					_addTooltip(jQuery('#rel_sales_working_capital'), table.salesToWorkingCapitalWarnings());
					_addTooltip(jQuery('#rel_ebit_interest'), table.ebitToInterestWarnings());
					_addTooltip(jQuery('#rel_cash_flow_debt'), table.cashFlowToDebtWarnings());
					_addTooltip(jQuery('#rel_fixed_worth'), table.fixedToWorthWarnings());
					_addTooltip(jQuery('#rel_debt_worth'), table.debtToWorthWarnings());
					_addTooltip(jQuery('#rel_profit_net_worth'), table.profitToNetWorthWarnings());
					_addTooltip(jQuery('#rel_profit_assets'), table.profitToTotalAssetsWarnings());
					_addTooltip(jQuery('#rel_sales_fixed_assets'), table.salesToFixedAssetsWarnings());
					_addTooltip(jQuery('#rel_sales_total_assets'), table.salesToTotalAssetsWarnings());
					_addTooltip(jQuery('#rel_depreciation_sales'), table.depreciationToSalesWarnings());
					_addTooltip(jQuery('#rel_comp_sales'), table.compToSalesWarnings());
					_addTooltip(jQuery('#rel_net_sales'), table.netSalesWarnings());
					_addTooltip(jQuery('#rel_assets'), table.assetsWarnings());
				}
			};

			self.generateWarnings = function() {
				var rService = LifeCycle.SpreadData.RMAServices.RatioService;
				var bundleId = self.bundle().recordId();
				var periodKey = self.selectedPeriodKey();
				var table = self.rmaTable();

				if (!rService.cashAndEquivalents(bundleId, periodKey)) {
					var cash = 'Cash and Equivalents';
					table.cashAndEquivalentsWarnings.push(cash);
					table.quickRatioWarnings.push(cash);
				}

				if (!rService.totalCurrentAssets(bundleId, periodKey)) {
					var currentAssets = 'Current Assets';
					table.totalCurrentAssetsWarnings.push(currentAssets);
					table.totalAssetsWarnings.push(currentAssets);
					table.totalEquityWarnings.push(currentAssets);
					table.currentRatioWarnings.push(currentAssets);
					table.profitToTotalAssetsWarnings.push(currentAssets);
					table.salesToTotalAssetsWarnings.push(currentAssets);
					table.assetsWarnings.push(currentAssets);
				}

				if (!rService.totalNonCurrentAssets(bundleId, periodKey)) {
					var nonCurrentAssets = 'Non-Current Assets';
					table.totalEquityWarnings.push(nonCurrentAssets);
					table.totalAssetsWarnings.push(nonCurrentAssets);
					table.profitToTotalAssetsWarnings.push(nonCurrentAssets);
					table.salesToTotalAssetsWarnings.push(nonCurrentAssets);
					table.assetsWarnings.push(nonCurrentAssets);
				}

				if (!rService.totalCurrentLiabilities(bundleId, periodKey)) {
					var currentLiabilities = 'Current Liabilities';
					table.totalCurrentLiabilitiesWarnings.push(currentLiabilities);
					table.totalLiabilitiesAndNetWorthWarnings.push(currentLiabilities);
					table.totalEquityWarnings.push(currentLiabilities);
					table.currentRatioWarnings.push(currentLiabilities);
					table.quickRatioWarnings.push(currentLiabilities);
					table.debtToWorthWarnings.push(currentLiabilities);
				}

				if (!rService.totalNonCurrentLiabilities(bundleId, periodKey)) {
					var nonCurrentLiabilities = 'Non-Current Liabilities';
					table.totalLiabilitiesAndNetWorthWarnings.push(nonCurrentLiabilities);
					table.totalEquityWarnings.push(nonCurrentLiabilities);
					table.debtToWorthWarnings.push(nonCurrentLiabilities);
				}

				if (!rService.totalEquity(bundleId, periodKey)) {
					var netWorth = 'Net Worth';
					table.totalEquityWarnings.push(netWorth);
					table.totalLiabilitiesAndNetWorthWarnings.push(netWorth);
				}

				if (!rService.netProfit(bundleId, periodKey)) {
					var netProfit = 'Net Profit';
					table.profitBeforeTaxesWarnings.push(netProfit);
					table.ebitToInterestWarnings.push(netProfit);
					table.cashFlowToDebtWarnings.push(netProfit);
					table.profitToNetWorthWarnings.push(netProfit);
					table.profitToTotalAssetsWarnings.push(netProfit);
				}

				if (!rService.workingCapital(bundleId, periodKey)) {
					var workingCapital = 'Working Capital';
					table.salesToWorkingCapitalWarnings.push(workingCapital);
				}

				if (!rService.tangibleNetWorth(bundleId, periodKey)) {
					var tangibleNetWorth = 'Tangible Net Worth';
					table.fixedToWorthWarnings.push(tangibleNetWorth);
					table.debtToWorthWarnings.push(tangibleNetWorth);
					table.profitToNetWorthWarnings.push(tangibleNetWorth);
				}

				if (!rService.getClassificationValue(bundleId, periodKey, 'income_taxes')) {
					var incomeTax = 'Income Taxes';
					table.profitBeforeTaxesWarnings.push(incomeTax);
					table.ebitToInterestWarnings.push(incomeTax);
					table.profitToNetWorthWarnings.push(incomeTax);
					table.profitToTotalAssetsWarnings.push(incomeTax);
				}

				if (!rService.getClassificationValue(bundleId, periodKey, 'sales_net')) {
					var sales = 'Sales (net)';
					table.salesToReceivablesWarnings.push(sales);
					table.salesToWorkingCapitalWarnings.push(sales);
					table.salesToFixedAssetsWarnings.push(sales);
					table.salesToTotalAssetsWarnings.push(sales);
					table.depreciationToSalesWarnings.push(sales);
					table.compToSalesWarnings.push(sales);
					table.netSalesWarnings.push(sales);
				}

				if (!rService.getClassificationValue(bundleId, periodKey, 'trade_receivables_net')) {
					var receivables = 'Trade Receivables (net)';
					table.salesToReceivablesWarnings.push(receivables);
				}

				if (!rService.getClassificationValue(bundleId, periodKey, 'cost_of_sales')) {
					var costOfSales = 'Cost of Sales';
					table.costOfSalesToInventoryWarnings.push(costOfSales);
					table.costOfSalesToPayablesWarnings.push(costOfSales);
				}

				if (!rService.getClassificationValue(bundleId, periodKey, 'inventory')) {
					var inventory = 'Inventory';
					table.costOfSalesToInventoryWarnings.push(inventory);
				}

				if (!rService.getClassificationValue(bundleId, periodKey, 'trade_payables')) {
					var payables = 'Trade Payables';
					table.costOfSalesToPayablesWarnings.push(payables);
				}

				if (!rService.getClassificationValue(bundleId, periodKey, 'interest_expense')) {
					var interestExpense = 'Interest Expense';
					table.ebitToInterestWarnings.push(interestExpense);
				}

				if (!rService.getClassificationValue(bundleId, periodKey, 'depreciation')) {
					var depreciation = 'Depreciation';
					table.cashFlowToDebtWarnings.push(depreciation);
					table.depreciationToSalesWarnings.push(depreciation);
				}

				if (!rService.getClassificationValue(bundleId, periodKey, 'depletion')) {
					var depletion = 'Depletion';
					table.cashFlowToDebtWarnings.push(depletion);
					table.depreciationToSalesWarnings.push(depletion);
				}

				if (!rService.getClassificationValue(bundleId, periodKey, 'amortization')) {
					var amortization = 'Amortization';
					table.cashFlowToDebtWarnings.push(amortization);
					table.depreciationToSalesWarnings.push(amortization);
				}

				if (!rService.getClassificationValue(bundleId, periodKey, 'long_term_debt')) {
					var ltd = 'Long Term Debt';
					table.cashFlowToDebtWarnings.push(ltd);
				}

				if (!rService.getClassificationValue(bundleId, periodKey, 'fixed_assets_net')) {
					var fixedAssets = 'Fixed Assets (net)';
					table.fixedToWorthWarnings.push(fixedAssets);
					table.salesToFixedAssetsWarnings.push(fixedAssets);
				}

				if (!rService.getClassificationValue(bundleId, periodKey, 'officers_directors_owners_compensation')) {
					var comp = 'Officers\', Directors\', Owners\' Compensation';
					table.compToSalesWarnings.push(comp);
				}
			};

			function _generateWarningMessage(classifications) {
				if (classifications.length === 1) {
					return classifications[0] + ' is not configured.';
				}

				var message;

				if (classifications.length === 2) {
					message = classifications.join(' and ');
				} else {
					var lastItem = classifications.pop();
					message = classifications.join(', ');
					message += ', and ' + lastItem;
				}

				return message + ' are not configured.';
			}

			function _addTooltip(element, classifications) {
				if (classifications.length) {
					var message = _generateWarningMessage(classifications);
					element.addClass('rma_warning');
					element.tooltip({
						trigger: 'hover focus',
						placement: 'right',
						title: message,
						container: 'body',
						template : '<div class="tooltip rma-tooltip" role="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>'
					});
				}
			}
			self.closeApp = function(e){
				if (e !== self.app.appId) {
					self.open(false);
				}
			};

			function _getLastThreeYears(historicalColumns) {
				return (ko.unwrap(historicalColumns.SizeCd) < 5 && ko.unwrap(historicalColumns.SizeCd) > 1);
			}

			function _getLatestFiscalYear(bundle) {
				for (var i = 0; i < bundle.statements().length; i++) {
					var statement = bundle.statements()[i];
					if (statement.isIncomeStatement() || statement.isBalanceSheet()) {
						var periodKeys = statement.periods().filter(function(period) {
							return period.isFiscalYear();})
							.map(function(period) {
								return period.periodKey();})
							.sort();
						return periodKeys.pop();
					}
				}
			}

			function _generateRMATable(benchmarks, bundleId, periodKey) {
				var table = new app.RMATable();
				table.historical(_getDataSet('H', benchmarks));
				table.historical(table.historical().filter(_getLastThreeYears));
				table.assets(_getDataSet('A', benchmarks));
				table.sales(_getDataSet('S', benchmarks));
				table.relationshipData(_getRelationshipData(bundleId, periodKey));
				return table;
			}

			function _getDataSet(setType, benchmarks) {
				var set = benchmarks.filter(function(benchmark) {
					return (ko.unwrap(benchmark.Sectionn) == setType);
				});
				set = set.sort(function (left, right) {
					return ko.unwrap(left.SizeCd) - ko.unwrap(right.SizeCd);
				});
				return set;
			}

			function _getRelationshipData(bundleId, periodKey) {
				var rcData = new app.RMAColumn();
				var rService = LifeCycle.SpreadData.RMAServices.RatioService;
				var totAssets = rService.totalAssets(bundleId, periodKey);
				var sales = rService.getClassificationValue(bundleId, periodKey, 'sales_net');
				rcData.Cash(rService.cashAndEquivalents(bundleId, periodKey, totAssets));
				rcData.Artrade(rService.getClassificationValue(
					bundleId, periodKey, 'trade_receivables_net', totAssets));
				rcData.Inv(rService.getClassificationValue(bundleId, periodKey, 'inventory', totAssets));
				rcData.Aocurra(rService.getClassificationValue(
					bundleId, periodKey, 'other_current_assets', totAssets));
				rcData.Totcurra(rService.totalCurrentAssets(bundleId, periodKey, totAssets));
				rcData.Fixeda(rService.getClassificationValue(bundleId, periodKey, 'fixed_assets_net', totAssets));
				rcData.Intang(rService.getClassificationValue(bundleId, periodKey, 'intangibles_net', totAssets));
				rcData.Aononcurra(rService.getClassificationValue(
					bundleId, periodKey, 'other_non_current_assets', totAssets));
				rcData.Totala(rService.totalAssets(bundleId, periodKey, totAssets));
				rcData.Notespy(rService.getClassificationValue(
					bundleId, periodKey, 'notes_payable_short_term', totAssets));
				rcData.Currmat(rService.getClassificationValue(
					bundleId, periodKey, 'current_portion_of_long_term_debt', totAssets));
				rcData.Aptrade(rService.getClassificationValue(bundleId, periodKey, 'trade_payables', totAssets));
				rcData.Aptax(rService.getClassificationValue(
					bundleId, periodKey, 'income_taxes_payable', totAssets));
				rcData.Aocurrl(rService.getClassificationValue(
					bundleId, periodKey, 'other_current_liabilities', totAssets));
				rcData.Totcurrl(rService.totalCurrentLiabilities(bundleId, periodKey, totAssets));
				rcData.Ltd(rService.getClassificationValue(bundleId, periodKey, 'long_term_debt', totAssets));
				rcData.Deftax(rService.getClassificationValue(bundleId, periodKey, 'deferred_taxes', totAssets));
				rcData.Aononcurrl(rService.getClassificationValue(
					bundleId, periodKey, 'other_non_current_liabilites', totAssets));
				rcData.Netwrth(rService.totalEquity(bundleId, periodKey, totAssets));
				rcData.Totallnw(rService.totalLiabilitiesAndNetWorth(bundleId, periodKey, totAssets));
				rcData.Sales(rService.getClassificationValue(bundleId, periodKey, 'sales_net', sales));
				rcData.Grproft(rService.getClassificationValue(bundleId, periodKey, 'gross_profit', sales));
				rcData.Opexp(rService.getClassificationValue(
					bundleId, periodKey, 'total_operating_expenses', sales));
				rcData.Opproft(rService.getClassificationValue(bundleId, periodKey, 'operating_profit', sales));
				rcData.Aoexp(rService.getClassificationValue(bundleId, periodKey, 'other_expenses', sales));
				rcData.Proftbtax(rService.profitBeforeTax(bundleId, periodKey, sales));
				rcData.CurrM(rService.currentRatio(bundleId, periodKey));
				rcData.QuickM(rService.quickRatio(bundleId, periodKey));
				rcData.SalesarM(rService.salesToReceivables(bundleId, periodKey));
				rcData.SalesarDM(rService.daysReceivables(bundleId, periodKey));
				rcData.CosinvM(rService.costOfSalesToInventory(bundleId, periodKey));
				rcData.CosinvDM(rService.daysInventory(bundleId, periodKey));
				rcData.CosapM(rService.costOfSalesToPayables(bundleId, periodKey));
				rcData.CosapDM(rService.daysPayables(bundleId, periodKey));
				rcData.SaleswcapM(rService.salesToWorkingCapital(bundleId, periodKey));
				rcData.EbitintM(rService.ebitToInterest(bundleId, periodKey));
				rcData.CflowcdebtM(rService.cashFlowToDebt(bundleId, periodKey));
				rcData.FixedwrthM(rService.fixedToWorth(bundleId, periodKey));
				rcData.DebtwrthM(rService.debtToWorth(bundleId, periodKey));
				rcData.PbttnwM(rService.profitToNetWorth(bundleId, periodKey));
				rcData.PbttotassM(rService.profitToTotalAssets(bundleId, periodKey));
				rcData.SalesfixedM(rService.salesToFixedAssets(bundleId, periodKey));
				rcData.SalestotassM(rService.salesToTotalAssets(bundleId, periodKey));
				rcData.DdasalesM(rService.depreciationToSales(bundleId, periodKey));
				rcData.OffcompsalesM(rService.compToSales(bundleId, periodKey));
				rcData.DllrSales(sales);
				rcData.DllrAssets(totAssets);
				return rcData;
			}

			return self;
		};
		app.log('ViewModel initialized.');
	};

	if(LifeCycle.RmaBenchmarks.ViewModel === undefined){
		LifeCycle.RmaBenchmarks.ViewModel = ViewModel;
	}
})();

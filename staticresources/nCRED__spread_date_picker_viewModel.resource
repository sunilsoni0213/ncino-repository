(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;

			self.app = app;
			self.MONTHS = 'months';
			self.QUARTERS = 'quarters';
			self.YEARS = 'years';
			self.COLUMNS = 'columns';
			var saveEnabled = false;

			var defaultData = {
				years: ko.observableArray([]),
				currentYear: ko.observable(''),
				showOperations: false,
				commonSizingEnabled: false,
				displayTrendEnabled: false,
				columnCategoryByYear: null,
				availableSources: null,
				headerRecordTotalId: null,
				bEditable: false,
				bColumnSourceEditable: false,
				bConfigurable: false,
				bundle: null,
				bundleLoaded: false
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}

			app.mapFromJS(defaultData, app.getMapping(), self);

			self.bundle = LifeCycle.SpreadData.lookupBundleById(self.bundle.recordId(), {
				alwaysReturnModel: true,
				generatePlaceholder: true,
				placeholderType: 'c.LifeCycleUnderwritingBundle'
			});
			self.showFootnotes = self.bundle.showFootnotes;

			self.periodAnalystOptions = data.periodAnalystOptions;

			self.debtScheduleOpen = ko.observable(false);

			self.getColumnProperties = function(year, month, numberOfPeriods, source){
				var yearIndex = null;
				var columnIndex = null;
				yearsLoop:
				for(i=0;i<self.years().length;i++){
					if(self.years()[i].year != year){
						continue;
					}else{
						for(j=0;j<self.years()[i].columns().length;j++){
							var currentColumn = self.years()[i].columns()[j];
							
							if(currentColumn.year == year
								&& currentColumn.month == month
								&& currentColumn.numberOfPeriods == numberOfPeriods
								&& currentColumn.source() == source){

								yearIndex = i;
								columnIndex = j;
								break yearsLoop;
							}
						}
					}
				}
				return {
					'yearIndex': yearIndex,
					'columnIndex': columnIndex
				};
			}

			self.clearCacheForCategorizedColsByYear = function(){
				self.columnCategoryByYear = null;
			};

			self.staticPeriodColumnYearMap = { year: undefined };
			self.staticPeriodNonCalcColumnYearMap = {};
			self.selectedYear = ko.observable();
			self.availableYears = ko.observableArray();

			self.setColumnCategoryByYear = function(columnByYearMap, bForceRemap, optionalSSReference){
				if(!self.spread.bStaticPeriods && (self.columnCategoryByYear == null || bForceRemap)){
					self.columnCategoryByYear = columnByYearMap;

					var years = [];
					_.each(columnByYearMap, function(yearColumn){
						years.push(new app.Year(yearColumn));
					});

					self.years(years);
					self.onBundleLoaded(self.bundle);
					optionalSSReference.showHideColumns(self.getCurrentSelectedColumns(), true);
				}else if(self.spread.bStaticPeriods){
					var aiColumnsToShow = [];
					var nonCalcColumns = [];
					var recordTotalId = optionalSSReference.sRecordTotalId;
					if(typeof self.staticPeriodColumnYearMap[recordTotalId] == "undefined"){
						self.staticPeriodColumnYearMap[recordTotalId] = {};
					}
					if(typeof self.staticPeriodNonCalcColumnYearMap[recordTotalId] == "undefined"){
						self.staticPeriodNonCalcColumnYearMap[recordTotalId] = {};
					}
					_.each(columnByYearMap, function(yearColumn){
						var year = yearColumn.year;
						if(!_.contains(self.availableYears(), year)){
							self.availableYears.push(year);
						}
						var selectedYear;
						if(typeof self.staticPeriodColumnYearMap[recordTotalId][year] == "undefined"){
							self.staticPeriodColumnYearMap[recordTotalId][year] = [];
						}
						if(typeof self.staticPeriodNonCalcColumnYearMap[recordTotalId][year] == "undefined"){
							self.staticPeriodNonCalcColumnYearMap[recordTotalId][year] = [];
						}
						_.each(yearColumn.columns, function(column){
							aiColumnsToShow.push(column.index);
							nonCalcColumns.push(column.index);
							if(column.selected == true){
								if(typeof self.staticPeriodColumnYearMap.selectedYear === "undefined"){
									self.staticPeriodColumnYearMap.selectedYear = year;
								}
							}
							if(typeof self.staticPeriodNonCalcColumnYearMap.selectedYear === "undefined"){
								self.staticPeriodNonCalcColumnYearMap.selectedYear = year;
							}
						});					
						_.each(yearColumn.per_unit_operating_expense, function(column){
							if(column.selected == true){
								aiColumnsToShow.push(column.index);
							}
						});
						_.each(yearColumn.percent_pgi, function(column){
							if(column.selected == true){
								aiColumnsToShow.push(column.index);
							}
						});
						self.staticPeriodColumnYearMap[recordTotalId][year] =
							self.staticPeriodColumnYearMap[recordTotalId][year].concat(aiColumnsToShow);
						self.staticPeriodNonCalcColumnYearMap[recordTotalId][year] =
							self.staticPeriodNonCalcColumnYearMap[recordTotalId][year].concat(nonCalcColumns);
						aiColumnsToShow = [];
						nonCalcColumns = [];
					});
				}
			};

			self.toggleYear = function(year){
				self.selectedYear(year);
			};

			self.getSelectedYear = function(){
				if(typeof self.selectedYear() === "undefined"){
					self.selectedYear(self.staticPeriodColumnYearMap.selectedYear);
				}
				return self.selectedYear();
			};

			self.selectedYear.subscribe(function(newYear){
				app.publish('SPREAD.Spreads.Rent_Roll.UpdateYear', newYear);
				var colTotMap = self.staticPeriodColumnYearMap;
				_.each(colTotMap, function(value, key){
					_.each(value, function(colsToShow, year){
						if(year == newYear){
							app.viewModel.spread.showHideColumns(colsToShow, true, key);
						}else{
							app.viewModel.spread.showHideColumns(colsToShow, false, key);
						}
					});
				});
			});

			self.getCategorizedColsByYear = function(bIgnoreCache){
				if(!_.isEmpty(app.viewModel.spread)){
					if(self.columnCategoryByYear == null || bIgnoreCache){
						self.columnCategoryByYear = app.viewModel.spread.getCategorizedColsByYear();
					}
				}
				return self.columnCategoryByYear;
			};

			self.determineCommonSizingIndexes = function(iCols, ignoreSelected, optionalSSReference){
				var csColumnIndexes = [];
				var spreadJSReference = app.viewModel.spread;
				if (optionalSSReference) {
					spreadJSReference = optionalSSReference;
				}
				var categorizedCols = spreadJSReference.getCategorizedCols();
				var commonSizingCols = categorizedCols['common_sizing'];
				_.each(commonSizingCols, function(csCol){
					if (!iCols || iCols.indexOf(csCol - 1) != -1) {
						Utils.addToArrayIfNotExists(csColumnIndexes, csCol);
					}
				});
				return csColumnIndexes;
			};

			self.determineTrendIndexes = function(iCols, ignoreSelected, optionalSSReference){
				var trendIndexes = [];
				var spreadJSReference = app.viewModel.spread;
				if (optionalSSReference) {
					spreadJSReference = optionalSSReference;
				}
				var trendCols = spreadJSReference.getValidTrendCols(ignoreSelected);
				_.each(trendCols, function(trendCol){
					if (!iCols || iCols.indexOf(trendCol + 1) != -1) {
						Utils.addToArrayIfNotExists(trendIndexes, trendCol);
					}
					if (!iCols || iCols.indexOf(trendCol - 2) != -1) {
						Utils.addToArrayIfNotExists(trendIndexes, trendCol);
					}
				});
				return trendIndexes;
			};

			self.determineNOIStatementOperatingExpensesIndexes = function(iCols, ignoreSelected, optionalSSReference){
				var noiColumnIndexes = [];
				var spreadJSReference = app.viewModel.spread;
				if (optionalSSReference) {
					spreadJSReference = optionalSSReference;
				}
				var categorizedCols = spreadJSReference.getCategorizedCols();
				var noiCalculatedColumns = categorizedCols['per_unit_operating_expense'];
				_.each(noiCalculatedColumns, function(noiCol){
					if (!iCols || iCols.indexOf(noiCol - 1) != -1) {
						Utils.addToArrayIfNotExists(noiColumnIndexes, noiCol);
					}
				});
				noiCalculatedColumns = categorizedCols['percent_pgi'];
				_.each(noiCalculatedColumns, function(noiCol){
					if (!iCols || iCols.indexOf(noiCol - 2) != -1) {
						Utils.addToArrayIfNotExists(noiColumnIndexes, noiCol);
					}
				});
				return noiColumnIndexes;
			};

			self.headerRecordTotalId.subscribe(function(recordTotalId){
				app.viewModel.spread.showHeaderForAdditionalDataPoints(recordTotalId);
			});

			self.refreshHeaderForAdditionalDataPoints = function(){
				app.viewModel.spread.showHeaderForAdditionalDataPoints(self.headerRecordTotalId());
			};

			self.spreadStatement.displayCommonSizing.subscribe(function(val){
				app.viewModel.spread.showHideColumns(
					self.determineCommonSizingIndexes(self.getCurrentSelectedColumns()), val);

				self.spreadStatement.save();
			});
			self.spreadStatement.displayTrend.subscribe(function(val){
				app.viewModel.spread.showHideColumns(
					self.determineTrendIndexes(self.getCurrentSelectedColumns()), val);

				self.spreadStatement.save();
			});
			
			self.showOperations.subscribe(function(val){
				jQuery('.main_spreading').find(".operation, .action_item_link, .action_item_calc_link, .action_item_edit, .action_item_kpi").each(function(index, elem){ 
					jQuery(elem).toggle(val); 
				});
			});

			self.getCurrentSelectedColumns = function(recordTotalId){
				var currentSelectedColumns = [];
				
				_.each(self.years(), function(currentYear){
					var currentYearSelected = [];
					_.each(currentYear.columns(), function(currentColumn){
						if(currentColumn.selected()){
							if(typeof currentColumn['index'] != 'undefined'){
								Utils.addToArrayIfNotExists(currentSelectedColumns, currentColumn['index']);
							}
						}
					});
				});
				return currentSelectedColumns;
			};

			self.getVisibleColumns = function(optionalSSReference){
				var columnsToShow = [];
				var recordTotalId;
				if(typeof optionalSSReference !== "undefined"){
					recordTotalId = optionalSSReference.sRecordTotalId;
				}
				columnsToShow = columnsToShow.concat(self.getCurrentSelectedColumns(recordTotalId));
				if(self.spreadStatement.displayCommonSizing()){
					columnsToShow = columnsToShow.concat(
						self.determineCommonSizingIndexes(self.getCurrentSelectedColumns(), false, optionalSSReference)
					);
				}
				if(self.spreadStatement.displayTrend()){
					columnsToShow = columnsToShow.concat(
						self.determineTrendIndexes(self.getCurrentSelectedColumns(), false, optionalSSReference)
					);
				}
				if(!_.isUndefined(optionalSSReference) && optionalSSReference.bIsNOIStatementOperatingExpenses){
					columnsToShow = columnsToShow.concat(
						self.determineNOIStatementOperatingExpensesIndexes(self.getCurrentSelectedColumns(), false, optionalSSReference)
					);
				}
				return columnsToShow;
			}

			self.refreshStatementsColumnVisibility =function(optionalSSReference){
				app.viewModel.spread.showHideColumns(self.getVisibleColumns(optionalSSReference), true);
			}

			self.hasPeriods = ko.computed(function(){
				return self.years().length > 0;
			});

			self.enableMenu = ko.computed(function(){
				return self.hasPeriods() || self.spread.bIsTemplate;
			});

			self.statementHasPeriodsButNotSelected = ko.computed(function(){
				return self.getCurrentSelectedColumns().length == 0 && self.hasPeriods();
			});

			self.showFootnotes.subscribe(function(value) {
				app.publish('SPREAD.Spreads.Configuration_Changed', {
					'name': LifeCycle.msgs.msg_configuration_show_footnotes, 
					'value': value });

				if (ko.unwrap(self.bundleLoaded) && self.validate(self.bundle)) {
					self.bundle.showFootnotes(value);
					self.saveBundle();
				}
			});

			self.validate = function(data) {
				return !_.isUndefined(data) && !_.isEmpty(ko.unwrap(data.recordId));
			};


			self.load = function(){
				app.subscribe('SPREAD.Spreads.Add_Rent_Roll_Scenario', function(newYear){
					var year = new Date(newYear).getFullYear();
					self.selectedYear(year);
				});
				try{
					if (self.validate(self.bundle)) {
					}
				}catch(e){
					app.log.failure(null, e);
				}
			};

			self.onBundleLoaded = function(result) {
				if (ko.unwrap(self.showFootnotes) != ko.unwrap(self.bundle.showFootnotes)) {
					self.showFootnotes(ko.unwrap(self.bundle.showFootnotes));
				}
				self.bundleLoaded(true);
			};

			self.saveBundle = function() {
				try{
					if(ko.unwrap(self.bundleLoaded) && self.validate(self.bundle)){
						app.performingAjax(true);

						var saveData = app.mapToJS(self.bundle, { useOptimizedMapper: true, maxDepth: 0 });
						LifeCycle.SpreadsService.saveIForce(
							saveData,
							function(result, event){
								app.performingAjax(false);
							},
							app.log.failure
						);
					}
				}catch(e){
					app.log.failure(null, e);
					app.performingAjax(false);
				}
			};

			app.log('ViewModel instantiated.');
			return self;
		}
		app.log('ViewModel initialized.');
	};
	if(LifeCycle.SpreadDatePicker.ViewModel == undefined){
		LifeCycle.SpreadDatePicker.ViewModel = ViewModel;
	}
})();

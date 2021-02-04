(function(){
	var Models = function(event, app){
		var defaultModelData = {
			recordId : null,
			name : '',
			isLoaded : false,
			isSaved : false,
			disabled: false
		};

		app.Year = function(data){
			var self = this;
			var defaultData = {
				year: '',
				columns: ko.observableArray([])
			};

			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			return self;
		}

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
			return self;
		};

		app.Column = function(data){
			var self = this;
			var defaultData = {
				apexType: app.mapApexFromModel('spreadStatementPeriod'),
				name: '',
				statementId: null,
				statementDate: '',
				numberOfPeriods : null,
				source: null,
				analyst: null,
				columnNumber: null,
				month: null,
				quarter: null,
				year: null,
				nameOverride: '',
				selected: ko.observable(false),
				type: 'column',
				index: null,
			};
			
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.selected.subscribe(function(selected){
				var affectedCols = [];

				self.save( function(){
					if(selected){
						LifeCycle.blockUI('300px');
						LifeCycle.SpreadData.SpreadDataMapLoader.buildAoDataMap(self.statementId, false, function(
							statement,
							_aoRecords,
							aoPeriods,
							_asRowIds
						) {
							var asStatementTotalMapKeys = statement.recordTotals().map(function(recordTotal){
								return recordTotal.recordId();
							});
							var aoStatementTotalMap = SpreadStatement.aggregateByTotalGroup(
								asStatementTotalMapKeys,
								_aoRecords,
								_asRowIds,
								aoPeriods);
							app.publish('SPREAD.Spreads.Refresh_Statement',aoStatementTotalMap);
						});
					}
				});

				affectedCols = affectedCols.concat([self.index]);

				app.viewModel.spread.updateSelectedColumns(affectedCols, selected);

				if(app.viewModel.spreadStatement.displayTrend()){
					affectedCols = affectedCols.concat(app.viewModel.determineTrendIndexes(affectedCols, !selected));
				}
				if(app.viewModel.spreadStatement.displayCommonSizing()){
					affectedCols = affectedCols.concat(app.viewModel.determineCommonSizingIndexes(affectedCols));
				}
				app.viewModel.spread.showHideColumns(affectedCols, selected);
				app.viewModel.spread.showHeaderForAdditionalDataPoints(app.viewModel.headerRecordTotalId());

				app.publish('SPREAD.Spreads.Column_Selection_Changed', _.pick(self, 'recordId', 'selected'));
			});

			self.name = ko.computed(function(){
				if(self.nameOverride != null && self.nameOverride != ""){
					return self.nameOverride;
				}else{
					return self.getDisplayDate(self.statementDate)
							+ (self.numberOfPeriods > 0 ? ', ' + self.numberOfPeriods + ' months':'')
							+ (typeof self.source() != 'undefined'?' (' + self.source()+')':'');
				}
			});

			self.getDisplayDate = function(statementDate){
				var sDate = new Date(statementDate);
				return (sDate.getMonth()+1) + '/' + sDate.getDate() + '/' + sDate.getFullYear();
			};
			
			self.save = function(successCallback, failureCallback){
				successCallback = _.isUndefined(successCallback) ? function(){} : successCallback;
				failureCallback = _.isUndefined(failureCallback) ? function(){} : failureCallback;
				var saveMapping = app.getMapping();
				var ignore = saveMapping['ignore'];
				if(ignore == null){
					ignore = [];
					saveMapping['ignore'] = ignore;
				}

				var additionalFieldsToIgnore = [
					'id',
					'index',
					'name',
					'quarter',
					'type'
				];

				_.each(additionalFieldsToIgnore, function(field){
					ignore.push(field);
				});
				var apexType = app.mapToJS(self).apexType;
				var objToSave = ko.mapping.toJS(self, saveMapping);
				objToSave.apexType = apexType;

				LifeCycle.SpreadsService.saveIForce(objToSave, successCallback, failureCallback);
				
			};

			return self;
		}

		app.AdditionalDataPoints = function(data){
			var self = this;
			var defaultData = {
				source: null
			};

			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.source.subscribe(function(selected){
				app.viewModel.saveSettings();
			});
		}

		app.setTypesMap({
			'LifeCycleSpreadStatement': 'spreadStatement',
			'LifeCycleSpreadStatementPeriod': 'spreadStatementPeriod'
		});

		app.setMapping({
			'ignore' : ['displayColumns','columnCategoryByYear'],
			'copy' : [
				'id',
				'statementId',
				'name',
				'statementDate',
				'month',
				'year',
				'columnNumber',
				'numberOfPeriods',
				'type',
				'index',
				'availableSources',
				'spread',
				'nameOverride',
				'columnCategoryByYear'
			],
			'spreadStatement' : {
				create: function(options){
					return new app.SpreadStatement(options.data);
				}
			},
			'years' :{
				key: function(year){
					ko.utils.unwrapObservable(year.yearName);
				},
				create: function(options){
					return new app.Year(options.data);
				}
			},
			'columns' : {
				key: function(column){
					ko.utils.unwrapObservable(column.name);
				},
				create: function(column){
					return new app.Column(column.data);
				}
			},
			'additional_data_points' : {
				create: function(options){
					return new app.AdditionalDataPoints(options.data);
				}
			}
		});
	};
	if(LifeCycle.SpreadDatePicker == undefined){
		LifeCycle.SpreadDatePicker = {};
	}
	if(LifeCycle.SpreadDatePicker.Models == undefined){
		LifeCycle.SpreadDatePicker.Models = Models;
	}
})();

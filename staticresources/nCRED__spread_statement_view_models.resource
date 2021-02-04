(function(){
	var Models = function(event, app){
		var defaultModelData = {
			recordId: null,
			name : ''
		};

		function periodSortAscending(a, b) {
			return a.periodKey() > b.periodKey() ? 1 : -1;
		};

		app.SpreadStatementView = function(data){
			var self = this;
			var defaultData = _.extend({
					apexType: app.mapApexFromModel('spreadStatementView'),
					viewFilter: null,
					statement: ko.observable(),
					bundle: ko.observable()
				}, 
				defaultModelData);
			
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.statementBundle = ko.computed(function () {
				if (self.statement()) {
					var bundleId = self.statement().bundle.recordId();
					var bundle = LifeCycle.SpreadData.lookupIForceById(bundleId);
					return bundle;
				}
			});
			
			return self;
		};
		app.IForceViewFilter = function(data){
			var self = this;
			var defaultData = _.extend({
					apexType: app.mapApexFromModel('viewFilter'),
					filterRecords: [],
					includeAll: false,
					selectingRecordTotals: ko.observableArray()
				}, 
				defaultModelData);
			
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.selectingRecordTotals = ko.observableArray();
			
			return self;
		};
		app.setMapping({
			'ignore': ['selectingRecordTotals'],
			'copy': [],
			'viewFilter': {
				create: function(options){
					return new app.IForceViewFilter(options.data);
				}
			},
			'spreadStatementView': {
				create: function(options){
					return new app.SpreadStatementView(options.data);
				}
			}
		});
		app.setTypesMap({
			'SpreadStatementViewFilter': 'viewFilter',
			'LifeCycleSpreadStatementView': 'spreadStatementView'
		});
		app.log('Models initialized.');
	};
	if(LifeCycle.Spread_Statement_View == undefined){
		LifeCycle.Spread_Statement_View = {};
	}
	if(LifeCycle.Spread_Statement_View.Models == undefined){
		LifeCycle.Spread_Statement_View.Models = Models;
	}
})();

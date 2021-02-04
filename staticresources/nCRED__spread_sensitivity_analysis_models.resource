(function(){
	var Models = function(event, app){
		var defaultModelData = {
		};
		app.SAInfo = function (data) {
			var self = this;
			var defaultData = _.extend({
					tables: [],
					fields: [],

					period: null,
					
					paymentsPerYear: 0,
					coverageTestNOICF: 0,
					coverageTestSimpleCF: 0,
					policyAdvanceRate: 0,
					calculatedMonthlyPmt: 0,
					calculatedAnnualDS: 0
				},
				defaultModelData);

			if (data != undefined) {
				_.extend(defaultData, data);
			}

			app.mapFromJS(defaultData, app.getMapping(), self);
		};
		app.SATable = function(data){
			var self = this;
			var defaultData = _.extend({
					name: '',
					recordId: '',
					rows: [],
					columns: [],
					startValue: 0,
					deviations: 4,
					stepValue: 0.05,
					bidirectional: true,
					apexType: app.mapApexFromModel('saTable')
				}, 
				defaultModelData);
			
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			
			return self;
		};
		app.SARow = function(data){
			var self = this;
			var defaultData = _.extend({
				percentValue: 0,
				apexType: app.mapApexFromModel('saRow'),
			}, defaultModelData);
			
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.cells = ko.observableArray();
			
			return self;
		};
		app.SAColumn = function(data){
			var self = this;
			var defaultData = _.extend({
				name: '',
				syntax: '',
				type: '',
				apexType: app.mapApexFromModel('saColumn'),
			}, defaultModelData);
			
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			
			return self;
		};
		app.SAField = function (data) {
			var self = this;
			var defaultData = _.extend({
				name: '',
				label: '',
				type: 'default',
				initialValue: '',
				linkedRecordSyntaxes: [],
				value: null,
				displayed: true,
				calculated: false,
				periodSpecific: false,
				periodValues: [],
				apexType: app.mapApexFromModel('saField')
			}, defaultModelData);

			if (data != undefined) {
				_.extend(defaultData, data);
			}
			
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.linkedRecords = ko.observableArray();
			self.periodValues = ko.observableArray();

			return self;
		};
		app.setMapping({
			'ignore': [
				'periodValues',
				'linkedRecords',
				'cells'
			],
			'period': {
				create: function (options) {
					return ko.observable(new app.SpreadStatementPeriod(options.data));
				} 
			},
			'tables': {
				create: function(options){
					return new app.SATable(options.data);
				}
			},
			'columns': {
				create: function(options){
					return new app.SAColumn(options.data);
				}
			},
			'rows': {
				create: function(options){
					return new app.SARow(options.data);
				}
			},
			'fields': {
				create: function(options){
					return new app.SAField(options.data);
				}
			},
			'info': {
				create: function(options){
					return new app.SAInfo(options.data);
				}
			}
		});
		app.log('Models initialized.');
	};
	if(LifeCycle.Spread_Sensitivity_Analysis == undefined){
		LifeCycle.Spread_Sensitivity_Analysis = {};
	}
	if(LifeCycle.Spread_Sensitivity_Analysis.Models == undefined){
		LifeCycle.Spread_Sensitivity_Analysis.Models = Models;
	}
})();

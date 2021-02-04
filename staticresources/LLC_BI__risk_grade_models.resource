(function(){
	var Models = function(event, app) {
		var defaultModelData = {
			recordId: null,
			name : null
		};

		app.Review = function(data) {
			var self = this;
			var defaultData = _.extend({
					apexType: app.mapApexFromModel('review'),
					templateId: null,
					factors: [],
					comments: null,
					computedRiskGrade: null,
					overriddenRiskGrade: null,
					finalRiskGrade: null,
					status: null
				}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.computedRiskGrade = ko.observable().extend({nullableNumeric: 2});
			self.overriddenRiskGrade = ko.observable().extend({nullableNumeric: 2});
			self.finalRiskGrade = ko.observable().extend({nullableNumeric: 2});
			self.groups = _groupsBuilder(self);

			self.canCalculate = ko.computed({
				read: function() {
					var result = true;
					var approved = app.viewModel.approved();
					var declined = app.viewModel.declined();
					if (self.status() == approved || self.status() == declined) {
						result = false;
					}
					_.each(self.factors(), function(factor) {
						if (factor.riskGrade() == null) {
							result = false;
						}
					})
					return result;
				}
			});
			self.applyValidationModel = function() {
				self.validationModel = ko.validatedObservable({
					comments: self.comments.extend({
						required: {
							params: true,
							message: app.viewModel.validationMessage(),
							onlyIf: function() {
								return self.overriddenRiskGrade() != null;
							}
						}
					})
				});
				self.validationModel.errors.showAllMessages();
				return self.validationModel;
			};
			return self;
		};
		app.Template = function(data) {
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('template'),
				name: null,
				factors: []
			}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.groups = _groupsBuilder(self);
			return self;
		};
		app.RiskGroup = function(data) {
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('riskGroup'),
				name: null,
				weight: null,
				groupNumber: null,
			}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.factors = [];
			self.sum = ko.computed({
				read: function() {
					var sum = 0.0;
					_.each(self.factors, function(factor) {
						sum += factor.weighted();
					});
					return sum;
				}
			});
			self.total = ko.computed({
				read: function () {
					return self.sum() * self.weight();
				}
			});
			self.weightPct = ko.computed({
				read: function () {
					return self.weight() * 100;
				}
			});
			return self;
		};
		app.Factor = function(data) {
			var self = this;
			var defaultData = _.extend({
					apexType: app.mapApexFromModel('factor'),
					criteria: [],
					name: null,
					factorType: null,
					riskGroup: {name: '', groupNumber: 10001, weight: 1.0},
					values: [],
					weight: null
				}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.getOrCreateValue = function() {
				if (self.values().length == 0) {
					self.values.push(new app.Value({factorId: self.recordId()}));
				}
				return self.values()[0];
			};
			self.isQuantitative = function() {
				return self.factorType() === app.viewModel.quantitative();
			};
			self.riskGrade = ko.computed({
				read: function() {
					var val = self.value();
					var result = _.find(self.criteria(), function(criteria) {
						var low = criteria.getLowerBound();
						var high = criteria.getUpperBound();
						var desc = criteria.description();
						if (self.isQuantitative()) {
							var num = parseFloat(val);
							return num >= low && num <= high;
						} else {
							return val === desc;
						}
					});
					return (result) ? result.riskGrade() : null;
				}
			});
			self.value = ko.computed({
				read: function() {
					var v = self.getOrCreateValue();
					if (self.isQuantitative()) {
						return v.quantitativeValue();
					} else {
						return v.qualitativeValue();
					}
				},
				write: function(data) {
					var v = self.getOrCreateValue();
					if (self.isQuantitative()) {
						v.quantitativeValue(parseFloat(data));
					} else {
						v.qualitativeValue(data);
					}
				}
			});
			self.weighted = ko.computed(function() {
				var grade = self.riskGrade();
				var weight = self.weight();
				if (grade != null) {
					return grade * weight;
				}
				return null;
			});

			self.weightPct = ko.computed(function() {
				return self.weight() * 100;
			});

			return self;
		};
		app.Criteria = function(data) {
			var self = this;
			var defaultData = _.extend({
					apexType: app.mapApexFromModel('criteria'),
					description: null,
					low: null,
					high: null,
					riskGrade: null
				}, defaultModelData);
			if(data != undefined) {
				_.extend(defaultData, data);
			}
			self.getLowerBound = function() {
				var low = parseFloat(self.low());
				if (_.isNaN(low)) {
					low = Number.MIN_VALUE;
				}
				return low;
			};
			self.getUpperBound = function() {
				var high = parseFloat(self.high());
				if (_.isNaN(high)) {
					high = Number.MAX_VALUE;
				}
				return high;
			};
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.Value = function(data) {
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('value'),
				qualitativeValue: null,
				quantitativeValue: null
			}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.setMapping({
			'criteria': {
				create: function(options){
					return new app.Criteria(options.data);
				}
			},
			'factors': {
				create: function(options){
					return new app.Factor(options.data);
				}
			},
			'review': {
				create: function(options){
					return new app.Review(options.data);
				}
			},
			'riskGroup': {
				create: function(options){
					return new app.RiskGroup(options.data);
				}
			},
			'template': {
				create: function(options){
					return new app.Template(options.data);
				}
			},
			'values': {
				create: function(options){
					return new app.Value(options.data);
				}
			},
			'value': {
				create: function(options){
					return new app.Value(options.data);
				}
			}
		});
		app.setTypesMap({
			'LifeCycleRiskGradeCriteria': 'criteria',
			'LifeCycleRiskGradeFactor': 'factor',
			'LifeCycleRiskGradeFactorValue': 'value',
			'LifeCycleRiskGradeGroup': 'riskGroup',
			'LifeCycleRiskRatingReview': 'review',
			'LifeCycleRiskGradeTemplate': 'template'
		});
		_groupsBuilder = function(model) {
			var groupsBuilder = function() {
				var map = {};
				_.each(model.factors(), function(factor) {
					var group = factor.riskGroup;
					var name = group.name();
					if (!map[name]) {
						map[name] = group;
					}
					map[name].factors.push(factor);
				});
				var result = _.values(map);
				result = _.sortBy(map, function(g) {
					return g.groupNumber();
				});
				return result;
			};
			return groupsBuilder;
		};
		app.log('Models initialized.');
	};
	if(LifeCycle.Risk_Grade == undefined){
		LifeCycle.Risk_Grade = {};
	}
	if(LifeCycle.Risk_Grade.Models == undefined){
		LifeCycle.Risk_Grade.Models = Models;
	}
})();

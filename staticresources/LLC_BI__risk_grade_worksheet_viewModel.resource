(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			self.app = app;
			var defaultData = {
				review: {},
				validationMessage: null,
				quantitative: null,
				approved: null,
				declined: null,
				readOnly: false
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.calculate = function() {
				if (self.review.applyValidationModel().isValid()) {
					var grade = 0.0;
					_.each(self.review.groups(), function(group) {
						grade += group.total();
					});
					self.review.computedRiskGrade(grade);
					self.saveAll();
				}
			};
			self.load = function(callback) {
				if (!_.isUndefined(self.review) && !_.isEmpty(self.review.recordId())) {
					self.retrieve(self.review, callback);
				}
			};
			self.retrieve = function(data, success, remotingOptions) {
				LifeCycle.BorrowerTree.retrieveIForce(
					data,
					data.recordId(),
					function(result, event) {
						app.mapFromJS(result, app.getMapping(), data);
						if (_.isFunction(success)) {
							success.apply(this, [result, event, data]);
						}
					},
					app.log.failure,
					remotingOptions,
					false
				);
			};
			self.save = function(value) {
				try {
					app.performingAjax(true);
					var data = app.mapToJS(value, app.mapping);
					LifeCycle.BorrowerTree.saveRecord(
						data,
						function(result, event){
							app.mapFromJS(result, app.mapping, value);
							app.performingAjax(false);
						},
						app.log.failure
					);
				} catch(e) {
					app.log.failure(null, e);
					app.performingAjax(false);
				}
			};
			self.saveAll = function() {
				if (self.review.applyValidationModel().isValid()) {
					_.each(self.review.factors(), function(factor) {
						if (factor.values().length > 0) {
							var value = factor.values()[0];
							self.save(value);
						}
					});
					self.save(self.review);
				}
			};
			app.log('ViewModel instantiated.');
			return self;
		}
		app.log('ViewModel initialized.');
	};
	if(LifeCycle.Risk_Grade_Worksheet.ViewModel == undefined){
		LifeCycle.Risk_Grade_Worksheet.ViewModel = ViewModel;
	}
})();
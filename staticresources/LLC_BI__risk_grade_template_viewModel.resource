(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			self.app = app;
			var defaultData = {
				template: {}
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.load = function() {
				if (!_.isEmpty(self.template.recordId())) {
					app.mapFromJS(
						{'template' : app.mapToJS(self.template)},
						app.getMapping(),
						self
					);
					self.retrieve(self.template);
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
			app.log('ViewModel instantiated.');
			return self;
		}
		app.log('ViewModel initialized.');
	};
	if(LifeCycle.Risk_Grade_Template.ViewModel == undefined){
		LifeCycle.Risk_Grade_Template.ViewModel = ViewModel;
	}
})();
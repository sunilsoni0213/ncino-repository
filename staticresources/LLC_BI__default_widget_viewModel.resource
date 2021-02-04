(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			self.app = app;
			var defaultData = {
				contextObject: '',
				screenSection: ''
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.load = function(callback){
				self.retrieveContextObject(self, function(arguments){
					self.retrieve(self.screenSection, function(arguments){
						self.retrieve(self.screenSection.widget, function(arguments){
							callback.apply();
							LifeCycle.Force.saveAttachment(
								self.screenSection.recordId(),
								msgs.msg_rendered_view_filename,
								msgs.msg_text_plain,
								jQuery('#'+self.screenSection.recordId()).html(),
								true,
								function(){},
								function(){}
							);
						}, undefined);
					}, undefined);
				}, undefined);
			};

			self.save = function(data){
				app.save(app.mapToJS(data), function(){});
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

			self.retrieveContextObject = function(data, success, remotingOptions) {
				LifeCycle.BorrowerTree.retrieveIForce(
					data,
					data.contextObject.recordId(),
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

			return self;
		}
	};
	if(LifeCycle.Default_Widget.ViewModel == undefined){
		LifeCycle.Default_Widget.ViewModel = ViewModel;
	}
})();

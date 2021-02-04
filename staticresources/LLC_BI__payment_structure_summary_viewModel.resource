(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			self.app = app;
			var defaultData = {
				contextObject: '',
				streams: []
			};
			
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.params = { route: null, group: null }

			self.load = function(callback){
				self.retrieveStreams(self, function(){
					self.retrieve(self.screenSection, function(arguments){
						self.retrieve(self.screenSection.widget, function(){
							callback.apply();
							self.params = app.mapToJS(self.screenSection.widget.parameters());
							LifeCycle.Force.saveAttachment(
								self.screenSection.recordId(),
								msgs.msg_rendered_view_filename,
								msgs.msg_text_plain,
								jQuery('#'+self.screenSection.recordId()).html(),
								true,
								function(){},
								function(){});
							}, undefined);
						}, undefined);
				}, undefined);
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

			self.retrieveStreams = function(data, success, remotingOptions) {
				LifeCycle.PaymentStructure.getPaymentStreams(
					data,
					data.contextObject.recordId(),
					function(result, event) {
						app.mapFromJS(result, app.getMapping(), self.streams);

						if (_.isFunction(success)) {
							success.apply(this, [result, event, data]);
						}
					},
					app.log.failure,
					remotingOptions,
					false
				);
			};

			self.redirect = function(group, route) {
				var loanId = self.contextObject.recordId();
				window.location.href="/apex/Loan?app="+self.params.group+"."+self.params.route+"&id="+loanId;
			};

			return self;
		}
	};
	if(LifeCycle.Payment_Structure_Summary.ViewModel == undefined){
		LifeCycle.Payment_Structure_Summary.ViewModel = ViewModel;
	}
})();
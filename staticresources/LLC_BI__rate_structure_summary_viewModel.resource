(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			self.app = app;
			var defaultData = {
				contextObject: '',
				streams: [],
				indexRates: [],
				rateIndicies: []
			};

			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.params = { route: null, group: null }

			self.load = function(callback){
				self.retrieveIndexRates(self, function(){
					self.retrieveRateIndicies(self, function() {
						self.retrieveStreams(self, function(){
							self.formatRates();
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
					}, undefined);
				}, undefined);
			};

			self.isFirstComponent = function(data) {
				return true;
			};

			self.formatRates = function() {
				_.each(self.streams(), function(stream){
					_.each(stream.components(), function(component) {
						var rateName = '';
						if(component.isFixed()) {
							rateName += parseFloat(component.rate()) + '%'; 
						}
						else {
							var spread = component.spread() ? component.spread() : 0; 
							var prop = component.index();
							rateName += self.getIndexDisplayName(component.index()) + ' + ' + parseFloat(spread) + '%'; 
							if(self.indexRates().hasOwnProperty(prop)){
								var propvalue = eval('self.indexRates().'+prop+'()')
								rateName += " (est. " + parseFloat(spread + propvalue).toFixed(4) + "%) ";
							}
						}
						component.rateName = ko.observable(rateName);
					});
				});
			};

			self.getIndexDisplayName = function(indexMasterLabel){
				var returnName = indexMasterLabel;
				_.each(self.rateIndicies(), function(index) {
					if(index.masterLabel() == indexMasterLabel){
						returnName = index.displayName();
					}
				});
				return returnName;
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
				LifeCycle.RateStructure.getRateStreams(
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

			self.retrieveIndexRates = function(data, success, remotingOptions) {
				LifeCycle.RateStructure.getIndexRates(
					data,
					function(result, event) {
						app.mapFromJS(result, app.getMapping(), self.indexRates);

						if (_.isFunction(success)) {
							success.apply(this, [result, event, data]);
						}
					},
					app.log.failure,
					remotingOptions,
					false
				);
			};

			self.retrieveRateIndicies = function(data, success, remotingOptions) {
				LifeCycle.RateStructure.getRateIndicies(
					data,
					function(result, event) {
						app.mapFromJS(result, app.getMapping(), self.rateIndicies);

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
	if(LifeCycle.Rate_Structure_Summary.ViewModel == undefined){
		LifeCycle.Rate_Structure_Summary.ViewModel = ViewModel;
	}
})();
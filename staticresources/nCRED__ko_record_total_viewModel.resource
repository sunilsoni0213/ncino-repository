(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(serverData){
			var self = this;
			self.app = app;
			var defaultData = {
				statement: null,
				recordTotal: '',
				records: [],
				isChild: false,
				targetElement: null
			};
			if(serverData != undefined){
				_.extend(defaultData, serverData);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			
			self.load = function(callback){
				app.subscribe("SPREAD.Spreads.Record_Total_Init", function(params){
					var viewModel = new app.ViewModel(params);
					viewModel.loadChildVM();
				});	
				callback.apply();
			};

			self.loadChildVM = function (callback) {
				self.isChild(true);
				self.targetElement(document.getElementById(self.recordTotal.recordId()));
				self.retrieve(self.recordTotal, function(){
					if (self.targetElement()) {
						ko.applyBindings(self, self.targetElement());
						app.publish("SPREAD.Spreads.Record_Total_Loaded." +
							self.recordTotal.recordId(), self);
					} else {
						app.publish("SPREAD.Spreads.Error",
							'Unable to located template for this Record Total. It Can Not Be Displayed' +
							self.recordTotal.recordId());
					}
				});
			};

			self.retrieve = function(data, success, remotingOptions){
				LifeCycle.SpreadsService.retrieveIForce(
					data,
					data.recordId(),
					function(result, event){
						app.mapFromJS(result, app.getMapping(), data);
						if(_.isFunction(success)){
							success.apply(this, [result, event, data]);
						}
					},
					app.log.failure, remotingOptions, false);
			};

			return self;
		}
		app.log('ViewModel initialized.');
	};
	if(LifeCycle.KO_Record_Total.ViewModel == undefined){
		LifeCycle.KO_Record_Total.ViewModel = ViewModel;
	}
})();

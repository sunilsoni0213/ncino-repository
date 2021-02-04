(function(registrationApp){
	var App = function(){
		var self = this;
		self.register = function(appName, appData){
			registrationApp.registerExtension(function(event, registrationApp){
				registrationApp.registerAppName(appName);
				(function(app){
					app.preRun = function(data){
						return (appData != undefined ? appData : data);
					}
					app.postRun = function(vm){
						if(!_.isUndefined(vm.spread)){
							vm.spread.rmaBenchmarksApp = app;
							vm.load();
						}
						return true;
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerModels(appName, LifeCycle.RmaBenchmarks.Models);
			registrationApp.registerViewModel(appName, LifeCycle.RmaBenchmarks.ViewModel);
		};
		return self;
	};
	if(LifeCycle.RmaBenchmarks == undefined){
		LifeCycle.RmaBenchmarks = {};
	}
	if(LifeCycle.RmaBenchmarks.App == undefined){
		LifeCycle.RmaBenchmarks.App = App;
	}
})(LifeCycle.RegistrationApp);

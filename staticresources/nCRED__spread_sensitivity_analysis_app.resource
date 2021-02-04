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
						vm.load(function(attachTo){});
						return true;
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerModels(appName, LifeCycle.Relationship.Models);
			registrationApp.registerModels(appName, LifeCycle.Spreading.Models);
			registrationApp.registerModels(appName, LifeCycle.Underwriting.Models);
			registrationApp.registerModels(appName, LifeCycle.Spread_Sensitivity_Analysis.Models);
			registrationApp.registerViewModel(appName, LifeCycle.Spread_Sensitivity_Analysis.ViewModel);
		};
		return self;
	};
	if(LifeCycle.Spread_Sensitivity_Analysis == undefined){
		LifeCycle.Spread_Sensitivity_Analysis = {};
	}
	if(LifeCycle.Spread_Sensitivity_Analysis.App == undefined){
		LifeCycle.Spread_Sensitivity_Analysis.App = App;
	}
})(LifeCycle.RegistrationApp);

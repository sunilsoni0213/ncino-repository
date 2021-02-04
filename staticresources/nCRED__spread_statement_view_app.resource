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
						vm.load(function(){});
						return true;
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerModels(appName, LifeCycle.Underwriting.Models);
			registrationApp.registerModels(appName, LifeCycle.Relationship.Models);
			registrationApp.registerModels(appName, LifeCycle.Spreading.Models);
			registrationApp.registerModels(appName, LifeCycle.Spread_Statement_View.Models);
			registrationApp.registerViewModel(appName, LifeCycle.Spread_Statement_View.ViewModel);
		};
		return self;
	};
	if(LifeCycle.Spread_Statement_View == undefined){
		LifeCycle.Spread_Statement_View = {};
	}
	if(LifeCycle.Spread_Statement_View.App == undefined){
		LifeCycle.Spread_Statement_View.App = App;
	}
})(LifeCycle.RegistrationApp);

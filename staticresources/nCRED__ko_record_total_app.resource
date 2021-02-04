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
			registrationApp.registerViewModel(appName, LifeCycle.KO_Record_Total.ViewModel);
		};
		return self;
	};
	if(LifeCycle.KO_Record_Total == undefined){
		LifeCycle.KO_Record_Total = {};
	}
	if(LifeCycle.KO_Record_Total.App == undefined){
		LifeCycle.KO_Record_Total.App = App;
	}
})(LifeCycle.RegistrationApp);

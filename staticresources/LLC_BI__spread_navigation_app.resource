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
						jQuery(window).on("load", vm.load);
						vm.spread.navApp = app;
						return true;
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerModels(appName, LifeCycle.Spreading.Models);
			registrationApp.registerViewModel(appName, LifeCycle.SpreadNavigation.ViewModel);
		};
		return self;
	};
	if(LifeCycle.SpreadNavigation == undefined){
		LifeCycle.SpreadNavigation = {};
	}
	if(LifeCycle.SpreadNavigation.App == undefined){
		LifeCycle.SpreadNavigation.App = App;
	}
	
})(LifeCycle.RegistrationApp);
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
						vm.spread.trailingTwelveMonthApp = app;
						return true;
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerViewModel(appName, LifeCycle.TTMonth.ViewModel);
		};
		return self;
	};
	if(!LifeCycle.TTMonth){
		LifeCycle.TTMonth = {};
	}
	if(!LifeCycle.TTMonth.App){
		LifeCycle.TTMonth.App = App;
	}
})(LifeCycle.RegistrationApp);
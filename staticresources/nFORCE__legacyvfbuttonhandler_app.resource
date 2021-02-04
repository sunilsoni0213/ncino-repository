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
				})(registrationApp.registeredApps[appName]);
				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerViewModel(appName, LifeCycle.LegacyVFButtonHandler.ViewModel);
		};
		return self;
	};
	if(LifeCycle.LegacyVFButtonHandler == undefined){
		LifeCycle.LegacyVFButtonHandler = {};
	}
	if(LifeCycle.LegacyVFButtonHandler.App == undefined){
		LifeCycle.LegacyVFButtonHandler.App = App;
	}
})(LifeCycle.RegistrationApp);

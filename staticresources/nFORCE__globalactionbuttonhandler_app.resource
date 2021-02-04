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
			registrationApp.registerViewModel(appName, LifeCycle.GlobalActionButtonHandler.ViewModel);
		};
		return self;
	};
	if(LifeCycle.GlobalActionButtonHandler == undefined){
		LifeCycle.GlobalActionButtonHandler = {};
	}
	if(LifeCycle.GlobalActionButtonHandler.App == undefined){
		LifeCycle.GlobalActionButtonHandler.App = App;
	}
})(LifeCycle.RegistrationApp);

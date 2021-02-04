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
			registrationApp.registerViewModel(appName, LifeCycle.MessageHandler.ViewModel);
		};
		return self;
	};
	if(LifeCycle.MessageHandler == undefined){
		LifeCycle.MessageHandler = {};
	}
	if(LifeCycle.MessageHandler.App == undefined){
		LifeCycle.MessageHandler.App = App;
	}

	LifeCycle.MessageHandler.Topics = {
		SUCCESS: 'message.saveSuccess',
		ERROR: 'message.error',
		CLEAR_ERROR: 'message.clearError',
		TOGGLE_VIEWSTATE: 'message.toggleViewState',
		DELETE: 'message.deleteSuccess',
		REFRESH_SECONDARY_NAVIGATION: 'navigation.secondary.refresh',
		REFRESH_TERTIARY_NAVIGATION: 'navigation.tertiary.refresh'
	};
})(LifeCycle.RegistrationApp);

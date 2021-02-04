(function(registrationApp){
	var App = function(){
		var self = this;
		self.register = function(appName){
			registrationApp.registerExtension(function(event, registrationApp){
				registrationApp.registerAppName(appName);
				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerModels(appName, LifeCycle.UnderwritingGlobal.Models);
			registrationApp.registerViewModel(appName, LifeCycle.UnderwritingGlobal.ViewModel);
		};
		return self;
	};
	if(LifeCycle.UnderwritingGlobal == undefined){
		LifeCycle.UnderwritingGlobal = {};
	}
	if(LifeCycle.UnderwritingGlobal.App == undefined){
		LifeCycle.UnderwritingGlobal.App = App;
	}
})(LifeCycle.RegistrationApp);
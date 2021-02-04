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
						setTimeout(vm.load, 1000);
						return true;
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerModels(appName, LifeCycle.Risk_Grade.Models);
			registrationApp.registerViewModel(appName, LifeCycle.Risk_Grade_Template.ViewModel);
		};
		return self;
	};
	if(LifeCycle.Risk_Grade_Template == undefined){
		LifeCycle.Risk_Grade_Template = {};
	}
	if(LifeCycle.Risk_Grade_Template.App == undefined){
		LifeCycle.Risk_Grade_Template.App = App;
	}
})(LifeCycle.RegistrationApp);
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
						vm.load(function(){
							var screenSectionId = vm.screenSection.recordId();
							ko.applyBindings(vm, document.getElementById(screenSectionId));
						});
						return true;
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerModels(appName, LifeCycle.Screen.Models);
			registrationApp.registerViewModel(appName, LifeCycle.KO_Narrative.ViewModel);
			registrationApp.registerView(appName, LifeCycle.KO_Narrative.View);
		};
		return self;
	};
	if(LifeCycle.KO_Narrative == undefined){
		LifeCycle.KO_Narrative = {};
	}
	if(LifeCycle.KO_Narrative.App == undefined){
		LifeCycle.KO_Narrative.App = App;
	}


})(LifeCycle.RegistrationApp);
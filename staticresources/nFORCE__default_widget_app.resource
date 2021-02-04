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
							app.publish('layoutDesigner.saveRenderedView', screenSectionId);
						});
						return true;
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerModels(appName, LifeCycle.Screen.Models);
			registrationApp.registerViewModel(appName, LifeCycle.Default_Widget.ViewModel);
		};
		return self;
	};
	if(LifeCycle.Default_Widget == undefined){
		LifeCycle.Default_Widget = {};
	}
	if(LifeCycle.Default_Widget.App == undefined){
		LifeCycle.Default_Widget.App = App;
	}
})(LifeCycle.RegistrationApp);
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
						jQuery(document).one(vm.screenSection.recordId(), 
							function(event, layoutDesignerVM){
								var screenSectionId = layoutDesignerVM.screenSectionId();	
								vm.load(function(){
									ko.applyBindings(vm, document.getElementById(screenSectionId));
								});
							}
						);
						return true;
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerViewModel(appName, LifeCycle.Rate_Structure_Summary.ViewModel);
			registrationApp.registerModels(appName, LifeCycle.Screen.Models);
		};
		return self;
	};
	if(LifeCycle.Rate_Structure_Summary == undefined){
		LifeCycle.Rate_Structure_Summary = {};
	}
	if(LifeCycle.Rate_Structure_Summary.App == undefined){
		LifeCycle.Rate_Structure_Summary.App = App;
	}
})(LifeCycle.RegistrationApp);
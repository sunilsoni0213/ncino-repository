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
						if(vm.isEditable()){
							jQuery(window).on("load", vm.load);
						}
						LifeCycle.BorrowerTree.buffer = true;
						LifeCycle.BorrowerTree.remotingTimeout = 120000;
						return true;
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log('Underwriting.Start ' + appName + ' App initialized.');
			});
			registrationApp.registerModels(appName, LifeCycle.Relationship.Models);
			registrationApp.registerModels(appName, LifeCycle.Spreading.Models);
			registrationApp.registerModels(appName, LifeCycle.Underwriting.Models);
			registrationApp.registerViewModel(appName, LifeCycle.Underwriting.Start.ViewModel);
		};
		return self;
	};
	if(LifeCycle.Underwriting == undefined){
		LifeCycle.Underwriting = {};
	}
	if(LifeCycle.Underwriting.Start == undefined){
		LifeCycle.Underwriting.Start = {};
	}
	if(LifeCycle.Underwriting.Start.App == undefined){
		LifeCycle.Underwriting.Start.App = App;
	}
})(LifeCycle.RegistrationApp);
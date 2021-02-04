(function(registrationApp){
	var App = function(){
		var self = this;
		self.viewModel = null;
		self.register = function(appName, appData){
			registrationApp.registerExtension(function(event, registrationApp){
				registrationApp.registerAppName(appName);
				(function(app){
					app.preRun = function(data){
						return (appData != undefined ? appData : data);
					};
					app.postRun = function(vm){
						self.viewModel = vm;
						jQuery(window).on("load", vm.load);
						return true;
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerModels(appName, LifeCycle.Relationship.Models);
			registrationApp.registerModels(appName, LifeCycle.Spreading.Models);
			registrationApp.registerViewModel(appName, LifeCycle.Spread_Printing.ViewModel);
		};

		self.setYears = function(aiYears){
			self.viewModel.setYears(aiYears);
		}

		return self;
	};
	if(LifeCycle.Spread_Printing == undefined){
		LifeCycle.Spread_Printing = {};
	}
	if(LifeCycle.Spread_Printing.App == undefined){
		LifeCycle.Spread_Printing.App = App;
	}
})(LifeCycle.RegistrationApp);
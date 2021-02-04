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
						google.maps.event.addDomListener(window, 'load', vm.loadMap);
						return true;
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerModels(appName, LifeCycle.Portfolio_Map.Models);
			registrationApp.registerViewModel(appName, LifeCycle.Portfolio_Map.ViewModel);
			registrationApp.registerView(appName, LifeCycle.Portfolio_Map.View);
		};
		return self;
	};
	if(LifeCycle.Portfolio_Map == undefined){
		LifeCycle.Portfolio_Map = {};
	}
	if(LifeCycle.Portfolio_Map.App == undefined){
		LifeCycle.Portfolio_Map.App = App;
	}
})(LifeCycle.RegistrationApp);
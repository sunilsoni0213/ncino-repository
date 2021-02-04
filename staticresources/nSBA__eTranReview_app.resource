(function(registrationApp){
	var App = function(){
		var self = this;
		self.register = function(appName, appData){
			registrationApp.registerExtension(function(event, registrationApp){
				registrationApp.registerAppName(appName);
				(function(app){
					app.getMap = function(type) {
						var mapping = app.getMapping();
						if (mapping && mapping[type]) {
							return mapping[type];
						}
						return {};
					};
					app.preRun = function(data){
						return (appData != undefined ? appData : data);
					}
					app.postRun = function(vm){
						jQuery(window).on("load", vm.load);
						return true;
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerViewModel(appName, LifeCycle.ETranReview.ViewModel);
			registrationApp.registerModels(appName, LifeCycle.ETranReview.Models);
		};
		return self;
	};
	if(LifeCycle.ETranReview == undefined){
		LifeCycle.ETranReview = {};
	}
	if(LifeCycle.ETranReview.App == undefined){
		LifeCycle.ETranReview.App = App;
	}
})(LifeCycle.RegistrationApp);
(function(registrationApp){
	var App = function(){
		var self = this;
		self.register = function(appName, appData){
			registrationApp.registerExtension(function(event, registrationApp){
				registrationApp.registerAppName(appName);
				(function(app){
					app.labels = _.extend({
						checkValidations: '',
						falsePositive: '',
						match: '',
						moreInfo: '',
						select: '',
						noMatch: '',
						inComplete: '',
						overRide: ''
					}, appData.labels);
					app.expirationDays = appData.expirationDays;
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
			registrationApp.registerViewModel(appName, LifeCycle.WatchlistReport.ViewModel);
			registrationApp.registerModels(appName, LifeCycle.Watchlist.Models);
		};
		return self;
	};
	if(LifeCycle.WatchlistReport == undefined){
		LifeCycle.WatchlistReport = {};
	}
	if(LifeCycle.WatchlistReport.App == undefined){
		LifeCycle.WatchlistReport.App = App;
	}
})(LifeCycle.RegistrationApp);
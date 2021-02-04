(function(registrationApp){
	var App = function(){
		var self = this;
		self.register = function(appName, appData){
			registrationApp.registerExtension(function(event, registrationApp){
				registrationApp.registerAppName(appName);
				(function(app){
					app.labels = _.extend({
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
			registrationApp.registerViewModel(appName, LifeCycle.WatchlistHistory.ViewModel);
			registrationApp.registerModels(appName, LifeCycle.Watchlist.Models);
		};
		return self;
	};
	if(LifeCycle.WatchlistHistory == undefined){
		LifeCycle.WatchlistHistory = {};
	}
	if(LifeCycle.WatchlistHistory.App == undefined){
		LifeCycle.WatchlistHistory.App = App;
	}
})(LifeCycle.RegistrationApp);
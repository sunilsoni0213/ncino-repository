(function(registrationApp){
	var App = function(){
		var self = this;
		self.register = function(appName, appData){
			registrationApp.registerExtension(function(event, registrationApp){
				registrationApp.registerAppName(appName);
				(function(app){
					app.preRun = function(data){
						return (appData != undefined ? appData : data);
					};
					app.postRun = function(vm){
						if (!_.isUndefined(window.spreadStatementInstance)) {
							spreadStatementInstance.commentsApp = app;
						}
						if (!_.isUndefined(vm.spread)) {
							vm.spread.commentsApp = app;
						}
						jQuery(window).on("load", vm.load);
						return true;
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerModels(appName, LifeCycle.Comments.Models);
			registrationApp.registerViewModel(appName, LifeCycle.Comments.ViewModel);
		};
		return self;
	};
	if(LifeCycle.Comments == undefined){
		LifeCycle.Comments = {};
	}
	if(LifeCycle.Comments.App == undefined){
		LifeCycle.Comments.App = App;
	}
})(LifeCycle.RegistrationApp);

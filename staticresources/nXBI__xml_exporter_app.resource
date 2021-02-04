(function(registrationApp){
	var App = function(){
		var self = this;
		var fieldSelector;
		self.initialize = function(appName, appData){
			registrationApp.registerAppName(appName);
			(function(app){
				app.getFieldSelector = function(){
					return fieldSelector;
				};
				app.preRun = function(data){
					return (appData != undefined ? appData : data);
				};
				app.postRun = function(vm){
					jQuery(vm.load);
					return true;
				};
			})(registrationApp.registeredApps[appName]);
			registrationApp.log('Exporter.Xml ' + appName + ' App initialized.');
		};
		self.register = function(appName, appModels, appData, fsPlugin){
			fieldSelector = fsPlugin;
			registrationApp.registerExtension(function(event, registrationApp){
				self.initialize(appName, appData);
			});
			if(!_.isUndefined(appModels)){
				if(_.isArray(appModels)){
					_.each(appModels, function(models){
						registrationApp.registerModels(appName, models);
					});
				}else if(_.isFunction(appModels)){
					registrationApp.registerModels(appName, appModels);
				}
			}
			registrationApp.registerViewModel(appName, LifeCycle.DataServices.Exporter.Xml.ViewModel);
			registrationApp.registerView(appName, LifeCycle.DataServices.ClosingLoanReview);
		};
		return self;
	};
	if(LifeCycle.DataServices.Exporter == undefined){
		LifeCycle.DataServices.Exporter = {};
	}
	if(LifeCycle.DataServices.Exporter.Xml == undefined){
		LifeCycle.DataServices.Exporter.Xml = {};
	}
	if(LifeCycle.DataServices.Exporter.Xml.App == undefined){
		LifeCycle.DataServices.Exporter.Xml.App = App;
	}
}(LifeCycle.RegistrationApp));
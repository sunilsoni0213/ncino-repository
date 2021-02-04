(function(registrationApp){
	var App = function(){
		var self = this;
		self.register = function(appName, appData){
			registrationApp.registerExtension(function(event, registrationApp){
				registrationApp.registerAppName(appName);
				(function(app){
					app.parentApp = function(){
						var potentialParentApps = LifeCycle.RegistrationApp.getAppsByName('LayoutDesigner');
						if(!potentialParentApps.length){
							return null;
						}

						var selfIndex = potentialParentApps.indexOf(app);
						if(selfIndex > 0){
							var parentIndex = selfIndex - 1;
							return potentialParentApps[parentIndex];
						} else {
							return null;
						}
					};
					app.preRun = function(data){
						app.blockUI = function(){};
						app.unblockUI = function(){};
						return (appData != undefined ? appData : data);
					};
					app.postRun = function(vm){
						if(vm.screenSectionId){
							app.performingAjax(true);
							vm.loadConfigurationData();
						}
						return true;
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerModels(appName, LifeCycle.LayoutDesigner.Models);
			registrationApp.registerViewModel(appName, LifeCycle.LayoutDesigner.ViewModel);
			registrationApp.registerView(appName, LifeCycle.LayoutDesigner.View);
		};
		return self;
	};
	if(LifeCycle.LayoutDesigner == undefined){
		LifeCycle.LayoutDesigner = {};
	}
	if(LifeCycle.LayoutDesigner.App == undefined){
		LifeCycle.LayoutDesigner.App = App;
	}
})(LifeCycle.RegistrationApp);
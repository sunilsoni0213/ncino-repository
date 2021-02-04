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
						jQuery(window).on("load", vm.loadSectionView);
						return true;
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log(appName + ' App initialized.');
			});

			registrationApp.registerModels(appName, LifeCycle.LayoutBuilder.Html.Template);
			registrationApp.registerModels(appName, LifeCycle.LayoutBuilder.Html.ReadOnly);
			registrationApp.registerModels(appName, LifeCycle.LayoutBuilder.Html.Edit);
			registrationApp.registerModels(appName, LifeCycle.LayoutBuilder.Html.Layouts);
			registrationApp.registerModels(appName, LifeCycle.LayoutBuilder.DataModels);
			registrationApp.registerViewModel(appName, LifeCycle.LayoutBuilder.ViewModel);
			registrationApp.registerView(appName, LifeCycle.LayoutBuilder.View);
		};
		return self;
	};
	if(LifeCycle.LayoutBuilder == undefined){
		LifeCycle.LayoutBuilder = {};
	}
	if(LifeCycle.LayoutBuilder.App == undefined){
		LifeCycle.LayoutBuilder.App = App;
	}
})(LifeCycle.RegistrationApp);
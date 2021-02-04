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
						vm.load();
						return true;
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerModels(appName, LifeCycle.Rent_Roll.Models);
			registrationApp.registerModels(appName, LifeCycle.Relationship.Models);
			registrationApp.registerModels(appName, LifeCycle.Spreading.Models);
			registrationApp.registerModels(appName, LifeCycle.LifeCycle_App.Models);
			registrationApp.registerViewModel(appName, LifeCycle.Rent_Roll.ViewModel);
		};
		return self;
	};
	if(LifeCycle.Rent_Roll == undefined){
		LifeCycle.Rent_Roll = {};
	}
	if(LifeCycle.Rent_Roll.App == undefined){
		LifeCycle.Rent_Roll.App = App;
	}
	ko.bindingHandlers.modal = {
		init: function (element, valueAccessor) {
			jQuery(element).modal({
				backdrop:'static'
			});
		},
		update: function (element, valueAccessor) {
			var value = valueAccessor();
			if (ko.utils.unwrapObservable(value)) {
				jQuery(element).modal('show');
			}
			else {
				jQuery(element).modal('hide');
			}
		}
	};
})(LifeCycle.RegistrationApp);

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
						jQuery(function(){
							vm.load(function(){
								ko.applyBindings(vm,document.getElementById('covenantManagerApp'));
							});
							return true;
						});
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerModels(appName, LifeCycle.Relationship.Models);
			registrationApp.registerModels(appName, LifeCycle.Covenant.Models);
			if (LifeCycle.SpreadData) {
				registrationApp.registerModels(appName, LifeCycle.Underwriting.Models);
				registrationApp.registerModels(appName, LifeCycle.Spreading.Models);
			}
			registrationApp.registerViewModel(appName, LifeCycle.Covenant_Manager.ViewModel);
		};
		return self;
	};
	if(LifeCycle.Covenant_Manager == undefined){
		LifeCycle.Covenant_Manager = {};
	}
	if(LifeCycle.Covenant_Manager.App == undefined){
		LifeCycle.Covenant_Manager.App = App;
	}
	var valueHandler = ko.bindingHandlers.value;
	ko.validation.configure({
		decorateElement: true,
		errorClass: 'slds-has-error',
		insertMessages: false
	});
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

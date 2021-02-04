
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
						jQuery(window).on("load", vm.load);
						vm.spread.spreadConfigApp = app;
						return true;
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerModels(appName, LifeCycle.Relationship.Models);
			registrationApp.registerModels(appName, LifeCycle.Underwriting.Models);
			registrationApp.registerModels(appName, LifeCycle.Covenant.Models);
			registrationApp.registerModels(appName, LifeCycle.Spreading.Models);
			registrationApp.registerModels(appName, LifeCycle.Rent_Roll.Models);
			registrationApp.registerViewModel(appName, LifeCycle.SpreadConfigApp.ViewModel);
			registrationApp.registerView(appName, LifeCycle.SpreadConfigApp.View);
		};
		return self;
	};
	if(LifeCycle.SpreadConfigApp == undefined){
		LifeCycle.SpreadConfigApp = {};
	}
	if(LifeCycle.SpreadConfigApp.App == undefined){
		LifeCycle.SpreadConfigApp.App = App;
	}

	var valueHandler = ko.bindingHandlers.value;
	ko.bindingHandlers.datepicker = {
		init: function(element, valueAccessor, allBindingsAccessor) {
			var value = ko.unwrap(valueAccessor());
			var container = jQuery(element).closest(".force");
			if (jQuery(element).closest(".modal").length != 0) {
				container = jQuery(element).closest(".modal");
			}
			var options = _.extend( {
				startView: 2,
				autoclose: true,
				container: container
			}, allBindingsAccessor().datepickerOptions || {} );
			jQuery(element).bootstrapDP(options);

			ko.utils.registerEventHandler(element, "changeDate", function () {
				var observable = valueAccessor();
				if (jQuery(element).bootstrapDP("getDate") != null) {
					var d = jQuery(element).bootstrapDP("getDate");
					var formattedDate = (d.getMonth() + 1) + '/' + d.getDate() + '/' + d.getFullYear();
					observable(formattedDate);
				}
			});
		},
		update: function(element, valueAccessor, allBindingsAccessor, data, context) {
			var value = ko.utils.unwrapObservable(valueAccessor())
			if (value != null) {
				value = new Date(value.replace(/\u200E/g,''));
				if (!isNaN(value.valueOf())) {
					jQuery(element).bootstrapDP("setDate", value);
				}
			}

		}
	};
})(LifeCycle.RegistrationApp);
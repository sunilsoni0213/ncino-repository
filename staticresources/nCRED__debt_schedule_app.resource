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
						if(!_.isUndefined(vm.spread)){
							vm.spread.debtScheduleApp = app;
							vm.load();
						}
						return true;
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerModels(appName, LifeCycle.DebtSchedule.Models);
			registrationApp.registerViewModel(appName, LifeCycle.DebtSchedule.ViewModel);
			registrationApp.registerView(appName, LifeCycle.DebtSchedule.View);
		};
		return self;
	};
	if(LifeCycle.DebtSchedule == undefined){
		LifeCycle.DebtSchedule = {};
	}
	if(LifeCycle.DebtSchedule.App == undefined){
		LifeCycle.DebtSchedule.App = App;
	}
	ko.bindingHandlers.timestamp = {
		update: function(element, valueAccessor, allBindingsAccessor){
			var value = ko.utils.unwrapObservable(valueAccessor());
			var brackets = ko.utils.unwrapObservable(allBindingsAccessor().brackets);
			var date = '';
			if ( value != undefined && (new Date(value)) != 'Invalid Date') {
				if (brackets)
					date = '[' + (new Date(value)).toLocaleString() + ']';
				else
					date = (new Date(value)).toLocaleString();
			}
			ko.bindingHandlers.text.update(element, function() { return date; });
		}
	};
	ko.bindingHandlers.strikeThrough = {
		update: function(element, valueAccessor){
			if(ko.utils.unwrapObservable(valueAccessor())){
				jQuery(element).css('text-decoration', 'line-through');
			}else{
				jQuery(element).css('text-decoration', 'none');
			}
		}
	};
	ChangeDetective = function(instance, dataToMonitor){
		var self = this;
		self.instance = instance;
		self.changed = false;
		_.each(dataToMonitor, function(value, key){
			if(key != 'isDirty' && typeof self.instance[key] == 'function'){
				self.instance[key].subscribe(function(newValue){
					instance.savePending(true);
				});
			}
		});
		return self;
	};
})(LifeCycle.RegistrationApp);

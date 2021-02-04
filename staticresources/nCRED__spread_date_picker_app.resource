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
						vm.spread.datePickerApp = app;
						return true;
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerModels(appName, LifeCycle.Relationship.Models);
			registrationApp.registerModels(appName, LifeCycle.Underwriting.Models);
			registrationApp.registerModels(appName, LifeCycle.SpreadDatePicker.Models);
			registrationApp.registerViewModel(appName, LifeCycle.SpreadDatePicker.ViewModel);
		};
		return self;
	};
	if(LifeCycle.SpreadDatePicker == undefined){
		LifeCycle.SpreadDatePicker = {};
	}
	if(LifeCycle.SpreadDatePicker.App == undefined){
		LifeCycle.SpreadDatePicker.App = App;
	}
	ko.bindingHandlers.stopBubble = {
		init: function(element) {
			ko.utils.registerEventHandler(element, "click", function(event) {
				event.cancelBubble = true;
				if (event.stopPropagation) {
					event.stopPropagation(); 
				}
			});
		}
	};

	var valueHandler = ko.bindingHandlers.value;
	ko.bindingHandlers.pValue = {
			
		init: function(element, valueAccessor, allBindingsAccessor, viewModel){
			
			viewModel.pValue =  ko.unwrap(valueAccessor());
			
			ko.utils.registerEventHandler(element, "change", function(event){
				
				var obs = valueAccessor();
				obs(event.target.value);
				
				if(event.target.value != '' && obs() != viewModel.pValue){
					
					var successCallback = function(){
						destroyErrorPopover(element);
						viewModel.pValue = obs();
						window.location.reload();
					};
					
					var failureCallback = function(){
						var exception = arguments[1];
						var msg;
						if(exception.message.indexOf(LifeCycle.msgs.msg_spread_field_custom_validation_exception) > -1){
							var msgRegEx = new RegExp(LifeCycle.msgs.msg_spread_field_custom_validation_exception + ", (.*):");
							var matches = msgRegEx.exec(exception.message);
							msg = matches[1];
						}
						createErrorPopover(element, msg);
					};
					
					if(_.isFunction(viewModel.save)){
						
						viewModel.save(successCallback, failureCallback);
						
					}else{
						
						var objToSave = ko.mapping.toJS(viewModel, app.getMapping());
						LifeCycle.SpreadsService.saveIForce(objToSave, successCallback, failureCallback);
						
					}
					
				}else {
					
					destroyErrorPopover(element);
					
				}
				
			});
			
			valueHandler.init(element, valueAccessor, allBindingsAccessor);
			
			var destroyErrorPopover = function(element){
				if(jQuery(element).hasClass('error')){
					jQuery(element).popover('destroy');
					jQuery(element).removeClass('error');
				}
			};
			
			var createErrorPopover = function(element, msg){
				if(_.isUndefined(msg)){
					 msg = '<p>An internal error has occured while saving.  <br /><br />Please reload the browser.</p>';
				}
				jQuery(element).addClass('error');
				jQuery(element).popover(
					{
						placement: 'top',
						html: true,
						content: msg, 
						trigger: 'hover'
					}
				);
			};

			
		},
		update: valueHandler.update
	};
})(LifeCycle.RegistrationApp);
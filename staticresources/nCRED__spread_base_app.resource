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
						if(!_.isUndefined(vm.screenSection) && _.isFunction(vm.screenSection.recordId)){
							jQuery(document).one(vm.screenSection.recordId(),
								function(event, anchorVM){
								vm.loanId = ko.observable(vm.contextObject.recordId());	
								vm.anchorVM = anchorVM;
								if(!_.isUndefined(vm.anchorVM.screenResources)){
									var screenResource = app.mapToJS(vm.anchorVM.screenResources);
									var key = Object.keys(screenResource)[0];
									var namespaceRE = /nFORCE.MappedSObjectHierarchyScreenResource_([A-Z_0-9a-z]*)__Loan__c/g;
									var matches = namespaceRE.exec(key);
									var namespace = matches[1];
									var params = app.mapToJS(anchorVM.widget().widgetParams());
									_.each(screenResource[key]['children'][0]['children'], function(item){
										var entityId = item['propertyBag'][namespace + '__Legal_Entities__c_Id'].value;
										vm.entities.push(LifeCycle.SpreadData.lookupIForceById(entityId, {
											generatePlaceholder: true,
											alwaysReturnModel: true,
											placeholderType: 'c.ALifeCycleInvolvement'
										}));
										LifeCycle.SpreadData.getIForceById(entityId, {}, function (_entity) {
											vm.loadedEntities.push(_entity)
										});
										if(!_.isUndefined(item['children'][0]['children'][0]['children'][0])){
											var propertyBag = item['children'][0]['children'][0]['children'][0]['propertyBag'];
											var bundleId = propertyBag[namespace + '__Underwriting_Bundle__c_Id'].value;
											vm.bundles().push(new app.UnderwritingBundle({recordId: bundleId}));
										}
									});
									if(vm.bundles().length > 0){
										vm.viewMode('display');
										vm.load(params);
									}
								}
								
							});
						}else{
							jQuery('#printConfigModal').modal({
								backdrop: 'static',
								keyboard: false
							});
						}
						return true;
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerModels(appName, LifeCycle.Relationship.Models);
			registrationApp.registerModels(appName, LifeCycle.Spreading.Models);
			registrationApp.registerModels(appName, LifeCycle.Underwriting.Models);
			registrationApp.registerModels(appName, LifeCycle.Covenant.Models);
			registrationApp.registerViewModel(appName, LifeCycle.Spread_Base.ViewModel);
			registrationApp.registerView(appName, LifeCycle.Spread_Base.View);
		};

		return self;
	};
	if(LifeCycle.Spread_Base == undefined){
		LifeCycle.Spread_Base = {};
	}
	if(LifeCycle.Spread_Base.App == undefined){
		LifeCycle.Spread_Base.App = App;
	}
})(LifeCycle.RegistrationApp);

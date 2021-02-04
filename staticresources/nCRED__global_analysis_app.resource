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
						if(_.isUndefined(vm.spread)) {
							vm.spread = {
								commentsApp: {},
								debtScheduleApp: {},
								footnotesApp: {},
								globalAnalysisApp: {},
								recordId: null
							};
							if(!_.isUndefined(vm.screenSection) && _.isFunction(vm.screenSection.recordId)){
								jQuery(document).one(vm.screenSection.recordId(),
									function(event, anchorVM){
									
									vm.anchorVM = anchorVM;
									if(!_.isUndefined(vm.anchorVM.screenResources)){
										var screenResource = app.mapToJS(vm.anchorVM.screenResources);
										var key = Object.keys(screenResource)[0];
										var namespaceRE = /nFORCE.MappedSObjectHierarchyScreenResource_([A-Z_0-9a-z]*)__Loan__c/g;
										var matches = namespaceRE.exec(key);
										var namespace = matches[1];
										var params = app.mapToJS(anchorVM.widget().widgetParams());
										_.each(screenResource[key]['children'][0]['children'], function(item){
											vm.relatedEntities.push({
												'accountId': item['propertyBag'][namespace + '__Legal_Entities__c_'+namespace+'__Account__c'].value,
												'involvementId': item['propertyBag'][namespace + '__Legal_Entities__c_Id'].value,
												'name': item['propertyBag'][namespace + '__Legal_Entities__c_Name'].value,
												'borrowerType': item['propertyBag'][namespace + '__Legal_Entities__c_'+namespace+'__Borrower_Type__c'].value,
												'accountType': item['propertyBag'][namespace + '__Legal_Entities__c_'+namespace+'__Relationship_Type__c'].value
											});
											if(!_.isUndefined(item['children'][0]['children'][0]['children'][0])){
												var propertyBag = item['children'][0]['children'][0]['children'][0]['propertyBag'];
												var bundleId = propertyBag[namespace + '__Underwriting_Bundle__c_Id'].value;
												vm.bundles().push(new app.UnderwritingBundle({recordId: bundleId}));
											}
										});
										if(vm.bundles().length > 0){
											vm.spread.globalAnalysisApp = app;
											vm.mode('print');
											vm.isOpen(true);
											vm.load();
										}
									}
								});
							}
						} else {
							vm.spread.globalAnalysisApp = app;
							vm.load();
						}	
						return true;
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerModels(appName, LifeCycle.Relationship.Models);
			registrationApp.registerModels(appName, LifeCycle.Spreading.Models);
			registrationApp.registerModels(appName, LifeCycle.Underwriting.Models);
			registrationApp.registerModels(appName, LifeCycle.GlobalAnalysis.Models);
			registrationApp.registerViewModel(appName, LifeCycle.GlobalAnalysis.ViewModel);
		};
		return self;
	};

	if(LifeCycle.GlobalAnalysis == undefined){
		LifeCycle.GlobalAnalysis = {};
	}

	if(LifeCycle.GlobalAnalysis.App == undefined){
		LifeCycle.GlobalAnalysis.App = App;
	}
})(LifeCycle.RegistrationApp);

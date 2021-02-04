(function(registrationApp){
	var App = function(){

		var self = this;

		self.register = function(appName, appData){
			registrationApp.registerExtension(function(event, registrationApp){
				registrationApp.registerAppName(appName);
				(function(app){
					app.preRun = function(data){
                        appData.validationMessage = appData.validationMessage || LifeCycle.msgs.msg_risk_grade_validation;
                        appData.approved = appData.approved || LifeCycle.msgs.msg_annual_review_approved;
                        appData.declined = appData.declined || LifeCycle.msgs.msg_annual_review_declined;
                        appData.quantitative = appData.quantitative || LifeCycle.msgs.msg_risk_grade_quantitative;

						return (appData != undefined ? appData : data);
					}
					app.postRun = function(vm){

					    function getReviewIdSelectedForDisplay(loanResource, namespace){
                            for(var i = 0; i < loanResource.children()[0].children().length; i++){
                                var reviewResource = loanResource.children()[0].children()[i];
                                var key = namespace + '__Annual_Review__c_' + namespace + '__Display_In_Credit_Memo__c';
                                if(reviewResource.propertyBag[key].value()){
                                    return reviewResource;
                                }
                            }
                        }

                        function getNamespace(screenResource){
                            var key = Object.keys(screenResource)[0];
                            var namespaceRE = /nFORCE.MappedSObjectHierarchyScreenResource_([A-Z_0-9a-z]*)__Loan__c/g;
                            var matches = namespaceRE.exec(key);
                            var namespace = matches[1];

                            return namespace;
                        }

                        if(!_.isUndefined(vm.screenSection) && _.isFunction(vm.screenSection.recordId)){
                            jQuery(document).one(vm.screenSection.recordId(),
                                function(event, anchorVM){
                                    vm.loanId = ko.observable(vm.contextObject.recordId());

									if(!_.isUndefined(anchorVM.screenResources)){
										var screenResource = app.mapToJS(anchorVM.screenResources);
										var namespace = getNamespace(screenResource);
										var widgetParameters = app.mapToJS(anchorVM.widget().widgetParams());
										var loanResource =  anchorVM.screenResources()['nFORCE.MappedSObjectHierarchyScreenResource_' + namespace + '__Loan__c'];
										var reviewResource = getReviewIdSelectedForDisplay(loanResource, namespace);
										vm.readOnly = function() { return widgetParameters['readOnly']};

										if(_.isUndefined(reviewResource)){
											vm.review = undefined;
										}else{
											vm.review = new app.Review({
												recordId: function(){
													return reviewResource.propertyBag[namespace + '__Annual_Review__c_Id'].value()
												}
											});
										}
									}

									ko.applyBindings(vm, document.getElementById(vm.screenSection.recordId()));
									vm.load();
                                });
                       } else {
                         setTimeout(vm.load, 1000);
                       }

						return true;
					};
				})(registrationApp.registeredApps[appName]);

				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerModels(appName, LifeCycle.Risk_Grade.Models);
			registrationApp.registerViewModel(appName, LifeCycle.Risk_Grade_Worksheet.ViewModel);
		};
		return self;
	};

	if(LifeCycle.Risk_Grade_Worksheet == undefined){
		LifeCycle.Risk_Grade_Worksheet = {};
	}

	if(LifeCycle.Risk_Grade_Worksheet.App == undefined){
		LifeCycle.Risk_Grade_Worksheet.App = App;
	}
})(LifeCycle.RegistrationApp);
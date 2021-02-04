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
						if(vm.screenSectionId){
							Layout.readLayoutData(
									vm.screenSectionId(),
									vm.guid(),
									app.mapToJS(vm.contextObject),
									function(data){
										app.mapFromJS(data, app.getMapping(), vm);
										vm.clone();
										if(vm.widget().isKnockout()){
											vm.signalWidgets();
										} else if (!vm.hasWidget()) {
											if (!_.isUndefined(LifeCycle.Force)) {
												var renderedView = jQuery('#'+vm.screenSectionId()).html();
												var regex = / data-bind=\".*\"/g;
												renderedView = renderedView.replace(regex, '');
												LifeCycle.Force.saveAttachment(
													vm.screenSectionId(),
													LifeCycle.msgs.msg_rendered_view_filename,
													LifeCycle.msgs.msg_text_plain,
													renderedView,
													true,
													false,
													function(){},
													function(){});
											}

										}
									},
									Layout.errorFunction);
						}
						jQuery(window).on("load", vm.load);
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
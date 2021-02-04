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
						jQuery(document).one(vm.screenSection.recordId(), 
							function(event, layoutDesignerVM){
								var screenSectionId = layoutDesignerVM.screenSectionId();	
								vm.load(function(){
									ko.applyBindings(vm, document.getElementById(screenSectionId));
								});
							}
						);
						return true;
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log(appName + ' App initialized.');
			});
			registrationApp.registerModels(appName, LifeCycle.CreditMemo.Models);
			registrationApp.registerViewModel(appName, LifeCycle.KO_Narrative.ViewModel);
			registrationApp.registerView(appName, LifeCycle.KO_Narrative.View);
		};
		return self;
	};
	if(LifeCycle.KO_Narrative == undefined){
		LifeCycle.KO_Narrative = {};
	}
	if(LifeCycle.KO_Narrative.App == undefined){
		LifeCycle.KO_Narrative.App = App;
	}

	ko.bindingHandlers.ckEditor = {

		init: function(element, valueAccessor, allBindings, deprecated, bindingContext){
			var text = ko.utils.unwrapObservable(valueAccessor());
			if(bindingContext.widgetParams != undefined){
				var options = ko.utils.unwrapObservable(bindingContext.widgetParams);
			}
 			var editor = jQuery( element ).ckeditor( function( ckEditor ) {
 				// retrieve the HTML from the attachment

	 		}).editor;

	 		if (typeof bindingContext.$data.widget.parameters().maxSize == 'function')
	 			editor.maxAttachmentSize = bindingContext.$data.widget.parameters().maxSize();
	 		else
	 			editor.maxAttachmentSize = 6000000;
	   		editor.on('paste', function(evt){
	   			console.log(evt);
	   		});
	   		editor.on('change', function () {
	   			if (editor.loaded) {
	   				editor.commands.save.enable();
	   			}
	   			else {
	   				editor.loaded = true;
	   				editor.resetDirty();
	   			}
	   		});
	   		// wait until the editor is done initializing
			editor.on('instanceReady',function() {
				editor.loaded = false;

				LifeCycle.Force.retrieveAttachment(
					editor.element.getId(),
					msgs.msg_rendered_view_filename,
					function(data){
						if(data != null){
							view = jQuery('<textarea />').html(data.body).text();
							if (view != '')
								editor.setData(view, function () {
									if (editor.config.setupDropZone)
										editor.config.setupDropZone(editor);
									
									editor.undoManager.save();
									var numSnaps = editor.undoManager.snapshots.length;
									var saveSnapshot = editor.undoManager.snapshots[numSnaps - 1];
									editor.config.initialSnapshot = saveSnapshot;
									editor.commands.cancel.disable();
								})
							else
								editor.loaded = true;
						}
					},
					function(){}
				);
		   			
		 	}, options);
	 	}
		
	};

})(LifeCycle.RegistrationApp);
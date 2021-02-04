(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;

			self.app = app;
			var defaultData = {
					screenResources: ko.observable(),
					'sectionName': '',
					'isHeadless': false,
					'isEditing': false,
					'isViewing': false,
					'isPreviewing': false,
					'isEditable': false,
					'instructions': '',
					'breakPageAfter': false,
					'breakPageBefore': false,
					'disablePrint': false,
					'displayOrder': '',
					'hasWidget': false,
					widget: ko.observable(),
					'displayToggleEffect': null,
					'hasDisplayToggleHeader': true,
					'hasDisplayToggleEffect': false
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.rawClone = {};
			self.clone = function(){
				self.rawClone =
					_.extend({}, ko.mapping.toJS(self));

				return self.rawClone;
			};
			self.print = function(){
				if(!self.disablePrint()){
					window.print();
				}
			};
			self.isValid = function(){
				return self.screenResources().isValid();
			};
			self.toggleExpand = function(){
				if(self.isExpanded()){
					if (jQuery.isFunction(self.isViewing))
						self.isViewing(false);
					if (jQuery.isFunction(self.isPreviewing))
						self.isPreviewing(false);
					if (jQuery.isFunction(self.isEditing))
						self.isEditing(false);
				}
				else{
					self.isViewing(true);
				}
			};
			self.isExpanded = ko.computed(function(){
				return self.isViewing() ||
					self.isEditing() ||
					self.isPreviewing();
			});
			self.toggleViewing = function(){
				self.isViewing(!self.isViewing());
				return false;
			}
			self.toggleEditing = function(){
				self.isEditing(!self.isEditing());
				return false;
			}
			self.togglePreviewing = function(){
				self.isPreviewing(!self.isPreviewing());
				return false;
			}
			self.isViewing.subscribe(function(newVal){
				if(newVal){
					self.isPreviewing(false);
					self.isEditing(false);
				}
			});
			self.isEditing.subscribe(function(newVal){
				if(newVal){
					self.isPreviewing(false);
					self.isViewing(false);
				}
			});
			self.isPreviewing.subscribe(function(newVal){
				if(newVal){
					self.isEditing(false);
					self.isViewing(false);
				}
			});
			self.save = function(){
				app.log('saving viewModel');
				if(this.isValid()){
					Layout.saveLayoutData(
							this,
							function(data){
								app.log('successfully saved viewModel');
								app.mapFromJS(data, app.getMapping(), self);
								self.clone();
							},
							Layout.errorFunction);
				}
				else{
					app.log('view model is invalid');
				}
			};
			self.expandAll = function(){
				return self.actionParentApps(function(vm){
					vm.isViewing(true);
				});
			};
			self.hideAll = function(){
				return self.actionParentApps(function(vm){
					if (jQuery.isFunction(vm.isViewing))
						vm.isViewing(false);
					if (jQuery.isFunction(vm.isPreviewing))
						vm.isPreviewing(false);
					if (jQuery.isFunction(vm.isEditing))
						vm.isEditing(false);
				});
			};
			self.actionParentApps = function(action){
				var anchorApp = self.app;
				while(anchorApp != null){
					action(anchorApp.viewModel);
					anchorApp = anchorApp.parentApp();
				}
				return false;
			}
			self.anchorVM = ko.computed(function(){
				var anchorApp = self.app;
				while(anchorApp.parentApp() != null){
					if(!anchorApp.viewModel.isHeadless()){
						return anchorApp.viewModel;
					}
					anchorApp = anchorApp.parentApp();
				}
				return anchorApp.viewModel;
			});
			self.editingContent = undefined;
			self.saveNarrative = function(vm){
				var activeEditorId = jQuery('#wysiwyg_'+vm.guid()).data('liveEdit').getActiveEditorId();
				if (!activeEditorId) return;

				var sHtml = jQuery('#' + activeEditorId).data('liveEdit').getXHTMLBody();

				Layout.saveNarrativeData(
					jQuery('#wysiwyg_id_'+vm.guid()).val(),
					sHtml,
					function(){
						self.editingContent = undefined;
						jQuery('#' + activeEditorId).css({minHeight: '0'}).data('liveEdit').finishedit();
						self.toggleWysiwig(vm.guid());
					},
					Layout.errorFunction
				);
			};
			self.enterWysiwig = function(vm){
				var activeWidget = jQuery('#wysiwyg_'+vm.guid());
				activeWidget.liveEdit({
					css: ['bootstrap/css/bootstrap.min.css', 'bootstrap/bootstrap_extend.css'],
					groups: [
						["group1", "", ["Bold", "Italic", "Underline", "FontName", "ForeColor", "RemoveFormat"]],
						["group2", "", ["Bullets", "Numbering", "Indent", "Outdent"]],
						["group3", "", ["Paragraph", "FontSize"]],
						["group4", "", ["LinkDialog", "ImageDialog", "TableDialog"]],
						["group5", "", ["Undo", "Redo", "FullScreen"]]
					]
				});
				activeWidget.css({minHeight: '20em'}).data('liveEdit').startedit();
				self.editingContent = activeWidget.data('liveEdit').getXHTMLBody();
				self.toggleWysiwig(vm.guid());
			};
			self.cancelWysiwig = function(vm){
				var activeEditorId = jQuery('#wysiwyg_'+vm.guid()).data('liveEdit').getActiveEditorId();
				if (!activeEditorId) return;

				var activeWidget = jQuery('#' + activeEditorId);
				if(!_.isUndefined(self.editingContent)){
					activeWidget.data('liveEdit').loadHTML(self.editingContent);
					self.editingContent = undefined;
				}
				activeWidget.css({minHeight: '0'}).data('liveEdit').finishedit();
				self.toggleWysiwig(vm.guid());
			};
			self.toggleWysiwig = function(guid){
				if(jQuery('#wysiwyg_controls_'+ guid).is(':visible')) {
					self.widget().isActive(false);
					jQuery('#wysiwyg_controls_'+ guid).hide();
					jQuery('#wysiwyg_edit_link_'+ guid).show();
					jQuery('button[id^="wysiwyg_edit_link_"]')
						.removeAttr('disabled')
						.removeAttr('title');
				} else {
					self.widget().isActive(true);
					jQuery('#wysiwyg_controls_'+ guid).show();
					jQuery('#wysiwyg_edit_link_'+ guid).hide();
					jQuery('button[id^="wysiwyg_edit_link_"]')
						.attr('disabled','disabled')
						.attr('title', LifeCycle.msgs.msgs_narrative_edit_blocked);
				}
			};
			self.signalWidgets = function(){
				jQuery(document).trigger( jQuery.Event(self.screenSectionId()), [self])
			};
			app.log('ViewModel instantiated.');
			return self;
		}
		app.log('ViewModel initialized.');
	};
	if(LifeCycle.LayoutDesigner.ViewModel == undefined){
		LifeCycle.LayoutDesigner.ViewModel = ViewModel;
	}
})();
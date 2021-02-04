(function(){
	var viewModelArray = [];
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;

			self.app = app;
			var defaultData = {
				'guid': null,
				'screenResources': ko.observable(),
				'sectionName': '',
				'isHeadless': false,
				'isEditing': false,
				'isPreviewing': false,
				'isViewing': false,
				'isEditable': true,
				'isDefaultEditable': false,
				'instructions': '',
				'breakPageAfter': false,
				'breakPageBefore': false,
				'disablePrint': false,
				'displayOrder': null,
				'hasWidget': false,
				'widget': ko.observable(),
				'displayToggleEffect': null,
				'hasDisplayToggleHeader': true,
				'saveBodyAsAttachment': false,
				'showLoader': true
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			/* Unmapped Properties */
			self.hasDisplayToggleEffect = ko.observable(false);

			self.uniqueChildren = {};

			self.screenResource = ko.computed({
				read: function(){
					return _.first(_.filter(self.screenResources(), function(resource) {
						return resource instanceof app.ScreenResource;
					}));
				},
				deferEvaluation: true
			});
			self.anchorVM = ko.computed(function(){
				var anchorApp = self.app;
				while(anchorApp.parentApp() != null){
					if(!ko.unwrap(anchorApp.viewModel.isHeadless())) {
						return anchorApp.viewModel;
					}
					anchorApp = anchorApp.parentApp();
				}
				return anchorApp.viewModel;
			});
			self.getApp = function(){
				return self.app;
			};
			self.pageBreakStatus = ko.computed(function() {
				return self.breakPageAfter() ? "stitchedActive" : "stitched";
			});
			self.pageBreakTextStatus = ko.computed(function() {
				return self.breakPageAfter() ? "page-break-text-active" : "page-break-text";
			});

			self.isUnique = function(resource){
				if (resource && resource.data.configuration) {
					var idField = resource.data.configuration.sObjectType + '_Id';
					var idProperties = _.filter(_.values(resource.propertyBag), function(property){
						return property.data.hasOwnProperty('guid') &&
							property.data.guid === idField;
					});
					var recordId = idProperties.shift();
					if (recordId && !self.uniqueChildren[recordId.value()]) {
						self.uniqueChildren[recordId.value()] = resource;
						return resource;
					}
				}
				return null;
			};

			self.unique = function(children){
				var toReturn = [];
				_.each(children(), function(child){
					var uniqueChild = self.isUnique(child);
					if(uniqueChild){
						toReturn.push(uniqueChild);
					}
				});
				return toReturn;
			};

			self.hasData = function(resource){
				if(resource && resource.data && resource.data.configuration && resource.data.configuration.layoutName !== 'NoLayout'){
					return !!resource.data.guid;
				}
				return false;
			};
			self.hasValidChildren = function($data, depthsToInclude){
				var isValid = true;
				for (var i = 0; i < depthsToInclude.length; i++) {
					isValid = true;
					var context = $data;
					for (var k = 0; k <= depthsToInclude[i]; k++) {
						if (k > 0) {
							context = context.children()[0];
						}
						if (!context) {
							isValid = false;
							break;
						}
					}
					if (isValid && (isValid = this.hasData(context))){
						break;
					}
				}
				return isValid;
			};

			/* Actions */
			self.isExpanded = ko.computed(function(){
				return self.isViewing();
			});

			self.toggleExpand = function(){
				self.isViewing(!self.isViewing());
			};

			self.togglePageBreak = function(){
				self.breakPageAfter(!self.breakPageAfter());
				self.screenResources = [];
				var data = app.mapToJS(self, {useOptimizedMapper: true, maxDepth:0, maxHeight: 0});
				delete data.showLoader;
				Layout.saveSectionData(
					data,
					function(data){},
					function(event, result){
						console.log(event.message);
					}
				);
			};

			self.loadConfigurationData = function(){
				Layout.readLayoutData(
					self.screenSectionId(),
					self.guid(),
					app.mapToJS(self.contextObject),
					function(data){
						app.mapFromJS(data, app.getMapping(), self);
						for(var rootResource in self.screenResources()){
							var resource = self.screenResources()[rootResource];
							if(resource instanceof app.ScreenResource){
								var numberOfChildren = resource.children().length;
								if(numberOfChildren > 0 && !LifeCycle.infiniteScrollLoad){
									for(var i=0; i < resource.children().length; i++){
										self.loadMoreData(resource.children()[i], function(){
											if(--numberOfChildren <= 0){
												self.signalLoadEnd();
											}
										});
									}
								} else {
									self.signalLoadEnd();
								}
							}
						};
					},
					function(event, result){
						app.performingAjax(false);
						Layout.errorFunction(event, result);
					}
				);
			};
			self.loadMoreChildren = function(){
				for(var rootResource in self.screenResources()){
					var resource = self.screenResources()[rootResource];
					if(resource instanceof app.ScreenResource){
						var numberOfChildren = resource.children().length;
						if(numberOfChildren > 0){
							jQuery.each(resource.children(), function(index, listResource){
								self.loadMoreData(listResource, function(){
									if(--numberOfChildren <= 0){
										self.signalLoadEnd();
									}
								});
							});
						} else {
							self.signalLoadEnd();
						}
					}
				};
			}
			self.loadMoreData = function(listResource, finishedLoading){
				if(LifeCycle.infiniteScrollLoad){
					self.showLoader(true);
				}
				if(listResource.remainingIds && listResource.remainingIds() && listResource.remainingIds().length > 0){
					var idsToQuery = listResource.remainingIds().splice(0, listResource.limitValue());
					var childClone = _.clone(listResource.data);
					childClone.remainingIds = idsToQuery;
					childClone.children = [];
					Layout.readMoreData(
						childClone,
						function(data){
							if(!LifeCycle.infiniteScrollLoad){
								self.loadMoreData(listResource, finishedLoading);
							}
							listResource.addChildren(data.children);
							self.showLoader(false);
						}
					);
				} else {
					finishedLoading();
				}
			};

			self.saveAttachment = function(screenSectionId){
				if(self.screenSectionId() == screenSectionId && !_.isUndefined(LifeCycle.Service)){
					var renderedView = jQuery('#' + self.screenSectionId()).clone();
					var dataBinds = jQuery(renderedView).find('*[data-bind]');
					jQuery(dataBinds).attr('data-bind', '');
					LifeCycle.Service.saveAttachment(
						self.screenSectionId(),
						LifeCycle.msgs.msg_rendered_view_filename,
						LifeCycle.msgs.msg_text_plain,
						renderedView.html(),
						true,
						false,
						function(){},
						function(){});
				}
			};

			self.signalLoadEnd = function(){
				self.showLoader(false);
				if(self.widget().isKnockout()){
					self.signalWidgets();
				}
				if(!self.widget().isNarrative() && self.saveBodyAsAttachment()){
					app.publish('layoutDesigner.saveRenderedView', self.screenSectionId());
				}
				jQuery('.force .form-control').first().focus();
				jQuery(window).scrollTop(0);
				app.performingAjax(false);
			}

			self.print = function(){
				if(!self.disablePrint()){
					window.print();
				}
			};

			self.setFocusFirstFormControl = function(isRenderingComplete){
				if(isRenderingComplete){
					jQuery('.force .form-control:first').focus();
				}
			};
			/* Mass Actions */
			self.expandAll = function(){
				return self.actionParentApps(function(vm){
					vm.isViewing(true);
				});
			};
			self.hideAll = function(){
				return self.actionParentApps(function(vm){
					vm.isViewing(false);
					vm.isEditing(false);
					vm.isPreviewing(false);
				});
			};
			self.actionParentApps = function(action){
				var anchorApp = self.app;
				while(anchorApp != null){
					action(anchorApp.viewModel);
					anchorApp = anchorApp.parentApp();
				}
				return false;
			};

			self.signalWidgets = function(){
				jQuery(document).trigger(jQuery.Event(self.screenSectionId()), [self]);
			};

			/* Topic Subscriptions */
			if(self.saveBodyAsAttachment()){
				app.subscribe('layoutDesigner.saveRenderedView', self.saveAttachment);
			}

			/* Original Narrative Widget */
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
					function(){}
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

			if(LifeCycle.infiniteScrollLoad){
				app.subscribe('Infinite_Scroll_Load_More', self.loadMoreChildren);
				jQuery(window).scroll(function() {
					if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight) {
						if(!self.showLoader()){
							app.publish('Infinite_Scroll_Load_More');
						}
					}
				});
			}

			app.log('ViewModel instantiated.');
			return self;
		}
		app.log('ViewModel initialized.');
	};
	if(LifeCycle.LayoutViewer.ViewModel == undefined){
		LifeCycle.LayoutViewer.ViewModel = ViewModel;
	}
})();
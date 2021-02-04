(function(){
	var viewModelArray = [];
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			var toggleSubscribed = false;

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
				'executeBusinessLogic': function() {},
				'hasWidget': false,
				'widget': ko.observable(),
				'displayToggleEffect': null,
				'hasDisplayToggleHeader': true,
				'saveBodyAsAttachment': false
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			/* Unmapped Properties */
			self.showLoader = ko.observable(!LifeCycle.infiniteScrollLoad);
			self.isAdding = ko.observable(false);
			self.isDeleting = ko.observable(false);
			self.isLocked = ko.observable(false);
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

			/* State Tracking */
			self.isAdding.subscribe(function(newVal){
				if(newVal){
					self.isDeleting(false);
					self.isPreviewing(false);
					self.isViewing(false);
				}
			});
			self.isDeleting.subscribe(function(newVal){
				if(newVal){
					self.isAdding(false);
					self.isEditing(false);
					self.isPreviewing(false);
					self.isViewing(false);
				}
			});
			self.isEditing.subscribe(function(newVal){
				if(newVal){
					self.isDeleting(false);
					self.isPreviewing(false);
					self.isViewing(false);
				}
			});
			self.isPreviewing.subscribe(function(newVal){
				if(newVal){
					self.isAdding(false);
					self.isDeleting(false);
					self.isEditing(false);
					self.isViewing(false);
				}
			});
			self.isViewing.subscribe(function(newVal){
				if(newVal){
					self.isAdding(false);
					self.isDeleting(false);
					self.isEditing(false);
					self.isPreviewing(false);
				}
			});
			self.isExpanded = ko.computed(function(){
				return self.isViewing() ||
					self.isEditing() ||
					self.isPreviewing();
			});
			self.hasDirtyData = ko.computed({
				read: function(){
					return _.isUndefined(self.screenResource())
							? false
							: self.screenResource().hasDirtyData();
				},
				write: function(value){
					if(!_.isUndefined(self.screenResource())){
						self.screenResource().hasDirtyData(value);
					}
				}
			});
			self.pageBreakStatus = ko.computed(function() {
				return self.breakPageAfter() ? "stitchedActive" : "stitched";
			});
			self.pageBreakTextStatus = ko.computed(function() {
				return self.breakPageAfter() ? "page-break-text-active" : "page-break-text";
			});
			self.hasDirtyData.subscribe(function(value){
				if(value){
					jQuery(window).on('beforeunload.ui', function(){
						return LifeCycle.msgs.msg_dirty_data_warning;
					});
				} else {
					jQuery(window).off('beforeunload.ui');
				}
			});

			self.isUnique = function(resource){
				if(resource) {
					var idField = resource.configuration.sObjectType() + '_Id';
					var idProperties = _.filter(_.values(resource.propertyBag), function(property){
						return property.hasOwnProperty('guid') &&
							property.guid() === idField;
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
				if(resource && resource.data) {
					return !!resource.data.guid;
				}
				return false;
			};
			self.hasValidChildren = function($data, depthsToInclude){
				return true;
			};

			/* Actions */
			self.toggleAdding = function(){
				self.clearError();
				self.isEditing(self.isDefaultEditable() || !self.isAdding());
				self.isAdding(!self.isAdding());
				return false;
			};
			self.toggleDeleting = function(){
				self.clearError();
				self.isDeleting(!self.isDeleting());
				return false;
			};
			self.toggleEditing = function(){
				if(viewModelArray == null || !viewModelArray || viewModelArray == []){
						self.clearError();
				} else {
					if(viewModelArray.length < 2){
						self.clearError();
					}
				}
				self.isEditing(self.isDefaultEditable() || !self.isEditing());
				return false;
			};
			self.togglePreviewing = function(){
				self.clearError();
				self.isPreviewing(!self.isPreviewing());
				return false;
			};
			self.toggleViewing = function(){
				self.clearError();
				self.isViewing(!self.isViewing());
				return false;
			};
			self.toggleExpand = function(){
				if(self.isExpanded()){
					self.isViewing(false);
					self.isPreviewing(false);
					self.isEditing(false);
				}
				else{
					self.isViewing(true);
				}
			};
			self.togglePageBreak = function(){
				self.breakPageAfter(!self.breakPageAfter());
				Layout.saveSectionData(
					app.mapToJS(self, {useOptimizedMapper: true, maxDepth:0, maxHeight: 0}),
					function(data){},
					function(event, result){
						console.log(event.message);
					}
				);
			};

			self.navigate = function(href, event){
				LifeCycle.Navigator.navigateToRoute(href, event);
			};

			self.create = function(resource){
				if(resource.isCreateable()){
					LifeCycle.blockUI();

					Layout.createNew(
						app.mapToJS(resource),
						function(data){
							if(resource.isList()){
								resource.selectedChild(resource.children.mappedCreate(data));
							} else {
								app.mapFromJS(data, app.getMapping(), resource);
							}

							self.toggleAdding();
							LifeCycle.unblockUI();
						},
						self.errorHandler
					);
				}
			};

			self.save = function(resource, tracker){
				if((self.isAdding() && resource.isCreateable())
						|| (!self.isAdding() && resource.isUpdateable())){

					LifeCycle.blockUI();

					tracker = (tracker && _.isFunction(tracker) ? tracker : function(){});
					tracker(app.appId, null);

					viewModelArray.push(self);

					var toSave = resource.isList() ? resource.selectedChild() : resource;

					Layout.saveLayoutData(
						app.mapToJS(toSave),
						function(data){
							app.mapFromJS(data, app.getMapping(), toSave);

							if(resource.isList()){
								self.saveSuccess();
							}

							tracker(app.appId, 'success');

							if(!toggleSubscribed){
								self.isAdding() ? self.toggleAdding() : self.toggleEditing();
							}

							LifeCycle.unblockUI();
						},
						function(event, result){
							var selfIndex = 0;
							while ((selfIndex = viewModelArray.indexOf(self, selfIndex)) > -1 ){
								viewModelArray.splice(selfIndex, 1)
							}
							tracker(app.appId, 'failure');

							self.errorHandler(event, result);
						}
					);
				}
			};
			self.cancel = function(resource){
				if(self.isAdding()){
					if(resource.isList()){
						resource.children.remove(resource.selectedChild());
						resource.selectedChild(undefined);
					}
					self.toggleAdding();
				}
				if(self.isEditing()){
					self.hasDirtyData(false);
					self.toggleEditing();
				}
			};
			self.delete = function(resource){
				if(resource.isDeletable()){
					if(confirm(LifeCycle.msgs.msg_confirm_delete)){
						LifeCycle.blockUI();
						self.toggleDeleting();

						var toDelete = resource.isList() ? resource.selectedChild() : resource;

						self.executeBusinessLogic(
							app.mapToJS(toDelete),
							'screen-resource-delete-container-bean',
							function(){
								if(resource.isList()){
									resource.children.remove(toDelete);
									resource.selectedChild(undefined);
								}
								self.toggleDeleting();
								self.deleteSuccess();
								LifeCycle.unblockUI();
							},
							self.errorHandler
						);
					}
				}
			};

			self.loadConfigurationData = function(){
				Layout.readLayoutData(
					self.screenSectionId(),
					self.guid(),
					app.mapToJS(self.contextObject),
					function(data){
						app.mapFromJS(data, app.getMapping(), self);
						if(!LifeCycle.infiniteScrollLoad){
							self.loadMoreChildren();
						}
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
					var idsToQuery = listResource.remainingIds().splice(0, listResource.configuration.limitValue());
					var childClone = _.clone(app.mapToJS(listResource));
					childClone.remainingIds = idsToQuery;
					childClone.children = [];
					Layout.readMoreData(
						childClone,
						function(data){
							if(!LifeCycle.infiniteScrollLoad){
								self.loadMoreData(listResource, finishedLoading);
							}
							var underlyingChildrenArray = listResource.children();
							for(var i=0, j=data.children.length; i<j; i++){
								var child = data.children[i];
								underlyingChildrenArray.push(
									app.mapFromJS(child, app.getMapping(), new app.ScreenResource(child))
								);
							}
							listResource.children.valueHasMutated();
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
			self.getCurrencyIsoCode = function(contextIdentifier, propertyBag) {
				var currencyFieldGuid = contextIdentifier + '_CurrencyIsoCode';
				var currencyIsoCode = propertyBag[currencyFieldGuid];
				if (currencyIsoCode) {
					return currencyIsoCode.value();
				}
				return '';
			};
			/* Topic Transmissions */
			if(LifeCycle.GlobalActionButtonHandler) {
				function identifyFlatResource(resource) {
					var flat = undefined;

					if(resource instanceof app.ScreenResource && !resource.isList()) {
						if(resource.isFlat() && !resource.hasChildren()) {
							flat = resource;
						}
						else {
							_.each(resource.children(), function(child) {
								flat = identifyFlatResource(child);
								if(flat) {
									return flat;
								}
							})
						}
					}

					return flat;
				}

				var subscription;
				self.screenResource.subscribe(function(resource) {

					resource = identifyFlatResource(resource);
					if(resource && resource.isUpdateable()) {

						if(self.isEditable()) {

							if(self.isDefaultEditable()) {
								app.publish(LifeCycle.Topics.GlobalActionButtonHandler.SHOW_SAVE);
								app.publish(LifeCycle.Topics.GlobalActionButtonHandler.FIRE_SAVE_WITH_CONTINUE);
							}
							else {
								app.publish(LifeCycle.Topics.GlobalActionButtonHandler.SHOW_EDIT);
							}

							if(subscription) {
								subscription.dispose();
							}

							subscription = self.isEditing.subscribe(function(value) {
								app.publish(LifeCycle.Topics.GlobalActionButtonHandler.RESET);

								if(value) {
									app.publish(LifeCycle.Topics.GlobalActionButtonHandler.SHOW_SAVE);

									if(self.isDefaultEditable()) {
										app.publish(LifeCycle.Topics.GlobalActionButtonHandler.SHOW_CONTINUE);
									}
									else {
										app.publish(LifeCycle.Topics.GlobalActionButtonHandler.SHOW_CANCEL);
									}
								}
								else {
									app.publish(LifeCycle.Topics.GlobalActionButtonHandler.SHOW_EDIT);
									app.publish(LifeCycle.Topics.GlobalActionButtonHandler.SHOW_CONTINUE);
								}
							});
						}
					}
				});
			}

			self.signalWidgets = function(){
				jQuery(document).trigger(jQuery.Event(self.screenSectionId()), [self]);
			};
			self.errorHandler = function(event, result){
				LifeCycle.unblockUI();
				app.publish(LifeCycle.MessageHandler.Topics.ERROR, event.message);
			};
			self.clearError = function(){
				app.publish(LifeCycle.MessageHandler.Topics.CLEAR_ERROR);
			};
			self.saveSuccess = function(){
				app.publish(LifeCycle.MessageHandler.Topics.SUCCESS, LifeCycle.msgs.msg_save_success);
			};
			self.deleteSuccess = function(){
				app.publish(LifeCycle.MessageHandler.Topics.DELETE, LifeCycle.msgs.msg_delete_success);
			};

			/* Topic Subscriptions */
			var searchTopic = 'lookup.search' + self.guid();
			app.subscribe(searchTopic, function(screenResource, successCallback){
				self.executeBusinessLogic(app.mapToJS(screenResource),
					'screen-resource-search-container-bean',
					successCallback,
					self.errorHandler)
			});
			if(self.saveBodyAsAttachment()){
				app.subscribe('layoutDesigner.saveRenderedView', self.saveAttachment);
			}

			if(LifeCycle.GlobalActionButtonHandler){
				app.subscribe(LifeCycle.Topics.GlobalActionButtonHandler.SAVE, function(tracker){
					self.save(self.screenResource(), tracker);
				});
				app.subscribe(LifeCycle.Topics.GlobalActionButtonHandler.EDIT, function(){
					self.toggleEditing();

				});
				app.subscribe(LifeCycle.Topics.GlobalActionButtonHandler.CANCEL, function(){
					self.cancel();
				});
				app.subscribe(LifeCycle.Topics.GlobalActionButtonHandler.RESET_DIRTY_DATA_ON_CONTINUE, function(){
					self.hasDirtyData(false);
				});
			}

			if(LifeCycle.MessageHandler){
				app.subscribe(LifeCycle.MessageHandler.Topics.TOGGLE_VIEWSTATE, function(){
					toggleSubscribed = true;

					for(i = 0; i < viewModelArray.length; i++){
						viewModelArray[i].isAdding() ?
							viewModelArray[i].toggleAdding(false) : viewModelArray[i].isEditing(false);
					}

				});
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
					self.errorHandler
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
						app.publish('Infinite_Scroll_Load_More');
					}
				});
			}

			app.log('ViewModel instantiated.');
			return self;
		}
		app.log('ViewModel initialized.');
	};
	if(LifeCycle.LayoutDesigner.ViewModel == undefined){
		LifeCycle.LayoutDesigner.ViewModel = ViewModel;
	}
})();
(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			var defaultData = {
				screenSectionId: null,
				readOnlyHtml: null,
				editHtml: null,
				previewHtml: null,
				screenResources: ko.observable() 
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			if(LifeCycle.Topics &&
				LifeCycle.Topics.SectionBuilder &&
				LifeCycle.Topics.SectionBuilder.UPDATE_CONFIG){
				app.subscribe(LifeCycle.Topics.SectionBuilder.UPDATE_CONFIG, function(newConfig){
					var mappingIgnore = {
						'ignore': [
							'$$hashKey',
							'remainingIds',
							'isContext',
							'selectedLayout',
							'selectedFieldSet',
							'availableLayouts',
							'parentConfiguration',
							'showUnique',
							'showSort'
						]
					}
					app.mapFromJS(
						newConfig,
						_.extend(app.getMapping(), mappingIgnore),
						self.screenResource().configuration
					);
				});
			}

			// initialize non-mapped observables
			self.guid = ko.observable();
			self.configurationContext = ko.observable();
			self.screenResource = ko.computed({
				read: function(){
					return _.first(_.filter(self.screenResources(), function(resource) {
						return resource['apexType'] && ko.unwrap(resource['apexType']).indexOf('ScreenResource') !== -1;
					}));
				},
				deferEvaluation: true
			});
			self.updateFilterCriteria = function(childConfigs){
				_.each(childConfigs, function(config){
					if(config.filterCriteria) {
						_.each(config.filterCriteria(), function (filter) {
							if (filter.fieldValue == '') {
								filter.fieldValue = "''";
							}
						});
					}
					if (config.childConfigurations && config.childConfigurations().length > 0) {
						config.childConfigurations(self.updateFilterCriteria(config.childConfigurations()));
					}
				});
				return childConfigs;
			}
			self.loadSectionView = function(){
				if(!_.isEmpty(self.screenSectionId())){
					LifeCycle.blockUI();
					LayoutBuilder.loadSectionView(
						self.screenSectionId(),
						function(data){
							app.mapFromJS(data, app.getMapping(), self);
							self.configurationContext(self.screenResource().configuration);
							LifeCycle.unblockUI();
						},
						function(event, result){
							LifeCycle.unblockUI();
							LayoutBuilder.errorFunction(event, result);
						}
					);
				}
			};
			self.cancel = function(htmlData){
				htmlData.rawHtml(htmlData.originalHtml());
				app.publish(LifeCycle.Topics.SectionBuilder.REFRESH_CONFIG);
			};
			self.generateViewHtml = function(htmlData){
				htmlData.rawHtml('');
				LifeCycle.blockUI();
				LayoutBuilder.reloadSectionViewWithConfiguration(
						app.mapToJS(self),
						function(data){
							self.screenResources(null); // to prevent property aggregation
							app.mapFromJS(data, app.getMapping(), self);
							self.configurationContext(self.screenResource().configuration);
							htmlData.rawHtml(htmlData.generateHtml(self.screenResource()));
							LifeCycle.unblockUI();
						},
						function(){
							LifeCycle.unblockUI();
						}
					);
			};
			self.isUnique = function(child){
				return child;
			};
			self.unique = function(children){
				return children;
			};
			self.hasData = function(resource){
				return true;
			};
			self.hasValidChildren = function($data, depthsToInclude){
				return true;
			};
			self.saveHtml = function(htmlData){
				LifeCycle.blockUI();
				self.screenResource().configuration = (self.updateFilterCriteria([self.screenResource().configuration]))[0];
				LayoutBuilder.saveHtml(
					htmlData,
					function (data) {
						htmlData.originalHtml(htmlData.rawHtml());
						LayoutBuilder.saveSectionConfiguration(
							app.mapToJS(self.screenResource().configuration),
							function () {
								self.screenResources(null); // to prevent property aggregation
								self.loadSectionView();
								LifeCycle.unblockUI();
							},
							function (data) {
								LifeCycle.unblockUI();
							}
						);

					}, function (data) {
						LifeCycle.unblockUI();
					}
				);
			};
			app.log('ViewModel instantiated.');
			return self;
		}
		app.log('ViewModel initialized.');
	};
	if(LifeCycle.LayoutBuilder.ViewModel == undefined){
		LifeCycle.LayoutBuilder.ViewModel = ViewModel;
	}
})();
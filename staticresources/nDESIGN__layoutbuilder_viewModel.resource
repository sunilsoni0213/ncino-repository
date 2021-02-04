(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			var defaultData = {
				screenSectionId: null,
				readOnlyHtml: null,
				editHtml: null,
				previewHtml: null,
				screenResources: null
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			
			// initialize non-mapped observables
			self.configurationContext = ko.observable();
			self.screenResource = ko.computed({
				read: function(){
					return _.first(_.values(self.screenResources()));
				},
				deferEvaluation: true
			});
			
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
						function(){
							LifeCycle.unblockUI();
						});
				}
			};
			self.cancel = function(htmlData){
				htmlData.rawHtml(htmlData.originalHtml());
			};
			self.generateViewHtml = function(htmlData){
				LifeCycle.blockUI();
				LayoutBuilder.reloadSectionViewWithConfiguration(
						app.mapToJS(self),
						function(data){
							self.screenResources(null); // to prevent property aggregation
							app.mapFromJS(data, app.getMapping(), self);
							self.configurationContext(self.screenResource().configuration);
							htmlData.rawHtml(htmlData.generateHtml(self.screenResources()));
							LifeCycle.unblockUI();
						},
						function(){
							LifeCycle.unblockUI();
						}
					);
			};
			self.saveHtml = function(htmlData){
				LifeCycle.blockUI();

				LayoutBuilder.saveHtml(
					htmlData,
					function(data){
						htmlData.originalHtml(htmlData.rawHtml());

						LayoutBuilder.saveSectionConfiguration(
							app.mapToJS(self.screenResource().configuration),
							function(){
								self.screenResources(null); // to prevent property aggregation
								self.loadSectionView();
								LifeCycle.unblockUI();
							},
							function(data){
								LifeCycle.unblockUI();
							}
						);

					},function(data){
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
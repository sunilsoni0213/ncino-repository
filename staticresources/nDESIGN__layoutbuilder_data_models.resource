(function(){
	var DataModels = function(event, app){
		app.SObjectRelationship = function(){
			var self = this;
			self.mapFromJS = function(data){
				return app.mapFromJS(data, app.getMapping(), self);
			};
			self.toString = function(){
				return self.label();
			};
			self.mapFromJS({
				label: "",
				name: "",
				sObjectType: ""
			});
			return self;
		};
		app.SectionConfiguration = function(){
			var self = this;
			self.mapFromJS = function(data){
				return app.mapFromJS(data, app.getMapping(), self);
			};
			self.mapFromJS({
				id: null,
				name: null,
				label: _.isUndefined(LifeCycle.msgs) ? "" : LifeCycle.msgs.label_default_section_configuration,
				sectionResourceClass: null,
				sObjectType: null,
				order: 1.01,
				fieldSetKey: null,
				sectionHeader: null,
				layoutName: null,
				layoutGeneratorClass: null,
				parentRelationshipName: null,
				screenSectionId: null,
				childConfigurations: [],
				availableFieldSets: [],
				availableRelationships: []
			});

			self.childNames = ko.computed({
				read: function(){
					var names = [];
					_.each(self.childConfigurations(), function(configuration){
						names.push(configuration.parentRelationshipName());
					});
					return names;
				},
				deferEvaluation: true
			});
			self.availableChildConfigurations = ko.computed({
				read: function(){
					return _.filter(self.availableRelationships(), function(relationship){
						return _.indexOf(self.childNames(), relationship.name()) == -1;
					}).sort();
				},
				deferEvaluation: true
			});
			self.addChildConfiguration = function(data){
				LifeCycle.blockUI();
				var child = self.childConfigurations.mappedCreate({
					label: data.label(),
					sObjectType: data.sObjectType(),
					order: Math.ceil((Math.floor(self.order()) + 1
							+ (self.childConfigurations().length / 100) + .01) * 100) / 100,
					parentRelationshipName: data.name(),
					screenSectionId: self.screenSectionId()
				});
				LayoutBuilder.loadSectionConfiguration(
					app.mapToJS(child),
					function(data){
						app.mapFromJS(data, app.getMapping(), child);
						child.setAsContext();
						LifeCycle.unblockUI();
					},
					function(event){
						LifeCycle.unblockUI();
					});
			};

			self.selectedFieldSet = ko.computed({
				read: function(){
					return _.isEmpty(self.fieldSetKey()) ? null
							: _.find(self.availableFieldSets(), function(fieldSet) {
								return fieldSet.name == self.fieldSetKey();
							});
				},
				write: function(value){
					self.fieldSetKey(_.isEmpty(value) ? null : value.name);
				},
				deferEvaluation: true
			});

			self.availableLayouts = ko.observableArray(_.filter(app.Html.Layouts, function(layout){
				//return layout.isList == self.sectionResource().isList();
				return true;
			}));
			self.selectedLayout = ko.computed({
				read: function(){
					return _.isEmpty(self.layoutGeneratorClass()) ? null
							: _.find(self.availableLayouts(), function(layout) {
								return layout.generator_class == self.layoutGeneratorClass();
							});
				},
				write: function(value){
					self.layoutGeneratorClass(_.isEmpty(value) ? null : value.generator_class);
					self.layoutName(_.isEmpty(value) ? null : value.name);
				},
				deferEvaluation: true
			});
			
			self.isLayoutSelected = ko.computed({
				read: function() {
					var obj = self.selectedLayout();
					if (obj && obj.name == LifeCycle.msgs.name_no_layout) {
						return false;
					}
					return true;
				},
				deferEvaluation: true
			});

			self.setAsContext = function(){
				app.viewModel.configurationContext(self);
			};
			self.isContext = ko.computed({
				read: function(){
					return self == app.viewModel.configurationContext();
				},
				deferEvaluation: true
			});

			return self;
		};

		app.ReadOnlyHtmlData = function(data){
			var self = this;
			var defaultData = {
				id: null,
				screenSectionId: '',
				rawHtml: '',
				htmlType: 'readOnly'
			};

			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.generateHtml = function(resources){
				var container = new app.Html.Template.Div();
				var conditional = new app.Html.Template.Div("if: screenResources");
				container.append(conditional);
				_.each(resources, function(resource, name){
					var html = resource.configuration.selectedLayout().generateHtml(
							"screenResources()['" + name + "']",
							resource,
							app.Html.ReadOnly.Factory);

					if(!_.isEmpty(html)){
						conditional.append(html);
					}
				});
				return container.html();
			};

			trackOriginalHtml(self);
			return self;
		};
		app.EditHtmlData = function(data){
			var self = this;
			var defaultData = {
				id: null,
				screenSectionId: '',
				rawHtml: '',
				htmlType: 'editHtml'
			};

			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.generateHtml = function(resources){
				var container = new app.Html.Template.Div();
				var conditional = new app.Html.Template.Div("if: screenResources");
				container.append(conditional);
				_.each(resources, function(resource, name){
					var html = resource.configuration.selectedLayout().generateHtml(
							"screenResources()['" + name + "']",
							resource,
							app.Html.Edit.Factory);

					if(!_.isEmpty(html)){
						conditional.append(html);
					}
				});
				return container.html();
			};

			trackOriginalHtml(self);
			return self;
		};

		var trackOriginalHtml = function(self){
			self.originalHtml = ko.observable();
			self.rawHtml.subscribe(function(newValue){
				if(typeof self.originalHtml() == 'undefined'){
					self.originalHtml(newValue);
				}
			});
		};

		app.setMapping({
			'availableFieldSets': {
				create: function(options){
					return options.data;
				}
			},
			'availableRelationships': {
				create: function(options){
					return new app.SObjectRelationship();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			'configuration': {
				create: function(options){
					return new app.SectionConfiguration();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			'childConfigurations': {
				create: function(options){
					var configuration = new app.SectionConfiguration();
					configuration.parentConfiguration = options.parent;
					return configuration;
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			'readOnlyHtml': {
				create: function(options){
					return new app.ReadOnlyHtmlData(options.data);
				}
			},
			'editHtml': {
				create: function(options){
					return new app.EditHtmlData(options.data);
				}
			},
			'previewHtml': {
				create: function(options){
					return new app.ReadOnlyHtmlData(options.data);
				}
			}
		});

		app.log('Models initialized.');
	};
	if(LifeCycle.LayoutBuilder == undefined){
		LifeCycle.LayoutBuilder = {};
	}
	if(LifeCycle.LayoutBuilder.DataModels == undefined){
		LifeCycle.LayoutBuilder.DataModels = DataModels;
	}
})();
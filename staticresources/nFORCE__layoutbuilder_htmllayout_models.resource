(function(){
	var Models = function(event, app){
		if(_.isUndefined(app.Html)){
			app.Html = {};
		}
		if(_.isUndefined(app.Html.Layouts)){
			app.Html.Layouts = {};
		}
		if(_.isUndefined(app.Html.Grid)){
			app.Html.Grid = {};
			app.Html.Table = {};
		}
		app.Html.ALayout = {
			FIELD_PROPERTIES: {
				LABEL: 'fieldLabel',
				VALUE: 'value'
			},
			label: '',
			name: '',
			generator_class: '',
			generateHtml: function(context, resource, factory){
				if(!_.isUndefined(context) && !_.isUndefined(resource)){
					var binding = resource.configuration.unique() ?
						'with:getViewModel().isUnique(' + context + ')' :
						'with:' + context;

					if(resource.isList()){
						binding = resource.configuration.unique()
							? 'foreach:getViewModel().unique(' + context + '.children)'
							: 'foreach:' + context + '.children';
						resource = resource.children()[0];
					}

					var section = factory.getMarkupForScreenResource(binding);
					var headerBinding = null;
					var generatedBindings = this._generateSubBindings(resource, context);
					if(generatedBindings!=''){
						headerBinding = 'if:' + generatedBindings;
					}

					var wrapperDiv =  new app.Html.Template.Div(headerBinding);

					new app.Html.AddSectionHeader(wrapperDiv, resource);
					this.generateLayout(wrapperDiv, resource, factory);
					this.generateChildren(wrapperDiv, resource, factory);
					section.append(wrapperDiv);
					return section;
				}
				return null;
			},
			generateContainer: function(section){
				throw "Layout must implement the generateContainer method";
			},
			generateProperty: function(factory, container, name, field, iterator){
				throw "Layout must implement the generateProperty method";
			},
			generatePropertyCondition: function(fieldName, propertyName, field){
				var condition = 'if:hasContent(\"' + fieldName;
				if (field.fieldType() != Layout.DATA.fieldTypes.BOOLEAN || propertyName == this.FIELD_PROPERTIES.LABEL) {
					condition += '.' + propertyName;
				}
				condition += '\")';
				return condition;
			},
			generateLayout: function(section, resource, factory){
				if(!_.isUndefined(section) && !_.isUndefined(resource)){
					var self = this;
					var container = self.generateContainer(section, resource);

					// var iterator = 0;
					var sharedElements = new Object();
					sharedElements['iterator'] = 0;
					if (_.isUndefined(resource.configuration) ||
						_.isUndefined(resource.configuration.selectedFieldSet()) ||
						_.isEmpty(resource.configuration.selectedFieldSet())){

						_.each(resource.propertyBag, function(field, name){
							iterator = self.generateProperty(factory, container, name, field, sharedElements);
						});
					} else {
						_.each(resource.configuration.selectedFieldSet().fields, function(name, index){
							var field = resource.propertyBag[name];
							iterator = self.generateProperty(factory, container, name, field, sharedElements);
						});
					}
				}
			},
			generateChildren: function(section, resource, factory){
				if(!_.isUndefined(section) && !_.isUndefined(resource)){
					for (var index = 0, len = resource.children().length; index < len; index++) {
						var child = resource.children()[index];
						var element = child.configuration.selectedLayout().generateHtml(
							"children()[" + index + "]",
							child,
							factory);

						if(!_.isEmpty(element)){
							section.append(element);
						}
					}
				}
			},
			_generateSubBindings: function(resource, context){
				var headerBinding, depth = 0, depthsToInclude = [];
				(function countDepth(thisResource){
					if (
						thisResource.configuration
						&& thisResource.configuration.layoutName
						&& thisResource.configuration.layoutName() != 'NoLayout'
					) {
						depthsToInclude.push(depth);
					}

					depth++;
					if (thisResource.children && thisResource.children().length > 0) {
						var resourceToPass = thisResource.children()[0];
						if (resourceToPass.isList && resourceToPass.isList()) {
							resourceToPass = resourceToPass.children()[0];
						}
						countDepth(resourceToPass);
					}
				})((resource.isList && resource.isList()) ? resource.children()[0] : resource);
				headerBinding = 'getViewModel().hasValidChildren($data, [' + depthsToInclude.join() + '])';
				return headerBinding;
			},
			_extractInfoFromElement: function(element){
				return {
					class: (element && element.attr)?element.attr('class'):'',
					binding: (element && element.attr)?element.attr('data-bind'):''
				};
			}
		};
		//This layout is first so the picklist is defaulted to No Layout
		app.Html.Layouts.NoLayout = _.extend(_.clone(app.Html.ALayout), {
			label: _.isUndefined(LifeCycle.msgs) ? "" : LifeCycle.msgs.label_no_layout,
			name: _.isUndefined(LifeCycle.msgs) ? "" : LifeCycle.msgs.name_no_layout,
			generator_class: 'Html.Layouts.NoLayout',
			generateContainer: function(section){
				return app.Html.Template.Div();
			},
			generateProperty: function(factory, container, name, field, iterator){

			}
		});

		app.Html.Layouts.SingleColumnGrid = _.extend(_.clone(app.Html.ALayout), {
			label: _.isUndefined(LifeCycle.msgs) ? "" : LifeCycle.msgs.label_single_column_grid,
			name: _.isUndefined(LifeCycle.msgs) ? "" : LifeCycle.msgs.name_single_column_grid,
			generator_class: 'Html.Layouts.SingleColumnGrid',
			generateContainer: function(section){
				var grid = new app.Html.Grid.Container("with:propertyBag");
				section.append(grid);
				return grid;
			},
			generateProperty: function(factory, container, name, field, sharedElements){
				var markup = factory.getMarkupForFieldType(field, name);
				if(!_.isEmpty(markup)){
					var row = new app.Html.Grid.Row();
					container.append(row);

					var binding;
					var extras = this._extractInfoFromElement(markup.label);
					if (extras.binding != '') {
						binding = extras.binding;
					} else {
						binding = this.generatePropertyCondition(name, this.FIELD_PROPERTIES.LABEL, field);
					}
					var label = new app.Html.Grid.RightShiftedCell(3, binding);
					label.addClass(extras.class)
					row.append(label);

					extras = this._extractInfoFromElement(markup.value);
					binding = this.generatePropertyCondition(name, this.FIELD_PROPERTIES.VALUE, field);
					if (extras.binding && extras.binding != '' && markup.value[0].tagName == 'SPAN') {
						binding = extras.binding;
						var value = new app.Html.Grid.Cell(3, binding);
						value.addClass(extras.class);
					} else {
						var value = new app.Html.Grid.Cell(3, binding);
						value.append(markup.value);
					}

					row.append(value);

					row.append(app.Html.Template.Provider.createElement({
						tag: 'div',
						style: {clear: 'both'},
						binding: undefined
					}));
				}
			}
		});
		app.Html.Layouts.TwoColumnGrid = _.extend(_.clone(app.Html.ALayout), {
			label: _.isUndefined(LifeCycle.msgs) ? "" : LifeCycle.msgs.label_two_column_grid,
			name: _.isUndefined(LifeCycle.msgs) ? "" : LifeCycle.msgs.name_two_column_grid,
			generator_class: 'Html.Layouts.TwoColumnGrid',
			generateContainer: function(section){
				var grid = new app.Html.Grid.Container("with:propertyBag");
				section.append(grid);
				section.append('<div style="clear:both;"></div>');
				return grid;
			},
			generateProperty: function(factory, container, name, field, sharedElements){
				var markup = factory.getMarkupForFieldType(field, name);
				if(!_.isEmpty(markup)){
					if(++sharedElements['iterator'] % 2 != 0){
						row = new app.Html.Grid.Row();
						container.append(row);
					}
					var binding;
					var extras = this._extractInfoFromElement(markup.label);
					if (extras.binding != '') {
						binding = extras.binding;
					} else {
						binding = this.generatePropertyCondition(name, this.FIELD_PROPERTIES.LABEL, field);
					}

					var label = new app.Html.Grid.RightShiftedCell(3, binding);
					label.addClass(extras.class);
					row.append(label);

					extras = this._extractInfoFromElement(markup.value);
					binding = this.generatePropertyCondition(name, this.FIELD_PROPERTIES.VALUE, field);
					if (extras.binding && extras.binding != '' && markup.value[0].tagName == 'SPAN') {
						binding = extras.binding;
						var value = new app.Html.Grid.Cell(3, binding);
						value.addClass(extras.class);
					} else {
						var value = new app.Html.Grid.Cell(3, binding);
						value.append(markup.value);
					}
					row.append(value);
				}
			}
		});
		app.Html.Layouts.SingleRowFluidLayout = _.extend(_.clone(app.Html.ALayout), {
			label: _.isUndefined(LifeCycle.msgs) ? "" : LifeCycle.msgs.label_single_row_layout,
			name: _.isUndefined(LifeCycle.msgs) ? "" : LifeCycle.msgs.name_single_row_layout,
			generator_class: 'Html.Layouts.SingleRowFluidLayout',
			generateContainer: function(section){
				var grid = new app.Html.Grid.Container("with:propertyBag");
				section.append(grid);
				return grid;
			},
			generateProperty: function(factory, container, name, field, sharedElements){
				var markup = factory.getMarkupForFieldType(field, name);
				if(!_.isEmpty(markup)){
					if(sharedElements['iterator'] == 0){
						sharedElements['labelRow'] = new app.Html.Grid.Row();
						container.append(sharedElements['labelRow']);

						sharedElements['valueRow'] = new app.Html.Grid.Row();
						container.append(sharedElements['valueRow']);
					}
					var binding;
					var extras = this._extractInfoFromElement(markup.label);
					if (extras.binding != '') {
						binding = extras.binding;
					} else {
						binding = this.generatePropertyCondition(name, this.FIELD_PROPERTIES.LABEL, field);
					}
					var label = new app.Html.Grid.Cell(3, binding);
					label.addClass(extras.class);

					extras = this._extractInfoFromElement(markup.value);
					binding = this.generatePropertyCondition(name, this.FIELD_PROPERTIES.VALUE, field);
					if (extras.binding && extras.binding != '' && markup.value[0].tagName == 'SPAN') {
						binding = extras.binding;
						var value = new app.Html.Grid.Cell(3, binding);
						value.addClass(extras.class);
					} else {
						var value = new app.Html.Grid.Cell(3, binding);
						value.append(markup.value);
					}

					sharedElements['labelRow'].append(label);
					sharedElements['valueRow'].append(value);

					sharedElements['iterator'] = ++sharedElements['iterator'] == 4 ? 0 : sharedElements['iterator'];
				}
			}
		});

		app.Html.Layouts.TableLayout = _.extend(_.clone(app.Html.ALayout), {
			label: _.isUndefined(LifeCycle.msgs) ? "" : LifeCycle.msgs.label_table_layout,
			name: _.isUndefined(LifeCycle.msgs) ? "" : LifeCycle.msgs.name_table_layout,
			generator_class: 'Html.Layouts.TableLayout',

			generateHtml: function(context, resource, factory){
				if(!_.isUndefined(context) && !_.isUndefined(resource)){
					var binding = resource.configuration.unique() && resource.isList()
						? 'with:getViewModel().unique(' + context + '.children)'
						: 'with:' + context;

					var section = factory.getMarkupForScreenResource(binding);
					this.generateLayout(section, resource, factory);
					if(!_.isUndefined(resource.isList()) && resource.isList() == true){
						resource = resource.children()[0];
					}
					this.generateChildren(section, resource, factory);
					return section;
				}
				return null;
			},

			generateContainer: function(section, resource){
				var bindings = resource.configuration.unique()
					? '$data[0]'
					: 'children()[0]'
				;

				var headerBinding = null;
				if (resource.children().length>0) {
					headerBinding = 'if:' + bindings;
				}

				var wrapperDiv =  new app.Html.Template.Div(headerBinding).addClass('wrapperDiv');
				section.append(wrapperDiv);

				new app.Html.AddSectionHeader(wrapperDiv, resource);

				var table = !resource.isList() && resource.configuration.unique()
					? new app.Html.Table.Container("with:getViewModel().isUnique($data)")
					: new app.Html.Table.Container();
				wrapperDiv.append(table);

				var thead = resource.isList()
					? new app.Html.Table.Head('with:' + bindings)
					: new app.Html.Table.Head();

				table.append(thead);

				thead.append(new app.Html.Table.Row("with:propertyBag"));

				var tbody = resource.isList()
					? new app.Html.Table.Body(resource.configuration.unique()
						? "foreach:$data"
						: "foreach:children")
					: new app.Html.Table.Body();
				table.append(tbody);

				tbody.append(new app.Html.Table.Row("with:propertyBag"));

				return table;
			},

			generateProperty: function(factory, container, name, field){
				var markup = factory.getMarkupForFieldType(field, name);

				if(!_.isEmpty(markup)){
					var binding;
					var extras = this._extractInfoFromElement(markup.label);
					if (extras.binding != '') {
						binding = extras.binding;
					} else {
						binding = this.generatePropertyCondition(name, this.FIELD_PROPERTIES.LABEL, field);
					}
					var label = new app.Html.Table.HeaderRow(binding);
					label.addClass(extras.class);

					extras = this._extractInfoFromElement(markup.value);
					binding = this.generatePropertyCondition(name, this.FIELD_PROPERTIES.VALUE, field);
					if (extras.binding && extras.binding != '' && markup.value[0].tagName == 'SPAN') {
						binding = extras.binding;
						var value = new app.Html.Table.Data(binding);
						value.addClass(extras.class);
					} else {
						var value = new app.Html.Table.Data(binding);
						value.append(markup.value);
					}

					container.find('thead').find('tr').append(label);
					container.find('tbody').find('tr').append(value);
				}
			},

			generateLayout: function(section, resource, factory){
				if(!_.isUndefined(section) && !_.isUndefined(resource)){
					var self = this;
					var container = self.generateContainer(section, resource);

					if(!_.isUndefined(resource.isList()) && resource.isList() == true){
						resource = resource.children()[0];
					}

					if (_.isUndefined(resource.configuration) ||
						_.isUndefined(resource.configuration.selectedFieldSet()) ||
						_.isEmpty(resource.configuration.selectedFieldSet())){

						_.each(resource.propertyBag, function(field, name){
							self.generateProperty(factory, container, name, field);
						});
					} else {
						_.each(resource.configuration.selectedFieldSet().fields, function(name, index){
							var field = resource.propertyBag[name];
							self.generateProperty(factory, container, name, field);
						});
					}
				}
			}
		});

		app.Html.Layouts.VerticalTableLayout = _.extend(_.clone(app.Html.ALayout), {
			label: _.isUndefined(LifeCycle.msgs) ? "" : LifeCycle.msgs.label_vertical_table_layout,
			name: _.isUndefined(LifeCycle.msgs) ? "" : LifeCycle.msgs.name_vertical_table_layout,
			generator_class: 'Html.Layouts.VerticalTableLayout',

			generateHtml: function(context, resource, factory){
				if(!_.isUndefined(context) && !_.isUndefined(resource)){
					var binding = resource.configuration.unique() && resource.isList()
						? 'with: getViewModel().unique(' + context + '.children)'
						: 'with: ' + context;

					var section = factory.getMarkupForScreenResource(binding);
					this.generateLayout(section, resource, factory);
					if(!_.isUndefined(resource.isList()) && resource.isList() == true){
						resource = resource.children()[0];
					}
					this.generateChildren(section, resource, factory);
					return section;
				}
				return null;
			},

			generateContainer: function(section, resource){
				var bindings = resource.configuration.unique()
					? '$data[0]'
					: 'children()[0]'
				;

				var headerBinding = null;
				if (resource.children().length>0) {
					headerBinding = 'if: ' + bindings;
				}

				var wrapperDiv =  new app.Html.Template.Div(headerBinding).addClass('wrapperDiv');
				section.append(wrapperDiv);

				new app.Html.AddSectionHeader(wrapperDiv, resource);

				var table = !resource.isList() && resource.configuration.unique()
					? new app.Html.Table.Container("with: getViewModel().isUnique($data)")
					: new app.Html.Table.Container();
				table[0].classList.add('vertical');
				wrapperDiv.append(table);

				var tbody = resource.isList()
					? new app.Html.Table.Body("with: " + bindings)
					: new app.Html.Table.Body();
				table.append(tbody);

				return table;
			},

			generateProperty: function(factory, container, name, field, isUnique){
				var markup = factory.getMarkupForFieldType(field, name);

				if(!_.isEmpty(markup)){
					var binding;
					var extras = this._extractInfoFromElement(markup.label);
					if (extras.binding != '') {
						binding = extras.binding;
					} else {
						binding = this.generatePropertyCondition(name, this.FIELD_PROPERTIES.LABEL, field);
					}
					var label = new app.Html.Table.HeaderRow(binding);
					label.addClass(extras.class);

					extras = this._extractInfoFromElement(markup.value);
					binding = this.generatePropertyCondition(name, this.FIELD_PROPERTIES.VALUE, field);
					if (extras.binding && extras.binding != '' && markup.value[0].tagName == 'SPAN') {
						binding = extras.binding;
						var value = new app.Html.Table.Data(binding);
						value.addClass(extras.class);
					} else {
						var value = new app.Html.Table.Data(binding);
						value.append(markup.value);
					}

					var row = new app.Html.Table.Row("with:propertyBag");
					row.append(label);
					var koForEach = isUnique
						? '<!-- ko foreach: $parents[1] -->'
						: '<!-- ko foreach: $parents[1].children() -->';
					row.append(koForEach);
					row.append('<!-- ko with:propertyBag -->');
					row.append(value);
					row.append('<!-- /ko -->');
					row.append('<!-- /ko -->');
					container.find('tbody').append(row);
				}
			},

			generateLayout: function(section, resource, factory){
				if(!_.isUndefined(section) && !_.isUndefined(resource)){
					var self = this;
					var container = self.generateContainer(section, resource);

					if(!_.isUndefined(resource.isList()) && resource.isList() == true){
						resource = resource.children()[0];
					}

					if (_.isUndefined(resource.configuration) ||
						_.isUndefined(resource.configuration.selectedFieldSet()) ||
						_.isEmpty(resource.configuration.selectedFieldSet())){

						_.each(resource.propertyBag, function(field, name){
							self.generateProperty(factory, container, name, field, resource.configuration.unique());
						});
					} else {
						_.each(resource.configuration.selectedFieldSet().fields, function(name, index){
							var field = resource.propertyBag[name];
							self.generateProperty(factory, container, name, field, resource.configuration.unique());
						});
					}
				}
			}
		});

		app.Html.Grid.Container = function(bindingCondition){
			return app.Html.Template.Provider.createElement({
				tag: 'div',
				classes: 'container-fluid avoid-break-inside',
				binding: !_.isUndefined(bindingCondition) ? bindingCondition : undefined
			});
		};
		app.Html.Grid.Row = function(bindingCondition){
			return app.Html.Template.Provider.createElement({
				tag: 'div',
				classes: 'row',
				binding: !_.isUndefined(bindingCondition) ? bindingCondition : undefined
			});
		};
		app.Html.Grid.Cell = function(size, bindingCondition){
			return app.Html.Template.Provider.createElement({
				tag: 'div',
				classes: 'col-xs-' + size,
				binding: !_.isUndefined(bindingCondition) ? bindingCondition : undefined
			});
		};
		app.Html.Grid.RightShiftedCell = function(size, bindingCondition){
			var self = new app.Html.Grid.Cell(size, bindingCondition);
			self.addClass('text-right');
			return self;
		};
		app.Html.Table.Container = function(bindingCondition){
			return app.Html.Template.Provider.createElement({
				tag: 'table',
				classes: 'table table-condensed',
				style: {clear: 'both'},
				binding: !_.isUndefined(bindingCondition) ? bindingCondition : undefined
			});
		};
		app.Html.Table.Head = function(bindingCondition){
			return app.Html.Template.Provider.createElement({
				tag: 'thead',
				classes: '',
				binding: !_.isUndefined(bindingCondition) ? bindingCondition : undefined
			});
		};
		app.Html.Table.Body = function(bindingCondition){
			return app.Html.Template.Provider.createElement({
				tag: 'tbody',
				classes: '',
				binding: !_.isUndefined(bindingCondition) ? bindingCondition : undefined
			});
		};
		app.Html.Table.HeaderRow = function(bindingCondition){
			return app.Html.Template.Provider.createElement({
				tag: 'th',
				classes: '',
				binding: !_.isUndefined(bindingCondition) ? bindingCondition : undefined
			});
		};
		app.Html.Table.Row = function(bindingCondition){
			return app.Html.Template.Provider.createElement({
				tag: 'tr',
				classes: '',
				binding: !_.isUndefined(bindingCondition) ? bindingCondition : undefined
			});
		};
		app.Html.Table.Data = function(bindingCondition){
			return app.Html.Template.Provider.createElement({
				tag: 'td',
				classes: '',
				binding: !_.isUndefined(bindingCondition) ? bindingCondition : undefined
			});
		};
		app.Html.SectionHeader = function(bindingCondition, elementContent){
			var element = app.Html.Template.Provider.createElement({
				tag: 'h4',
				classes: '',
				content: elementContent
			});
			if(!_.isUndefined(bindingCondition)){
				return new app.Html.Template.Div(bindingCondition, element);
			} else {
				return element;
			}
		};
		app.Html.AddSectionHeader = function(section, resource, bindingCondition){
			if (!_.isUndefined(resource.configuration.sectionHeader()) &&
				!_.isEmpty(resource.configuration.sectionHeader())) {
				var sectionHead = new app.Html.SectionHeader(bindingCondition, resource.configuration.sectionHeader());
				sectionHead.css('font-weight', 'bold');
				section.prepend(sectionHead);
			}
		};
	};
	if(LifeCycle.LayoutBuilder == undefined){
		LifeCycle.LayoutBuilder = {};
	}
	if(LifeCycle.LayoutBuilder.Html == undefined){
		LifeCycle.LayoutBuilder.Html = {};
	}
	if(LifeCycle.LayoutBuilder.Html.Layouts == undefined){
		LifeCycle.LayoutBuilder.Html.Layouts = Models;
	}
}());
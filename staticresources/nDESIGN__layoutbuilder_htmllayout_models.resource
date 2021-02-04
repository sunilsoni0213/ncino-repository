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
				LABEL: "fieldLabel",
				VALUE: "value"
			},
			label: "",
			name: "",
			generator_class: "",
			generateHtml: function(context, resource, factory){
				if(!_.isUndefined(context) && !_.isUndefined(resource)){
					var binding = "with: " + context;

					if(!_.isUndefined(resource.isList()) && resource.isList() == true){
						binding = "foreach: " + context + ".children";
						resource = resource.children()[0];
					}
					var section = factory.getMarkupForScreenResource(binding);
					new app.Html.AddSectionHeader(section, resource);

					this.generateLayout(section, resource, factory);
					this.generateChildren(section, resource, factory);

					var conditional = new app.Html.Template.Div("if: " + context);
					conditional.append(section);

					return conditional;
				}
				return null;
			},
			generateContainer: function(section){
				throw "Layout must implement the generateContainer method";
			},
			generateProperty: function(factory, container, name, field, iterator){
				throw "Layout must implement the generateProperty method";
			},
			generatePropertyCondition: function(fieldName, propertyName){
				return "if: $data." + fieldName + " && $data." + fieldName + "." + propertyName;
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
					for(var index = 0; index < resource.children().length; index++){
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
				var grid = new app.Html.Grid.Container("with: propertyBag");
				section.append(grid);
				return grid;
			},
			generateProperty: function(factory, container, name, field, sharedElements){
				var markup = factory.getMarkupForFieldType(field, name);
				if(!_.isEmpty(markup)){
					var row = new app.Html.Grid.Row();
					container.append(row);

					var label = new app.Html.Grid.RightShiftedCell(3, this.generatePropertyCondition(
							name, this.FIELD_PROPERTIES.LABEL));
					label.append(markup.label);
					row.append(label);

					var value = new app.Html.Grid.Cell(3, this.generatePropertyCondition(
							name, this.FIELD_PROPERTIES.VALUE));
					value.append(markup.value);
					row.append(value);
				}
			}
		});
		app.Html.Layouts.TwoColumnGrid = _.extend(_.clone(app.Html.ALayout), {
			label: _.isUndefined(LifeCycle.msgs) ? "" : LifeCycle.msgs.label_two_column_grid,
			name: _.isUndefined(LifeCycle.msgs) ? "" : LifeCycle.msgs.name_two_column_grid,
			generator_class: 'Html.Layouts.TwoColumnGrid',
			generateContainer: function(section){
				var grid = new app.Html.Grid.Container("with: propertyBag");
				section.append(grid);
				return grid;
			},
			generateProperty: function(factory, container, name, field, sharedElements){
				var markup = factory.getMarkupForFieldType(field, name);
				if(!_.isEmpty(markup)){
					if(++sharedElements['iterator'] % 2 != 0){
						row = new app.Html.Grid.Row();
						container.append(row);
					}

					var label = new app.Html.Grid.RightShiftedCell(3, this.generatePropertyCondition(
							name, this.FIELD_PROPERTIES.LABEL));
					label.append(markup.label);
					row.append(label);

					var value = new app.Html.Grid.Cell(3, this.generatePropertyCondition(
							name, this.FIELD_PROPERTIES.VALUE));
					value.append(markup.value);
					row.append(value);
				}
			}
		});
		app.Html.Layouts.SingleRowFluidLayout = _.extend(_.clone(app.Html.ALayout), {
			label: _.isUndefined(LifeCycle.msgs) ? "" : LifeCycle.msgs.label_single_row_layout,
			name: _.isUndefined(LifeCycle.msgs) ? "" : LifeCycle.msgs.name_single_row_layout,
			generator_class: 'Html.Layouts.SingleRowFluidLayout',
			generateContainer: function(section){
				var grid = new app.Html.Grid.Container("with: propertyBag");
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
					var label = new app.Html.Grid.Cell(3, this.generatePropertyCondition(
							name, this.FIELD_PROPERTIES.LABEL));
					label.append(markup.label);
					sharedElements['labelRow'].append(label);

					var value = new app.Html.Grid.Cell(3, this.generatePropertyCondition(
							name, this.FIELD_PROPERTIES.VALUE));
					value.append(markup.value);
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
					var binding = "with: " + context;
					
					var section = factory.getMarkupForScreenResource(binding);
					this.generateLayout(section, resource, factory);
					if(!_.isUndefined(resource.isList()) && resource.isList() == true){
						resource = resource.children()[0];
					}
					this.generateChildren(section, resource, factory);

					var conditional = new app.Html.Template.Div("if: " + context);
					conditional.append(section);
					return conditional;
				}
				return null;
			},

			generateContainer: function(section, resource){
				new app.Html.AddSectionHeader(section, resource);

				var table = new app.Html.Table.Container();
				section.append(table);

				var thead = !_.isUndefined(resource.isList()) && resource.isList() == true
					? new app.Html.Table.Head("with: children()[0]")
					: new app.Html.Table.Head();

				table.append(thead);

				thead.append(new app.Html.Table.Row("with: propertyBag"));

				var tbody = !_.isUndefined(resource.isList()) && resource.isList() == true
					? new app.Html.Table.Body("foreach: children")
					: new app.Html.Table.Body();
				table.append(tbody);

				tbody.append(new app.Html.Table.Row("with: propertyBag"));

				return table;
			},

			generateProperty: function(factory, container, name, field){
				var markup = factory.getMarkupForFieldType(field, name);
				var theadRow = container.find('thead').find('tr');

				if(!_.isEmpty(markup)){
					var label = new app.Html.Table.HeaderRow(this.generatePropertyCondition(
							name, this.FIELD_PROPERTIES.LABEL));
					label.append(markup.label);
					theadRow.append(label);
					
					var tbodyRow = container.find('tbody').find('tr');

					var value = new app.Html.Table.Data(this.generatePropertyCondition(
							name, this.FIELD_PROPERTIES.VALUE));
					value.append(markup.value);
					tbodyRow.append(value);
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
		app.Html.SectionHeader = function(bindingCondition){
			return app.Html.Template.Provider.createElement({
				tag: 'h4',
				classes: '',
				binding: !_.isUndefined(bindingCondition) ? bindingCondition : undefined
			});
		};
		app.Html.AddSectionHeader = function(section, resource){
			if (!_.isUndefined(resource.configuration.sectionHeader()) &&
				!_.isEmpty(resource.configuration.sectionHeader())) {
				var sectionHead = new app.Html.SectionHeader();
				jQuery(sectionHead).css("font-weight", "bold");
				sectionHead.append(resource.configuration.sectionHeader());
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
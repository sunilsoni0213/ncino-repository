(function(){
	var Models = function(event, app){
		if(_.isUndefined(app.Html)){
			app.Html = {};
		}
		if(_.isUndefined(app.Html.ReadOnly)){
			app.Html.ReadOnly = {};
		}
		app.Html.ReadOnly.BooleanElement = function(name){
			return app.Html.Template.Provider.createElement({
				tag: 'input',
				attributes: {
					type: 'checkbox',
					disabled: 'disabled'
				},
				binding: 'checked: ' + name + '.value'
			});
		};
		app.Html.ReadOnly.CurrencyElement = function(name){
			return app.Html.Template.Provider.createElement({
				tag: 'span',
				binding: 'currencyText: ' + name + '.value'
			});
		};
		app.Html.ReadOnly.DateElement = function(name){
			return app.Html.Template.Provider.createElement({
				tag: 'span',
				binding: 'dateText: ' + name + '.value'
			});
		};
		app.Html.ReadOnly.DateTimeElement = function(name){
			return app.Html.Template.Provider.createElement({
				tag: 'span',
				binding: 'dateTimeText: ' + name + '.value'
			});
		};
		app.Html.ReadOnly.EmailElement = function(name){
			return new app.Html.Template.Provider.createElement({
				tag: 'a',
				attributes: {
					target: '_blank'
				},
				binding:
					'text: ' + name + '.value, ' +
					'attr: { href: "mailto:"+' + name + '.value()}'
			})
		};
		app.Html.ReadOnly.PercentElement = function(name){
			return new app.Html.Template.Provider.createElement({
				tag: 'span',
				binding:
					'maskText: ' + name + '.value, ' +
					'maskOptions: {groups: [{delimiter: "%", length: 20}, {length:0}]}'
			})
		};
		app.Html.ReadOnly.PicklistElement = function(name){
			return app.Html.Template.Provider.createElement({
				tag: 'span',
				binding: 'text: ' + name + '.selectedOption().label'
			});
		};
		app.Html.ReadOnly.DoubleElement = function(name, precision){
			return app.Html.Template.Provider.createElement({
				tag: 'span',
				binding:
					'numericText: ' + name + '.value, ' +
					'precision: ' + precision
			});
		};
		app.Html.ReadOnly.TextAreaElement = function(name){
			return app.Html.Template.Provider.createElement({
				tag: 'span',
				binding: 'html: ' + name + '.value'
			});
		};
		app.Html.ReadOnly.UrlElement = function(name){
			return app.Html.Template.Provider.createElement({
				tag: 'a',
				attributes: {
					target: '_blank'
				},
				binding: 'urlLink: ' + name + '.value'
			});
		};
		app.Html.ReadOnly.StringElement = function(name){
			return app.Html.Template.Provider.createElement({
				tag: 'span',
				binding: 'text: ' + name + '.value'
			});
		};
		app.Html.ReadOnly.ReferenceElement = function(name){
			return app.Html.Template.Provider.createElement({
				tag: 'span',
				binding: 'text: ' + name + '.displayValue'
			});
		};
		app.Html.ReadOnly.Label = function(name){
			return app.Html.Template.Provider.createElement({
				tag: 'span',
				classes: 'text-label',
				binding: 'text: ' + name + '.fieldLabel'
			});
		};
		app.Html.ReadOnly.Factory = {
			getMarkupForScreenResource: function(contextBinding){
				return app.Html.Template.Provider.createElement({
					tag: 'div',
					binding: contextBinding
				});
			},
			getMarkupForFieldType: function(field, name){
				var markup = null;
				if(field != null && field.fieldType() != null && name != null){
					switch(field.fieldType()){
						case Layout.DATA.fieldTypes.INTEGER:
						case Layout.DATA.fieldTypes.PHONE:
						case Layout.DATA.fieldTypes.COMBOBOX:
						case Layout.DATA.fieldTypes.MULTIPICKLIST:
						case Layout.DATA.fieldTypes.STRING:
						case Layout.DATA.fieldTypes.ID:
							markup = { value: new app.Html.ReadOnly.StringElement(name) };
							break;
						case Layout.DATA.fieldTypes.PICKLIST:
							markup = { value: new app.Html.ReadOnly.PicklistElement(name) };
							break;
						case Layout.DATA.fieldTypes.TEXTAREA:
							markup = { value: new app.Html.ReadOnly.TextAreaElement(name) };
							break;
						case Layout.DATA.fieldTypes.DOUBLE:
							markup = { value: new app.Html.ReadOnly.DoubleElement(name, field.scale()) };
							break;
						case Layout.DATA.fieldTypes.DATE:
							markup = { value: new app.Html.ReadOnly.DateElement(name) };
							break;
						case Layout.DATA.fieldTypes.DATETIME:
							markup = { value: new app.Html.ReadOnly.DateTimeElement(name) };
							break;
						case Layout.DATA.fieldTypes.PERCENT:
							markup = { value: new app.Html.ReadOnly.PercentElement(name) };
							break;
						case Layout.DATA.fieldTypes.CURRENCY:
							markup = { value: new app.Html.ReadOnly.CurrencyElement(name) };
							break;
						case Layout.DATA.fieldTypes.BOOLEAN:
							markup = { value: new app.Html.ReadOnly.BooleanElement(name) };
							break;
						case Layout.DATA.fieldTypes.EMAIL:
							markup = { value: new app.Html.ReadOnly.EmailElement(name) };
							break;
						case Layout.DATA.fieldTypes.URL:
							markup = { value: new app.Html.ReadOnly.UrlElement(name) };
							break;
						case Layout.DATA.fieldTypes.REFERENCE:
							markup = { value: new app.Html.ReadOnly.ReferenceElement(name) };
							break;
					}
					if(!_.isNull(markup)){
						markup.label = new app.Html.ReadOnly.Label(name);
					}
				}
				return markup;
			}
		};
		app.log('Html.ReadOnly initialized.');
	};
	if(LifeCycle.LayoutBuilder == undefined){
		LifeCycle.LayoutBuilder = {};
	}
	if(LifeCycle.LayoutBuilder.Html == undefined){
		LifeCycle.LayoutBuilder.Html = {};
	}
	if(LifeCycle.LayoutBuilder.Html.ReadOnly == undefined){
		LifeCycle.LayoutBuilder.Html.ReadOnly = Models;
	}
}());
(function(){
	var Models = function(event, app){
		if(_.isUndefined(app.Html)){
			app.Html = {};
		}
		if(_.isUndefined(app.Html.ReadOnly)){
			app.Html.ReadOnly = {};
		}
		app.Html.ReadOnly.BooleanElement = function(name){
			var container = new app.Html.ReadOnly.Container();
			container.append(new app.Html.ReadOnly.Image(
					'Layout.Images.checkboxChecked',
					'visible:' + name + '.value()==true'));
			container.append(new app.Html.ReadOnly.Image(
					'Layout.Images.checkboxUnchecked',
					'visible:' + name + '.value()==false'));
			return container;
		};
		app.Html.ReadOnly.CurrencyElement = function(name, contextIdentifier){
			return app.Html.Template.Provider.createElement({
				tag: 'span',
				binding: 'currencyElement:getContent(\"' + name + '.value\"),' +
				'scale:getContent(\"' + name + '.scale\"),' +
				'currencyIsoCode:getContent(\"' + contextIdentifier + '_CurrencyIsoCode.value\")'
			});
		};
		app.Html.ReadOnly.DateElement = function(name){
			return app.Html.Template.Provider.createElement({
				tag: 'span',
				binding: 'dateText:getContent(\"' + name + '.value\")'
			});
		};
		app.Html.ReadOnly.DateTimeElement = function(name){
			return app.Html.Template.Provider.createElement({
				tag: 'span',
				binding: 'dateTimeText:getContent(\"' + name + '.value\")'
			});
		};
		app.Html.ReadOnly.EmailElement = function(name){
			return new app.Html.Template.Provider.createElement({
				tag: 'a',
				attributes: {
					target: '_blank'
				},
				binding:
					'text:getContent(\"' + name + '.value\"),' +
					'attr:{href:"mailto:"+' + name + '.value()}'
			});
		};
		app.Html.ReadOnly.PercentElement = function(name){
			return new app.Html.Template.Provider.createElement({
				tag: 'span',
				binding:
				'percentElement:getContent(\"' + name + '.value\"),' +
				'scale:getContent(\"' + name + '.scale\"),' +
				'precision:getContent(\"' + name + '.precision\")'
			});
		};
		app.Html.ReadOnly.PicklistElement = function(name){
			return app.Html.Template.Provider.createElement({
				tag: 'span',
				binding: 'text:getContent(\"' + name + '.selectedOption\",true,\"label\")'
			});
		};
		app.Html.ReadOnly.DoubleElement = function(name){
			return app.Html.Template.Provider.createElement({
				tag: 'span',
				binding:
					'decimalElement:getContent(\"' + name + '.value\"),' +
					'scale:getContent(\"' + name + '.scale\")'
			});
		};
		app.Html.ReadOnly.TextAreaElement = function(name){
			return app.Html.Template.Provider.createElement({
				tag: 'span',
				binding: 'html:getContent(\"' + name + '.value\")'
			});
		};
		app.Html.ReadOnly.UrlElement = function(name){
			return app.Html.Template.Provider.createElement({
				tag: 'a',
				attributes: {
					target: '_blank'
				},
				binding: 'urlLink:getContent(\"' + name + '.value\")'
			});
		};
		app.Html.ReadOnly.StringElement = function(name){
			return app.Html.Template.Provider.createElement({
				tag: 'span',
				binding: 'text:getContent(\"' + name + '.value\")'
			});
		};
		app.Html.ReadOnly.ReferenceElement = function(name){
			return app.Html.Template.Provider.createElement({
				tag: 'span',
				binding: 'text:getContent(\"' + name + '.displayValue\")'
			});
		};
		app.Html.ReadOnly.Label = function(name){
			return app.Html.Template.Provider.createElement({
				tag: 'span',
				classes: 'text-label',
				binding: 'text:getContent(\"' + name + '.fieldLabel\")'
			});
		};
		app.Html.ReadOnly.Container = function(contextBinding){
			return app.Html.Template.Provider.createElement({
				tag: 'span',
				binding: contextBinding
			});
		};
		app.Html.ReadOnly.Image = function(source, binding){
			binding = binding ? binding + ', ' : '';
			binding += 'attr:{src:' + source + '}';

			return app.Html.Template.Provider.createElement({
				'tag': 'img',
				'binding': binding
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
				if(field != null && field.fieldType && field.fieldType() != null && name != null){
					switch(field.fieldType()){
						case Layout.DATA.fieldTypes.INTEGER:
						case Layout.DATA.fieldTypes.PHONE:
						case Layout.DATA.fieldTypes.COMBOBOX:
						case Layout.DATA.fieldTypes.MULTIPICKLIST:
						case Layout.DATA.fieldTypes.STRING:
						case Layout.DATA.fieldTypes.ENCRYPTEDSTRING:
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
							markup = { value: new app.Html.ReadOnly.DoubleElement(name) };
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
							markup = { value: new app.Html.ReadOnly.CurrencyElement(name, field.contextIdentifier()) };
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
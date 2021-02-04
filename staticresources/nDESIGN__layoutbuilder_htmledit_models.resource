(function(){
	var Models = function(event, app){
		if(_.isUndefined(app.Html)){
			app.Html = {};
		}
		if(_.isUndefined(app.Html.Edit)){
			app.Html.Edit = {};
		}
		app.Html.Edit.BooleanInput = function(name, inputId){
			return app.Html.Template.Provider.createElement({
				tag: 'input',
				attributes: {
					type: 'checkbox',
					id: !_.isUndefined(inputId) ? inputId : app.Html.Template.Provider.generateUniqueFieldId(name)
				},
				binding: 'checked: ' + name + '.value'
			});
		};
		app.Html.Edit.CurrencyInput = function(name, inputId){
			var inputDiv = app.Html.Template.Provider.createElement({
				tag: 'div',
				classes: 'input-group'
			});
			var prependSpan = app.Html.Template.Provider.createElement({
				tag: 'span',
				classes: 'input-group-addon',
				content: '$'
			});
			var currencyInput = app.Html.Template.Provider.createElement({
				tag: 'input',
				attributes: {
					type: 'text',
					id: !_.isUndefined(inputId) ? inputId : app.Html.Template.Provider.generateUniqueFieldId(name)
				},
				classes: 'form-control',
				binding: 'currencyValue: ' + name + '.value'
			});
			return inputDiv.append(prependSpan).append(currencyInput);
		};
		app.Html.Edit.IdInput = function(name, inputId){
			return new app.Html.Template.Provider.createElement({
				tag: 'input',
				attributes: {
					type: 'text',
					id: !_.isUndefined(inputId) ? inputId : app.Html.Template.Provider.generateUniqueFieldId(name),
					disabled: 'disabled'
				},
				classes: 'form-control',
				binding: 'value: ' + name + '.value'
			});
		};
		app.Html.Edit.PercentInput = function(name, inputId){
			var inputDiv = new app.Html.Template.Provider.createElement({
				tag: 'div',
				classes: 'input-group'
			});
			var percentInput = new app.Html.Edit.StringInput(name, inputId);
			var appendSpan = new app.Html.Template.Provider.createElement({
				tag: 'span',
				classes: 'input-group-addon',
				content: '%'
			});

			return inputDiv.append(percentInput).append(appendSpan);
		};
		app.Html.Edit.StringInput = function(name, inputId){
			return app.Html.Template.Provider.createElement({
				tag: 'input',
				attributes: {
					type: 'text',
					id: !_.isUndefined(inputId) ? inputId : app.Html.Template.Provider.generateUniqueFieldId(name)
				},
				classes: 'form-control',
				binding: 'value: ' + name + '.value'
			});
		};
		app.Html.Edit.TextAreaInput = function(name, inputId){
			return new app.Html.Template.Provider.createElement({
				tag: 'textarea',
				attributes: {
					id: !_.isUndefined(inputId) ? inputId : app.Html.Template.Provider.generateUniqueFieldId(name)
				},
				classes: 'form-control',
				binding: 'value: ' + name + '.value'
			});
		};
		app.Html.Edit.Label = function(name, inputId){
			var args = {
				tag: 'label',
				classes: 'control-label text-muted',
				binding: 'text: ' + name + '.fieldLabel'
			};
			if(inputId != undefined){
				_.extend(args, {attributes: {'for' : inputId} });
			}
			return app.Html.Template.Provider.createElement(args);
		};
		app.Html.Edit.Factory = {
			getMarkupForScreenResource: function(contextBinding){
				return app.Html.Template.Provider.createElement({
					tag: 'form',
					classes: 'form-horizontal',
					binding: contextBinding
				});
			},
			getMarkupForFieldType: function(field, name) {
				var markup = null;
				if(field != null && field.fieldType() != null && name != null){
					var inputId = app.Html.Template.Provider.generateUniqueFieldId(name);
					switch(field.fieldType()){
						case Layout.DATA.fieldTypes.EMAIL:
						case Layout.DATA.fieldTypes.INTEGER:
						case Layout.DATA.fieldTypes.COMBOBOX:
						case Layout.DATA.fieldTypes.STRING:
						case Layout.DATA.fieldTypes.DOUBLE:
						case Layout.DATA.fieldTypes.URL:
							markup = { value: new app.Html.Edit.StringInput(name, inputId) };
							break;
						case Layout.DATA.fieldTypes.ID:
							markup = { value: new app.Html.Edit.IdInput(name, inputId) };
							break;
						case Layout.DATA.fieldTypes.PERCENT:
							markup = { value: new app.Html.Edit.PercentInput(name, inputId) };
							break;
						case Layout.DATA.fieldTypes.CURRENCY:
							markup = { value: new app.Html.Edit.CurrencyInput(name, inputId) };
							break;
						case Layout.DATA.fieldTypes.BOOLEAN:
							markup = { value: new app.Html.Edit.BooleanInput(name, inputId) };
							break;
						case Layout.DATA.fieldTypes.TEXTAREA:
							markup = { value: new app.Html.Edit.TextAreaInput(name, inputId) };
							break;
					}
					if(!_.isNull(markup)){
						markup.label = new app.Html.Edit.Label(name, inputId)
					}
				}
				return markup;
			}
		};
		app.log('Html.Edit initialized.');
	};
	if(LifeCycle.LayoutBuilder == undefined){
		LifeCycle.LayoutBuilder = {};
	}
	if(LifeCycle.LayoutBuilder.Html == undefined){
		LifeCycle.LayoutBuilder.Html = {};
	}
	if(LifeCycle.LayoutBuilder.Html.Edit == undefined){
		LifeCycle.LayoutBuilder.Html.Edit = Models;
	}
}());
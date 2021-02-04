(function(){
	var Models = function(event, app){

		app.Field = function(data, descriptor) {
			this.descriptor = descriptor || {};
			this.data = data || {};
			this.value = ko.observable(
				this.data.value ||
				(this.isNumeric() && !isNaN(this.data.value)
					? this.data.value
					: (this.isBooleanType()
							? false
							: null
						)
				)
			);
			
			return this;
		};
		
		
		
		Object.defineProperties(app.Field.prototype, {
			"contextIdentifier": {
				get: function() {
					return this.descriptor.contextIdentifier || this.data.contextIdentifier || null;
				}
			},
			"controllingGuid": {
				get: function() {
					return this.descriptor.controllingGuid || this.data.controllingGuid || null;
				}
			},
			"displayOrder": {
				get: function() {
					return this.descriptor.displayOrder || this.data.displayOrder || null;
				}
			},
			"displayValue": {
				get: function() {
					return this.data.displayValue || null;
				}
			},
			"fieldLabel": {
				get: function() {
					return this.descriptor.fieldLabel || this.data.fieldLabel || null;
				}
			},
			"fieldLength": {
				get: function() {
					return this.descriptor.fieldLength || this.data.fieldLength || null;
				}
			},
			"fieldName": {
				get: function() {
					return this.descriptor.fieldName || this.data.fieldName || null;
				}
			},
			"fieldType": {
				get: function() {
					return this.descriptor.fieldType || this.data.fieldType || null;
				}
			},
			"inlineHelpText": {
				get: function() {
					return this.descriptor.inlineHelpText || this.data.inlineHelpText || null;
				}
			},
			"guid": {
				get: function() {
					return this.data.guid || null;
				}
			},
			"isCalculated": {
				get: function() {
					return this.descriptor.isCalculated || this.data.isCalculated || false;
				}
			},
			"isDependent": {
				get: function() {
					return this.descriptor.isDependent || this.data.isDependent || false;
				}
			},
			"isDirty": {
				get: function() {
					return this.data.isDirty || false;
				}
			},
			"isHtmlFormatted": {
				get: function() {
					return this.descriptor.isHtmlFormatted || this.data.isHtmlFormatted || false;
				}
			},
			"isReadOnly": {
				get: function() {
					return this.descriptor.isReadOnly || this.data.isReadOnly || false;
				}
			},
			"isRequired": {
				get: function() {
					return this.descriptor.isRequired || this.data.isRequired || false;
				}
			},
			"isVisible": {
				get: function() {
					return this.descriptor.isVisible || this.data.isVisible || true;
				}
			},
			"masked": {
				get: function() {
					return this.descriptor.masked || this.data.masked || false;
				}
			},
			"options": {
				get: function() {
					return this.descriptor.options || this.data.options || [];
				}
			},
			"precision": {
				get: function() {
					return this.descriptor.precision || this.data.precision || null;
				}
			},
			"referenceContext": {
				get: function() {
					return this.descriptor.referenceContext || this.data.referenceContext || null;
				}
			},
			"scale": {
				get: function() {
					return this.descriptor.scale || this.data.scale || null;
				}
			},
			"selectedOption": {
				value: function() {
					if (this.isPicklistType()) {
						var value = this.value(), options = this.options;
						for(var i = 0; i < options.length; i++) {
							if (options[i].value == value) {
								return new app.Option(options[i]);
							}
						}
						return new app.Option({ value: value });
					}
					return undefined;
				}
			},
			"selectedOptions": {
				value: function() {
					return this.isMultiPicklistType() && this.value() ? this.value().split(";") : [];
				}
			},
			"isFieldType": {
				value: function(type, comparison) {
					comparison = _.isUndefined(comparison) ? this.fieldType : comparison;
					return comparison == type;
				}
			},
			"isCurrencyType": {
				value: function(comparison) {
					return this.isFieldType(Layout.DATA.fieldTypes.CURRENCY, comparison);
				}
			},
			"isDateType": {
				value: function(comparison) {
					return this.isFieldType(Layout.DATA.fieldTypes.DATE, comparison);
				}
			},
			"isDateTimeType": {
				value: function(comparison) {
					return this.isFieldType(Layout.DATA.fieldTypes.DATETIME, comparison);
				}
			},
			"isDoubleType": {
				value: function(comparison) {
					return this.isFieldType(Layout.DATA.fieldTypes.DOUBLE, comparison);
				}
			},
			"isIntegerType": {
				value: function(comparison) {
					return this.isFieldType(Layout.DATA.fieldTypes.INTEGER, comparison);
				}
			},
			"isMultiPicklistType": {
				value: function(comparison) {
					return this.isFieldType(Layout.DATA.fieldTypes.MULTIPICKLIST, comparison);
				}
			},
			"isNumeric": {
				value: function(comparison) {
					return this.isCurrencyType(comparison)
						|| this.isDoubleType(comparison)
						|| this.isIntegerType(comparison)
						|| this.isPercentType(comparison);
				}
			},
			"isBooleanType": {
				value: function(comparison) {
					return this.isFieldType(Layout.DATA.fieldTypes.BOOLEAN, comparison);
				}
			},
			"isPercentType": {
				value: function(comparison) {
					return this.isFieldType(Layout.DATA.fieldTypes.PERCENT, comparison);
				}
			},
			"isPicklistType": {
				value: function(comparison) {
					return this.isFieldType(Layout.DATA.fieldTypes.PICKLIST, comparison);
				}
			},
			"isReferenceType": {
				value: function(comparison) {
					return this.isFieldType(Layout.DATA.fieldTypes.REFERENCE, comparison);
				}
			}
		});

		app.FieldsMap = function(parent) {
			this.parent = parent;
			return this;
		};
		Object.defineProperties(app.FieldsMap.prototype, {
			"getFields": {
				value: function() {
					return _.filter(_.values(this), function(value) {
						return value instanceof app.Field;
					});
				}
			},
			"setFields": {
				value: function(data) {
					var descriptors = this.parent.descriptors || { fields: {} };
					_.each(data, function(value, key) {
						this[key] = new app.Field(value, descriptors.fields[value.guid]);
					}, this);
				}
			},
			"getParent": {
				value: function() {
					return this.parent;
				}
			},
			"hasContent": {
				value: function(fieldNamePropertyName){
					var tmp = fieldNamePropertyName.split('.'),
						fieldName = tmp[0],
						propertyName = tmp[1];
					var ret = false;
					if(this[fieldName] && (typeof propertyName == 'undefined' || this[fieldName][propertyName])){
						ret = true;
					}
					return ret;
				}
			},
			"getContent": {
				value: function(fieldNamePropertyName, isFunction, subPropertyName){
					var tmp = fieldNamePropertyName.split('.'),
						fieldName = tmp[0],
						propertyName = tmp[1];
					isFunction = typeof isFunction === 'undefined' ? false : !!isFunction;
					var ret;
					if (typeof this[fieldName] !== 'undefined') {
						if(isFunction && typeof this[fieldName][propertyName] === 'function') {
							ret = this[fieldName][propertyName]();
							if(typeof subPropertyName !== 'undefined') {
								ret = ret[subPropertyName];
							}
						} else if (typeof this[fieldName][propertyName] !== 'undefined' && this[fieldName][propertyName] !== null) {
							ret = this[fieldName][propertyName];
						} else if (typeof this[fieldName]['data'][propertyName] !== 'undefined') {
							ret = this[fieldName]['data'][propertyName];
						}
					}
					return ret;
				}
			}
		});

		app.Option = function(data) {
			this.data = data || {};
			return this;
		};
		Object.defineProperties(app.Option.prototype, {
			"active": {
				get: function() {
					return this.data.active || true;
				}
			},
			"defaultValue": {
				get: function() {
					return this.data.defaultValue || false;
				}
			},
			"label": {
				get: function() {
					return this.data.label || this.data.value;
				}
			},
			"value": {
				get: function() {
					return this.data.value || null;
				}
			}
		});

		app.ScreenResource = function(data){
			this.data = data || {};
			this.propertyBag = new app.FieldsMap(this);
			this.children = ko.observableArray();
			return this;
		};
		Object.defineProperties(app.ScreenResource.prototype, {
			"descriptors": {
				get: function(){
					return this.data.descriptors || null;
				}
			},
			"apexType": {
				value: function(){
					return this.data.apexType || null;
				}
			},
			"guid": {
				value: function(){
					return this.data.guid || null;
				}
			},
			"remainingIds": {
				value: function(){
					return this.data.remainingIds || null;
				}
			},
			"limitValue": {
				value: function(){
					return this.data.configuration.limitValue || null;
				}
			},
			"isAccessible": {
				value: function(){
					return this.data.isAccessible || null;
				}
			},
			"isCreateable": {
				value: function(){
					return this.data.isCreateable || null;
				}
			},
			"isDeleteable": {
				value: function(){
					return this.data.isDeleteable || null;
				}
			},
			"isUpdateable": {
				value: function(){
					return this.data.isUpdateable || null;
				}
			},
			"isHierarchy": {
				value: function(){
					return this.data.isHierarchy || null;
				}
			},
			"isList": {
				value: function(){
					return this.data.isList || null;
				}
			},
			"isFlat": {
				value: function(){
					return !(this.isHierarchy() || this.isList());
				}
			},
			"hasChildren": {
				value: function(){
					return this.children && this.children() && this.children().length > 0;
				}
			},
			"getViewModel": {
				value: function(){
					return app.viewModel;
				}
			},
			"addChildren": {
				value: function(children){
					if(children){
						for(var i=0; i < children.length; i++){
							this.addChild(children[i]);
						}
					}
				}
			},
			"addChild": {
				value: function(child){
					var newResource = new app.ScreenResource(child);
					newResource.propertyBag.setFields(child.propertyBag);
					this.children.push(newResource);
					newResource.addChildren(child.children);
					return newResource;
				}
			}
		});
		app.ScreenResourcesMap = function(data){
			for(var prop in data){
				var property = data[prop];
				if(property.guid){
					var resource = new app.ScreenResource(property);
					resource.propertyBag.setFields(resource.data.propertyBag);
					resource.addChildren(resource.data.children);
					this[property.guid] = resource;
				}
			}
			return this;
		};
		app.WidgetMap = function(data){
			var self = this;
			self.PARAM_SET_DELIM = ";";
			self.PARAM_VAL_DELIM = ":";

			var defaultData = {
				widgetParams: ""
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.isLoading = ko.observable(false);
			self.progressBarPercentage = ko.observable("0%");
			self.isActive = ko.observable(false);
			self.loadingText = LifeCycle.msgs.label_widget_loading_text;
			self.waitingText = LifeCycle.msgs.label_widget_please_wait_text;

			self.isLoading.subscribe(function(newValue){
				if(newValue == false){
					self.progressBarPercentage("100%");
				}
			});
			self.progressBarMessage = ko.computed({
				read: function(){
					return self.progressBarPercentage() + " loaded";
				}
			});

			self.height = ko.computed({
				read: function(){
					return self.isActive() || _.isUndefined(self.widgetParams().height)
						? 'auto'
						: self.widgetParams().height();
				},
				deferEvaluation: true
			});

			return self;
		};
		app.setMapping({
			'copy': ['descriptors','options'],
			'ignore': ['data','descriptor','parent'],
			'screenResources': {
				create: function(options){
					return new app.ScreenResourcesMap(options.data);
				}
			},
			'widget': {
				create: function(options){
					return new app.WidgetMap(options.data);
				}
			},
			'widgetParams': {
				create: function(options){
					return ko.observable({});
				},
				update: function(options){
					var params = {};
					if(_.isString(options.data) && !_.isEmpty(options.data)){
						_.map(options.data.split(options.parent.PARAM_SET_DELIM), function(element){
							var param = element.split(options.parent.PARAM_VAL_DELIM);
							params[param[0]] = param[1];
						});
					}
					return app.mapFromJS(params, app.getMapping(), options.target);
				}
			}
		});
		app.log('Models initialized.');
	};
	if(LifeCycle.LayoutViewer == undefined){
		LifeCycle.LayoutViewer = {};
	}
	if(LifeCycle.LayoutViewer.Models == undefined){
		LifeCycle.LayoutViewer.Models = Models;
	}
})();
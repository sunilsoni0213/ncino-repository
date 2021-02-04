(function(){
	var dateUtil = {
		TZ_OFFSET_MS: new Date().getTimezoneOffset() * 60000,
		convertGmtTimestampToLocalDate: function(timestamp){
			var td = new Date(timestamp);
			if (_.isUndefined(timestamp) || _.isNull(timestamp)){
				return null;
			}
			return new Date(td.getUTCFullYear(), td.getUTCMonth(), td.getUTCDate(), td.getUTCHours(), td.getUTCMinutes(), td.getUTCSeconds());
		},
		convertLocalDateToGmtTimestamp: function(localDate){
			return (_.isUndefined(localDate) || _.isNull(localDate))
					? null : localDate.getTime() - this.TZ_OFFSET_MS;
		}
	};
	var Models = function(event, app){

		// Field preprocessor
		app.Field = function(data, parent, descriptor){
			var _data;

			_data = _.extend({
				// default data
				contextIdentifier: null,
				controllingGuid: null,
				displayOrder: null,
				displayValue: null,
				fieldLabel: null,
				inlineHelpText: null,
				fieldLength: null,
				fieldName: null,
				fieldType: null,
				guid: null,
				isDependent: false,
				isDirty: false,
				isReadOnly: false,
				isRequired: false,
				isVisible: true,
				options: [],
				precision: null,
				referenceContext: null,
				scale: null,
				value: null
			}, (_.isUndefined(descriptor) ? {} : descriptor), (_.isUndefined(data) ? {} : data));

			self = _data;
			self.isFieldType = function(type, comparison) {
				comparison = _.isUndefined(comparison) ? ko.unwrap(self.fieldType) : comparison;
				return comparison == type;
			};
			self.isCurrencyType = function(comparison){
				return self.isFieldType(Layout.DATA.fieldTypes.CURRENCY, comparison);
			};
			self.isDateType = function(comparison){
				return self.isFieldType(Layout.DATA.fieldTypes.DATE, comparison);
			};
			self.isDateTimeType = function(comparison){
				return self.isFieldType(Layout.DATA.fieldTypes.DATETIME, comparison);
			};
			self.isIntegerType = function(comparison){
				return self.isFieldType(Layout.DATA.fieldTypes.INTEGER, comparison);
			};
			self.isDoubleType = function(comparison){
				return self.isFieldType(Layout.DATA.fieldTypes.DOUBLE, comparison);
			};
			self.isPercentType = function(comparison){
				return self.isFieldType(Layout.DATA.fieldTypes.PERCENT, comparison);
			};
			self.isPicklistType = function(comparison){
				return self.isFieldType(Layout.DATA.fieldTypes.PICKLIST, comparison);
			};
			self.isMultiPicklistType = function(comparison){
				return self.isFieldType(Layout.DATA.fieldTypes.MULTIPICKLIST, comparison);
			};
			self.isReferenceType = function(comparison){
				return self.isFieldType(Layout.DATA.fieldTypes.REFERENCE, comparison);
			};

			if((self.isIntegerType() ||
				self.isDoubleType() ||
				self.isCurrencyType() ||
				self.isPercentType()) &&
				!self.value){
				self.value = 0;
			}

			if(self.isPicklistType()){
				self.selectedOption = function () {
					return getPicklistOptionForValue(ko.unwrap(this.value), ko.unwrap(this.options));
				};
			}

			if(self.isMultiPicklistType()){
				var formatSelectedOptions = function(value){
					self.selectedOptions = value ? value.split(';') : [];
				};
				formatSelectedOptions(ko.unwrap(self.value));
			}

			function getPicklistOptionForValue(value, options) {
				for (var i = 0; i < options.length; i++) {
					var option = options[i];
					if (ko.unwrap(option.value) == value) {
						return option;
					}
				}
				return {
					label: value,
					value: value,
					defaultValue: false,
					active: true
				};
			}

			return _data;
		};
		app.FieldsMap = function(data, parent){
			var self = this;
			// has no default data
			self.getFields = function(){
				return _.filter(_.values(self), function(value){
					return value instanceof app.Field;
				});
			};
			self.getParent = function(){
				return parent;
			};
			self.hasContent = function(fieldNamePropertyName){
				var tmp = fieldNamePropertyName.split('.'),
					fieldName = tmp[0],
					propertyName = tmp[1];
				var ret = false;
				if(self[fieldName] && (typeof propertyName === 'undefined' || self[fieldName][propertyName])){
					ret = true;
				}
				return ret;
			};
			self.getContent = function(fieldNamePropertyName, isFunction, subPropertyName){
				var tmp = fieldNamePropertyName.split('.'),
					fieldName = tmp[0],
					propertyName = tmp[1];
				isFunction = typeof isFunction === 'undefined' ? false : !!isFunction;
				var ret;
				if (typeof self[fieldName] !== 'undefined') {
					if(isFunction && typeof self[fieldName][propertyName] === 'function') {
						ret = self[fieldName][propertyName]();
						if(typeof subPropertyName !== 'undefined') {
							ret = ret[subPropertyName];
						}
					} else if (typeof self[fieldName][propertyName] !== 'undefined' && self[fieldName][propertyName] !== null) {
						ret = self[fieldName][propertyName];
					} else if (typeof self[fieldName]['data'][propertyName] !== 'undefined') {
						ret = self[fieldName]['data'][propertyName];
					}
				}
				return ret;
			};
			return self;
		};
		app.ScreenResource = function(data){
			var self = this;

			app.mapFromJS({
				// default data
				apexType: null,
				children: [],
				guid: null,
				propertyBag: {},
				isAccessible: false,
				isCreateable: false,
				isDeletable: false,
				isUpdateable: false,
				isHierarchy: false,
				isList: false
			}, app.getMapping(), self);

			self.selectedChild = ko.observable();

			self.propertyList = ko.computed({
				read: function(){
					return _.filter(_.values(self.propertyBag), function(property){
						return property instanceof app.Field && property.isVisible();
					}).sort(function(a,b){
						return a.displayOrder() - b.displayOrder();
					});
				},
				deferEvaluation: true
			});

			self.isFlat = ko.computed({
				read: function(){
					return !(self.isHierarchy() || self.isList());
				},
				deferEvaluation: true
			});

			self.hasChildren = ko.computed({
				read: function(){
					return self.children().length > 0;
				},
				deferEvaluation: true
			});

			self.hasDirtyData = ko.computed({
				read: function(){
					var hasDirtyData = false;
					_.each(self.propertyList(), function(property){
						if(property.isDirty()){
							hasDirtyData = true;
						}
					});
					_.each(self.children(), function(child){
						if(child.hasDirtyData()){
							hasDirtyData = true;
						}
					});
					return hasDirtyData;
				},
				write: function(value){
					if(!value){
						_.each(self.propertyList(), function(property){
							if(property.isDirty()){
								property.resetData();
							}
						});
						_.each(self.children(), function(child){
							if(child.hasDirtyData()){
								child.hasDirtyData(value);
							}
						});
					}
				},
				deferEvaluation: true
			});

			self.getViewModel = function(){
				return app.viewModel;
			};

			return self;
		};
		app.ScreenResourcesMap = function(data){
			var self = this;

			// has no default data
			if(!_.isUndefined(data)){
				_.each(data, function(value, key){
					if(_.isUndefined(app.getMapping()[key])){
						app.getMapping()[key] = app.getMapping()['screenResource'];
					}
				});
				app.mapFromJS(data, app.getMapping(), self);
			}

			return self;
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
			'copy': ['descriptors'],
			'children': {
				create: function(options){
					return new app.ScreenResource(options.data);
				},
				update: function(options){
					return app.mapFromJS(options.data, app.getMapping(), options.target);
				}
			},
			'options': {
				create: function(options){
					return new Object();
				},
				update: function(options){
					return app.mapFromJS(options.data, app.getMapping(), options.target);
				},
				key: function(option){
					return ko.utils.unwrapObservable(option.value);
				}
			},
			'propertyBag': {
				create: function(options){
					return new app.FieldsMap(options.data, options.parent);
				},
				update: function(options){
					var descriptors = options.parent.descriptors || { fields: {} };
					_.each(options.data, function(value, key){
						// Preprocess fields
						options.data[key] = app.Field(value, options.target, descriptors.fields[value.guid]);
					});
					return app.mapFromJS(options.data, app.getMapping(), options.target);
				}
			},
			'screenResource': {
				create: function(options){
					return new app.ScreenResource(options.data);
				},
				update: function(options){
					return app.mapFromJS(options.data, app.getMapping(), options.target);
				}
			},
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
	if(LifeCycle.LayoutDesigner == undefined){
		LifeCycle.LayoutDesigner = {};
	}
	if(LifeCycle.LayoutDesigner.Models == undefined){
		LifeCycle.LayoutDesigner.Models = Models;
	}
})();

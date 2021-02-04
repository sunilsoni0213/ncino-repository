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
		app.Field = function(data, parent, descriptor){
			var _data,
				_source,
				self = this,
				PREFIX = 'vf-field-source-',
				DELIM = '-';

			self.setData = function(data){
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
					isHtmlFormatted: false,
					options: [],
					precision: null,
					referenceContext: null,
					scale: null,
					value: null
				}, (_.isUndefined(descriptor) ? {} : descriptor), (_.isUndefined(data) ? {} : data));

				if(!_.isUndefined(app.viewModel) && app.viewModel instanceof app.ViewModel
						&& !_.isUndefined(parent) && parent instanceof app.FieldsMap){
					_source = document.getElementById(
							  PREFIX + app.viewModel.guid()
							+ DELIM + parent.getParent().guid()
							+ DELIM + _data.guid);
					_source = _.isNull(_source) ? undefined : _source;
				}

				var options = getOptionsFromSource(_source);
				_data.options = _.isUndefined(options) ? _data.options : options;

				if(!_.isUndefined(self.selectedOptions)) {
					self.selectedOptions([]);
				}

				return app.mapFromJS(_data, app.getMapping(), self);
			};
			self.resetData = function(){
				return app.mapFromJS(_data, app.getMapping(), self);
			};

			self.setData(data);

			self.isOriginallyRequired = self.isRequired();

			self.isFieldType = function(type, comparison) {
				comparison = _.isUndefined(comparison) ? self.fieldType() : comparison;
				return comparison == type;
			};
			self.isDateType = function(comparison){
				return self.isFieldType(Layout.DATA.fieldTypes.DATE, comparison);
			};
			self.isDateTimeType = function(comparison){
				return self.isFieldType(Layout.DATA.fieldTypes.DATETIME, comparison);
			};
			self.isDoubleType = function(comparison){
				return self.isFieldType(Layout.DATA.fieldTypes.DOUBLE, comparison);
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

			// unmapped properties
			self.DEFAULT_PLACEHOLDER = self.isDoubleType()
					? '0' + (self.scale() ? '.' : '' ) + Array(self.scale() + 1).join('0') : '';
			self.MULTIPICK_VAL_DELIM = ';';
			self.isDisabled = ko.observable(self.isReadOnly());
			self.placeholder = ko.observable(self.DEFAULT_PLACEHOLDER);
			self.selectedOptions = ko.observableArray([]);

			var tracking = self.isReferenceType() ? 'displayValue' : 'value';
			self[tracking].subscribe(function(value){
				value = _.isUndefined(value) || _.isNull(value) || value === '' ? null : value;
				self.isDirty(value != _data[tracking]);
			}, null, 'change');

			if(self.isDateType() || self.isDateTimeType()){
				var formatDisplayValue = function(value){
					if(_.isNull(value)){
						self.displayValue(null);
					} else {
						if (self.isDateType()) {
							self.displayValue(moment(value).utc().format('YYYY-MM-DD'));
						} else if (self.isDateTimeType()) {
							self.displayValue(moment(value).format('YYYY-MM-DDTHH:mm'));
						}
					}
				};
				formatDisplayValue(self.value());
				self.value.subscribe(formatDisplayValue);
				self.displayValue.subscribe(function(value){
					if(!_.isNaN(value) && !_.isUndefined(value) && !_.isNull(value)){
						if (self.isDateType()) {
							self.value(moment.utc(value).valueOf());
						} else {
							self.value(moment(value).valueOf());
						}
					} else {
						self.value(null);
					}
				});
			}

			if(self.isPicklistType()){
				self.value.subscribe(function(value){
					if(!_.isUndefined(_source)){
						jQuery(_source).find('select')
								.val(self.value())
								.trigger('change');
					}
				});

				if(self.isDependent() && !_.isEmpty(self.controllingGuid())
						&& !_.isUndefined(parent[self.controllingGuid()])
						&& parent[self.controllingGuid()] instanceof app.Field){

					parent[self.controllingGuid()].value.subscribe(function(value){
						if(!_.isUndefined(_source)){
							var length = self.options().length;

							_.each(getOptionsFromSource(_source), function(option){
								var index = self.options.mappedIndexOf(option);
								if(index == -1){
									self.options.mappedCreate(option);
								}else{
									// must add value at last index
									self.options.push(self.options()[index]);
									// before removing it from original index
									self.options.splice(index, 1);
									length--;
								}
							});
							self.options.splice(0, length);

							if (self.options) {
								if (self.options().length === 1 && self.options()[0].label() === OPTION_NONE) {
									self.isRequired(false);
								} else {
									self.isRequired(self.isOriginallyRequired);
								}
							}
						}
					});
				}

				self.selectedOption = ko.computed({
					read: function(){
						return getPicklistOptionForValue(self.value(), self.options());
					},
					write: function(option){
						option = _.isEmpty(option) ? undefined : option;
						self.value(_.isObject(option) ? option.value() : option);
					},
					deferEvaluation: true
				});
			}

			if(self.isMultiPicklistType()){
				var formatSelectedOptions = function(value){
					self.selectedOptions(_.isNull(value) ? [] : value.split(self.MULTIPICK_VAL_DELIM));
				};

				self.value.subscribe(formatSelectedOptions);
				self.selectedOptions.subscribe(function(values) {
					self.value(_.isEmpty(values) ? null : values.join(self.MULTIPICK_VAL_DELIM));
				});
				self.selectedOptions.subscribe(function(values) {
					var labels = [];
					if(!_.isEmpty(values)) {
						_.each(values, function(value) {
							if (!_.isNull(value)) {
								var selectedOption = getPicklistOptionForValue(value, self.options());
								if (selectedOption) {
									labels.push(selectedOption.label());
								}
							}
						});
					}
					self.displayValue(_.isEmpty(labels) ? '' : labels.join(self.MULTIPICK_VAL_DELIM + ' '));
				});

				formatSelectedOptions(self.value());
			}

			if(self.isReferenceType()){
				self.placeholder(LifeCycle.msgs.type_to_search);
				self.displayValue.subscribe(function(value){
					if(_.isEmpty(value)){
						self.value(null);
					}
				});
			}

			self.getApp = function(){
				return app;
			};
			self.getParent = function(){
				return parent;
			};

			function getOptionsFromSource(source){
				if(_.isUndefined(source)){
					return undefined;
				}

				var options = [];
				_.each(jQuery(source).find('option'), function(option){
					options.push({
						active: true,
						defaultValue: option.defaultSelected,
						label: option.label ? option.label : option.text,
						value: option.label === OPTION_NONE ? '' : option.value
					});
				});
				return options;
			}

			function getPicklistOptionForValue(value, options) {
				for (var i = 0; i < options.length; i++) {
					var option = options[i];
					if (option.value() == value) {
						return option;
					}
				}
				return {
					label: ko.observable(value),
					value: ko.observable(value),
					defaultValue: ko.observable(false),
					active: ko.observable(true)
				};
			};
			self.getCurrencyIsoCode = function(propertyBag) {
				return app.viewModel.getCurrencyIsoCode(self.contextIdentifier(), propertyBag);
			};
			return self;
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
			self.PARAM_SET_DELIM = ';';
			self.PARAM_VAL_DELIM = ':';

			var defaultData = {
				widgetParams: '',
				isLoading: false,
				progressBarPercentage: '0%',
				isActive: null,
				loadingText: LifeCycle.msgs.label_widget_loading_text,
				waitingText: LifeCycle.msgs.label_widget_please_wait_text
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.isLoading.subscribe(function(newValue){
				if(newValue == false){
					self.progressBarPercentage('100%');
				}
			});
			self.progressBarMessage = ko.computed({
				read: function(){
					return self.progressBarPercentage() + ' loaded';
				}
			});

			self.isActive = ko.observable(false);
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
			'field': {
				create: function(options){
					return new app.Field(
						options.data,
						options.parent,
						options.parent.getParent && options.parent.getParent().descriptors ?
						options.parent.getParent().descriptors.fields[options.data.guid] :
						undefined
					);
				},
				update: function(options){
					return options.target.setData(options.data);
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
					_.each(options.data, function(value, key){
						if(_.isUndefined(app.getMapping()[key])){
							app.getMapping()[key] = app.getMapping()['field'];
						}
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
	var OPTION_NONE = '--None--';
})();

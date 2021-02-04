(function(){
	/* Custom Bindings */
	ko.bindingHandlers.publish = {
		init: function(element, valueAccessor, allBindings, viewModel, bindingContext){
			var value = ko.utils.unwrapObservable(valueAccessor());
			var app = ko.utils.unwrapObservable(value.publisher);
			var topic = ko.utils.unwrapObservable(value.topic);
			var message = ko.utils.unwrapObservable(value.message) || {};

			if(!_.isUndefined(app) && _.isString(topic) && !_.isEmpty(topic)){
				ko.applyBindingsToNode(element, {
					click: function() {
							app.publish(topic, message);
						}
				});
			}
		}
	};

	ko.bindingHandlers.tooltip = {
		init: function(element, valueAccessor) {
			var local = ko.utils.unwrapObservable(valueAccessor()),
				options = {};

			ko.utils.extend(options, ko.bindingHandlers.tooltip.options);
			ko.utils.extend(options, local);

			jQuery(element).tooltip(options);

			ko.utils.domNodeDisposal.addDisposeCallback(element, function() {
				jQuery(element).tooltip("destroy");
			});
		},
		options: {
			placement: "right",
			trigger: "click"
		}
	};

	ko.bindingHandlers.search = {
		shouldExecute: true,
		disableRelatedFields: function(value, reference){
			reference = _.isUndefined(reference) ? this : reference,
				value = _.isUndefined(value) ? reference.value() : value;
			if(_.isEmpty(value)){
				_.each(reference.getParent().getFields(), function(field){
					if(field.contextIdentifier() == reference.referenceContext()){
						field.isDisabled(true);
						if(field.fieldType() === Layout.DATA.fieldTypes.PICKLIST
							&& !field.isReadOnly()){
							field.options.unshift({
								label: ko.observable(LifeCycle.msgs.select_start
										+ reference.fieldLabel()
										+ LifeCycle.msgs.select_end),
								value: ko.observable(LifeCycle.msgs.select_start
										+ reference.fieldLabel()
										+ LifeCycle.msgs.select_end),
								defaultValue: ko.observable(false),
								active: ko.observable(true)
							});
							field.value(
									LifeCycle.msgs.select_start
									+ reference.fieldLabel()
									+ LifeCycle.msgs.select_end);
						}else{
							field.placeholder(
									LifeCycle.msgs.select_start
									+ reference.fieldLabel()
									+ LifeCycle.msgs.select_end);
							field.displayValue(null);
							field.value(null);
						}
						field.isDirty(false);
					}
				});
			}
		},
		enableRelatedFields: function(value, reference, properties){
			reference = _.isUndefined(reference) ? this : reference,
				value = _.isUndefined(value) ? reference.value() : value;
			properties = _.isUndefined(properties) ? {
				getFields: function(){
					return [];
				}
			} : properties;
			if (!_.isEmpty(value)){
				_.each(reference.getParent().getFields(), function(field){
					if(field.contextIdentifier() == reference.referenceContext()){
						field.isDisabled(field.isReadOnly());
						if(field.fieldType() === Layout.DATA.fieldTypes.PICKLIST
							&& !field.isReadOnly()){
							field.options.shift();
						}else{
							field.placeholder(field.DEFAULT_PLACEHOLDER);
						}
						var replacement = _.find(properties.getFields(), function(property){
							return property.fieldName() == field.fieldName();
						});
						field.displayValue(_.isUndefined(replacement) ? null : replacement.displayValue());
						field.value(_.isUndefined(replacement) ? null : replacement.value());
						field.isDirty(false);
					}
				});
			}
		},
		init: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
			var field = bindingContext.$data;
			ko.bindingHandlers.search.disableRelatedFields.call(field);
			field.value.subscribe(ko.bindingHandlers.search.disableRelatedFields, field);
		},
		hideResults: function(field, resultsId, app){
			jQuery('input[data-result-id="' + field.guid() + '"]').off('.lookupSearch');
			jQuery(window).off('.lookupSearch');
			jQuery(resultsId).fadeOut({
				duration: 100,
				done: function(){
					jQuery(resultsId).remove().appendTo(jQuery(
						'input[data-result-id="' + field.guid() + '"]').parent());
					var resultResource = new app.ScreenResource();
					ko.applyBindingsToNode(
						document.getElementById(field.guid()),
						{template: {name: 'search-results-template', data: resultResource}},
						resultResource);
				}
			});
		}
	};
	ko.bindingHandlers.search.executeSearch = _.debounce(function (element, valueAccessor, allBindings, viewModel, bindingContext){
		if (!bindingContext){
			return;
		}
		if (ko.bindingHandlers.search.shouldExecute){
			var field = bindingContext.$data,
				value, app, screenResource, newResource, mappedField, resultsId, jsonResource;
			ko.bindingHandlers.search.shouldExecute = false;
			value = ko.utils.unwrapObservable(valueAccessor());
			app = ko.utils.unwrapObservable(value.publisher);
			resultsId = '#' + field.guid();

			if (element != document.activeElement || !field.isDirty()
				|| field.displayValue() == null || field.displayValue().length <= 2){
				ko.bindingHandlers.search.hideResults(field, resultsId, app);
				ko.bindingHandlers.search.shouldExecute = true;
				return;
			}

			screenResource = ko.utils.unwrapObservable(value.resource);
			newResource = new app.ScreenResource();
			mappedField = app.mapToJS(field);
			jsonResource = {
				apexType: screenResource.apexType(),
				propertyBag: {},
				children: [],
				configuration: app.mapToJS(screenResource.configuration)
			};

			jsonResource.propertyBag[field.guid()] = mappedField;
			app.mapFromJS(jsonResource, app.getMapping(), newResource);

			var searchTopic = 'lookup.search' + app.appId;
			app.publish(searchTopic, [newResource, function(resource){
				if (resource.propertyBag[field.guid()].displayValue != field.displayValue()){
					ko.bindingHandlers.search.shouldExecute = true;
					ko.bindingHandlers.search.executeSearch(
						element, valueAccessor, allBindings, viewModel, bindingContext);
					return;
				}

				var resultResource = new app.ScreenResource();
				resultResource.selectedChild.subscribe(function(child){
					ko.bindingHandlers.search.hideResults(field, resultsId, app);
					ko.bindingHandlers.search.shouldExecute = false;
					_.each(child.propertyBag.getFields(), function(value, key){
						if (value.fieldType() === Layout.DATA.fieldTypes.ID){
							field.value(value.value());
						} else if (value.fieldName() == 'Name'){
							field.displayValue(value.value());
						}
					});
					ko.bindingHandlers.search.enableRelatedFields(field.value(), field, child.propertyBag);
					ko.bindingHandlers.search.shouldExecute = true;
				});
				app.mapFromJS(resource, app.getMapping(), resultResource);

				if(!ko.bindingHandlers.search.updating){
					(function(){
						var DEFAULT_HEIGHT = 183;
						var SCROLLBAR_WIDTH = 17;
						var TABLE_PAD = 25;

						var element = jQuery(resultsId);
						element.remove().appendTo('div.force .ui-container');
						ko.applyBindingsToNode(
							document.getElementById(field.guid()),
							{template: {name: 'search-results-template', data: resultResource}},
							resultResource);

						element.fadeIn(100)
							.css('height', resultResource.children().length > 4 ? DEFAULT_HEIGHT : 'auto')
							.css('width', 'auto')
							.removeClass('is-small');

						var input = jQuery('input[data-result-id="' + element.attr('id') + '"]').parent();

						var tableWidth = element.find('table:first').width();

						var roomToRight = jQuery(window).width() - input.offset().left;
						var roomToLeft = input.offset().left + input.width();
						var alignLeft = roomToRight > roomToLeft;

						var isSmall = (roomToRight < tableWidth + TABLE_PAD
							&& roomToLeft < tableWidth + TABLE_PAD);

						element.addClass(isSmall ? 'is-small' : '');

						var scrollBarWidth =
							(resultResource.children().length > 4) && !isSmall ? SCROLLBAR_WIDTH : 0;

						(function(){
							var thList = element.find('thead th');
							var tdList = element.find('tbody td');

							var colWidths = thList.map(function(v, i){
								return jQuery(this).width() > jQuery(tdList[i]).width() ?
									jQuery(this).width() : jQuery(tdList[i]).width();
							}).get();

							thList.each(function(i, v){
								if (i == thList.length - 1){
									jQuery(v).width(colWidths[i] + scrollBarWidth);
								} else {
									jQuery(v).width(colWidths[i]);
								}
								jQuery(tdList[i]).width(colWidths[i]);
							});
						})();

						tableWidth = tableWidth + (isSmall ? 0 : TABLE_PAD);
						var divWidth = alignLeft ?
							(tableWidth < roomToRight ? tableWidth : roomToRight)
							: (tableWidth < roomToLeft ? tableWidth : roomToLeft);
						element.find('table').eq(1).width(tableWidth - scrollBarWidth);
						element.width(divWidth);

						element.offset({
							top: (input.offset().top + input.outerHeight()),
							left: (alignLeft ?
									input.offset().left :
									(input.offset().left - divWidth) + input.width()
							)
						});

						jQuery(".container-fluid")
							.click(function(){
								ko.bindingHandlers.search.hideResults(field, resultsId, app);
							});

						jQuery(".ui-lookup-results")
							.click(function(){
								ko.bindingHandlers.search.updating = true;
							});

						jQuery(window)
							.off('resize.lookupSearch')
							.one('resize.lookupSearch', function(){
								ko.bindingHandlers.search.hideResults(field, resultsId, app);
							});
					})();
				} else {
					ko.bindingHandlers.search.updating = false;
				}
				ko.bindingHandlers.search.shouldExecute = true;
			}]);
		}
	}, 500);
	ko.bindingHandlers.search.update = ko.bindingHandlers.search.executeSearch;

	ko.bindingHandlers.decimalElement = {
		update: function(element, valueAccessor, allBindingsAccessor){
		var options = allBindingsAccessor() || {};

		if(!_.has(options, 'required')) {
			options = _.extend({
				'required':false
			}, options);
		}

		var value = ko.utils.unwrapObservable(valueAccessor());
		var scale = _.isUndefined(allBindingsAccessor().scale) ? 2 : ko.unwrap(allBindingsAccessor().scale);

		var formatted;

		if(!_.isNull(value) && !_.isUndefined(value) && _.isNumber(value)){
			formatted = value.toFixed(scale);
		} else {
			formatted = value;
		}
		if(options['required']) {
			formatted = _formatAsRequired(formatted, element);
		}
			ko.bindingHandlers.text.update(element, function () { return formatted; });
		}
	};

	ko.bindingHandlers.currencyElement = {
		update:function(element,valueAccessor,allBindingsAccessor){
			var options = allBindingsAccessor().currencyOptions || {};
			options = _.extend({
				'default': null,
				'stripSymbol': false,
				'required': false
			}, options);

			var value = ko.utils.unwrapObservable(valueAccessor());
			var scale = 2; // number of decimal places to round to
			var scaleDivisor = 1;  // scale for currency value
			if (allBindingsAccessor().hasOwnProperty('scaleDivisor')) {
				scaleDivisor = ko.unwrap(allBindingsAccessor().scaleDivisor);
			}
			if (allBindingsAccessor().hasOwnProperty("scale")) {
				scale = ko.unwrap(allBindingsAccessor().scale);
			}
			if (!_.isNull(value) && !isNaN(value)) {
				value = value/scaleDivisor;
			}
			var formatted;
			if(!window.LifeCycle.Internationalize) {
				formatted = isNaN(value) ? options['default']
					: jQuery('<input />').val(value).formatCurrency({ 'region': LifeCycle.language, 'roundToDecimalPlace': scale }).val();
				if(options['stripSymbol'] && _.isString(formatted)){
					formatted = formatted.replace(_getCurrencySymbol(LifeCycle.language), '');
				}
			} else {
				if(options['stripSymbol']) {
					formatted = isNaN(value) ? options['default']
						: window.LifeCycle.Internationalize.format(value, 'N' + scale);
				} else {
					formatted = isNaN(value) ? options['default']
						: window.LifeCycle.Internationalize.format(value, 'C' + scale, ko.unwrap(allBindingsAccessor().currencyIsoCode));
				}
			}
			if(options['required']) {
				formatted = _formatAsRequired(formatted, element);
			}
			ko.bindingHandlers.text.update(element, function() { return formatted; });
		}
	};

	ko.bindingHandlers.percentElement = {
		update: function(element, valueAccessor, allBindingsAccessor){
			var options = allBindingsAccessor() || {};
			var scale = _.isUndefined(allBindingsAccessor().scale) ? 0 : ko.unwrap(allBindingsAccessor().scale);
			var precision = _.isUndefined(allBindingsAccessor().precision) ? 18 : ko.unwrap(allBindingsAccessor().precision);

			if(!_.has(options, 'required')) {
				options = _.extend({
				'required':false
				}, options);
			}

			var value = ko.utils.unwrapObservable(valueAccessor());
			var formatted = null;
			if((!_.isEmpty(value) || _.isNumber(value)) && !_.isString(value)){
				formatted = Number(value).toPrecision(precision);
				//to avoid sci. notation values from toPrecision
				formatted = Number(formatted);
				formatted = String(formatted.toFixed(scale))  + '%';
			}
			if(options['required']) {
				formatted = _formatAsRequired(formatted, element);
			}
			ko.bindingHandlers.text.update(element, function () { return formatted; });
		}
	};

	ko.bindingHandlers.ckEditor = {

		init: function(element, valueAccessor, allBindings, deprecated, bindingContext){
			var text = ko.utils.unwrapObservable(valueAccessor());
			if(bindingContext.widgetParams != undefined){
				var options = ko.utils.unwrapObservable(bindingContext.widgetParams);
			}
			var editor = jQuery( element ).ckeditor( function( ckEditor ) {
				// retrieve the HTML from the attachment

			}).editor;

			if (typeof bindingContext.$data.widget.parameters().maxSize == 'function')
				editor.maxAttachmentSize = bindingContext.$data.widget.parameters().maxSize();
			else
				editor.maxAttachmentSize = 6000000;
			editor.on('paste', function(evt){
				console.log(evt);
			});
			editor.on('change', function () {
				if (editor.loaded) {
					editor.commands.save.enable();
				}
				else {
					editor.loaded = true;
					editor.resetDirty();
				}
			});
			// wait until the editor is done initializing
			editor.on('instanceReady',function() {
				editor.loaded = false;

				LifeCycle.Force.retrieveAttachment(
					editor.element.getId(),
					LifeCycle.msgs.msg_rendered_view_filename,
					function(data){
						if(data != null){
							view = jQuery('<textarea />').html(data.body).text();
							if (view != '')
								editor.setData(view, function () {
									if (editor.config.setupDropZone)
										editor.config.setupDropZone(editor);

									editor.undoManager.save();
									var numSnaps = editor.undoManager.snapshots.length;
									var saveSnapshot = editor.undoManager.snapshots[numSnaps - 1];
									editor.config.initialSnapshot = saveSnapshot;
									editor.commands.cancel.disable();
								});
							else
								editor.loaded = true;
						}
					},
					function(){}
				);

			}, options);
		}

	};

	ko.bindingHandlers.datepicker = {
		intl: window.LifeCycle.Internationalize,
		_getSalesforceDstOffset: function(currentDate, selectedDate) {
			var currentTimezoneOffset = currentDate.getTimezoneOffset();
			var selectedTimezoneOffset = selectedDate.getTimezoneOffset();
			var sfOffset = -ko.bindingHandlers.datepicker.intl.sfUserTimezoneOffset / 1000 / 60;

			var dstOffset = 0;
			if (sfOffset !== selectedTimezoneOffset && sfOffset === currentTimezoneOffset) {
				dstOffset = (selectedTimezoneOffset - currentTimezoneOffset) * 60 * 1000;
			}

			return dstOffset;
		},
		_getJsDstOffset: function(currentDate, selectedDate) {
			var sfOffset = -ko.bindingHandlers.datepicker.intl.sfUserTimezoneOffset;
			var selectedTimezoneOffset = selectedDate.getTimezoneOffset() * 60 * 1000;
			var currentTimezoneOffset = currentDate.getTimezoneOffset() * 60 * 1000;
			var jsDstOffset = selectedTimezoneOffset - currentTimezoneOffset;

			var sfDstOffset = selectedTimezoneOffset - sfOffset;
			return sfDstOffset !== jsDstOffset ? jsDstOffset : 0;
		},
		_parseDatetime: function(input, isDate) {
			if (!input) {
				return new Date(undefined);
			}

			var date = ko.bindingHandlers.datepicker.intl.parseDate(input);
			if (!isDate && date == null) {
				var dateCode = ko.bindingHandlers.datepicker.intl.formats.datetime.SHORT_DATE;
				var datePattern = ko.bindingHandlers.datepicker.intl.getDatetimePattern(dateCode);
				var timeCode = ko.bindingHandlers.datepicker.intl.formats.datetime.SHORT_TIME;
				var timePattern = ko.bindingHandlers.datepicker.intl.getDatetimePattern(timeCode);

				date =  ko.bindingHandlers.datepicker.intl.parseDate(input, datePattern + ' ' + timePattern);
			}

			return date;
		},
		_addTime: function(input, date, element) {
			var previousDate = ko.bindingHandlers.datepicker._parseDatetime(element.dataset._preDateValue, true);
			var previousFormattedDate = ko.bindingHandlers.datepicker._formatDatetime(previousDate, true);

			if (input === previousFormattedDate && element.dataset._preDateValue !== previousFormattedDate) {
				return element.dataset._preDateValue;
			} else if (input === ko.bindingHandlers.datepicker._formatDatetime(date, true)) {
				date = ko.bindingHandlers.datepicker._getSelectedDateWithCurrentTime(date);
				return ko.bindingHandlers.datepicker._formatDatetime(date, false);
			}

			return input;
		},
		_getSelectedDateWithCurrentTime: function(date) {
			var aggregateOffset = ko.bindingHandlers.datepicker.intl.aggregateTimezoneOffset;
			var currentDate = ko.bindingHandlers.datepicker._getCurrentDate();
			var jsDstOffset = ko.bindingHandlers.datepicker._getJsDstOffset(currentDate, date);
			var sfDstOffset = ko.bindingHandlers.datepicker._getSalesforceDstOffset(currentDate, date);

			var time = new Date(currentDate.getTime() + aggregateOffset + jsDstOffset + sfDstOffset);
			var localizedTimeString = new Date(date.toDateString() + ' ' + time.toTimeString()).toTimeString();
			return new Date(date.toDateString() + ' ' + localizedTimeString);
		},
		_getCurrentDate: function() {
			return new Date();
		},
		_applyOrRemoveTimezoneDifferences: function(date, isApply) {
			var multiplier = isApply ? 1 : -1;

			var currentDate = ko.bindingHandlers.datepicker._getCurrentDate();
			var dstOffset = multiplier * ko.bindingHandlers.datepicker._getJsDstOffset(currentDate, date);
			var aggregateOffset = multiplier * ko.bindingHandlers.datepicker.intl.aggregateTimezoneOffset;

			return new Date(date.getTime() + aggregateOffset + dstOffset);
		},
		_getDisplayDatetime: function(value, isDate) {
			var date = new Date(value);
			if (!value || isNaN(date.getDate())) {
				return '';
			}

			if (isDate) {
				date = ko.bindingHandlers.datepicker._getDateWithUTC(date);
			} else {
				date = ko.bindingHandlers.datepicker._applyOrRemoveTimezoneDifferences(date, true);
			}

			return ko.bindingHandlers.datepicker._formatDatetime(date, isDate);
		},
		_formatDatetime: function(date, isDate) {
			var datetime = ko.bindingHandlers.datepicker.intl.format(date, 'd');
			if (!isDate) {
				datetime += ' ' + ko.bindingHandlers.datepicker.intl.format(date, 't');
			}
			return datetime;
		},
		_getDateWithUTC: function(date) {
			return new Date(date.getTime() + (date.getTimezoneOffset() * 60 * 1000));
		},
		_setDateObservable: function(inputValue, observable, isDate) {
			if (inputValue) {
				observable(ko.bindingHandlers.datepicker._convertModelValue(inputValue, isDate));
			} else {
				observable('');
			}
		},
		_convertModelValue: function(modelValue, isDate) {
			var date = ko.bindingHandlers.datepicker._parseDatetime(modelValue, isDate);
			if (!date || isNaN(date.getTime())) {
				return '';
			}
			if (isDate) {
				return new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate())).toUTCString();
			}

			return ko.bindingHandlers.datepicker._applyOrRemoveTimezoneDifferences(date, false).toUTCString();
		},
		_setDatepickerDate: function($element, input, isDate) {
			var datepicker = $element.data("datepicker");

			if (datepicker) {
				var date = ko.bindingHandlers.datepicker._parseDatetime(input, isDate);
				datepicker.setDate(date || ko.bindingHandlers.datepicker._getCurrentDate());
				datepicker.update();
				$element.val(input);
			}
		},
		init: function(element, valueAccessor, allBindingsAccessor, data) {
			var isDate = allBindingsAccessor().isDate;
			var pattern = ko.bindingHandlers.datepicker.intl.getDatetimePattern(ko.bindingHandlers.datepicker.intl.formats.datetime.SHORT_DATE);
			if(pattern){
				var intlDateFormat = pattern.toLowerCase();
			}
			var attrs = allBindingsAccessor().datepickerOptions || {};
			var options = {
				container: attrs.container || undefined,
				startView: attrs.startView || undefined,
				autoclose: attrs.autoclose || true,
				orientation: attrs.orientation || 'auto',
				forceParse: attrs.forceParse || false,
				format: attrs.format || intlDateFormat
			};

			if (typeof options.container === 'undefined' && jQuery('.ui-container').length > 0){
				options.container = '.ui-container';
			}

			var $el = jQuery(element);
			$el.attr('type', 'text').datepicker(options);

			$el.click(function(e){
				var $this = jQuery(this);
				ko.bindingHandlers.datepicker._setDatepickerDate($this, $this.val(), isDate);
			});

			var updateDateTime = function(e) {
				var observable = valueAccessor();
				if (ko.isObservable(observable)) {
					var input = e.currentTarget.value.trim();
					var date = ko.bindingHandlers.datepicker._parseDatetime(input, isDate);

					if (!isDate && date && !isNaN(date.getTime())) {
						input = ko.bindingHandlers.datepicker._addTime(input, date, e.currentTarget);
						e.currentTarget.value = input;
					}

					ko.bindingHandlers.datepicker._setDateObservable(input, observable, isDate);
				}
			};
			ko.utils.registerEventHandler(element, 'hide', function(e) {
				updateDateTime(e);
				ko.bindingHandlers.datepicker._setDatepickerDate(jQuery(e.currentTarget), e.currentTarget.value, isDate);
			});
			ko.utils.registerEventHandler(element, 'blur', updateDateTime);

			ko.utils.registerEventHandler(element, 'focus', function() {
				element.dataset._preDateValue = element.value;
			});
			ko.utils.registerEventHandler(element, 'keydown', function(e) {
				var arrowKeys = [ 37, 38, 39, 40 ];
				var inputValue = element.value;
				var observable = valueAccessor();
				var key = e.keyCode || e.which;

				if (observable() && ko.isObservable(observable) && !inputValue && arrowKeys.includes(key)) {
					var date = ko.utils.unwrapObservable(valueAccessor());
					element.value = ko.bindingHandlers.datepicker._getDisplayDatetime(date, isDate);
				}
			});
			//handle disposal (if KO removes by the template binding)
			ko.utils.domNodeDisposal.addDisposeCallback(element, function() {
				$el.datepicker("destroy");
			});

			ko.bindingHandlers.validationCore.init(element, valueAccessor, allBindingsAccessor);

			var observable = valueAccessor();
			if (ko.isObservable(observable)) {
				var date = ko.utils.unwrapObservable(observable);
				var formattedValue = ko.bindingHandlers.datepicker._getDisplayDatetime(date, isDate);
				ko.bindingHandlers.datepicker._setDatepickerDate($el, formattedValue, isDate);
			}
		}
	};

	bindHandlerHelpers = {
		getEditor: function(element, options) {
			return jQuery(element).ckeditor(options).editor;
		},
		clearTabs: function(definition, tabs) {
			for (var i = tabs.length - 1; i >= 0; --i) {
			   definition.removeContents(tabs[i]);
			}
		}
	};

	ko.bindingHandlers.richTextElement = {

		init: function(element, valueAccessor, allBindings) {

			var newValueObservable = valueAccessor();
			var options = allBindings().ckeditoroptions || {};

			var editor = bindHandlerHelpers.getEditor(element,options);

			editor.on('change', function() {
				if(editor.loaded) {
					newValueObservable(editor.getData());
				} else {
					editor.loaded = true;
					editor.resetDirty();
				}
			});

			editor.on('configLoaded', function() {

				editor.config.removePlugins = 'about,allyhelp,bidi,pastefromexcel,stylesheetparser,' +
					'autogrow,droppaste,cancel,widget,spreadsimport';

				editor.config.toolbar = [
					{ name: 'text', items: [ 'Bold', 'Italic', 'Underline','TextColor', 'BGColor' ] },
					{ name: 'format', items: [ 'Undo', 'Redo', 'NumberedList', 'BulletedList', 'Outdent',
						'Indent', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight'] },
					{ name: 'attach', items: [ 'Link', 'Image'] }
				];
			});

			CKEDITOR.on('dialogDefinition', function(ev) {
				if(ev.data.name == 'image') {
					var def = ev.data.definition;
					bindHandlerHelpers.clearTabs(def, ['Link','Upload','advanced']);
				}
			});

		}
	};

	ko.bindingHandlers.foreachPeriod = {
		init: function (element, valueAccessor, allBindings, viewModel, bindingContext) {
			var values = ko.utils.unwrapObservable(valueAccessor());
			var periods = allBindings().periods;
			var onlySelected = ko.utils.unwrapObservable(allBindings().onlySelected);

			function generatePeriodMatchedArray (values, periods) {
				var periodArray = [];

				for (var p = 0; p < periods.length; p++) {
					var period = periods[p];

					if (onlySelected && !period.selected()) {
						continue;
					}

					var matched = false;
					for (var v = 0; v < values.length; v++) {
						var value = values[v];

						var valuePeriodId;
						if (value && value.period) {
							if (typeof value.period.recordId == 'function') {
								valuePeriodId = value.period.recordId();
							} else {
								valuePeriodId = value.period.recordId;
							}
						}

						if (valuePeriodId == period.recordId()) {
							matched = true;
							periodArray.push(value);
						}
					}

					if (!matched) {
						periodArray.push(null);
					}
				}

				return periodArray;
			}

			ko.applyBindingsToNode(element, { foreach: generatePeriodMatchedArray(values, periods) }, bindingContext);
			return { controlsDescendantBindings: true };
		}
	};
	ko.virtualElements.allowedBindings.foreachPeriod = true;

	ko.bindingHandlers.schwift = {
		init: function (element, valueAccessor, allBindingsAccessor) {
			var value = valueAccessor();
			var options = allBindingsAccessor().schwiftOptions || {};

			var marginValue = 0;
			if (ko.unwrap(value)) {
				marginValue = '0';
			} else {
				marginValue = '-' + (options.distance || '100px');
			}

			jQuery(element).toggle(ko.unwrap(value));

			var margin = '';
			switch (options.direction) {
				case 'left':
					margin = 'margin-right';
					break;
				case 'down':
					margin = 'margin-top';
					break;
				case 'up':
					margin = 'margin-down';
					break;
				case 'right':
				default:
					margin = 'margin-left';
					break;
			}

			jQuery(element).css(margin, marginValue);
		},
		update: function (element, valueAccessor, allBindingsAccessor) {
			var value = valueAccessor();
			var options = allBindingsAccessor().schwiftOptions || {};

			var marginValue = 0;
			var easing = '';
			var duration = (options.duration || 'fast');
			var fadeInSpeed = (options.fadeInSpeed || 'slow');
			var fadeOutSpeed = (options.fadeOutSpeed || 'fast');

			if (ko.unwrap(value)) {
				marginValue = '0';
				easing = 'easeOutCubic';
			} else {
				marginValue = '-' + (options.distance || '100px');
			}

			var animation = {};
			switch (options.direction) {
				case 'left':
					animation['margin-right'] = marginValue;
					break;
				case 'down':
					animation['margin-top'] = marginValue;
					break;
				case 'up':
					animation['margin-down'] = marginValue;
					break;
				case 'right':
				default:
					animation['margin-left'] = marginValue;
					break;
			}

			if (ko.unwrap(value)) {
				jQuery(element).animate(animation, {
					easing: easing,
					duration: duration,
					queue: false
				}, function () {

				}).fadeIn(fadeInSpeed);
			} else {
				jQuery(element).animate(animation, {
					easing: easing,
					duration: duration,
					queue: false
				}, function () {

				}).fadeOut(fadeOutSpeed);
			}
		}
	};

	ko.bindingHandlers.chosen = {
		init: function(element, valueAccessor, allBindingsAccessor){
			ko.bindingHandlers.options.init(element);

			var $element = jQuery(element);
			var options = ko.unwrap(allBindingsAccessor()['chosenOptions']);

			if (typeof options === 'object')
				$element.chosen(options);
			else
				$element.chosen();

			['options', 'selectedOptions', 'value'].forEach(function(propName){
				if (allBindingsAccessor().hasOwnProperty(propName)){
					var prop = allBindingsAccessor()[propName];
					if (ko.isObservable(prop)){
						prop.subscribe(function(){
							setTimeout(function () {
								$element.trigger('chosen:updated');
							}, 0);
						});
					}
				}
			});
		},
		update: function(element, valueAccessor, allBindingsAccessor) {
			ko.bindingHandlers.options.update(element, valueAccessor, allBindingsAccessor);
			setTimeout(function () {
				jQuery(element).trigger('chosen:updated');
			}, 0);
		}
	};

	ko.bindingHandlers.filteredOptions = {
		init: function(element, valueAccessor, allBindingsAccessor, vm){
			var controllingGuid = ko.unwrap(valueAccessor());
			if (controllingGuid){
				var refresh = function(){
					var vmParent = vm.getParent()[controllingGuid];
					if (vmParent){
						vmParent.value.valueHasMutated();

						jQuery(element).off('focus', refresh);
					}
				};

				jQuery(element).on('focus', refresh);
			}
		}
	};

	ko.bindingHandlers.buttonToggler = {
		init: function (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {
			ko.bindingHandlers.checked.init(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext);

			var initialSelectedScale = ko.unwrap(valueAccessor());
			jQuery(element).parent().removeClass("active");
			jQuery(element).css("display", "none");
			if (initialSelectedScale == jQuery(element).val()) {
				jQuery(element).parent().addClass("active");
			}

		},
		update: function (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {
			var initialSelectedScale = ko.unwrap(valueAccessor());
			jQuery(element).parent().removeClass("active");
			if (initialSelectedScale == jQuery(element).val()) {
				jQuery(element).parent().addClass("active");
			}
		}
	};

}());
(function() {
	'use strict';
	angular.module('nForceAngular.directives', []).directive('nforceDatePicker',
		function() {
			function formatDate(dateToFormat, dateFormat) {
				if (typeof dateToFormat === 'string') {
					var newDate = moment(new Date(dateToFormat.replace(/[-\.]/g, '/')));
					return newDate.isValid() ? newDate.utc().format(dateFormat) : '';
				} else if (typeof dateToFormat.getDate === 'function') {
					var newDate = moment(dateToFormat);
					return newDate.isValid() ? newDate.utc().format(dateFormat) : '';
				} else {
					return '';
				}
			}

			function elementPreviousDate(element, value) {
				if (typeof value === 'undefined') {
					value = element.dataset.previousDate;
				} else {
					element.dataset.previousDate = value;
				}
				return value;
			}

			return {
				restrict: 'A',
				scope: {
					datesDisabled: '@',
					defaultViewDate: '@'
				},
				link: function(scope, element, attrs, ngModelCtrl) {
					function saveToModel(newDate){
						if (ngModelCtrl) {
							ngModelCtrl.$setViewValue(newDate);
						}
					}
					if (ngModelCtrl) {
						ngModelCtrl.$formatters.push(function(modelValue) {
							if (_.isUndefined(modelValue) || _.isNull(modelValue)) {
								return null;
							}
							var td = new Date(modelValue);
							if (isNaN(td.getDate())) {
								return null;
							}
							return new Date(td.getUTCFullYear(), td.getUTCMonth(), td.getUTCDate(),
								td.getUTCHours(), td.getUTCMinutes(), td.getUTCSeconds());
						});
						ngModelCtrl.$parsers.push(function(viewValue) {
							if (_.isUndefined(viewValue) || _.isNull(viewValue)) {
								return null;
							}
							return moment(viewValue).valueOf();
						});
					}
					if (!jQuery.browser.mobile) {
						var options = {
							container: attrs.container || undefined,
							autoclose: attrs.autoclose || true,
							orientation: attrs.orientation || 'auto',
							forceParse: attrs.forceParse || false,
							format: attrs.format || 'yyyy-mm-dd'
						};

						if (attrs.datesDisabled) {
							options.datesDisabled = scope.$eval(attrs.datesDisabled);
						}
						attrs.$observe('datesDisabled', function(value) {
							if (value) {
								jQuery(element).datepicker('setDatesDisabled', scope.$eval(value));
							}
						});

						if (attrs.startDate) {
							options.startDate = attrs.startDate;
						}
						attrs.$observe('startDate', function(value) {
							if (value) {
								jQuery(element).datepicker('setStartDate', value);
							}
						});

						if (attrs.endDate) {
							options.endDate = attrs.endDate;
						}
						attrs.$observe('endDate', function(value) {
							if (value) {
								jQuery(element).datepicker('setEndDate', value);
							}
						});

						if (attrs.defaultViewDate) {
							options.defaultViewDate = attrs.defaultViewDate;
						}
						attrs.$observe('defaultViewDate', function(value) {
							if (value) {
								jQuery(element).datepicker('setDate', value);
							}
						});

						if (typeof options.container === 'undefined' && jQuery(
								'.ui-container').length > 0) {
							options.container = '.ui-container';
						}
						jQuery(element)
							.attr('type', 'text')
							.datepicker(options)
							.on('show', function(e) {
								if (!e.date) {
									var inputValue = jQuery(element).val();
									if (inputValue){
										jQuery(element).datepicker('setDate', inputValue);
									}
								}
							})
							.on('changeDate', function(e) {
								saveToModel(formatDate(e.date, 'YYYY-MM-DD'));
							})
							.on('blur', function() {
								var $this = jQuery(this);
								if (!elementPreviousDate(this) && $this.val() != '') {
									elementPreviousDate(this, $this.val());
								}
								var newDate = formatDate(elementPreviousDate(this), 'YYYY-MM-DD');
								$this.val(newDate);
								saveToModel(newDate);
								if (newDate === '' && elementPreviousDate(this)) {
									jQuery(element).datepicker('setDate', newDate);
								}
							})
							.on('focus', function() {
								var inputValue = jQuery(this).val();
								elementPreviousDate(this, inputValue)
								if (inputValue !== '') {
									var newDate = formatDate(inputValue, 'YYYY-MM-DD');
									if (newDate === '') {
										jQuery(element).datepicker('setDate', new Date());
									}
									jQuery(this).val(inputValue);
								}
							})
							.on('keyup', function(e) {
								var key = parseInt(e.keyCode || e.which, 10);
								if (key !== 13) {
									var $this = jQuery(this);
									if (typeof $this.val === 'function') {
										var inputValue = $this.val();
										elementPreviousDate(this, inputValue);
										var newDate = formatDate(inputValue, 'YYYY-MM-DD');
										if (newDate === '') {
											newDate = new Date();
										}
										var startPos = $this.prop("selectionStart");
										var startEnd = $this.prop("selectionEnd");
										jQuery(element).datepicker('setDate', newDate);
										$this.val(inputValue);
										saveToModel(inputValue);
										$this.prop("selectionStart", startPos);
										$this.prop("selectionEnd", startEnd);
									}
								}
							})
							.on('keydown', function(e) {
								var key = parseInt(e.keyCode || e.which, 10);
								if ((key === 13 || key === 9) && elementPreviousDate(this)) {
									var $this = jQuery(this);
									if (typeof $this.val === 'function') {
										var newDate = formatDate(elementPreviousDate(this), 'YYYY-MM-DD');
										$this.val(newDate);
										elementPreviousDate(this, newDate);
									}
								}
							});
					} else {
						jQuery(element).attr('type', 'date');
					}
				}
			};
		}
	)
}());
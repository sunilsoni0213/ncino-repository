(function(){
	'use strict';

	angular
	.module('selfRegisterApp')
	.directive('dateInput', dateInput);

	var DIRECTIVE_NAME = 'dateInput';

	dateInput.$inject = ['helperService', 'dateFilter', 'DATE_DELIMITER'];

	function dateInput(helperService, dateFilter, DATE_DELIMITER) {
		var directive = {
			require: 'ngModel',
			restrict: 'A',
			scope: {
				dateFormat: '='
			},
			link: link
		};
		return directive;

		function link($scope, element, attrs, controller) {
			var self = this;
			var $element = jQuery(element[0]);

			$scope.datePartIndices = getDatePartIndices($scope.dateFormat);

			$element.keydown(function(event) {
				var key = event.which || event.keyCode;
				if (!isValidKeyEntry(key)) {
					// Prevent invalid chars from being typed
					event.preventDefault();
					return false;
				}
			});

			$element.keyup(function(event) {
				var key = event.which || event.keyCode;
				if (!isValidKeyEntry(key)) {
					return;
				}

				// Only if a number was entered
				if ((key >= 48 && key <= 57) || (key >= 96 && key <= 105)) {
					$(this).val(function (index, value) {
						return formatDateString(value);
					});
				}
			});

			controller.$formatters.push(function(modelValue) {
				return dateFilter(modelValue, $scope.dateFormat);
			});

			controller.$parsers.push(function(viewValue) {
				return parseDateString(viewValue);
			});

			controller.$validators.dateInput = function(modelValue, viewValue) {
				// If view value not set the front-ent will handle form validation
				if (!viewValue) {
					return true;
				}
				return parseDateString(viewValue) != null;
			};

			function isValidKeyEntry(keyCode) {
				// Allow backspace, delete, or tab
				if (keyCode == 8 || keyCode == 46 || keyCode == 9) {
					return true;
				}

				// Allow arrow keys (include 0 for silly firefox)
				if ((keyCode >= 37 && keyCode <= 40) || keyCode == 0) {
					return true;
				}

				// Allow numbers
				if (keyCode >= 48 && keyCode <= 57) {
					return true;
				}

				// Allow keypad numbers
				if (keyCode >= 96 && keyCode <= 105) {
					return true;
				}

				return false;
			}

			function formatDateString(value) {
				var date = value.replace(/\//g, '');
				var dateChars = date.toString().split('');

				if (dateChars.length >= 2) {
					dateChars.splice(2, 0, DATE_DELIMITER.SLASH);
				}

				if (dateChars.length >= 5) {
					dateChars.splice(5, 0, DATE_DELIMITER.SLASH);
				}

				return dateChars.join('');
			}

			function parseDateString(dateString) {
				if (!dateString || dateString.length < 10) {
					return null;
				}

				var parts = dateString.split(DATE_DELIMITER.SLASH);
				if (parts.length != 3) {
					return null;
				}
				var month = parseInt(parts[$scope.datePartIndices.monthIndex]);
				var day = parseInt(parts[$scope.datePartIndices.dayIndex]);
				var year = parseInt(parts[$scope.datePartIndices.yearIndex]);

				if (!helperService.isValidMonth(month)
					|| !helperService.isValidDay(year, month, day)
					|| !helperService.isValidYear(year)) {
					return null;
				}

				return new Date(year, (month - 1), day);
			}

			function getDatePartIndices(dateFormat) {
				var datePartIndices = {};
				var parts = dateFormat.split(DATE_DELIMITER.SLASH);
				for (var i = 0; i < parts.length; i++) {
					if (parts[i] == 'MM') {
						datePartIndices.monthIndex = i;
					}
					else if (parts[i] == 'dd') {
						datePartIndices.dayIndex = i;
					}
					else if(parts[i] == 'yyyy') {
						datePartIndices.yearIndex = i;
					}
				}
				return datePartIndices;
			}
		}
	}
})();
(function(){
	'use strict';

	angular
		.module('selfRegisterApp')
		.directive('numberInput', numberInput);

	var DIRECTIVE_NAME = 'numberInput';

	numberInput.$inject = ['helperService'];

	function numberInput(helperService) {
		var directive = {
			restrict: 'A',
			link: link
		};
		return directive;

		function link($scope, element, attrs, controller) {
			var self = this;
			var $element = jQuery(element[0]);
			$scope.priorValue = '';

			$element.on('input', function(event) {
				// Retain position
				var position = event.target.selectionStart;

				// Automatically format numeric value
				$(this).val(function(index, value) {
					return helperService.formatNumber(value);
				});

				// Set cursor to prior position
				if ($scope.priorValue.length == $(this).val().length - 2) {
					event.target.selectionEnd = position + 1;
				}
				else if ($scope.priorValue.length == $(this).val().length + 2) {
					event.target.selectionEnd = position - 1;
				}
				else if ($scope.priorValue.length == $(this).val().length) {
					// Do not advance the cursor if no change in length occurs
					event.target.selectionEnd = position - 1;
				}
				else {
					event.target.selectionEnd = position;
				}

				$scope.priorValue = $(this).val();
			});
		}
	}
})();
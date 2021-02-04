(function(){
	'use strict';

	angular
		.module('selfRegisterApp')
		.directive('portalDropdown', portalDropdown);

	portalDropdown.$inject = ['$document'];

	function portalDropdown($document) {
		var directive = {
			restrict: 'A',
			link: link
		};
		return directive;

		function link($scope, element, attrs) {
			var self = this;
			var $element = jQuery(element[0]);

			$element.on('click', toggleDropdown);
			function toggleDropdown() {
				$element.parent().toggleClass('slds-is-open');
			}

			var handler = function(event) {
				var outsideTarget = (element[0] !== event.target)
					&& (0 === $element.find(event.target).length);
				if (outsideTarget) {
					$element.parent().removeClass('slds-is-open');
				}
			};
			$document.on('click', handler);

			// Remove event handlers when directive is destroyed
			$scope.$on('$destroy', function() {
				$document.off('click', handler);
				$element.off('click', toggleDropdown);
			});
		}
	}
})();
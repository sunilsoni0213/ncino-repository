(function(){
	'use strict';

	angular
		.module('selfRegisterApp')
		.directive('clickOutside', clickOutside);

	var DIRECTIVE_NAME = 'clickOutside';

	clickOutside.$inject = ['$document', '$parse'];

	function clickOutside($document, $parse) {
		var directive = {
			restrict: 'A',
			link: link
		};
		return directive;

		function link($scope, element, attrs, controller) {
			var self = this;
			var $element = jQuery(element[0]);

			var clickOutsideFunction = $parse(attrs[DIRECTIVE_NAME]);
			var handler = function(event) {
				var outsideTarget = (element[0] !== event.target)
					&& (0 === $element.find(event.target).length);
				if (outsideTarget) {
					$scope.$apply(function () {
						clickOutsideFunction($scope, {});
					});
				}
			};

			$document.on('click', handler);
			$scope.$on('$destroy', function() {
				$document.off('click', handler);
			});
		}
	}
})();
(function(){
	'use strict';

	angular
		.module('selfRegisterApp')
		.directive('handleHashChange', handleHashChange);

	handleHashChange.$inject = ['$rootScope', 'NAV_EVENTS'];

	function handleHashChange($rootScope, NAV_EVENTS) {
		var directive = {
			restrict: 'E',
			scope: {},
			link: link
		};
		return directive;

		function link($scope, element, attrs, controller) {
			/* jshint validthis: true */
			var self = this;
			var $element = jQuery(element[0]);

			// Has contract with controller to handle URL hash as a string
			window.onhashchange = function() {
				$scope.$apply(function() {
					$rootScope.$broadcast(NAV_EVENTS.HASH_CHANGE, {
						hash: window.location.hash
					});
				});
			}
		}
	}
})();
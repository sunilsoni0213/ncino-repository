(function(){
	'use strict';

	angular
		.module('selfRegisterApp')
		.directive('pageInclude', pageDirective);

	// Directive has an attribute allowing it to bind to different route properties (ex. body, navigation, topbar, etc.)
	var BIND_TO = 'bindTo';

	pageDirective.$inject = ['$rootScope', 'NAV_EVENTS', 'FORM_CONSTANTS', 'helperService', 'applicationFactory'];

	function pageDirective($rootScope, NAV_EVENTS, FORM_CONSTANTS, helperService, applicationFactory) {
		var directive = {
			restrict: 'E',
			replace: true,
			link: link,
			scope: {},
			template: '<ng-include src="pageSrc"></ng-include>'
		};
		return directive;

		function link($scope, element, attrs) {
			var bindTo = attrs[BIND_TO];
			var setSrc = function ($scope) {
				$scope.pageSrc = applicationFactory.routes[applicationFactory.selectedRouteId][bindTo];
				if (applicationFactory.applicationId) {
					$scope.pageSrc = helperService.updateQueryStringParameter($scope.pageSrc, FORM_CONSTANTS.ID_PARAM,
						applicationFactory.applicationId);
				}
			};
			$rootScope.$on(NAV_EVENTS.NAV_LOAD, function(event, data) {
				// Initial full page load - render the selected Route Body
				setSrc($scope);
			});

			$rootScope.$on(NAV_EVENTS.SAVE_FORM, function(event, data) {
				// Save -> Next event
				setSrc($scope);
			});

			$rootScope.$on(NAV_EVENTS.NAVIGATE, function(event, data) {
				// Navigation option
				setSrc($scope);
			});
		}
	}
})();
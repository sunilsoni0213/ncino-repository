(function(){
	'use strict';

	angular
		.module('selfRegisterApp')
		.constant('SIZE_CONSTANTS', {
			'MIN_SCREENSIZE_BREAKPOINT': 0,
			'XSMALL_SCREENSIZE_BREAKPOINT': 320,
			'SMALL_SCREENSIZE_BREAKPOINT': 480,
			'MEDIUM_SCREENSIZE_BREAKPOINT': 768,
			'LARGE_SCREENSIZE_BREAKPOINT': 1024
		})
		.directive('resizer', ['$window', 'SIZE_CONSTANTS', function($window, SIZE_CONSTANTS) {
			return {
				restrict: 'A',
				link: function (scope, elem, attrs) {
					// Initial check when the page loads
					scope.isXSmall = ($window.innerWidth >= SIZE_CONSTANTS.MIN_SCREENSIZE_BREAKPOINT
						&& $window.innerWidth < SIZE_CONSTANTS.SMALL_SCREENSIZE_BREAKPOINT) ? true : false;
					scope.isSmall = ($window.innerWidth >= SIZE_CONSTANTS.SMALL_SCREENSIZE_BREAKPOINT
						&& $window.innerWidth < SIZE_CONSTANTS.MEDIUM_SCREENSIZE_BREAKPOINT) ? true : false;
					scope.isMedium = ($window.innerWidth >= SIZE_CONSTANTS.MEDIUM_SCREENSIZE_BREAKPOINT
						&& $window.innerWidth < SIZE_CONSTANTS.LARGE_SCREENSIZE_BREAKPOINT) ? true : false;
					scope.isLarge = $window.innerWidth >= SIZE_CONSTANTS.LARGE_SCREENSIZE_BREAKPOINT ? true : false;

					// Shorthand used to represent mobile experience vs tablet and bigger
					scope.isSmallOrBigger = $window.innerWidth >= SIZE_CONSTANTS.SMALL_SCREENSIZE_BREAKPOINT ? true : false;
					// Shorthand used to represent desktop/tablet experience vs. mobile experience.
					scope.isMediumOrBigger = $window.innerWidth >= SIZE_CONSTANTS.MEDIUM_SCREENSIZE_BREAKPOINT ? true : false;

					angular.element($window).on('resize', function() {
						scope.$apply(function() {
							// Recalculate on resize
							scope.isXSmall = ($window.innerWidth >= SIZE_CONSTANTS.MIN_SCREENSIZE_BREAKPOINT
								&& $window.innerWidth < SIZE_CONSTANTS.SMALL_SCREENSIZE_BREAKPOINT) ? true : false;
							scope.isSmall = ($window.innerWidth >= SIZE_CONSTANTS.SMALL_SCREENSIZE_BREAKPOINT
								&& $window.innerWidth < SIZE_CONSTANTS.MEDIUM_SCREENSIZE_BREAKPOINT) ? true : false;
							scope.isMedium = ($window.innerWidth >= SIZE_CONSTANTS.MEDIUM_SCREENSIZE_BREAKPOINT
								&& $window.innerWidth < SIZE_CONSTANTS.LARGE_SCREENSIZE_BREAKPOINT) ? true : false;
							scope.isLarge = $window.innerWidth >= SIZE_CONSTANTS.LARGE_SCREENSIZE_BREAKPOINT ? true : false;
							scope.isSmallOrBigger = $window.innerWidth >= SIZE_CONSTANTS.SMALL_SCREENSIZE_BREAKPOINT ? true : false;
							scope.isMediumOrBigger = $window.innerWidth >= SIZE_CONSTANTS.MEDIUM_SCREENSIZE_BREAKPOINT ? true : false;
						})
					});
				}
			}
		}]);
})();
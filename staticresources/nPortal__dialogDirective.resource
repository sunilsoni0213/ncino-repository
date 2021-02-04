(function(){
	'use strict';

	angular
		.module('selfRegisterApp')
		.directive('portalDialog', portalDialog);

	portalDialog.$inject = ['$rootScope', 'config'];

	function portalDialog($rootScope, config) {
		var directive = {
			restrict: 'E',
			replace: true,
			scope: {
				dialog: '=conf',
				cancel: '&',
				confirm: '&'
			},
			templateUrl: config.get().dialogView
		};
		return directive;
	}
})();
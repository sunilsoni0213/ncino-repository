(function(){
	'use strict';

	angular
		.module('selfRegisterApp')
		.directive('portalLoader', portalLoader);

	portalLoader.$inject = ['$rootScope', '$timeout', 'label', 'LOADER_EVENTS'];

	function portalLoader($rootScope, $timeout, label, LOADER_EVENTS) {
		var directive = {
			restrict: 'E',
			replace: true,
			link: link,
			template: '<div class="portal-loader-overlay" ng-if="loaderQueue.length > 0">' +
				'<div class="portal-loader-message">' +
				'<div class="portal-loader-icon" n-style="pso-loader-icon" style="background-image: url({{loaderIconPath}})" />' +
				'<div class="slds-text-heading--large slds-text-align--center">' +
				'{{loaderQueue[0].message}}...</div>' +
				'</div>' +
				'</div>'
		};
		return directive;

		function link($scope, element, attrs) {
			$scope.label = label.getLabels();
			$scope.loaderQueue = [];
			$scope.loaderIconPath = attrs.sldsPath + '/assets/images/spinners/slds_spinner_brand.gif';

			$rootScope.$on(LOADER_EVENTS.SHOW, function(e, args) {
				addLoader(args.id, args.message);
			});

			$rootScope.$on(LOADER_EVENTS.HIDE, function(e, args) {
				removeLoader(args.id);
			});

			function addLoader(id, msg) {
				var loader = {
					id: id,
					message: msg || $scope.label.Loading_Default_Message
				};
				$scope.loaderQueue.push(loader);
				// timeout after 15 seconds
				setTimeout(function() {
					removeLoader(id);
				}, 15000);
			}

			function removeLoader(id) {
				if ($scope.loaderQueue && id) {
					for (var i = 0; i < $scope.loaderQueue.length; i++) {
						var loader = $scope.loaderQueue[i];
						if (loader.id == id) {
							$scope.loaderQueue.splice(i, 1);
							break;
						}
					}
				}
			}
		}
	}
})();
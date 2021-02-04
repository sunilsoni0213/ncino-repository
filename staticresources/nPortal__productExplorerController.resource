angular.module('selfRegisterApp')
	.controller('ProductExplorerController', ['$scope', 'dashboardDataService', 'helperService', '$sce',
		function($scope, dashboardDataService, helperService, $sce) {

			var vm = this;
			vm.products = null;

			vm.init = init;
			vm.getProducts = getProducts;
			vm.toTrusted = toTrusted;
			vm.showLoader = showLoader;

			vm.init();

			function init() {
				vm.getProducts();
			}

			function getProducts() {
				dashboardDataService.getProducts().then(function(response) {
					vm.products = JSON.parse(response);
				});
			}

			function toTrusted(html) {
				return $sce.trustAsHtml(html);
			}

			function showLoader(loadingMessage) {
				helperService.showLoader(loadingMessage);
			}
		}]);
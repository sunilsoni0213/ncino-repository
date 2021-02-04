angular.module('selfRegisterApp')
	.controller('DashboardNavController', ['$rootScope', '$scope', 'dashboardNavService',
		'helperService', 'VF_PAGES', '$location',
		function($rootScope, $scope, dashboardNavService, helperService, VF_PAGES, $location) {
			var vm = this;
			vm.appName = '';
			vm.aid = '';
			vm.selectedRouteId = '';
			vm.isOnlineAppsEnabled = false;
			vm.routes = [];
			vm.accounts = null;
			vm.loans = null;
			vm.deposits = null;
			vm.menuVisible = false;
			vm.pages = VF_PAGES;

			vm.init = init;
			vm.loadAppName = loadAppName;
			vm.loadAid = loadAid;
			vm.retrieveRoutes = retrieveRoutes;
			vm.loadSelectedRoute = loadSelectedRoute;
			vm.getOnlineAppsEnabled = getOnlineAppsEnabled;
			vm.isSelectedPage = isSelectedPage;
			vm.getFullRouteApp = getFullRouteApp;
			vm.isSelectedProduct = isSelectedProduct;
			vm.retrieveAccounts = retrieveAccounts;
			vm.retrieveLoans = retrieveLoans;
			vm.retrieveDeposits = retrieveDeposits;

			vm.init();

			function init() {
				vm.loadAppName();
				vm.loadAid();
				vm.retrieveRoutes();
				vm.getOnlineAppsEnabled();
				vm.retrieveAccounts();
				vm.retrieveLoans();
				vm.retrieveDeposits();
			}

			function loadAppName() {
				vm.appName = helperService.getParameterByName('app');
			}

			function loadAid() {
				vm.aid = helperService.getParameterByName('aid');
			}

			function retrieveRoutes() {
				if (vm.appName) {
					dashboardNavService.retrieveRoutes(vm.appName).then(function(response) {
						if (response != null) {
							vm.routes = JSON.parse(response);
							vm.loadSelectedRoute();
						}
					});
				}
			}

			function loadSelectedRoute() {
				for (var i = 0; i < Object.keys(vm.routes).length; i++) {
					var route = vm.routes[Object.keys(vm.routes)[i]];
					if (route.app == vm.appName.split('.')[1]) {
						vm.selectedRouteId = route.sid;
						return;
					}
				}
			}

			function getOnlineAppsEnabled() {
				dashboardNavService.getOnlineAppsEnabled().then(function(response) {
					vm.isOnlineAppsEnabled = response;
				});
			}

			function isSelectedPage(routeBody) {
				// Use body of Route (VF Page) to determine page match (use Contains due to namespace differences)
				return (vm.selectedRouteId && vm.routes[vm.selectedRouteId].body &&
					vm.routes[vm.selectedRouteId].body.toUpperCase().indexOf(routeBody.toUpperCase()) !== -1);
			}

			function getFullRouteApp(routeBody) {
				// Look for a Route with a Body (VF Page) that contains the Page Name passed and return the
				// fully qualified app name (group and route app)
				for (var i = 0; i < Object.keys(vm.routes).length; i++) {
					var route = vm.routes[Object.keys(vm.routes)[i]];
					if (route.body.toUpperCase().indexOf(routeBody.toUpperCase()) !== -1) {
						return route.groupApp + '.' + route.app;
					}
				}
				return '';
			}

			function isSelectedProduct(id) {
				return (vm.aid && vm.aid == id);
			}

			function retrieveAccounts() {
				dashboardNavService.retrieveAccounts().then(function(response) {
					if (response != null) {
						vm.accounts = JSON.parse(response);
					}
				});
			}

			function retrieveLoans() {
				dashboardNavService.retrieveLoans().then(function(response) {
					if (response != null) {
						vm.loans = JSON.parse(response);
					}
				});
			}

			function retrieveDeposits() {
				dashboardNavService.retrieveDeposits().then(function(response) {
					if (response != null) {
						vm.deposits = JSON.parse(response);
					}
				});
			}
}]);
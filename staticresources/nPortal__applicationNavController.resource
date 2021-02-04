angular.module('selfRegisterApp')
	.filter('applicationNavDisplay', function() {
		return function(items, selectedRoute) {
			var filtered = [];
			for (var routeId in items) {
				if (items.hasOwnProperty(routeId)) {
					var route = items[routeId];
					// Show all top level routes,
					// and all in the same route family (looking at grandparent if grandchild route and parent if not)
					if (!route.parentRouteId ||
						(selectedRoute.grandparentRouteId && route.parentRouteId == selectedRoute.grandparentRouteId) ||
						(!selectedRoute.grandparentRouteId && route.parentRouteId == selectedRoute.parentRouteId)){
						filtered.push(items[routeId]);
					}
				}
			}
			return filtered;
		};
	})
	.controller('ApplicationNavController', ['$rootScope', '$scope', 'applicationNavService',
		'helperService', 'NAV_EVENTS', 'VF_PAGES', 'applicationFactory', '$location',
		function($rootScope, $scope, applicationNavService, helperService, NAV_EVENTS, VF_PAGES, applicationFactory,
			$location) {

		var vm = this;
		vm.applicationId = '';
		vm.selectedRouteId = '';
		vm.routes = {};
		vm.routesLength = 0;
		vm.appName = '';
		vm.pageHeader = '';
		vm.percentComplete = 0;
		vm.furthestRouteAppName = '';
		vm.artifactId = '';

		vm.init = init;
		vm.getId = getId;
		vm.loadAppName = loadAppName;
		vm.handleSaveEvent = handleSaveEvent;
		vm.navigate = navigate;
		vm.getPageHeader = getPageHeader;
		vm.getPercentComplete = getPercentComplete;
		vm.getArtifactId = getArtifactId;
		vm.handleNavLoad = handleNavLoad;
		vm.handleEditReview = handleEditReview;
		vm.handleHashChange = handleHashChange;
		vm.getSelectedRouteIndex = getSelectedRouteIndex;

		vm.init();

		$scope.$on(NAV_EVENTS.NAV_LOAD, vm.handleNavLoad);
		if (applicationFactory.routes) {
			// Routes were loaded before this controller initialized
			vm.handleNavLoad();
		}
		$scope.$on(NAV_EVENTS.SAVE_FORM, vm.handleSaveEvent);
		$scope.$on(NAV_EVENTS.EDIT_REVIEW, vm.handleEditReview);
		$scope.$on(NAV_EVENTS.HASH_CHANGE, vm.handleHashChange);

		function init() {
			vm.getId();
			vm.loadAppName();
			vm.getPageHeader();
			vm.getPercentComplete();
		}

		function getId() {
			vm.applicationId = helperService.getParameterByName('id');
		}

		function loadAppName() {
			vm.appName = helperService.getAppName();
		}

		function getPageHeader() {
			if (vm.appName) {
				applicationNavService.getTopbarText(vm.applicationId).then(function(response) {
					if (response != null) {
						vm.pageHeader = response;
					}
				});
			}
		}

		function getPercentComplete() {
			if (vm.appName && vm.applicationId) {
				applicationNavService.getPercentComplete(vm.appName, vm.applicationId).then(function(response) {
					if (response != null) {
						vm.percentComplete = response;
					}
				});
			}
		}

		function handleNavLoad(event, data) {
			// Navigation options have been loaded in the factory
			vm.routes = applicationFactory.routes;
			vm.routesLength = Object.keys(vm.routes).length;
			vm.selectedRouteId = applicationFactory.selectedRouteId;
		}

		function handleSaveEvent(event, data) {
			vm.selectedRouteId = applicationFactory.selectedRouteId;
			// Update percent complete
			vm.getPercentComplete();

			// Did the user move on to a new route family?
			if (!applicationFactory.routes[applicationFactory.selectedRouteId].parentRouteId) {
				// Refresh the menu options
				applicationFactory.init();
			}
		}

		function handleEditReview(event, data) {
			// Navigate to the selected review item
			vm.navigate(data.appName);
		}

		function handleHashChange(event, data) {
			// Navigate to the location specified in the URL
			if (data.hash && data.hash.split('.').length == 2) {
				vm.navigate(data.hash.split('.')[1]);
			}
			else {
				console.log('Invalid route specified in URL.');
			}
		}

		function navigate(appName) {
			var route = applicationFactory.validateRouteSelection(appName);
			applicationFactory.selectedRouteId = route.sid;
			vm.selectedRouteId = route.sid;
			$location.path(applicationFactory.buildAppName(route.app));
			$rootScope.$broadcast(NAV_EVENTS.NAVIGATE, applicationFactory.routes);
		}

		function getArtifactId() {
			vm.artifactId = helperService.getParameterByName('aid');
		}

		function getSelectedRouteIndex() {
			// Return the route order of the selected route or the parent if it is a grandchild
			var index = 0;
			var selectedRoute = vm.routes[vm.selectedRouteId];
			if (selectedRoute.grandparentRouteId) {
				index = vm.routes[selectedRoute.parentRouteId].routeOrder;
			}
			else {
				index = selectedRoute.routeOrder;
			}
			return index;
		}
}]);
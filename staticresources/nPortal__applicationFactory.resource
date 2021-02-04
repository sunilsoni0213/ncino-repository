angular.module('selfRegisterApp')
	.factory('applicationFactory', ['$rootScope', 'applicationNavService', 'helperService', 'NAV_EVENTS',
		'$location',
		function($rootScope, applicationNavService, helperService, NAV_EVENTS, $location) {
			var svc = this;

			svc.routes = {};
			svc.selectedRouteId = '';
			svc.furthestRouteAppName = '';

			svc.init = init;
			svc.getId = getId;
			svc.loadAppName = loadAppName;
			svc.retrieveMenu = retrieveMenu;
			svc.loadSelectedRoute = loadSelectedRoute;
			svc.validateRouteSelection = validateRouteSelection;
			svc.getProgenyRoute = getProgenyRoute;
			svc.getAncestorRoute = getAncestorRoute;
			svc.handleSaveEvent = handleSaveEvent;
			svc.buildAppName = buildAppName;
			svc.getRouteByAppName = getRouteByAppName;
			svc.loadNextRoute = loadNextRoute;
			svc.getNextRouteInList = getNextRouteInList;
			svc.getNextRouteFamily = getNextRouteFamily;

			svc.init();

			function init() {
				svc.getId();
				svc.loadAppName();
				svc.retrieveMenu();
			}

			function getId() {
				svc.applicationId = helperService.getParameterByName('id');
			}

			function loadAppName() {
				svc.appName = helperService.getAppName();
			}

			function retrieveMenu() {
				if (svc.applicationId) {
					applicationNavService.getFurthestRoute(svc.applicationId).then(function(response) {
						if (response != null) {
							svc.furthestRouteAppName = response;
							applicationNavService.retrieveMenu(svc.appName || svc.furthestRouteAppName).then(function(response) {
								if (response != null) {
									// Fire event to inform module that navigation options are loaded
									svc.routes = JSON.parse(response);
									svc.loadSelectedRoute();
									$rootScope.$broadcast(NAV_EVENTS.NAV_LOAD, svc.routes);
								}
							});
						}
					});
				}
			}

			function loadSelectedRoute() {
				// Load the first route when none has been visited
				if (!svc.furthestRouteAppName) {
					// Load the first child route if one is available
					if (Object.keys(svc.routes).length > 0) {
						var routeId = Object.keys(svc.routes)[0];
						var route = svc.getProgenyRoute(svc.routes[routeId]) || svc.routes[routeId];
						svc.selectedRouteId = route.sid;
						svc.appName = route.groupApp + '.' + route.app;
						$location.path(svc.appName);
						return;
					}
				}

				if (!svc.appName) {
					// Load where the user left off if location is not specified
					svc.appName = svc.furthestRouteAppName;
				}

				// If a route was specified in the URL, navigate to it
				var route = svc.validateRouteSelection(svc.appName.split('.')[1]);
				svc.selectedRouteId = route.sid;
				svc.appName = svc.buildAppName(route.app);
				$location.path(svc.appName);
			}

			function validateRouteSelection(appName) {
				// Determine if the user should be taken to this route
				var selectedRoute = svc.getRouteByAppName(appName);
				var furthestRoute = svc.getRouteByAppName(svc.furthestRouteAppName.split('.')[1]);
				if (selectedRoute.routeOrder > furthestRoute.routeOrder) {
					// Do not allow the user to skip ahead, but go to the child route if it exists
					return svc.getProgenyRoute(furthestRoute) || furthestRoute;
				}
				else if (svc.getAncestorRoute(selectedRoute) != svc.getAncestorRoute(furthestRoute)) {
					// Do not allow the user to navigate to a different route family
					return svc.getProgenyRoute(furthestRoute) || furthestRoute;
				}
				else {
					// If the selected route has children go to the first child
					return svc.getProgenyRoute(selectedRoute) || selectedRoute;
				}
			}

			function getProgenyRoute(route) {
				// Check for child routes at 2 levels
				if (route.childRoutes == null || route.childRoutes.length == 0) {
					return null;
				}
				else {
					var childRoute = svc.routes[route.childRoutes[0]];
					if (childRoute.childRoutes == null || childRoute.childRoutes.length == 0) {
						return childRoute;
					}
					else {
						return svc.routes[childRoute.childRoutes[0]];
					}
				}
			}

			function getAncestorRoute(route) {
				// Check for parent routes at 2 levels
				if (route.parentRouteId == null) {
					return null;
				}
				else {
					var parentRoute = svc.routes[route.parentRouteId];
					if (parentRoute.parentRouteId == null) {
						return parentRoute;
					}
					else {
						return svc.routes[parentRoute.parentRouteId];
					}
				}
			}

			function handleSaveEvent(data, ignoreFurthest, nextRouteFamily) {
				var furthestRoute = svc.getRouteByAppName(svc.furthestRouteAppName.split('.')[1]);

				// Load the next valid route, otherwise the current route will be loaded again
				var nextRoute;
				if (!nextRouteFamily) {
					// Get next route, excluding the furthest if noFurthest is true
					nextRoute = svc.loadNextRoute(svc.selectedRouteId, !ignoreFurthest);
				}
				else {
					// Go to the next route family, or go to the furthest route
					nextRoute = svc.getNextRouteFamily(svc.selectedRouteId);
					if (!ignoreFurthest && nextRoute.routeOrder < furthestRoute.routeOrder) {
						nextRoute = furthestRoute;
					}
				}

				if (nextRoute != null) {
					svc.selectedRouteId = nextRoute.sid;
				}

				// Get route to navigate to based on selected route id in case a next route was not found
				var navigateToRoute = svc.routes[svc.selectedRouteId];
				var appName = svc.buildAppName(navigateToRoute.app);

				// Only update furthest route if going past the current furthest route
				if (navigateToRoute.routeOrder > furthestRoute.routeOrder) {
					svc.furthestRouteAppName = appName;
				}

				// Update URL parameters and refresh data
				$location.path(appName);
				// FIXME: SAVE_FORM lifecycle event is likely redundant - hash change triggers navigation event
				$rootScope.$broadcast(NAV_EVENTS.SAVE_FORM, data);
			}

			function buildAppName(routeApp) {
				return svc.appName.split('.')[0] + '.' + routeApp;
			}

			function getRouteByAppName(routeAppName) {
				for (var routeId in svc.routes) {
					if (svc.routes.hasOwnProperty(routeId)) {
						if (svc.routes[routeId].app == routeAppName) {
							return svc.routes[routeId];
						}
					}
				}
				return null;
			}

			function loadNextRoute(routeId, useFurthest) {
				var nextRoute = svc.getNextRouteInList(routeId);
				if (nextRoute != null) {
					var furthestRoute = svc.getRouteByAppName(svc.furthestRouteAppName.split('.')[1]);
					// Optionally factor in the furthest route so that it will go there instead of the next route in line
					if (useFurthest && nextRoute.routeOrder < furthestRoute.routeOrder) {
						return svc.getProgenyRoute(furthestRoute) || furthestRoute;
					}
					else {
						// Use the next route, but go to first child if there is one
						return svc.getProgenyRoute(nextRoute) || nextRoute;
					}
				}
				return null;
			}

			function getNextRouteInList(routeId) {
				var routeIds = Object.keys(svc.routes);
				for (var i = 0; i < routeIds.length; i++) {
					if (routeIds[i] == routeId) {
						if (i < routeIds.length - 1) {
							return svc.routes[routeIds[i + 1]];
						}
					}
				}
				return null;
			}

			function getNextRouteFamily(routeId) {
				var selectedRoute = svc.routes[routeId];
				// Find the next route in the list of routes that does not have the same parent
				var routeIds = Object.keys(svc.routes);
				for (var i = 0; i < routeIds.length; i++) {
					var route = svc.routes[routeIds[i]];
					if (route.routeOrder > selectedRoute.routeOrder && route.parentRouteId != selectedRoute.parentRouteId) {
						// Use this route, but go to child if exists
						return svc.getProgenyRoute(route) || route;
					}
				}
				return null;
			}

			return svc;
		}]);
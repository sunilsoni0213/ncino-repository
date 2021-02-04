angular.module('selfRegisterApp')
	.controller('TileController', ['$rootScope', '$scope', 'tileDataService', '$sce',
		'helperService', 'DYNAMIC_RENDER', 'SOBJ_TYPES', 'NAV_EVENTS',
		function($rootScope, $scope, tileDataService, $sce, helperService, DYNAMIC_RENDER, SOBJ_TYPES,
			NAV_EVENTS) {

		var vm = this;
		vm.applicationId = '';
		vm.routeId = '';
		vm.appName = '';
		vm.tiles = null;
		vm.iconBasePath = '';
		vm.isLoanAidContext = false;

		vm.init = init;
		vm.getId = getId;
		vm.loadAppName = loadAppName;
		vm.getIsLoanAidContext = getIsLoanAidContext;
		vm.retrieveRouteId = retrieveRouteId;
		vm.retrieveTiles = retrieveTiles;
		vm.toTrusted = toTrusted;
		vm.handleSaveEvent = handleSaveEvent;
		vm.handleNavigateEvent = handleNavigateEvent;

		vm.init();

		$scope.$on(NAV_EVENTS.SAVE_FORM, vm.handleSaveEvent);
		$scope.$on(NAV_EVENTS.NAVIGATE, vm.handleNavigateEvent);

		function init() {
			vm.getId();
			vm.loadAppName();
			vm.getIsLoanAidContext();
			vm.retrieveRouteId();
		}

		function getId() {
			vm.applicationId = helperService.getParameterByName('id');
		}

		function loadAppName() {
			vm.appName = helperService.getParameterByName('app');
			if (!vm.appName) {
				vm.appName = helperService.getAppName();
			}
		}

		function getIsLoanAidContext() {
			var contextId = helperService.getParameterByName('aid') || vm.applicationId;
			if (contextId) {
				tileDataService.getSObjectType(contextId).then(function(response) {
					vm.isLoanAidContext = response != null &&
						(response == SOBJ_TYPES.APPLICATION || response == SOBJ_TYPES.LOAN);
				});
			}
		}

		function retrieveRouteId() {
			if (vm.appName && vm.appName.split('.').length == 2) {
				tileDataService.retrieveRouteId(vm.appName).then(function(response) {
					if (response != null) {
						vm.routeId = response;
						vm.retrieveTiles();
					}
				});
			}
		}

		function retrieveTiles() {
			tileDataService.retrieveTiles(vm.routeId).then(function(response) {
				if (response != null) {
					vm.tiles = JSON.parse(response);
					vm.tiles.forEach(function(tile, i) {
						if (tile.body && tile.body.substring(0, 2) == DYNAMIC_RENDER.RENDER_START &&
							tile.body.substring(tile.body.length - 2, tile.body.length) == DYNAMIC_RENDER.RENDER_END) {
							tile.dynamic = true;
							var pageName = tile.body.replace(DYNAMIC_RENDER.RENDER_START, '');
							pageName = pageName.replace(DYNAMIC_RENDER.RENDER_END, '');
							tileDataService.retrievePageUrl(pageName).then(function(response) {
								vm.tiles[i].bodyUrl = response;
							});
						}
						else {
							vm.tiles[i].loaded = true;
						}
					});
				}
			});
		}

		function handleSaveEvent(event, data) {
			vm.init();
		}

		function handleNavigateEvent(event, data) {
			vm.init();
		}

		function toTrusted(html) {
			return $sce.trustAsHtml(html);
		}
}]);

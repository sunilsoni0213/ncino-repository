angular.module('selfRegisterApp')
	.controller('DocumentUploadController', ['$rootScope', '$scope', 'onlineFormsDataService',
		'helperService', 'DOC_CONSTANTS', 'NAV_EVENTS',
		function($rootScope, $scope, onlineFormsDataService, helperService, DOC_CONSTANTS, NAV_EVENTS) {

		var vm = this;
		vm.applicationId = '';
		vm.route = {
			headerText: '',
			subheaderText: '',
			portalIconPath: ''
		};
		vm.appName = '';
		vm.selectedTabIndex = 0;

		vm.init = init;
		vm.getId = getId;
		vm.loadAppName = loadAppName;
		vm.retrieveUIData = retrieveUIData;
		vm.handleURLHash = handleURLHash;

		vm.init();

		$scope.$on(NAV_EVENTS.HASH_CHANGE, vm.handleURLHash);

		function init() {
			vm.getId();
			vm.loadAppName();
			vm.retrieveUIData();
			vm.handleURLHash(null, {
				hash: window.location.hash
			});
		}

		function getId() {
			vm.applicationId = helperService.getParameterByName('id');
		}

		function loadAppName() {
			vm.appName = helperService.getAppName();
		}

		function retrieveUIData() {
			if (vm.appName && vm.appName.split('.').length == 2) {
				onlineFormsDataService.retrieveUIData(vm.appName, vm.applicationId).then(function(response) {
					if (response != null) {
						vm.route = JSON.parse(response);
					}
				});
			}
		}

		function handleURLHash(event, data) {
			if (!data || !data.hash) {
				return;
			}
			if (data.hash.indexOf(DOC_CONSTANTS.TO_DO_HASH) !== -1) {
				vm.selectedTabIndex = 0;
			}
			else if (data.hash.indexOf(DOC_CONSTANTS.REVIEW_HASH) !== -1) {
				vm.selectedTabIndex = 1;
			}
			else if (data.hash.indexOf(DOC_CONSTANTS.APPROVED_HASH) !== -1) {
				vm.selectedTabIndex = 2;
			}
		}
}]);

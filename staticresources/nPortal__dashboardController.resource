angular.module('selfRegisterApp')
	.controller('DashboardController', ['$scope', 'dashboardDataService', 'helperService',
		function($scope, dashboardDataService, helperService) {

		var vm = this;
		vm.applications = null;
		vm.application = {};
		vm.documents = null;
		vm.documentsApp = '';
		vm.isOnlineApplicationEnabled = false;

		vm.init = init;
		vm.getApplications = getApplications;
		vm.getDocuments = getDocuments;
		vm.getDocumentsApp = getDocumentsApp;
		vm.getIsOnlineApplicationEnabled = getIsOnlineApplicationEnabled;

		vm.init();

		function init() {
			vm.getDocumentsApp();
			vm.getIsOnlineApplicationEnabled();
			vm.getDocuments();
		}

		function getApplications() {
			dashboardDataService.getApplications().then(function(response) {
				vm.applications = response;
			});
		}

		function getDocuments() {
			dashboardDataService.getDocuments().then(function(response) {
				vm.documents = JSON.parse(response);
			});
		}

		function getDocumentsApp() {
			dashboardDataService.getDocumentsApp().then(function(response) {
				vm.documentsApp = response;
			});
		}

		function getIsOnlineApplicationEnabled() {
			dashboardDataService.getIsOnlineApplicationEnabled().then(function(response) {
				vm.isOnlineApplicationEnabled = response;
				if (vm.isOnlineApplicationEnabled) {
					// Only retrieve applications if OA is enabled
					vm.getApplications();
				}
			});
		}
}]);
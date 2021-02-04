angular.module('selfRegisterApp')
	.controller('SecurityBadgeController', ['$scope', 'securityBadgesService',
		function($scope, securityBadgesService) {

		var vm = this;
		vm.securityBadges = [];
		vm.imageServerURL = '';

		vm.init = init;
		vm.retrieveSecurityBadges = retrieveSecurityBadges;
		vm.retrieveImageServerURL = retrieveImageServerURL;

		vm.init();

		function init() {
			vm.retrieveSecurityBadges();
			vm.retrieveImageServerURL();
		}

		function retrieveSecurityBadges() {
			securityBadgesService.retrieveSecurityBadges().then(function(response) {
				if (response != null) {
					vm.securityBadges = JSON.parse(response);
				}
			});
		}

		function retrieveImageServerURL() {
			securityBadgesService.retrieveImageServerURL().then(function(response) {
				if (response != null) {
					vm.imageServerURL = response;
				}
			});
		}
}]);
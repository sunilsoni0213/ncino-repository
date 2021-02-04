angular.module('selfRegisterApp')
	.controller('FundingController', ['$rootScope', '$scope', 'label', 'fundingDataService', 'helperService',
		function($rootScope, $scope, label, fundingDataService, helperService) {

		var vm = this;
		vm.label = label.getLabels();
		vm.applicationId = '';
		vm.appName = '';
		vm.productId = null;
		vm.showFundingPanel = false;
		vm.initialFundingAmount = '';
		vm.fundingMethodTypes = [];
		vm.isScreenSectionLoaded = false;
		vm.fundingMethodScreenSection = null;
		vm.selectedMethodType = '';
		vm.isFundingCollected = false;
		vm.isFundingEnabled = false;

		vm.init = init;
		vm.getId = getId;
		vm.loadUrlParameters = loadUrlParameters;
		vm.getIsFundingEnabled = getIsFundingEnabled;
		vm.getIsFundingCollected = getIsFundingCollected;
		vm.getFundingMethodTypes = getFundingMethodTypes;
		vm.selectFundingMethodType = selectFundingMethodType;
		vm.resetFundingMethodType = resetFundingMethodType;
		vm.saveFundingMethod = saveFundingMethod;
		vm.cancelFunding = cancelFunding;

		vm.init();

		function init() {
			vm.getId();
			vm.loadUrlParameters();
			vm.getIsFundingEnabled();
			vm.getIsFundingCollected();
			vm.getFundingMethodTypes();
		}

		function getId() {
			vm.applicationId = helperService.getParameterByName('id');
		}

		function loadUrlParameters() {
			vm.appName = helperService.getAppName();
			vm.productId = helperService.getParameterByName('productId');
		}

		function getIsFundingEnabled() {
			fundingDataService.isFundingEnabled().then(function(response) {
				vm.isFundingEnabled = response;
			});
		}

		function getIsFundingCollected() {
			if (vm.applicationId) {
				fundingDataService.isFundingCollected(vm.applicationId).then(function(response) {
					if (response.type && response.type === 'exception') {
						console.log('An error occurred getting funding status.');
					}
					else {
						vm.isFundingCollected = response;
					}
				});
			}
		}

		function getFundingMethodTypes() {
			fundingDataService.getFundingMethodTypes().then(function(response) {
				if (response != null) {
					vm.fundingMethodTypes = JSON.parse(response);
				}
			});
		}

		function selectFundingMethodType(typeId, sectionId) {
			vm.resetFundingMethodType();
			vm.selectedMethodType = typeId;
			if (vm.applicationId) {
				fundingDataService.getFundingMethodTypeScreenSection(vm.appName, sectionId).then(function(response) {
					if (response != null) {
						vm.isScreenSectionLoaded = true;
						vm.fundingMethodScreenSection = JSON.parse(response);
					}
				});
			}
		}

		function resetFundingMethodType() {
			vm.selectedMethodType = '';
			vm.isScreenSectionLoaded = false;
			vm.fundingMethodScreenSection = null;
		}

		function saveFundingMethod() {
			if (vm.selectedMethodType && vm.applicationId) {
				var loaderID = helperService.showLoader(vm.label.Funding_Save_Message);
				fundingDataService.saveFundingMethod(vm.applicationId, vm.selectedMethodType, vm.initialFundingAmount).then(function(response) {
					if (response != null) {
						vm.isFundingCollected = true;
						vm.showFundingPanel = false;
					}
					helperService.hideLoader(loaderID);
				});
			}
		}

		function cancelFunding() {
			vm.resetFundingMethodType();
			vm.initialFundingAmount = '';
			vm.showFundingPanel = false;
		}
}]);
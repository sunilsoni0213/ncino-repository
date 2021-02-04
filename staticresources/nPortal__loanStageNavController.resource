angular.module('selfRegisterApp')
	.controller('loanStageNavController', ['$scope', 'loanStageNavService',
		'helperService', 'VF_PAGES',
		function($scope, loanStageNavService, helperService, VF_PAGES) {

		var vm = this;
		vm.applicationId = '';
		vm.appName = '';
		vm.artifactId = '';
		vm.loanInfo;
		vm.externalStages = [];
		vm.currentStageIndex = -1;

		vm.init = init;
		vm.getId = getId;
		vm.loadAppName = loadAppName;
		vm.getArtifactId = getArtifactId;
		vm.getLoanInfo = getLoanInfo;
		vm.loadExternalStages = loadExternalStages;

		vm.init();

		function init() {
			vm.getId();
			vm.loadAppName();
			vm.getArtifactId();
			vm.getLoanInfo();
		}

		function getId() {
			vm.applicationId = helperService.getParameterByName('id');
		}

		function loadAppName() {
			vm.appName = helperService.getParameterByName('app');
		}

		function getArtifactId() {
			vm.artifactId = helperService.getParameterByName('aid');
		}

		function getLoanInfo() {
			if (vm.artifactId) {
				loanStageNavService.getLoanInfo(vm.artifactId).then(function(response) {
					if (response != null) {
						vm.loanInfo = JSON.parse(response);
						loadExternalStages();
					}
				});
			}
		}

		function loadExternalStages() {
			if (vm.loanInfo) {
				loanStageNavService.loadExternalStages(vm.loanInfo.LLC_BI__Stage__c || '', vm.loanInfo.LLC_BI__Status__c || '',
					vm.loanInfo.LLC_BI__Product_Reference__r.LLC_BI__Product_Type__c).then(function(response) {
					if (response != null) {
						vm.externalStages = JSON.parse(response);
						setCurrentStageIndex();
					}
				});
			}
		}

		function setCurrentStageIndex() {
			for (var i = 0; i < vm.externalStages.length; i++) {
				if (vm.externalStages[i].isCurrentStage) {
					vm.currentStageIndex = i;
					break;
				}
			}

			if (vm.currentStageIndex == -1) {
				console.log('Could not find current external stage index.');
			}
		}
}]);
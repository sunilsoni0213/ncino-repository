angular.module('treasuryConversionApp')
	.controller('treasuryConversionController', ['$scope', 'dataService', 'messageService',
		function($scope, dataService, messageService) {

		var vm = this;
		vm.treasuryServices = [];
		vm.init = init;
		vm.accountId;
		vm.isComplete = null;
		vm.init();

		function init() {
			dataService.getConvertedTreasuryServices().then(
				function(response, event){
					if (response === "noProducts") {
						vm.isComplete = false;
					}
					else {
						vm.treasuryServices = angular.fromJson(response);
						if (vm.treasuryServices.length > 0) {
							vm.accountId = vm.treasuryServices[0].accountId;
							vm.isComplete = true;
						}
						else {
							vm.isComplete = false;
						}
					}
				},
				function(error){
					vm.isComplete = false;
					messageService.setMessage({ type: messageService.messageTypes.error, text: error }, true);
				}
			);
		};
}]);

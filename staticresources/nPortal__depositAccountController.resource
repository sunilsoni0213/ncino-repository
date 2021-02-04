angular.module('selfRegisterApp')
	.controller('DepositAccountController', ['$scope', 'label', 'onlineFormsDataService', 'helperService', 'SOBJ_TYPES',
		function($scope, label, onlineFormsDataService, helperService, SOBJ_TYPES) {
		var vm = this;
		vm.label = label.getLabels();
		vm.applicationId = '';
		vm.fields = [];

		vm.init = init;
		vm.getId = getId;
		vm.retrieveProductSummaryFields = retrieveProductSummaryFields;

		vm.init();

		function init() {
			vm.getId();
			vm.retrieveProductSummaryFields();
		}

		function getId() {
			vm.applicationId = helperService.getParameterByName('id');
		}

		function retrieveProductSummaryFields() {
			onlineFormsDataService.retrieveProductSummaryFields(vm.applicationId).then(function(response) {
				if (response.type && response.type === 'exception') {
					helperService.showMessage(vm.label.Portal_Error_Retrieve_Summary_Fieldset,
						MESSAGE_CONSTANTS.TYPE_ERROR);
				}
				else {
					// Get intelligent field formatting
					var fieldSet = {
						sObjectType: SOBJ_TYPES.ACCOUNT,
						fields: response
					};
					vm.fields = helperService.applyFieldFormatting(fieldSet);
				}
			});
		}
}]);
angular.module('selfRegisterApp')
	.controller('ApplicationTopbarController', ['$scope', 'applicationTopbarService', 'onlineFormsDataService',
		'helperService', 'NAV_EVENTS', 'SOBJ_TYPES',
		function($scope, applicationTopbarService, onlineFormsDataService, helperService, NAV_EVENTS, SOBJ_TYPES) {

		var vm = this;
		vm.namespacePrefix = '';
		vm.fields = [];
		vm.applicationId = '';
		vm.fieldSetName = '';

		vm.init = init;
		vm.getId = getId;
		vm.getNamespacePrefix = getNamespacePrefix;
		vm.getFields = getFields;
		vm.convertToLongDate = convertToLongDate;
		vm.handleSaveEvent = handleSaveEvent;
		vm.handleNavigateEvent = handleNavigateEvent;
		vm.getCurrencySymbol = getCurrencySymbol;
		vm.getDateFormat = getDateFormat;
		vm.filterDate = filterDate
		vm.filterDatetime = filterDatetime;

		vm.init();

		$scope.$on(NAV_EVENTS.SAVE_FORM, vm.handleSaveEvent);
		$scope.$on(NAV_EVENTS.NAVIGATE, vm.handleNavigateEvent);

		function init() {
			vm.getId();
			vm.getCurrencySymbol();
			vm.getDateFormat();
			vm.getNamespacePrefix();
		}

		function getId() {
			vm.applicationId = helperService.getParameterByName('id');
		}

		function getNamespacePrefix() {
			applicationTopbarService.getNamespacePrefix().then(function(response) {
				vm.namespacePrefix = response;
				vm.getFields(vm.applicationId, vm.fieldSetName);
			});
		}

		function getFields() {
			if (vm.applicationId) {
				applicationTopbarService.getArtifactFields(vm.applicationId).then(function(response) {
					if (response != null) {
						// Get intelligent field formatting
						var fieldSet = {
							sObjectType: SOBJ_TYPES.ACCOUNT,
							fields: response
						};
						vm.fields = helperService.applyFieldFormatting(fieldSet);
					}
				});
			}
		}

		function getCurrencySymbol() {
			onlineFormsDataService.getCurrencySymbol().then(function(response) {
				vm.currencySymbol = response;
			});
		}

		function getDateFormat() {
			onlineFormsDataService.getDateFormat().then(function(response) {
				vm.dateFormat = response;
			});
		}

		function filterDate(dateString, format) {
			return helperService.filterDate(dateString, format);
		}

		function filterDatetime(dateString, format) {
			return helperService.filterDatetime(dateString, format);
		}

		function convertToLongDate(dateString) {
			return helperService.convertToLongDate(dateString);
		}

		function handleSaveEvent(event, data) {
			vm.init();
		}

		function handleNavigateEvent(event, data) {
			vm.init();
		}
}]);
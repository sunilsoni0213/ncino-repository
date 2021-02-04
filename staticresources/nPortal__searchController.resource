angular.module('selfRegisterApp')
	.controller('SearchController', ['$rootScope', '$scope', 'label', 'searchDataService', 'helperService',
		'NAV_EVENTS', 'applicationFactory', '$location', 'onlineFormsDataService',
		function($rootScope, $scope, label, searchDataService, helperService, NAV_EVENTS, applicationFactory,
			$location, onlineFormsDataService) {
			var vm = this;
			vm.label = label.getLabels();
			vm.applicationId = '';
			vm.appName = '';
			vm.searchSelectText = '';
			vm.searchSelectActiveText = '';
			vm.results = [];
			vm.defaultSelectText = vm.label.Select_Button;
			vm.previouslySelectedResultId = null;

			vm.init = init;
			vm.loadUrlParameters = loadUrlParameters;
			vm.retrieveSearchResults = retrieveSearchResults;
			vm.selectSearchResult = selectSearchResult;
			vm.retrieveSearchSelectText = retrieveSearchSelectText;
			vm.retrieveSearchSelectActiveText = retrieveSearchSelectActiveText;
			vm.getIdOfPreviouslySelectedResult = getIdOfPreviouslySelectedResult;

			vm.init();

			function init() {
				vm.loadUrlParameters();
				vm.retrieveSearchSelectText();
				vm.retrieveSearchSelectActiveText();
				vm.getIdOfPreviouslySelectedResult();
				vm.retrieveSearchResults();
			}

			function loadUrlParameters() {
				vm.applicationId = helperService.getParameterByName('id');
				vm.appName = helperService.getAppName();
			}

			function retrieveSearchSelectText() {
				searchDataService.retrieveSearchSelectText(vm.appName).then(function(response) {
					if (response && response.type && response.type === 'exception') {
						console.log('An error occurred retrieving search select text.');
					}
					else {
						vm.searchSelectText = response;
					}
				});
			}

			function retrieveSearchSelectActiveText() {
				searchDataService.retrieveSearchSelectActiveText(vm.appName).then(function(response) {
					if (response && response.type && response.type === 'exception') {
						console.log('An error occurred retrieving search select active text.');
					}
					else {
						vm.searchSelectActiveText = response;
					}
				});
			}

			function retrieveSearchResults() {
				var loaderID = helperService.showLoader();
				searchDataService.retrieveSearchResults(vm.applicationId, vm.appName).then(function(response) {
					helperService.hideLoader(loaderID);
					if (response.type && response.type === 'exception') {
						helperService.showMessage(vm.label.Portal_Error_Retrieve_Search_Results,
							MESSAGE_CONSTANTS.TYPE_ERROR);
					}
					else {
						if (response.length == 0) {
							// No results found, forward to next route
							var nextRoute = applicationFactory.loadNextRoute(applicationFactory.selectedRouteId, false);
							applicationFactory.selectedRouteId = nextRoute.sid;
							applicationFactory.furthestRouteAppName = applicationFactory.buildAppName(nextRoute.app);
							$location.path(applicationFactory.buildAppName(nextRoute.app));
							$rootScope.$broadcast(NAV_EVENTS.NAVIGATE, applicationFactory.routes);
						}
						else {
							// Process results to format address fields
							for (var i = 0; i < response.length; i++) {
								var fieldSet = response[i];
								fieldSet.fields = helperService.applyFieldFormatting(fieldSet);
							}
							vm.results = response;
						}
					}
				});
			}

			function selectSearchResult(selectedResultId, isEdit) {
				var loaderID = helperService.showLoader();
				searchDataService.selectSearchResult(vm.applicationId, vm.appName, selectedResultId).then(function(response) {
					if (response.type && response.type === 'exception') {
						helperService.hideLoader(loaderID);
						helperService.showMessage(vm.label.Portal_Error_Select_Search_Result,
							MESSAGE_CONSTANTS.TYPE_ERROR);
					}
					else {
						// If an item is selected or Edit is selected for a different item than the currently selected
						// business, reset session progress in the UI to force user through the workflow again
						if (selectedResultId != '' && (!isEdit ||
							vm.previouslySelectedResultId && vm.previouslySelectedResultId != selectedResultId)) {
							// Item selected call save and load next route family
							// When a new item is selected, the user should have to complete all subsequent steps
							applicationFactory.handleSaveEvent(JSON.parse(response), true, !isEdit);
							applicationFactory.loadAppName();
							applicationFactory.furthestRouteAppName = applicationFactory.appName;
							onlineFormsDataService.updateApplicationNavigation(
								vm.applicationId,
								applicationFactory.routes[applicationFactory.selectedRouteId].routeGroupId
							);
						}
						else {
							// No item selected or edit selected for the same item, load the next route
							applicationFactory.handleSaveEvent(JSON.parse(response), true, false);
						}
						helperService.hideLoader(loaderID);
					}
				});
			}

			function getIdOfPreviouslySelectedResult() {
				searchDataService.getIdOfPreviouslySelectedResult(vm.applicationId, vm.appName).then(function(response) {
					vm.previouslySelectedResultId = response;
				});
			}
}]);
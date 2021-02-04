angular.module('app')
	.controller('loanAutoDecisionRunController', ['$scope', 'dataService', '$window', 'messageService', 'navigator',
		function($scope, dataService, $window, messageService, navigator) {
			"use strict";
			var vm = this;
			vm.window = $window;
			vm.error = null;
			vm.loanId = null;
			vm.processComplete = false;
			vm.isRedirecting = false;
			vm.scorecardId = null;
			vm.currentRetryCount = 0;
			vm.currentProcess;
			vm.statuses = [
				'Starting Process',
				'Validating Data',
				'Analyzing Data'
			]

			vm.generateDecision = generateDecision;
			vm.displayNextStage = displayNextStage;
			vm.processDecisionResult = processDecisionResult;
			vm.redirectToScorecardDetail = redirectToScorecardDetail;
			vm.displayNextStage();

			function errorHandler(error) {
				vm.error = error;
				messageService.setMessage({type: messageService.messageTypes.error, text: vm.error }, true);
			}

			function processDecisionResult(response) {
				if (response == undefined || isNaN(response.retryInterval) || isNaN(response.maximumRetries)) {
					errorHandler('Invalid response received.');
				}
				else {
					if (response.scorecardId != null || response.status != 'Information Request Initiated') {
						vm.scorecardId = response.scorecardId;
						vm.statuses.push('Generating Scorecard');
						vm.statuses.push('Process Complete');
						vm.processComplete = true;
					}
					else {
						if (response.statusInformation != vm.currentProcess) {
							vm.currentRetryCount = 0;
						}
						if (vm.currentRetryCount <= response.maximumRetries) {
							vm.currentProcess = response.statusInformation;
							vm.statuses.push('Retrieving Data - ' + vm.currentProcess);
							setTimeout(generateDecision, response.retryInterval * 1000, vm.loanId);
							vm.currentRetryCount++;
						}
						else {
							errorHandler(
								'It look longer than expected to retrieve data that is required for the decision process. ' +
								'The  "' + vm.currentProcess +'" was requested and not received. Manually retrieve ' +
								'the data and/or retry the Auto-Decision process.');
						}
					}
				}
			}

			function redirectToScorecardDetail(scorecardDetailRouteAppName) {
				vm.isRedirecting = true;
				var group = 'loan';

				if(getAppURLParameterValue() != null) {
					group = getAppURLParameterValue();
					group = group.substring(0, group.indexOf('.'));
				}

				var href =
					vm.window.location.origin +
					vm.window.location.pathname +
					'?app=' + group + '.' + scorecardDetailRouteAppName +
					'&id='+vm.loanId +
					'&scorecardId='+vm.scorecardId;

				if (vm.window.location.search != undefined &&
					vm.window.location.search != null) {
					
					if(vm.window.location.search.indexOf('inline=1') > 0) {
						href += '&inline=1';
					}

					if(vm.window.location.search.indexOf('sid=') > 0){
						var sid = vm.window.location.search.split('sid=')[1].split('&')[0]
						href += '&sid=' + sid;
					}
				}

				navigator.navigateToRoute(href);
			}

			function getAppURLParameterValue() {
				var result;
				if(vm.window.location.search !== undefined && vm.window.location.search !== null) {
					result =  vm.window.location.search.match(
						new RegExp("(\\?|&)app(\\[\\])?=([^&]*)")
					);
				}
				return result ? result[3] : null;
		   }

			function displayNextStage() {
				if (vm.statuses.length > 0) {
					vm.status = vm.statuses[0];
					vm.statuses.splice(0, 1);
					$scope.$applyAsync();
				}
				else if (vm.processComplete) {
					dataService.getScorecardDetailRouteAppName(getAppURLParameterValue()).then(
						vm.redirectToScorecardDetail,
						errorHandler);
				}
				if (vm.error == null && !vm.isRedirecting) {
					setTimeout(displayNextStage, 1000);
				}
			}

			function generateDecision(loanId) {
				vm.processComplete = false;
				vm.loanId = loanId;
				dataService.generateDecision(loanId).then(
					vm.processDecisionResult,
					errorHandler);
			}
}]);
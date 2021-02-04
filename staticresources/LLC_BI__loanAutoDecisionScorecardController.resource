angular.module('app')
	.constant('loanAutoDecisionConstants', {
		ADVERSE_ACTION: 'adverse_action',
		APPROVED: 'Approved',
		BORROWER_ACCOUNT: 'Borrower Account',
		DECLINED: 'Declined',
		MANUAL_APPROVAL: 'manual_approval',
		RECOMMEND_APPROVAL: 'Recommend Approval',
		RECOMMEND_DECLINE: 'Recommend Decline',
		RESULT: 'Result',
		TAB_TYPE: 'loan'
	})
	.controller('loanAutoDecisionScorecardController', ['$scope', 'dataService', '$window', 'loanAutoDecisionConstants', 'messageService',
		function($scope, dataService, $window, loanAutoDecisionConstants, messageService) {
			"use strict";
			var vm = this;
			vm.accounts = [];
			vm.borrowerAccount = loanAutoDecisionConstants.BORROWER_ACCOUNT;
			vm.displayAdverseActionButton = null;
			vm.displayApprovalButton = null;
			vm.displayManualApprovalButton = null;
			vm.isRetailLoan = null;
			vm.loanId = null;
			vm.loanInformation = null;
			vm.namespacePrefix = '';
			vm.policyExceptions = null;
			vm.scorecard = null;
			vm.selectedAccount = null;
			vm.tabType = loanAutoDecisionConstants.TAB_TYPE;
			vm.window = $window;
			vm.clickTab = clickTab;
			vm.customFieldName = customFieldName;
			vm.getButtonOptions = getButtonOptions;
			vm.getScorecardDetails = getScorecardDetails;
			vm.hasOverallPointInformation = hasOverallPointInformation;
			vm.init = init;
			vm.isMultiCurrency = isMultiCurrency;
			vm.performAction = performAction;
			vm.redirectToCreditReport = redirectToCreditReport;
			vm.setButtonDisplayOptions = setButtonDisplayOptions;

			function init(loanId, scorecardId, scorecardObjectName) {
				vm.loanId = loanId;
				if (scorecardObjectName.indexOf('__') > 0) {
					vm.namespacePrefix = scorecardObjectName.substring(0,scorecardObjectName.indexOf('__')+2);
				}
				clickTab(null);
				loadScorecard(scorecardId);
			}

			function loadScorecard(scorecardId) {
				dataService.getScorecard(scorecardId).then(
					function(response) {
						vm.scorecard = response;
						vm.isRetailLoan = isRetailLoan(response);
						drawOverviewChart();
						getButtonOptions();
					},
					errorHandler
				);

				dataService.getLoanInformation(scorecardId).then(
					function(response) {
						vm.loanInformation = response;
						vm.borrowerAccount = vm.loanInformation[vm.namespacePrefix + 'Account__r'];
						vm.accounts = [];
						if (vm.borrowerAccount != null) {
							vm.accounts.push(vm.borrowerAccount);
						}
						var entities = vm.loanInformation[vm.namespacePrefix + 'Legal_Entities__r'];
						if (entities != null) {
							for (var cnt = 0; cnt < entities.length; cnt++) {
								if (vm.borrowerAccount == undefined || entities[cnt][vm.namespacePrefix + 'Account__r'].Id != vm.borrowerAccount.Id) {
									vm.accounts.push(entities[cnt][vm.namespacePrefix + 'Account__r']);
								}
								if (vm.borrowerAccount == null) {
									if (entities[cnt][vm.namespacePrefix + 'Borrower_Type__c'] == 'Borrower') {
										vm.borrowerAccount = entities[cnt];
									}
								}
							}
						}
						vm.policyExceptions = vm.loanInformation[vm.namespacePrefix+'Policy_Exceptions__r'];
						if(vm.policyExceptions == null)
							vm.policyExceptions = [];

						clickTab(null);
					},
					errorHandler
				);
			}

			function isMultiCurrency() {
				return vm.loanInformation !== null && vm.loanInformation['CurrencyIsoCode'] !== undefined;
			}

			function isRetailLoan(response){
				if (response[vm.namespacePrefix+'Loan__r'] != null) {
					return response[vm.namespacePrefix+'Loan__r'][vm.customFieldName('Product_Line')] == 'Consumer';
				}
				return null;
			}

			function getScorecardDetails() {
				if (vm.scorecard != null) {
					return vm.scorecard[vm.namespacePrefix+'Scorecard_Details__r'];
				}
				return [];
			}

			function clickTab(account) {
				vm.selectedAccount = account;
				if (account == null) {
					vm.tabType = 'loan';
					vm.selectedAccount = vm.borrowerAccount;
				}
				else {
					vm.tabType = 'account';
					vm.selectedAccount = account;
				}
			}

			function performAction(action) {
				var href = vm.window.location.pathname +
					'?app=' + action +
					'&id='+vm.loanId;
				if (vm.window.location.search != undefined &&
					vm.window.location.search != null &&
					vm.window.location.search.indexOf('inline=1') > 0) {
					href += '&inline=1';
				}
				vm.window.location.href = href;
			}

			function hasOverallPointInformation() {
				return vm.scorecard != null &&
					vm.scorecard[vm.customFieldName('Assigned_Points')] !== null &&
					vm.scorecard[vm.customFieldName('Assigned_Points')] !== undefined &&
					vm.scorecard[vm.customFieldName('Maximum_Points')] !== null &&
					vm.scorecard[vm.customFieldName('Maximum_Points')] !== undefined;
			}

			function drawOverviewChart(assignedPoints, maximumPoints) {
				google.charts.load('current', {packages:['corechart']});
				google.charts.setOnLoadCallback(drawChart);
				function drawChart() {
					var data = google.visualization.arrayToDataTable([
					  ['Category','Points'],
					  ['Assigned',vm.scorecard[vm.customFieldName('Assigned_Points')]],
					  ['Unassigned',vm.scorecard[vm.customFieldName('Maximum_Points')]-vm.scorecard[vm.customFieldName('Assigned_Points')]]
					]);

					var options = {
					  pieHole: 0.8,
					  enableInteractivity: false,
					  tooltip: {trigger: 'none'},
					  legend: {position: 'none'},
					  pieSliceText: 'none',
					  pieStartAngle: 270-(180*vm.scorecard[vm.customFieldName('Assigned_Points')]/vm.scorecard[vm.customFieldName('Maximum_Points')]),
					  colors:['06b264','CFD7E6'],
					  chartArea:{left:0,top:0,width:'100%',height:'100%'}
					};

					var chart = new google.visualization.PieChart(document.getElementById('decisionOverviewPointsChart'));
					chart.draw(data, options);
				}
			}

			function setButtonDisplayOptions(response) {
				var result = vm.scorecard[vm.customFieldName(loanAutoDecisionConstants.RESULT)];

				vm.displayApprovalButton = loanAutoDecisionConstants.APPROVED === result;
				vm.displayManualApprovalButton = result === loanAutoDecisionConstants.RECOMMEND_APPROVAL && !vm.isRetailLoan;
				vm.displayAdverseActionButton = [
					loanAutoDecisionConstants.RECOMMEND_DECLINE,
					loanAutoDecisionConstants.DECLINED].indexOf(result) > -1 && !vm.isRetailLoan;

				if (response !== undefined) {
					if (loanAutoDecisionConstants.MANUAL_APPROVAL in response) {
						vm.displayManualApprovalButton = response[
							loanAutoDecisionConstants.MANUAL_APPROVAL].indexOf(result) > -1;
					}

					if (loanAutoDecisionConstants.ADVERSE_ACTION in response) {
						vm.displayAdverseActionButton = response[
							loanAutoDecisionConstants.ADVERSE_ACTION].indexOf(result) > -1;
					}
				}
			}

			function getButtonOptions() {
				dataService.getButtonDisplayOptions().then(function(response){
					setButtonDisplayOptions(response);
				});
			}

			function redirectToCreditReport() {
				vm.window.location.href =
					'/' + vm.selectedAccount[vm.customFieldName('FICO_Credit_Report')]
			}

			function customFieldName(fieldName) {
				return vm.namespacePrefix + fieldName + '__c';
			}

			function errorHandler(error) {
				LifeCycle.unblockUI();
				messageService.setMessage({type: messageService.messageTypes.error, text: error }, true);
			}
}])
.filter('fieldset', function($filter) {
	return function(value, type) {
		if (value == null || value == undefined) {
			value = '\u00A0';
		}
		if (type == 'datetime' || type == 'date') {
			return $filter('date')(value, 'mediumDate', '+0000');
		}
		if (type == 'currency') {
			return $filter('currency')(value, '$');
		}
		if (type == 'percent') {
			return $filter('number')(value, '3')+'%';
		}
		if (type == 'boolean') {

			return String(value).charAt(0).toUpperCase() + String(value).slice(1);
		}
		return value;
	}
})
.directive('ndsValue', function(){
	return {
		restrict: 'A',
	scope: {
		ndsValue: '='
	},
	link: function(scope, element){
		element.bind('valueChange', function(event){
			scope.$apply(function(){
					scope.ndsValue = event.originalEvent ? event.originalEvent.detail : event.detail;
				});
			});
		}
	}
})
.directive('ndsProps', function(){
	return {
		link: function(scope, element, attrs){
			scope.$watchCollection(attrs.ndsProps, function(newValues){
				for (var key in newValues) {
					element[0][key] = newValues[key];
				}
			});
		}
	}
});
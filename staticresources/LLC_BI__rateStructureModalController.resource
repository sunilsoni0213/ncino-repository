(function(){
	"use strict";
	angular.module('ncRateAndPayment')
	.controller('rateStructureModalController', ['$scope', '$rootScope',
		'messageService', 'label', 'rateStructureRemoting',
		function($scope, $rootScope, messageService, label, rateStructureRemoting) {

		var vm = this;

		vm.performanceIndicatorComparisons = ["Greater than", "Less than", "In Between", "Equal to",
			"Greater than or equal to", "Less than or Equal to"];
		vm.performanceIndicatorActions = [label.getLabels().Increase_Rate, label.getLabels().Decrease_Rate, label.getLabels().Leave_Rate_Unchanged, label.getLabels().Set_Rate];
		vm.covenantFrequencyUnits = [];
		vm.covenantTypes = [];
		vm.legalEntities = [];

		vm.rules = [];

		vm.save = save;
		vm.cancel = cancel;
		vm.addRule = addRule;
		vm.deleteRule = deleteRule;
		vm.canCreateRule = canCreateRule;
		vm.isRateAdjusting = isRateAdjusting;
		vm.isRateSetting = isRateSetting;
		vm.isComparisonInBetween = isComparisonInBetween;

		$rootScope.$on('createNewPerformanceIndicator', function(event, loanId, componentIndex){

			messageService.clear();

			rateStructureRemoting.getFilteredCovenantTypes()
				.then(function(result){
					vm.covenantTypes = result;

			}, handleInitializeError);

			rateStructureRemoting.getEntities(loanId)
				.then(function(result){
					vm.legalEntities = result;
			}, handleInitializeError);

			rateStructureRemoting.getCovenantFrequencyUnits()
				.then(function(result){
					vm.covenantFrequencyUnits = result;

			}, handleInitializeError);

			rateStructureRemoting.createPricingCovenant()
				.then(function(result){

					vm.performanceIndicator = result;
					vm.componentIndex = componentIndex;

					vm.rules = [];
					vm.rules.push({
						comparisonOperator: null,
						comparisonValue: null,
						minComparisonValue: null,
						maxComparisonValue: null,
						adjustmentAction: null,
						adjustmentAmount: null
					});

					vm.dialogShown = true;

			}, handleInitializeError);
		});

		function canCreateRule(rule) {
			if(vm.rules && rule && (rule.adjustmentAmount || rule.adjustmentAction === "Leave Rate Unchanged")) {
				return true;
			}
			return false;
		}

		function handleInitializeError(message){

				messageService.setMessage({text: message, type: messageService.messageTypes.error});
				vm.dialogShown = false;
		}

		function addRule() {
			vm.rules.push({
				comparisonOperator: null,
				comparisonValue: null,
				minComparisonValue: null,
				maxComparisonValue: null,
				adjustmentAction: null,
				adjustmentAmount: null
			});
		}

		function deleteRule(rule){
			var index = vm.rules.indexOf(rule);
			if(index !== -1) {
				vm.rules.splice(index,1);
			}

			if(vm.rules.length === 0){
				vm.rules.push({
					comparisonOperator: null,
					comparisonValue: null,
					minComparisonValue: null,
					maxComparisonValue: null,
					adjustmentAction: null,
					adjustmentAmount: null
				});
			}
		}

		function save(){

			convertUTCString();
			removeUnusedFields(vm.rules);

			vm.performanceIndicator.name = vm.performanceIndicator.covenantMgmt.covenantType.name;
			vm.performanceIndicator.rules = vm.rules;

			if (vm.performanceIndicator.covenantMgmt.nextEvalDate &&
				vm.performanceIndicator.covenantMgmt.nextEvalDate.isValid()) {

				vm.performanceIndicator.covenantMgmt.nextEvalDate =
					moment(vm.performanceIndicator.covenantMgmt.nextEvalDate).format("YYYY-MM-DD");
			}

			$rootScope.$broadcast('saveMessage', vm.performanceIndicator, vm.componentIndex);
			vm.dialogShown = false;
		}

			function convertUTCString() {
				if (vm.performanceIndicator.covenantMgmt.nextEvalDate) {
					vm.performanceIndicator.covenantMgmt.nextEvalDate =
						moment(parseInt(vm.performanceIndicator.covenantMgmt.nextEvalDate));
					}
				}

		function cancel(){
			vm.dialogShown = false;
		}

		function removeUnusedFields(){

			angular.forEach(vm.rules, function(rule){

				if(rule.comparisonOperator === "In Between"){
					delete rule.comparisonValue;
				} else {
					delete rule.minComparisonValue;
					delete rule.maxComparisonValue;
				}

			});
		}

		function isRateAdjusting(rule){
			return rule.adjustmentAction !== label.getLabels().Leave_Rate_Unchanged;
		}

		function isRateSetting(rule){
			return rule.adjustmentAction === label.getLabels().Set_Rate;
		}

		function isComparisonInBetween(rule){
			return rule.comparisonOperator === "In Between";
		}
	}]);
})();

angular.module('ruleEngineApp')
	.controller('RuleEngineAdminController', ['$scope', 'dataService', 'label',
		function($scope, dataService, label) {
		"use strict";
		var vm = this;
		var scope = $scope;
		vm.ruleEngines = [];
		vm.ruleEngineRules = [];
		vm.ruleEngineRule = {};
		vm.modalInfo = {};
		vm.ruleEngineContexts = [];
		vm.modalVisible = false;
		vm.error = null;
		vm.success = null;
		vm.export = {};
		vm.import = {};
		vm.init = init;
		vm.loadRules = loadRules;
		vm.addModal = addModal;
		vm.editModal = editModal;
		vm.removeModal = removeModal;
		vm.hideModal = hideModal;
		vm.getRuleEngineRule = getRuleEngineRule;
		vm.upsertRuleEngineRule = upsertRuleEngineRule;
		vm.deleteRuleEngineRule = deleteRuleEngineRule;
		vm.dismissNotification = dismissNotification;
		vm.importRule = importRule;
		vm.exportRule = exportRule;
		vm.fileNameChanged = fileNameChanged;
		vm.labels = label.getLabels();
		vm.getHeader = getHeader;

		vm.init();

		function errorHandler(error) {
			LifeCycle.unblockUI();
			hideModal();
			vm.error = error;
		}

		function dismissNotification() {
			vm.error = null;
			vm.success = null;
		}

		function init() {
			dataService.getRuleEngines().then(
				function(response) {
					vm.ruleEngines = response;
					if (Object.keys(vm.ruleEngines).length == 1) {
						vm.export.ruleEngine = vm.ruleEngines[Object.keys(vm.ruleEngines)];
						vm.import.ruleEngine = vm.ruleEngines[Object.keys(vm.ruleEngines)];
					}
					if (vm.ruleEngineRules != []) {
						matchRules();
					}
				},
				errorHandler);
			dataService.getRuleEngineContextInformation().then(
				function(response) {
					vm.ruleEngineContexts = response;
				},
				errorHandler);
			loadRules();
		}

		function loadRules() {
			dataService.getRuleEngineRules().then(
				function(response) {
					vm.ruleEngineRules = response;
					matchRules();
				},
				errorHandler);
		}

		function hideModal() {
			vm.modalVisible = false;
		}

		function addModal() {
			vm.ruleEngineRule = {};
			vm.modalInfo = {
				type:'add',
				requiredFieldClass:'requiredInput',
				editable:true
			};
			setPickerDate('startdatepicker',Date.now());
			if (Object.keys(vm.ruleEngines).length == 1) {
				vm.ruleEngineRule.ruleEngineUniqueName = vm.ruleEngines[Object.keys(vm.ruleEngines)].uniqueName;
			}
			vm.modalVisible = true;
		}

		function editModal(ruleEngineRuleId) {
			vm.ruleEngineRule = {};
			scope.modalForm.$setPristine();
			vm.modalInfo = {
				type:'edit',
				requiredFieldClass:'requiredInput',
				editable:true
			};
			vm.getRuleEngineRule(ruleEngineRuleId);
		}

		function removeModal(ruleEngineRuleId) {
			vm.ruleEngineRule = {};
			vm.modalInfo = {
				type:'remove',
				editable:false
			};
			vm.getRuleEngineRule(ruleEngineRuleId);
		}

		function setPickerDate(pickerId, apexDate) {
			if (apexDate == null) {
				return;
			}
			var jsDate = new Date(apexDate);
			jsDate.setMinutes(+new Date().getTimezoneOffset());
			jQuery('#'+pickerId).datepicker('setDate', jsDate);
		}

		function getRuleEngineRule(ruleEngineRuleId) {
			dataService.getRuleEngineRule(ruleEngineRuleId).then(function(response) {
				vm.ruleEngineRule = response;
				vm.ruleEngineContexts.forEach(function (context) {
					if (context.name === vm.ruleEngineRule.context) {
						vm.modalInfo.context = context;
						vm.modalInfo.context.rules.forEach(function (contextRule) {
							if (contextRule.id === vm.ruleEngineRule.contextRuleId) {
								vm.modalInfo.contextRule = contextRule;
							}
						});
					}
				});
				matchRule(vm.ruleEngineRule);
				setPickerDate('startdatepicker',vm.ruleEngineRule.startDate);
				setPickerDate('enddatepicker',vm.ruleEngineRule.endDate);
				vm.modalVisible = true;
			});
		}

		function matchRule(rule) {
			if (vm.ruleEngines && vm.ruleEngines[rule.ruleEngineUniqueName] != null) {
				vm.ruleEngines[rule.ruleEngineUniqueName].externalReferences.forEach(function (externalreference) {
					if (externalreference.externalRuleReference === rule.ruleEngineExternalReference.externalRuleReference ||
						externalreference.externalRuleUniqueName === rule.ruleEngineExternalReference.externalRuleUniqueName) {
						rule.ruleEngineExternalReference = externalreference;
					}
				});
			}
		}

		function matchRules() {
			vm.ruleEngineRules.forEach(function (rule) {
				matchRule(rule);
			});
		}

		function upsertRuleEngineRule() {
			vm.ruleEngineRule.contextRuleId = vm.modalInfo.contextRule.id;
			if (vm.modalInfo.startDate != null) {
				vm.ruleEngineRule.startDate = new Date(vm.modalInfo.startDate).getTime();
			}
			if (vm.modalInfo.endDate != null) {
				vm.ruleEngineRule.endDate = new Date(vm.modalInfo.endDate).getTime();
			}
			dataService.upsertRuleEngineRule(vm.ruleEngineRule).then(function(response) {
				vm.ruleEngineRules = response;
				matchRules();
				hideModal();
			},
			errorHandler);
		}

		function deleteRuleEngineRule(ruleToDeleteId) {
			dataService.deleteRuleEngineRule(ruleToDeleteId).then(
				function(response) {
					vm.ruleEngineRules = response;
					matchRules();
				},
				errorHandler
			);
			hideModal();
		}

		function exportRule() {
			dismissNotification();
			LifeCycle.blockUI();
			dataService.exportRuleEngineRuleVersion(vm.export.ruleEngine.uniqueName, vm.export.version.externalReference).then(
				function(response) {
					var filename =
						vm.export.ruleEngine.displayName+'.'+
						vm.export.externalReference.externalRuleDisplayName+'.'+
						vm.export.version.versionNumber +'.exportedRule';
					filename = filename.replace(' ','_');
					saveAs(new Blob([response], {type: "application/octet-stream"}), filename);
					vm.success = 'Successfully exported Rule.';
					scope.exportForm.$setPristine();
					LifeCycle.unblockUI();
				},
				errorHandler);
		}

		function fileNameChanged(info) {
			vm.import.file = null;
			if (info.files.length > 0) {
				vm.import.file = info.files[0];
			}
			$scope.$apply();
		}

		function importRule() {
			dismissNotification();
			LifeCycle.blockUI();
			var reader = new FileReader();
			reader.onload = function(event) {
				dataService.importRuleEngineRule(
					vm.import.ruleEngine.uniqueName,
					vm.import.ruleName,
					event.target.result,
					vm.import.version).then(
						function(response) {
							vm.success = 'Successfully imported Rule.';
							LifeCycle.unblockUI();
						},
					errorHandler);
			};
			reader.onerror = function(event) {
				errorHandler('File could not be read. (' + event.target.error.code + ')');
			};
			scope.importForm.$setPristine();
			reader.readAsText(vm.import.file);
		}

		function getHeader() {
			if(vm.modalInfo.type == 'add') return (vm.labels.Rule_Engine_Add_Rule_Header);
			if(vm.modalInfo.type == 'edit') return (vm.labels.Rule_Engine_Edit_Rule_Header);
			if(vm.modalInfo.type == 'remove') return (vm.labels.Rule_Engine_Remove_Rule_Header);
		}
}]);

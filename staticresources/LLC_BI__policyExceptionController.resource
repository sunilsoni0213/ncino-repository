angular.module('policyExceptionApp')
	.controller('PolicyExceptionController', ['$scope', 'dataService', 'messageService',
		function($scope, dataService, messageService) {

		var vm = this;
		vm.chatterComments = null;
		vm.chatterFeed = {};
		vm.commentRequired = false;
		vm.commentsLimit = 3;
		vm.legalEntities = [];
		vm.covenants = [];
		vm.collateral = [];
		vm.mitigationReasons = [];
		vm.modalInfo = {};
		vm.namespacePrefix = {};
		vm.policyException = {};
		vm.policyExceptions = [];
		vm.policyExceptionTemplates = [];
		vm.policyXception = {};

		vm.init = init;
		vm.addModal = addModal;
		vm.clearPolicyException = clearPolicyException;
		vm.copyTemplateCode = copyTemplateCode;
		vm.deletePolicyException = deletePolicyException;
		vm.deleteModal = deleteModal;
		vm.editModal = editModal;
		vm.expand = expand;
		vm.getChatterFeed = getChatterFeed;
		vm.getCollateral = getCollateral;
		vm.getCovenant = getCovenant;
		vm.getEntities = getEntities;
		vm.getMitigationReasons = getMitigationReasons;
		vm.getPolicyException = getPolicyException;
		vm.getPolicyExceptions = getPolicyExceptions;
		vm.getPolicyExceptionTemplates = getPolicyExceptionTemplates;
		vm.getPolicyXception = getPolicyXception;
		vm.postChatterComment = postChatterComment;
		vm.setCommentRequired = setCommentRequired;
		vm.toggleModal = toggleModal;
		vm.upsertPolicyException = upsertPolicyException;
		vm.upsertPolicyXception = upsertPolicyXception;
		vm.getPicklistValues = getPicklistValues;
		vm.returnPicklistValues = [];


		jQuery(window.document).on('show.bs.collapse', function(event) {
			jQuery('#'+event.target.id+'-td img').addClass('rotImg');
			jQuery('#'+event.target.id+'-tr').addClass('slds-is-selected');
			jQuery('.collapse.in').collapse('hide');
		});

		jQuery(window.document).on('hidden.bs.collapse', function(event) {
			jQuery('#'+event.target.id+'-td img').removeClass('rotImg');
			jQuery('#'+event.target.id+'-tr').removeClass('slds-is-selected');
		});


		function init(objectName) {
			if (objectName.indexOf('__') > 0) {
				vm.namespacePrefix = objectName.substring(0,objectName.indexOf('__')+2);
			}
			vm.getPolicyExceptions();
			vm.getPicklistValues();
		}

		function addModal() {
			vm.policyException = {};
			vm.getPolicyExceptionTemplates();
			vm.getEntities();
			vm.getCollateral();
			vm.getCovenant();
			vm.toggleModal('add', true, true);
		}

		function clearPolicyException(fieldName, exceptionType) {
			var id = vm.policyException.Id;
			vm.policyException = {};
			vm.policyException[fieldName] = exceptionType;
			vm.policyException.Id = id;
		}

		function copyTemplateCode() {
			angular.forEach(vm.policyExceptionTemplates, function(listItem) {
				if(vm.policyException.Name === listItem.name
					&& vm.policyException[vm.namespacePrefix + 'Type__c'] === listItem['type']) {
					vm.policyException[vm.namespacePrefix + 'Code__c'] = listItem['code'];
					vm.policyException.Name = listItem.originalName;
				}
			});
			vm.upsertPolicyException();
		}

		function deleteModal(policyExceptionId) {
			vm.policyException = {};
			vm.getPolicyException(policyExceptionId);
			vm.getPolicyExceptionTemplates();
			vm.getEntities();
			vm.getCollateral();
			vm.getCovenant();
			vm.toggleModal('delete', true, false);
		}

		function deletePolicyException(policyExceptionId) {
			dataService.deletePolicyException(policyExceptionId)
				.then(function() {
					vm.getPolicyExceptions();
				})
				.catch(function (error) {
					messageService.setMessage(
					{ type: messageService.messageTypes.error, text: error }
					, true);
				});

			vm.toggleModal('delete', false, false);
		}

		function editModal(policyExceptionId) {
			vm.policyException = {};
			vm.getPolicyException(policyExceptionId);
			vm.getPolicyExceptionTemplates();
			vm.getEntities();
			vm.getCollateral();
			vm.getCovenant();
			vm.toggleModal('edit', true, true);
		}

		function expand(policyExceptionId) {
			messageService.clear();
			vm.commentRequired = false;
			vm.policyXception = {};
			vm.getMitigationReasons(policyExceptionId);
			vm.getChatterFeed(policyExceptionId);
			vm.getPolicyXception(policyExceptionId);
			vm.commentsLimit = 3;
		}

		function getChatterFeed(policyExceptionId) {
			vm.chatterFeed = {};
			dataService.getChatterFeed(policyExceptionId)
				.then(function(response) {
					vm.chatterFeed = response;
				})
				.catch(function (error) {
					messageService.setMessage({ type: messageService.messageTypes.error, text: error }, true);
				});
		}

		function getCollateral() {
			vm.collateral = [];
			dataService.getCollateral()
				.then(function(response) {
					vm.collateral = response;
				})
				.catch(function (error) {
					messageService.setMessage({ type: messageService.messageTypes.error, text: error }, true);
				});
		}

		function getCovenant() {
			vm.covenants = [];
			dataService.getCovenant()
				.then(function(response) {
					vm.covenants = response;
				})
				.catch(function (error) {
					messageService.setMessage({ type: messageService.messageTypes.error, text: error }, true);
				});
		}

		function getEntities() {
			vm.legalEntities = [];
			dataService.getEntities()
				.then(function(response) {
					vm.legalEntities = response;
				})
				.catch(function (error) {
					messageService.setMessage({ type: messageService.messageTypes.error, text: error }, true);
				});
		}

		function getMitigationReasons(policyExceptionId) {
			dataService.getMitigationReasons(policyExceptionId)
				.then(function(response) {
					vm.mitigationReasons = response;
				})
				.catch(function (error) {
					messageService.setMessage({ type: messageService.messageTypes.error, text: error }, true);
				});
		}

		function getPolicyException(policyExceptionId) {
			vm.chatterComments = null;
			dataService.getPolicyException(policyExceptionId)
				.then(function(response) {
					vm.policyException = response;
				})
				.catch(function (error) {
					messageService.setMessage({ type: messageService.messageTypes.error, text: error }, true);
				});
		}

		function getPolicyExceptions() {
			dataService.getPolicyExceptions()
				.then(function(response) {
					vm.policyExceptions = response;
				})
				.catch(function (error) {
					messageService.setMessage({ type: messageService.messageTypes.error, text: error }, true);
				});
		}

		function getPolicyExceptionTemplates() {
			dataService.getPolicyExceptionTemplates()
				.then(function(response) {
					vm.policyExceptionTemplates = response;
				})
				.catch(function (error) {
					messageService.setMessage({ type: messageService.messageTypes.error, text: error }, true);
				});
		}

		function getPolicyXception(policyExceptionId) {
			vm.chatterComments = null;
			vm.policyXception = {};
			dataService.getPolicyXception(policyExceptionId)
				.then(function(response) {
					vm.policyXception = response;
				})
				.catch(function (error) {
					messageService.setMessage({ type: messageService.messageTypes.error, text: error }, true);
				});
		}

		function postChatterComment() {
			if(vm.chatterComments != null) {
				dataService.postChatterComment(vm.policyXception.policyExceptionId, vm.chatterComments)
					.then(function(response) { vm.chatterComments = null;})
					.catch(function (error) {
						messageService.setMessage({ type: messageService.messageTypes.error, text: error }, true);
					});
			}
		}

		function getPicklistValues() {
			dataService.getPicklistValues()
				.then(function(response) {
					vm.returnPicklistValues = response;
					return response;
				})
				.catch(function (error) {
					vm.returnPicklistValues = [];
					messageService.setMessage({ type: messageService.messageTypes.error, text: error }, true);
				});
		}

		function setCommentRequired() {
			vm.commentRequired = false;
			angular.forEach(vm.mitigationReasons, function(listItem) {
				if (listItem.originalReason === vm.policyXception.mitigationReason1
						|| listItem.originalReason === vm.policyXception.mitigationReason2
						|| listItem.originalReason === vm.policyXception.mitigationReason3) {
					vm.commentRequired = listItem.commentRequired;
				}
			});

			console.log(vm.commentRequired);
		}

		function toggleModal(type, visible, editable) {
			messageService.clear();
			vm.modalInfo = {
				type: type,
				visible: visible,
				editable: editable
			};
		}

		function upsertPolicyException() {
			vm.policyException.name = vm.policyException.originalName;
			dataService.upsertPolicyException(vm.policyException)
				.then(function(response) {
					vm.toggleModal('add', false, false);
					vm.getPolicyExceptions();
				})
				.catch(function (error) {
					var errorArray = error.split('first error:');
					error = errorArray.length > 1 ? errorArray[1] : errorArray[0];
					messageService.setMessage({ type: messageService.messageTypes.error, text: error}, true);
					vm.getPolicyExceptions();
				});
		}

		function upsertPolicyXception() {
			vm.policyXception.name = vm.policyXception.originalName;
			dataService.upsertPolicyXception(vm.policyXception)
				.then(function(response) {
					vm.getPolicyExceptions();
				})
				.catch(function (error) {
					messageService.setMessage({ type: messageService.messageTypes.error, text: error}, true);
					vm.getPolicyExceptions();
				});
		}

}]).filter('split', function() {
	return function(objList, delimeter, fieldName) {
		if(objList.length === 0){
			return '';
		}
		var returnList = [];
		for(var i = 0; i < objList.length; i++) {
			returnList = returnList.concat(objList[i][fieldName].split(delimeter));
		}
		var uniqueItems = [];
		for(i = 0; i < returnList.length; i++) {
			if(uniqueItems.indexOf(returnList[i]) < 0) {
				uniqueItems.push(returnList[i]);
			}
		}
		return uniqueItems.sort();
	}
}).filter('unique', function() {
	return function(objList, fieldName) {
		var uniqueItems = [];
		for(var i = 0; i < objList.length; i++) {
			if(uniqueItems.indexOf(objList[i][fieldName]) < 0) {
				uniqueItems.push(objList[i][fieldName]);
			}
		}
		return uniqueItems.sort();
	}
});
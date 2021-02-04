(function(angular) {
	'use strict';
	angular.module('ncPolicyExceptionAuto', ['ncUI','ncDataProviders'])
	.controller('policyExceptionAutoRunController', PolicyExceptionAutoRunController);

	PolicyExceptionAutoRunController.$inject = ['$window','messageService','remotingManager'];
	function PolicyExceptionAutoRunController($window, messageService, remotingManager){
		var vm = this;
		vm.error = false;
		vm.response = null;
		vm.loanId = null;

		vm.generateAutoPolicyExceptions = function(generatePolExcRa, loanId){
			vm.error = false;
			vm.response = null;
			vm.loanId = loanId;
			remotingManager.invokeAction(
				generatePolExcRa,
				vm.loanId,
				vm.receiveAutoPolExcResponse,
				{escape: false}
			);
		}

		vm.receiveAutoPolExcResponse = function(result, event){
			if (event.status) {
				vm.response = JSON.parse(result);
				messageService.clear();
				var group = 'loan';

				if($window.location.search !== undefined && $window.location.search !== null){
					group = $window.location.search.substring(
					$window.location.search.indexOf('?app=') + 5);
					group = group.substring(0, group.indexOf('.'));
				}

				var href = $window.location.origin + $window.location.pathname +'?app='+group+'.policy-exception&id='+vm.loanId;

				if ($window.location.search != undefined && $window.location.search != null && $window.location.search.indexOf('inline=1') > 0) {
					href += '&inline=1';
				}
				$window.location.href = href;
			} else {
				vm.response = null;
				vm.error = true;
				messageService.setMessage(
					{
						type: messageService.messageTypes.error,
						canDismiss: false,
						text: event.message
					}, true);
			}
		}
	}
})(window.angular);
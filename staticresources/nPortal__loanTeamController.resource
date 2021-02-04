angular.module('selfRegisterApp')
	.controller('LoanTeamController', ['$scope', 'loanTeamDataService', 'helperService',
		function($scope, loanTeamDataService, helperService) {
			var vm = this;
			vm.contextId = '';
			vm.loanTeam = [];
			vm.tileId = '';

			vm.init = init;
			vm.bindTile = bindTile;
			vm.getContextId = getContextId;
			vm.getLoanTeam = getLoanTeam;

			vm.init();

			function init() {
				vm.getContextId();
				vm.getLoanTeam();
			}

			function bindTile(tile) {
				vm.tileId = tile.sid;
			}

			function getContextId() {
				vm.contextId = helperService.getParameterByName('aid');
				if (!vm.contextId) {
					// Use primary Id parameter if aid (DocumentUpload) is not available
					vm.contextId = helperService.getParameterByName('id');
				}
			}

			function getLoanTeam() {
				if (vm.contextId) {
					loanTeamDataService.getLoanTeam(vm.contextId).then(function(response) {
						if (response != null) {
							vm.loanTeam = response;

							// If the Loan Team panel is bound to a tile,
							// hide the tile when no members are available.
							if (vm.loanTeam.length == 0 && vm.tileId) {
								jQuery(document.getElementById(vm.tileId)).hide();
							}
						}
					});
				}
			}
		}]);
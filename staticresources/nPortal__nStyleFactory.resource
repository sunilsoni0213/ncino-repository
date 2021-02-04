angular.module('selfRegisterApp')
	.factory('nStyleFactory', ['$rootScope', 'nStyleDataService', 'helperService',
		function($rootScope, nStyleDataService, helperService) {
	var svc = this;
	svc.styles = null;
	svc.loadStart = false;
	svc.loadComplete = false;
	svc.clients = {};
	svc.clientsComplete = 0;

	svc.retrieveStyles = retrieveStyles;
	svc.returnStyles = returnStyles;
	svc.flagComplete = flagComplete;

	return svc;

	function retrieveStyles() {
		if (!svc.loadStart && svc.styles == null) {
			// Set flag to prevent redundant requests
			svc.loadStart = true;
			nStyleDataService.retrieveStyles().then(function (response) {
				if (response.type && response.type === 'exception') {
					svc.styles = null;
					svc.loadStart = false;
					helperService.showMessage(vm.label.Error_Retrieve_Styles, MESSAGE_CONSTANTS.TYPE_ERROR);
				}
				else {
					svc.loadComplete = true;
					svc.styles = {};
					svc.styles = JSON.parse(response);
				}
				svc.returnStyles();
			});
		}

		// Returns cached styles if available. Otherwise, styles will come back via the applyCallback function
		return svc.styles;
	}

	function returnStyles() {
		// Styles have been loaded. Signal to clients using their provided callback
		for (var clientId in svc.clients) {
			if (svc.clients.hasOwnProperty(clientId)) {
				svc.clients[clientId].applyCallback(svc.styles);
			}
		}
	}

	function flagComplete(clientId) {
		svc.clientsComplete++;
		// Have all styles been applied to registered elements?
		if (svc.clientsComplete == Object.keys(svc.clients).length)  {
			svc.clients[clientId].completeCallback();
		}
	}
}]);
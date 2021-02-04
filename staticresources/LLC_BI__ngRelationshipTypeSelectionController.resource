(function(){
	'use strict';
	angular.module('app', ['ncUI']).controller('AppController', AppController);
	AppController.$inject = ['$scope', 'label', 'config', 'messageService'];
	function AppController($scope, label, config, messageService) {
		$scope.labels = label.getLabels();
		var typeConfig = config.get();
		$scope.anchor = {};
		$scope.anchor.link = '#';
		$scope.anchor.src = $scope.labels.anchorSrc;
		$scope.anchor.background = $scope.labels.anchorBackground;
		$scope.anchor.text = $scope.labels.anchorText;

		if(typeConfig.errorShow){
			messageService.setMessage({ type: messageService.messageTypes.error, text: $scope.labels.typeErrorMsg }, true);
		}
	}
})();
(function(){
	'use strict';
	angular.element(document).ready(function() {
		angular.bootstrap(document.getElementById('app'), ['app']);
	});
})();

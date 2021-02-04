(function(){
	'use strict';
	angular.module('app', []).controller('AppController', AppController);
	AppController.$inject = ['$scope','label'];
	function AppController($scope,label) {
		$scope.labels = label.getLabels();

		$scope.anchor = {};
		$scope.anchor.link = '#';
		$scope.anchor.src = $scope.labels.anchorSrc;
		$scope.anchor.background = $scope.labels.anchorBackground;
		$scope.anchor.text = $scope.labels.anchorText;
	}
})();
(function(){
	'use strict';
	angular.element(document).ready(function() {
		angular.bootstrap(document.getElementById('app'), ['app']);
	});
})();

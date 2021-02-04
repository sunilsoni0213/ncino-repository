(function(){
	'use strict';
	angular.module('app', []).controller('AppController', AppController);
	AppController.$inject = ['$scope','label'];
	function AppController($scope,label) {
		$scope.labels = label.getLabels();
		$scope.continue = {};
		$scope.continue.rendered = true;
		$scope.continue.disabled = false;
		$scope.continue.text = $scope.labels.continueLabel;
		$scope.continue.styleClass = 'item btn btn-md btn-secondary';

		$scope.anchor = {};
		$scope.anchor.link = '#';
		$scope.anchor.circleText = $scope.labels.circleText;
		$scope.anchor.text = $scope.labels.newCustomerCreation;

		$scope.error = {};
		$scope.error.rendered = false;
		$scope.error.message = 'The error message';

		$scope.success = {};
		$scope.success.rendered = false;
		$scope.success.message = 'The success message';
	}
})();

(function(){
	'use strict';
	angular.element(document).ready(function() {
		angular.bootstrap(document.getElementById('app'), ['app']);
	});
})();
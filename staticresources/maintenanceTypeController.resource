angular.module('maintenanceTypeApp')
	.controller('MaintenanceTypeController', ['$scope', 'dataService',
		function($scope, dataService) {

		$scope.types = [];
		$scope.newType = [];
		$scope.newTypes = [];
		$scope.modalVisible = false;

		$scope.init = init;
		$scope.addModal = addModal;
		$scope.editModal = editModal;
		$scope.expand = expand;
		$scope.getCategories = getCategories;
		$scope.getTypes = getTypes;
		$scope.toggleModal = toggleModal;
		$scope.upsertTypes = upsertTypes;
		$scope.init();

		function init() {
			dataService.getTypes().then(function(response) {
				$scope.types = response;
			});
		}

		function addModal() {
			$scope.getTasks();
			$scope.toggleModal();
		}

		function editModal(taskId) {
			$scope.getTask(taskId);
			$scope.addModal();
		}

		function expand(taskId) {
			$scope.getTask(taskId);
			$scope.getSubtasks(taskId);
		}

		function getCategories() {
			dataService.getCategories().then(function(response) {
				$scope.categories = response;
			});
		}

		function getTypes(){
			dataService.getTypes().then(function(response){
				$scope.types = response;
			});
		}

		function toggleModal() {
			$scope.modalVisible = !$scope.modalVisible;
		}

		function upsertTypes() {
			$scope.newTypes = splitLines($scope.newTypes);
			if($scope.newTypes != null){
				dataService.upsertTypes($scope.newTypes).then(function(response) {
					$scope.modalVisible = false;
					$scope.types = response;
					for(var i = 0; i < $scope.newTypes.length; i++){
						$scope.types.push($scope.newTypes[i]);
					}
				});
			}
			$scope.newTypes = [];
		}

		function splitLines(string) {
			if(string != null){
				var array = string.split('\n');
			}
			return array;
		}
}]);
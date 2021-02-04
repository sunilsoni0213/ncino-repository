angular.module('maintenanceChecklistApp')
	.controller('MaintenanceChecklistController', ['$scope', 'dataService',
		function($scope, dataService) {

		$scope.checklistItems = [];
		$scope.newChecklistItem = {};
		$scope.newChecklist = [];
		$scope.subjectList = [];
		$scope.deleteChecklistItem = {};
		$scope.removalChecklist = [];
		$scope.modalVisible = false;

		$scope.init = init;
		$scope.getChecklist = getChecklist;
		$scope.addChecklist = addChecklist;
		$scope.deleteChecklist = deleteChecklist;
		$scope.addChecklistItem = addChecklistItem;
		$scope.init();

		function init() {
			$scope.newChecklistItem = {};
			$scope.newChecklist = [];
			$scope.subjectList = [];
			dataService.getChecklist().then(function(response) {
				$scope.checklistItems = response;
			});
		}

		function getChecklist() {
			dataService.getChecklist().then(function(response) {
				$scope.categories = response;
			});
		}

		function addChecklist(){
			dataService.addChecklist($scope.newChecklist).then(function(response){
				init();
			});
		}

		function deleteChecklist() {
			dataService.deleteChecklist().then(function(response){
				getChecklist();
			});
		}

		function addChecklistItem(){
			$scope.newChecklist.push($scope.newChecklistItem);
			$scope.subjectList.push($scope.newChecklistItem.Subject);
			$scope.newChecklistItem = {};
		}

		function deleteChecklistItem(){
			removalChecklist.push(deleteChecklistItem);
		}
}]);
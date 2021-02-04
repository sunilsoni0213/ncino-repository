angular.module('maintenanceMappingApp')
	.controller('MaintenanceMappingController', ['$scope', 'dataService',
		function($scope, dataService) {

		$scope.maps = [];
		$scope.tasks = [];
		$scope.types = [];
		$scope.availableActions = [];
		$scope.masterActionList = [];
		$scope.selectedActions = [];

		$scope.newChecklistItem = {};
		$scope.selectedType = {};
		$scope.deleteChecklistItem = {};
		$scope.action = {
			actionItem : '',
			taskId : '',
			selected : false
		};

		$scope.modalVisible = false;

		$scope.init = function() {
			$scope.masterActionList = [];
			dataService.getMappings().then(function(response) {
				$scope.maps = response;
				sortMaps();
			});
			dataService.retrieveTasks().then(function(response) {
				$scope.tasks = response;
				sortTasks();
			});
		}

		$scope.retrieveTasks = function() {
			dataService.retrieveTasks().then(function(response) {
				$scope.tasks = response;
			});
		}

		$scope.getMappings = function() {
			dataService.getMappings().then(function(response) {
				$scope.maps = response;
				sortMaps();
			});
		}

		$scope.saveMappings = function() {
			var actions = [];
			for(var selected in $scope.selectedActions){
				actions.push($scope.selectedActions[selected].taskId);
			}
			dataService.saveMappings($scope.selectedType, actions).then(function(response){
				$scope.maps = response;
				sortMaps();
			});
		}

		$scope.selectItem = function(checklistItem){
			checklistItem.selected = true;
			$scope.newChecklistItem = checklistItem;
		}

		$scope.deselectItem = function(checklistItem){
			checklistItem.selected = false;
			$scope.deleteChecklistItem = checklistItem;
		}

		$scope.getCurrentChecklist = function() {
			$scope.availableActions = $scope.masterActionList;
			if($scope.maps[$scope.selectedType]!= null){
				$scope.selectedActions = [];
				var checklist = $scope.maps[$scope.selectedType];
				for(var key in checklist){
					for(var task in $scope.tasks){
						if(checklist[key].LLC_BI__Task_Id__c === $scope.tasks[task].Id){
							updateLoadedChecklists($scope.tasks[task].Subject);
						}
					}
				}
			}
		}

		$scope.addChecklistItem = function(){
			if($scope.newChecklistItem.actionItem != null && $scope.newChecklistItem.selected === true){
				$scope.selectedActions.push($scope.newChecklistItem);
				removeFromAvailable($scope.newChecklistItem);
			}
			$scope.newChecklistItem = {};
		}

		$scope.removeSelectedItem = function(){
			if($scope.deleteChecklistItem.actionItem != null && $scope.deleteChecklistItem.selected === false){
				$scope.availableActions.push($scope.deleteChecklistItem);
				removeFromSelected($scope.deleteChecklistItem);
			}
			$scope.deleteChecklistItem = {};
		}

		function sortTasks(){
			for(var task in $scope.tasks){
				var action = {};
				action.actionItem = $scope.tasks[task].Subject;
				action.selected = false;
				action.taskId = $scope.tasks[task].Id;
				if($scope.action.actionItem != null){
					$scope.masterActionList.push(action);
				}
			}
		}

		function sortMaps(){
			$scope.types = [];
			for(var key in $scope.maps){
				$scope.types.push(key);
			}
		}

		function removeFromAvailable(checklistItem){
			var i = $scope.availableActions.indexOf(checklistItem);
			if(i != -1){
				$scope.availableActions.splice(i,1);
			}
		}

		function removeFromSelected(checklistItem){
			var i = $scope.selectedActions.indexOf(checklistItem);
			if(i != -1){
				$scope.selectedActions.splice(i,1);
			}
		}

		function updateLoadedChecklists(adjustableItems) {
			var oldList = $scope.availableActions;
			$scope.availableActions = [];
			angular.forEach(oldList, function(item) {
				if (item.actionItem != adjustableItems){
					$scope.availableActions.push(item);
				} else{
					if(item.actionItem != null){
						$scope.selectedActions.push(item);
					}
				}
			});
		};

}]);
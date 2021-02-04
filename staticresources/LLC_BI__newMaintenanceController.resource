angular.module('newMaintenanceApp')
	.controller('MaintenanceTaskController', ['$scope', 'dataService',
		function($scope, dataService) {

		var vm = this;
		vm.tasks = [];
		vm.typeSubtype = [];
		vm.checklistMap = [];
		vm.types = [];
		vm.modalVisible = false;
		vm.newTask = {};
		vm.task = {};
		vm.signers = [];
		vm.contactName = null;
		vm.init = init;
		vm.sort_by_taskObject = sort_by_taskObject;
		vm.sort_by_percentComplete = sort_by_percentComplete;
		vm.applyDefaultSort = applyDefaultSort;
		vm.changeSorting = changeSorting;
		vm.performSort = performSort;
		vm.addModal = addModal;
		vm.editModal = editModal;
		vm.expand = expand;
		vm.getTask = getTask;
		vm.getTasks = getTasks;
		vm.getTypeSubtype = getTypeSubtype;
		vm.getSigners = getSigners;
		vm.toggleModal = toggleModal;
		vm.upsertTask = upsertTask;
		vm.toggleImage = toggleImage;
		vm.isTasksLoaded= false;
		vm.columnHeaders = [
				{
					label: 'Status',
					name: 'Status'
				},
				{
					label: 'Description',
					name: 'Description'
				},
				{
					label: 'Maintenance Type',
					name: 'SubType__c'
				},
				{
					label: 'Created Date',
					name: 'CreatedDate'
				},
				{
					label: 'Percent Completed',
					name: 'percentComplete'
				}
			];

		vm.sort = {
			column: null,
			descending: false
		};

		vm.init();

		function init() {
			vm.newTask = {};
			var taskIds = [];
			jQuery(window.document).on('show.bs.collapse', function(e) {
				toggleImage(e.target,false)
			});
			jQuery(window.document).on('hide.bs.collapse', function(e) {
				toggleImage(e.target,true);
			});
			dataService.getTasks().then(function(response) {
				vm.tasks = response;

				var foundMatch = false;
				if(vm.tasks != null){
					var search = new RegExp(vm.columnHeaders[2].name , "i");
					for(var i=0; (i<vm.tasks.length && !foundMatch) ; i++){
						keys = _.keys(vm.tasks[i].taskObject);
						var arr = jQuery.grep(keys, function (value) {
							return search.test(value);
						});

						if(arr != null && arr[0] != null){
							vm.columnHeaders[2].name = arr[0];
							foundMatch = true;
						}
					}
				}

				vm.applyDefaultSort();
				vm.isTasksLoaded= true;
			}).catch(function(err){});
			dataService.getTypeSubtype().then(function(response) {
				vm.types = [];
				vm.typeSubtype = angular.fromJson(response);
				for (var key in vm.typeSubtype) {
					vm.types.push(key);
				}
			}).catch(function(err){});
			dataService.getSigners().then(function(response) {
				vm.signers = response;
			}).catch(function(err){});
		}

		function sort_by_taskObject(field, reverse, primer){
			var key = primer ?
				function(x) {return primer(x.taskObject[field])} :
				function(x) {return x.taskObject[field]};

			return function (a, b) {
				return a = key(a), b = key(b), [1, -1][+!!reverse] * ((a > b) - (b > a));
			}
		}

		function sort_by_percentComplete(field, reverse, primer){
			var key = primer ?
				function(x) {return primer(x[field])} :
				function(x) {return x[field]};
			return function (a, b) {
				return a = key(a), b = key(b), [1, -1][+!!reverse] * ((a > b) - (b > a));
			}
		}

		function applyDefaultSort() {
			vm.sort.column = vm.columnHeaders[3].name;
			vm.sort.descending = false;
			performSort();
		}

		function changeSorting(column) {
			if (vm.sort.column == column) {
				vm.sort.descending = !vm.sort.descending;
			} else {
				vm.sort.column = column;
				vm.sort.descending = false;
			}
			performSort();
		}

		function performSort() {
			if(vm.tasks != null && vm.tasks.length > 0){
				if(vm.sort.column != vm.columnHeaders[4].name){
					vm.tasks.sort(
						vm.sort_by_taskObject(vm.sort.column, vm.sort.descending, function(a){
						return (_.isUndefined(a) ? '' : (isNaN(a) ? a.toUpperCase() : a));
					}));
				}
				else {
					vm.tasks.sort(
						vm.sort_by_percentComplete(vm.sort.column, vm.sort.descending, function(a){
						return (_.isUndefined(a) && isNaN(a)) ? -1 : a;
					}));
				}
			}
		}

		function addModal() {
			vm.getTasks();
			vm.toggleModal();
		}

		function editModal(taskId) {
			vm.getTask(taskId);
			vm.addModal();
		}

		function expand(collapseId) {
			jQuery(collapseId).collapse('toggle');
		}

		function toggleImage(currentTarget,open) {
			if(open) {
				jQuery("img[expand-target = '#"+currentTarget.id+"']").attr('src',
					dataService.getResourcePath()+'/assets/icons/utility/chevronright_60.png');
			}else {
				jQuery("img[expand-target = '#"+currentTarget.id+"']").attr('src',
					dataService.getResourcePath()+'/assets/icons/utility/chevrondown_60.png');
			}
		}
		function getTasks() {
			dataService.getTasks().then(function(response) {
				vm.tasks = response;
			});
		}

		function getTask(taskId) {
			dataService.getTask(taskId).then(function(response) {
				vm.newTask = response;
			});
		}

		function getTypeSubtype() {
			dataService.getTypeSubtype().then(function(response) {
				vm.typeSubtype = response;
			});
		}

		function getSigners() {
			dataService.getSigners().then(function(response) {
				vm.signers = response;
			});
		}

		function toggleModal() {
			vm.modalVisible = !vm.modalVisible;
		}

		function upsertTask(isSaveAndNew) {
			for (var contact in vm.signers) {
				if(contact.Name === vm.contactName){
					vm.newTask.WhoId = contact.Id;
				}
			}
			if(vm.newTask.RecurrenceStartDateOnly != null){
				vm.newTask.RecurrenceStartDateOnly = Date.parse(vm.newTask.RecurrenceStartDateOnly);
			}
			if (vm.contactName !== null && vm.newTask.Maintenance_Type__c !== null) {
				dataService.upsertTask(vm.newTask).then(function(response) {
					vm.modalVisible = isSaveAndNew;
					vm.init();
				});
			}
		}

		function assignWhoId() {
			for (var contact in vm.signers) {
				if(contact.Name === vm.contactName){
					vm.newTask.WhoId = contact.Id;
				}
			}
		}

		function assignContactName(contactId) {
			for (var contact in vm.signers) {
				if(contact.Id === contactName){
					vm.contactName = contact.Name;
				}
			}
		}

}]).filter('split', function() {
	return function(objList, delimeter, fieldName) {
		if(objList.length == 0){
			return '';
		}
		var returnList = [];
		for(i = 0; i < objList.length; i++) {
			returnList = returnList.concat(objList[i][fieldName].split(delimeter));
		}
		return returnList.sort();
	}
}).filter('cmdate', [
	'$filter', function($filter) {
		return function(input, format) {
			return $filter('date')(new Date(input), format);
		};
	}
]).filter('unique', function() {
	return function(objList, fieldName) {
		var uniqueItems = [];
		for(i = 0; i < objList.length; i++) {
			if(uniqueItems.indexOf(objList[i][fieldName]) < 0) {
				uniqueItems.push(objList[i][fieldName]);
			}
		}
		return uniqueItems.sort();
	}
});
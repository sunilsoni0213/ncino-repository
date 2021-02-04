angular.module('selfRegisterApp')
	.controller('OwnersController', ['$rootScope', '$scope', 'label', 'ownersDataService',
		'helperService', 'NAV_EVENTS', 'MESSAGE_CONSTANTS', 'applicationFactory',
		function($rootScope, $scope, label, ownersDataService, helperService, NAV_EVENTS, MESSAGE_CONSTANTS,
			applicationFactory) {

		var vm = this;
		vm.label = label.getLabels();
		vm.applicationId = '';
		vm.owners = [];
		vm.ownersRoute = {};
		vm.appName = '';
		vm.productId = null;
		vm.onlineFormSubmitted = false;
		vm.removeDialog = {
			isRendered: false,
			context: null,
			labels: {
				header: vm.label.Remove_Owner_Confirm_Header,
				body: vm.label.Remove_Owner_Confirm_Body,
				cancel: vm.label.Remove_Owner_Confirm_No,
				confirm: vm.label.Remove_Owner_Confirm_Yes
			},
			confirm: function() {
				vm.removeDialog.isRendered = false;
				vm.removeOwner(vm.removeDialog.context);
			},
			cancel: function() {
				vm.removeDialog.isRendered = false;
			}
		};

		vm.init = init;
		vm.getId = getId;
		vm.loadUrlParameters = loadUrlParameters;
		vm.retrieveOwners = retrieveOwners;
		vm.getFullName = getFullName;
		vm.getAddress = getAddress;
		vm.showRemoveOwnerDialog = showRemoveOwnerDialog;
		vm.removeOwner = removeOwner;
		vm.saveOwners = saveOwners;
		vm.addOwner = addOwner;
		vm.getOwnersRoute = getOwnersRoute;

		vm.init();

		function init() {
			vm.getId();
			vm.loadUrlParameters();
		}

		function getId() {
			vm.applicationId = helperService.getParameterByName('id');
		}

		function loadUrlParameters() {
			vm.appName = helperService.getAppName();
			vm.productId = helperService.getParameterByName('productId');
		}

		function retrieveOwners(isLiveLoad) {
			if (vm.applicationId) {
				ownersDataService.retrieveOwners(vm.applicationId, isLiveLoad).then(function(response) {
					if (response != null) {
						vm.owners = JSON.parse(response);
					}
				});
			}
		}

		function getFullName(owner) {
			return owner.firstName + ' ' + owner.lastName;
		}

		function getAddress(owner) {
			var address = '';
			if (owner.street) {
				address = owner.street
			}
			if (owner.city) {
				address += (address.length > 0 ? ' ' : '') + owner.city;
			}
			if (owner.state) {
				address += (address.length > 0 ? ', ' : '') + owner.state;
			}
			if (owner.zip) {
				address += (address.length > 0 ? ' ' : '') + owner.zip;
			}
			return address;
		}

		function showRemoveOwnerDialog(index) {
			vm.removeDialog.isRendered = true;
			vm.removeDialog.context = index;
		}

		function removeOwner(index) {
			vm.owners.splice(index, 1);
		}

		function saveOwners(route) {
			vm.onlineFormSubmitted = true;
			if ($scope.onlineFormForm.$valid) {
				var loaderID = helperService.showLoader(vm.label.Application_Save_Message);
				ownersDataService.saveOwners(angular.toJson(route), angular.toJson(vm.owners), vm.applicationId).then(function(response) {
					helperService.hideLoader(loaderID);
					if (response.type && response.type === 'exception') {
						helperService.hideLoader(loaderID);
						helperService.showMessage(vm.label.Owners_Save_Error, MESSAGE_CONSTANTS.TYPE_ERROR);
					}
					else {
						applicationFactory.handleSaveEvent(JSON.parse(response));
					}
				});
			}
		}

		function addOwner() {
			var owner = {
				firstName: '',
				lastName: '',
				email: '',
				mobile: '',
				street: '',
				city: '',
				state: '',
				zip: ''
			};
			vm.owners.push(owner);
		}

		function getOwnersRoute() {
			ownersDataService.getOwnersRoute(vm.applicationId).then(function(response) {
				if (response.type && response.type === 'exception') {
					helperService.showMessage(vm.label.Owners_Route_Error, MESSAGE_CONSTANTS.TYPE_ERROR);
				}
				else {
					vm.ownersRoute = JSON.parse(response);
				}
			});
		}
}]);
angular.module('selfRegisterApp')
	.constant('REG_CONSTANTS', {
		'NEW_APP_HASH': '#newApp',
		'EMAIL_HASH': '#confirmation'
	})
	.controller('SelfRegisterController', ['$scope', 'label', 'dataService', 'helperService', 'REG_CONSTANTS', 'MESSAGE_CONSTANTS',
		function($scope, label, dataService, helperService, REG_CONSTANTS, MESSAGE_CONSTANTS) {

		var vm = this;
		vm.label = label.getLabels();
		vm.modalVisible = false;
		vm.showEmailConfirmation = false;
		vm.emailResent = false;
		vm.portalUser = {
			firstName: '',
			lastName: '',
			email: '',
			mobile: '',
			regFields: []
		};
		vm.prelimSubmitted = false;
		vm.prelimValid = false;
		vm.login = {
			username: '',
			password: '',
			isFailed: false
		};
		vm.loginSubmitted = false;
		vm.securityBadges = [];
		vm.imageServerURL = '';
		vm.productOptions = [];
		vm.selectedProduct = {};
		vm.productLinked = false;
		vm.captchaSettings = {};
		vm.captchaResponse = '';
		vm.onlineAppsEnabled = true;

		vm.init = init;
		vm.getRegistrationFields = getRegistrationFields;
		vm.registerUser = registerUser;
		vm.performLogin = performLogin;
		vm.toggleModal = toggleModal;
		vm.handleURLHash = handleURLHash;
		vm.resendEmail = resendEmail;
		vm.getProductOptions = getProductOptions;
		vm.applySelectedProduct = applySelectedProduct;
		vm.getURL = getURL;
		vm.retrieveCaptchaSettings = retrieveCaptchaSettings;
		vm.getOnlineAppsEnabled = getOnlineAppsEnabled;
		vm.redirectToLogin = redirectToLogin;

		vm.init();

		function init() {
			vm.portalUser = {};
			vm.handleURLHash(window.location.hash);
			vm.getRegistrationFields();
			vm.getProductOptions();
			vm.retrieveCaptchaSettings();
			vm.getOnlineAppsEnabled();
		}

		function getRegistrationFields() {
			dataService.getRegistrationFields().then(function(response) {
				vm.portalUser.regFields = response;
			});
		}

		function registerUser() {
			if (vm.captchaSettings.isEnabled && !vm.captchaResponse) {
				helperService.showMessage(
					vm.label.Error_Captcha_Validation,
					MESSAGE_CONSTANTS.TYPE_WARNING
				);
				return;
			}

			vm.prelimSubmitted = true;

			if (!$scope.prelimForm.$valid || (vm.onlineAppsEnabled && !vm.selectedProduct.sid)) {
				return;
			}

			var loaderID = helperService.showLoader();
			vm.prelimValid = true;
			dataService.registerUser(JSON.stringify(vm.portalUser), vm.selectedProduct.sid || '').then(function(response) {
				helperService.hideLoader(loaderID);
				if (response.type && response.type === 'exception') {
					helperService.showMessage(
						vm.label.Self_Registration_Error,
						MESSAGE_CONSTANTS.TYPE_ERROR
					);
				}
				else if (response != null && response != 'false' && response != false) {
					vm.showEmailConfirmation = true;
					window.location.hash = REG_CONSTANTS.EMAIL_HASH;
				}
				else {
				   toggleModal();
				}
			});
		}

		function performLogin() {
			vm.loginSubmitted = true;
			if (!$scope.loginForm.$valid) {
				return;
			}

			var loaderID = helperService.showLoader();
			dataService.login(vm.login.username, vm.login.password, vm.selectedProduct.sid).then(function(response) {
				vm.login.isFailed = response == null;
				if (vm.login.isFailed) {
					// Hide loader if the login failed
					helperService.hideLoader(loaderID);
				}
				else {
					// Ensure the user has correct sharing. They can lose this if deactivated.
					dataService.ensureUserSharing(vm.login.username).then(function(wasReactivated) {
						window.top.location.href = response;
					});
				}
			});
		}

		function toggleModal() {
			vm.modalVisible = true;
		}

		function handleURLHash(hash) {
			if (hash === REG_CONSTANTS.NEW_APP_HASH) {
				vm.showEmailConfirmation = false;
			}
			else if (hash === REG_CONSTANTS.EMAIL_HASH) {
				if (vm.prelimValid) {
					vm.showEmailConfirmation = true;
				}
			}
		}

		function resendEmail() {
			if (vm.portalUser.email && vm.portalUser.email.length > 0) {
				dataService.resendEmail(vm.portalUser.email).then(function(response) {
					vm.emailResent = (response == true);
				});
			}
		}
		function getProductOptions() {
			dataService.getApplicationTypes().then(function(response) {
				vm.productOptions = JSON.parse(response);
				vm.applySelectedProduct();
			});
		}

		function getURL() {
			return window.location.href;
		}

		function applySelectedProduct() {
			var linkedProduct = helperService.getParameterByName('product');
			if (linkedProduct) {
				vm.productOptions.forEach(function(productOption) {
					if (linkedProduct.toLowerCase().substring(0, 15) === productOption.sid.toLowerCase().substring(0, 15)) {
						vm.productLinked = true;
						vm.selectedProduct = productOption;
						return;
					}
				});
			}
		}

		function retrieveCaptchaSettings() {
			dataService.retrieveCaptchaSettings().then(function(response) {
				if (response.type && response.type === 'exception') {
					helperService.showMessage(
						vm.label.Error_Retrieve_Captcha_Settings,
						MESSAGE_CONSTANTS.TYPE_ERROR
					);
				}
				else if (response != null) {
					vm.captchaSettings = JSON.parse(response);
				}
			});
		}

		function getOnlineAppsEnabled() {
			dataService.getOnlineAppsEnabled().then(function(response) {
				if (response.type && response.type === 'exception') {
					console.log('An error occurred retrieving the online applications enabled setting.');
				}
				else if (response != null) {
					vm.onlineAppsEnabled = response;
				}
			});
		}

		function redirectToLogin(url) {
			if (vm.selectedProduct.sid) {
				url = url + '?product=' + vm.selectedProduct.sid;
			}
			helperService.setWindowURL(url);
		}
}]);
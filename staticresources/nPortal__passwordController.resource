angular.module('selfRegisterApp')
	.controller('PasswordController', ['$scope', 'label', 'dataService',
		'helperService', 'MESSAGE_CONSTANTS',
		function($scope, label, dataService, helperService, MESSAGE_CONSTANTS) {

		var vm = this;
		vm.label = label.getLabels();
		vm.isInternalChange = false;
		vm.email = '';
		vm.siteUrl = '';
		vm.passwordRegex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!#$%\-_=+<>]).{8,}$/;
		vm.uppercaseRegex = /[A-Z]/;
		vm.lowercaseRegex = /[a-z]/;
		vm.numberRegex = /\d/;
		vm.specialCharacterRegex = /[!#$%\-_=+<>]/;
		vm.oldPassword = '';
		vm.newPassword = '';
		vm.confirmPassword = '';
		vm.changePasswordSubmitted = false;
		vm.passwordReset = false;

		vm.init = init;
		vm.loadUrlParameters = loadUrlParameters;
		vm.hasMinimumChars = hasMinimumChars;
		vm.hasLowercaseCharacter = hasLowercaseCharacter;
		vm.hasUppercaseCharacter = hasUppercaseCharacter;
		vm.hasNumber = hasNumber;
		vm.hasSpecialCharacter = hasSpecialCharacter;
		vm.isValidPassword = isValidPassword;
		vm.isPasswordMatch = isPasswordMatch;
		vm.submitPasswordChange = submitPasswordChange;
		vm.setWindowURL = setWindowURL;
		vm.resetPassword = resetPassword;

		vm.init();

		function init() {
			vm.loadUrlParameters();
		}

		function loadUrlParameters() {
			if (helperService.getParameterByName('retURL')) {
				vm.isInternalChange = false;
			}
			else {
				vm.isInternalChange = true;
			}
		}

		function hasMinimumChars() {
			return vm.newPassword && vm.newPassword.length >= 8;
		}

		function hasLowercaseCharacter() {
			return vm.newPassword && vm.lowercaseRegex.test(vm.newPassword);
		}

		function hasUppercaseCharacter() {
			return vm.newPassword && vm.uppercaseRegex.test(vm.newPassword);
		}

		function hasNumber() {
			return vm.newPassword && vm.numberRegex.test(vm.newPassword);
		}

		function hasSpecialCharacter() {
			return vm.newPassword && vm.specialCharacterRegex.test(vm.newPassword);
		}

		function isValidPassword() {
			return (vm.newPassword && vm.passwordRegex.test(vm.newPassword));
		}

		function isPasswordMatch() {
			return (vm.confirmPassword == vm.newPassword);
		}

		function submitPasswordChange() {
			var loaderID = helperService.showLoader();
			dataService.setPassword(vm.newPassword, vm.isInternalChange).then(function(response) {
				if (response.type && response.type == 'exception') {
					helperService.hideLoader(loaderID);
					helperService.showMessage(vm.label.Change_Password_Error, MESSAGE_CONSTANTS.TYPE_ERROR,
						vm.label.Change_Password_Error_Subtext);
				}
				else {
					vm.changePasswordSubmitted = true;
					vm.setWindowURL(response);
				}
			});
		}

		function setWindowURL(url) {
			window.location.href = url;
		}

		function resetPassword() {
			var loaderID = helperService.showLoader(vm.label.Forgot_Password_Progress);
			dataService.resetPassword(vm.email).then(function(response) {
				if (response != null && response == true) {
					helperService.hideLoader(loaderID);
					vm.passwordReset = true;
				}
				else {
					helperService.hideLoader(loaderID);
					helperService.showMessage(vm.label.Forgot_Password_Error, MESSAGE_CONSTANTS.TYPE_ERROR,
						vm.label.Forgot_Password_Error_Subtext);
				}
			});
		}
}]);
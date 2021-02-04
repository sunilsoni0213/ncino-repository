angular.module('selfRegisterApp')
	.controller('portalEidVerificationController', ['$scope', 'EidVerificationService', 'helperService', 'label',
	function($scope, EidVerificationService, helperService, label) {
		var vm = this;
		vm.label = label.getLabels();
		vm.responses = [];
		vm.mockQuestions = {
			questions: [
				{
					questionId: 0,
					questionText: 'Your credit file indicates that you may have an auto loan/lease, opened in or ' +
					'around April 2012. Who is the credit provider for this account?',
					questionResponses: [
						'BANK OF AMERICA',
						'CHASE',
						'ORION FINANCIAL',
						'NISSAN FINANCE',
						'NONE OF THE ABOVE'
					]
				},
				{
					questionId: 1,
					questionText: 'What is the total monthly payment for the above-referenced account?',
					questionResponses: [
						'$125 - $174',
						'$175 - $224',
						'$225 - $274',
						'$275 - $324',
						'NONE OF THE ABOVE'
					]
				},
				{
					questionId: 2,
					questionText: 'Your credit file indicates that you may have a student loan, opened in ' +
					'or around November 2008. Who is the credit provider for this account?',
					questionResponses: [
						'CITI STUDENT LOANS',
						'SALLIE MAE',
						'GREAT LAKES',
						'FEDLOAN SERVICING',
						'NONE OF THE ABOVE'
					]
				},
				{
					questionId: 3,
					questionText: 'What is the total monthly payment for the above-referenced account?',
					questionResponses: [
						'$50-$74',
						'$75-$99',
						'$100-$124',
						'$125-$149',
						'NONE OF THE ABOVE'
					]
				}
			]
		};

		vm.init = init;
		vm.getVerificationQuestions = getVerificationQuestions;

		vm.transactionLogId = '';
		vm.responseMsg = '';

		vm.init();

		function getVerificationQuestions() {
			EidVerificationService.getVerificationQuestions().then(function(response) {
				var responseJson = JSON.parse(response);
				vm.transactionLogId = responseJson.transactionLogId;
			});
		}

		function init() {
			// vm.getVerificationQuestions();
			// TODO:
			// This remote call invokes the SendService, RelationshipService, and creates the Transaction Log that we
			// will need to poll when we resume EID implementation. It is being removed here to avoid dependency on the
			// plugin for demo purposes.
		}
 }]);
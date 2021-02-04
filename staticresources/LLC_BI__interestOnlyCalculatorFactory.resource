(function() {
	angular.module('ncRateAndPayment')
	.factory('interestOnlyCalculatorFactory', ['PaymentCalculatorFactory',

	function(PaymentCalculatorFactory) {

		var InterestOnlyCalculatorFactory = Object.create(PaymentCalculatorFactory);

		InterestOnlyCalculatorFactory.calculatePayment = function(remainingBalance, remainingLoanTerm, remainingAmortization, rate, extraPayment, desiredBalloon) {

			var payment = null;

			if(this.arePaymentInputsValid(remainingBalance, rate)) {

				extraPayment = this.processExtraPayment(extraPayment);
				payment = this.roundToCents(remainingBalance * rate + extraPayment);
			}

			return payment;
		};

		InterestOnlyCalculatorFactory.calculateAmortizationPayment = function(tablePaymentNumber, streamPaymentNumber, principalFrequency, paymentDateMoment, currentPayment, streamComponent, interestRate, paymentAmount, balance, interestFrequency) {


			if (currentPayment.isLastPayment){
				currentPayment.extraPayment = 0;
				currentPayment.principal = this.roundToCents(balance);
				currentPayment.totalPayment = this.roundToCents(currentPayment.principal + currentPayment.interest);
				currentPayment.balance = this.roundToCents(balance - currentPayment.principal);

			} else {
				currentPayment.principal = 0;
				currentPayment.totalPayment = this.roundToCents(currentPayment.principal +  currentPayment.interest + currentPayment.extraPayment);
				currentPayment.balance = this.roundToCents(balance - currentPayment.extraPayment);
			}
		};

		InterestOnlyCalculatorFactory.getBaseFrequency = function(streamComponent) {
			return streamComponent.interestPaymentFrequency;
		};

		return InterestOnlyCalculatorFactory;

	}]);
})();
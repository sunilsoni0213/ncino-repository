(function() {
	angular.module('ncRateAndPayment')
	.factory('pPlusICalculatorFactory', ['PaymentCalculatorFactory',

	function(PaymentCalculatorFactory) {

		var PplusICalculatorFactory = Object.create(PaymentCalculatorFactory);

		PplusICalculatorFactory.arePaymentInputsValid = function(amount, rate, numberOfAmortizationPeriods) {
			return PaymentCalculatorFactory.arePaymentInputsValid(amount, rate) &&
					 numberOfAmortizationPeriods &&
					 numberOfAmortizationPeriods > 0;
		};

		PplusICalculatorFactory.calculatePayment = function(remainingBalance, remainingLoanTerm, remainingAmortization, rate, extraPayment, desiredBalloon) {

			var payment = NaN;

			if(this.arePaymentInputsValid(remainingBalance, rate, remainingAmortization)) {

				if(desiredBalloon){
					payment = this.roundToCents((remainingBalance - desiredBalloon) / remainingLoanTerm);
				} else {
					payment = this.roundToCents(remainingBalance / remainingAmortization);
				}

				payment += this.processExtraPayment(extraPayment);
			}

			return payment;
		};

		PplusICalculatorFactory.calculateAmortizationPayment = function(tablePaymentNumber, streamPaymentNumber, principalFrequency, paymentDateMoment, currentPayment, streamComponent, interestRate, paymentAmount, balance, interestFrequency) {

			if(isInterestOnlyPayment(streamPaymentNumber, interestFrequency, principalFrequency)) {
				currentPayment.extraPayment = 0;
				currentPayment.principal = 0;
				currentPayment.totalPayment = this.roundToCents(currentPayment.principal + currentPayment.interest + currentPayment.extraPayment);
				currentPayment.balance = this.roundToCents(balance - currentPayment.principal - currentPayment.extraPayment);
				return;
			}

			currentPayment.principal = currentPayment.hasPrincipalPayment ? paymentAmount : 0;

			if (currentPayment.isLastPayment) {

				currentPayment.extraPayment = 0;
				currentPayment.principal = this.roundToCents(balance);
				currentPayment.totalPayment = this.roundToCents(currentPayment.principal + currentPayment.interest);
				currentPayment.balance = this.roundToCents(balance - currentPayment.principal);

			} else if (currentPayment.principal > balance) {

				currentPayment.principal = this.roundToCents(balance - currentPayment.extraPayment);
				currentPayment.totalPayment = this.roundToCents(currentPayment.principal + currentPayment.interest + currentPayment.extraPayment);
				currentPayment.balance = this.roundToCents(balance - currentPayment.principal - currentPayment.extraPayment);

			} else {

				currentPayment.principal = this.roundToCents(currentPayment.principal - currentPayment.extraPayment);
				currentPayment.totalPayment = this.roundToCents(currentPayment.principal + currentPayment.interest + currentPayment.extraPayment);
				currentPayment.balance = this.roundToCents(balance - currentPayment.principal - currentPayment.extraPayment);
			}
		};

		PplusICalculatorFactory.getBaseFrequency = function(streamComponent) {

			var interest = streamComponent.interestPaymentFrequency;
			var principal = streamComponent.principalPaymentFrequency;

			return (interest.frequency > principal.frequency ? interest : principal);
		};

		function isInterestOnlyPayment(paymentNumber, interestFrequency, principalFrequency) {

			return (paymentNumber % (Math.round(interestFrequency.frequency/principalFrequency.frequency)) != 0);
		}

		return PplusICalculatorFactory;

	}]);

})();
(function() {
	angular.module('ncRateAndPayment')
	.factory('pAndICalculatorFactory', ['PaymentCalculatorFactory',

	 function(PaymentCalculatorFactory) {

		var PandICalculatorFactory = Object.create(PaymentCalculatorFactory);

		PandICalculatorFactory.arePaymentInputsValid = function(amount, rate, numberOfAmortizationPeriods) {
			return PaymentCalculatorFactory.arePaymentInputsValid(amount, rate) &&
					 numberOfAmortizationPeriods &&
					 numberOfAmortizationPeriods > 0;
		};

		PandICalculatorFactory.calculatePayment = function(remainingBalance, remainingLoanTerm, remainingAmortization, rate, extraPayment, desiredBalloon) {

			var payment = NaN;

			if (rate !== null && +rate === 0) {

				if(desiredBalloon){
					payment = (remainingBalance - desiredBalloon) / remainingLoanTerm;
				} else {
					payment = remainingBalance / remainingAmortization;
				}
			} else if(this.arePaymentInputsValid(remainingBalance, rate, remainingAmortization)){

				var numerator;
				var denominator;
				if(desiredBalloon) {
					numerator = (remainingBalance * Math.pow(1 + (+rate), remainingLoanTerm) - desiredBalloon) * rate;
					denominator = (Math.pow(1 + (+rate), remainingLoanTerm) - 1);
				} else {
					numerator = (remainingBalance * Math.pow(1 + (+rate), remainingAmortization)) * rate;
					denominator = (Math.pow(1 + (+rate), remainingAmortization) - 1);
				}

				extraPayment = this.processExtraPayment(extraPayment);

				payment = numerator / denominator + extraPayment;
			}

			return payment;
		};

		PandICalculatorFactory.calculateAmortizationPayment = function(tablePaymentNumber, streamPaymentNumber, principalFrequency, paymentDateMoment, currentPayment, streamComponent, interestRate, paymentAmount, balance, interestFrequency, interestAccrualMethod) {

			currentPayment.totalPayment = this.roundToCents(paymentAmount);

			if (currentPayment.isLastPayment) {

				currentPayment.extraPayment = 0;
				currentPayment.principal = this.roundToCents(balance);
				currentPayment.totalPayment = this.roundToCents(currentPayment.principal + currentPayment.interest);
				currentPayment.balance = this.roundToCents(balance - currentPayment.principal);

			} else if (currentPayment.totalPayment > balance) {

				currentPayment.principal = this.roundToCents(balance - currentPayment.extraPayment);
				currentPayment.totalPayment = this.roundToCents(currentPayment.principal + currentPayment.interest + currentPayment.extraPayment);
				currentPayment.balance = this.roundToCents(balance - currentPayment.principal - currentPayment.extraPayment);

			} else {

				if(tablePaymentNumber == 1) {

					var mockFirstPaymentInterestAccrualMethod = '30_' + interestAccrualMethod.split("_")[1];
					var mockLastPayDateInterest = this.getCalculatedInterestPayment(tablePaymentNumber, streamComponent, interestRate, balance, null, paymentDateMoment, mockFirstPaymentInterestAccrualMethod);
					currentPayment.principal = this.roundToCents(currentPayment.totalPayment - mockLastPayDateInterest - currentPayment.extraPayment);
					currentPayment.totalPayment = this.roundToCents(currentPayment.principal + currentPayment.interest + currentPayment.extraPayment);

				} else {
					currentPayment.principal = this.roundToCents(currentPayment.totalPayment - currentPayment.interest - currentPayment.extraPayment);
				}
				currentPayment.balance = this.roundToCents(balance - currentPayment.principal - currentPayment.extraPayment);
			}
		};

		PandICalculatorFactory.getBaseFrequency = function(streamComponent) {
			return streamComponent.principalPaymentFrequency;
		};

		return PandICalculatorFactory;
	}]);
})();

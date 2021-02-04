"use strict";
(function() {
	angular
		.module('ncRateAndPayment')
		.factory('PandIStream', ['$filter', 'PaymentStream',
										  'unitAndFrequencyConverter', 'pAndICalculatorFactory', 'label',

	function($filter, PaymentStream, unitAndFrequencyConverter, pAndICalculatorFactory, label) {

		var intl = window.LifeCycle.Internationalize;
		function PandIStream(object){
			PaymentStream.call(this, object);
		}

		PandIStream.prototype = Object.create(PaymentStream.prototype);

		PandIStream.prototype.calculateAmortization = function(loan, amortizationUnit, existingAmortizationTable) {

			var streamComponent = this.components[0];

			streamComponent.interestPaymentFrequency = streamComponent.frequency;
			streamComponent.principalPaymentFrequency = streamComponent.frequency;

			var rate = this.getWeightedRate(streamComponent);
			this.calculatePayment(loan, amortizationUnit, rate);

			var periodUnit = unitAndFrequencyConverter.getUnitForFrequency(streamComponent.frequency);
			var numPeriods = unitAndFrequencyConverter.convertUnit(this.termLength, this.termUnit, periodUnit);

			var monthUnit = _.findWhere(unitAndFrequencyConverter.getUnits(), {frequency: 12});
			var isLastStream = (loan.remainingLoanTerm - this.getTermLength(monthUnit)) == 0;

			var amortizationTable = pAndICalculatorFactory.calculateAmortization(
																				streamComponent,
																				numPeriods,
																				loan.accrualMethod,
																				loan.remainingBalance,
																				this.effectiveDate,
																				isLastStream,
																				this.extraPayment,
																				rate,
																				loan.projectedCloseDate,
																				existingAmortizationTable);

			this._endingBalance = pAndICalculatorFactory.getRemainingBalance(amortizationTable);

			return amortizationTable;
		};

		PandIStream.prototype.calculatePayment = function(loan, amortizationUnit, periodRate) {

			var paymentUnit = unitAndFrequencyConverter.getUnitForFrequency(this.components[0].frequency);
			var numAmortPeriods = unitAndFrequencyConverter.convertUnit(loan.remainingAmortization, amortizationUnit, paymentUnit);
			var numLoanPeriods = unitAndFrequencyConverter.convertUnit(loan.remainingLoanTerm, amortizationUnit, paymentUnit);

			var paymentAmount = pAndICalculatorFactory.calculatePayment(loan.remainingBalance, numLoanPeriods, numAmortPeriods, periodRate, this.extraPayment, loan.desiredBalloon);

			this.components[0].amount = !isNaN(paymentAmount) ? paymentAmount : 0;
		};

		PandIStream.prototype.updateStreamName = function() {

			var summary = "";
			if(this.canDisplaySummary()){
				summary = this.formatSummaryOutput(label.getLabels().P_And_I_Stream_Summary, [
					this.components[0].frequency.label.toLowerCase(),
					intl.format(this.components[0].amount, 'C2'),
					this.termLength,
					this.getTermUnitLabel()
				]);
			}

			this.name = summary;
		};

		PandIStream.prototype.checkLoanInputs = function(loan){

			var errorMessage = PaymentStream.prototype.checkLoanInputs(loan);

			if(!loan.amortizationTerm){
				errorMessage = this.formatSummaryOutput(
					label.getLabels().Amortization_Term_Stream_Error,
					[label.getLabels().Principal_and_Interest]
				);
			}

			return errorMessage;
		};

		return PandIStream;

	}]);
})();
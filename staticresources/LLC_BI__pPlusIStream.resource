"use strict";
(function() {
	angular
		.module('ncRateAndPayment')
		.factory('PplusIStream', ['$filter', 'PaymentStream',
										  'unitAndFrequencyConverter', 'pPlusICalculatorFactory', 'label',

	function($filter, PaymentStream, unitAndFrequencyConverter, pPlusICalculatorFactory, label) {

		var intl = window.LifeCycle.Internationalize;
		function PplusIStream(object){
			PaymentStream.call(this, object);
		}

		PplusIStream.prototype = Object.create(PaymentStream.prototype);

		PplusIStream.prototype.calculateAmortization = function(loan, amortizationUnit, existingAmortizationTable) {

			var streamComponent = this.components[0];

			var baseFrequency = pPlusICalculatorFactory.getBaseFrequency(streamComponent);

			var rate = this.getWeightedRate(streamComponent);
			var periodUnit = unitAndFrequencyConverter.getUnitForFrequency(baseFrequency);
			var numPeriods = unitAndFrequencyConverter.convertUnit(this.termLength, this.termUnit, periodUnit);

			var monthUnit = _.findWhere(unitAndFrequencyConverter.getUnits(), {frequency: 12});
			var isLastStream = (loan.remainingLoanTerm - this.getTermLength(monthUnit)) == 0;

			var amortizationTable = pPlusICalculatorFactory.calculateAmortization(
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

			this._endingBalance = pPlusICalculatorFactory.getRemainingBalance(amortizationTable);

			return amortizationTable;
		};

		PplusIStream.prototype.calculatePayment = function(loan, amortizationUnit)  {

			this.components[0].frequency = this.components[0].principalPaymentFrequency;
			var paymentUnit = unitAndFrequencyConverter.getUnitForFrequency(this.components[0].frequency);
			var numLoanPeriods = unitAndFrequencyConverter.convertUnit(loan.remainingLoanTerm, amortizationUnit, paymentUnit);
			var numAmortPeriods = unitAndFrequencyConverter.convertUnit(loan.remainingAmortization, amortizationUnit, paymentUnit);

			var basePayment = pPlusICalculatorFactory.calculatePayment(loan.remainingBalance, numLoanPeriods, numAmortPeriods, 1.0, this.extraPayment, loan.desiredBalloon);

			this.components[0].amount = !isNaN(basePayment) ? basePayment : 0;
		};

		PplusIStream.prototype.updateStreamName = function() {

			var summary = "";
			if (this.canDisplaySummary()) {
				summary = this.formatSummaryOutput(label.getLabels().P_Plus_I_Stream_Summary, [
					this.components[0].principalPaymentFrequency.label.toLowerCase(),
					intl.format(this.components[0].amount, 'C2'),
					this.termLength,
					this.getTermUnitLabel()
				]);
			}

			this.name = summary;
		};

		PplusIStream.prototype.checkLoanInputs = function(loan){

			var errorMessage = PaymentStream.prototype.checkLoanInputs(loan);

			if (!loan.amortizationTerm) {
				errorMessage = this.formatSummaryOutput(
					label.getLabels().Amortization_Term_Stream_Error,
					[label.getLabels().Principal_plus_Interest]
				);
			}

			return errorMessage;
		};

		return PplusIStream;
	}]);
})();
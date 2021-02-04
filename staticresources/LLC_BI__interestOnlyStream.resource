"use strict";
(function() {
	angular
		.module('ncRateAndPayment')
		.factory('InterestOnlyStream', ['$filter', 'PaymentStream',
												  'unitAndFrequencyConverter', 'interestOnlyCalculatorFactory', 'label',

	function($filter, PaymentStream, unitAndFrequencyConverter, interestOnlyCalculatorFactory, label) {

		var intl = window.LifeCycle.Internationalize;
		function InterestOnlyStream(object){
			PaymentStream.call(this, object);
		}

		InterestOnlyStream.prototype = Object.create(PaymentStream.prototype);

		InterestOnlyStream.prototype.calculateAmortization = function(loan, amortizationUnit, existingAmortizationTable) {

			var streamComponent = this.components[0];
			streamComponent.interestPaymentFrequency = streamComponent.frequency;
			streamComponent.principalPaymentFrequency = streamComponent.frequency;

			var rate = this.getWeightedRate(streamComponent);
			this.calculatePayment(loan, amortizationUnit, rate);

			var periodUnit = unitAndFrequencyConverter.getUnitForFrequency(this.components[0].frequency);
			var numPeriods = unitAndFrequencyConverter.convertUnit(this.termLength, this.termUnit, periodUnit);

			var monthUnit = _.findWhere(unitAndFrequencyConverter.getUnits(), {frequency: 12});
			var isLastStream = (loan.remainingLoanTerm - this.getTermLength(monthUnit)) == 0;

			var amortizationTable = interestOnlyCalculatorFactory.calculateAmortization(
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

			this._endingBalance = interestOnlyCalculatorFactory.getRemainingBalance(amortizationTable);

			return amortizationTable;
		};

		InterestOnlyStream.prototype.calculatePayment = function(loan, amortizationUnit, periodRate) {

			var paymentUnit = unitAndFrequencyConverter.getUnitForFrequency(this.components[0].frequency);
			var numPeriods = unitAndFrequencyConverter.convertUnit(loan.remainingAmortization, amortizationUnit, paymentUnit);
			var payment = interestOnlyCalculatorFactory.calculatePayment(loan.remainingBalance, numPeriods, numPeriods, periodRate, this.extraPayment);

			this.components[0].amount = (!isNaN(payment) && payment != null) ? payment : 0;
		};

		InterestOnlyStream.prototype.updateStreamName = function() {

			var summary = "";
			if(this.canDisplaySummary()){
				summary = this.formatSummaryOutput(label.getLabels().Interest_Only_Stream_Summary, [
					intl.format(this.components[0].amount, 'C2'),
					this.termLength,
					this.getTermUnitLabel()
				]);
			}

			this.name = summary;
		};

		return InterestOnlyStream;
	}]);
})();
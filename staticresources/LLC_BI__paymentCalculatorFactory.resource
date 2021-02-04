(function() {
	angular.module('ncRateAndPayment')
	.factory('PaymentCalculatorFactory', ['unitAndFrequencyConverter', 'label', 'PaymentStream', 

	function(unitAndFrequencyConverter, label, PaymentStream) {

		var Payment = function(period, paymentDate, extraPayment) {
			this.period = period;
			this.paymentDate = paymentDate;
			this.principal = null;
			this.extraPayment = processExtraPayment(extraPayment);
			this.interest = null;
			this.totalPayment = null;
			this.balance = null;
			this.isLastPayment = null;
			this.hasPrincipalPayment = true;
		};

		var complexDateStructure = {};
		var paymentTable = [];


		return {
			arePaymentInputsValid: arePaymentInputsValid,
			areAmortizationInputsValid: areAmortizationInputsValid,
			processExtraPayment: processExtraPayment,
			calculateAmortization: calculateAmortization,
			getPaymentDate: getPaymentDate,
			getRemainingBalance: getRemainingBalance,
			getBalloonPayment: getBalloonPayment,
			initializeFirstPaymentMoment: initializeFirstPaymentMoment,
			getCalculatedInterestPayment: getCalculatedInterestPayment,
			roundToCents: roundToCents
		};

		function arePaymentInputsValid(amount, rate) {
			return amount !== null && amount !== undefined && amount >= 0 &&
					 rate !== null && rate !== undefined && rate >= 0;
		}

		function areAmortizationInputsValid(numberOfLoanPeriods){
			return numberOfLoanPeriods && numberOfLoanPeriods > 0 &&
					 numberOfLoanPeriods == parseInt(numberOfLoanPeriods, 10);
		}

		function processExtraPayment(extraPayment) {
			extraPayment = parseFloat(extraPayment);
			if (isNaN(extraPayment) || extraPayment < 0) {
				extraPayment = 0;
			}

			return extraPayment;
		}

		function calculateAmortization(streamComponent,
										numPeriods,
										interestAccrualMethod,
										remainingBalance,
										effectiveDate,
										isLastStream,
										extraPayment,
										interestRate,
										projectedCloseDate,
										existingAmortizationTable) {
			paymentTable = [];
			complexDateStructure = {};
			var initialPeriod = 1;
			var baseFrequency = this.getBaseFrequency(streamComponent);
			var principalPaymentFrequency = streamComponent.principalPaymentFrequency;
			var interestPaymentFrequency = streamComponent.interestPaymentFrequency;
			var paymentAmount = streamComponent.amount;
			var monthlyFrequency = unitAndFrequencyConverter.getFrequencyByFrequency(12);
			var paymentFrequency = streamComponent.frequency;

			if(existingAmortizationTable) {
				paymentTable = _.flatten(
					_.map(existingAmortizationTable,
						function(yearGroup) {
							return yearGroup.payments;
						}));
				initialPeriod = paymentTable[paymentTable.length - 1].period + 1;
			}

			var dateMoment = initializeFirstPaymentMoment(effectiveDate);
			var currentPayment = null;
			var paymentDateMoment = dateMoment.clone();

			if(projectedCloseDate == "") {
				projectedCloseDate = dateMoment.clone();
			}

			if(isSemiMonthly(monthlyFrequency, principalPaymentFrequency, interestPaymentFrequency)) {
				createComplexDateStructure(paymentDateMoment);
			}

			for(var i = initialPeriod;
				i < (initialPeriod + numPeriods) && remainingBalance > 0;
				i++) {
				var paymentNumber = (i + 1) - initialPeriod;

				paymentDateMoment = getPaymentDate(i, baseFrequency, monthlyFrequency, paymentFrequency, interestPaymentFrequency, paymentNumber, dateMoment, paymentDateMoment);

				currentPayment = new Payment(i, paymentDateMoment.clone(), extraPayment);
				currentPayment.period = i;
				currentPayment.isNewTableStart = (i === initialPeriod);
				currentPayment.isLastPayment = (i === initialPeriod + numPeriods - 1) && isLastStream;

				if(i == 1){
					var firstPaymentInterestAccrualMethod = 'Actual_' + interestAccrualMethod.split("_")[1];
					currentPayment.interest = this.getCalculatedInterestPayment(i,
																				streamComponent,
																				interestRate,
																				remainingBalance,
																				projectedCloseDate,
																				paymentDateMoment,
																				firstPaymentInterestAccrualMethod);
    			} else {

    			    currentPayment.interest = this.getCalculatedInterestPayment(i,
																				streamComponent,
																				interestRate,
																				remainingBalance,
																				projectedCloseDate,
																				paymentDateMoment,
																				interestAccrualMethod);
    		   }

				this.calculateAmortizationPayment(i,
													paymentNumber,
													principalPaymentFrequency,
													paymentDateMoment.clone(),
													currentPayment,
													streamComponent,
													interestRate,
													paymentAmount,
													remainingBalance,
													interestPaymentFrequency,
													interestAccrualMethod);

				paymentTable.push(currentPayment);

				remainingBalance = currentPayment.balance;
			}

			return sumPaymentTableYears(paymentTable);
		}

		function getPreviousPayDate(paymentNumber, projectedCloseDate) {
			return (paymentNumber > 1) ? paymentTable[paymentNumber-2].paymentDate : projectedCloseDate;
		}

		function getCalculatedInterestPayment(paymentNumber, streamComponent, interestRate, remainingBalance, projectedCloseDate, paymentDateMoment, interestAccrualMethod) {

			var previousPaymentDate = getPreviousPayDate(paymentNumber, projectedCloseDate);
			var accrualRatio = getAccrualRatio(previousPaymentDate, paymentDateMoment, interestAccrualMethod, streamComponent.interestPaymentFrequency);
			var annualInterestRate = interestRate / streamComponent.frequency.ratio;
			return roundToCents(remainingBalance * annualInterestRate * accrualRatio);
		}

		function getAccrualRatio(previousPayDate, paymentDateMoment, interestAccrualMethod, interestPaymentFrequency) {
			var daysInMonth = getAccrualDaysInMonth(previousPayDate, paymentDateMoment, interestAccrualMethod, interestPaymentFrequency);
			var daysInYear = getAccrualDaysInYear(previousPayDate, paymentDateMoment, interestAccrualMethod);
			return daysInMonth / daysInYear;
		}

		function getAccrualDaysInMonth(previousPayDate, paymentDateMoment, interestAccrualMethod, interestPaymentFrequency) {
			var daysInMonth = parseInt(interestAccrualMethod.split("_")[0]);
			if(isNaN(daysInMonth)) {
				daysInMonth = paymentDateMoment.diff(previousPayDate, 'days');
			} else {
			    daysInMonth = 360 * interestPaymentFrequency.ratio;
   			}
			return daysInMonth;
		}

		function getAccrualDaysInYear(previousPayDate, paymentDateMoment, interestAccrualMethod) {
			var daysInYear = parseInt(interestAccrualMethod.split("_")[1]);
			if(isNaN(daysInYear)) {
				var thisYear = moment('1/1/'+paymentDateMoment.year());
				var nextYear = moment('1/1/'+(paymentDateMoment.year()+1));
				return nextYear.diff(thisYear, 'days');
			}
			return daysInYear;
		}

		function createComplexDateStructure(paymentDateMoment) {
			var complexDates = [];
			complexDates.push(paymentDateMoment.date());
			complexDates.push(paymentDateMoment.clone().add(15, 'day').date());

			complexDateStructure = {
				dateArray: complexDates,
				monthIncrementer: complexDates[0] < complexDates[1] ? 0 : 1
			};
		}

		function getPaymentDate(paymentNumber, baseFrequency, monthlyFrequency, principalPaymentFrequency, interestPaymentFrequency, streamPaymentNumber, dateMoment, paymentDateMoment) {

			var paymentDate = paymentDateMoment.clone();

			if(isSemiMonthly(monthlyFrequency, principalPaymentFrequency, interestPaymentFrequency)) {

				var dayOfMonth = getPaymentDay(streamPaymentNumber);

				if(dayOfMonth > paymentDate.daysInMonth()) {
					paymentDate.date(paymentDate.daysInMonth());
				}
				else {
					paymentDate.date(dayOfMonth);

					if(isNewMonth(streamPaymentNumber, dayOfMonth)) {
						paymentDate.add(1, 'month');
					}
				}
			}
			else {
				paymentDate = dateMoment.clone().add((streamPaymentNumber-1)*(monthlyFrequency.frequency/baseFrequency.frequency), 'M');
			}
			return paymentDate;
		}

		function isNewMonth(paymentNumber, dayOfMonth) {
			return (dayOfMonth == complexDateStructure.dateArray[complexDateStructure.monthIncrementer] && paymentNumber > 1);
		}
		function getPaymentDay(paymentNumber) {
			return (paymentNumber % 2 ? complexDateStructure.dateArray[0] : complexDateStructure.dateArray[1]);
		}

		function isSemiMonthly(monthlyFrequency, principalPaymentFrequency, interestPaymentFrequency) {
			return (monthlyFrequency.frequency < Math.max(principalPaymentFrequency.frequency, interestPaymentFrequency.frequency));
		}

		function initializeFirstPaymentMoment(firstPaymentDate) {
			var firstPaymentMoment;

			if (firstPaymentDate) {
				firstPaymentMoment = moment(firstPaymentDate, "ll");
			} else {
				firstPaymentMoment = moment();
			}
			return firstPaymentMoment;
		}

		function sumPaymentTableYears(paymentTable) {

			var groupedTable = [];
			var currentYearSummary = null;
			var previousPayment = null;

			paymentTable.forEach(function(payment) {

				if(previousPayment === null ||
				   payment.paymentDate.year() !== previousPayment.paymentDate.year()) {

					currentYearSummary = {
						year: payment.paymentDate.year(),
						principalSum: payment.principal,
						extraPaymentSum: payment.extraPayment,
						interestSum: payment.interest,
						totalPayments: payment.totalPayment,
						balance: payment.balance,
						payments: [payment]
					};

					groupedTable.push(currentYearSummary);

				} else {

					currentYearSummary.principalSum += payment.principal;
					currentYearSummary.extraPaymentSum += payment.extraPayment;
					currentYearSummary.interestSum += payment.interest;
					currentYearSummary.totalPayments += payment.totalPayment;
					currentYearSummary.balance = payment.balance;
					currentYearSummary.payments.push(payment);
				}

				previousPayment = payment;
			});

			return groupedTable;
		}

		function getRemainingBalance(amortizationTable){

			if(!amortizationTable || amortizationTable.length === 0){
				return null;
			}

			var lastPayment = getLastPayment(amortizationTable);

			return lastPayment.balance;
		}

		function getLastPayment(amortizationTable){
			var numberOfPaymentYears = amortizationTable.length;
			var lastPaymentYear = amortizationTable[numberOfPaymentYears - 1];
			var numberOfPaymentsInLastYear = lastPaymentYear.payments.length;
			var lastPayment = lastPaymentYear.payments[numberOfPaymentsInLastYear - 1];

			return lastPayment;
		}

		function getBalloonPayment(amortizationTable){
			if(!amortizationTable || amortizationTable.length === 0){
				return null;
			}

			var lastPayment = getLastPayment(amortizationTable);

			return lastPayment.totalPayment;
		}

		function roundToCents(value) {
			value = +value;

			var scale = 2;

			if (isNaN(value)){
				return NaN;
			}

			value = value.toString().split('e');
			value = Math.round(+(value[0] + 'e' + (value[1] ? (+value[1] + scale) : scale)));
			value = value.toString().split('e');

			return +(value[0] + 'e' + (value[1] ? (+value[1] - scale) : -scale));
		}
	}]);
})();
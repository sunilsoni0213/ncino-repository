(function() {
	"use strict";
	angular
		.module('ncRateAndPayment')
		.controller('paymentCalculatorController', ['$scope', 'pAndICalculatorFactory', 'pPlusICalculatorFactory', 'interestOnlyCalculatorFactory', 'unitAndFrequencyConverter', 'label', 'PaymentStream', 'messageService',
			function($scope, pAndICalculatorFactory, pPlusICalculatorFactory, interestOnlyCalculatorFactory, unitAndFrequencyConverter, label, PaymentStream, messageService) {

				var vm = this;
				vm.labels = label.getLabels();

				vm.paymentTypes = [vm.labels.Principal_and_Interest, vm.labels.Principal_plus_Interest, vm.labels.Interest_Only];
				vm.paymentType = vm.paymentTypes[0];
				vm.calculationHasBeenPerformed = false;
				vm.baseUnit=0;
				vm.amortizationValue = null;
				vm.extraPayment = null;
				vm.loanTermValue = null;
				vm.previousFirstPaymentDate = null;
				vm.paymentTable = [];
				vm.hasBalloonPayment = false;
				vm.firstPaymentDate = null;
				vm.firstPaymentDateMoment = null;
				vm.interestRateUnit = 0;
				vm.frequencyUnits = 0;
				vm.amortizationUnit = {};
				vm.loanTermUnit = {};
				vm.tableShown = false;
				vm.extraPaymentIncluded = false;
				vm.balloonPayment = 0;
				vm.baseUnit = {};
				vm.baseFrequency = {};
				vm.accrualMethods = getAccrualMethods();
				vm.accrualMethod = vm.accrualMethods[0];

				vm.calculatePayment = calculatePayment;
				vm.validateTermValues = validateTermValues;
				vm.init = init;
				vm.loadUnits = loadUnits;
				vm.loadFrequencies = loadFrequencies;
				vm.canCalculate = canCalculate;
				vm.toggleAmortizationTable = toggleAmortizationTable;
				vm.getNumberOfAmortizationPeriods = getNumberOfAmortizationPeriods;
				vm.getNumberofLoanPeriods = getNumberofLoanPeriods;
				vm.initializePaymentStream = initializePaymentStream;

				vm.isPandI = isPandI;
				vm.isPplusI = isPplusI;
				vm.isInterestOnly = isInterestOnly;
				vm.lastCalculation = '';

				vm.monthlyFrequency = {};
				vm.annualFrequency = {};
				vm.monthlyUnit = {};
				vm.annualUnit = {};

				var amortTermGreaterLoanTermError = {
					text: vm.labels.Amortization_Term_Error,
					type: messageService.messageTypes.error
				};
				vm.init();

				function init() {
					loadUnits();
					loadFrequencies();
				}

				function loadUnits() {
					unitAndFrequencyConverter.getUnits()
						.then(function(result) {
							vm.rateUnits = result;
							vm.monthlyUnit = unitAndFrequencyConverter.getUnitByFrequency(12);
							vm.annualUnit = unitAndFrequencyConverter.getUnitByFrequency(1);

							vm.rateUnits = [];
							vm.rateUnits.push(vm.monthlyUnit);
						}, handleError);
				}

				function loadFrequencies() {
					unitAndFrequencyConverter.getFrequencies()
						.then(function(result) {
							vm.frequencyUnits = result;
							vm.monthlyFrequency = unitAndFrequencyConverter.getFrequencyByFrequency(12);
							vm.annualFrequency = unitAndFrequencyConverter.getFrequencyByFrequency(1);

							vm.baseFrequency = vm.monthlyFrequency;
							vm.frequencyUnits = [];
							vm.frequencyUnits.push(vm.annualFrequency);

							vm.baseUnit = vm.monthlyUnit;
							vm.amortizationUnit = vm.monthlyUnit;
							vm.loanTermUnit = vm.monthlyUnit;
							vm.interestRateUnit = vm.annualFrequency;
						}, handleError);
				}

				var frequencyMultiplierMap = {
					Months: 1,
					Years: 12
				};

				function calculatePayment() {
					var calcFactory;

					if (vm.canCalculate()) {
						if (isPandI()) {
							calcFactory = pAndICalculatorFactory;
						} else if (isPplusI()) {
							calcFactory = pPlusICalculatorFactory;
						} else if (isInterestOnly()) {
							calcFactory = interestOnlyCalculatorFactory;
						}
						setFirstPaymentDateMoment();

						var numberOfAmortizationPeriods = getNumberOfAmortizationPeriods(vm.amortizationValue, vm.amortizationUnit);

						var numberOfLoanPeriods = getNumberofLoanPeriods(vm.loanTermValue, vm.loanTermUnit, numberOfAmortizationPeriods);

						vm.hasBalloonPayment = numberOfLoanPeriods < numberOfAmortizationPeriods;

						var paymentStream = initializePaymentStream(numberOfLoanPeriods);
						var rate = PaymentStream.prototype.getWeightedRate(paymentStream.components[0], vm.rate);

						vm.amortizedPayment = calcFactory.calculatePayment(
							vm.amount,
							numberOfLoanPeriods,
							numberOfAmortizationPeriods,
							rate,
							vm.extraPayment,
							null
						);

						paymentStream.components[0].amount = vm.amortizedPayment;

						if (vm.isInterestOnly()) {
							vm.extraPayment = null;
						}

						vm.paymentTable = calcFactory.calculateAmortization(
							paymentStream.components[0],
							numberOfLoanPeriods,
							vm.accrualMethod.value,
							vm.amount,
							vm.firstPaymentDateMoment,
							true,
							vm.extraPayment,
							rate,
							getPreviousFirstPayment(),
							null
						);

						if (vm.hasBalloonPayment) {
							vm.balloonPayment = pAndICalculatorFactory.getBalloonPayment(vm.paymentTable);
						}

						vm.extraPaymentIncluded = vm.extraPayment;

						vm.calculationHasBeenPerformed = true;

						vm.lastCalculation = vm.paymentType;
					}
				}

				function initializePaymentStream(numberOfLoanPeriods) {
					var amortizationFrequency = unitAndFrequencyConverter.getFrequencyByFrequency(vm.amortizationUnit.frequency);
					return {
						effectiveDate: vm.firstPaymentDateMoment.format('ll'),
						termLength: numberOfLoanPeriods,
						termUnit: vm.loanTermUnit,
						extraPayment: vm.extraPayment,
						components: [{
							amount: vm.amount,
							frequency: amortizationFrequency,
							principalPaymentFrequency: amortizationFrequency,
							interestPaymentFrequency: amortizationFrequency,
							rateStream: null
						}]
					};
				}

				function getPreviousFirstPayment() {
					var previousFirstPaymentMoment = vm.firstPaymentDateMoment.clone();
					return previousFirstPaymentMoment.subtract(Math.round(365/vm.amortizationUnit.frequency), 'days').format('YYYY-MM-DD');
				}

				function isPandI() {
					return vm.paymentType === vm.labels.Principal_and_Interest;
				}

				function isPplusI() {
					return vm.paymentType === vm.labels.Principal_plus_Interest;
				}

				function isInterestOnly() {
					return vm.paymentType === vm.labels.Interest_Only;
				}

				function canCalculate() {
					return vm.amount && vm.amount > 0 &&
						vm.rate && vm.rate > 0 &&
						vm.amortizationValue && vm.amortizationValue > 0 &&
						vm.validateTermValues();
				}

				function validateTermValues() {
					var returnBool = (vm.amortizationValue * frequencyMultiplierMap[vm.amortizationUnit.label] >= vm.loanTermValue * frequencyMultiplierMap[vm.loanTermUnit.label]);

					if (!returnBool) {
						messageService.setMessage(amortTermGreaterLoanTermError);
					} else {
						messageService.clear();
					}

					return returnBool;
				}

				function toggleAmortizationTable() {
					vm.tableShown = true;
				}

				function getNumberOfAmortizationPeriods(amortizationValue, amortizationUnit) {
					return amortizationValue * frequencyMultiplierMap[amortizationUnit.label];
				}

				function getNumberofLoanPeriods(loanTermValue, loanTermUnit, numberOfAmortizationPeriods) {

					var numberOfLoanPeriods;

					if (loanTermValue) {
						numberOfLoanPeriods = loanTermValue * frequencyMultiplierMap[loanTermUnit.label];
					} else {
						numberOfLoanPeriods = numberOfAmortizationPeriods;
					}
					return numberOfLoanPeriods;
				}
				function handleError(message) {}

				function getAccrualMethods() {
					var methods = [];
					methods.push({
						label: vm.labels.Accrual_Method_30_360,
						value: '30_360'
					});
					methods.push({
						label: vm.labels.Accrual_Method_Actual_360,
						value: 'actual_360'
					});
					methods.push({
						label: vm.labels.Accrual_Method_Actual_365,
						value: 'actual_365'
					});
					methods.push({
						label: vm.labels.Accrual_Method_Actual_Actual,
						value: 'actual_actual'
					});
					return methods;
				}

				function setFirstPaymentDateMoment() {
					if (vm.firstPaymentDate && typeof vm.firstPaymentDate === 'string') {
						vm.firstPaymentDateMoment = moment(parseInt(vm.firstPaymentDate));
					} else {
						vm.firstPaymentDateMoment = moment();
					}
				}
			}]);
})();
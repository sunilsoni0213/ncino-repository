
(function() {
	"use strict";
	angular
		.module('ncRateAndPayment')
		.controller('PaymentStructureController', ['$scope', '$locale', '$attrs', '$q', 'ui',
			'messageService', 'label', 'paymentStructureRemoting', 'IForceRemoting','rateStructureLookupService',
			'paymentStreamFactory', 'loanSerializer','unitAndFrequencyConverter', 'modalDialogService', 'screenSection', 'pubsub',
	function($scope, $locale, $attrs, $q, ui,
				messageService, label,
				paymentStructureRemoting, IForceRemoting,
				rateStructureLookupService,
				paymentStreamFactory, loanSerializer,
				unitAndFrequencyConverter, modalDialogService,
				screenSection, pubsub) {

		var vm = this;
		vm.intl = window.LifeCycle.Internationalize;
		var screenState = "summaryView";
		var previousStream = null;

		var tooManyPaymentsMessage = {
			text: label.getLabels().Exceeds_Max_Number_Payments,
			type: messageService.messageTypes.error
		};
		var requiredFieldsMissingMessage = {
			text: label.getLabels().Missing_Payment_Structure_Fields_Error,
			type: messageService.messageTypes.error
		};

		vm.working = false;
		vm.isEditing = false;

		vm.loanInfo = {
			amount: null,
			amortizationTerm: null,
			loanTerm: null,
			remainingAmortization: null,
			remainingBalance: null,
			remainingLoanTerm: null,
			desiredBalloon: null,
			firstPaymentMoment: null,
			accrualMethod: null,
			projectedCloseDate: null,
			calculatedBalloon: null
		};

		vm.contextId = "";

		vm.streams = [];
		vm.frequencies = null;
		vm.units = null;

		vm.workingStream = null;
		vm.streamCopy = null;
		vm.streamToDelete = null;
		vm.loanType = null;

		vm.showModal = false;

		vm.init = init;
		vm.addStream = addStream;
		vm.setStreamType = setStreamType;
		vm.saveStream = saveStream;
		vm.editStream = editStream;
		vm.cancel = cancel;
		vm.initDialog = initDialog;
		vm.confirmDeleteStream = confirmDeleteStream;
		vm.canSaveStream = canSaveStream;
		vm.isValidIntInput = isValidIntInput;
		vm.formatPaymentType = formatPaymentType;
		vm.formValid = false;
		vm.streamErrors = null;

		vm.canCreateStream = canCreateStream;
		vm.isSummaryView = isSummaryView;
		vm.isStreamView = isStreamView;
		vm.isValidLoanAmount = isValidLoanAmount;
		vm.arePaymentPeriodsExceeded = arePaymentPeriodsExceeded;
		vm.arePaymentPeriodsRemaining = arePaymentPeriodsRemaining;
		vm.getPaymentStreamNumber = getPaymentStreamNumber;
		vm.calculatePrincipalPlusInterestAmount = calculatePrincipalPlusInterestAmount;
		vm.checkConvertFrequency = checkConvertFrequency;
		vm.getLoanValue = getLoanValue;
		vm.validateForm = validateForm;
		vm.checkPartialPeriod = checkPartialPeriod;
		vm.canShowTable = canShowTable;

		vm.streamTypes = paymentStreamFactory.getStreamTypes();

		vm.editLoanInfo = {
			remainingLoanTerm: null,
			remainingAmortization: null,
			remainingBalance: null
		};

		try {
			vm.currencySymbol = window.LifeCycle.Internationalize.getCurrencySymbol();
		} catch (err) {
			vm.currencySymbol = '$';
		}
		vm.postLoadButtonHide = postLoadButtonHide;

		vm.init();

		function init() {

			ui.block();

			initDialog();

			vm.loanInfo.contextId = $attrs.objectId;
			vm.loanInfo.amount = Number($attrs.amount);
			vm.loanInfo.amortizationTerm = Number($attrs.amortizationTerm);
			vm.loanInfo.loanTerm = Number($attrs.loanTerm);
			vm.loanInfo.desiredBalloon = Number($attrs.desiredBalloon);
			vm.loanInfo.accrualMethod = $attrs.accrualMethod;
			vm.loanInfo.projectedCloseDate = $attrs.projectedCloseDate;
			vm.loanType = $attrs.loanType;
			vm.enableZeroAmountStreams = $attrs.enableZeroAmountStreams === 'true';

			if ($attrs.firstPaymentDate) {
				vm.loanInfo.firstPaymentDateMoment = moment($attrs.firstPaymentDate);
			}

			unitAndFrequencyConverter.getFrequencies()
				.then(function(frequencies){
					vm.frequencies = frequencies;
					return unitAndFrequencyConverter.getUnits();
				}, handleError)
				.then(function(units){
					vm.units = units;
					vm.baseUnit = _.findWhere(vm.units, {frequency: 12});
					return vm.baseUnit;
				}, handleError)
				.then(function(){
					if(canCreateStream()){

						startRemoting();

						rateStructureLookupService
						.initialize(vm.loanInfo.contextId)
						.then(function(){

							return paymentStructureRemoting.getStreams(vm.loanInfo.contextId);

						}, handleError)
						.then(function(streams){
							streams.forEach(function(stream){
								vm.streams.push(paymentStreamFactory.extendStream(stream));
							});

							recalculateAllStreams();
							return saveAllStreams();

						}, handleError)
						.then(function(){

							finishRemoting();

							if(vm.loanInfo.projectedCloseDate != "") {
								if(moment(vm.loanInfo.projectedCloseDate) > vm.loanInfo.firstPaymentDateMoment) {
									vm.streamErrors = label.getLabels().Invalid_Close_Date;
									messageService.setMessage({text: vm.streamErrors, type: messageService.messageTypes.error});
								}
							}
						}, handleError);
					}
					else{
						ui.unblock();
					}
				});

			vm.postLoadButtonHide();
		}

		function postLoadButtonHide() {
			pubsub.publish(LifeCycle.Topics.GlobalActionButtonHandler.HIDE_SAVE);
			pubsub.publish(LifeCycle.Topics.GlobalActionButtonHandler.HIDE_CANCEL);
			pubsub.publish(LifeCycle.Topics.GlobalActionButtonHandler.HIDE_EDIT);
		}

		function initDialog() {
			modalDialogService.setDialog({
				title: label.getLabels().Delete_Confirmation_Title,
				body: label.getLabels().Delete_Confirmation_Body
			});

			modalDialogService.setCancelButton({
				label: label.getLabels().Cancel,
				style: 'neutral',
				visible: true,
				behavior: function() {
					vm.showModal = false;
				}
			});
			modalDialogService.setContinueButton({
				label: label.getLabels().Continue,
				style: 'destructive',
				visible: true,
				behavior: function() {
					deleteStream();
				}
			});
		}

		function canCreateStream() {

			var canCreate = false;
			var requiredFieldsExist = vm.isValidLoanAmount() && vm.loanInfo.loanTerm && vm.loanInfo.amortizationTerm && vm.loanInfo.firstPaymentDateMoment;

			if (requiredFieldsExist) {

				messageService.removeMessage(requiredFieldsMissingMessage);
				canCreate = true;

			} else if (messageService.getMessages().indexOf(requiredFieldsMissingMessage) === -1) {
				messageService.setMessage(requiredFieldsMissingMessage);
			}

			if (vm.streamErrors) {
				canCreate = false;
			}

			return canCreate;
		}

		function canShowTable() {
			return (vm.loanInfo.amount > 0 && vm.streams && vm.streams.length > 0 && vm.loanInfo.remainingLoanTerm === 0);
		}

		function canSaveStream(isFormValid) {
			return (!vm.arePaymentPeriodsExceeded() &&
					(vm.workingStream.components[0].type !== label.getLabels().Select_Payment_Type) &&
					vm.formValid &&
					!vm.streamErrors &&
					vm.workingStream.components[0].principalPaymentFrequency <= vm.workingStream.components[0].interestPaymentFrequency &&
					vm.isValidIntInput(vm.workingStream.termLength) &&
					vm.isValidIntInput(vm.workingStream.sequence));
		}

		function isValidIntInput(inputField) {
		    return (!isNaN(inputField) && inputField > 0);
		}
		function formatPaymentType() {
			vm.streamTypes.splice(0,0,label.getLabels().Select_Payment_Type);
			vm.workingStream.components[0].type=vm.streamTypes[0];
		}
		function isSummaryView() {
			return screenState === "summaryView";
		}

		function isStreamView() {
			return screenState === "streamView";
		}

		function arePaymentPeriodsRemaining() {

			var totalPeriods = calculateTotalPaymentPeriods();
			setPaymentExceededError(totalPeriods);

			return vm.loanInfo.loanTerm - totalPeriods > 0;
		}

		function arePaymentPeriodsExceeded() {

			var totalPeriods = calculateTotalPaymentPeriods();

			setPaymentExceededError(totalPeriods);

			return totalPeriods > vm.loanInfo.loanTerm;
		}

		function setPaymentExceededError(totalPeriods) {

			if (totalPeriods > vm.loanInfo.loanTerm) {

				if (messageService.getMessages().indexOf(tooManyPaymentsMessage) === -1) {
					messageService.setMessage(tooManyPaymentsMessage);
				}

			} else {
				messageService.removeMessage(tooManyPaymentsMessage);
			}
		}

		function calculateTotalPaymentPeriods(){

			var totalPeriods = 0;
			vm.streams.forEach(function(stream){
				totalPeriods += stream.getTermLength(vm.baseUnit);
			});

			if (!vm.working && vm.workingStream){
				totalPeriods += vm.workingStream.getTermLength(vm.baseUnit);
			}

			if (vm.isEditing) {
				var originalStream = _.find(vm.streams,
					function(stream) {
						return stream.recordId === vm.workingStream.recordId;
					});
				totalPeriods -= originalStream.getTermLength(vm.baseUnit);
			}

			return totalPeriods;
		}

		function getPaymentStreamNumber(payment){

			var streamNumber = null;
			if (payment && payment.isNewTableStart) {
				vm.streams.forEach(function(stream){
					if (stream.effectiveDate.format('l') === payment.paymentDate.format('l')) {
						streamNumber = stream.sequence;
					}
				});
			}

			return streamNumber;
		}

		function sortStreams() {
			vm.streams.sort(function(a, b) {
				return a.sequence - b.sequence;
			});
		}

		function addStream() {

			messageService.clear();

			startRemoting();

			paymentStructureRemoting.createStream()
				.then(function(stream) {

				var isFirstStream = vm.streams.length === 0;

				vm.workingStream = paymentStreamFactory.extendStream(stream);
				angular.extend(vm.workingStream, {
					contextId: vm.loanInfo.contextId,
					sequence: isFirstStream ? 1 : vm.streams[vm.streams.length - 1].sequence + 1,
					termLength: vm.loanInfo.remainingLoanTerm,
					termUnit: vm.baseUnit,
					effectiveDate: isFirstStream ?
											vm.loanInfo.firstPaymentDateMoment.clone() :
											vm.streams[vm.streams.length - 1].endDate.add(1, "Days")
				});

				vm.workingStream.components[0].rateStream = rateStructureLookupService.lookupRateStream(vm.workingStream.effectiveDate);

				vm.formatPaymentType();

				screenState = "streamView";

				finishRemoting();

			}, handleError);
		}

		function validateForm(){
			messageService.clear();
			vm.streamErrors = null;

			checkPartialPeriod();

			return vm.streamErrors == null;
		}

		function checkPartialPeriod(){

			if (_.isUndefined(vm.workingStream.termLength)) {
				return true;
			}

			var partialPeriodError = false;

			if (vm.workingStream.components[0].type == label.getLabels().Principal_plus_Interest) {

				if (vm.workingStream.hasPartialPeriod(vm.workingStream.components[0].principalPaymentFrequency)) {
					vm.streamErrors = label.getLabels().Invalid_Principal_Frequency;
					if (_.isEmpty(_.where(messageService.getMessages(), {text: vm.streamErrors}))) {
						messageService.setMessage({text: vm.streamErrors, type: messageService.messageTypes.error});
					}
					partialPeriodError = true;
				}
				if (vm.workingStream.hasPartialPeriod(vm.workingStream.components[0].interestPaymentFrequency)) {
					vm.streamErrors = label.getLabels().Invalid_Interest_Frequency;
					if (_.isEmpty(_.where(messageService.getMessages(), {text: vm.streamErrors}))) {
						messageService.setMessage({text: vm.streamErrors, type: messageService.messageTypes.error});
					}
					partialPeriodError = true;
				}
			}
			else if (vm.workingStream.components[0].type == label.getLabels().Principal_and_Interest || vm.workingStream.components[0].type == label.getLabels().Interest_Only) {
				if (vm.workingStream.hasPartialPeriod(vm.workingStream.components[0].frequency)) {
					vm.streamErrors = label.getLabels().Invalid_Principal_Frequency;
					if (_.isEmpty(_.where(messageService.getMessages(), {text: vm.streamErrors}))) {
						messageService.setMessage({text: vm.streamErrors, type: messageService.messageTypes.error});
					}
					partialPeriodError = true;
				}
			}

			if (!partialPeriodError) {
				messageService.clear();
				vm.streamErrors = null;
			}

			return partialPeriodError;
		}

		function checkConvertFrequency(){
			if(vm.workingStream.components[0].principalPaymentFrequency.frequency <= vm.workingStream.components[0].interestPaymentFrequency.frequency){
				getStreamPrincipalPayment();
			}
			else {
				vm.streamErrors = label.getLabels().Invalid_Frequency_Selection;
				messageService.setMessage({text: vm.streamErrors, type: messageService.messageTypes.error});
			}
		}

		function getLoanValue(currentStream){
			var loanValue = vm.loanInfo.amount;
			vm.streams.forEach(function(stream){
				loanValue -= (stream.termLength * stream.components[0].amount)/(stream.termUnit.frequency/stream.components[0].principalPaymentFrequency.frequency);
			});
			loanValue += (currentStream.termLength * currentStream.components[0].amount)/(currentStream.termUnit.frequency/currentStream.components[0].principalPaymentFrequency.frequency)
			return loanValue;
		}

		function getStreamPrincipalPayment(){
			var originalPrincipalFrequency = vm.workingStream.components[0].principalPaymentFrequency.frequency;
			vm.workingStream.components[0].principalPaymentFrequency = _.findWhere(vm.frequencies, {frequency: 12});
			vm.workingStream.calculatePayment(vm.loanInfo, vm.baseUnit);
			vm.workingStream.components[0].principalPaymentFrequency = _.findWhere(vm.frequencies, { frequency: originalPrincipalFrequency });
			vm.workingStream.components[0].frequency = _.findWhere(vm.frequencies, { frequency: originalPrincipalFrequency });
			vm.workingStream.components[0].amount *= (vm.workingStream.termUnit.frequency/originalPrincipalFrequency);
		}

		function calculatePrincipalPlusInterestAmount(stream) {
			var calcPercent = (stream.components[0].amount / vm.loanInfo.amount) * 100;
			var calcAmount = (stream.components[0].percent / 100) * vm.loanInfo.amount;
			var percent = stream.components[0].percent;
			var amount = stream.components[0].amount;
			var isPercent = stream.components[0].principalAsPercent;
			vm.streamErrors = null;
			messageService.clear();

			if (isPercent && (percent >= 0 && percent <= 100)) {
				stream.components[0].amount = parseFloat(calcAmount.toFixed(2));
			} else if (!isPercent && (amount >= 0 && amount <= vm.loanInfo.amount)) {
				stream.components[0].percent = parseFloat(calcPercent.toFixed(3));
			} else {
				vm.streamErrors = label.getLabels().Invalid_Principal_Plus_Interest;
				messageService.setMessage(
					{text: vm.streamErrors, type: messageService.messageTypes.error}
				);
			}
		}

		function setStreamType() {

			vm.streamTypes = paymentStreamFactory.getStreamTypes();

			vm.streamErrors = null;
			messageService.clear();
			vm.workingStream = paymentStreamFactory.extendStream(vm.workingStream);
			vm.workingStream.calculatePayment(vm.loanInfo, vm.baseUnit);

			vm.streamErrors = vm.workingStream.checkLoanInputs(vm.loanInfo);

			if (vm.streamErrors) {
				messageService.setMessage({text: vm.streamErrors, type: messageService.messageTypes.error});
			}

			vm.validateForm();
		}

		function storeExtendedFields() {
			if (screenSection != null && screenSection.formBuilder != null && screenSection.formBuilder.fields != null) {
				var formFields = screenSection.formBuilder.fields['extendedFields'];

				localizeExtendedFields(vm.workingStream.components[0], formFields, false);
			}
		}

		function localizeExtendedFields(component, formFields, onRecalculate) {
			if (onRecalculate) {
				for (var i in formFields) {
					if (formFields[i].isUpdateable && formFields[i].value) {
						if (formFields[i].filter === 'DATE') {
							component.extendedFields[i].value =
								moment(formFields[i].value).format('MM/DD/YYYY');
						} else if (formFields[i].filter === 'DATETIME') {
							if (!formFields[i].timeLocalized) {
								var utcDate = new Date(formFields[i].value).getTime() + vm.intl.sfUserTimezoneOffset;
								component.extendedFields[i].value = new Date(utcDate);
							}
							delete formFields[i].timeLocalized;
						} else {
							component.extendedFields[i].value = formFields[i].value;
						}
					}
				}
			} else {
				for (var i in formFields) {
					if (!formFields[i].isReadOnly && formFields[i].hasOwnProperty('value')) {
						if (formFields[i].fieldType === 'DATE') {
							var parsedDate = new Date(parseInt(formFields[i].value));
							parsedDate = new Date(parsedDate.getTime() + (parsedDate.getTimezoneOffset() * 60 * 1000) );

							component.extendedFields[formFields[i].fieldName]['value'] =
								vm.intl.format(parsedDate,
									'd'
								);
						} else if (formFields[i].fieldType === 'DATETIME') {
							var parsedDate = new Date(parseInt(formFields[i].value) + vm.intl.aggregateTimezoneOffset);
							component.extendedFields[formFields[i].fieldName]['value'] =
								vm.intl.format(
									parsedDate,
									vm.intl.formats.dateTime
								);
							component.extendedFields[formFields[i].fieldName]['timeLocalized'] = true;
						} else {
							if (component.extendedFields.hasOwnProperty(formFields[i].fieldName)) {
								component.extendedFields[formFields[i].fieldName]['value'] =
									formFields[i].value;
							}
						}
					}
				}
			}
		}

		function saveStream(stream) {
			if(vm.validateForm()) {
				storeExtendedFields();
				startRemoting();

				if (vm.isEditing) {
					vm.streams[_.indexOf(vm.streams, previousStream)] = stream;
				} else {
					vm.streams.push(stream);
				}

				recalculateAllStreams();

				saveAllStreams().then(function(){

					vm.isEditing = false;
					vm.workingStream = undefined;
					previousStream = undefined;
					screenState = "summaryView";
					finishRemoting();

				}, function(message) {
					if (!vm.isEditing) {
						removeStream(stream);
					} else {
						vm.streams[vm.streams.indexOf(stream)] = previousStream;
					}
					screenState = "streamView";
					handleError(message);
				});
			}
		}

		function recalculateAllStreams() {

			vm.amortizationTable = null;
			vm.loanInfo.remainingBalance = vm.loanInfo.amount;
			vm.loanInfo.remainingAmortization = vm.loanInfo.amortizationTerm;
			vm.loanInfo.remainingLoanTerm = vm.loanInfo.loanTerm;

			sortStreams();

			var currentDate = moment(vm.loanInfo.firstPaymentDateMoment, 'l');

			angular.forEach(vm.streams, function(stream) {
				localizeExtendedFields(stream.components[0], stream.components[0].extendedFields, true);
				calculatePrincipalPlusInterestAmount(stream);

				var streamTermInMonths = stream.getTermLength(vm.baseUnit);

				stream.effectiveDate = moment(currentDate);

				if (streamTermInMonths % 1 != 0) {
					stream.endDate = moment(currentDate.add(15, "Days")
						.add(Math.floor(streamTermInMonths), "Months")
							.subtract(1, "Days"));
				} else {
					stream.endDate = moment(currentDate.add(streamTermInMonths, "Months")
						.subtract(1, "Days"));
				}

				currentDate.add(1, "Days");

				stream.components[0].rateStream = rateStructureLookupService.lookupRateStream(stream.effectiveDate);

				if (vm.loanInfo.amount > 0) {
					vm.amortizationTable = stream.calculateAmortization(vm.loanInfo, vm.baseUnit, vm.amortizationTable);
					vm.loanInfo.remainingBalance = stream._endingBalance;
				}

				stream.updateStreamName();

				vm.loanInfo.remainingLoanTerm -= streamTermInMonths;
				vm.loanInfo.remainingAmortization -= streamTermInMonths;
			});
		}

		function saveAllStreams(){

			var promises = [];
			vm.streams.forEach(function(stream){
				promises.push(performSaveRemoting(stream));
			});

			return $q.all(promises).then(pushToLoan);
		}

		function pushToLoan(){

			var promise = $q.resolve(null);

			if (vm.loanInfo.remainingLoanTerm === 0) {
				if (vm.loanInfo.amortizationTerm > vm.loanInfo.loanTerm && vm.amortizationTable != null) {
					vm.loanInfo.calculatedBalloon =
						vm.amortizationTable[vm.amortizationTable.length-1]
							.payments[vm.amortizationTable[vm.amortizationTable.length-1].payments.length-1]
								.totalPayment;
				}
				
				var serializedLoanInfo = loanSerializer.serializeLoan(vm.loanInfo, vm.streams[0], vm.loanType);
				promise = IForceRemoting.saveIForce(serializedLoanInfo);
			}

			return promise;
		}

		function editStream(stream) {
			previousStream = stream;
			vm.workingStream = angular.copy(stream);

			vm.editLoanInfo.remainingLoanTerm = vm.loanInfo.remainingLoanTerm;
			vm.editLoanInfo.remainingAmortization = vm.loanInfo.remainingAmortization;
			vm.editLoanInfo.remainingBalance = vm.loanInfo.remainingBalance;

			vm.loanInfo.remainingLoanTerm += vm.workingStream.termLength;
			vm.loanInfo.remainingAmortization += vm.workingStream.termLength;

			vm.loanInfo.remainingBalance += getLoanValue(vm.workingStream);
			vm.isEditing = true;
			screenState = "streamView";
		}

		function confirmDeleteStream(stream){
			if (stream !== null) {
				vm.streamToDelete= stream;
				vm.showModal = true;
			}
		}

		function deleteStream() {
			vm.showModal = false;
			startRemoting();
			paymentStructureRemoting.removeStream(vm.streamToDelete.toSerializedApex())
				.then(function() {

				removeStream(vm.streamToDelete);

				recalculateAllStreams();

				saveAllStreams().then(function(){
					finishRemoting();
				}, handleError);

			}, handleError);
		}

		function removeStream(stream) {
			var index = vm.streams.indexOf(stream);
			if(index !== -1){
				vm.streams.splice(index, 1);
			}
		}

		function cancel() {
			messageService.clear();
			if (vm.isEditing){
				vm.loanInfo.remainingLoanTerm = vm.editLoanInfo.remainingLoanTerm;
				vm.loanInfo.remainingAmortization = vm.editLoanInfo.remainingAmortization;
				vm.loanInfo.remainingBalance = vm.editLoanInfo.remainingBalance;
			}

			vm.streamTypes = paymentStreamFactory.getStreamTypes();

			vm.isEditing = false;
			previousStream = undefined;
			vm.workingStream = undefined;
			screenState = "summaryView";
		}

		function isValidLoanAmount() {
			return vm.loanInfo.amount || (vm.loanInfo.amount === 0 && vm.enableZeroAmountStreams);
		}

		function performSaveRemoting(remoteStream) {

			return $q(function(resolve, reject){
				paymentStructureRemoting.saveStream(remoteStream.toSerializedApex())
					.then(function(stream) {


					angular.merge(remoteStream, stream);
					remoteStream.fromSerializedApex();

					resolve(remoteStream);

				}, function(error){
					reject(error);
				});
			});
		}

		function startRemoting(){
			vm.working = true;
			messageService.clear();
			ui.block();
		}

		function finishRemoting() {
			vm.working = false;
			ui.unblock();
		}

		function handleError(message){
			messageService.setMessage({text: message, type: messageService.messageTypes.error});
			ui.unblock();
		}
	}]);
})();
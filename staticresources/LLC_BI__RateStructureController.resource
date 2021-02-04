(function(){
	"use strict";
	angular.module('ncRateAndPayment')
	.controller('rateStructureController', ['$scope', '$filter', '$rootScope', '$locale', '$attrs', '$q',
		'label', 'messageService', 'rateStructureRemoting', 'modalDialogService', 'ui', 'unitAndFrequencyConverter', 'screenSection', 'pubsub',
		function($scope, $filter, $rootScope, $locale, $attrs, $q, label, messageService, rateStructureRemoting, modalDialogService, ui, unitAndFrequencyConverter, screenSection, pubsub) {

		var vm = this;
		vm.intl = window.LifeCycle.Internationalize;

		var tooManyPaymentsMessage = {
			text: label.getLabels().Exceeds_Max_Number_Payments,
			type: messageService.messageTypes.error
		};
		var requiredFieldsMissingMessage = {
			text: label.getLabels().Missing_Payment_Structure_Fields_Error,
			type: messageService.messageTypes.error
		};

		vm.ratePrecision = 8;
		vm.doneLoading = false;

		vm.loanInfo = {
			amount: null,
			loanId: null,
			loanFirstPaymentDate: null,
			loanTermValue: null,
			amortTermValue: null,
			remainingLoanTerm: null
		};

		vm.screenState = "summary";
		vm.streams = [];
		vm.swapSelections = ["Yes", "No"];
		vm.indices = [];
		vm.activeIndices = [];
		vm.indexRates = [];
		vm.rateTypes = [];
		vm.units = null;
		vm.baseUnit = null;
		vm.defaultEffectiveDate = moment();
		vm.effectiveDateStreamMoments = [];
		vm.endDateStreamMoments = [];
		vm.streamCopy = null;
		vm.streamToDelete = null;
		vm.componentCopy = null;
		vm.splitCount = 1;
		vm.isSplit = false;
		vm.showComponentDetails = null;
		vm.usesOldData = false;
		vm.showModal = false;

		vm.init = init;
		vm.addStream = addStream;
		vm.editStream = editStream;
		vm.save = save;
		vm.recalculateAllStreams = recalculateAllStreams;
		vm.deletePerformanceIndicator = deletePerformanceIndicator;
		vm.cancel = cancel;
		vm.canSaveStream = canSaveStream;
		vm.canCreateStream = canCreateStream;
		vm.showPerformanceIndicatorModal = showPerformanceIndicatorModal;
		vm.initDialog = initDialog;
		vm.confirmDeleteStream = confirmDeleteStream;
		vm.getStreamMonths = getStreamMonths;
		vm.setStreamDates = setStreamDates;
		vm.setActiveIndices = setActiveIndices;
		vm.getActiveIndices = getActiveIndices;

		vm.isSummary = isSummary;
		vm.isAddStream = isAddStream;
		vm.isEditStream = isEditStream;
		vm.isValidLoanAmount = isValidLoanAmount;
		vm.hasPerformanceIndicators = hasPerformanceIndicators;
		vm.arePaymentPeriodsExceeded = arePaymentPeriodsExceeded;
		vm.formatStreamForSave = formatStreamForSave;
		vm.parsePricingCovenantRules = parsePricingCovenantRules;
		vm.adjustSplits = adjustSplits;
		vm.resetSplits = resetSplits;
		vm.getRateName = getRateName;
		vm.getIndexDisplayName = getIndexDisplayName;
		vm.getIndicesArrayIndex = getIndicesArrayIndex;
		vm.getAllInRate = getAllInRate;
		vm.setRateType = setRateType;
		vm.expand = expand;
		vm.postLoadButtonHide = postLoadButtonHide;
		vm.init();

		$rootScope.$on("saveMessage", function(event, performanceIndicator, componentIndex) {
			if (!vm.activeStream.components[componentIndex].hasOwnProperty('pricingCovenants')) {
				vm.activeStream.components[componentIndex].pricingCovenants = [];
			}
			vm.activeStream.components[componentIndex].pricingCovenants.push(performanceIndicator);
		});

		function init() {
			ui.block();
			vm.loanInfo.loanId = $attrs.objectId;
			vm.loanInfo.loanTermValue = Number($attrs.loanTerm);
			vm.loanInfo.amortTermValue = Number($attrs.amortTerm);
			vm.loanInfo.remainingLoanTerm = Number($attrs.loanTerm);
			vm.loanInfo.amount = Number($attrs.amount);
			vm.enableZeroAmountStreams = $attrs.enableZeroAmountStreams === 'true';

			if ($attrs.firstPaymentDate) {
				vm.loanInfo.loanFirstPaymentDate = moment($attrs.firstPaymentDate);
			}

			messageService.clear();
			rateStructureRemoting.getInterestRateTypes().then(function(result) {
				vm.rateTypes = result;
			}, handleError);

			rateStructureRemoting.getIndices().then(function(result) {
				vm.indices = result;
				vm.setActiveIndices();

			}, handleError);

			rateStructureRemoting.getIndexRates().then(function(result) {
				vm.indexRates = result;
			}, handleError);

			unitAndFrequencyConverter.getUnits().then(function(units) {
				vm.units = units;
				vm.baseUnit = _.findWhere(vm.units, {frequency: 12});

				if (canCreateStream()) {
					rateStructureRemoting.getStreams(vm.loanInfo.loanId).then(function(result) {
						vm.streams = result;

						angular.forEach(vm.streams, function(stream) {
							if (stream.termUnit == 'Months') {
								vm.usesOldData = true;
							} else {
								stream.termUnit = _.findWhere(vm.units, {developerName: stream.termUnit});
							}
							vm.parsePricingCovenantRules(stream);
						});

						if (!vm.usesOldData) {
							recalculateAllStreams().then(function() {
								unLocalizeDates();
								ui.unblock();
							}, handleError);
						} else {
							ui.unblock();
						}
					}, handleError);
				}
			}, handleError);

			vm.doneLoading = true;
			vm.initDialog();

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

		function addStream() {
			vm.activeStream = {};
			vm.interestValue = null;
			vm.interestUnit = null;

			var sequence = 1;
			if (vm.streams.length !== 0) {
				sequence = vm.streams[vm.streams.length -1].sequence + 1;
			}

			messageService.clear();

			rateStructureRemoting.createStream().then(function(result) {
				vm.activeStream = result;
				vm.activeStream.sequence = sequence;
				vm.activeStream.termLength = vm.loanInfo.remainingLoanTerm;
				vm.activeStream.contextId = vm.loanInfo.loanId;
				vm.activeStream.components[0].frequency = "Frequency_Annually";
				vm.activeStream.components[0].rate = 0;
				vm.activeStream.effectiveDate = vm.defaultEffectiveDate;
				vm.activeStream.termUnit = vm.baseUnit;
				vm.componentCopy = _.clone(vm.activeStream.components[0]);
				vm.componentCopy.appliedLoanPercentage = null;
			}, handleError);

			vm.screenState = "addStream";
		}

		function editStream(stream) {
			vm.activeStream = {};
			vm.activeStream = stream;
			vm.originalStream = angular.copy(stream);

			vm.loanInfo.remainingLoanTerm += stream.termLength;
			vm.isSplit = stream.components.length > 1;
			if (vm.isSplit) {
				vm.splitCount = stream.components.length;
			}

			vm.screenState = 'editStream';
		}

		function recalculateAllStreams() {
			vm.loanInfo.remainingLoanTerm = Number($attrs.loanTerm);
			var i = 1;
			angular.forEach(vm.streams, function(stream) {
				var streamTermInMonths = vm.getStreamMonths(stream);
				stream.sequence = i;
				setStreamDates(stream);
				stream.termUnit = stream.termUnit.developerName;
				vm.loanInfo.remainingLoanTerm -= streamTermInMonths;
				i++;
			});
			return saveAllStreams();
		}

		function adjustSplits() {
			if (vm.activeStream.components && vm.activeStream.components.length != vm.splitCount) {
				var count = vm.activeStream.components.length;
				if (count < vm.splitCount) {
					for (var i = 0; i < vm.splitCount-count; i++) {
						vm.activeStream.components.push(angular.copy(vm.componentCopy));
					}
				}
				if (count > vm.splitCount) {
					vm.activeStream.components.splice(vm.splitCount)
				}
			}
		}

		function resetSplits() {
			vm.splitCount = 1;
			vm.adjustSplits();
			vm.activeStream.components[0].appliedLoanPercentage = 100;
		}

		function canSaveStream(isFormInvalid) {
			return (vm.isAddStream() || vm.isEditStream()) &&
				vm.activeStream &&
				vm.activeStream.termUnit &&
				!vm.arePaymentPeriodsExceeded() &&
				vm.activeStream.termLength > 0 &&
				!isFormInvalid;
		}

		function canCreateStream() {
			if (vm.loanInfo.loanFirstPaymentDate &&
				vm.loanInfo.loanTermValue &&
				vm.loanInfo.amortTermValue &&
				vm.isValidLoanAmount())
			{
				messageService.removeMessage(requiredFieldsMissingMessage);
				return true;
			} else if (messageService.getMessages().indexOf(requiredFieldsMissingMessage) === -1) {
				messageService.setMessage(requiredFieldsMissingMessage);
			}

			ui.unblock();
			return false;
		}

		function arePaymentPeriodsExceeded() {
			var remainingTerm = vm.loanInfo.remainingLoanTerm - (getStreamMonths(vm.activeStream));

			setPaymentExceededError(remainingTerm);

			return remainingTerm < 0;
		}

		function setPaymentExceededError(remainingTerm) {
			if (remainingTerm < 0) {
				if (messageService.getMessages().indexOf(tooManyPaymentsMessage) === -1) {
					messageService.setMessage(tooManyPaymentsMessage);
				}
			} else {
				messageService.removeMessage(tooManyPaymentsMessage);
			}
		}

		function saveAllStreams() {
			messageService.clear();
			var promises = [];
			angular.forEach(vm.streams, function(stream) {
				var cloneStream = _.clone(stream);
				localizeDates(cloneStream);
				cloneStream.components = null;
				promises.push(performSaveRemoting(cloneStream));

				stream.termUnit = _.findWhere(vm.units, {developerName: stream.termUnit});
			});

			return $q.all(promises);
		}

		function localizeDates(stream) {
			vm.effectiveDateStreamMoments[stream.sequence] = _.clone(stream.effectiveDate);
			vm.endDateStreamMoments[stream.sequence] = _.clone(stream.endDate);
			stream.effectiveDate = vm.intl.format(stream.effectiveDate.toDate(), 'd');
			stream.endDate = vm.intl.format(stream.endDate.toDate(), 'd');
			}

		function unLocalizeDates() {
			angular.forEach(vm.streams, function(stream) {
				unLocalizeStreamDates(stream);
			});
		}

		function unLocalizeStreamDates(stream) {
			stream.effectiveDate = vm.effectiveDateStreamMoments[stream.sequence];
			stream.endDate = vm.endDateStreamMoments[stream.sequence];
		}

		function save() {
			messageService.clear();

			if (isStreamValidForSave(vm.activeStream)) {
				vm.streamCopy = _.clone(vm.activeStream);
				storeExtendedFields();
				vm.formatStreamForSave(vm.streamCopy);
				messageService.clear();

				if (isAddStream()) {
					saveNewStream();
				} else if (isEditStream()) {
					updateStream();
				}
			}
		}

		function setActiveIndices() {
			vm.activeIndices = [];
			for (var i = 0; i < vm.indices.length; i++) {
				if (vm.indices[i].isActive) {
					vm.activeIndices.push(vm.indices[i]);
				}
			}
		}

		function getActiveIndices(currentModel) {
			var retArray = vm.activeIndices.slice(0);

			if (currentModel && vm.activeIndices.filter(function(index){return index.displayName === currentModel.displayName}).length === 0) {
				retArray.push(currentModel);
			}

			return retArray;
		}

		function storeExtendedFields() {
			if (screenSection != null && screenSection.formBuilder != null && screenSection.formBuilder.fields != null) {
				for (var i=0; i < vm.streamCopy.components.length; i++) {
					var formFields = {};
					if (vm.streamCopy.components[i].isFixed) {
						formFields = screenSection.formBuilder.fields['fixed-' + i];
					} else {
						formFields = screenSection.formBuilder.fields['variable-' + i];
					}

					localizeExtendedFields(vm.streamCopy.components[i], formFields);
				}
			}
		}

		function localizeExtendedFields(component, formFields) {
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
					} else {
						if (component.extendedFields.hasOwnProperty(formFields[i].fieldName)) {
							component.extendedFields[formFields[i].fieldName]['value'] =
								formFields[i].value;
						}
					}
				}
			}
		}

		function saveNewStream() {
			rateStructureRemoting.saveStream(vm.streamCopy).then(function(result) {
				vm.parsePricingCovenantRules(result);
				result.termUnit = vm.activeStream.termUnit;
				vm.streams.push(result);
				postSaveProcessing();
				unLocalizeStreamDates(result);
			}, handleError);
		}

		function updateStream() {
			rateStructureRemoting.saveStream(vm.streamCopy).then(function(result) {
				vm.parsePricingCovenantRules(result);
				result.termUnit = vm.activeStream.termUnit;
				var arrayIndex = getStreamIndexBySequence(vm.streamCopy.sequence);
				if (arrayIndex !== null) {
					vm.streams[arrayIndex] = result;
				}
				postSaveProcessing();
				unLocalizeStreamDates(result);
			}, handleError);
		}

		function postSaveProcessing() {
			vm.loanInfo.remainingLoanTerm -= getStreamMonths(vm.activeStream);
			vm.isSplit = false;
			vm.showComponentDetails = null;
			vm.screenState = "summary";

		}

		function performSaveRemoting(remoteStream) {
			return $q(function(resolve, reject) {
				rateStructureRemoting.saveStream(remoteStream).then(function(stream){
					resolve(remoteStream);
				}, function(error){
					reject(error);
				});
			});
		}

		function confirmDeleteStream(stream) {
			vm.streamToDelete = stream;
			vm.showModal = true;
		}

		function deleteStream() {
			vm.showModal = false;
			startRemoting();
			messageService.clear();

			rateStructureRemoting.removeStream(vm.streamToDelete).then(function() {
				var index = vm.streams.indexOf(vm.streamToDelete);
				if (index !== -1) {
					vm.streams.splice(index, 1);
				}
				if (!vm.usesOldData) {
					recalculateAllStreams().then(function(){
						unLocalizeDates()
						finishRemoting();
					}, handleError);
				} else {
					finishRemoting();
				}
			}, handleError);
		}

		function deletePerformanceIndicator(component, performanceIndicator) {
			var index = component.pricingCovenants.indexOf(performanceIndicator);
			if (index !== -1) {
				component.pricingCovenants.splice(index, 1);
			}
		}

		function isStreamValidForSave(stream) {
			if (stream && stream.components && stream.components.length > 0) {
				var totalPercentage = 0;
				var invalidValueFound = false;
				angular.forEach(stream.components, function(component) {
					if (isNaN(component.appliedLoanPercentage) ||
						component.appliedLoanPercentage == null ||
						component.appliedLoanPercentage == 0)
					{
						invalidValueFound = true;
					} else {
						totalPercentage += Number(component.appliedLoanPercentage);
					}
				});

				if (invalidValueFound) {
					handleError(label.getLabels().Applied_Loan_Percentage_Value_Error);
					return false;
				} else if (totalPercentage != 100) {
					handleError(label.getLabels().Applied_Loan_Percentage_Total_Error);
					return false;
				} else {
					return true
				}
			}
			return false;
		}

		function formatStreamForSave(stream) {
			if (stream.termUnit != 'Months' && stream.termUnit != null) {
				setStreamDates(stream);
				stream.termUnit = stream.termUnit.developerName;
			}
			localizeDates(stream);


			angular.forEach(stream.components, function(component) {
				if (component.index) {
					component.index = component.index.masterLabel;
				}

				if (component.hasOwnProperty('pricingCovenants')) {
					angular.forEach(component.pricingCovenants, function(pricingCovenant) {
						pricingCovenant.rules = angular.toJson(pricingCovenant.rules);
					});
				}
			});
		}

		function setStreamDates(stream) {
			var currentStreamMonths = Math.floor(vm.getStreamMonths(stream));

			if (stream.sequence == 1) {
				stream.effectiveDate = vm.loanInfo.loanFirstPaymentDate;
			} else if(vm.usesOldData) {
				stream.effectiveDate = moment(_.clone(vm.streams[vm.streams.length-1].endDate)).add(1, 'Days');
			} else {
				stream.effectiveDate = moment(_.clone(vm.streams[stream.sequence-2].endDate)).add(1, 'Days');
			}

			if (isSemiMonthly(stream.termUnit.developerName) && stream.termLength % 2 != 0) {
				stream.endDate = moment(_.clone(stream.effectiveDate)).add(15, 'Days').add(currentStreamMonths, 'Months').subtract(1, 'Days');
			} else {
				stream.endDate = moment(_.clone(stream.effectiveDate)).add(currentStreamMonths, 'Months').subtract(1, 'Days');
			}
		}

		function formatRate(rate) {
			return vm.intl.format(parseFloat($filter('number')(rate, vm.ratePrecision)), 'N' + vm.ratePrecision);
		}

		function parsePricingCovenantRules(stream) {
			if (stream.components) {
				angular.forEach(stream.components, function(component) {
					if (component.hasOwnProperty('pricingCovenants')) {
						angular.forEach(component.pricingCovenants, function(pricingCovenant) {
							var escapedJson = _.unescape(pricingCovenant.rules);
							pricingCovenant.rules = angular.fromJson(escapedJson);
						});
					}
				});
			}
		}

		function getStreamIndexBySequence(sequence) {
			for (var i = 0; i < vm.streams.length; i++) {
				if (vm.streams[i].sequence === sequence) {
					return i;
				}
			}
			return null;
		}

		function getRateName(comp) {
			var rateName = '';
			if (!comp) {
				return rateName;
			} else if (comp.isFixed) {
				rateName += formatRate(comp.rate) + "%";
			} else {
				var spread = comp.spread ? comp.spread : 0;

				rateName += vm.getIndexDisplayName(comp.index) + " + " + formatRate(spread) + "%";

				if (!isNaN(vm.indexRates[comp.index])) {
					rateName += " (est. " + formatRate(spread + vm.indexRates[comp.index]) + "%) ";
				}
			}
			return rateName;
		}

		function getIndexDisplayName(indexMasterLabel) {
			var displayName = '';
			angular.forEach(vm.indices, function(index) {
				if (index.masterLabel == indexMasterLabel) {
					displayName = index.displayName;
				}
			});
			return displayName;
		}

		function getIndicesArrayIndex(indexMasterLabel) {
			if (indexMasterLabel) {
				var testValue = indexMasterLabel;
				if (indexMasterLabel.masterLabel) {
					testValue = indexMasterLabel.masterLabel;
				}
				for (var i = 0; i < vm.indices.length; i++) {
					if (vm.indices[i].masterLabel === testValue) {
						return i;
					}
				}
			}
			return null;
		}

		function getAllInRate(component) {
			if (!component.isFixed) {
				var allInRate;
				if (typeof component.index === 'object') {
					component.rate = vm.indexRates[component.index.masterLabel];
				} else {
					component.rate = vm.indexRates[component.index];
				}
				allInRate = component.rate;

				if (component.spread) {
					allInRate += component.spread;
				}
				return allInRate;
			}
		}

		function setRateType(component, rateType) {
			if (rateType === 'Fixed') {
				component.isFixed = true;
				component.spread = 0;
			} else {
				component.isFixed = false;
			}
		}

		function expand(collapseId) {
			vm.showComponentDetails =
				(vm.showComponentDetails == collapseId) ?
				vm.showComponentDetails = null :
				vm.showComponentDetails = collapseId;
		}

		function cancel() {
			if (vm.screenState == 'editStream' && vm.originalStream) {
				if (vm.originalStream.termLength) {
					vm.loanInfo.remainingLoanTerm -= vm.originalStream.termLength;
				}
				if (vm.originalStream.sequence) {
					var arrayIndex = getStreamIndexBySequence(vm.originalStream.sequence);
					if (arrayIndex !== null) {
						vm.streams[arrayIndex] = vm.originalStream;
					}
				}
				vm.originalStream = {};
			}
			messageService.clear();
			vm.isSplit = false;
			vm.screenState = "summary";
		}

		function showPerformanceIndicatorModal(componentIndex) {
			$rootScope.$broadcast('createNewPerformanceIndicator', vm.loanInfo.loanId, componentIndex);
		}

		function isSummary() {
			return vm.screenState === 'summary';
		}

		function isAddStream() {
			return vm.screenState === 'addStream';
		}

		function isEditStream() {
			return vm.screenState === 'editStream';
		}

		function isValidLoanAmount() {
			return vm.loanInfo.amount || (vm.loanInfo.amount === 0 && vm.enableZeroAmountStreams);
		}

		function getStreamMonths(stream) {
			if(stream.termUnit == null || stream.termUnit == 'Months'){
				return '';
			}
			return (stream.termLength * (vm.baseUnit.frequency / stream.termUnit.frequency));
		}

		function hasPerformanceIndicators(component) {
			return component.pricingCovenants && component.pricingCovenants.length > 0;
		}

		function startRemoting() {
			vm.working = true;
			messageService.clear();
			ui.block();
		}

		function finishRemoting() {
			vm.working = false;
			ui.unblock();
		}

		function isSemiMonthly(termUnit) {
			return termUnit == 'Unit_Semimonths';
		}

		function handleError(message) {
			messageService.setMessage({text: message, type: messageService.messageTypes.error});
			ui.unblock();
		}
	}]).filter('range', function() {
		return function(input, min, max) {
			min = parseInt(min);
			max = parseInt(max);
			for (var i=min; i<=max; i++)
				input.push(i);
			return input;
		};
	});
})();

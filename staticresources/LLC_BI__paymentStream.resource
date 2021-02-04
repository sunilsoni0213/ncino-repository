"use strict";
(function() {
	angular
		.module('ncRateAndPayment')
		.factory('PaymentStream', ['unitAndFrequencyConverter', 'rateStructureLookupService',

	function(unitAndFrequencyConverter, rateStructureLookupService) {

		function PaymentStream(object){

			this._endingBalance = null;
			angular.extend(this, object);
		}

		PaymentStream.prototype.formatSummaryOutput = function(sourceString, args){
			return sourceString.replace(/{(\d+)}/g, function(match, number) {
				return typeof args[number] !== 'undefined'
					? args[number]
					: match;
			});
		};

		PaymentStream.prototype.canDisplaySummary = function(){

			return this.components[0].frequency && this.components[0].frequency.label &&
					 this.components[0].amount != null &&
					 this.termLength &&
					 this.termUnit && this.termUnit.label;
		};

		PaymentStream.prototype.toSerializedApex = function() {
			var intl = window.LifeCycle.Internationalize;


			var processedStream = angular.copy(this);
			delete processedStream._endingBalance;

			processedStream.termUnit = serializeFrequencyOrUnit(processedStream.termUnit);
			processedStream.components[0].frequency = serializeFrequencyOrUnit(processedStream.components[0].frequency);
			processedStream.components[0].principalPaymentFrequency = serializeFrequencyOrUnit(processedStream.components[0].principalPaymentFrequency);
			processedStream.components[0].interestPaymentFrequency = serializeFrequencyOrUnit(processedStream.components[0].interestPaymentFrequency);

			if(this.effectiveDate) {
				processedStream.effectiveDate = intl.format(this.effectiveDate.toDate(), 'd');
			}

			if(this.endDate) {
				processedStream.endDate = intl.format(this.endDate.toDate(), 'd');
			}

			if(this.components[0].rateStream){
				processedStream.components[0].rateStream = this.components[0].rateStream.recordId;
			}

			return processedStream;
		};

		function serializeFrequencyOrUnit(unitOrFreq) {

			var serializedFrequencyOrUnit = unitOrFreq;

			if(unitOrFreq && unitOrFreq.developerName) {
				serializedFrequencyOrUnit = unitOrFreq.developerName;
			}

			return serializedFrequencyOrUnit;
		}

		PaymentStream.prototype.fromSerializedApex = function(){

			this.termUnit = deserializeUnit(this.termUnit);
			this.components[0].frequency = deserializeFrequency(this.components[0].frequency);
			this.components[0].principalPaymentFrequency = deserializeFrequency(this.components[0].principalPaymentFrequency);
			this.components[0].interestPaymentFrequency = deserializeFrequency(this.components[0].interestPaymentFrequency);

			if(this.effectiveDate){
				this.effectiveDate = moment(this.effectiveDate);
				this.components[0].rateStream = rateStructureLookupService.lookupRateStream(this.effectiveDate);
			}
			if(this.endDate){
				this.endDate = moment(this.endDate, 'l');
			}
		};

		function deserializeFrequency(frequency) {

			var deserializedFrequency = frequency;

			if(frequency && !frequency.developerName){
				deserializedFrequency = unitAndFrequencyConverter.getFrequencyByName(frequency);
			}

			return deserializedFrequency;
		}

		function deserializeUnit(unit) {

			var deserializedUnit = unit;

			if(unit && !unit.developerName){
				deserializedUnit = unitAndFrequencyConverter.getUnitByName(unit);
			}

			return deserializedUnit;
		}

		PaymentStream.prototype.getTermLength = function(targetUnit){

			return unitAndFrequencyConverter.convertUnit(this.termLength, this.termUnit, targetUnit);
		};

		PaymentStream.prototype.getTermUnitLabel = function(){

			var processedLabel = this.termUnit.label.toLowerCase();
			if(this.termLength === 1) {
				processedLabel = processedLabel.replace(/s$/, "");
			}

			return processedLabel;
		};

		PaymentStream.prototype.getRate = function(){

			var rate = 0;
			if(this.components[0].rateStream){

				var rateStream = this.components[0].rateStream;
				rate = getCalculatedRateAmount(rateStream);

				rate = unitAndFrequencyConverter.convertFrequency(rate, rateStream.components[0].frequency, this.components[0].frequency);
			}

			return rate / 100;
		};

		PaymentStream.prototype.getAnnualRate = function(){

			var annualRate = 0;

			if(this.components[0].rateStream){
				var rateStream = this.components[0].rateStream;
				var rate = getCalculatedRateAmount(rateStream);

				annualRate = unitAndFrequencyConverter.convertFrequency(rate, rateStream.components[0].frequency, "Frequency_Annually");
			}

			return annualRate;
		};

		function getCalculatedRateAmount(rateStream){

			var rate = 0;
			if(rateStream) {

				var rateComponent = rateStream.components[0];
				if(rateComponent.isFixed){
					rate = rateComponent.rate;
				} else {
					rate = rateComponent.currentIndex + rateComponent.spread;
				}
			}

			return rate;
		}

		PaymentStream.prototype.getWeightedRate = function(streamComponent, interestRate) {

			var rate = (interestRate == null ? 0 : interestRate);
			var annualFrequency = unitAndFrequencyConverter.getFrequencyByName('Frequency_Annually');

			if(streamComponent.rateStream) {
				rate = getWeightedRateAmount(streamComponent.rateStream);
			}

			rate = unitAndFrequencyConverter.convertFrequency(rate, annualFrequency, streamComponent.frequency);

			return rate / 100;
		};

		PaymentStream.prototype.getWeightedAnnualRate = function(streamComponent){

			var annualRate = 0;

			if(streamComponent.rateStream){
				var rateStream = streamComponent.rateStream;
				var rate = getWeightedRateAmount(rateStream);

				annualRate = unitAndFrequencyConverter.convertFrequency(rate, rateStream.components[0].frequency, "Frequency_Annually");
			}

			return annualRate;
		};

		function getWeightedRateAmount(rateStream){

			var weightedRate = 0;
			if(rateStream) {
				angular.forEach(rateStream.components, function(component, key) {
					weightedRate += (component.isFixed ? component.rate : component.currentIndex + component.spread) * (component.appliedLoanPercentage/100);
				}, weightedRate);
			}

			return weightedRate;
		}

		PaymentStream.prototype.checkLoanInputs = function(loan){
			return null;
		};

		PaymentStream.prototype.hasPartialPeriod = function(streamFrequency) {

			var paymentUnit = unitAndFrequencyConverter.getUnitForFrequency(streamFrequency);
			var numberPeriods = unitAndFrequencyConverter.convertUnit(this.termLength, this.termUnit, paymentUnit);

			return (numberPeriods % 1 !== 0);
		};

		return PaymentStream;

	}]);
})();
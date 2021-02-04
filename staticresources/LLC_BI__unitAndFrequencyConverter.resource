(function() {
	angular.module('ncRateAndPayment')
	.factory("unitAndFrequencyConverter", ['$q', 'timePeriodRemoting', 'messageService', 'label',
	function($q, timePeriodRemoting, messageService, label){

			var frequencies = [];
			var units = [];
			var deferred = $q.defer();

			return {
				getUnits: getUnits,
				getUnitByName: getUnitByName,
				getFrequencies: getFrequencies,
				getFrequencyByName: getFrequencyByName,
				convertUnit: convertUnit,
				convertFrequency: convertFrequency,
				getUnitsInFrequency: getUnitsInFrequency,
				getUnitForFrequency: getUnitForFrequency,
				getUnitByFrequency: getUnitByFrequency,
				getFrequencyByFrequency: getFrequencyByFrequency
			};

		function getFrequencies(){
			if(frequencies.length>0){
				return frequencies;
			}else{
				return timePeriodRemoting.getPeriodMetaData(label.getLabels().PeriodFrequency)
				.then(function(result){
					frequencies = result;
					return frequencies;
				}, handleError);
			}
		}

		function getUnits() {
			if(units.length>0){
				return units;
			}else{
				return timePeriodRemoting.getPeriodMetaData(label.getLabels().PeriodUnit)
				.then(function(result){
					units = result;
					return units;
				}, handleError);
			}
		}

		function getUnitByName(name) {
			return _.findWhere(units, {developerName: name});
		}

		function getFrequencyByName(name){

			return _.findWhere(frequencies, {developerName: name});
		}

		function getUnitByFrequency(_frequency){
			return _.findWhere(units, {frequency: _frequency});
		}

		function getFrequencyByFrequency(_frequency){
			return _.findWhere(frequencies, {frequency: _frequency});
		}

		function convertUnit(sourceValue, sourceUnit, targetUnit) {

			var convertedSource = convertInput(sourceUnit, getUnitByName);
			var convertedTarget = convertInput(targetUnit, getUnitByName);

			return sourceValue * (convertedTarget.ratio / convertedSource.ratio);
		}

		function convertFrequency(sourceValue, sourceFrequency, targetFrequency) {

			var convertedSource = convertInput(sourceFrequency, getFrequencyByName);
			var convertedTarget = convertInput(targetFrequency, getFrequencyByName);

			return sourceValue * (convertedTarget.ratio / convertedSource.ratio);
		}

		function getUnitsInFrequency(sourceUnit, targetFrequency){

			return targetFrequency.ratio * sourceUnit.ratio;
		}

		function getUnitForFrequency(frequencyObj) {
			return (frequencyObj ? _.findWhere(units, {frequency: frequencyObj.frequency}) : undefined);
		}

		function convertInput(input, conversionFunction){

			var convertedInput = input;

			if(_.isString(input)){
				convertedInput = conversionFunction(input);
			}

			return convertedInput;
		}

		function handleError(message){
			messageService.setMessage({text: message, type: messageService.messageTypes.error});
		}
	}]);
})();
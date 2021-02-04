"use strict";
(function() {
	angular
		.module('ncRateAndPayment')
		.factory('rateStructureLookupService', ['$q', 'rateStructureRemoting',

	function($q, rateStructureRemoting) {

		var rateStructure = null;
		var indexRates;

		return {
			initialize: initialize,
			lookupRateStream: lookupRateStream
		};

		function initialize(loanId){

			return rateStructureRemoting.getIndexRates()
						.then(function(indexRateResult){
							indexRates = indexRateResult;

							return rateStructureRemoting.getStreams(loanId);
						})
						.then(function(structure){

							rateStructure = structure;
							sortRateStructure();
							assignCurrentIndexValues();
						});
		}

		function sortRateStructure(){
			rateStructure.sort(function(a, b){
				return moment(a.effectiveDate).diff(moment(b.effectiveDate));
			});
		}

		function assignCurrentIndexValues(){

			rateStructure.forEach(function(stream){
				stream.components.forEach(function(component){

					if(!component.isFixed) {
						component.currentIndex = null;
						component.currentIndex = indexRates[component.index];
					}
				});
			});
		}

		function lookupRateStream(dateMoment){

			var matchedStream = null;

			if(dateMoment){
				rateStructure.forEach(function(stream){
					if(isInStream(dateMoment, stream)){
						matchedStream = stream;
					}
				});
			}

			return matchedStream;
		}

		function isInStream(dateMoment, stream){
			return (dateMoment.isSame(stream.effectiveDate) || dateMoment.isAfter(stream.effectiveDate)) &&
					 (dateMoment.isSame(stream.endDate) || dateMoment.isBefore(stream.endDate));
		}
	}]);
})();
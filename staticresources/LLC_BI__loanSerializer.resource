"use strict";
(function() {
	angular
		.module('ncRateAndPayment')
		.factory('loanSerializer', [
	function() {

		return {
			serializeLoan: serializeLoan
		};

		function serializeLoan(loan, stream, loanType) {

			var rateComponent = {};
			if (stream.components[0].rateStream==null) {
				rateComponent = {
					isFixed: true
				};
			} else {
				rateComponent = stream.components[0].rateStream.components[0];
			}

			return {
				recordId: loan.contextId,
				apexType: loanType,
				allInRate: stream.getAnnualRate(),
				pricingBasis: rateComponent.isFixed ? "Fixed" : "Floating",
				index: rateComponent.isFixed ? null : rateComponent.index,
				spread: rateComponent.isFixed ? null : rateComponent.spread,
				paymentType: stream.components[0].type,
				paymentFrequency: stream.components[0].frequency.label,
				paymentAmount: stream.components[0].amount,
				calculatedBalloonAmount: loan.calculatedBalloon
			};
		}
	}]);
})();
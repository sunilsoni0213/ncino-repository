"use strict";
(function() {
	angular
		.module('ncRateAndPayment')
		.factory('paymentStreamFactory', ['PaymentStream', 'PandIStream', 'PplusIStream', 'InterestOnlyStream',

	function(PaymentStream, PandIStream, PplusIStream, InterestOnlyStream) {

		return {
			getStreamTypes: getStreamTypes,
			extendStream: extendStream
		};

		function getStreamTypes(){
			return [ "Principal & Interest",
						"Principal + Interest",
						"Interest Only"];
		}

		function extendStream(stream) {

			var newStream = null;
			if(stream.components[0].type === "Principal & Interest"){
				newStream = new PandIStream(stream);
			} else if (stream.components[0].type === "Principal + Interest") {
				newStream = new PplusIStream(stream);
			} else if (stream.components[0].type === "Interest Only"){
				newStream = new InterestOnlyStream(stream);
			}else {
				newStream = new PaymentStream(stream);
			}

			newStream.fromSerializedApex();

			return newStream;
		}
	}]);
})();
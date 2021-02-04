(function(){
	'use strict';
	angular.module('app').provider('label', Label);
	function Label(){
		var self = this;
		self.labels = {};

		self.$get = function() {
			return {
				getLabels: function() {
					return self.labels;

				}
			}
		};

		self.setLabel = function(key,value){
			self.labels[key] = value;
		}
	}
})();

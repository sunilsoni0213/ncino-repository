(function(){
	'use strict';

	angular
		.module('selfRegisterApp')
		.directive('nStyle', nStyle);

	var DIRECTIVE_NAME = 'nStyle';

	nStyle.$inject = ['$rootScope', '$document', 'nStyleFactory', 'helperService'];

	function nStyle($rootScope, $document, nStyleFactory, helperService) {
		var directive = {
			restrict: 'A',
			link: link
		};
		return directive;

		function link($scope, element, attrs, controller) {
			var $element = jQuery(element[0]);
			var pseudoClasses = attrs[DIRECTIVE_NAME].split(' ');

			// Listen for retrieval of styles using closure / callback magic
			var client = {};
			client.clientId = helperService.generateID();
			client.applyCallback = function(args) {
				applyStyles($element, pseudoClasses, args, client.clientId);
			};
			client.completeCallback = function() {
				$element.closest('body.has-nstyle').show();
			};
			nStyleFactory.clients[client.clientId] = client;

			// Use cached styles if already available
			var styleData = nStyleFactory.retrieveStyles();
			if (styleData != null) {
				applyStyles($element, pseudoClasses, styleData, client.clientId);
			}

			// Listen for changes in the attribute value
			attrs.$observe(DIRECTIVE_NAME, function(newValue) {
				if (nStyleFactory.styles != null) {
					var newClasses = newValue.split(' ');
					applyStyles($element, newClasses, nStyleFactory.retrieveStyles(), client.clientId);
				}
			});
		}

		function applyStyles($element, pseudoClasses, styleData, clientId) {
			// Extend object to contain CSS styles from nStyleService
			var styles = {};
			for (var i = 0; i < pseudoClasses.length; i++) {
				var pClass = pseudoClasses[i];
				jQuery.extend(styles, styleData[pClass]);
			}

			// Apply CSS to $element
			$element.css(styles);

			// Tell the factory the news
			nStyleFactory.flagComplete(clientId);
		}
	}
})();
(function(){
	'use strict';

	angular
		.module('selfRegisterApp')
		.directive('displayTooltip', displayTooltip);

	function displayTooltip() {
		var directive = {
			restrict: 'A',
			scope: {
				leftPadding: '=tooltipPaddingLeft',
				spacing: '=tooltipSpacing'
			},
			link: link
		};
		return directive;

		function link($scope, element, attrs, controller) {
			/* jshint validthis: true */
			var self = this;

			var $element = jQuery(element[0]);
			$element.hide();

			// Finds the mobile tooltip area
			var $mobileTip = $element.siblings('.portal-tooltip-x-small');
			$mobileTip.children().hide();

			// Finds the neighboring icon container who triggers the mouse events
			var $icon = $element.siblings('.slds-icon_container');

			// Show and hide with mouse / touch events
			var spacing = $scope.spacing;
			var leftPadding = $scope.leftPadding;
			var toggleVisibility = function() {
				$element.css({
					position: 'absolute',
					left: (-$element.width() / 2) + ($icon.width() / 2) + leftPadding,
					top: -$element.height() - ($icon.height() / 2) - spacing
				});
				if ($element.is(':visible') || $mobileTip.children().is(':visible')) {
					$element.fadeOut();
					$mobileTip.children().fadeOut();
				}
				else {
					$element.fadeIn();
					$mobileTip.children().fadeIn();
				}
			}
			$icon.click(toggleVisibility);
			$element.siblings('span.portal-tooltip-label').click(toggleVisibility);
		}
	}
})();
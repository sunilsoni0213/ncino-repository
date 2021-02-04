(function() {
	'use strict';

	angular
		.module('selfRegisterApp')
		.constant('MESSAGE_CONSTANTS', {
			'TYPE_BASE': '',
			'TYPE_SUCCESS': 'slds-theme--success',
			'TYPE_WARNING': 'slds-theme--warning',
			'TYPE_ERROR': 'slds-theme--error'
		})
		.directive('portalMessage', portalMessage);

	portalMessage.$inject = ['$rootScope', 'label', 'MESSAGE_CONSTANTS', 'NAV_EVENTS'];

	function portalMessage($rootScope, label, MESSAGE_CONSTANTS, NAV_EVENTS) {
		var directive = {
			restrict: 'E',
			replace: true,
			link: link,
			template: '<div id="portal-messages" class="slds-notify_container"></div>'
		};
		return directive;

		function link($scope, element, attrs) {
			var $element = jQuery(element[0]);

			$scope.label = label.getLabels();

			$rootScope.$on('SHOW_MESSAGE', function(e, args) {
				showMessage(args.id, args.message, args.type, args.subText);
				setTimeout(function() {
					jQuery('#msg-' + args.id).remove();
				}, 30000);
			});

			$rootScope.$on(NAV_EVENTS.SAVE_FORM, function(e, args) {
				closeAll();
			});

			$rootScope.$on(NAV_EVENTS.NAVIGATE, function(e, args) {
				closeAll();
			});

			jQuery('.slds-notify_container').on('click', '.close-portal-message', function(e) {
				jQuery(this).parent().remove();
			});

			function showMessage(id, msg, type, txt) {
				var subText = txt || '';
				if (!subText && type == MESSAGE_CONSTANTS.TYPE_ERROR) {
					subText = $scope.label.Error_Message_Subtext;
				}
				var iconPath = attrs.sldsPath + '/assets/icons/utility-sprite/svg/symbols.svg#info';
				if (type == MESSAGE_CONSTANTS.TYPE_ERROR || type == MESSAGE_CONSTANTS.TYPE_WARNING) {
					iconPath = attrs.sldsPath + '/assets/icons/utility-sprite/svg/symbols.svg#warning';
				}

				// Hide prior toast messages
				jQuery('.slds-notify--toast').hide();

				var message = '<div id="msg-' + id + '" class="slds-notify portal-toast slds-notify--toast ' + type + '" role="alert">' +
						'<span class="slds-assistive-text">Error</span>' +
						'<button class="slds-button slds-button--icon-inverse slds-notify__close close-portal-message">' +
						'<svg aria-hidden="true" class="slds-button__icon slds-button__icon--large">' +
						'<use xlink:href="' + attrs.sldsPath + '/assets/icons/utility-sprite/svg/symbols.svg#close"></use>' +
						'</svg><span class="slds-assistive-text">Close</span>' +
						'</button>' +
						'<div class="slds-notify__content slds-grid">' +
						'<svg aria-hidden="true" class="slds-icon slds-icon--small slds-m-right--small slds-col slds-no-flex">' +
						'<use xlink:href="' + iconPath + '"></use>' +
						'</svg>' +
						'<div class="slds-col slds-align-middle">' +
						'<h2 class="slds-text-heading--small">' + msg + '</h2>' +
						'<p>' + subText + '</p>' +
						'</div>' +
						'</div>' +
						'</div>';
				$element.append(message);
			}

			function closeAll() {
				// Release all message divs when the single page app advances or navigates away
				jQuery(".portal-toast").each(function (i, msg) {
					msg.remove();
				});
			}
		}
	}
})();
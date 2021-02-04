(function(){
	angular
		.module('ncinoUi')
		.factory('messageHandler', messageHandler);

	function messageHandler(){
		return {
			handleError: handleError,
			clearError: clearError
		};

		function handleError(message){
			if(!_.isUndefined(LifeCycle.MessageHandler)){
				jQuery(window.document).trigger(LifeCycle.MessageHandler.Topics.ERROR, message);
			}
		}

		function clearError(){
			if(!_.isUndefined(LifeCycle.MessageHandler)){
				jQuery(window.document).trigger(LifeCycle.MessageHandler.Topics.CLEAR_ERROR);
			}
		}
	}
})();
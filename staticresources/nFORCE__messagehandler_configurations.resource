(function(){
	var Configurations = {
		SuccessMessage: {
			styleClass: '',
			defaultCallback: function(message){
				if(jQuery(this.element()).queue('fx') == 0){
					this.message(message);
					jQuery(this.element()).fadeIn(200);
					jQuery(this.element()).fadeOut(2500);
				}
			},
			subscriptions: [
				{topic: LifeCycle.MessageHandler.Topics.SUCCESS},
				{topic: LifeCycle.MessageHandler.Topics.DELETE}
			]
		},
		ErrorMessage: {
			styleClass: '',
			init: function(){
				jQuery(this.element()).remove().prependTo('.force .ui-container .message-container');
				this.header(LifeCycle.msgs.msg_error_header);
			},
			subscriptions: [
				{
					topic: LifeCycle.MessageHandler.Topics.ERROR,
					callback: function(message){
						if(message){
							this.message(_.unescape(message).replace(/&#39;/g, "'").replace(/([:.])\s{3,}/g, '$1\n- '));
							jQuery(this.element()).show();
						}
					}
				},
				{
					topic: LifeCycle.MessageHandler.Topics.CLEAR_ERROR,
					callback: function(){
						jQuery(this.element()).hide();
					}
				}]
		}
	};
	if(LifeCycle.MessageHandler.Configurations == undefined){
		LifeCycle.MessageHandler.Configurations = {};
	}
	_.extend(LifeCycle.MessageHandler.Configurations, Configurations);
})();
(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			self.app = app;
			var defaultData = {};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			_.each(self.buttonSubs(), function(value){
				this.app.publish(value.pubTopic());
				if(!_.isNull(value.subTopic()) && !_.isNull(value.buttonId())){
					this.app.subscribe(value.subTopic(), function(){
						var buttons = jQuery('.ui-container [id$=":'+value.buttonId()+'"]');
						if(buttons.length){
							buttons[0].click();
						}
					});
				}
			}, self);
			app.log('ViewModel instantiated.');
			return self;
		}
		app.log('ViewModel initialized.');
	};
	if(LifeCycle.LegacyVFButtonHandler.ViewModel == undefined){
		LifeCycle.LegacyVFButtonHandler.ViewModel = ViewModel;
	}
})();

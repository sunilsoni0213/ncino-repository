(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			self.app = app;
			var defaultData = {
					init: null,
					header: null,
					message: null,
					styleClass: null,
					element: null,
					defaultCallback: function(message){this.message(message);},
					subscriptions: [{topic: null, callback: null}]
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.removeMessage = function(){
				jQuery(self.element()).hide();
			};

			_.each(self.subscriptions(), function(value){
				var callback = _.isFunction(value.callback) ? value.callback : this.defaultCallback;
				if(!_.isNull(value.topic()) && _.isFunction(callback)){
					this.app.subscribe(value.topic(), _.bind(callback, this));
				}
			}, self);

			if(_.isFunction(self.init)){
				_.bind(self.init, self)();
			}
			if(!_.isNull(self.element()) && !_.isNull(self.styleClass())){
				jQuery(self.element()).addClass(self.styleClass());
			}

			app.log('ViewModel instantiated.');
			return self;
		}
		app.log('ViewModel initialized.');

	};
	if(LifeCycle.MessageHandler.ViewModel == undefined){
		LifeCycle.MessageHandler.ViewModel = ViewModel;
	}
})();

(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			self.app = app;
			var defaultData = {
				contextObject: '',
				screenSection: ''
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			
			self.load = function(callback){
				app.retrieve(self.contextObject, function(arguments){
					app.retrieve(self.screenSection, function(arguments){
						app.retrieve(self.screenSection.widget, function(arguments){
							callback.apply();
							}, { buffer: false });
						}, { buffer: false });
				}, { buffer: false });
			};

			self.save = function(data){
				app.save(app.mapToJS(data), function(){});
			};

			return self;
		}
	};
	if(LifeCycle.Default_Widget.ViewModel == undefined){
		LifeCycle.Default_Widget.ViewModel = ViewModel;
	}
})();

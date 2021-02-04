(function(){
	var View = function(event, app){
		app.View = function(viewModel){
			var self = this;
			app.log('View instantiated.');
			
			return self;
		}
		app.log('View initialized.');
	};
	if(LifeCycle.SpreadConfigApp == undefined){
		LifeCycle.SpreadConfigApp = {};
	}
	if(LifeCycle.SpreadConfigApp.View == undefined){
		LifeCycle.SpreadConfigApp.View = View;	
	}
})();
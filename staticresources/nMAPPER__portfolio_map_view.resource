(function(){
	var View = function(event, app){
		app.View = function(viewModel){
			var self = this;
			viewModel.load();
			app.log('View instantiated.');
			
			return self;
		}
		app.log('View initialized.');
	};
	if(LifeCycle.Portfolio_Map == undefined){
		LifeCycle.Portfolio_Map = {};
	}
	if(LifeCycle.Portfolio_Map.View == undefined){
		LifeCycle.Portfolio_Map.View = View;
	}
})();
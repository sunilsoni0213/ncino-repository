(function(){
	var View = function(event, app){
		app.View = function(viewModel){
			var self = this;
			app.log('View instantiated.');
			
			return self;
		}
		app.log('View initialized.');
	};
	if(LifeCycle.LayoutDesigner == undefined){
		LifeCycle.LayoutDesigner = {};
	}
	if(LifeCycle.LayoutDesigner.View == undefined){
		LifeCycle.LayoutDesigner.View = View;	
	}
})();
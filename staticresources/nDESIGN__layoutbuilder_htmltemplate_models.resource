(function(){
	var Models = function(event, app){
		if(_.isUndefined(app.Html)){
			app.Html = {};
		}
		if(_.isUndefined(app.Html.Template)){
			app.Html.Template = {};
		}
		app.Html.Template.Provider = {
			createElement: function(data){
				var element = null;
				if(!_.isEmpty(data.tag)){
					element = jQuery("<"+data.tag+" />");
				}
				else{
					throw 'tag must be defined and not null';
				}
				
				if(!_.isUndefined(data.binding)){
					element.attr("data-bind", data.binding);
				}
				if(!_.isUndefined(data.attributes)){
					element.attr(data.attributes);
				}
				if(!_.isUndefined(data.classes)){
					element.addClass(data.classes);
				}
				if(!_.isUndefined(data.content)){
					element.html(data.content);
				}
				return element;
			},
			generateUniqueFieldId: function(fieldName){
				return _.uniqueId(fieldName + '_');
			}
		};
		app.Html.Template.Div = function(binding){
			return app.Html.Template.Provider.createElement({
				tag: 'div',
				binding: binding
			});
		};
		app.log('Html.Template initialized.');
	};
	if(LifeCycle.LayoutBuilder == undefined){
		LifeCycle.LayoutBuilder = {};
	}
	if(LifeCycle.LayoutBuilder.Html == undefined){
		LifeCycle.LayoutBuilder.Html = {};
	}
	if(LifeCycle.LayoutBuilder.Html.Template == undefined){
		LifeCycle.LayoutBuilder.Html.Template = Models;
	}
}());
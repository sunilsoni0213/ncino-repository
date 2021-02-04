(function(){
	var Models = function(event, app){
		var defaultModelData = {
			recordId : null,
			name : '',
			disabled: false
		};

		app.Header = function(data){
			var self = this;
			var defaultData = _.extend({
					visible: true
				}, defaultModelData);

			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			return self;
		};

		app.DataType = function(data){
			var self = this;
			var defaultData = _.extend({
				options: []
			}, defaultModelData);

			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			return self;
		}
		app.Column = function(data){
			var self = this;
			var defaultData = _.extend({
					header: '',
					sortOrder: '',
					dataType: '',
					showTotal: '',
					value: ''
				}, defaultModelData);

			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			return self;
		};
		
		app.log('Models initialized.');

		app.setMapping({
			'tenantInfoColumns': {
				create: function(options){
					return new app.Column(options.data);
				}
			},
			'header': {
				create: function(options){
					return new app.Header(options.data);
				}
			},
			'dataType': {
				create: function(options){
					return new app.DataType(options.data);
				}
			}
		});
	};
	if(LifeCycle.LifeCycle_App == undefined){
		LifeCycle.LifeCycle_App = {};
	}
	if(LifeCycle.LifeCycle_App.Models == undefined){
		LifeCycle.LifeCycle_App.Models = Models;
	}
})();

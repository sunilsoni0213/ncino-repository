(function(){
	var Models = function(event, app){
		var defaultModelData = {
			recordId : null,
			name : '',
			isLoaded : false,
			isSaved : false,
			disabled: false
		};
		app.ScreenSection = function(data){
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('screenSection'),
				widget: ''
			}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;	
		};
		app.Widget = function(data){
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('widget'),
				data: '',
				parameters: '',
				icon: '',
				scriptResourceOne: '',
				scriptResourceTwo: '',
				scriptResourceThree: '',
				scriptResourceFour: '',
				scriptResourceFive: '',
				scriptResourceSix: '',
				scriptResourceSeven: '',
				scriptResourceEight: '',
				scriptResourceNine: '',
				scriptResourceTen: '',
				styleSheetResourceOne: '',
				styleSheetResourceTwo: '',
				styleSheetResourceThree: '',
				styleSheetResourceFour: '',
				styleSheetResourceFive: '',
				styleSheetResourceSix: '',
				styleSheetResourceSeven: '',
				styleSheetResourceEight: '',
				styleSheetResourceNine: '',
				styleSheetResourceTen: ''
				}, defaultModelData);
			
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.Screen = function(data){
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('screen'),
				lookupKey: '',
				screenSections: []
			}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.setMapping({
			'screen': {
				create: function(options){
					return new app.Screen(options.data);
				}
			},
			'screens': {
				create: function(options){
					return new app.Screen(options.data);
				}
			},
			'screenSection': {
				create: function(options){
					return new app.ScreenSection(options.data);
				}
			},
			'screenSections': {
				create: function(options){
					return new app.ScreenSection(options.data);
				}
			},
			'widget': {
				create: function(options){
					return new app.Widget(options.data);
				}
			},
			'parameters': {
                create: function(options){
                        return ko.observable({});
                },
                update: function(options){
                        var params = {};
                        if(_.isString(options.data) && !_.isEmpty(options.data)){
                                _.map(options.data.split(';'), function(element){
                                        var param = element.split(':');
                                        params[param[0]] = param[1];
                                });
                        }
                        return app.mapFromJS(params, app.getMapping(), options.target);
                }
        	}
		});
		app.setTypesMap({
			'LifeCycleScreen': 'screen',
			'LifeCycleScreenSection': 'screenSection',
			'LifeCycleWidget': 'widget'
		});
		app.log('Screen Models initialized.');
	};
	if(LifeCycle.Screen == undefined){
		LifeCycle.Screen = {};
	}
	if(LifeCycle.Screen.Models == undefined){
		LifeCycle.Screen.Models = Models;
	}
})();
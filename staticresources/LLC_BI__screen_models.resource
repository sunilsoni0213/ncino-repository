(function(){
	var Models = function(event, app){
		var defaultModelData = {
			recordId : null,
			name : '',
			isLoaded : false,
			isSaved : false,
			disabled: false
		};
		app.ScreenSegment = function(data) {
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('screenSegment'),
				screen: {},
				screenSection: {}
			}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.ScreenSection = function(data){
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('screenSection')
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
			'screenSegment': {
				create: function(options){
					return new app.ScreenSegment(options.data);
				}
			},
			'screenSegments': {
				create: function(options){
					return new app.ScreenSegment(options.data);
				}
			}
		});
		app.setTypesMap({
			'Screen': 'screen',
			'LifeCycleScreen': 'screen',
			'ScreenSection': 'screenSection',
			'LifeCycleScreenSection': 'screenSection',
			'ScreenSegment': 'screenSegment',
			'LifeCycleScreenSegment': 'screenSegment'
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
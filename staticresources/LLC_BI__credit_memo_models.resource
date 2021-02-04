(function(){
	var Models = function(event, app){
		var defaultModelData = {
			recordId : null,
			name : '',
			isLoaded : false,
			isSaved : false,
			disabled: false
		};
		app.CreditMemo = function(data){
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('creditMemo'),
				description: '',
				lookupKey: '',
				screen: {}
			}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.CreditMemoTemplate = function(data){
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('creditMemoTemplate'),
				description: '',
				freeTextSearchField: '',
				lookupKey: '',
				screen: {}
			}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.CreditMemoScreenContainer = function(data) {
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('creditMemoScreenContainer'),
				description: '',
				freeTextSearchField: '',
				lookupKey: '',
				creditMemoScreens: []
			}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.CreditMemoScreen = function(data) {
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('creditMemoScreen'),
				description: '',
				freeTextSearchField: '',
				lookupKey: '',
				creditMemo: {},
				screen: {}
			}, defaultModelData);
			if (data != undefined) {
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.CreditMemoContainer = function(data){
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('creditMemoContainer'),
				creditMemo: '',
				freeTextSearchField: '',
				relatedObjectId: null
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
		app.setMapping({
			'creditMemo': {
				create: function(options){
					return new app.CreditMemo(options.data);
				}
			},
			'creditMemos': {
				create: function(options){
					return new app.CreditMemo(options.data);
				}
			},
			'creditMemoTemplate': {
				create: function(options){
					return new app.CreditMemoTemplate(options.data);
				}
			},
			'creditMemoTemplates': {
				create: function(options){
					return new app.CreditMemoTemplate(options.data);
				}
			},
			'creditMemoScreenContainer': {
				create: function(options){
					return new app.CreditMemoScreenContainer(options.data);
				}
			},
			'creditMemoScreen': {
				create: function(options){
					return new app.CreditMemoScreen(options.data);
				}
			},
			'creditMemoContainer': {
				create: function(options){
					return new app.CreditMemoContainer(options.data);
				}
			},
			'screenSection': {
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
			'CreditMemo': 'creditMemo',
			'LifeCycleCreditMemo': 'creditMemo',
			'LifeCycleCreditMemoTemplate': 'creditMemoTemplate',
			'LifeCycleCreditMemoScreenContainer': 'creditMemoScreenContainer',
			'CreditMemoScreen': 'creditMemoScreen',
			'LifeCycleCreditMemoScreen': 'creditMemoScreen',
			'CreditMemoContainer': 'creditMemoContainer',
			'LifeCycleCreditMemoContainer': 'creditMemoContainer',
			'LifeCycleWidget': 'widget',
			'LifeCycleScreenSection': 'screenSection'
		});
		app.log('Credit Memo Models initialized.');
	};
	if(LifeCycle.CreditMemo == undefined){
		LifeCycle.CreditMemo = {};
	}
	if(LifeCycle.CreditMemo.Models == undefined){
		LifeCycle.CreditMemo.Models = Models;
	}
})();
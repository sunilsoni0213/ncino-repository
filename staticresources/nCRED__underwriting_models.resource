(function(){
	var Models = function(event, app){
		var defaultModelData = {
			recordId : null,
			name : '',
			isLLCBI: false,
			isLoaded : false,
			isSaved: false
		};
		var defaultForceModelData = {
			recordId : null,
			name : ''
		};
		app.StatementBundles = function(data, shallow){
			var self = this;
			var defaultData = {};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			var mapping = {};
			mapping[app.mapApexFromModel('iUnderwritingBundle')] = {
				create: function(options){
					return new app.UnderwritingBundle(options.data, options.useViewModelPlugin);
				}
			};
			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, mapping, self);
			}
			
			return self;
		};
		
		/**
		 * @typedef {app.Underwriting} KOUnderwritingSummary
		 * @implements IForceKO
		 * @type Object
		 *
		 * @property {function(): string} apexType
		 * @property {function(): string} recordId
		 * @property {function(): string} name
		 * @property {function(): boolean} isLLCBI
		 * @property {function(): boolean} isLoaded
		 * @property {function(): boolean} isSaved
		 * @property {Object} __ko_mapping__
		 *
		 * @returns {KOUnderwritingSummary}
		 * @constructor
		 */
		app.Underwriting = function(data, shallow){
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('underwriting')
			}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, app.getMapping(), self);
			}
			
			return self;
		};
		
		/**
		 * @typedef {app.UnderwritingBundle} KOUnderwritingBundle
		 * @implements IForceKO
		 * @type Object
		 *
		 * @property {function(): string} apexType
		 * @property {function(): string} description
		 * @property {function(): boolean} showFootnotes
		 * @property {KORelationship} container
		 * @property {function(): Array<KOStatement>} statements
		 * @property {function(): Array<KOCovenantCompliance>} covenantCompliances
		 * @property {function(): string} scale
		 * @property {function(): string} recordId
		 * @property {function(): string} name
		 * @property {function(): boolean} isLLCBI
		 * @property {function(): boolean} isLoaded
		 * @property {function(): boolean} isSaved
		 * @property {function(): boolean} __shallow
		 * @property {boolean} __placeholder
		 * @property {function(): number} scaleDivisor
		 * @property {Object} __ko_mapping__
		 * @property {Object} __changeTracking
		 * @property {boolean} __cached
		 * @property {function} __retrieve
		 * @property {function(): boolean} isTemplate
		 * @property {function(): boolean} disabled
		 * @property {function(): string} freeTextSearchField
		 * @property {function(): boolean} isRelationshipPointer
		 * @property {function(): boolean} saved
		 *
		 * @returns {KOUnderwritingBundle}
		 * @constructor
		 */
		app.UnderwritingBundle = function(data, shallow){
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('underwritingBundle'),
				description: '',
				showFootnotes: false,
				container: {},
				statements: [],
				covenantCompliances: [],
				scale: null
			}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}

			var mapping = jQuery.extend(true, {}, app.getMapping());
			mapping.ignore.covenantCompliances = true;

			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, app.getMapping(), self);
			}

			self.scaleDivisor = ko.computed(function () {
				switch (self.scale()) {
					case 'm':
					case 'M':
						return 1000;
					case 'mm':
					case 'MM':
						return 1000000;
					case '$':
					default:
						return 1;
				}
			}, {deferEvaluation: true});

			if( (['$','m','mm']).indexOf(self.scale()) == -1 ){
				self.scale('$');
			}
			
			return self;
		};
		
		/**
		 *
		 * @param data
		 * @param shallow
		 * @return {KOUnderwritingBundle}
		 * @constructor
		 */
		app.UnderwritingBundleTemplate = function(data, shallow){
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('underwritingBundleTemplate'),
				description: '',
				freeTextSearchField: '',
				container: {},
				statements: []
			}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, app.getMapping(), self);
			}
			
			return self;
		};

		app.setMapping({
			'underwriting': {
				create: function(options){
					return new app.Underwriting(options.data, options.useViewModelPlugin);
				}
			},
			'underwritings': {
				create: function(options){
					return new app.Underwriting(options.data, options.useViewModelPlugin);
				}
			},
			'underwritingBundle': {
				create: function(options){
					return new app.UnderwritingBundle(options.data, options.useViewModelPlugin);
				}
			},
			'underwritingBundles': {
				create: function(options){
					return new app.UnderwritingBundle(options.data, options.useViewModelPlugin);
				}
			},
			'underwritingBundleTemplate': {
				create: function(options){
					return new app.UnderwritingBundleTemplate(options.data, options.useViewModelPlugin);
				}
			},
			'underwritingBundleTemplates': {
				create: function(options){
					return new app.UnderwritingBundleTemplate(options.data, options.useViewModelPlugin);
				}
			},
			'bundle': {
				create: function(options){
					if(options.data != undefined && options.data.isTemplate == true){
						return new app.UnderwritingBundleTemplate(options.data, options.useViewModelPlugin);
					}else{
						return new app.UnderwritingBundle(options.data, options.useViewModelPlugin);
					}
				}
			},
			'bundles': {
				create: function(options){
					if(options.data != undefined && options.data.isTemplate == true){
						return new app.UnderwritingBundleTemplate(options.data, options.useViewModelPlugin);
					}else{
						return new app.UnderwritingBundle(options.data, options.useViewModelPlugin);
					}
				}
			},
			'statementBundles': {
				create: function(options){
					return new app.StatementBundles(options.data, options.useViewModelPlugin);
				}
			},
			'container': {
				create: function(options){
					return new app.Relationship(options.data, options.useViewModelPlugin);
				}
			}
		});
		app.setTypesMap({
			'LifeCycleUnderwriting': 'underwriting',
			'LifeCycleUnderwritingBundle': 'underwritingBundle',
			'LifeCycleUnderwritingBundleTemplate': 'underwritingBundleTemplate',
			'ILifeCycleUnderwritingBundle': 'iUnderwritingBundle'
		});
		app.log('Underwriting Models initialized.');
	};
	if(LifeCycle.Underwriting == undefined){
		LifeCycle.Underwriting = {};
	}
	if(LifeCycle.Underwriting.Models == undefined){
		LifeCycle.Underwriting.Models = Models;
	}
})();

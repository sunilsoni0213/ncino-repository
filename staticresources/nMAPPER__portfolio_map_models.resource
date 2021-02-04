(function(){
	var Models = function(event, app){
		var defaultModelData = {
			name : ''
		};
		app.MapSource = function(data){
			var self = this;
			var defaultData = _.extend({
				recordId: null,
				name: '',
				label: '',
				description: '',
				isLoading: false,
				availableColumns: [],
				operatorMap: null,
				filters: [],
				locations: [],
				currentReportInstanceId: null,
				apexType: app.mapApexFromModel('MapSource')
			}, defaultModelData);

			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.addFilter = function(data){
				self.filters.push(new app.MapFilter(app.mapToJS(data)));
				self.filterToAdd.column('');
				self.filterToAdd.operator('');
				self.filterToAdd.value('');
			}

			self.removeFilter = function(data){
				self.filters.remove(data);
			}

			return self;
		};
		app.MapLocation = function(data){
			var self = this;
			var defaultData = _.extend({
				name: '',
				url: null,
				address: '',
				propertyMap: null,
				actions: [],
				generatedUrl: null,
				apexType: app.mapApexFromModel('MapLocation')
			}, defaultModelData);

			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.displayPropertyMap = ko.computed(function() {
				var properties = [];
				_.each(self.propertyMap, function(objValue, objKey){
					if (properties.length < 5){
						if (objValue == '-'){
							properties.push({ key: objKey, value: '' });
						} else {
							properties.push({ key: objKey, value: objValue });
						}
					}
				});

				return properties;
			});

			return self;
		};
		app.MapAddress = function(data){
			var self = this;
			var defaultData = _.extend({
				street: '',
				city: '',
				state: '',
				zipCode: '',
				country: '',
				latitude: null,
				longitude: null,
				apexType: app.mapApexFromModel('MapAddress')
			}, defaultModelData);

			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.formattedAddress = ko.computed(function(){
				var addressFormat = '';

				if (self.street().indexOf(self.city()) > -1){
					console.log()
					addressFormat = '{0}';

				} else if (!_.isUndefined(self.street()) && !_.isEmpty(self.street()) &&
					!_.isUndefined(self.city()) && !_.isEmpty(self.city()) &&
					!_.isUndefined(self.state()) && !_.isEmpty(self.state()) &&
					!_.isUndefined(self.zipCode()) && !_.isEmpty(self.zipCode())){

					addressFormat = '{0}<br />{1}, {2} {3}';

				} else if (!_.isUndefined(self.city()) && !_.isEmpty(self.city()) &&
					!_.isUndefined(self.state()) && !_.isEmpty(self.state()) &&
					!_.isUndefined(self.zipCode()) && !_.isEmpty(self.zipCode())){

					addressFormat = '{1}, {2} {3}';

				} else if (!_.isUndefined(self.city()) && !_.isEmpty(self.city()) &&
					!_.isUndefined(self.state()) && !_.isEmpty(self.state())){

					addressFormat = '{1}, {2}';

				}

				return String.format(addressFormat, self.street(), self.city(), self.state(), self.zipCode());
			});

			return self;
		};
		app.MapAction = function(data){
			var self = this;
			var defaultData = _.extend({
				label: '',
				description: '',
				objectName: '',
				url: '',
				contextId: '',
				generatedUrl: '',
				apexType: app.mapApexFromModel('MapAction')
			}, defaultModelData);

			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			return self;
		};
		app.MapFilter = function(data){
			var self = this;
			var defaultData = _.extend({
				availableColumns: [],
				operatorMap: {},
				column: '',
				operator: '',
				value: '',
				apexType: app.mapApexFromModel('MapFilter')
			}, defaultModelData);

			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.availableOperators = ko.computed(function(){
				var selectedColumnDataType = null;
				_.each(self.availableColumns(), function(col){
					if (col.name() === self.column()){
						selectedColumnDataType = col.dataType();
					}
				});
				var obj =  self.operatorMap[selectedColumnDataType];
				var properties = [];
				for (var key in obj) {
					if (obj.hasOwnProperty(key)) {
						properties.push({ name: key, value: obj[key]() });
					}
				}
				return properties;
			});

			return self;
		};
		app.FilterableColumn = function(data){
			var self = this;
			var defaultData = _.extend({
				label: '',
				dataType: '',
				apexType: app.mapApexFromModel('FilterableColumn')
			}, defaultModelData);

			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			return self;
		};
		app.setMapping({
			'availableMapSources': {
				create: function(options){
					return new app.MapSource(options.data);
				}
			},
			'selectedMapSources': {
				create: function(options){
					return new app.MapSource(options.data);
				}
			},
			'currentMapSources': {
				create: function(options){
					return new app.MapSource(options.data);
				}
			},
			'mapSources': {
				create: function(options){
					return new app.MapSource(options.data);
				}
			},
			'locations': {
				create: function(options){
					return new app.MapLocation(options.data);
				}
			},
			'address': {
				create: function(options){
					return new app.MapAddress(options.data);
				}
			},
			'actions': {
				create: function(options){
					return new app.MapAction(options.data);
				}
			},
			'filters': {
				create: function(options){
					return new app.MapFilter(options.data);
				}
			},
			'filterToAdd': {
				create: function(options){
					return new app.MapFilter(options.data);
				}
			},
			'availableColumns': {
				create: function(options){
					return new app.FilterableColumn(options.data);
				}
			}
		});
		app.setTypesMap({
			'MapSourceReport': 'MapSource',
			'MapLocation': 'MapLocation',
			'MapAddress': 'MapAddress',
			'MapAction': 'MapAction',
			'MapFilter': 'MapFilter',
			'FilterableColumn': 'FilterableColumn'
		});
		app.log('Models initialized.');
	};
	if(LifeCycle.Portfolio_Map == undefined){
		LifeCycle.Portfolio_Map = {};
	}
	if(LifeCycle.Portfolio_Map.Models == undefined){
		LifeCycle.Portfolio_Map.Models = Models;
	}
})();
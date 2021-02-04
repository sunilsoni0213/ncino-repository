(function(){
	var Models = function(event, app) {
		app.Address = function(data) {
			var self = this;
			var defaultData = {
				city: null,
				country: null,
				postalCode: null,
				state: null,
				street: null
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.Contact = function(data) {
			var self = this;
			var defaultData = {
				birthTimestamp: null,
				mailingAddress: null,
				ssn: null
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.birthDate = ko.computed(function() {
				var bDay = self.birthTimestamp();
				return (bDay!=undefined) 
					? moment(bDay).utc().format('MM/DD/YYYY')
					: null;
			}, this);
			return self;
		};
		app.Match = function(data) {
			var self = this;
			var defaultData = {
				birthDate: null,
				comments: null,
				entityAddresses: [],
				entityName: null,
				entityScore: null,
				gender: null,
				nationality: null,
				placeOfBirth: null,
				reasonListed: null,
				watchListName: null
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.Relationship = function(data) {
			var self = this;
			var defaultData = {
				name: null,
				entityType: null,
				isIndividual: false,
				primaryContact: null,
				shippingAddress: null,
				taxIdentificationNumber: null
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.address = ko.computed(function() {
				var address = null;
				if (self.isIndividual()) {
					if (self.primaryContact!=undefined) {
						address = self.primaryContact.mailingAddress;
					}
				} else {
					address = self.shippingAddress;
				}
				return address;
			}, this);
			return self;
		};
		app.Response = function(data) {
			var self = this;
			var defaultData = {
				relationship: null,
				watchListMatches: []
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.watchLists = ko.computed(function() {
				var index = 0;
				return _.chain(self.watchListMatches())
					.groupBy(function(match) {
						return match.watchListName();
					})
					.map(function(value, key) {
						index++;
						return {
							name: key,
							index: index,
							matches: value
						};
					})
					.sortBy(function(watchList) {
						return watchList.name;
					})
					.value();
			}, this);
			return self;
		};
		app.setMapping({
			'entityAddresses': {
				create: function(options){
					return new app.Address(options.data);
				}
			},
			'mailingAddress': {
				create: function(options){
					return new app.Address(options.data);
				}
			},
			'primaryContact': {
				create: function(options){
					return new app.Contact(options.data);
				}
			},
			'relationship': {
				create: function(options){
					return new app.Relationship(options.data);
				}
			},
			'response': {
				create: function(options){
					return new app.Response(options.data);
				}
			},
			'shippingAddress': {
				create: function(options){
					return new app.Address(options.data);
				}
			},
			'watchListMatches': {
				create: function(options){
					return new app.Match(options.data);
				}
			}
		});
		app.log('Models initialized.');
	};
	if(LifeCycle.WatchlistReport == undefined){
		LifeCycle.WatchlistReport = {};
	}
	if(LifeCycle.WatchlistReport.Models == undefined){
		LifeCycle.WatchlistReport.Models = Models;
	}
})();
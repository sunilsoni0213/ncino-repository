(function(){
	var Models = function(event, app){
		var defaultModelData = {
			recordId : null,
			name : '',
			disabled: false
		};
		app.Tenant = function(data){
			var self = this;
			var defaultData = _.extend({
					name: '',
					squareFeet: 0,
					isEditing: false,
					tenantInfoColumns: [],
					currentYear: '',
					rentInfo: []	
				}, 
				defaultModelData);
			
			if(data != undefined){
				_.extend(defaultData, data);
			}

			app.mapFromJS(defaultData, app.getMapping(), self);

			self.selectedRentInfo = ko.computed(function() {
				var filter = ko.utils.arrayFilter(self.rentInfo(), function(rentInfo) {
					return rentInfo.year() == self.currentYear();
				});

				if (!_.isUndefined(filter)) {
					return filter[0];
				}
			});

			self.validationModel = ko.validatedObservable({
				name: self.name.extend({
					required: true
				}),
				squareFeet: self.squareFeet.extend({
					required: true,
					number: true
				})
			});
			
			return self;
		};
		app.RentRollPeriod = function(data){
			var self = this;
			var defaultData = _.extend({
				year: '',
				scenarios: []
			}, defaultModelData);

			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);


			return self;
		};
		app.Scenario = function(data){
			var self = this;
			var defaultData = _.extend({
				periodId: '',
				periodExternalLookupKey: '',
				rentSqFt: 0,
				isEditingSqFt: false
			}, defaultModelData);

			if(data != undefined){
				_.extend(defaultData, data);
			}

			app.mapFromJS(defaultData, app.getMapping(), self);

			self.editSqFt = function() {
				self.isEditingSqFt(true);
			}
			
			self.validationModel = ko.validatedObservable({
				rentSqFt: self.rentSqFt.extend({
					number: true
				})
			});

			return self;
		}
		app.ColumnTotal = function(data){
			var self = this;
			var defaultData = _.extend({
				periodId: '',
				total: 0
			}, defaultModelData);

			if (data != undefined) {
				_.extend(defaultData, data);
			}

			app.mapFromJS(defaultData, app.getMapping(), self);

		}
		
		app.log('Models initialized.');

		app.setMapping({
			'rentInfo': {
				create: function(options){
					return new app.RentRollPeriod(options.data);
				}
			},
			'columnTotals': {
				create: function(options){
					return new app.ColumnTotal(options.data);
				}
			},
			'scenarios': {
				create: function(options){
					return new app.Scenario(options.data);
				}
			},
			'currentTotals': {
				create: function(options){
					return new app.Scenario(options.data);
				}
			},
			'years': {
				create: function(options){
					return new app.RentRollPeriod(options.data);
				}	
			},
			'tenants': {
				create: function(options){
					return new app.Tenant(options.data);
				}
			}

		});
	};
	if(LifeCycle.Rent_Roll == undefined){
		LifeCycle.Rent_Roll = {};
	}
	if(LifeCycle.Rent_Roll.Models == undefined){
		LifeCycle.Rent_Roll.Models = Models;
	}
})();

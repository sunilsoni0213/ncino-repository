jQuery(function(){
	(function (app){
		Loan = function(data){
			var self = this;
			var defaultData = _.extend({
					amount: 0,
					apexType: LifeCycle.BorrowerTree.typeMapFlipped['LOAN'],
					relationship: {},
					borrowers: [],
					guarantors: []
				}, app.DefaultModelData);

			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.mapping.LOAN, self);
			self.show = ko.observable(false);
			self.validationModel = ko.validatedObservable({});
			self.selected = ko.observable(false);

			return self;
		};
		Package = function(data){
			var self = this;
			var defaultData = _.extend({
					apexType: LifeCycle.BorrowerTree.typeMapFlipped['PRODUCTPACKAGE'],
				}, app.DefaultModelData);

			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.mapping.PACKAGE, self);
			self.show = ko.observable(false);
			self.validationModel = ko.validatedObservable({});
			self.selected = ko.observable(false);
			return self;
		};
		Relationship = function(data){
			var self = this;
			var defaultData = _.extend({
					apexType: LifeCycle.BorrowerTree.typeMapFlipped['RELATIONSHIP'],
					entityType : undefined,
					entityTypeLabel : undefined,
					isIndividual: false,
					taxIdentificationNumber: '',
					loans: [],
					contacts: [],
					involvements: []
				},app.DefaultModelData);

			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(
					defaultData, app.mapping.RELATIONSHIP, self);

			self.showBillingAddress = ko.observable(false);
			self.showShippingAddress = ko.observable(false);
			self.show = ko.observable(false);
			self.selected = ko.observable(false);
			self.isIndividualComputed = ko.computed(function(){
				return self.entityType() == 'Sole Proprietorship' || self.entityType() == 'Individual';
			}, self);

			self.entityType.subscribe(function(newVal){
				_.each(self.involvements(), function(inv){
					_.each(inv.signers(), function(signer){
						signer.filterCapacityOptions(newVal);
					});
				});
			});
			self.fireEntityTypeChange = function(){
				var old = self.entityType();
				self.entityType('');
				self.entityType(old);
				return self;
			};
			self.validationModel = ko.validatedObservable({
					name: self.name.extend({
						required: true,
						minLength: 3,
						maxLength: 80
					}),
					entityType: self.entityType.extend({
						required: true
					})
			});

			return self;
		};
		Contact = function(data){
			var self = this;
			var defaultData = _.extend({
					apexType: LifeCycle.BorrowerTree.typeMapFlipped['CONTACT'],
					firstName : '',
					lastName : '',
					birthDate: null,
					ssn: '',
					isPrimaryContact: false,
					relationship: {},
					signings: []
				}, app.DefaultModelData);

			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.mapping.CONTACT, self);
			self.selected = ko.observable(false);
			self.show = ko.observable(false);

			self.validationModel = ko.validatedObservable({
				firstName: self.firstName.extend({
					required: {
						params: true,
						onlyIf: function(){ return self.lastName() != "" || self.selected(); }
					},
					minLength: 3,
					maxLength: 80
				}),
				lastName: self.lastName.extend({
					required: {
						params: true,
						onlyIf: function(){ return self.firstName() != "" || self.selected(); }
					},
					minLength: 3,
					maxLength: 80
				}),
				ssn: self.ssn.extend({
					required: false,
					pattern: {
						message: 'Invalid social security number.',
						params: /^([\d*]{3})\s?\-?\s?([\d*]{2})\s?\-?\s?(\d{4})$/
					}
				})
			});

			return self;
		};
		Signer = function(data){
			var self = this;
			var defaultData = _.extend({
					apexType: LifeCycle.BorrowerTree.typeMapFlipped['SIGNER'],
					authority : '',
					capacity : '',
					ownershipPercentage : 100,
					involvement: {},
					contact: {}
				}, app.DefaultModelData);

			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(
					defaultData, app.mapping.SIGNER, self);
			self.show = ko.observable(false);
			self.validationModel = ko.validatedObservable({
				ownershipPercentage: self.ownershipPercentage.extend({
					required: {
						onlyIf: function(){return self.involvement.showOwnershipPercentage()},
						params: true
					},
					min: 0.01,
					max: 100.00
				})
			});
			self.filteredCapacityOptions = ko.observableArray([]);
			self.entityTypeObjservable = null;
			self.filterCapacityOptions = ko.computed({
				read: function(){
					return self.filteredCapacityOptions();
				},
				write: function(entityType){
					self.filteredCapacityOptions([]);
					_.each(self.mappedCapacityOptions[entityType] ? self.mappedCapacityOptions[entityType]() : [], function(element){
						self.filteredCapacityOptions.push(element);
					});
				}
			});
			self.contactObservable = ko.observable(self.contact);
			return self;
		};
		Involvement = function(data){
			var self = this;
			var defaultData = _.extend({
					contingentPercentage : null,
					contingentAmount: null,
					contingentType : '',
					loan: {},
					relationship: {},
					signers: [],
					borrowerType: 'Borrower',
					isIncludedInGlobalAnalysis: true,
					apexType: LifeCycle.BorrowerTree.typeMapFlipped['INVOLVEMENT']
				}, app.DefaultModelData);

			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.mapping.INVOLVEMENT, self);
			self.show = ko.observable(false);
			self.showOwnershipPercentage = ko.computed(function(){
				return 'Assign Specific' == self.contingentType() ||
					'Pro Rata' == self.contingentType();
			});
			self.disableContingentAmount = ko.computed(function(){
				return (self.contingentPercentage()) || self.isDisabled();
			});
			self.disableContingentPercentage = ko.computed(function(){
				return (self.contingentAmount()) || self.isDisabled();
			});
			self.showOwnershipPercentage.subscribe(function(newValue){
				_.each(self.signers(), function(element, index, list){
					if(self.showOwnershipPercentage()){
						if(!element.ownershipPercentage()) {
							element.ownershipPercentage(100.00);
						}
					}
					else{
						element.ownershipPercentage(null);
					}
				});
			});
			self.validationModel = ko.validatedObservable({
				contingentPercentage: self.contingentPercentage.extend({
					required: {
						onlyIf: function () {
							return !self.contingentAmount();}
					},
					min: 0.00,
					max: 100.00
				}),
				contingentAmount: self.contingentAmount.extend({
					required: {
						onlyIf: function () {
							return !self.contingentPercentage();}
					},
					min: 0.00
				})
			});
			//Default to 'Related Entity' when creating the involvement from the product package
			if (typeof window.borrowerTreeApp.viewModel !== 'undefined') {
				if (typeof window.borrowerTreeApp.viewModel.RELATIONSHIP !== 'undefined') {
					if (typeof window.borrowerTreeApp.viewModel.RELATIONSHIP.PRODUCTPACKAGE !== 'undefined') {
						self.borrowerType('Related Entity');
					}
				}
			}
			return self;
		};
		Borrower = function(data){
			if(data !== undefined){
				_.extend(
					data, {
					apexType: LifeCycle.BorrowerTree.typeMapFlipped['BORROWER']});
			}
			return new Involvement(data);
		};
		Guarantor= function(data){
			if(data !== undefined){
				_.extend(
					data, {
					apexType: LifeCycle.BorrowerTree.typeMapFlipped['GUARANTOR']});
				}
				return new Involvement(data);
			};
	})(window.borrowerTreeApp);
});

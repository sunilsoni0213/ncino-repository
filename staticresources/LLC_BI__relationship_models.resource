(function(){
	var Models = function(event, app){
		var defaultModelData = {
			recordId : null,
			name : '',
			isLoaded : false,
			isSaved : false,
			disabled: false,
			freeTextSearchField: ''
		};
		app.Loan = function(data, shallow){
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('loan'),
				amount: 0,
				interestRate: 0,
				amortization: 0,
				relationship: {},
				borrowers: [],
				guarantors: [],
				creditMemo: null,
				covenants: []
			}, defaultModelData);
			if(data !== undefined){
				_.extend(defaultData, data);
			}	
			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, app.getMapping(), self);
			}

			self.involvements = ko.observableArray();

			self.show = ko.observable(false);
			self.validationModel = ko.validatedObservable({});
			self.selected = ko.observable(false);
			
			self.loanCovenants = ko.observableArray();
			
			return self;
		};
		app.Relationship = function(data, shallow){
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('relationship'),
				entityType : '',
				isIndividual: false,
				taxIdentificationNumber: '',
				fiscalYearEnd: 0,
				loans: [],
				contacts: [],
				involvements: [],
				covenants: [],
				naicsCode: ''
			},defaultModelData);
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, app.getMapping(), self);
			}

			self.bundles = ko.observableArray();
			self.bundle = ko.computed({
				read: function(){
					return self.bundles().length ? self.bundles()[0] : undefined;
				},
				write: function(value){
					value ? self.bundles.unshift(value) : self.bundles.removeAll();
				},
				deferEvaluation: true
			});

			self.displayFiscalYearEnd = ko.computed({
				read: function () {
					if (_.isNumber(self.fiscalYearEnd()) && self.fiscalYearEnd() != 0) {
						return _toDisplay(self.fiscalYearEnd());
					} else {
						return null;
					}
				},
				write: function (value) {
					value = value.replace(/\u200E/g,'');
					self.fiscalYearEnd(new Date(value).getTime());
				}
			});

			self.isFiscalYearEndSet = ko.computed(function(){
				return !_.isNull(self.fiscalYearEnd()) &&
					_.isNumber(self.fiscalYearEnd()) &&
					self.fiscalYearEnd() != 0;
			});

			self.fiscalYearEndPlaceholder = LifeCycle.msgs.msg_spread_config_fiscal_year_end_date_placeholder;
			self.showBillingAddress = ko.observable(false);
			self.showShippingAddress = ko.observable(false);
			self.show = ko.observable(false);
			self.selected = ko.observable(false);
			self.isIndividual = ko.computed(function(){
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
			self.applyValidationModel = function(){
				self.validationModel = ko.validatedObservable({
						displayFiscalYearEnd: self.displayFiscalYearEnd.extend({
							required: {
								params: true,
								message: 'You must select a date for the fiscal year end.'
							}
						}),
						name: self.name.extend({
							required: true,
							minLength: 3,
							maxLength: 80
						})
				});

				self.validationModel.errors.showAllMessages();

				return self.validationModel;
			};

			function _toDisplay(time) {
				return new Date(time).toLocaleDateString();
			}

			function _getApexType (namespacedType) {
				if (typeof namespacedType != 'string') {
					return null;
				}
				return ko.unwrap(namespacedType).substring(namespacedType.indexOf('.') + 1);
			}

			self.getUnderwritingBundle = function(){
				var _namespace = self.apexType().substring(0, self.apexType().indexOf('.'));
				if(!_.isEmpty(self.statementBundles)
						&& !_.isEmpty(app.mapApexFromModel('iUnderwritingBundle'))) {
					var _adjustedType = _namespace + '.' + _getApexType(app.mapApexFromModel('iUnderwritingBundle'));
					if(!_.isEmpty(self.statementBundles[_adjustedType])){
						return self.statementBundles[_adjustedType];
					}
				}
				return undefined;
			};
			
			self.accountCovenants = ko.observableArray();

			return self;
		};
		app.Contact = function(data, shallow){
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('contact'),
				firstName : '',
				lastName : '',
				birthDate: 0,
				ssn: '',
				isPrimaryContact: false,
				relationship: {},
				signings: []
			}, defaultModelData);
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, app.getMapping(), self);
			}
			
			self.selected = ko.observable(false);
			self.show = ko.observable(false);

			self.validationModel = ko.validatedObservable({
				firstName: self.firstName.extend({
					required: true,
					minLength: 3,
					maxLength: 80
				}),
				lastName: self.lastName.extend({
					required: true,
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
		app.Signer = function(data, shallow){
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('signer'),
				authority : '',
				capacity : '',
				ownershipPercentage : 100,
				involvement: {},
				contact: {}
			}, defaultModelData);
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, app.getMapping(), self);
			}
			
			self.show = ko.observable(false);
			self.validationModel = ko.validatedObservable({
				ownershipPercentage: self.ownershipPercentage.extend({
					required: {
						onlyIf: function(){return ko.unwrap(self.involvement.showOwnershipPercentage);},
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
		app.Involvement = function(data, shallow){
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('involvement'),
				contingentPercentage : 100,
				contingentType : '',
				isIncludedInGlobalAnalysis: true,
				loan: {},
				relationship: {},
				signers: [],
				borrowerType: 'Borrower'
			}, defaultModelData);
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, app.getMapping(), self);
			}
			
			self.show = ko.observable(false);
			self.showOwnershipPercentage = ko.computed(function(){
				return 'Assign Specific' == self.contingentType() ||
					'Pro Rata' == self.contingentType();
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
					required: true,
					min: 0.00,
					max: 100.00
				})
			});

			return self;
		};
		app.Borrower = function (data, shallow) {
			if (data !== undefined) {
				_.extend(data, {
					apexType: app.mapApexFromModel('borrower')
				});
			}
			return new app.Involvement(data, shallow);
		};
		app.Guarantor = function (data, shallow) {
			if (data !== undefined) {
				_.extend(data, {
					apexType: app.mapApexFromModel('guarantor')
				});
			}
			return new app.Involvement(data, shallow);
		};
		app.Collateral = function(data, shallow){
			var self = this;
			var defaultData = _.extend({
					apexType: app.mapApexFromModel('collateral'),
					collateralType: '',
					numberOfUnits: 0
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
		app.ProductPackage = function(data, shallow) {
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('productPackage')
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
			'loan': {
				create: function(options){
					return new app.Loan(options.data, options.useViewModelPlugin);
				}
			},
			'loans': {
				create: function(options){
					return new app.Loan(options.data, options.useViewModelPlugin);
				}
			},
			'account': {
				create: function(options){
					return new app.Relationship(options.data, options.useViewModelPlugin);
				}
			},
			'accounts': {
				create: function(options){
					return new app.Relationship(options.data, options.useViewModelPlugin);
				}
			},
			'relationship': {
				create: function(options){
					return new app.Relationship(options.data, options.useViewModelPlugin);
				}
			},
			'relationships': {
				create: function(options){
					return new app.Relationship(options.data, options.useViewModelPlugin);
				}
			},
			'contact': {
				create: function(options){
					return new app.Contact(options.data, options.useViewModelPlugin);
				}
			},
			'contacts': {
				create: function(options){
					return new app.Contact(options.data, options.useViewModelPlugin);
				}
			},
			'signer': {
				create: function(options){
					return new app.Signer(options.data, options.useViewModelPlugin);
				}
			},
			'signers': {
				create: function(options){
					return new app.Signer(options.data, options.useViewModelPlugin);
				}
			},
			'signings': {
				create: function (options){
					return new app.Signer(options.data, options.useViewModelPlugin);
				}
			},
			'involvement': {
				create: function(options){
					switch(app.mapApexToModel(options.data.apexType)){
						case 'borrower':
							return new app.Borrower(options.data, options.useViewModelPlugin);
						case 'guarantor':
							return new app.Guarantor(options.data, options.useViewModelPlugin);
						default:
							return new app.Involvement(options.data, options.useViewModelPlugin);
					}
				}
			},
			'involvements': {
				create: function(options){
					switch(app.mapApexToModel(options.data.apexType)){
						case 'borrower':
							return new app.Borrower(options.data, options.useViewModelPlugin);
						case 'guarantor':
							return new app.Guarantor(options.data, options.useViewModelPlugin);
						default:
							return new app.Involvement(options.data, options.useViewModelPlugin);
					}
				}
			},
			'borrower': {
				create: function(options){
					return new app.Borrower(options.data, options.useViewModelPlugin);
				}
			},
			'borrowers': {
				create: function(options){
					return new app.Borrower(options.data, options.useViewModelPlugin);
				}
			},
			'guarantor': {
				create: function(options){
					return new app.Guarantor(options.data, options.useViewModelPlugin);
				}
			},
			'guarantors': {
				create: function(options){
					return new app.Guarantor(options.data, options.useViewModelPlugin);
				}
			},
			'collateral': {
				create: function(options){
					return new app.Collateral(options.data, options.useViewModelPlugin);
				}
			},
			'productPackage': {
				create: function(options){
					return new app.ProductPackage(options.data, options.useViewModelPlugin);
				}
			},
			// anonymous related objects
			'creditMemo': {
				create: function(options){
					var self = {};
					var defaultData = {
						apexType: app.mapApexFromModel('creditMemo')
					};
					if(options.data !== undefined){
						_.extend(defaultData, options.data);
					}	
					app.mapFromJS(defaultData, app.getMapping(), self);
					return self;
				}
			}
		});
		app.setTypesMap({
			'LifeCycleLoan': 'loan',
			'LifeCycleRelationship': 'relationship',
			'LifeCycleContact': 'contact',
			'LifeCycleSigner': 'signer',
			'ALifeCycleInvolvement': 'involvement',
			'LifeCycleBorrower': 'borrower',
			'LifeCycleGuarantor': 'guarantor',
			'LifeCycleCustomTypeEntity': 'involvement',
			'LifeCycleCreditMemo': 'creditMemo',
			'LifeCycleCollateral': 'collateral',
			'LifeCycleProductPackage': 'productPackage'
		});
		app.log('LifeCycle Models initialized.');
	};
	if(LifeCycle.Relationship == undefined){
		LifeCycle.Relationship = {};
	}
	if(LifeCycle.Relationship.Models == undefined){
		LifeCycle.Relationship.Models = Models;
	}
})();

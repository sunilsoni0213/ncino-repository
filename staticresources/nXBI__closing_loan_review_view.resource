(function(){
	var ClosingLoanReview = function(event, app){
		app.View = function(vm){

			var self = this;
			self.baseDirectory = '/';
			self.loanData = vm.apiData;

			self.tabs = [{ 
				name: LifeCycle.msgs.msgs_borrowers,
				nameSingular: LifeCycle.msgs.msgs_borrower,
				context: ko.observableArray(),
				isActive: ko.observable(true) 
			},{ 
				name: LifeCycle.msgs.msgs_co_borrowers,
				nameSingular: LifeCycle.msgs.msgs_co_borrower,
				context: ko.observableArray(),
				isActive: ko.observable(false) 
			},{ 
				name: LifeCycle.msgs.msgs_guarantors,
				nameSingular: LifeCycle.msgs.msgs_guarantor,
				context: ko.observableArray(), 
				isActive: ko.observable(false) 
			},{ 
				name: LifeCycle.msgs.msgs_authorized_signers,
				nameSingular: LifeCycle.msgs.msgs_authorized_signer,
				context: ko.observableArray(), 
				isActive: ko.observable(false) 
			}];
			
			self.tabContext = ko.observable();
			
			self.setTabs = function(){
				if (typeof vm.apiData.involvements === 'function'){
					_.each(vm.apiData.involvements(), function(involvement){
						if (involvement.isBorrower()){
							self.tabs[0].context.push(formatContact(involvement, involvement.relationship.primaryContact));
						}else if (involvement.isCoborrower()){
							self.tabs[1].context.push(formatContact(involvement, involvement.relationship.primaryContact));
						}else if (involvement.isGuarantor()){
							self.tabs[2].context.push(formatContact(involvement, involvement.relationship.primaryContact));
						}
						
						if (!_.isEmpty(involvement.signers)){
							_.each(involvement.signers(), function(signer){
								self.tabs[3].context.push(formatContact(involvement, signer.contact));
							})

						}
					});
				}
				self.tabContext(self.tabs[0]);
			};
			
			self.setTabContext = function(target){
				_.each(self.tabs, function(tab){
					var setActive = tab.context === target.context;
					
					if (setActive) {
						self.tabContext(tab);
					}
					
					tab.isActive(setActive);
				});
			};
			
			self.setDefaults = function(){
				var notSet = function(data){
					return (data === undefined || data === null || data === 0);
				};
				
				_.each(vm.loanDefaultValues().loanDefaults, function(value, key){
					if (notSet(vm.apiData[key])){
						vm.apiData[key] = ko.observable(value);
					}
				});
				_.each(vm.loanDefaultValues().relationshipDefaults, function(value, key){
					if (vm.apiData['relationship'] != null && notSet(vm.apiData['relationship'][key])){
						vm.apiData['relationship'][key] = ko.observable(value);
					}
				});
				
				self.setTabs();
			};
			
			self.missingFields = function() {
				// uses pluggable required field strategy
				var plugin = app.getFieldSelector();
				if (plugin && _.isFunction(plugin.getMissingFields)) {
					return plugin.getMissingFields(vm.apiData);
				}
				return missingFieldsLegacy(vm.apiData);
			};

			function missingFieldsLegacy(apiData) {
				// maintains backward compatability with FLO
				var toComplete = [],
					relationship = apiData.relationship,
					typeCode = typeof apiData.typeCode === 'function' ? apiData.typeCode() : null,
					paymentType = typeof apiData.paymentType === 'function' ? apiData.paymentType() : null;
					involvements = apiData.involvements ? apiData.involvements : null;

				if (relationship == undefined || relationship == null){
					toComplete.push(LifeCycle.msgs.msgs_relationship_loan);
				}
				if (typeCode == undefined || typeCode == null | typeCode == ""){
					toComplete.push(LifeCycle.msgs.msgs_loan_type_code);
				}
				if (paymentType == undefined || paymentType == null || paymentType == ""){
					toComplete.push(LifeCycle.msgs.msgs_payment_type);
				}

				_.each(involvements(), function(involvement){
					entityType = involvement.relationship.entityType;
					if (entityType == undefined || entityType == null ){
						toComplete.push(LifeCycle.msgs.msgs_relationship_type);
					} else if (entityType() == 'Partnership'
							|| entityType() == 'Corporation'
							|| entityType() == 'Trust'
							|| entityType() == 'Limited Liability Company'
							|| entityType() == 'Government'
							|| entityType() == 'Association'
							) {

						taxId = involvement.relationship.taxIdentificationNumber;
						if (taxId == undefined || taxId == null) {
							toComplete.push(LifeCycle.msgs.msgs_business_tax_id);
						}
					} else if (entityType() == 'Sole Proprietorship'
									|| entityType() == 'Individual') {

						contact = involvement.relationship.primaryContact;
						if ((contact != undefined || contact != null)
							&& (contact.Id != null || contact.Id != undefined)) {
							
							ssn = involvement.relationship.primaryContact.ssn;
							if (ssn == undefined || ssn == null) {
								toComplete.push(LifeCycle.msgs.msgs_ssn);
							}
						}
					}
				});

				return toComplete;
			}

			function formatContact(entity, contact){
				var c = {};
				c.isIndividual = true;
				c.borrowerType = entity.borrowerType;
				c.homePhone = contact.homePhone;
				c.mobilePhone = contact.mobilePhone;
				c.otherPhone = contact.otherPhone;
				c.firstName = contact.firstName;
				c.lastName = contact.lastName;
				c.ssn = contact.ssn;
				c.cFax = contact.fax;
				c.birthTimestamp = contact.birthTimestamp;
				c.email = contact.email;
				c.driversLicense = contact.driversLicense;
				c.mailingAddress = contact.mailingAddress;
				c.otherAddress = contact.otherAddress;
				c.entityType = entity.relationship.entityType;
				c.phone = entity.relationship.phone;
				c.name = entity.relationship.name;
				c.rFax = entity.relationship.fax;
				c.taxIdentificationNumber = entity.relationship.taxIdentificationNumber;
				c.website = entity.relationship.website;
				c.billingAddress = entity.relationship.billingAddress;
				c.shippingAddress = entity.relationship.shippingAddress;

				return c;
			}
			
			self.isValid = function(){
				return self.missingFields().length == 0;
			};
			
			self.edit = function(data) {
				window.location.href = self.baseDirectory + data.recordId();
			};
			
			return self;
		}
	};
	if(LifeCycle.DataServices.ClosingLoanReview == undefined){
		LifeCycle.DataServices.ClosingLoanReview = ClosingLoanReview;
	}
})();
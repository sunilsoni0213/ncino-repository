(function(){
	var Models = function(event, app){
		var defaultModelData = {
			recordId : null,
			name : '',
			isLoaded : false,
			isSaved : false,
			disabled: false
		};
		app.LegalEntitySObject = function(data){
			var self = this;
			var defaultData = _.extend({
				Contingent_Liabilties__r: null	
			});
			app.getMapping()['ignore'] =
				[
					'Contingent_Liabilties__r'
				];
			app.mapFromJS(defaultData, app.getMapping(), self);

			return self;

		}
		app.DebtScheduleContainer = function(data){
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('debtScheduleContainer'),
				proposedLoans: [],
				proposedLoansLabels: [],
				proposedLoansLabel: '',
				otherObligations: [],
				otherObligiationsLabels: [],
				otherObligiationsLabel: '',
				indirectDebt: [],
				indirectDebtLabels: [],
				indirectDebtLabel: '',
				creditFacilities: [],
				creditFacilitiesLabels:[],
				creditFacilitiesLabel: '',
				payoffsLabel: '',
				participationsLabel: '',
				lockedDate: null,
				lockedByUser: null,
				isLocked: null,
				canBeLocked: null,
				showFootnotes: false
			}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			self.mapping = app.getMapping();

			self.mapping['ignore'] =
				[
					'recordId',
					'isSaved',
					'otherObligiationsLabels',
					'disabled',
					'isLoaded',
					'otherObligiationsLabel',
					'lockedDate'
				];
			app.mapFromJS(defaultData, app.getMapping(), self);
			
			self.selectedEntity = ko.observable();

			self.activeCreditFacilities = ko.computed(function() {
				return ko.utils.arrayFilter(self.creditFacilities(), function(debt) {
					return debt.relationshipId() == self.selectedEntity();
				});
			});

			self.activeProposedLoans  = ko.computed(function() {
				return ko.utils.arrayFilter(self.proposedLoans(), function(debt) {
					return debt.relationshipId() == self.selectedEntity();
				});
			});

			self.commentsEmpty = ko.computed(function() {
				var commentFound = false;
				_.each(self.activeCreditFacilities(), function(debt) {
					if (debt.dsComments().length > 0) {
						commentFound = true;
					}
				});
				_.each(self.activeProposedLoans(), function(debt) {
					if (debt.dsComments().length > 0) {
						commentFound = true;
					}
				});
				return !commentFound;
			});

			self.creditFacilitiesTotalOriginalAmount = ko.computed(function(){
				var total = 0.00;
				_.each(self.activeCreditFacilities(), function(loan){
					if(!loan.isRemoved()){
						var amount = parseFloat(loan.originalAmount());
						if(!_.isUndefined(amount) && amount > 0){
							total += amount;
						}
					}
				});
				return parseFloat(total);
			});
			
			self.creditFacilitiesTotalPrincipalAmount = ko.computed(function(){
				var total = 0.00;
				_.each(self.activeCreditFacilities(), function(loan){
					if(!loan.isRemoved()){
						var amount = parseFloat(loan.principalAmount());
						if(!_.isUndefined(amount) && amount > 0){
							total += amount;
						}
					}
				});
				return parseFloat(total);
			});
			
			self.creditFacilitiesTotalMonthlyPayment = ko.computed(function(){
				var total = 0.00;
				_.each(self.activeCreditFacilities(), function(loan){
					if(!loan.isRemoved()){
						var amount = parseFloat(loan.paymentAmount());
						if(!_.isUndefined(amount) && amount > 0){
							total += amount;
						}
					}
				});
				return parseFloat(total);
			});
			
			self.creditFacilitiesTotalAvailableAmount = ko.computed(function(){
				return self.creditFacilitiesTotalOriginalAmount() - self.creditFacilitiesTotalPrincipalAmount();
			});
			
			self.proposedTotalOriginalAmount = ko.computed(function(){
				var total = 0.00;
				_.each(self.activeProposedLoans(), function(loan){
					if(!loan.isRemoved()) {
						var amount = parseFloat(loan.originalAmount());
						if(!_.isUndefined(amount) && amount > 0){
							total += amount;
						}
					}
				});
				return parseFloat(total);
			});
			
			self.proposedTotalPrincipalAmount = ko.computed(function(){
				var total = 0.00;
				_.each(self.activeProposedLoans(), function(loan){
					if(!loan.isRemoved()) {
						var amount = parseFloat(loan.principalAmount());
						if(!_.isUndefined(amount) && amount > 0){
							total += amount;
						}
					}
				});
				return parseFloat(total);
			});
			
			self.proposedTotalMonthlyPayment = ko.computed(function(){
				var total = 0.00;
				_.each(self.activeProposedLoans(), function(loan){
					if(!loan.isRemoved()){
						var amount = parseFloat(loan.paymentAmount());
						if(!_.isUndefined(amount) && amount > 0){
							total += amount;
						}
					}
				});
				return parseFloat(total);
			});
			
			self.proposedTotalAvailableAmount = ko.computed(function(){
				return self.proposedTotalOriginalAmount() - self.proposedTotalPrincipalAmount();
			});
			
			self.totalMonthlyDebtService = ko.computed(function(){
				return self.proposedTotalMonthlyPayment() + self.creditFacilitiesTotalMonthlyPayment();
			});
			
			self.totalOriginalAmount = ko.computed(function(){
				return self.proposedTotalOriginalAmount() + self.creditFacilitiesTotalOriginalAmount();
			});
			
			self.totalPrincipalAmount = ko.computed(function(){
				return self.proposedTotalPrincipalAmount() + self.creditFacilitiesTotalPrincipalAmount();
			});

			return self;
		};
		
		app.DebtScheduleLoan = function(data){
			var self = this;
			var defaultData = _.extend({
				unfundedAmount: null,
				relationshipName: null,
				relationshipId: null,
				rate: null,
				proposedPaymentAmount: null,
				product: null,
				principalAmount: null,
				payoffAmount: null,
				payments: null,
				paymentFrequency: null,
				paymentAmount: null,
				participatedEntity: null,
				participatedAmount: null,
				ownershipPercentage: null,
				originalAmount: null,
				name: null,
				maturityDateLong: null,
				loanNr: null,
				loanId: null,
				isRemoved: false,
				isOverridden: null,
				institution: null,
				source: null,
				dsComments: []
			}, defaultModelData);
			
			if(data != undefined){
				_.extend(defaultData, data);
			}
			self.mapping = app.getMapping();

			self.mapping['ignore'] =
				[
					'isOverridden',
					'disabled',
					'isLoaded',
					'unfundedAmount',
					'maturityDateStr',
					'maturityDate'
				];
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.savePending = ko.observable(false);

			self.hasChanged = new ChangeDetective(self, defaultData);

			self.isEditing = ko.observable(false);
			self.showComments = ko.observable(false);

			self.isVisible = ko.computed(function(){
				return self.isEditing() && self.source() == LifeCycle.msgs.msg_user;
			});
			
			self.availableAmount = ko.computed(function() {
				return self.originalAmount() - self.principalAmount();
			});
			
			self.isRemovedText = ko.computed(function() {
				return self.isRemoved() ? LifeCycle.msgs.msg_excluded: LifeCycle.msgs.msg_included;
			});
			self.allowSave = ko.computed(function() {
				return (self.savePending() && self.validationModel().isValid()) ? true : false;
			});
			self.loanIncluded = ko.computed(function(){
				return self.isRemoved() ? 'error' : '';
			});
			self.loanIncludedButton = ko.computed(function(){
				return self.isRemoved() ? 'btn-danger' : 'btn-success';
			});
			self.isUserCreated = function() {
				return self.source() == LifeCycle.msgs.msg_user ? true : false;
			};
			self.maturityDateStr = function(){
				if(self.maturityDateLong() != null){
					var d = new Date(self.maturityDateLong());
					return d.toLocaleDateString();
				}
				return null;
			};

			self.validationModel = ko.validatedObservable({
					name: self.name.extend({
						required: true,
						maxLength: 80
					}),
					originalAmount: self.originalAmount.extend({
						required: true,
						number: true,
						min: 0
					}),
					principalAmount: self.principalAmount.extend({
						required: true,
						number: true,
						min: 0
					}),
					paymentAmount: self.paymentAmount.extend({
						required: true,
						number: true,
						min: 0
					})
			});

			return self;
			
		};

		app.DebtScheduleLoanComment = function(data){
			var self = this;
			var defaultData = _.extend({
				createdDate: null,
				comment: null,
				name: null,
				userId: null
			}, defaultModelData);

			if(data != undefined){
				_.extend(defaultData, data);
			}
			self.mapping = app.getMapping();

			self.mapping['ignore'] =
				[
					'disabled',
					'isLoaded',
					'isSaved'
				];
			app.mapFromJS(defaultData, app.getMapping(), self);

			return self;

		};

		app.setMapping({
			'dsComments': {
				create: function(options){
					return new app.DebtScheduleLoanComment(options.data);
				}
			},
			'creditFacilities': {
				create: function(options){
					return new app.DebtScheduleLoan(options.data);
				}
			},
			'proposedLoans': {
				create: function(options){
					return new app.DebtScheduleLoan(options.data);
				}
			},
			'otherObligations': {
				create: function(options){
					return new app.DebtScheduleLoan(options.data);
				}
			},
			'indirectDebt': {
				create: function(options){
					return new app.DebtScheduleLoan(options.data);
				}
			}
		});
		app.setTypesMap({
			'DebtSchedule.DebtScheduleContainer': 'debtScheduleContainer'
		});
		
	};
	if(LifeCycle.DebtSchedule == undefined){
		LifeCycle.DebtSchedule = {};
	}
	if(LifeCycle.DebtSchedule.Models == undefined){
		LifeCycle.DebtSchedule.Models = Models;
	}
})();

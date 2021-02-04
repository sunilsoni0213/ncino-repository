(function(){
	var ViewModel = function(event, app){
		app.log('register viewModel event callback executing');
		app.ViewModel = function(data){
			var self = this;
			self.app = app;
			var defaultData = {
				statement: {}
			};
			if(data){
				_.extend(defaultData, data);
			}
			
			LifeCycle.SpreadData.cacheUnmappedIForces([defaultData.statement]);

			self.mapping = app.getMapping();
			// so it does not create a new instance
			self.mapping['copy'] = ['spread'];
			app.mapFromJS(defaultData, self.mapping, self);
			self.statement = LifeCycle.SpreadData.lookupStatementById(self.statement.recordId());

			self.eligibleSecondInterimDates = ko.computed(function () {
				return LifeCycle.SpreadData.TTMServices.EligibilityService.getEligibleSecondInterimDates(self.statement);
			}, {deferEvaluation: true});
			
			self.selectedSecondInterimDate = ko.observable();
			
			self.setSelectedInterimDate = function (interimDate) {
				self.selectedSecondInterimDate(new Date(interimDate));
				self.showTTMSelectionModal();
			};
			

			self.getDisplayDateFromStatementDate = function (statementDate) {
				var displayDate = new Date(statementDate);
				displayDate.setDate(displayDate.getDate() + 1);
				return displayDate.toLocaleDateString();
			};

			self.selectedScenarioInterim1s = ko.computed(function () {
				if (!self.selectedSecondInterimDate()) {
					return [];
				}
				
				return LifeCycle.SpreadData.TTMServices.EligibilityService.getOptionsForSecondInterimDate(
					self.selectedSecondInterimDate(),
					self.statement
				).interim1s;
			}, {deferEvaluation: true});
			
			self.selectedScenarioFiscalYears = ko.computed(function () {
				if (!self.selectedSecondInterimDate()) {
					return [];
				}
				
				return LifeCycle.SpreadData.TTMServices.EligibilityService.getOptionsForSecondInterimDate(
					self.selectedSecondInterimDate(),
					self.statement
				).fiscalYears;
			}, {deferEvaluation: true});
			
			self.selectedScenarioInterim2s = ko.computed(function () {
				if (!self.selectedSecondInterimDate()) {
					return [];
				}
				
				return LifeCycle.SpreadData.TTMServices.EligibilityService.getOptionsForSecondInterimDate(
					self.selectedSecondInterimDate(),
					self.statement
				).interim2s;
			}, {deferEvaluation: true});

			self.selectedInterim1 = ko.observable();
			self.selectedFiscalYear = ko.observable();
			self.selectedInterim2 = ko.observable();

			self.selectedScenarioInterim1s.subscribe(function(scenarioInterims) {
				if(scenarioInterims.length){
					self.selectedInterim1(scenarioInterims[0]);
				}
			});

			self.selectedScenarioFiscalYears.subscribe(function(scenarioInterims) {
				if(scenarioInterims.length){
					self.selectedFiscalYear(scenarioInterims[0]);
				}
			});

			self.selectedScenarioInterim2s.subscribe(function(scenarioInterims) {
				if(scenarioInterims.length){
					self.selectedInterim2(scenarioInterims[0]);
				}
			});

			self.showTTMSelectionModal = function () {
				jQuery('#trailing_twelve_month_modal').modal().modal('show');
			};

			self.generateTTMs = function() {
				app.performingAjax(true);
				LifeCycle.SpreadData.TTMServices.GenerationService.generateTTMPeriods(self.selectedInterim1(), self.selectedFiscalYear(), self.selectedInterim2());
			};

			return self;
		};

		app.log('Trailing Twelve Month ViewModel initialized.');
	};
	if(!LifeCycle.TTMonth.ViewModel){
		LifeCycle.TTMonth.ViewModel = ViewModel;
	}
})();
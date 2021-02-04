(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			self.app = app;
			var defaultData = {
				isOpen: false,
				isEditingSqFt: false,
				isEditingTenant: false,
				isEditingYear: false,
				tenantInfoColumns: [],
				collateral: '',
				years: [],
				currentYear: '',
				tenants: [],
				selectedTenant: '',
				selectedYear: '',
				statementId: '',
				columnTotals: [],
				mode: '',
				errorExists: false,
				errorMsg: ''
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}

			app.mapFromJS(defaultData, app.getMapping(), self);

			self.hideRentRollSavedAlert = ko.observable(true);
			self.reloadOnSave = ko.observable(false);
			self.collateral = LifeCycle.SpreadData.lookupIForceById(self.collateral.recordId(), {
				generatePlaceholder: true,
				placeholderType: 'c.LifeCycleCollateral',
				alwaysReturnModel: true
			});

			self.isPrintView = ko.computed(function() {
				return self.mode() == LifeCycle.msgs.msg_mode_print; 
			});

			self.totalSquareFeet = ko.computed(function() {
				var total = 0;
				_.each(self.tenants(), function(tenant){
					total += parseInt(tenant.squareFeet());
				});
				return total;
			});

			self.currentTotals = ko.computed(function() {
				var totals;
				_.each(self.tenants(), function(tenant) {
					_.each(tenant.rentInfo(), function(rentRollPeriod){
						if (rentRollPeriod.year() == self.currentYear()) {
							if (!totals) {	
								totals = new app.RentRollPeriod(app.mapToJS(rentRollPeriod));
								_.each(totals.scenarios(), function(scenario) {
									scenario.rentSqFt(0);
								});
							}
							_.each(rentRollPeriod.scenarios(), function(scenario) {
								if (!isNaN(scenario.rentSqFt())) {
									var currentTotal = totals.scenarios()[rentRollPeriod.scenarios().indexOf(scenario)].rentSqFt();
									var toAdd = scenario.rentSqFt() * tenant.squareFeet();
									totals.scenarios()[rentRollPeriod.scenarios().indexOf(scenario)].rentSqFt(
										 currentTotal + toAdd
									);
								}
							});
						}
					});
				});
				if (!_.isUndefined(totals)) {
					_.each(totals.scenarios(), function(scenario) {
						var match = ko.utils.arrayFirst(self.columnTotals(), function(column) {
							return column.periodId() === scenario.periodId();
						});
						match.total(scenario.rentSqFt());
					});
				}
				app.publish('SPREAD.Spreads.Rent_Roll.Annual_Income_Updated', totals);
				return totals;
			});

			self.toggle = function(e) {
				app.publish("SPREAD.Spreads.Fullscreen_App_Opened", self.app.appId);
				self.hideRentRollSavedAlert(true);
				self.isOpen(!self.isOpen());
				if ( typeof key !== "undefined" ) {
					if(self.isOpen()){
						key.setScope('rent_roll');
					}else{
						key.setScope('nav');
					}
				}
				if (self.isOpen() && jQuery('.main_spreading').is(':visible')) {
					jQuery('.main_spreading, .spread-footnotes').hide();
				} else if (!self.isOpen() && jQuery('.main_spreading').is(':hidden')) {
					jQuery('.main_spreading, .spread-footnotes').show();
				}
			};

			self.closeApp = function(e) {
				if (e != self.app.appId) {
					self.isOpen(false);
				}
			};

			self.editTenant = function(tenant){
				if (self.tenants().indexOf(tenant) < 0) {
					self.selectedTenant(new app.Tenant({
						tenantInfoColumns: app.mapToJS(self.tenantInfoColumns),
						rentInfo: app.mapToJS(self.years),
						currentYear: self.currentYear()
					}));
				} else {
					self.selectedTenant(tenant);
				}
				self.isEditingTenant(true);
			};

			self.editYear = function(year){
				if (!self.isOpen()){
					self.toggle();
				}
				if (self.years().indexOf(year) < 0) {
					self.selectedYear(new app.RentRollPeriod());
				} else {
					self.selectedYear(year);
				}
				self.isEditingYear(true);
				self.errorExists(false);
			};
			self.submitTenantForm = function() {
				if (self.tenants().indexOf(self.selectedTenant()) < 0 ) {
					self.tenants.push(self.selectedTenant());
				}
				self.isEditingTenant(false);
			};
			self.submitYearForm = function() {
				LifeCycle.blockUI('300px');
				var scenarioNames = [
					LifeCycle.msgs.msg_current_rent_roll_scenario,
					LifeCycle.msgs.msg_appraisal_scenario,
					LifeCycle.msgs.msg_underwriting_scenario,
					LifeCycle.msgs.msg_at_stabilization_scenario];

				var scenarios = [];
				var periods = [];

				scenarioNames.map(function(name) {
					var period = new app.SpreadStatementPeriod({
						statementDate: Date.parse(self.selectedYear().year()),
						numberOfPeriods: 12,
						source: name,
						nameOverride: name,
						month: scenarioNames.indexOf(name) + 1,
						year: new Date(self.selectedYear().year()).getFullYear(),
						selected: true,
						statementId: self.statementId(),
						lookupKey: Utils.generateUUID()
					});

					periods.push(period);

					scenarios.push(new app.Scenario({
						periodExternalLookupKey: period.lookupKey()
					}));
				});

				LifeCycle.SpreadsService.saveIForces(
					app.mapToJS(periods, { useOptimizedMapper: true, maxDepth: 0 }),
					function(result) {
						LifeCycle.SpreadData.cacheUnmappedIForces(result);
						result.map(function(period) {
							self.errorExists(false);
							var scenario = scenarios.filter(function(scenario) {
									return (scenario.periodExternalLookupKey() == period.lookupKey);
								})[0];
							scenario.periodId(period.recordId);
							self.selectedYear().scenarios().push(scenario);
							var columnTotal = new app.ColumnTotal({
								periodId: period.recordId
							});
							self.columnTotals.push(columnTotal);
						});

						self.tenants().map(function(tenant) {
							tenant.rentInfo.push(new app.RentRollPeriod(app.mapToJS(self.selectedYear())));
						});

						self.years.push(self.selectedYear());
						self.currentYear(self.selectedYear().year());
						self.isEditingYear(false);
						self.reloadOnSave(true);
						app.publish('SPREAD.Spreads.Add_Rent_Roll_Scenario', self.selectedYear().year());
					},
					function (result, event) {
						LifeCycle.unblockUI();
						self.errorExists(true);
						self.errorMsg(event.message);
						if (event.message.indexOf('Spread Statement Period must be unique within a Statement')) {
							self.errorMsg(LifeCycle.msgs.msg_rent_roll_error_existing_scenario);
						}
					}
				);
			};
			self.updateYear = function(data) {
				_.each(self.years(), function(year){
					if (data == new Date(year.year()).getFullYear()){
						self.currentYear(year.year());
					}
				});
				self.save(false);
			};
			self.addTenant = function() {
				self.tenants.push(new app.Tenant({
					tenantInfoColumns: app.mapToJS(self.tenantInfoColumns),
					rentInfo: app.mapToJS(self.years),
					currentYear: self.currentYear()
				}));
			};

			self.removeTenant = function(tenant){
				self.tenants.remove(tenant);
			};

			self.currentYear.subscribe(function(year){
				_.each(self.tenants(), function(tenant){
					tenant.currentYear(year);
				});
			});

			self.showAddYearAlert = ko.computed(function(){
				return (self.years().length == 0);
			});

			if ( typeof key !== "undefined" ) {
				key('tab', 'rent_roll', function(event, handler){
					var found = false;
					var td = jQuery(event.srcElement).parent().next('td');
					do{
						if(jQuery(td).has('input').length > 0){
							jQuery(td).find('input').focus();	
							found = true;
						}
						td = jQuery(td).next('td');
						if(td.length == 0){
							found = true;
						}
					}while(found == false);
				});
				key('esc', 'rent_roll', function(event, handler){
					self.toggle();
				});
				key.filter = function(event){
					return true;
				};
			}

			self.load = function(){
				app.subscribe("SPREAD.Spreads.Fullscreen_App_Opened", self.closeApp);
				app.subscribe('SPREAD.Spreads.Rent_Roll.UpdateYear', self.updateYear);
				if(document.getElementById('rent_roll_button') != null){
					ko.applyBindings(self, document.getElementById('rent_roll_button'));
				}
				if (!_.isNull(self.collateral.recordId())) {
					self.initializeVM();
				}
			};

			app.subscribe("SPREAD.Spreads.Load_Rent_Roll", function (rentRollParams) {
				var rentRollVM = new app.ViewModel(rentRollParams);
				rentRollVM.initializeVM(function(){
					app.publish("SPREAD.Spreads.Rent_Roll_Loaded", rentRollVM);
				});
			});

			self.initializeVM = function(callback) {
				if (!self.collateral.recordId()) {
					return;
				}
				
				LifeCycle.SpreadsService.retrieveIForce({}, self.collateral.recordId(), function (jsForce) {
					LifeCycle.SpreadData.cacheUnmappedIForces([jsForce]);
					self.tenants.subscribe(function(data){
						self.collateral.numberOfUnits(self.tenants().length);
						app.publish("SPREAD.Spreads.Rent_Roll.Collateral_Units", self.collateral.numberOfUnits());
					});
					app.subscribe("SPREAD.Spreads.Rent_Roll.Get_Collateral_Units", function(){
						app.publish("SPREAD.Spreads.Rent_Roll.Collateral_Units", self.collateral.numberOfUnits());
					});
					LifeCycle.Spreads.loadRentRollContainer(
						self.collateral.recordId(),
						ko.unwrap(self.collateral.collateralType).subType(),
						function(result){
							if(result){
								result = JSON.parse(jQuery('<textarea />').html(JSON.stringify(result)).text());
								result = LifeCycle.SpreadsService.deNamespace(result);
								result.isEditingSqFt = false;
								app.mapFromJS(result, app.getMapping(), self);
								if(_.isFunction(callback)){
									callback.apply();
								}
							}
						},
						function(){}
					);
				});
			};

			self.cancelChanges = function() {
				self.toggle();
				self.initializeVM();
			};

			self.saveButton = function() {
				self.save(true);
			};

			self.save = function(toggle){
				if (toggle) {
					self.toggle();
				}
				if (LifeCycle.SpreadData._utils.isPlaceholder(self.collateral)) {
					return;
				}
				
				var mapped = app.mapToJS(self);
				
				self.collateral.numberOfUnits(self.tenants().length);
				LifeCycle.SpreadsService.saveIForce(mapped.collateral, function(){});
				LifeCycle.Force.saveAttachment(
					self.collateral.recordId(),
					LifeCycle.msgs.msg_rent_roll_filename,
					'application/json',
					JSON.stringify(mapped),
					true,
					false,
					function() {
						if (toggle) {
							self.hideRentRollSavedAlert(false);
						}
						if (self.reloadOnSave()) {
							window.location.reload();
						}
					},
					function(){});
			};

			return self;
		}
		app.log('ViewModel initialized.');
	};
	if(LifeCycle.Rent_Roll.ViewModel == undefined){
		LifeCycle.Rent_Roll.ViewModel = ViewModel;
	}
})();

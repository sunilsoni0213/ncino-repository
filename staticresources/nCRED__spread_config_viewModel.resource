(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			self.app = app;
			var defaultData = {
				statement: {},
				hasPeriods: false,
				isLoaded: false,
				currentUserId: ''
			};

			if(data != undefined){
				_.extend(defaultData, data);
			}

			LifeCycle.SpreadData.cacheUnmappedIForces([defaultData.statement, defaultData.bundle]);

			app.mapFromJS(defaultData, app.getMapping(), self);

			self.statement = LifeCycle.SpreadData.lookupStatementById(self.statement.recordId());
			self.statement.bundle = LifeCycle.SpreadData.lookupBundleById(self.bundle.recordId());
			self.sizingScale = self.statement.bundle.scale;

			self.sizingScale.subscribe(function() {
				if (self.statement.bundle && !_.isEmpty(self.statement.bundle))  {
					self.saveBundle();
					app.publish('SPREAD.Spreads.Scale_Updated', self.statement.bundle.scaleDivisor());
				}
			});

			self.canConvertToCRE = ko.observable(data.canConvertToCRE);
			self.relatedCollateral = ko.observable(data.relatedCollateral);
			self.relatedCRECollateral = ko.computed(function () {
				var realEstate = [];

				var search = LifeCycle.msgs.msg_real_estate_collateral_type_name + '-';
				var relatedCollateral = ko.unwrap(self.relatedCollateral);
				if (relatedCollateral) {
					for (var i = 0; i < relatedCollateral.length; i++) {
						var collateral = relatedCollateral[i];
						var collateralType = ko.unwrap(collateral.collateralType);
						if (collateralType.indexOf(search) != -1) {
							realEstate.push(collateral);
						}
					}
				}

				return realEstate;
			});

			var cache = undefined;

			self.relationship = new app.Relationship(data.relationship);
			self.periodSourceOptions = data.periodSourceOptions;
			self.periodAnalystOptions = data.periodAnalystOptions;
			
			self.periodComplianceOptions = ko.computed(function () {
				self.isLoaded();
				return LifeCycle.SpreadData.lookupCovenantComplianceOptionsForStatement(self.statement);
			}, {deferEvaluation: true});
			
			self.debtScheduleOpen = ko.observable(false);

			self.hasCreateStatementsPermission = function(data){
				var hasPermission = self.isEditable && self.isColumnSourceEditable;
				return hasPermission;
			};

			self.isConfigurable = data.isConfigurable;
			self.isCommonSizingConfigurable = data.isCommonSizingConfigurable;
			self.isColumnSourceEditable= data.isColumnSourceEditable;
			self.isEditable = data.isEditable;
			self.spread = data.spread;
			self.selectedPeriod = ko.observable(new app.SpreadStatementPeriod());
			self.selectedCollateral = ko.observable();
			
			self.complianceChosenOptions = {
				width: '270px',
				placeholder_text_multiple: LifeCycle.msgs.msg_spread_config_compliance_options_caption,
				placeholder_text_single: LifeCycle.msgs.msg_spread_config_compliance_options_caption
			};
			
			self.complianceOptionText = function (obj) {
				if (!obj || !obj.covenant || !obj.covenant.covenantType) {
					return;
				}
				
				var objValue = obj.covenant.covenantType.name() + ' (' + obj.covenant.frequency() + ')';
				if(obj.effectiveDate() != null) {
					var effDate = new Date(obj.effectiveDate());
					var effMonth = effDate.getMonth() + 1;
					objValue += ' - ' + effMonth + '/' + effDate.getUTCDate() + '/' + effDate.getFullYear();
				}
				return objValue;
			};
			
			self.complianceOptionAfterRender = function (option, item) {
				if (!_.isEmpty(item.period)) {
					jQuery(option).attr('disabled', true);
				}
			};

			
			self.canSetFiscalYearEnd = function(data) {
				var hasPermission = self.isEditable;
				return hasPermission;
			}

			self.evaluateFiscalYearPeriod = function(statementDate, fiscalYearEnd, numberOfPeriods) {
				var isDateValid = false;
				var isNumberOfPeriodsValid = false;

				if (_.isNumber(statementDate) && !_.isNaN(statementDate) && 
					_.isNumber(fiscalYearEnd) && !_.isNaN(fiscalYearEnd) && 
					new Date(statementDate).getMonth() == new Date(fiscalYearEnd).getMonth()) {

					isDateValid = true;
				}

				if (_.isNumber(numberOfPeriods) && !_.isNaN(numberOfPeriods) &&
					numberOfPeriods == 12) {

					isNumberOfPeriodsValid = true;
				}

				return (isDateValid && isNumberOfPeriodsValid);
			};

			self.hideFiscalYearEndAlert = function() {
				if (!self.relationship.isLoaded()) {
					return true;
				}				
				return self.relationship.isFiscalYearEndSet();
			};

			self.hideFinancialStatementAlert = function() {
				if ( self.statement.statementType() == LifeCycle.msgs.msg_spread_noi_statement || !self.hideFiscalYearEndAlert()) {
					return true;
				} else if ( !self.hasPeriods() && self.isLoaded()) {
					return false;
				} else {
					return true;
				}
			};

			self.isFiscalYearPeriod = ko.computed({
				read: function() {
					if (!_.isUndefined(self.selectedPeriod()) &&
						!_.isUndefined(self.relationship)) {

						var period = self.selectedPeriod();
						var statementDate = period.statementDate();
						var numberOfPeriods = period.numberOfPeriods();
						var fiscalYearEnd = self.relationship.fiscalYearEnd();
						var value = self.evaluateFiscalYearPeriod(statementDate, fiscalYearEnd, numberOfPeriods);
						if(period.isNewPeriod()){
							period.isFiscalYear(value);
						}
					}
				}
			});

			self.isFiscalYearEnabled = ko.computed({
				read: function() {
					if (!_.isUndefined(self.selectedPeriod())) {
						if (self.selectedPeriod().periodType() == 'Trailing Twelve Month') {
							return false;
						}
						
						var numberOfPeriods = self.selectedPeriod().numberOfPeriods();

						if (_.isNumber(numberOfPeriods) && !_.isNaN(numberOfPeriods) &&
							numberOfPeriods == 12) {

							return true;
						}
					}

					return false;
				}
			});

			self.isGlobalAnalysisYearEnabled = ko.computed({
				read: function() {
					if (!_.isUndefined(self.selectedPeriod())) {
						return self.isFiscalYearEnabled() && self.selectedPeriod().isFiscalYear();
					}

					return false;
				}
			});

			self.evaluateGlobalAnalysisDefault = ko.computed({
				read: function() {
					if (!_.isUndefined(self.selectedPeriod) &&
						!_.isUndefined(self.selectedPeriod()) &&
						!_.isUndefined(self.selectedPeriod().isFiscalYear) &&
						!_.isUndefined(self.selectedPeriod().isFiscalYear()) &&
						!_.isUndefined(self.selectedPeriod().isGlobalAnalysisYear) &&
						!_.isUndefined(self.selectedPeriod().isGlobalAnalysisYear())) {

						// Get any periods that are set to GA and have the same year.
						var globalPeriodMatches = _getGlobalAnalysisYearPeriods(self.selectedPeriod());

						// If the selected period is a fiscal year and there are no matches, then true.
						if (self.selectedPeriod().isFiscalYear() && globalPeriodMatches.length <= 0) {
							self.selectedPeriod().isGlobalAnalysisYear(true);
						}
						// If the selected period is not a fiscal year, then false.
						else if (!self.selectedPeriod().isFiscalYear()) {
							self.selectedPeriod().isGlobalAnalysisYear(false);
						}
					}
				}
			});

			function _isGlobalAnalysisYear(currentPeriod, periodToCompare) {
				return !!(
				currentPeriod.recordId() != periodToCompare.recordId() &&
				currentPeriod.year() == periodToCompare.year() &&
				periodToCompare.isGlobalAnalysisYear()
				);
			};

			function _getGlobalAnalysisYearPeriods(currentPeriod) {
				var globalPeriodMatches = [];

				if (!_.isUndefined(self.statement.periods.apexType) && 
					self.statement.periods.apexType() == app.mapApexFromModel('spreadStatementPeriod')) {

					if (_isGlobalAnalysisYear(currentPeriod, self.statement.periods)) {
						globalPeriodMatches.push(self.statement.periods);
					}
				} else {
					_.each(ko.unwrap(self.statement.periods), function(period) {
						if (_isGlobalAnalysisYear(currentPeriod, period)) {
							globalPeriodMatches.push(period);
						}
					});
				}

				return globalPeriodMatches;
			}

			self.globalAnalysisYearExists = ko.computed({
				read: function() {
					if (!_.isUndefined(self.statement.periods) && 
						!_.isUndefined(self.selectedPeriod) &&
						!_.isUndefined(self.selectedPeriod())) {

						// Check for other periods in this year.
						var globalPeriodMatches = _getGlobalAnalysisYearPeriods(self.selectedPeriod());

						if (self.selectedPeriod().isGlobalAnalysisYear() && globalPeriodMatches.length > 0) {
							self.selectedPeriod().errorMsg(LifeCycle.msgs.msg_fiscal_year_already_selected);
							return true;
						} else {
							self.selectedPeriod().errorMsg(undefined);
						}
					}

					return false;
				}
			});

			function _toGMT(time) {
				var date = new Date(time);
				var gmt = Date.UTC(
					date.getFullYear(),
					date.getMonth(),
					date.getDate(),
					date.getHours(),
					date.getMinutes(),
					date.getSeconds(),
					date.getMilliseconds()
				);
				return gmt;
			};

			self.errorMessage = ko.observable();
			self.errorHeading = ko.observable('Error');
			self.errorSubmit = ko.observable('Reload');
			self.errorMessage.subscribe(function(value){
				jQuery('#alert-error-save').slideDown();
			});
			self.applyValidationModel = function(){
				self.validationModel = ko.validatedObservable({
					calcCommonSizingDivisorId: self.statement.calcCommonSizingDivisorId.extend({
						required: {
							params: true,
							message: LifeCycle.msgs.msg_spread_config_common_sizing_divisor_id_required
						}
					})
				});
				return self.validationModel;
			};

			self.editFiscalYearEnd = function(data, event) {
				if (self.isEditable) {

					if (!_.isUndefined(self.relationship) && 
						!_.isUndefined(self.relationship.fiscalYearEnd) && 
						!_.isUndefined(self.relationship.fiscalYearEnd())) {

						self.cache('fiscal-year', self.relationship.fiscalYearEnd())
					}

					if(self.spread.navApp.viewModel.savePending()) {
						self.spread.navApp.viewModel.saveChanges(function() {
							jQuery('#set_fiscal_year_modal').modal({ }).find('input, textarea').placeholder();
						});
					} else {
						jQuery('#set_fiscal_year_modal').modal({ }).find('input, textarea').placeholder();
					}
				}
			};

			self.saveFiscalYearEnd = function(data, event) {
				var currentRelationship = self.relationship;
				if(currentRelationship.applyValidationModel().isValid()){
					LifeCycle.blockUI('300px');
					jQuery('#set_fiscal_year_modal').modal('hide');
					objToSave = app.mapToJS(currentRelationship, {useOptimizedMapper: true, maxDepth: 0});
					LifeCycle.SpreadsService.saveIForce(objToSave, function(){
						LifeCycle.unblockUI();
					});
				}
			};

			self.cache = function(tag, data) {
				if (_.isUndefined(cache)) {
					cache = {};
				}
				cache[tag] = data;
			};

			self.getCache = function(tag) {
				if (!_.isUndefined(cache)) {
					return cache[tag];
				}

				return null;
			};

			self.revertFiscalYear = function() {
				if (!_.isUndefined(self.relationship) && 
					!_.isUndefined(self.relationship.fiscalYearEnd) && 
					!_.isUndefined(self.relationship.fiscalYearEnd())) {

					self.relationship.fiscalYearEnd(self.getCache('fiscal-year'));
				}

				jQuery('#set_fiscal_year_modal').modal('hide');
			};

			self.getAnalystName = function(data, event) {
				if (
					!_.isUndefined(data)
					&& LifeCycle.SpreadData._utils.getApexType(data.apexType())
					== LifeCycle.SpreadData._utils.getApexType(app.mapApexFromModel('spreadStatementPeriod'))
				) {
					if (!_.isUndefined(data.analyst()) && !_.isUndefined(ko.unwrap(data.analystName))) {
						return data.analystName();
					}
					if (!_.isUndefined(data.analyst()) && !_.isUndefined(self.periodAnalystOptions)) {
						var analyst = _.findWhere(self.periodAnalystOptions, {key: data.analyst()});
						if (!_.isUndefined(analyst) && !_.isUndefined(analyst.value)) {
							return analyst.value;
						}
					}
				}

				return null;
			};

			self.getPeriod = function(periodLookupKey) {
				self.requestPeriodMap();

				return self.periodIdMap[periodLookupKey];
			};

			function _buildPeriodIdMap() {
				if (_.isUndefined(self.periodIdMap) || self.periodIdMap == null) {
					self.periodIdMap = {};
				}

				if (_.isUndefined(ko.unwrap(self.statement.periods).length)) {
					self.periodIdMap[ko.unwrap(self.statement.periods).lookupKey()] = self.periods;
				} else {
					var periods = ko.unwrap(self.statement.periods);
					for (var i = 0; i < periods.length; i++) {
						self.periodIdMap[periods[i].lookupKey()] = periods[i];
					}
				}
			};

			self.editPeriod = function(data, event){
				if (self.isEditable) {
					var periodToEdit = null;
					if (LifeCycle.SpreadData._isPeriod(data)) {
						periodToEdit = data;
						self.cache('period', {
							source: data.source(),
							analyst: data.analyst(),
							isFiscalYear: data.isFiscalYear(),
							isGlobalAnalysisYear: data.isGlobalAnalysisYear(),
							covenantCompliances: data.covenantCompliances()
						});
					} else {
						periodToEdit = new app.SpreadStatementPeriod();
					}

					if (self.spread.navApp.viewModel.savePending()) {
						self.spread.navApp.viewModel.saveChanges(function(){
							self.selectedPeriod(periodToEdit);
							jQuery('#add_new_period_modal').modal({ backdrop: 'static' });
						});
					} else {
						self.selectedPeriod(periodToEdit);
						jQuery('#add_new_period_modal').modal({ backdrop: 'static' });
					}
					
					jQuery('#covenantsSelect').trigger('chosen:updated');
				}
			};

			self.createPeriod = function(){
				var period = self.selectedPeriod();

				period.statement = self.statement;
				period.statementId(self.statement.recordId());
				if(period.applyValidationModel().isValid()){
					if(!self.periodExists()){
						LifeCycle.blockUI('300px');
						jQuery('#add_new_period_modal').modal('hide');
						spreadStatementInstance.aoPeriods.push(period);
						self.statement.periods.push(period);
						if (self.periodIdMap != null) {
							self.periodIdMap[period.lookupKey] = period;
						} else {
							self.requestPeriodMap();
						}
						objToSave = app.mapToJS(period, {useOptimizedMapper: true});
						LifeCycle.SpreadsService.saveIForce(objToSave, function(response){
							app.mapFromJS(response, app.getMapping(), period);
							if (period.covenantCompliances().length) {
								var count = period.covenantCompliances().length;
								period.covenantCompliances().forEach(function (cc) {
									objToSave = app.mapToJS(cc, {useOptimizedMapper: true});
									LifeCycle.SpreadsService.saveIForce(objToSave, function () {
										if (!--count) {
											window.location.reload();
										}
									});
								});
							} else {
								window.location.reload();
							}
						});
					}
				}
			};

			self.revertPeriod = function() {
				if (!_.isUndefined(self.selectedPeriod) && 
					!_.isUndefined(self.selectedPeriod())) {

					var periodCache = self.getCache('period');
					if (!_.isUndefined(periodCache) && periodCache != null) { 

						if (!_.isUndefined(periodCache.source)) { 
							self.selectedPeriod().source(periodCache.source);
						}
						if (!_.isUndefined(periodCache.analyst)) { 
							self.selectedPeriod().analyst(periodCache.analyst);
						}
						if (!_.isUndefined(periodCache.isFiscalYear)) { 
							self.selectedPeriod().isFiscalYear(periodCache.isFiscalYear);
						}
						if (!_.isUndefined(periodCache.isGlobalAnalysisYear)) { 
							self.selectedPeriod().isGlobalAnalysisYear(periodCache.isGlobalAnalysisYear);
						}
						if (!_.isUndefined(periodCache.covenantCompliances)) {
							self.selectedPeriod().covenantCompliances(periodCache.covenantCompliances);
						}
					}
				}

				jQuery('#add_new_period_modal').modal('hide');
			};

			self.openConvertToCRE = function() {
				if (self.canConvertToCRE()) {
					if(self.relatedCollateral().length > 0) {
						self.selectedCollateral(self.relatedCollateral()[0]);
					}
					jQuery('#convert_to_cre_modal').modal().modal('show');
				}
			}
			self.convertToCRE = function(){
				LifeCycle.blockUI();
				LifeCycle.Spreads.createSpread(
					self.spread.spreadId,
					ko.unwrap(self.selectedCollateral().collateralMgmtId),
					function(data){
						window.location.replace('/apex/Spread?id=' + data);
					},
					function(){});
			}

			self.periodExists = ko.computed(function(){
				if (!_.isUndefined(self.selectedPeriod) &&
					!_.isUndefined(self.selectedPeriod())) {

					var period = self.selectedPeriod();
					if (_.isUndefined(period.recordId) || period.recordId() == null) {
						var displayStatementDate = new Date(period.displayStatementDate());
						var selectedSource = period.source();
						period.statementDate(displayStatementDate.getTime());
						period.year(displayStatementDate.getFullYear());
						period.month(displayStatementDate.getMonth() + 1);
						var statementDate = new Date(period.statementDate());
						var periodExists = _.findWhere(
							spreadStatementInstance.aoPeriods, 
							{
								month: statementDate.getMonth() +1,
								numberOfPeriods: parseInt(period.numberOfPeriods()),
								year: statementDate.getFullYear()
							}
						);
						
						if(!_.isUndefined(periodExists)){
							
							if(_.isUndefined(periodExists.source) || periodExists.source == ''){
								
								period.errorMsg('A period already exists for this time frame which has not yet been given a source.');
								
							}else{
								
								if(selectedSource == periodExists.source){
									period.errorMsg('A period already exists for this time frame which has the same source.');
								}else{
									period.errorMsg(undefined);
									return false;
								}
								
							}
							
							return true;
							
						}
					}

					period.errorMsg(undefined);
				}

				return false;
			});
			
			self.allRecords = function(){
				if(!_.isUndefined(self.statement.recordTotals())){
					var allRecords = [];
					_.each(self.statement.recordTotals(), function(recordTotal){
							allRecords.push(recordTotal);
						_.each(recordTotal.records(), function(record){
							allRecords.push(record);
						});
					});
					return allRecords;
				}
			};

			function _buildRecordIdMap() {
				if (_.isUndefined(self.recordIdMap) || self.recordIdMap == null) {
					self.recordIdMap = {};
				}

				var allRecords = self.allRecords();

				if (_.isUndefined(allRecords.length)) {
					self.recordIdMap[allRecords.recordId()] = allRecords;
				} else {
					for (var i = 0; i < allRecords.length; i++) {
						self.recordIdMap[allRecords[i].recordId()] = allRecords[i];
					}
				}
			};

			self.requestPeriodMap = function() {
				_buildPeriodIdMap();
				var publishData = _.extend({ 'periodMap': self.periodIdMap }, { 'recordId': ko.observable(self.spread.spreadId) });
				app.publish('SPREAD.Spreads.Period_Map_Loaded', publishData);
			};

			self.requestRecordMap = function() {
				_buildRecordIdMap();
				var publishData = _.extend({ 'recordMap': self.recordIdMap }, { 'recordId': ko.observable(self.spread.spreadId) });
				app.publish('SPREAD.Spreads.Record_Map_Loaded', publishData);
			}

			self.onRequestPeriodMap = function(data) {
				if (!_.isUndefined(data.recordId) && data.recordId == ko.unwrap(self.statement.recordId)) {
					self.requestPeriodMap();
				}
			};

			self.onRequestRecordMap = function(data) {
				if (!_.isUndefined(data.recordId) && data.recordId == ko.unwrap(self.statement.recordId)) {
					self.requestRecordMap();
				}
			};

			self.onAnnualIncomeUpdated = function(data) {
				if (data) {
					self.spread.updateAnnualIncomeRecords(
						data,
						function(){});
				}
			};

			self.onRequestCurrentUser = function(callback) {
				callback(self.currentUserId());
			};

			self.load = function(){
				app.subscribe('SPREAD.Spreads.Request_Period_Map', self.onRequestPeriodMap);
				app.subscribe('SPREAD.Spreads.Request_Record_Map', self.onRequestRecordMap);
				app.subscribe('SPREAD.Spreads.Rent_Roll.Annual_Income_Updated', self.onAnnualIncomeUpdated);
				app.subscribe('SPREAD.Spreads.Get_Current_User_Id', self.onRequestCurrentUser);

				try{
					if(_.isEmpty(self.statement.recordId())){
						throw new Error(LifeCycle.msgs.msg_spread_config_required_data);
					}
					
					SpreadStatement._getStatement(
							self.statement.recordId(),
							function(statement, event){
								if (self.isLoaded()) {
									return;
								}
								app.publish('SPREAD.Spreads.Spread_Config.Loaded_Periods');

								self.requestPeriodMap();
								if(!_.isEmpty(self.relationship.recordId())) {
									LifeCycle.SpreadsService.retrieveIForce(
										{},
										self.relationship.recordId(),
										function(result, event){
											app.mapFromJS(result, self.mapping, self.relationship);
											self.isLoaded(true);
										},
										app.log.failure);
								}
								self.requestRecordMap();
							},
							app.log.failure);
				}catch(e){
					app.log.failure(null, e);
				}

				// Setup toggle buttons to "modified" radio-format
				// That is, allow 0-1 toggle buttons to be selected
				var toggleNavItems = jQuery(".nav > li:has(*[data-bind*='click: toggle'])");

				toggleNavItems.on('click', function (e) { 

					if(!jQuery(this).hasClass(".active")) { 
						var itemsToDeselect = jQuery(toggleNavItems).filter(".active").not(this);

						itemsToDeselect.each(function () {
							// Initiate the click event on the child element ONLY, to prevent infinite recursion
							// Use triggerHandler to prevent propagation
							jQuery(this).children().triggerHandler('click');

							jQuery(this).removeClass("active");
							jQuery(this).children().removeClass("active");
						});
					}
				});
			};

			self.save = function(vm){
				try{
					if(_.isEmpty(self.statement.recordId())){
						throw new Error(LifeCycle.msgs.msg_spread_config_required_data);
					}/* @TODO check if it's dirty */
					if(self.applyValidationModel().isValid()){
						app.performingAjax(true);


						var saveData = app.mapToJS(vm.statement, { maxDepth: 0 });

						delete saveData.lookupKey;
						LifeCycle.SpreadsService.saveIForce(
							saveData,
							function(result, event){
								app.mapFromJS(result, self.mapping, vm);
								self.spread.setCalcCommonSizingDivisorId(
									self.statement.calcCommonSizingDivisorId()
								);
								app.performingAjax(false);
							},
							app.log.failure
						);
					}
				}catch(e){
					app.log.failure(null, e);
					app.performingAjax(false);
				}
			};

			self.saveBundle = function() {
				try{
					if(self.statement.bundle && !_.isEmpty(self.statement.bundle)){
						app.performingAjax(true);

						var saveData = app.mapToJS(self.statement.bundle, { useOptimizedMapper: true, maxDepth: 0 });
						LifeCycle.SpreadsService.saveIForce(
							saveData,
							function(result, event){
								app.performingAjax(false);
							},
							app.log.failure
						);
					}
				}catch(e){
					app.log.failure(null, e);
					app.performingAjax(false);
				}
			};

			self.optionsCaption = LifeCycle.msgs.msg_spread_config_common_sizing_options_caption;
			self.common_sizing_save_button_msg = LifeCycle.msgs.msg_common_sizing_save_button_msg;
			self.permissionNotMet = LifeCycle.msgs.msg_permission_not_met;

			return self;
			
		}
	};
	if(LifeCycle.SpreadConfigApp.ViewModel == undefined){
		LifeCycle.SpreadConfigApp.ViewModel = ViewModel;
	}
})();


ko.bindingHandlers.buttonToggler = {
	init: function (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {
		ko.bindingHandlers.checked.init(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext);

		var initialSelectedScale = ko.unwrap(valueAccessor());
		jQuery(element).parent().removeClass("active");
		jQuery(element).css("display", "none");
		if (initialSelectedScale == jQuery(element).val()) {
			jQuery(element).parent().addClass("active");
		}

	},
	update: function (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {
		var initialSelectedScale = ko.unwrap(valueAccessor());
		jQuery(element).parent().removeClass("active");
		if (initialSelectedScale == jQuery(element).val()) {
			jQuery(element).parent().addClass("active");
		}
	}
};

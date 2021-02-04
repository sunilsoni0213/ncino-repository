(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			self.app = app;
			
			var defaultData = {
				bundles: [],
				spreads: [],
				statements: [],
				entities: [],
				viewMode: LifeCycle.msgs.msg_mode_print,
				autoclose: false,
				exportDebtSchedule: true,
				exportRmaStatement: true,
				hideEmptyRecords: false,
				includeCRE: null,
				exportGlobalAnalysis: false,
				scope: '',
				hasCRE: false,
				enableRMA: false,
				rmaURL: '',
				rmaKey: ''
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.getMapping()['ignore'] = ['spread'];
			app.mapFromJS(defaultData, app.getMapping(), self);
			
			self.spread = data.spread;
			
			self.loadedBundles = ko.observableArray();
			self.loadedEntities = ko.observableArray();
			
			for (var i = 0; i < self.entities().length; i++) {
				var entity = self.entities()[i];
				self.entities.replace(entity, LifeCycle.SpreadData.lookupIForceById(entity.recordId(), {
					generatePlaceholder: true,
					alwaysReturnModel: true,
					placeholderType: 'c.ALifeCycleInvolvement'
				}));
				LifeCycle.SpreadData.getIForceById(entity.recordId(), {}, function (_entity) {
					self.loadedEntities.push(_entity)
				});
			}
			
			self.canExportFootnotes = function() {
				return (!_.isUndefined(self.spread) &&
				!_.isUndefined(self.spread.commentsApp) &&
				!_.isUndefined(self.spread.footnotesApp));
			};
			
			self.isGlobalOnly = ko.computed(function() {
				return (self.scope() == LifeCycle.msgs.msg_scope_global);
			});
			
			self.exportGlobalAnalysis = ko.computed(function() {
				return (self.scope() == LifeCycle.msgs.msg_scope_global || self.scope() == LifeCycle.msgs.msg_scope_loan);
			});
			
			self.remotingCallSuccessCount = LifeCycle.IForceCache._batchedIdsCompleted;
			self.remotingCallCount = LifeCycle.IForceCache._batchedIds;
			self.progressBar = LifeCycle.IForceCache._batchProgress;
			
			var _fnFormatPercentageForDisplay = function(value){
				if(!_.isUndefined(value) && !isNaN(value)){
					iValue = (Math.abs(value) * 100).toFixed(2);
					return value < 0 ? "(" + iValue + ")" : iValue;
				}
				return 0.00;
			};
			
			function _processNewBundle (newBundle) {
				var bundleIds = self.bundles().map(function (b) { return _18Id(b.recordId()); });
				var index = bundleIds.indexOf(_18Id(newBundle.recordId()));
				var oldBundle = self.bundles()[index];
				
				self.bundles.replace(oldBundle, newBundle);
				
				newBundle.loadedStatements = ko.computed({
					read: function(){
						return newBundle.statements().filter(function(data){
							return data.isLoaded();
						});
					}
				});
				
				newBundle.numberOfSelectedPeriods = ko.computed({
					read: function(){
						var selectedPeriods = 0;
						for(var i = 0; i< newBundle.statements().length; i++){
							var currentStatement = newBundle.statements()[i];
							for(var j=0; j<currentStatement.periods().length; j++){
								if(currentStatement.periods()[j].selected() || currentStatement.isStaticPeriods()){
									selectedPeriods += 1;
								}
							}
						}
						return selectedPeriods;
					}
				});
				
				newBundle.loadedPeriodsWithRecordValues = ko.computed({
					read: function(){
						var loadedPeriods = 0;
						for(var i = 0; i< newBundle.statements().length; i++){
							var currentStatement = newBundle.statements()[i];
							for(var j=0; j<currentStatement.periods().length; j++){
								if((currentStatement.periods()[j].selected() || currentStatement.isStaticPeriods())
									&& currentStatement.periods()[j].hasLoadedRecordValues()){
									
									loadedPeriods += 1;
								}
							}
						}
						return loadedPeriods;
					}
				});
				
				newBundle.statementsWithLoadedRelationships = ko.computed({
					read: function(){
						return newBundle.statements().filter(function(statement){
							if(
								statement.spreads().length > 0 &&
								!_.isEmpty(statement.spreads()[0].involvement)
							){
								return statement.spreads()[0].involvement.relationship.isLoaded();
							}else{
								return false;
							}
						});
					}
				});
				
				newBundle.hasLoadedAllStatementsWithRelationships = ko.computed({
					read: function(){
						if(newBundle.statements().length > 0){
							return newBundle.statements().length == newBundle.statementsWithLoadedRelationships().length;
						}else{
							return false;
						}
					}
				});
				
				newBundle.hasLoadedAllSelectedPeriodsWithRecordValues = ko.computed({
					read: function(){
						return newBundle.numberOfSelectedPeriods() == newBundle.loadedPeriodsWithRecordValues();
					}
				});
				
				newBundle.finishedLoading = ko.computed({
					read: function(){
						return (newBundle.hasLoadedAllSelectedPeriodsWithRecordValues());
					}
				});
			}
			
			self.loadBundlesAndStatements = function (bundles, callback) {
				LifeCycle.SpreadData.getEntireBundles(
					bundles,
					{},
					function (newBundles) {
						for (var i = 0; i < newBundles.length; i++) {
							var newBundle = newBundles[i];
							_processNewBundle(newBundle);
						}
						callback(newBundles);
					}
				);
			};
			
			self.loadBundleAndStatements = function(bundle, callback){
				
				LifeCycle.SpreadData.getEntireBundle(
					bundle.recordId(),
					{},
					function (newBundle) {
						_processNewBundle(newBundle);
						callback(newBundle);
					}
				);
			};
			
			self.getDisplayDate = function(statementDate, seperator){
				if(_.isUndefined(seperator)){
					seperator = '/';
				}
				
				var sDate = (statementDate != null ? new Date(statementDate) : new Date());
				return (sDate.getMonth()+1) + seperator + sDate.getDate() + seperator + sDate.getFullYear();
			};
			
			var _sortStatements = function(statements){
				statements().sort(function(a,b){
					return (a.sortOrder() < b.sortOrder() ? -1 : 1);
				});
			}
			
			var _sortRecordTotals = function(statements){
				for(var i=0;i<statements().length; i++){
					statements()[i].recordTotals().sort(function(a,b){
						return (a.rowNumber() < b.rowNumber() ? -1 : 1);
					});
				}
			};
			
			var _sortPeriods = function(statements){
				for(var i=0;i<statements().length; i++){
					var currentStatement = statements()[i];
					
					currentStatement.periods().sort(function(a,b){
						if (a.periodKey() < b.periodKey()) {
							return -1;
						}
						if (a.periodKey() > b.periodKey()) {
							return 1;
						}
						return 0;
					});
				}
			};
			
			var _generatePeriodMap = function(statements){
				for(var i=0;i<statements().length; i++){
					var currentStatement = statements()[i];
					currentStatement.periodMap = {};
					
					for(var j=0; j<currentStatement.periods().length; j++){
						var currentPeriod = currentStatement.periods()[j];
						currentStatement.periodMap[currentPeriod.recordId()] = currentPeriod;
					}
				}
			};
			
			var _generatePeriodLookupMap = function(statements){
				for(var i=0;i<statements().length; i++){
					var currentStatement = statements()[i];
					currentStatement.periodLookupMap = {};
					
					for(var j=0; j<currentStatement.periods().length; j++){
						var currentPeriod = currentStatement.periods()[j];
						currentStatement.periodLookupMap[currentPeriod.lookupKey()] = currentPeriod;
					}
					
					var publishData = _.extend({ 'periodMap': currentStatement.periodLookupMap },
						_.pick(currentStatement, 'recordId'));
					app.publish('SPREAD.Spreads.Period_Map_Loaded', publishData);
				}
			};
			
			var _generateRecordMap = function(statements){
				for(var i=0;i<statements().length; i++){
					var currentStatement = statements()[i];
					currentStatement.recordMap = {};
					
					if (_.isUndefined(currentStatement.recordTotals().length)) {
						currentStatement.recordMap[currentStatement.recordTotals().recordId()] = currentStatement.recordTotals();
					} else {
						_.each(currentStatement.recordTotals(), function(recordTotal){
							currentStatement.recordMap[recordTotal.recordId()] = recordTotal;
							if (_.isUndefined(recordTotal.records().length)) {
								currentStatement.recordMap[recordTotal.records().recordId()] = recordTotal.records();
							} else {
								_.each(recordTotal.records(), function(record){
									currentStatement.recordMap[record.recordId()] = record;
								});
							}
						});
					}
					
					var publishData = _.extend({ 'recordMap': currentStatement.recordMap },
						_.pick(currentStatement, 'recordId'));
					app.publish('SPREAD.Spreads.Record_Map_Loaded', publishData);
				}
			};
			
			var _generateOrderedIds = function(statements){
				for(var i=0;i<statements().length; i++){
					var currentStatement = statements()[i];
					
					currentStatement.orderedPeriodIds = [];
					currentStatement.selectedOrderedPeriodIds = [];
					for(var j=0; j<currentStatement.periods().length; j++){
						currentStatement.orderedPeriodIds.push(currentStatement.periods()[j].recordId());
						
						if(currentStatement.periods()[j].selected() || currentStatement.isStaticPeriods()){
							currentStatement.selectedOrderedPeriodIds.push(currentStatement.periods()[j].recordId());
						}
					}
				}
			};
			
			var _generateRecordValueMap = function(statements){
				for(var i=0;i<statements().length; i++){
					var currentStatement = statements()[i];
					currentStatement.recordValueMap = {};
					
					for(var j=0; j<currentStatement.periods().length; j++){
						var currentPeriod = currentStatement.periods()[j];
						
						var periodMap = currentStatement.recordValueMap[currentPeriod.recordId()];
						if(periodMap == null){
							periodMap = {};
							currentStatement.recordValueMap[currentPeriod.recordId()] = periodMap;
						}
						
						for(var k=0; k<currentPeriod.recordValues().length; k++){
							var currentRecordValue = currentPeriod.recordValues()[k];
							
							periodMap[currentRecordValue.record.recordId()] = currentRecordValue;
						}
					}
				}
			};
			
			var _generatePeriodTotalMap = function(statements){
				for(var i=0;i<statements().length; i++){
					var currentStatement = statements()[i];
					currentStatement.periodTotalMap = {};
					
					for(var j=0; j<currentStatement.periods().length; j++){
						var currentPeriod = currentStatement.periods()[j];
						
						var periodMap = currentStatement.periodTotalMap[currentPeriod.recordId()];
						if(periodMap == null){
							periodMap = {};
							currentStatement.periodTotalMap[currentPeriod.recordId()] = periodMap;
						}
						
						for(var k=0; k<currentPeriod.periodTotals().length; k++){
							var currentPeriodTotals = currentPeriod.periodTotals()[k];
							
							periodMap[currentPeriodTotals.recordTotal.recordId()] = currentPeriodTotals;
						}
					}
				}
			};
			
			var _generateAnalystOptionMap = function(statements){
				for(var i=0;i<statements().length; i++){
					var currentStatement = statements()[i];
					currentStatement.analystIdMap = {};
					
					for(var j=0; j<currentStatement.analystOptions().length; j++){
						var currentAnalystOption = currentStatement.analystOptions()[j];
						var analystIds = Object.keys(currentAnalystOption);
						_.each(analystIds, function(analystId){
							currentStatement.analystIdMap[analystId] = ko.unwrap(currentAnalystOption[analystId]);
						});
					}
				}
			};
			
			self.footnoteComponents = ko.observableArray();
			self.loadedFootnoteComponents = ko.observableArray();
			self.commentComponents = ko.observableArray();
			self.loadedCommentComponents = ko.observableArray();
			self.loadingFootnoteComponents = ko.observable(false);
			self.loadFootnoteComponents = function() {
				self.loadingFootnoteComponents(true);
				
				var commentComponentsLoading = [];
				var footnoteComponentsLoading = [];
				
				_.each(self.bundles(), function(bundle) {
					_.each(bundle.statements(), function(statement) {
						if(statement.spreads().length) {
							var spread = statement.spreads()[0];
							var spreadId = spread.recordId();
							var statementTypeId = spread.statement.recordId();
							
							// Create the comments app for the given spread.
							if(!_.contains(commentComponentsLoading, spreadId)){
								commentComponentsLoading.push(spreadId);
								
								var commentsVM = new self.spread.commentsApp.ViewModel({
									'contextId': statementTypeId,
									'currentUser': {},
									'configuration': {
										'autoLoad': true
									},
									'permissions': {
										'canAddComment': false
									}
								});
								commentsVM.load();
								
								self.commentComponents.push(commentsVM);
								self.loadedCommentComponents.push(statementTypeId);
							}
							
							// Create the footnotes app for the given spread.
							if(!_.contains(footnoteComponentsLoading, statementTypeId)){
								footnoteComponentsLoading.push(statementTypeId);
								
								var footnotesVM = new self.spread.footnotesApp.ViewModel({
									'footnoteConfiguration': { 'showFootnotes': ko.unwrap(bundle.showFootnotes) },
									'spreadId': ko.unwrap(spread.recordId),
									'statementType': ko.unwrap(statement.statementType),
									'statementTypeId': statementTypeId,
									'mode': ko.unwrap(self.viewMode)
								});
								footnotesVM.load();
								
								self.footnoteComponents.push(footnotesVM);
								self.loadedFootnoteComponents.push(statementTypeId);
							}
						}
					});
				});
				
				self.loadingFootnoteComponents(false);
			};
			
			self.debtSchedules = ko.observableArray();
			self.loadedDebtSchedules = ko.observableArray();
			self.debtSchedulesLoading = [];
			
			self.loadDebtSchedules = function(){
				self.loadingDebtSchedules(true);
				
				// Keep track of loading vs. loaded internally
				_.each(self.bundles(), function(bundle){
					_.each(bundle.statements(), function(statement){
						_.each(statement.spreads(), function(spread){
							var entityId = spread.involvement.recordId();
							if(!_.contains(self.debtSchedulesLoading, entityId)) {
								self.debtSchedulesLoading.push(entityId);
								
								var debtScheduleParams = {
									spread: {
										spreadId: spread.recordId()
									},
									legalEntity: {
										recordId: entityId
									},
									mode: LifeCycle.msgs.msg_mode_print
								};
								
								app.publish('SPREAD.Spreads.Load_Debt_Schedule', debtScheduleParams);
							}
						});
					});
				});
			};

			self.rmaStatements = ko.observableArray();
			self.loadedRmaStatements = ko.observableArray();
			self.rmaStatementsLoading = [];

			self.loadRmaStatements = function(){
				self.loadingRmaStatements(true);
				var naics = self.bundles().map(function(bundle) {
					if (!ko.unwrap(bundle.container.naicsCode)) {
						return false;
					}
					
					var relationshipId = bundle.container.recordId();
					if (self.rmaStatementsLoading.indexOf(relationshipId) < 0) {
						self.rmaStatementsLoading.push(relationshipId);
						var rmaStatementParams = {
							relationship: {
								recordId: relationshipId
							},
							rmaKey: self.rmaKey(),
							rmaURL: self.rmaURL()
						};
						app.publish('SPREAD.Spreads.Load_RMA_Statement', rmaStatementParams);
					}
					
					return true;
				});
				
				return naics.some(function (x) { return x; });
			};

			self.rentRolls = ko.observableArray();
			self.loadedRentRolls = ko.observableArray();
			self.rentRollsToLoad = [];
			self.sensitivityAnalyses = ko.observableArray();
			self.loadedSensitivityAnalyses = ko.observableArray();
			
			self.loadRentRolls = function() {
				self.loadingRentRolls(true);
				_.each(self.bundles(), function(bundle){
					_.each(bundle.statements(), function(statement){
						_.each(statement.spreads(), function(spread){
							if (ko.unwrap(spread.collateralMgmt)) {
								if(!_.contains(self.rentRollsToLoad, spread.collateralMgmt())) {
									self.rentRollsToLoad.push(spread.collateralMgmt());
									
									var sensitivityAnalysisParams = {
										loan: {
											recordId: self.loanId()
										},
										collateral: {
											recordId: spread.collateralMgmt()
										},
										spread: {
											recordId: spread.recordId()
										},
										statement: {
											recordId: spread.statement.recordId()
										},
										mode: LifeCycle.msgs.msg_mode_print
									};
									app.publish('SPREAD.Spreads.Load_Sensitivity_Analysis', sensitivityAnalysisParams);
								}
							}
						});
					});
				});
				
				_.each(self.rentRollsToLoad, function(collateralMgmt) {
					var rentRollParams = {
						collateral: {
							recordId: collateralMgmt
						},
						'mode': LifeCycle.msgs.msg_mode_print
					};
					app.publish('SPREAD.Spreads.Load_Rent_Roll', rentRollParams);
				});
			}
			
			app.subscribe("SPREAD.Spreads.Debt_Schedule_Loaded", function (debtScheduleVM) {
				// Override the relationship name for the proposed loan with the known entity name
				var entityRelationship = debtScheduleVM.legalEntity.relationship;
				if (debtScheduleVM.container.proposedLoans().length > 0)
					debtScheduleVM.container.proposedLoans()[0].relationshipName(entityRelationship.name());
				
				self.debtSchedules.push(debtScheduleVM);
				self.loadedDebtSchedules.push(debtScheduleVM.legalEntity.recordId);
				
				// Check if all debt schedules loaded
				var loading = self.debtSchedulesLoading;
				var loaded = self.loadedDebtSchedules();
				if (jQuery(loaded).not(loading).length === 0 && jQuery(loading).not(loaded).length === 0) {
					// All debt schedules loaded
					self.loadingDebtSchedules(false);
				}
			});

			app.subscribe("SPREAD.Spreads.RMA_Statement_Loaded", function (rmaStatementVM) {
				self.rmaStatements.push(rmaStatementVM);
				self.loadedRmaStatements.push(rmaStatementVM.relationship.recordId());
				var loading = self.rmaStatementsLoading;
				var loaded = self.loadedRmaStatements();
				if (jQuery(loaded).not(loading).length === 0 && jQuery(loading).not(loaded).length === 0) {
					self.loadingRmaStatements(false);
				}
			});

			app.subscribe("SPREAD.Spreads.Rent_Roll_Loaded", function (rentRollVM) {
				self.rentRolls.push(rentRollVM);
				self.loadedRentRolls.push(rentRollVM.collateral.recordId());
				
				var loading = self.rentRollsToLoad;
				var loaded = self.loadedRentRolls();
				if (jQuery(loaded).not(loading).length === 0 && jQuery(loading).not(loaded).length === 0) {
					// All rent rolls loaded
					self.loadingRentRolls(false);
				}
			});
			
			app.subscribe("SPREAD.Spreads.Sensitivity_Analysis_Loaded", function (sensitivityAnalysisVM) {
				if (self.sensitivityAnalyses.indexOf(sensitivityAnalysisVM) < 0) {
					self.sensitivityAnalyses.push(sensitivityAnalysisVM);
				}
				if (self.loadedSensitivityAnalyses.indexOf(sensitivityAnalysisVM.collateral.recordId()) < 0) {
					self.loadedSensitivityAnalyses.push(sensitivityAnalysisVM.collateral.recordId());
				}
			});
			
			self.globalAnalysis = ko.observable();
			self.loadingGlobalAnalysis = ko.observable(false);
			self.loadedGlobalAnalysis = ko.observable(false);
			var _loadGlobalAnalysis = function() {
				if (self.exportGlobalAnalysis()) {
					self.loadingGlobalAnalysis(true);
					self.spread.globalAnalysisApp.viewModel.loadGlobalAnalysis(self.bundles());
					self.loadingGlobalAnalysis(false);
					self.loadedGlobalAnalysis(true);
				}
			}
			
			self.generateFileName = function(extension){
				var fileName = '';
				var seperator = '';
				_.each(app.viewModel.bundles(), function(bundle){
					var relationshipName = seperator+bundle.container.name();
					fileName += relationshipName.split(' ').join('_');
					seperator = '_';
				});
				return fileName + '_' + self.getDisplayDate(null, '-') + extension;
			};
			self.loadingDebtSchedules = ko.observable(false);

			self.loadingRmaStatements = ko.observable(false);

			self.loadRentRollsStarted = ko.observable(false);
			self.loadingRentRolls = ko.observable(false);
			
			self.loadSensitiviyAnalysesStarted = ko.observable(false);
			self.loadingSensitivityAnalyses = ko.observable(false);
			
			self.readyToRender = ko.computed({
				read: function(){
					var loadedBundles = self.loadedBundles().length;
					var loadedEntities = self.loadedEntities().length;
					var loadedDebtSchedules = self.debtSchedules().length;
					var loadingDebtSchedules = self.loadingDebtSchedules();
					var loadedRmaStatements = self.rmaStatements().length;
					var loadingRmaStatements = self.loadingRmaStatements();
					var loadedRentRolls = self.rentRolls().length;
					var rentRollsToLoad = self.rentRollsToLoad.length;
					var loadingRentRolls = self.loadingRentRolls();
					
					var loadedSensitivityAnalyses = self.sensitivityAnalyses().length;
					
					var loadedGlobalAnalysis = self.loadedGlobalAnalysis();
					var loadingGlobalAnalysis = self.loadingGlobalAnalysis();
					var loadedFootnoteComponents = self.footnoteComponents().length;
					var loadingFootnoteComponents = self.loadingFootnoteComponents();
					
					var startedEntities = ko.computed(function () {
						var started = [];
						_.each(self.bundles(), function (bundle) {
							_.each(bundle.statements(), function (statement) {
								if (started.indexOf(bundle) == -1 && statement.spreads().length) {
									started.push(bundle);
								}
							})
						});
						return started.length;
					});
					
					if(self.bundles().length > 0 && self.bundles().length == loadedBundles || self.scope() == LifeCycle.msgs.msg_scope_global) {
						
						if (self.canExportFootnotes() && self.scope() != LifeCycle.msgs.msg_scope_global) {
							if (!loadingFootnoteComponents && !loadedFootnoteComponents) {
								self.loadFootnoteComponents();
							}
						}
						
						if(self.exportDebtSchedule() && self.scope() != LifeCycle.msgs.msg_scope_global) {
							if(!loadingDebtSchedules && loadedDebtSchedules < startedEntities()) {
								self.loadDebtSchedules();
								return false;
							}
							if (loadingDebtSchedules) {
								return false;
							}
						}

						if(self.exportRmaStatement() && self.scope() != LifeCycle.msgs.msg_scope_global) {
							if(!loadingRmaStatements && !loadedRmaStatements && self.enableRMA()) {
								if (self.loadRmaStatements()) {
									return false;
								} else {
									self.loadingRmaStatements(false);
									self.enableRMA(false);
									lodaingRmaStatements = false;
								}
							}
							if (loadingRmaStatements) {
								return false;
							}
						}

						if((self.includeCRE() || (self.includeCRE() == null && self.hasCRE())) && self.scope() != LifeCycle.msgs.msg_scope_global) {
							if (!self.loadRentRollsStarted()) {
								self.loadRentRollsStarted(true);
								self.loadRentRolls();
								return false;
							}
							if (!loadingRentRolls && loadedRentRolls < rentRollsToLoad) {
								self.loadRentRolls();
								return false;
							}
							if (loadingRentRolls) {
								return false;
							}
							if (loadedSensitivityAnalyses < rentRollsToLoad) {
								return false;
							}
						}
						
						if (self.exportGlobalAnalysis()) {
							if (!self.spread || !self.spread.globalAnalysisApp || !self.spread.globalAnalysisApp.viewModel) {
								return false;
							}
							
							if (!self.spread.globalAnalysisApp.viewModel.loaded()) {
								return false;
							}
						}
						
						return true;
						
					}
					
					return false;
				}
				
			});
			
			self.load = function(params){
				jQuery('#global_batch_progress').show();
				jQuery('#printConfigModal').modal('hide');
				jQuery('.center-block').hide();
				if(!_.isUndefined(self.anchorVM)){
					self.anchorVM.widget().isLoading(true);
				} else {
					jQuery("#loading-modal").modal("show");
				}
				
				self.params = {};
				if(!_.isUndefined(params)){
					self.params = params;
				}
				self.debtScheduleBindingsApplied = false;
				self.rmaStatementBindingsApplied = false;
				self.rentRollBindingsApplied = false;
				self.sensitivityAnalysisBindingsApplied = false;
				self.hasBeenRendered = false;
				
				function _print () {
					jQuery('#global_batch_progress').hide();
					
					if(self.debtSchedules().length > 0 && !self.debtScheduleBindingsApplied){
						ko.applyBindings(self, document.getElementById('debt_schedule_container'));
						self.debtScheduleBindingsApplied = true;
					}
					if(self.rmaStatements().length > 0 && !self.rmaStatementBindingsApplied){
						ko.applyBindings(self, document.getElementById('rma_benchmarks_container'));
						self.rmaStatementBindingsApplied = true;
					}
					if(self.rentRolls().length > 0 && !self.rentRollBindingsApplied){
						ko.applyBindings(self, document.getElementById('rent_roll_container'));
						self.rentRollBindingsApplied = true;
					}
					if(self.sensitivityAnalyses().length > 0 && !self.sensitivityAnalysisBindingsApplied){
						ko.applyBindings(self, document.getElementById('sensitivity_analysis_container'));
						self.sensitivityAnalysisBindingsApplied = true;
					}
					
					if(!self.hasBeenRendered){
						var html = self.app.view.render();
					}
					self.hasBeenRendered = true;
					if(self.viewMode() == 'excel'){
						var fileName = self.generateFileName(self.excelExportPostfix());
						
						LifeCycle.Spreads.saveAttachment(
							fileName,
							html,
							self.bundles()[0].recordId(), // first bundle id
							'application/vnd.ms-excel',
							function(attachmentId){
								window.location.replace("/servlet/servlet.FileDownload?file="+attachmentId);
							},
							function(){});
					}
					
					if(!_.isUndefined(self.anchorVM)){
						self.anchorVM.widget().isLoading(false);
					}
					if(!_.isUndefined(self.screenSection)){
						self.saveRenderedView();
					}
				}
				
				if (self.readyToRender()) {
					_print();
				} else {
					self.readyToRender.subscribe(function(isReady){
						if(isReady){
							_print();
						}
					});
				}
				
				if (self.scope() != LifeCycle.msgs.msg_scope_global) {
					self.loadBundlesAndStatements(
						self.bundles().map(function (b) { return b.recordId(); }),
						function(bundles){
							_.each(bundles, function(bundle){
								_sortStatements(bundle.statements);
								_sortRecordTotals(bundle.statements);
								_sortPeriods(bundle.statements);
								_generateOrderedIds(bundle.statements);
								if (self.loadedBundles().indexOf(bundle.recordId()) == -1) {
									self.loadedBundles.push(bundle.recordId());
								}
							});
							self.loadingRmaStatements(false);
						}
					);
				}
				
				self.app.subscribe('SPREAD.Spreads.Request_Period_Map', self.onRequestPeriodMap);
				self.app.subscribe('SPREAD.Spreads.Request_Record_Map', self.onRequestRecordMap);
			};
			
			// Saves the attachment and stores the attachmentId in recordId.
			self.saveRenderedView = function() {
				LifeCycle.Force.saveAttachment(
					self.screenSection.recordId(),
					msgs.msg_rendered_view_filename,
					msgs.msg_text_plain,
					jQuery('#'+self.screenSection.recordId()).html(),
					true,
					function(){},
					function(){});
			};
			
			self.cancel = function() {
				window.close();
			}
			
			return self;
		}
	};
	if(LifeCycle.Spread_Base.ViewModel == undefined){
		LifeCycle.Spread_Base.ViewModel = ViewModel;
	}
})();

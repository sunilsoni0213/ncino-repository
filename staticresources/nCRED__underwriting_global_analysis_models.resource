(function(registrationApp){
	var Models = function(event, app){
		app.log('register model event callback executing');
		
		// TODO: move to a generic class
		app.Section = function(data){
			var self = this;
			
			var defaultData = {
				isHovered: false,
				isRendered: false,
				loanId: '',
				underwritingEntities: '',
				lifeCycleLoan: '',
				spreadStatement: ''
			}
			if(data != undefined){
				_.extend(defaultData, data);
			}
			
			app.mapFromJS(defaultData, app.getMapping(), self);
			
			self.loanId.subscribe(function(newValue) {
				if(newValue != null && newValue.length > 0){
					LifeCycle.BorrowerTree.retrieveLoan({}, newValue, function(result){
						self.lifeCycleLoan(new Loan(result));
						
						if(!self.spreadStatement.recordId()){
							LifeCycle.Spreads.createGlobalAnalysisSpreadStatement(
									self.lifeCycleLoan(),
									function(result){
										self.spreadStatement.isConfigurable(result.isConfigurable);
										self.spreadStatement.isEditable(result.isEditable);
										self.spreadStatement.startYear(result.startYear);
										self.spreadStatement.startMonth(result.startMonth);
										self.spreadStatement.endYear(result.endYear);
										self.spreadStatement.endMonth(result.endMonth);
										self.spreadStatement.isTemplate(result.isTemplate);
										self.spreadStatement.groupColumns(result.groupColumns);
										self.spreadStatement.filtering(result.filtering);
										self.spreadStatement.allowedPeriod(
												SpreadStatement.determineAllowedPeriod(
													result.startYear,
													result.startMonth,
													result.endYear,
													result.endMonth));
										self.spreadStatement.recordId(result.statementId);
									});
						}
					});
				}
			});
			
			return self;
		}
		app.UnderwritingEntity = function(data){
			var self = this;
			
			var defaultData = {
				recordId: null,
				includeInGlobal: false,
				name: '',
				type: ''
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
				
			app.mapFromJS(defaultData, app.getMapping(), self);
				
			return self;
		};
		app.SpreadStatement = function(data){
			var self = this;
			
			var defaultData = {
					recordId: null,
					name: '',
					interaction: 'keyboard',
					startYear: '',
					startMonth: '',
					endYear: '',
					endMonth: '',
					isTemplate: '',
					allowedPeriod: '',
					groupColumns: '',
					balanceTotals: '',
					filtering: '',
					isConfigurable: false,
					isEditable: false,
					apexType: app.getTypesMapFlipped['spreadStatement'],
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
				
			app.mapFromJS(defaultData, app.getMapping(), self);
			
			self.spreadInstance = null;
			
			self.recordId.subscribe(function(newValue) {
				if(newValue != null && newValue.length > 0){
					self.spreadInstance = new app.SpreadType(newValue);
					self.spreadInstance.bConfigurable = self.isConfigurable();
					self.spreadInstance.bEditable = self.isEditable();
					self.spreadInstance.sInteraction = self.interaction();
					self.spreadInstance.aiAllowedPeriod = self.allowedPeriod();
					self.spreadInstance.aiSelectedYears = self.spreadInstance.getYears(
							self.spreadInstance.aiAllowedPeriod.years);
					self.spreadInstance.bIsTemplate = self.isTemplate();
					self.spreadInstance.groupColumns = self.groupColumns();
					self.spreadInstance.balanceTotals = self.balanceTotals();
					self.spreadInstance.filtering = self.filtering();

					self.spreadInstance.getRemoteData();
					if(!window.spreadStatementInstance){
						window.spreadStatementInstance = self.spreadInstance;
					}
				}
			});
			return self;
		};
		app.SpreadType = function(recordId){
			var _that = this;
			var iRecordCounter = 0;
			var iGroupCounter = 0;
			var aoRecords = [];
			var aoRecordsOnly = [];
			var asColumnIds = [];
			var asRowIds = [];
			var bReset = false;
			var sTotalRowName = null;
			_that.bConfigurable = false;
			_that.bEditable = false;
			_that.sInteraction = 'keyboard';
			var aoSpreadStatementContainer = {};
			var asSpreadStatementContainerKey = [];
			_that.aoStatementKeyTables = []
			_that.aiAllowedPeriod = {};
			_that.aiSelectedYears = [];
			_that.bIsTemplate = false;
			_that.bColumnSourceEditable = false;
			var sGridControlTemplate = '';
			var nAttachTo = '.main_spreading';
			_that.statementLinkedRecords = null;
			_that.statementLinkedRecordGroups = null;
			var sourceRecordIdMap = {};
			_that.datePickerApp = {};

			_that.initTable = function() {
				return SpreadStatement.initTable(
					recordId,  //statmentId
					nAttachTo,  //nAttachTo
					aoRecords,  //aoRecords
					bReset,  //bReset
					aoSpreadStatementContainer, //aoSpreadStatementContainer
					asSpreadStatementContainerKey, //asSpreadStatementContainerKey
					asRowIds, //asRowIds
					asColumnIds, //asColumnIds
					sTotalRowName, //sTotalRowName
					_that.bConfigurable, //bConfigurable
					_that.bEditable, //bEditable
					_that.bColumnSourceEditable, //bColumnSourceEditable
					_that.sInteraction, //sInteraction
					sGridControlTemplate, //sGridControlWidget
					_that.resetVars, //fnResetVars
					_that.getRemoteTotals, //fnLoadPeriodTotals
					_that.addNewPeriodProxy, //fnAddNewPeriodProxy
					_that.setRecordCounter, //fnSetRecordCOUnter
					_that.setGroupCounter, //fnSetGroupCounter
					_that.setSelectedYears, //fnSetSelectedYears
					false, //bTotalOnly
					_that.groupColumns, //bGroupColumns
					_that.balanceTotals, //bBalanceTotals,
					false, // bDateAppColumns,
					true, // bEnableExpansionArrows
					_that.filtering, //bFiltering
					_that.aiSelectedYears, //aiCurrentYears
					_that.aiAllowedPeriod, //aiAllowedPeriod
					_that.bIsTemplate, //bIsTemplate
					sGridControlTemplate, //sGridControlTemplate
					_that.performRecordUpdate, //updateRecordCell
					_that.getRemoteData, //fnGetRemoteData
					_that.setupLinkedRecords, //setupLinkedRecords
					_that.getLinkableFields, //fnGetLinkedFields
					_that.showHideRecordInGrandTotal,
					_that.notifyLinkedSourceUpdated,
					_that.notifyLinkedSourceUpdated,
					_that.getStatementLinkedRecordValues,
					_that.getStatementLinkedRecordGroups,
					null,  // spreadId
					function(){},  // unlinkRecords
					false,  // isCommonSizingOptional
					function(){},  // updateCommonSizingValues
					function(){},  // accumulateRecordGroups
					null,
					_that.getKeyTableMap,
					_that.setKeyTableMap);
			},
			_that.getKeyTableMap = function(){
				return _that.aoStatementKeyTables;
			}
			_that.setKeyTableMap = function(aoKeyTables){
				_that.aoStatementKeyTables = aoKeyTables;
			}
			_that.moveToNextKeyTable = function(sTableId, iXCoord, iYCoord, bForward){
				var offset = 0;
				var selectedTableIndex;
				var visibleTableFound = false;

				for(var i=0; i<_that.aoStatementKeyTables.length; i++){
					if(_that.aoStatementKeyTables[i].id == sTableId){

						while (!visibleTableFound) {
							bForward ? offset++ : offset--;
							if(i+offset < 0 || i+offset > _that.aoStatementKeyTables.length){
								break;
							}

							if(_that.aoStatementKeyTables[i+offset]
								&& jQuery('#' + _that.aoStatementKeyTables[i+offset].id).closest('.dataTables_wrapper').is(':visible')
								&& !jQuery('#' + _that.aoStatementKeyTables[i+offset].id).hasClass('rows_hidden') ){
								visibleTableFound = true;
								selectedTableIndex = i+offset;
							}
						}
					}
				}
				if(!_.isUndefined(selectedTableIndex)){
					if(!bForward){
						iYCoord = jQuery('#' + _that.aoStatementKeyTables[selectedTableIndex].id).find('tbody tr').length - 1;
					}
					_that.aoStatementKeyTables[selectedTableIndex].keys.fnSetPosition(iXCoord, iYCoord);
					return true;
				}
				return false;
			},
			_that.resetVars = function() {
					iRecordCounter = 0;
					iGroupCounter = 0;
					iPrevRecordCounter = -1;
					iPrevGroupCounter = -1;
					aoRecords.splice(0, aoRecords.length);
					aoRecordsOnly.splice(0, aoRecordsOnly.length);
					asColumnIds.splice(0, asColumnIds.length);
					asRowIds.splice(0, asRowIds.length);
					bReset = false;
				}
			_that.selectYearsForAll = function (aiYears) {
					for ( var i = 0; i < asSpreadStatementContainerKey.length; i++) {
						var oSpreadStatement = aoSpreadStatementContainer[asSpreadStatementContainerKey[i]];
						oSpreadStatement.setSelectedYears(aiYears);
					 }
				},
			_that.setSelectedYears = function(aiYears) {
				_that.selectYearsForAll(aiYears);
			}
			_that.initTableNext = function () {
				_that.initTable();
			},
			_that.setRecordCounter = function(iCounter) {
					iRecordCounter = iCounter;
					iPrevRecordCounter = iCounter - 1;
				},
			_that.setGroupCounter = function (iCounter) {
				iGroupCounter = iCounter;
				iPrevGroupCounter = iCounter - 1;
			},
			_that.addNewPeriodProxy = function(sYears) {
				aiSelectedYears = [].concat(sYears);
				_that.getRemoteData();
			},
			_that.showHideRecordInGrandTotal = function(recordName, show){
				var grandTotalSpreadStatement = _.find(aoSpreadStatementContainer, function(oSpreadStatement){
					if(oSpreadStatement.bIsTotalsGrid){
						return oSpreadStatement;
					}
				});
				
				if(typeof grandTotalSpreadStatement != 'undefined'){
					grandTotalSpreadStatement.showHideRecordWithName(recordName, show);
				}
			},
			_that.notifyLinkedSourceUpdated = function(updatedObj){
				for(var i = 0; i < asSpreadStatementContainerKey.length; i++){
					var oSpreadStatement = aoSpreadStatementContainer[asSpreadStatementContainerKey[i]];
					if(typeof oSpreadStatement != 'undefined'){
						oSpreadStatement.updateLinkedRecords(updatedObj, {});
					}
				}
			},
			_that.performRecordUpdate = function(bUpdateTotalColumns, obj){
					var success = function(){};
					if(bUpdateTotalColumns){
						success = function(obj, asSpreadStatementContainerKey, aoSpreadStatementContainer){

							try{
								for ( var i = 0; i < asSpreadStatementContainerKey.length; i++) {
									var oSpreadStatement = aoSpreadStatementContainer[asSpreadStatementContainerKey[i]];
									if(oSpreadStatement.bIsTotalsGrid) {
										for(var p=0;p<obj.groupTotal.length;p++){
												oSpreadStatement.editGroupData(
													obj.groupTotal[p].name,
													obj.groupTotal[p].year,
													obj.groupTotal[p].quarter,
													obj.groupTotal[p].val.toString(),
													obj);
										}
										for(var p=0;p<obj.periodTotal.length;p++){
											oSpreadStatement.editPeriodData(
													obj.periodTotal[p].name,
													obj.periodTotal[p].periodId,
													obj.periodTotal[p].val.toString(),
													obj);
										}
									}
								}
								//_that.performRecordUpdate(false, obj);
							}
							catch(error){
								console.log('error');
								console.log(error);
								console.log(error.stack);
							}
							finally{}
						};
					}
				success.apply(
					this, [
						obj,
						asSpreadStatementContainerKey,
						aoSpreadStatementContainer]);
				LifeCycle.Spreads.updateRecordCells(
						obj,
						asSpreadStatementContainerKey,
						aoSpreadStatementContainer,
						function(){},
						_that.handleRemoteError);
			},
			_that.getYears = function(aiAllowedYears){
				return aiAllowedYears;
			},
			_that.readSelectedYears = function(aiAllowedYears){
				var sCookie = jQuery.cookie(recordId+'_spreads_selected_years');
				if(sCookie == null){
					return [];
				}
				var toRet = [];
				var sYears = jQuery.parseJSON(sCookie);
				for(var g=0;g<sYears.length;g++){
					var iYear =  0 + sYears[g];
					if(aiAllowedYears.indexOf(iYear) >= 0){
						toRet.push(iYear);
					}
					
				}
				return toRet;
			},
			_that.handleRemoteError = function(result){
				console.log('error');
				console.log(result);
			},
			_that.getRemoteData = function(){
				_that.resetVars();
				LifeCycle.SpreadsService.retrieveIForce({}, recordId,
					function(iForce){
						sTotalRowName = SpreadStatement.parseRecordsFromIForceObjects(iForce, aoRecords, asColumnIds, asRowIds, _that.aiSelectedYears, sourceRecordIdMap);
						LifeCycle.SpreadsService.retrieveIForces({}, asRowIds,
							function(iForces){
								SpreadStatement.mergeRecordValuesIntoIForce(aoRecords, asColumnIds, iForces);
								_that.initTable();
								if (_that.filtering){
									SpreadStatement.hideSearch(nAttachTo);
								}
							},
							_that.handleRemoteError
						);
					},
					_that.handleRemoteError
				);
			},
			_that.setupLinkedRecords = function(aoTargetRecord, sourceRecordId, period_over_period_change, callback){
				var targetSpreadStatement;
				var aoSourceRecord = [];
				var targetRecordId = aoTargetRecord[0]['record']['id'];
				var targetRecordTotalId = aoTargetRecord[0]['record']['total_group_id'];

				for ( var i = 0; i < asSpreadStatementContainerKey.length; i++){
					var recordTotalId = asSpreadStatementContainerKey[i];
					var oSpreadStatement = aoSpreadStatementContainer[recordTotalId];

					if(recordTotalId == targetRecordTotalId){
						targetSpreadStatement = oSpreadStatement;
					}
					if(aoSourceRecord.length == 0){
						aoSourceRecord = oSpreadStatement.findRecord(sourceRecordId);
					}else if (targetSpreadStatement != undefined){
						break;
					}
				}

				if(_.isUndefined(sourceRecordIdMap[sourceRecordId])){
					sourceRecordIdMap[sourceRecordId] = [];
				}
				if(!_.contains(sourceRecordIdMap[sourceRecordId], targetRecordId)){
					sourceRecordIdMap[sourceRecordId].push(targetRecordId);
				}

				if(!_.isUndefined(targetSpreadStatement) && aoSourceRecord.length == 0){
					if(_.contains(asSpreadStatementContainerKey, sourceRecordId)){
						var sourceSpreadStatement = aoSpreadStatementContainer[sourceRecordId];
						aoSourceRecord = sourceSpreadStatement.getColumnTotals();
					}else{
						targetSpreadStatement.getLinkedRecords(true, function(){});
					}
				}

				if(aoSourceRecord.length > 0 ){
					targetSpreadStatement.insertLinkedRecordObjectsIntoDataMap(
						aoTargetRecord,
						aoSourceRecord,
						period_over_period_change);
				}
				callback.apply([]);
			},
			_that.getRemoteTotals = function(){
				LifeCycle.Spreads.getRemoteTotals.apply(
					_that,
					[recordId,
					_that.aiSelectedYears,
					function(){
						LifeCycle.unblockUI();
					},
					_that.handleRemoteError]);
			},
			_that.getStatementLinkedRecordValues = function(bIgnoreCache, callback){
				if(_that.statementLinkedRecords == null || bIgnoreCache){
					LifeCycle.Spreads.getLinkedRecordValues(recordId, false, _that.aiSelectedYears, function(result){
						_that.statementLinkedRecords = result;
						callback.apply(this, [_that.statementLinkedRecords]);
					});
				}else{
					callback.apply(this, [_that.statementLinkedRecords]);
				}
			},
			_that.getStatementLinkedRecordGroups = function(bIgnoreCache, callback){
				if(_that.statementLinkedRecordGroups == null || bIgnoreCache){
					LifeCycle.Spreads.getLinkedRecordGroups(recordId, false, _that.aiSelectedYears, function(result){
						_that.statementLinkedRecordGroups = result;
						callback.apply(this, [_that.statementLinkedRecordGroups]);
					});
				}else{
					callback.apply(this, [_that.statementLinkedRecordGroups]);
				}
			},
			_that.getLinkableFields = function(statementId, callback){
				LifeCycle.Spreads.retrieveUnderwritingEntities(
					ko.mapping.toJS(window.LifeCycle.RegistrationApp.viewModel.UNDERWRITING_GLOBAL.section.lifeCycleLoan()),
					function(entities){
						callback.apply(_that, [entities]);
					}
				);
			};
			return _that;
		}
		app.setMapping({
			'spreadStatement': {
				create: function(options){
					return new app.SpreadStatement(options.data);
				}
			},
			'underwritingEntities': {
				create: function(options){
					return new app.UnderwritingEntity(options.data);
				}
			},
			'section': {
				create: function(options){
					return new app.Section(options.data);
				}
			}
		});
		app.setTypesMap({
			'LifeCycleSpreadStatement': 'spreadStatement'
		});
		app.log('Underwriting Models initialized.');
	};
	if(LifeCycle.UnderwritingGlobal == undefined){
		LifeCycle.UnderwritingGlobal = {};
	}
	if(LifeCycle.UnderwritingGlobal.Models == undefined){
		LifeCycle.UnderwritingGlobal.Models = Models;
	}
})(LifeCycle.RegistrationApp);

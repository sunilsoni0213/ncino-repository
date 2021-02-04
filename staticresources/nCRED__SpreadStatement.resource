function SpreadStatement(oInit) {

	var FINANCIAL_GROUP = 'Financial';
	var DECIMAL_GROUP = 'Decimal';
	var PERCENTAGE_GROUP = 'Percentage';

	// public variables
	this.bInitialized = false;
	this.bIsSummaryGroup = false;
	this.bHideColumnTotals = false;
	this.oInit = oInit;
	
	// public functions
	this.reset = reset;
	this.setSelectedYears = _fnSetSelectedYears;
	this.getSelectedYears = _fnGetSelectedYears;
	this.editPeriodData = _fnEditPeriodData;
	this.recalculateTotal = _fnRecalculateTotal;
	this.setGetLinkedFieldsFunction = _fnSetLinkedFieldsFunction;
	this.showHideRecordWithName = _fnShowHideRecordWithName;
	this.updateLinkedRecords = _fnUpdateLinkedRecords;
	this.findRecord = _fnFindRecord;
	this.insertLinkedRecordObjectsIntoDataMap = _fnInsertLinkedRecordObjectsIntoDataMap;
	this.getLinkedRecords = _fnGetLinkedRecords;
	this.showHideColumns = _fnShowHideColumns;
	this.getValidTrendCols = _fnGetValidTrendCols;
	this.getValidNOIStatementOperatingExpensesCols = _fnGetValidNOIStatementOperatingExpensesCols;
	this.updateSelectedColumns = _fnUpdateSelectedColumns;
	this.getCategorizedCols = _fnCategorizeColumnsGlobal;
	this.getCategorizedColsByYear = _fnCategorizeColumnsByYear;
	this.modifyYears = _fnModifyYears;
	this.getColumnTotals = _fnGetColumnTotals;
	this.reDraw = _fnReDraw;
	this.findPositionFromTD = _fnFindPositionFromTD;
	this.getNodes = _fnGetNodes;
	this.editTableCell = _fnEditTableCell;
	this.recalculateDebtService = _fnRecalculateDebtService;
	this.bIsNOIStatementOperatingExpenses = false;
	this.sRecordTotalId = null;
	this.fireEvents = _fnFireEvents;
	this.editIcon = this.oInit.editIcon;

	// private variables

	var jQuery = null;
	if( typeof oInit.jQuery != 'undefined') {
		jQuery = oInit.jQuery;
	}

	var Haml = null;
	if( typeof oInit.haml != 'undefined') {
		Haml = oInit.haml;
	}

	var _that = null;
	var _oSheetTable = null;
	var _aoDataMap = null;
	var _anModifiedHeaders = [];
	var _anModifiedFooters = [];
	var _sTotalRowName = null;
	var _sAccountTitle = null;
	var _aoCategorizedCols = {};
	var _aoCategorizedColsByYear = {};
	var _nTable = null;
	var _nContainer = null;
	var _nAttachTo = null;
	var msgs = null;
	var _sStatementId = null;
	var _spreadControlWidgetClass = 'spread_control_widget';
	var _sSpreadControlWidgetTemplate = null;
	var _iFutureYears = 0;
	var _iPastYears = 0;
	var _aiCurrentYears = [];
	var _aiAllowedPeriod = {};
	var _linkedRecordValues = null;
	var _bCurrencyPeriodValues = false;
	var _bDisplayControlWidget = false;
	var _bSyncAllGrids = false;
	var _bUpdateTotalColumns = false;
	var _bConfigurable = true;
	var _bEditable = true;
	var _bColumnSourceEditable = false;
	var _bJQueryUI = false;
	var _iRecordCounter = 0;
	var _iGroupCounter = 0;
	var _sInteraction = 'keyboard';
	var _bGroupColumns = true;
	var _bDateAppColumns = true;
	var _bEnableExpansionArrows = false;
	var _bBalanceTotals = false;
	var _bHideAllRecords = false;
	var _bHideCurrencySymbol = false;
	var _sTotalGroupId = null;
	var _keys = null;
	var _typeOfStatement = null;
	var _bIsRatio = false;
	var _aoPeriods = null;
	var _fnAddSpreadStatementRecord = function(){};
	var _fnUpdateRemoteIncludeInTotal = function(){};
	var _fnGetSpreadStatementRecords = function(){};
	var _fnRegisterStatement = function(instance){};
	var _fnLinkSpreadRecord = function(){};
	var _fnSetupLinkedRecords = function(){};
	var _fnUpdateRemoteSpreadOperation = function(){};
	var _fnShowHideRecordInGrandTotal = function(){};
	var _fnNotifySourceRecordUpdated = function(){};
	var _fnNotifySourceRecordTotalUpdated = function(){};
	var _fnGetLinkedFields = function(){};
	var _fnGetTotalRecord = function(){};
	var _fnSaveIForceRecord = function(){};
	var _fnGetSourceRecordIdMap = function(){};
	var _fnGetDebtServiceRecordIdMap = function(){};
	var _bTotalOnly = false;
	var _unlinkRecords = function(){};
	var _bIsCommonSizingOptional = false;
	var _fnUpdateCommonSizingValue = function(){};
	var _bIsTrendOptional = false;
	var _fnUpdateTrendValue = function(){};
	var _bAccumulateRecordGroups = true;
	var _aoColumnTotals = [];
	var _datePickerApp = null;
	var _navApp = null;
	var _spreadConfigApp = null;
	var _fnInSourceRecordIdMap = function(){};
	var _fnSetSuppressReDraw = function(){};
	var _bIsChartOfAccountEditable = false;
	var _fnGetIForceVM = function(){};
	var _iCollateralNumberOfUnits = 0;
	var _eventQueue = {publish: [], subscribe: []};
	var _pgiColumnTotals;
	var _bForceRemap = false;
	/** @type LifeCycle.SpreadRenderingService */
	var renderingService = null;
	var _fnGetRemoteData = function() {return false;};
	
	window.drawTimer = null;
	window.drawOneTimer = null;
	window.isDrawingAll = false;
	
	var _fnInit = function (oInit, that, callback) {
		
		var self = this;
		if(_that != null) {
			_that.oInit = oInit;
		}
		_that = that;
		try {
			_anModifiedHeaders = [];
			_anModifiedFooters = [];
			_aoCategorizedCols = {};
			_aoCategorizedColsByYear = {};
			_aoUniqueRecords = [];

			var aoRecords = [];
			var asRowIds = [];
			if( typeof oInit == 'undefined') {
				oInit = {};
			}
			if(typeof oInit.fnGetIForceVM != 'undefined'){
				_fnGetIForceVM = oInit.fnGetIForceVM;
			}
			if(typeof oInit.getSourceRecordIdMap != 'undefined'){
				_fnGetSourceRecordIdMap = oInit.getSourceRecordIdMap;
			}
			if(typeof oInit.getDebtServiceRecordIdMap != 'undefined'){
				_fnGetDebtServiceRecordIdMap = oInit.getDebtServiceRecordIdMap;
			}
			if(typeof oInit.bAccumulateRecordGroups != 'undefined'){
				_bAccumulateRecordGroups = oInit.bAccumulateRecordGroups;
			}
			if(typeof oInit.isCommonSizingOptional){
				_bIsCommonSizingOptional = oInit.isCommonSizingOptional;
				_fnUpdateCommonSizingValue = oInit.updateCommonSizingValue;
			}
			if(typeof oInit.isTrendOptional){
				_bIsTrendOptional = oInit.isTrendOptional;
				_fnUpdateTrendValue = oInit.updateTrendValue;
			}
			if( typeof oInit.aoRecords != 'undefined') {
				oInit.aoRecords = Utils.cloneArray(oInit.aoRecords);
				aoRecords = oInit.aoRecords;
			}
			if( typeof oInit.aoPeriods != 'undefined') {
				_aoPeriods = oInit.aoPeriods;
			}
			if( typeof oInit.asRowIds != 'undefined') {
				oInit.asRowIds = Utils.cloneArray(oInit.asRowIds);
				asRowIds = oInit.asRowIds;
			}

			if( typeof oInit.msgs != 'undefined') {
				msgs = oInit.msgs;
			}

			if( typeof oInit.nTable != 'undefined') {
				_nTable = oInit.nTable;
				if(jQuery.fn.DataTable.fnIsDataTable(_nTable)){
					jQuery(_nTable).dataTable().fnDestroy();
					jQuery(_nTable).find('thead tr').remove();
					jQuery(_nTable).find('tfoot tr').remove();
				}
			} else {
				throw 'a table element must be specified';
			}
			
			if( typeof oInit.nContainer != 'undefined') {
				_nContainer = oInit.nContainer;
			} else {
				throw 'a container element must be specified';
			}
			if( typeof oInit.nAttachTo != 'undefined') {
				_nAttachTo = oInit.nAttachTo;
			} else {
				throw 'a parent container element must be specified';
			}			
			
			if( typeof oInit.sTotalRowName != 'undefined') {
				_sTotalRowName = oInit.sTotalRowName;
			}

			if( typeof oInit.sAccountTitle != 'undefined') {
				_sAccountTitle = oInit.sAccountTitle;
			}

			if( typeof oInit.addNewPeriod != 'undefined') {
				_fnAddNewPeriod = oInit.addNewPeriod;
			}
			if(typeof oInit.selectYearsForAll != 'undefined'){
				_fnSelectYearsForAll = oInit.selectYearsForAll; 
			}
			if(typeof oInit.incrementRecordCounter != 'undefined'){
				_fnIncrementRecordCounter = oInit.incrementRecordCounter; 
			}
			if(typeof oInit.incrementGroupCounter != 'undefined'){
				_fnIncrementGroupCounter = oInit.incrementGroupCounter; 
			}
			if( typeof oInit.iFutureYears != 'undefined') {
				_iFutureYears = oInit.iFutureYears;
			}
			if( typeof oInit.iPastYears != 'undefined') {
				_iPastYears = oInit.iPastYears;
			}
			if( typeof oInit.statementId != 'undefined') {
				_sStatementId = oInit.statementId;
			}
			if( typeof oInit.recordTotalId != 'undefined') {
				_that.sRecordTotalId = oInit.recordTotalId;
			}
			if( typeof oInit.bCurrencyPeriodValues != 'undefined') {
				_bCurrencyPeriodValues = oInit.bCurrencyPeriodValues;
			}
			if(typeof oInit.bIsChartOfAccountEditable != 'undefined'){
				_bIsChartOfAccountEditable = oInit.bIsChartOfAccountEditable;
			}
			if(typeof oInit.bDisplayControlWidget != 'undefined'){
				_bDisplayControlWidget = oInit.bDisplayControlWidget;
			}
			if(typeof oInit.bSyncAllGrids != 'undefined'){
				_bSyncAllGrids = oInit.bSyncAllGrids;
			}
			if(typeof oInit.bUpdateTotalColumns != 'undefined'){
				_bUpdateTotalColumns = oInit.bUpdateTotalColumns;
			}
			if(typeof oInit.bHideColumnTotals != 'undefined'){
				_that.bHideColumnTotals = oInit.bHideColumnTotals;
			}
			if(typeof oInit.bConfigurable != 'undefined'){
				_bConfigurable = oInit.bConfigurable;
			}
			if(typeof oInit.bEditable != 'undefined'){
				_bEditable = oInit.bEditable;
			}
			if(typeof oInit.bColumnSourceEditable != 'undefined'){
				_bColumnSourceEditable = oInit.bColumnSourceEditable;
			}
			if(typeof oInit.bJQueryUI != 'undefined'){
				_bJQueryUI = oInit.bJQueryUI;
			}
			if(typeof oInit.iRecordCounter != 'undefined'){
				_iRecordCounter = oInit.iRecordCounter;
			}
			if(typeof oInit.iGroupCounter != 'undefined'){
				_iGroupCounter = oInit.iGroupCounter;
			}
			if(typeof oInit.sInteraction != 'undefined'){
				_sInteraction = oInit.sInteraction;
			}
			if(typeof oInit.sSpreadControlWidgetTemplate != 'undefined'){
				_sSpreadControlWidgetTemplate = oInit.sSpreadControlWidgetTemplate;
			}
			if(typeof oInit.bGroupColumns != 'undefined'){
				_bGroupColumns = oInit.bGroupColumns;
			}
			if(typeof oInit.bDateAppColumns != 'undefined'){
				_bDateAppColumns = oInit.bDateAppColumns;
			}
			if(typeof oInit.bEnableExpansionArrows != 'undefined'){
				_bEnableExpansionArrows = oInit.bEnableExpansionArrows;
			}
			if(typeof oInit.bBalanceTotals != 'undefined'){
				_bBalanceTotals = oInit.bBalanceTotals;
			}
			if(typeof oInit.aiCurrentYears != 'undefined'){
				_aiCurrentYears = oInit.aiCurrentYears;
			}
			else{
				throw 'the years to be rendered must be specified';
			}
			if(typeof oInit.aiAllowedPeriod != 'undefined'){
				_aiAllowedPeriod = oInit.aiAllowedPeriod;
			}
			else{
				throw 'the years to be rendered must be specified';
			}
			if(typeof oInit.updateRecordCell != 'undefined'){
				_fnUpdateRecordCell = oInit.updateRecordCell;
			}
			if(typeof oInit.showHideRecordInGrandTotal != 'undefined'){
				_fnShowHideRecordInGrandTotal = oInit.showHideRecordInGrandTotal;
			}
			if(typeof oInit.notifySourceRecordUpdated != 'undefined'){
				_fnNotifySourceRecordUpdated = oInit.notifySourceRecordUpdated;
			}
			if(typeof oInit.notifySourceRecordTotalUpdated != 'undefined'){
				_fnNotifySourceRecordTotalUpdated = oInit.notifySourceRecordTotalUpdated;
			}
			if(typeof oInit.addSpreadStatementRecord != 'undefined'){
				_fnAddSpreadStatementRecord = oInit.addSpreadStatementRecord;
			}
			if(typeof oInit.updateIncludeInTotal != 'undefined'){
				_fnUpdateRemoteIncludeInTotal = oInit.updateIncludeInTotal;
			}
			if(typeof oInit.getSpreadStatementRecords != 'undefined'){
				_fnGetSpreadStatementRecords = oInit.getSpreadStatementRecords;
			}
			if(typeof oInit.registerStatement != 'undefined'){
				_fnRegisterStatement = oInit.registerStatement;
			}
			if(typeof oInit.linkSpreadRecord != 'undefined'){
				_fnLinkSpreadRecord = oInit.linkSpreadRecord;
			}
			if(typeof oInit.setupLinkedRecords != 'undefined'){
				_fnSetupLinkedRecords = oInit.setupLinkedRecords;
			}
			if(typeof oInit.unlinkRecords != 'undefined'){
				_fnUnlinkRecords = oInit.unlinkRecords;
			}
			if(typeof oInit.getLinkedFields != 'undefined'){
				_fnGetLinkedFields = oInit.getLinkedFields;
			}
			if(typeof oInit.updateSpreadOperation != 'undefined'){
				_fnUpdateRemoteSpreadOperation = oInit.updateSpreadOperation;
			}
			if(typeof oInit.config != 'undefined'){
				_bHideAllRecords = oInit.config.hideAllRecords;
				_bHideCurrencySymbol = oInit.config.hideCurrencySymbol;
				_sTotalGroupId = oInit.config.id;
			}
			if(typeof oInit.getTotalRecord != 'undefined'){
				_fnGetTotalRecord = oInit.getTotalRecord;
			}
			if(typeof oInit.saveIForceRecord != 'undefined'){
				_fnSaveIForceRecord = oInit.saveIForceRecord;
			}
			if(typeof oInit.bTotalOnly != 'undefined'){
				_bTotalOnly = oInit.bTotalOnly;
			}
			if(typeof oInit.datePickerApp != 'undefined'){
				_datePickerApp = oInit.datePickerApp;
			}
			if(typeof oInit.bForceRemap != 'undefined'){
				_bForceRemap = oInit.bForceRemap;
			}
			if(typeof oInit.navApp != 'undefined'){
				_navApp = oInit.navApp;

				// Bidirectional pubsub for SpreadStatement <-> Spread_Data parity
				_navApp.subscribe('SPREAD.Spreads.RecordValue_Updated', function (recordValueInfo) {
					if (!jQuery.contains(document.documentElement, _oSheetTable[0])) {
						return;
					}
					
					var targetRecordId = _18Id(recordValueInfo.recordId);
					var targetPeriodId = recordValueInfo.periodId;
					var newValue = recordValueInfo.value;

					var matchingValues = _fnFindRecord(targetRecordId);
					if (matchingValues) {
						for (var iCol = 0; iCol < matchingValues.length; iCol++) {
							if (matchingValues[iCol] === matchingValues[iCol + 1]) {
								continue;
							}
							var value = matchingValues[iCol];
							var recordType = value['record']['recordType'];
							var isStandardRecord = SpreadStatement.RecordType.isStandard(recordType);

							var periodType;
							if (value.period) {
								periodType = value['period']['periodType'];
							}
							
							var isStandardPeriod = SpreadStatement.RecordType.isStandard(periodType);

							// TODO: Remove restriction when Spread_Data should update any records
							var currentRecord = LifeCycle.SpreadData.lookupRecordById(targetRecordId);
							var currentPeriod = LifeCycle.SpreadData.lookupPeriodById(targetPeriodId);
							var matchingRecordValue = LifeCycle.SpreadData.lookupRecordValueByRecordAndPeriod(
								currentRecord,
								currentPeriod,
								false // lookup only
							);

							if (isStandardRecord && isStandardPeriod && matchingRecordValue && !ko.unwrap(matchingRecordValue.formula)) {
								return;
							}

							var iRow = _fnFindiRow(targetRecordId);

							if (value.calculated || value.isLinked) {
								// Can't update
								continue;
							}

							// All periods or specific period
							if (!targetPeriodId || _18Id(value.period.recordId) == _18Id(targetPeriodId)) {
								// Update via _editData
								_editData(iRow, iCol, newValue, undefined, undefined, undefined, true);
							}
						}
					}
				});
				
				_navApp.subscribe('SPREAD.Spreads.Scale_Updated', function (scale) {
					if (!jQuery.contains(document.documentElement, _oSheetTable[0])) {
						return;
					}
					_fnReDraw();
				});
				_navApp.subscribe('SPREAD.Spreads.Refresh_Statement', _fnReFreshPeriodData);
			}
			if(typeof oInit.spreadConfigApp != 'undefined'){
				_spreadConfigApp = oInit.spreadConfigApp;
			}
			if(typeof oInit.inSourceRecordIdMap != 'undefined'){
				_fnInSourceRecordIdMap = oInit.inSourceRecordIdMap;
			}
			if(typeof oInit.renderingService != 'undefined'){
				renderingService = oInit.renderingService;
			}
			if(typeof oInit.setSuppressReDraw != 'undefined'){
				_fnSetSuppressReDraw = oInit.setSuppressReDraw;
			}
			if(typeof oInit.getRemoteData != 'undefined'){
				_fnGetRemoteData = oInit.getRemoteData;
			}
			
			try{
				_fnVerifyRecordIntegrity(aoRecords);
			}
			catch(error){
				//_fnModifyYears(_aiCurrentYears, true);
				console.log('error');
				console.log(error);
				console.log('aoRecords');
				console.log(aoRecords);
				return;
			}

			_sortRecords(asRowIds, aoRecords);

			var aaData = _fnGenerateAaData(aoRecords, asRowIds, _aoPeriods, _aoUniqueRecords);
			
			if(_bIsCommonSizingOptional || _bIsTrendOptional){
				_fnInsertCalculatedColumns(aaData);
			}

			if(typeof oInit.typeOfStatement != 'undefined'){
				_typeOfStatement = oInit.typeOfStatement;
			}

			if(_typeOfStatement == 'NOI Statement'){
				_fnInsertNOIStatementOperatingExpensesCalculatedColumns(aaData);
				if(_sAccountTitle == 'Operating Expenses'){
					_that.bIsNOIStatementOperatingExpenses = true;
				}
			}
			_fnPadDataArray(aaData);
			
			_aoCategorizedCols = _fnCategorizeColumns(aaData);
			_aoDataMap = aaData;
			
			var aoColDefs = _fnGenerateColumnDefs(aaData, _aiAllowedPeriod, _bConfigurable, that.editIcon);

			_oSheetTable = _fnCreateDataTable(
				_nTable,
				_nAttachTo,
				_aoDataMap, 
				aoColDefs, 
				_aoCategorizedCols, 
				_anModifiedHeaders, 
				_anModifiedFooters, 
				_sTotalRowName,
				_sStatementId,
				_nContainer,
				_bDisplayControlWidget,
				_bJQueryUI,
				_sSpreadControlWidgetTemplate,
				_bGroupColumns,
				_bBalanceTotals,
				_aiAllowedPeriod,
				_bTotalOnly,
				_bConfigurable,
				_aoUniqueRecords,
				_bIsChartOfAccountEditable,
				_that.bIsNOIStatementOperatingExpenses,
				that.editIcon);

			_oSheetTable.fnFilterPeriods(
					_aoDataMap, 
					_aiCurrentYears, 
					_aoCategorizedCols,
					_bDisplayControlWidget,
					_bSyncAllGrids,
					false,
					_bGroupColumns,
					_bDateAppColumns,
					_bIsCommonSizingOptional,
					_that.bIsNOIStatementOperatingExpenses,
					_bIsTrendOptional,
					_that);

			if(typeof oInit.bIsSummaryGroup != 'undefined'){
				_that.bIsSummaryGroup = oInit.bIsSummaryGroup;
			}

			_that.bInitialized = true;
			
			if(_navApp != null){
				jQuery(_nTable).on("click", function(event, handler){
					if(!_navApp.viewModel.blockedUI()){
						var element = event.target;
						if(jQuery(element).is("td.spread_col")){
							_navApp.viewModel.tableId(jQuery(this).attr('id'));
							_navApp.viewModel.tableNode(element);
						}
					}
				});
			}

			if(_that.bIsNOIStatementOperatingExpenses){
				_spreadConfigApp.subscribe("SPREAD.Spreads.Rent_Roll.Collateral_Units", function(units){
					_iCollateralNumberOfUnits = units;
					_fnCalculatePerUnitOperatingExpenseValues();
					_that.reDraw();
				});

				_fnRegisterEvent(false, LifeCycle.Events.Spreads.PGI_Record_Total_Init, _fnCalculatePercentPGIValues);
				_fnRegisterEvent(false, LifeCycle.Events.Spreads.PGI_Record_Total_Update, _fnCalculatePercentPGIValues);
				_spreadConfigApp.publish("SPREAD.Spreads.Rent_Roll.Get_Collateral_Units", function(){});

			}

			if(_datePickerApp != null 
					&& _datePickerApp.viewModel != null
					&& _.isFunction(_datePickerApp.viewModel.setColumnCategoryByYear)){

				_datePickerApp.viewModel.setColumnCategoryByYear(_fnCategorizeColumnsByYear(), _bForceRemap, _that);

				if(_spreadConfigApp != null && _spreadConfigApp.viewModel != null
						&& _.isFunction(_spreadConfigApp.viewModel.hasPeriods)){
					
					_spreadConfigApp.viewModel.hasPeriods(true);
				}
			}

			_fnRegisterInitEvent(_aoDataMap);
			_fnRegisterUpdateEvent(_aoDataMap);

			if(_typeOfStatement == 'Ratios'){
				_bIsRatio = true;
			}

			if(!_.isUndefined(callback)){
				callback.apply();
			}
			
		}
		catch(ex) {
			console.log(ex);
			console.log(ex.stack);
			throw ex;
		}
		finally {
			_fnGetLinkedRecords(false, function(){
				_fnRegisterStatement(_that);
			});

			if(_datePickerApp != null &&
				_datePickerApp.viewModel != null &&
				_.isFunction(_datePickerApp.viewModel.refreshHeaderForAdditionalDataPoints)){

				_datePickerApp.viewModel.refreshHeaderForAdditionalDataPoints();
			}
		}
	};

	function _fnRecalculateDebtService(sRecordName, sPeriodId, sVal, spreadStatementCellUpdate, suppressTableUpdate){
		if(_that.bInitialized){
			var iRow = -1;
			var iCol = -1;

			outerForLoop:
			for(var i=0;i<_aoDataMap.length;i++){
				for(var j=1;j<_aoDataMap[i].length;j++){
					var oCol = _aoDataMap[i][j];
					if(sRecordName == oCol['record']['name']){
						if(oCol['period'] != null &&
							sPeriodId == oCol['period']['id']){
							iRow = i;
							iCol = j;
							break outerForLoop;
						}
					}
				}
			}

			if(iRow >= 0 && iCol >= 0){
				return _editData(iRow,iCol,sVal,null,spreadStatementCellUpdate,suppressTableUpdate, true);
			}
		}
	};

	function _fnGetLinkedRecords(bIgnoreCache, callback){
		_fnGetLinkedRecordValues(bIgnoreCache, function(){
			callback.apply([]);
		});
	};

	function _fnGetLinkedRecordValues(bIgnoreCache, callback){
		if(_linkedRecordValues == null || bIgnoreCache){
			_linkedRecordValues = {};
			SpreadStatement._getLinkedRecordValues(_sStatementId, false, _aiCurrentYears, function(result){
				_linkedRecordValues = _fnBuildLinkedRecordValues(result);
				_.each(_linkedRecordValues, function(periods, sourceRecordId){
					_.each(periods, function(linkedRecords, period){
						_.each(linkedRecords, function(linkedValue, linkedRecordId){
							_fnEditPeriodData(
									linkedValue['record']['name'],
									linkedValue['period']['id'],
									_fnCalculateLinkedRecordValue(
											linkedValue,
											linkedValue['linkedRecord'],
											periods),
									null,
									true);
						});
					});
				});
				_fnReDraw();
			});
		}
		callback.apply(this);
	};

	function _fnCreateDataTable(
		nTable, 
		nAttachTo,
		aaMap, 
		aoColDefs, 
		aoCategorizedCols, 
		anModifiedHeaders, 
		anModifiedFooters, 
		sTotalRowName,
		sStatementId,
		nContainer,
		bDisplayWidget,
		bJQueryUI,
		sSpreadControlWidgetTemplate,
		bGroupColumns,
		bBalanceTotals,
		aiAllowedPeriod,
		bTotalOnly,
		bConfigurable,
		_aoUniqueRecords,
		bIsChartOfAccountEditable,
		bIsNOIStatementOperatingExpenses,
		editIcon) {

		var aoColumns = [];
		for(var i=0;i<aoColDefs.length;i++){
			aoColumns.push({
				'sWidth' : aoColDefs[i]['sWidth']
			});
		}
		
		var oSheetTable = jQuery(nTable).dataTable({
			"bFilter": true, // always true to allow show/hide functionality
			"bStateSave" : false,
			"bScrollInfinite" : false,
			"bScrollCollapse" : true,
			"bJQueryUI" : bJQueryUI,
			"bAutoWidth" : false,
			"bPaginate" : false,
			"bRetrieve" : false,
			"bDestroy" : true,
			"bUseRendered" : false,
			"aoColumns": aoColumns,
			"aoColumnDefs" : aoColDefs,
			"bInfo": false,
			"bSort": false,
			"oLanguage": {
				"sSearch": '<i class="icon-search"></i>',
				"sZeroRecords": ""
			},
			"asStripeClasses": [],
			"fnDrawCallback" : function() {
				this.fnResizeTable(nContainer);
				if(!_that.bIsSummaryGroup) {
					var oOpts = {
						'tooltip' : null,
						'placeholder' : '',
						'indicator' : '', // TODO!
						'type' : 'text',
						'event' : 'navAppEditEvent',
						'onblur' : function(sVal){
							this.reset(sVal);
							var element = jQuery(this);
							element.html(_fnEditTableCell(this, sVal, {}));
							element.find(".action_item_in_cell_edit_formula").click(function () {
								jQuery(element).click().trigger('navAppEditEvent');
							});

							if (LifeCycle.SpreadData.FormulaService.isFormulaLike(sVal)) {
								if (!LifeCycle.SpreadData.FormulaService.isValidFormulaString(sVal)) {
									setTimeout(function () {
										element.addClass('error');
										element.click().trigger('navAppEditEvent');
										
										key.setScope('formula');
										_navApp.viewModel.blockedUI(true);
										
										element.tooltip('destroy').tooltip({
											'trigger': 'manual',
											'title': LifeCycle.msgs.msg_math_in_cell_invalid_formula,
											'container': 'body',
											'placement': 'right'}).tooltip('show');
									}, 0);
									return;
								} else {
									element.tooltip('destroy');
									key.setScope('nav');
									_navApp.viewModel.blockedUI(false);
								}
								
								return '';
							} else {
								element.tooltip('destroy');
								key.setScope('nav');
								_navApp.viewModel.blockedUI(false);
							}
							
							return sVal;
						},
						'select': true,
						'onreset' : function() {},
						'data': function (value, settings) {
							var element = jQuery(this);
							var aoRecord = _fnFindRecord(element.parent().attr('id'));
							var record = LifeCycle.SpreadData.lookupRecordById(aoRecord[0].record.id);

							var recordVal = _fnGetRecordVal(element);

							if(recordVal && recordVal.formula()){
								return recordVal.formula();
							}

							if(aoRecord[0]['record']['debit']){
								var displayRegex = /\((\d*\.\d*)\)/;
								var theValues = value.match(displayRegex);

								if(theValues != null && theValues[1] != null){
									value = Utils.getNumberFromCurrency(theValues[1]);
								}else{
									value = Utils.getNumberFromCurrency(value) * -1;
								}
							}else{
								value = Utils.getNumberFromCurrency(value);
							}

							value = LifeCycle.SpreadData.FormattingService.scaleValueForRecord(value, record);

							return value;
						}
					};
					
					jQuery.editable.types['text'].plugin = function (settings, _cell) {
						var cell = jQuery(_cell);
						var cellInput = cell.find('input');
						var row = cell.parent();
						
						var aoRecord = _fnFindRecord(row.attr('id'));
						if (_.isEmpty(aoRecord)) {
							return;
						}
						
						var record = LifeCycle.SpreadData.lookupRecordById(aoRecord[0].record.id);
						if (!record) {
							return;
						}
						
						function _cellCheck () {
							cell.tooltip('destroy');
							cell.find('input').removeClass('error');
							
							if (LifeCycle.SpreadData.FormulaService.isFormulaLike(cellInput.val())) {
								key.setScope('formula');
								
								if (!LifeCycle.SpreadData.FormulaService.isValidFormulaString(cellInput.val())) {
									cell.find('input').addClass('error');
								}
								
								if (LifeCycle.SpreadData.FormattingService.getScaleDivisorForRecord(record) > 1) {
									cell.tooltip({
										trigger: 'manual',
										title: LifeCycle.msgs.msg_spreads_scale_enabled_math_in_cell_reminder,
										placement: 'right',
										container: 'body'
									}).tooltip('show');
								}
							} else {
								key.setScope('nav');
							}
						}
						
						jQuery(document).on('keyup', function (e) {
							if (e.keyCode == 27) { // escape key maps to keycode `27`
								key.setScope('nav');
								_navApp.viewModel.blockedUI(false);
								jQuery(document).off('keyup', this);
								renderingService.render();
							}
						});
						
						_cellCheck(null);
						cellInput.on('input', _cellCheck);
						cellInput.on('blur', function () {
							cell.tooltip('destroy');
						});
					};
					jQuery(nTable).find("td").each(function(){
						var element = jQuery(this);
						if (!_bEditable && ( element.hasClass('spread_col') && !element.hasClass('disabled'))) {

							var recordVal = _fnGetRecordVal(element);

							if (recordVal && recordVal.formula()) {
								var pencil = jQuery(
									'<a href="javascript:void(0);">' +
									'<span class="action_item_in_cell_edit_formula cursor-pointer pull-right adjust_dor_fx" >' +
									'<span class="f">𝑓</span>'+
									'<span class="x">𝑥</span>' +
									'</span>' +
									'</a>'
								);

								element.append(pencil);

								element.tooltip({
									trigger: 'hover',
									placement: 'left',
									title: recordVal.formula(),
									container: 'body'
								});
							}
						}
						if (_bEditable && ( element.hasClass('spread_col') && !element.hasClass('disabled'))) {
							element.editable( function(sVal, jEditableSettings){
									this.reset(sVal);
									element.html(_fnEditTableCell(this, sVal, jEditableSettings));
							}, oOpts);

							var recordVal = _fnGetRecordVal(element);
							var pencilExists = element.find(".slds-icon").length > 0;
							var noErrorsOnCell = element.find(".error").length <= 0;

							if(recordVal && recordVal.formula()) {
								if (!pencilExists && noErrorsOnCell) {
									var pencil = jQuery(
										'<a href="javascript:void(0);">' +
										'<span class="action_item_in_cell_edit_formula cursor-pointer pull-right">' +
										'<img class="slds-icon" src=' + editIcon + ' />' +
										'</span>' +
										'</a>'
									);
									
									pencil.click(
										function () {
											jQuery(element).click().trigger('navAppEditEvent');
										}
									);
									
									element.append(pencil);
								}
								
								if (element.text() == LifeCycle.SpreadData.FormattingService.INSIGNIFICANT_VALUE_INDICATOR) {
									element.addClass('math_in_cell_scaling_warning');
									if (!element.find('i.math_in_cell_scaling_warning_icon').length) {
										element.prepend('<i class="fa fa-warning pull-left math_in_cell_scaling_warning_icon"></i>');
									}
									element.tooltip({
										trigger: 'hover',
										placement: 'left',
										title: LifeCycle.msgs.msg_spreads_scale_enabled_math_in_cell_warning,
										container: 'body'
									});
								} else {
									element.removeClass('math_in_cell_scaling_warning');
								}
							} else {
								element.removeClass('math_in_cell_scaling_warning');
								element.find('.action_item_in_cell_edit_formula').remove();
							}
						}
					});
				}
			},
			"fnInitComplete" : function() {
				var oTable = this;

				if(!bTotalOnly){
					var nActionElem = jQuery(nTable).find('th.spread_title');
					_fnBuildSpreadSelectWidget(nTable, sStatementId, nActionElem, oTable, bConfigurable, _aoUniqueRecords);
					_fnBuildFormulaHideControl(nActionElem, sStatementId, nAttachTo);
				}

				jQuery(window).resize(function() {
					oTable.fnResizeTable(nContainer);
				});

				_navApp.publish('LLC_BI.Comments.Consumer_Rendered');

			},
			"fnRowCallback" : function(nRow, aaData, iDataIndex) {
				var recordId = _fnGetRecordId(iDataIndex);
				var isLinkedRecord = false;
				var isProtected = false;
				var isReadOnly = false;

				jQuery(nRow).attr('id', recordId);
				
				var statement = LifeCycle.SpreadData.lookupStatementById(_sStatementId);

				var matchingCell;
				for(var i=0;i<_aoDataMap.length;i++){
					var aoRow = _aoDataMap[i];
					for(var k = 0; k < aoRow.length; k++) {
						var oRecord = aoRow[k];

						if (oRecord['record']['id'] && oRecord['record']['id'] == recordId) {
							matchingCell = oRecord;

							var recordType = oRecord['record']['recordType'];
							
							var periodLookupKey, period, periodType;
							var periodIsReadOnly = false;
							if (oRecord.period) {
								periodLookupKey = oRecord['period']['lookupKey'];
								period = LifeCycle.SpreadData.lookupPeriodByLookupKey(periodLookupKey, {array: statement.periods()});
								periodType = period.periodType();
								periodIsReadOnly = SpreadStatement.PeriodType.isReadOnly(periodType);
							}

							isProtected = SpreadStatement.RecordType.isProtected(recordType);
							isReadOnly = SpreadStatement.RecordType.isReadOnly(recordType);
							isLinkedRecord = oRecord['linkedRecord'];

							if (isLinkedRecord || isProtected) {
								jQuery(nRow).find('td.spread_title .title').addClass('disabled');
								jQuery(nRow).find('td.spread_title').siblings().addClass('disabled');
							}

							if(periodIsReadOnly){
								var filter = '[id^="' + periodLookupKey + '"]';
								jQuery(nRow).find('td.spread_title').siblings(filter).addClass('disabled');
							}

							if((oRecord.record.kpiType == msgs.msg_standard_kpi || oRecord.record.kpiType == msgs.msg_user_kpi) && k==0) {
								var rowTitle = jQuery(nRow.getElementsByClassName('title'));
								rowTitle.html('<u>' + rowTitle.html() + '</u>');
							}
						}
					}
				}

				var bShowLinkRecordAction = bConfigurable && !isProtected;

				if (!bTotalOnly) {
					var container = jQuery(nRow).find('td.spread_title');
					// add kpi toggle
					if (bShowLinkRecordAction && jQuery(nRow).find('.action_item_kpi').length == 0 && matchingCell.record.kpiType != msgs.msg_standard_kpi) {
						if (_spreadConfigApp.viewModel.statement.statementType() !=  msgs.msg_kpi && !self.bStaticPeriods) {
							container.append(jQuery(nAttachTo).find('div.toggle_kpi').html());
							_fnSetToggleKPIAction(nRow, recordId);
						}
					}
					// add link control
					if (bShowLinkRecordAction && jQuery(nRow).find('.action_item_link').length == 0) {
						container.append(jQuery(nAttachTo).find('div.add_new_link').html());
						_fnSetLinkAction(nRow, sStatementId, recordId);
					}
					if(bIsChartOfAccountEditable && jQuery(nRow).find('.action_item_edit').length == 0){
						container.append(jQuery(nAttachTo).find('div.edit_record').html());
						_fnSetEditRecordAction(nRow, sStatementId, recordId);
					}
					// add operation update control
					if (jQuery(nRow).find('.operations_menu').length == 0 && !isReadOnly) {
						container.find('.operation').after(
								jQuery(nAttachTo).find('div.operations_menu_container').html());
						if(bConfigurable){
							_fnSetUpdateOperationAction(nRow, sStatementId, recordId);
						}
					}
					if(_datePickerApp != null
							&& _datePickerApp.viewModel != null
							&& _datePickerApp.viewModel.showOperations()){

						container.find('.action_item_link').show();
						container.find('.action_item_edit').show();
						container.find('.operation').show();
						container.find('.action_item_kpi').show();

					}
				}
			},
			"fnHeaderCallback" : function(nHead, aaData, iStart, iEnd, aiDisplay) {
				var iCols = aaData.length > 0 ? aaData[0].length : 0;
				var iIndex = 1;
				// ensure that all required headers are created
				for(var i = 1; i < iCols; i++) {
					if(this.fnIsColVisible(i)){
						var nActionElem = jQuery(nHead.getElementsByTagName('th')[iIndex]);
						var sHeaderText = '';
						var oRecord = aaMap[0][i];

						if(oRecord != null && oRecord['common_sizing'] == null && oRecord['trend'] == null) {
							if(oRecord['period'] != null) {
								sHeaderText = _fnConstructHeader(oRecord['period']);
							}
							_fnCreateHeaderElement(this, nHead, nActionElem, i, sHeaderText, aoCategorizedCols, oRecord);
						}
						iIndex++;
					}
				}
				if(_datePickerApp != null &&
					_datePickerApp.viewModel != null &&
					_.isFunction(_datePickerApp.viewModel.refreshHeaderForAdditionalDataPoints)){

					_datePickerApp.viewModel.refreshHeaderForAdditionalDataPoints();
				}
			},
			"fnFooterCallback" : function(nFoot, aaData, iStart, iEnd, aiDisplay) {
				if(_bIsRatio && _that.bIsSummaryGroup){
					jQuery(this).find('tfoot tr td').each(function(index, td){jQuery(td).html('');});
				}else{
					if(sTotalRowName != null && sTotalRowName.length > 0) {
						jQuery(this)[0].deleteTFoot();
						_fnRemoveAllFooterCustomizations();
						nFoot = jQuery(this)[0].createTFoot();
						var nRow = nFoot.insertRow(0);
						var iCols = aaData.length > 0 ? aaData[0].length : 0;
						var colsToUpdate = [];
						for(var i = iCols-1; i >= 0; i--) {
							if(this.fnIsColVisible(i)) {
								colsToUpdate.push(i);
								var nCell = nRow.insertCell(0);
									_fnRenderFooterContent(
											this,
											jQuery(nCell),
											i,
											aaData,
											aiDisplay,
											aaMap,
											aoCategorizedCols,
											bGroupColumns,
											bBalanceTotals,
											_bHideCurrencySymbol,
											nAttachTo);
									anModifiedFooters.push(jQuery(nCell));
							}
						}
					}
				}
			}
		});
		return oSheetTable;
	}

	function _fnSetEditRecordAction(nRow, sStatementId, recordId){
		jQuery(nRow).find('.action_item_edit').click(function(){
			_fnBuildEditChartOfAccountDialog(recordId);
		});
	}

	function _fnBuildEditChartOfAccountDialog(recordId){
		_vm = _fnGetIForceVM();
		LifeCycle.SpreadsService.retrieveIForce({}, recordId, function(record){
			_vm.load(record, 'edit_record');
			jQuery('#edit_record').modal('show');
		});
	}

	function _fnSetToggleKPIAction(nRow, recordId){
		jQuery(nRow).find('.action_item_kpi').click(function(){
			_fnToggleIncludeInKPI(recordId);
		});
	}

	function _fnToggleIncludeInKPI(recordId){
		LifeCycle.SpreadsService.retrieveIForce({}, recordId, function(record){
			if (!_.isUndefined(record.kpiType)){
				if (record.statement.isTemplate) {
					record.kpiType = (record.kpiType == msgs.msg_standard_kpi ? '' : msgs.msg_standard_kpi);
				} else {
					record.kpiType = (record.kpiType == msgs.msg_user_kpi ? '' : msgs.msg_user_kpi);
				}
				LifeCycle.SpreadsService.saveIForce(record, function(data){
					if (!_.isUndefined(data.kpiType)) {
						var rowTitle = jQuery('#' + data.recordId + ' .title:first');
						(data.kpiType == msgs.msg_user_kpi || data.kpiType == msgs.msg_standard_kpi) ? rowTitle.html('<u>' + rowTitle.html() + '</u>') : rowTitle.html(rowTitle.children().html());
					}
				});
			}
		});
	}

	function _fnSetLinkAction(nRow, sStatementId, recordId) {

		jQuery(nRow).find('.action_item_link').click(function(){

			_fnBuildOptionTreeDialog(
				sStatementId,
				recordId,
				_fnGetLinkedFields,
				_nAttachTo,
				nRow);
		});
	}
	function _fnBuildOptionTreeDialog(
		sStatementId,
		recordId,
		_fnGetLinkedFields,
		nAttachTo,
		nRow){

		var oTreeValues = {};

		var sDialog = sStatementId + '_link_dialog';
		var nDialog = '.' + sDialog;

		// retrieve linkable fields from backend
		LifeCycle.blockUI('300px');
		_fnGetLinkedFields(
			sStatementId,
			function(entities){
				oTreeValues = SpreadStatement.parseOptionTreeFromEntityValues(entities);

				var options = {
					show_multiple: 12,
					choose: ''
				};

				jQuery(nAttachTo).find('#link_record input[name="tree_select"]').optionTree(oTreeValues, options);


				jQuery(nAttachTo).find('#link_record').dialog({
					dialogClass: 'no-close ' + sDialog,
					position: { my: 'center', at: 'center' },
					resizable: false,
					draggable: false,
					title: msgs.msg_spreads_link_record,
					width: 900,
					height: 400
				});

				_fnBindOptionTreeActions(nRow, sStatementId, recordId, nDialog, nAttachTo);
				LifeCycle.unblockUI();
			}
		);
	}

	function _fnBindOptionTreeActions(nRow, sStatementId, recordId, nDialog, nAttachTo) {
		jQuery(nDialog).find('input[name="tree_select"]').change(function() {
			_fnDisplayLinkSelection(nDialog);
		});
		jQuery(nDialog).find('#link_record input[name="cancel"]').unbind();
		jQuery(nDialog).find('#link_record input[name="cancel"]').one('click', function() {
			_fnResetOptionTree(nDialog, nAttachTo);
		});
		jQuery(nDialog).find('#link_record input[name="link"]').unbind();
		jQuery(nDialog).find('#link_record input[name="link"]').one('click', function() {
			_fnPerformLinkAction(nRow, sStatementId, recordId, nDialog, nAttachTo);
		});
		jQuery(nDialog).find('#link_record input[name="unlink"]').unbind();
		jQuery(nDialog).find('#link_record input[name="unlink"]').one('click', function() {
			_fnPerformUnlinkAction(nRow, sStatementId, recordId, nDialog, nAttachTo);
		});
	}

	function _fnPerformLinkAction(nRow, sStatementId, targetRecordId, nDialog, nAttachTo){
		var sourceRecordId = jQuery(nDialog).find('#link_record input[name="tree_select"]').val();
		var period_over_period_change;
		var prior_fiscal_year;
		var linked_record_type = jQuery(nDialog).find('#linked_record_type').val();

		switch(linked_record_type) {
			case msgs.msg_period_over_period_change:
				period_over_period_change = true;
				prior_fiscal_year = false;
				break;
			case msgs.msg_prior_fiscal_year:
				period_over_period_change = false;
				prior_fiscal_year = true;
				break;
			default:
				period_over_period_change = false;
				prior_fiscal_year = false;
				break;
		}

		_fnSetSuppressReDraw(false);
		_fnLinkSpreadRecord(
			sStatementId,
			targetRecordId,
			sourceRecordId,
			period_over_period_change,
			prior_fiscal_year,
			function(result){
				LifeCycle.SpreadData.loadIForceById(targetRecordId, {}, function () {
					_fnGetRemoteData(true, false, function () {
						Utils.unblockUI();
					});
				});
			},
			SpreadStatement.handleError
		);
		_fnResetOptionTree(nDialog, nAttachTo);
	}

	function _fnDestroyEditableDataTable(nRow) {
		jQuery(nRow).find('td').each(function() {
			jQuery(this).editable('destroy');
		});
	}

	function _fnFindRecord(recordId){
		var aoRecords = [];
		var iRow = _fnFindiRow(recordId);
		if(!_.isUndefined(iRow)){
			return _aoDataMap[iRow];
		}else{
			return [];
		}
	};

	function _fnGetNodes(){
		return _oSheetTable.fnGetNodes();
	};

	function _fnGetNodeByRecordAndPeriod(record, period) {
		return jQuery('#' + period.lookupKey() + '_' + record.recordId());
	};

	function _fnFindPositionFromTD(nNode){
		return _oSheetTable.fnGetPosition(nNode);
	};

	function _fnPerformUnlinkAction(nRow, sStatementId, recordId, nDialog, nAttachTo){
		_fnLinkSpreadRecord(
			sStatementId,
			recordId,
			null,
			null,
			null,
			function(result){
				var aoRow = _fnFindRecord(recordId);
				for(var k = 0; k < aoRow.length; k++) {
					var oRecord = aoRow[k];
					if(oRecord['period'] && oRecord['period']['id'] && oRecord['record']['id'] == recordId){
						delete oRecord['linkedRecord'];
						oRecord['isLinked'] = false;
						if(oRecord['value'] != null){
							_fnEditPeriodData(
								oRecord['record']['name'],
								oRecord['period']['id'],
								null,
								undefined,
								false
							);
						}
					}
				}

				_fnUnlinkRecords(recordId);

				_fnGetLinkedRecords(true, function(){
					jQuery(nRow).find('td').removeClass('disabled');
					jQuery(nRow).find('td.spread_title .title').removeClass('disabled');
				});
			},
			SpreadStatement.handleError
		);

		_fnResetOptionTree(nDialog, nAttachTo);
	}

	function _fnResetOptionTree(nDialog, nAttachTo) {
		jQuery(nDialog).find('#linked_result').hide();
		jQuery(nDialog).find('#link_record select[name="tree_select____"]').remove();
		jQuery(nDialog).find('#link_record select[name="tree_select___"]').remove();
		jQuery(nDialog).find('#link_record select[name="tree_select__"]').remove();
		jQuery(nDialog).find('#link_record select[name="tree_select_"]').prop('selectedIndex',0);
		jQuery(nDialog).find('#link_record input[name="tree_select"]').val('');
		jQuery(nDialog).find('#link_record input[name="link"]').attr('disabled', 'disabled');
		// jquery dialog has removed our html from nAttach to, so add it back
		jQuery(nAttachTo).find('.option_tree_container').html(jQuery(nDialog).html());
		jQuery(nDialog).find('#link_record').dialog('destroy');
	}

	function _fnDisplayLinkSelection(nDialog) {
		jQuery(nDialog).find('#linked_result').hide();
		var selectedVal = jQuery(nDialog).find('#link_record input[name="tree_select"]').val();
		var selectedName = jQuery(nDialog).find('#link_record select[name="tree_select____"] option:selected').text();
		jQuery(nDialog).find('#link_selected').text(msgs.msg_spreads_link_selected_record + ' ' + selectedName);
		jQuery(nDialog).find('#link_record input[name="link"]').removeAttr('disabled');
		jQuery(nDialog).find('#linked_result').show();

	}

	function _fnSetUpdateOperationAction(
		nRow,
		sStatementId,
		recordId) {

		jQuery(nRow).find('.operation').click(function() {
			jQuery('.operations_menu').hide();
			jQuery(nRow).find('.operations_menu').show();
		});
		jQuery(document).click(function(e) {
			if(!jQuery(e.target).is('.operations_menu') &&
				!jQuery(e.target).parents().is('.operations_menu') &&
				!jQuery(e.target).is('.operation')) {
				jQuery(nRow).find('.operations_menu').hide();
			}
		});
		jQuery(nRow).find('.operations_menu li').click(function() {
			var operation = jQuery(this).find('input[name="operation"]').val();
			_fnUpdateSpreadOperation(sStatementId, recordId, operation);
		});
	}

	function _fnFindiRow(recordId){
		var iRow;
		for(var i=0;i<_aoDataMap.length;i++){
			var oCol = _aoDataMap[i][0];
			if(oCol['record']['id'] != null && oCol['record']['id'] == recordId) {
				iRow = i;
				break;
			}
		}
		return iRow;
	}

	function _fnUpdateSpreadOperation(sStatementId, recordId, operation) {
		var aiUpdatedCols = [];
		var iRow = _fnFindiRow(recordId);
		var aoRecord = _aoDataMap[iRow];
		var aiCol = [].concat(
					_aoCategorizedCols['months'],
					_aoCategorizedCols['quarters'],
					_aoCategorizedCols['years']
		);
		_.each(aiCol, function(iCol){

			var oCol = aoRecord[iCol];
			if(oCol['record']['id'] != null && oCol['record']['id'] == recordId) {
				oCol['record']['operation'] = operation;

				if(operation.toLowerCase() == msgs.msg_add.toLowerCase()){
					oCol['record']['operation_add'] = true;
				} else {
					oCol['record']['operation_add'] = false;
				}
				if(operation.toLowerCase() == msgs.msg_subtract.toLowerCase()){
					oCol['record']['operation_subtract'] = true;
				} else {
					oCol['record']['operation_subtract'] = false;
				}
				if(operation.toLowerCase() == msgs.msg_multiply.toLowerCase()){
					oCol['record']['operation_multiply'] = true;
				} else {
					oCol['record']['operation_multiply'] = false;
				}
				if(operation.toLowerCase() == msgs.msg_divide.toLowerCase()){
					oCol['record']['operation_divide'] = true;
				} else {
					oCol['record']['operation_divide'] = false;
				}
			}
			aiUpdatedCols.push(iCol);
		});

		_oSheetTable.fnUpdate(_aoDataMap[iRow], iRow, true, true);

		_fnUpdateRemoteSpreadOperation(
			sStatementId,
			recordId,
			operation,
			function() {},
			SpreadStatement.handleError);

		var spreadStatementCellUpdate = _fnCalculateGroupTotals(
				_oSheetTable,
				_aoDataMap,
				aiUpdatedCols,
				true,
				true,
				_sAccountTitle);

		_fnSetSuppressReDraw(false);
		_fnUpdateRecordCell(true, spreadStatementCellUpdate);
	}

	function _fnGetColumnTotals(){
		_aoColumnTotals = [];
		var aiCol = [];
		aiCol = aiCol.concat(
			_aoCategorizedCols['months'],
			_aoCategorizedCols['quarters'],
			_aoCategorizedCols['years']
		);
		var iCols = _aoDataMap.length > 0 ? _aoDataMap[0].length : 0;
		var colsToUpdate = [];
		_.each(aiCol, function(iCol){
			var aoRecordValue = jQuery.extend(true, {}, _aoDataMap[0][iCol]);
			// record.id is used to update linked records when this value is updated.
			aoRecordValue['record']['id'] = aoRecordValue['record']['total_group_id'];
			var iColTotal = _oSheetTable.fnGetColumnTotal(iCol, _aoDataMap);
			if(!_.isUndefined(aoRecordValue['period'])){
				aoRecordValue['value'] = iColTotal;
			}

			_aoColumnTotals[iCol] = aoRecordValue;

		});

		return _aoColumnTotals;

	}

	function _fnReDraw(){
		/**
		 * @type ISpreadsTableUpdate
		 */
		var tableUpdate = {
			table: _oSheetTable,
			data: _aoDataMap
		};
		renderingService.requestRedraw(tableUpdate);
	}

	function _fnCalculateGroupTotals(
		oTable,
		aaMap,
		aiCols,
		bVisiblesOnly,
		bUpdateTotalColumns,
		sAccountTitle,
		spreadStatementCellUpdate){

		if(_.isUndefined(spreadStatementCellUpdate)){

			var spreadStatementCellUpdate = {
					recordPeriods : [],
					groups : [],
					periodTotal : [],
					groupTotal : []
			};

		}

		// remove common sizing columns if they are present, they are not sent to the server
		aiCols = _.difference(aiCols, _aoCategorizedCols['common_sizing']);
		aiCols = _.difference(aiCols, _aoCategorizedCols['trend']);

		for(var g=0;g<aiCols.length;g++){
			var iCol = aiCols[g];
			if(!bVisiblesOnly || (bVisiblesOnly && oTable.fnIsColVisible(iCol))){
				var aiDisplayableRows = _fnGetVisibleRows();
				for(var j = 0; j < aiDisplayableRows.length; j++) {
					var iRow = aiDisplayableRows[j];
					var oColData = aaMap[iRow][iCol];
					var columnTotal = oTable.fnGetColumnTotal(iCol, aaMap);
					if(!isNaN(columnTotal)){
						var aoColumnTotalRecord = {
							record: { id: oColData['record']['total_group_id'] },
							period: oColData['period'],
							value: columnTotal
						};
						
						// Cache updater
						var columnRecord = oColData.record;
						var columnTotalRecordId = columnRecord.total_group_id;
						
						// Check to see if total is linked to SpreadData
						var allRecordTotals = SpreadStatement.aRecordTotals;
						for (var i = 0; i < allRecordTotals.length; i++) {
							var recordTotal = allRecordTotals[i];
							if (columnTotalRecordId == recordTotal.recordId()) {
								
								LifeCycle.SpreadData.updatePeriodTotalToValue(
									recordTotal.recordId(),
									aoColumnTotalRecord.period.recordId,
									columnTotal
								);
							}
						}
						
						_fnNotifySourceRecordTotalUpdated( aoColumnTotalRecord, iCol );
					}
					break;
				}
			}
		}
		return spreadStatementCellUpdate;
	}

	function _fnSetInitialSelectedYears(aiCurrentYears){
		for(var i=new Date().getFullYear();i>new Date().getFullYear()-2;i--){
			Utils.addToArrayIfNotExists(aiCurrentYears, i);
		}
	}

	function _fnGenerateAvailableYears(years) {
		var aoYears = [];
		for(var i=years.length-1;i>=0;i-- ) {
			var year = {
				value : years[i],
				selected : _aiCurrentYears.indexOf(years[i]) >= 0
			};
			aoYears.push(year);
		}
		return aoYears;
	}

	function _fnCreateFooterTdIfNotExist(nRow, i) {
		var elem = jQuery(nRow).find('#' + i);
		if(elem == null || elem.length == 0) {
			jQuery('<td>').appendTo(nRow);
			jQuery(nRow).find('td').last().attr('id',i);
			elem = jQuery(nRow).find('#' + i);
		}
		return elem;
	}

	function _fnRenderFooterContent(
			oTable,
			elem,
			iCol,
			aaData,
			aiDisplay,
			aaMap,
			aoCategorizedCols,
			bGroupColumns,
			bBalanceTotals,
			bHideCurrencySymbol,
			nAttachTo) {
		if(!_that.bHideColumnTotals){
			switch(iCol) {
				case 0:
					elem.html(_sTotalRowName).css({width: "10%"});
					elem.html(_sTotalRowName).attr('id', _that.sRecordTotalId);
					if (!self.bStaticPeriods) {
						elem.html('<span class="title">' + _sTotalRowName + "</span>").addClass(LifeCycle.msgs.msg_commentable_class);
					}
					if (_spreadConfigApp.viewModel.statement.statementType() !=  msgs.msg_kpi && !self.bStaticPeriods) {
						if (aaMap[0][0].record.total_kpiType != msgs.msg_standard_kpi)  {
							elem.append(jQuery(nAttachTo).find('div.toggle_kpi').html());
						}

						_fnSetToggleKPIAction(elem, elem[0].id);
						if (aaMap[0][0].record.total_kpiType == msgs.msg_standard_kpi || aaMap[0][0].record.total_kpiType == msgs.msg_user_kpi){
							rowTitle = jQuery(elem.children()[0]);
							rowTitle.html( '<u>' + rowTitle.html() + '</u>');
						}
					}
					break;
				default:
					var iColTotal = oTable.fnGetColumnTotal(iCol, aaMap);
					var recordTotal = LifeCycle.SpreadData.lookupRecordTotalById(_that.sRecordTotalId);
					var periodTotal;
					var groupType = aaMap[0][0].record.total_group_type;
					var html;
					var bTotalPercentageColumn = false;
					var bTotalCommonSizingColumn = false;
					var bTotalTrendColumn = false;
					var bTotalBlank = false;

					if(aoCategorizedCols['common_sizing'].indexOf(iCol) >= 0){
						elem.addClass("common_sizing_column");
						bTotalCommonSizingColumn = true;
						bTotalPercentageColumn = true;
					}
					if(aoCategorizedCols['trend'].indexOf(iCol) >= 0){
						elem.addClass("trend_column");
						bTotalTrendColumn = true;
						bTotalPercentageColumn = true;
					}
					if(aoCategorizedCols['per_unit_operating_expense'].indexOf(iCol) >= 0){
						elem.addClass("per_unit_operating_expense_column");
						bTotalBlank = true;
					}
					if(aoCategorizedCols['percent_pgi'].indexOf(iCol) >= 0){
						elem.addClass("percent_pgi");
						bTotalBlank = true;
					}
					
					if (bTotalTrendColumn || bTotalCommonSizingColumn) {
						var firstRow = aaMap[0];
						if (firstRow[iCol].trend || firstRow[iCol].common_sizing) {
							periodTotal = LifeCycle.SpreadData.lookupPeriodTotalByRecordTotalIdAndPeriodId(
								recordTotal.recordId(),
								firstRow[iCol].period.recordId
							);
						}
					}
					
					var formattedValue;
					if(elem.find('div') == null || elem.find('div').length == 0) {
						if (bTotalPercentageColumn) {
							if (bTotalCommonSizingColumn) {
								// Common Sizing
								formattedValue = LifeCycle.SpreadData.CommonSizingService.calculateAndFormatCommonSizingTotal(
									periodTotal
								);
							} else if (bTotalTrendColumn) {
								// Trend
								formattedValue = LifeCycle.SpreadData.TrendService.calculateAndFormatTrendTotal(
									periodTotal
								);
							}
							html = '<div><div class="total_percentage">' + formattedValue + '</div></div>';
						}
						else if (bTotalBlank) {
							html = '<div class="total_blank"></div>';
						} else {
							formattedValue = LifeCycle.SpreadData.FormattingService.formatPeriodTotal(iColTotal, recordTotal);
							
							var periodLookup = oTable._fnGetUniqueThs()[iCol].id;
							elem.attr('id', periodLookup + '_' + _that.sRecordTotalId);
							if (!self.bStaticPeriods){
								elem.addClass(LifeCycle.msgs.msg_commentable_class);
							}
							
							var className = 'total';
							if (groupType == FINANCIAL_GROUP) {
								className = 'spreads_currency total';
							}
							
							html = '<div><div class="' + className + '">' + formattedValue + '</div></div><div class="action"></div></div>';
							
						}
						elem[0].innerHTML = html;
					} else {
						formattedValue = LifeCycle.SpreadData.FormattingService.formatPeriodTotal(iColTotal, recordTotal);
						elem.find('.total')[0].innerHTML = formattedValue;
					}

					var sCategoryKey = 'months';
					if(aoCategorizedCols['years'].indexOf(iCol) >= 0
							|| aoCategorizedCols['quarters'].indexOf(iCol) >= 0) {
						if(aoCategorizedCols['years'].indexOf(iCol) >= 0) {
							sCategoryKey = 'years';
						} else if(aoCategorizedCols['quarters'].indexOf(iCol) >= 0) {
							sCategoryKey = 'quarters';
						}
					}
					if(bBalanceTotals){
						if((bGroupColumns && sCategoryKey != 'months') || (!bGroupColumns && sCategoryKey == 'months')){
							if(iColTotal != 0){
								_fnRenderUnbalancedTotal(oTable, elem.find('.action'), iCol, aoCategorizedCols);
							}
							else{
								_fnRenderBalancedTotal(oTable, elem.find('.action'), iCol, aoCategorizedCols);
							}
						}
					}
			}
		}
	}

	function _fnVerifyRecordIntegrity(aoRecords){
		for(var t = 0; t < aoRecords.length; t++) {
			if(aoRecords[t]['year_group'] == null ||
				aoRecords[t]['quarter_group'] == null){

				throw {
					message: 'group is null',
					object: aoRecords[t],
					index: t,
					records: aoRecords
				};
			}
		}
	}

	function _sortRecords(asRowIds, aoRecords){
		var aoRecs = [];

		for(var l=0;l<asRowIds.length;l++){
			var sRowId = asRowIds[l];
			for(var m=0;m<aoRecords.length;m++){
				if(aoRecords[m]['record'] != null &&
					aoRecords[m]['record']['id'] == sRowId){

					aoRecs.push(aoRecords[m]);
					break;
				}
			}
		}

		aoRecs.sort(function(a,b){return a['record']['row'] - b['record']['row'];});
		asRowIds.splice(0, asRowIds.length);

		for(var n=0;n<aoRecs.length;n++){
			asRowIds.push(aoRecs[n]['record']['id']);
		}
	}


	function _fnGenerateAaData(aoRecords, asRowIds, aoPeriods, _aoUniqueRecords) {
		var aaData = [];
		var asUniqueRecordKeys = [];
		for(var t = 0; t < aoRecords.length; t++) {
			var oRecordValue = aoRecords[t];
			var iRowId = asRowIds.indexOf(oRecordValue['record']['id']);
			var period = _.findWhere(aoPeriods, {lookupKey: oRecordValue['period']['id']});
			var aoRow = aaData[iRowId];
			if(aoRow == null) {
				aoRow = [];
			}
			aoRow[period.iCol] = oRecordValue;
			aaData[iRowId] = aoRow;
			if(!_.contains(asUniqueRecordKeys, oRecordValue['record']['id'])){
				_aoUniqueRecords.push(oRecordValue.record);
				asUniqueRecordKeys.push(oRecordValue['record']['id']);
			}
		}
		return aaData;
	}

	function _fnFindTrendChildCellInRow (rowData, trendCellColIndex, parentCell) {
		var futurePeriodId = parentCell.period.recordId;
		var futurePeriod = LifeCycle.SpreadData.lookupPeriodById(futurePeriodId);
		var pastPeriod = LifeCycle.SpreadData.TrendService.findPreviousTrendPeriodForPeriod(futurePeriod);
		
		if (!pastPeriod) {
			return null;
		} else {
			for (var i = trendCellColIndex - 1; i >= 0; i--) {
				var cell = rowData[i];
				if (_18Id(cell.period.recordId) == pastPeriod.recordId()) {
					return cell;
				}
			}
		}
	}

	function _fnInsertNOIStatementOperatingExpensesCalculatedColumns(aaData){
		for(var i = 0; i < aaData.length; i++){

			var numCalculatedColumns = 2;

			var aoRow = aaData[i];
			var aoNewRow = [];
			for(var k = 0; k < aoRow.length; k++){

				var oRecord = aoRow[k];
				var oCol;

				aoNewRow.push(oRecord);

				oCol = { year_group: oRecord['year_group'], record: oRecord['record'] };
				oCol['calculated'] = true;
				oCol['per_unit_operating_expense'] = {};
				oCol['per_unit_operating_expense']['source_col'] = aoNewRow.length;
				oCol['per_unit_operating_expense']['value'] = '';
				aoNewRow.push(oCol);

				oCol = { year_group: oRecord['year_group'], record: oRecord['record'] };
				oCol['calculated'] = true;
				oCol['percent_pgi'] = {};
				oCol['percent_pgi']['source_col'] = aoNewRow.length;
				oCol['percent_pgi']['value'] = '';
				aoNewRow.push(oCol);

			}

			aaData[i] = aoNewRow;

		}

	}

	function _fnInsertCalculatedColumns(aaData){
		for(var i = 0; i < aaData.length; i++){

			var numCalculatedColumns = 2;

			var aoRow = aaData[i];
			var aoNewRow = [];
			for(var k = 0; k < aoRow.length; k++){

				var oRecord = aoRow[k];
				var oCol;

				if (k > 0) {
					oCol = jQuery.extend(true, {}, oRecord);
					oCol.calculated = true;
					oCol.trend = {
						value: null,
						parentCell: oRecord,
						childCell: _fnFindTrendChildCellInRow(aoNewRow, aoNewRow.length, oRecord)
					};
					aoNewRow.push(oCol);

					var parentCell = oRecord;
					if (parentCell) {
						parentCell.parentTrendColIndex = aoNewRow.length;
					}

					var childCell = _fnFindTrendChildCellInRow(aoNewRow, aoNewRow.length, oRecord);
					if (childCell) {
						if (!childCell.childTrendColIndexes) {
							childCell.childTrendColIndexes = [];
						}

						childCell.childTrendColIndexes.push(aoNewRow.length);
					}
				}

				aoNewRow.push(oRecord);

				oCol = jQuery.extend(true, {}, oRecord);
				oCol['calculated'] = true;
				oCol['common_sizing'] = {};
				oCol['common_sizing']['source_col'] = aoNewRow.length;
				aoNewRow.push(oCol);

			}

			aaData[i] = aoNewRow;

		}
	}

	function _fnExtractValueFromNode(oRecordValue){
		if(oRecordValue['period'] != null){
			return oRecordValue['value'];
		}
	}

	/**
	 * adds 1 row to the front of every column
	 */
	function _fnPadDataArray(aaMap) {

		for(var j = 0; j < aaMap.length; j++) {
			if(aaMap[j].length > 0) {
				aaMap[j].unshift(aaMap[j][0]);
			}

		}
	}

	function _fnCategorizeColumnsByYear(disableShowHide){
		var categorizedByYear = {};
		for(var j = 1; j < _aoDataMap[0].length; j++) {
			var oRecord = _aoDataMap[0][j];

			var year = null;
			if(oRecord['year_group'] != null) {
				year = oRecord['year_group']['year'];
			}else{
				year = oRecord['quarter_group']['year'];
			}

			var currentYear = categorizedByYear[year];
			if(currentYear == null) {
				currentYear = {
					'columns': [],
					'year': year
				};
				categorizedByYear[year] = currentYear;
			}

			var aiCommonSizing = currentYear['common_sizing'];
			if(aiCommonSizing == null){
				aiCommonSizing = [];
				currentYear['common_sizing'] = aiCommonSizing;
			}
			var aiPerUnitOperatingExpense = currentYear['per_unit_operating_expense'];
			if(aiPerUnitOperatingExpense == null){
				aiPerUnitOperatingExpense = [];
				currentYear['per_unit_operating_expense'] = aiPerUnitOperatingExpense;
			}
			var aiPercentPGI = currentYear['percent_pgi'];
			if(aiPercentPGI == null){
				aiPercentPGI = [];
				currentYear['percent_pgi'] = aiPercentPGI;
			}
			var aiTrend = currentYear['trend'];
			if(aiTrend == null){
				aiTrend = [];
				currentYear['trend'] = aiTrend;
			}

			if(oRecord['per_unit_operating_expense'] != null){
				Utils.addToArrayIfNotExists(aiPerUnitOperatingExpense, {
					type: 'per_unit_operating_expense',
					'index': j,
					selected: _that.bIsNOIStatementOperatingExpenses
				});
			}
			if(oRecord['percent_pgi'] != null){
				Utils.addToArrayIfNotExists(aiPercentPGI, {
					type: 'percent_pgi',
					'index': j,
					selected: _that.bIsNOIStatementOperatingExpenses
				});
			}

			if(oRecord['common_sizing'] != null){
				Utils.addToArrayIfNotExists(aiCommonSizing, {
					'type' : 'common_sizing',
					'index': j
				});
			} else if(oRecord['trend'] != null){
				Utils.addToArrayIfNotExists(aiTrend, {
					'type' : 'trend',
					'index': j
				});
			} else if(oRecord['period'] != null && oRecord['period']['id'] != null) {
				oRecord['period']['index'] = j;
				Utils.addToArrayIfNotExists(currentYear['columns'], oRecord['period']);
				if (!disableShowHide) {
					_fnShowHideColumns([ oRecord['period']['index'] ], oRecord['period']['selected']
						&& (typeOfStatement != LifeCycle.msgs.msg_spread_noi_statement
						|| _datePickerApp == null
						|| _datePickerApp.viewModel == null
						|| oRecord['period']['year'] == _datePickerApp.viewModel.selectedYear()));
				}
			}
		}
		return categorizedByYear;
	}

	function _fnCategorizeColumnsGlobal () {
		return _fnCategorizeColumns(_aoDataMap);
	}
	function _fnGetValidNOIStatementOperatingExpensesCols (ignoreSelected) {
		var noiCols = [];
		for(var i = 0; i < _aoDataMap.length; i++) {
			for(var j = 1; j < _aoDataMap[i].length; j++) {// start at 1 since the first col is the record name
				var oRecord = _aoDataMap[i][j];
				if(oRecord['per_unit_operating_expense'] != null){
					Utils.addToArrayIfNotExists(noiCols, j);
				}
			}
		}
		return trendCols;
	}
	function _fnGetValidTrendCols (ignoreSelected) {
		var trendCols = [];
		for(var i = 0; i < _aoDataMap.length; i++) {
			for(var j = 1; j < _aoDataMap[i].length; j++) {// start at 1 since the first col is the record name
				var oRecord = _aoDataMap[i][j];

				if(oRecord['trend'] != null &&
					oRecord['trend']['parentCell'] != null &&
					oRecord['trend']['childCell'] != null &&
					(
						ignoreSelected ||
						(
							oRecord['trend']['parentCell']['period']['selected'] &&
							oRecord['trend']['childCell']['period']['selected']
						)
					)
				){
					Utils.addToArrayIfNotExists(trendCols, j);
				}
			}
		}
		return trendCols;
	}

	function _fnCategorizeColumns(aaData) {
		var aoNonGroupIndex = {};

		for(var i = 0; i < aaData.length; i++) {
			for(var j = 1; j < aaData[i].length; j++) {// start at 1 since the first col is the record name
				var oRecord = aaData[i][j];
				var aiYears = aoNonGroupIndex['years'];
				if(aiYears == null) {
					aiYears = [];
					aoNonGroupIndex['years'] = aiYears;
				}
				var aiQuarters = aoNonGroupIndex['quarters'];
				if(aiQuarters == null) {
					aiQuarters = [];
					aoNonGroupIndex['quarters'] = aiQuarters;
				}
				var aiMonths = aoNonGroupIndex['months'];
				if(aiMonths == null) {
					aiMonths = [];
					aoNonGroupIndex['months'] = aiMonths;
				}
				var aiCommonSizing = aoNonGroupIndex['common_sizing'];
				if(aiCommonSizing == null){
					aiCommonSizing = [];
					aoNonGroupIndex['common_sizing'] = aiCommonSizing;
				}
				var aiTrend = aoNonGroupIndex['trend'];
				if(aiTrend == null){
					aiTrend = [];
					aoNonGroupIndex['trend'] = aiTrend;
				}
				var aiPerUnitOperatingExpense = aoNonGroupIndex['per_unit_operating_expense'];
				if(aiPerUnitOperatingExpense == null){
					aiPerUnitOperatingExpense = [];
					aoNonGroupIndex['per_unit_operating_expense'] = aiPerUnitOperatingExpense;
				}
				var aiPercentPGI = aoNonGroupIndex['percent_pgi'];
				if(aiPercentPGI == null){
					aiPercentPGI = [];
					aoNonGroupIndex['percent_pgi'] = aiPercentPGI;
				}

				if(oRecord['common_sizing'] != null){
					Utils.addToArrayIfNotExists(aiCommonSizing, j);
				} else if(oRecord['trend'] != null){
					Utils.addToArrayIfNotExists(aiTrend, j);
				} else if(oRecord['period'] != null && oRecord['period']['id'] != null) {
					Utils.addToArrayIfNotExists(aiYears, j);
				} else if(oRecord['per_unit_operating_expense'] != null){
					Utils.addToArrayIfNotExists(aiPerUnitOperatingExpense, j);
				} else if(oRecord['percent_pgi'] != null){
					Utils.addToArrayIfNotExists(aiPercentPGI, j);
				}
			}
		}
		return aoNonGroupIndex;
	}

	function _fnGenerateColumnDefs(aaData, aiAllowedPeriod, bConfigurable, editIcon) {
		var aoColMap = {};
		var aoToReturn = [];

		var oCol = {
			"bSortable" : true,
			"sType" : "record-name",
			"sClass": 'spread_title',
			"sTitle" : _sAccountTitle,
			"sType" : 'label',
			"fnRender" : function(oObj, sVal) {
				var text = function(sVal){
					if(!sVal['dummy'] && sVal['record'] != null) {
						if(sVal['record']['debit']){
							return '(' + sVal['record']['name'] +')';
						}
						return sVal['record']['name'];
					}
					return '';
				}(sVal);
				var operation = function(sVal){
					if(!sVal['dummy'] && sVal['record'] != null) {
						if(sVal['record']['operation_add'] == true){
							return '+';
						}
						else if(sVal['record']['operation_subtract'] == true){
							return '-';
						}
						else if(sVal['record']['operation_multiply'] == true){
							return '*';
						}
						else if(sVal['record']['operation_divide'] == true){
							return '/';
						}
					}
					return '';
				}(sVal);
				var operationClass = 'operation';
				if(!bConfigurable){
					operationClass += ' disabled';
				}
				return '<span class="title">'+text+'</span><span class="'+operationClass+'">'+operation+'</span>';
			},
			"fnCreatedCell": function (nTd, sData, oData, iRow, iCol) {
				var element = jQuery(nTd);
				var relatedRecord = aaData[iRow][iCol];
				if (!self.bStaticPeriods) {
					element.addClass(LifeCycle.msgs.msg_commentable_class);
				}
				element.attr('id', relatedRecord['record']['id']);
			},
			"aTargets" : [0]
		};
		aoToReturn.push(oCol);

		var iColCount = 0;

		for(var k = 0; k < aaData.length; k++) {
			iColCount = aaData[k].length;
			for(var m = 1; m < iColCount; m++) {
				var oRecord = aaData[k][m];

				if(oRecord['common_sizing'] != null){

					oCol = {
						"bSortable" : false,
						"sTitle" : _fnConstructCommonSizingHeader(oRecord['common_sizing']),
						"sType": 'commonSizing',
						"sClass" : 'common_sizing_column',
						"fnRender" : function(oObj, sVal) {
							var recordValue = LifeCycle.SpreadData.lookupRecordValueByRecordIdAndPeriodId(
								sVal.record.id,
								sVal.period.recordId
							);
							return LifeCycle.SpreadData.CommonSizingService.calculateAndFormatCommonSizing(recordValue);
						},
						"aTargets" : [m]
					};

				} else if(oRecord['trend'] != null){

					oCol = {
						"bSortable" : false,
						"sTitle" : _fnConstructTrendHeader(oRecord['trend']),
						"sType": 'trend',
						"sClass" : 'trend_column',
						"fnRender" : function(oObj, sVal) {
							var recordValue = LifeCycle.SpreadData.lookupRecordValueByRecordIdAndPeriodId(
								sVal.record.id,
								sVal.period.recordId
							);
							return LifeCycle.SpreadData.TrendService.calculateAndFormatTrend(recordValue);
						},
						"aTargets" : [m]
					};

				} else if(oRecord['per_unit_operating_expense'] != null){

					oCol = {
						"bSortable" : false,
						"sTitle" : _fnConstructPerUnitOperatingExpenseHeader(oRecord['per_unit_operating_expense']),
						"sType": 'trend',
						"sClass" : 'trend_column',
						"fnRender" : function(oObj, sVal) {
							var oVal = sVal['per_unit_operating_expense'] != null ? sVal['per_unit_operating_expense'] : '';
							var displayValue = oVal['value'];
							if(sVal['record']['debit']){
								displayValue *= -1;
							}
							return _fnFormatCurrencyForDisplay(displayValue, 1, true);
						},
						"aTargets" : [m]
					};

				} else if(oRecord['percent_pgi'] != null){

					oCol = {
						"bSortable" : false,
						"sTitle" : _fnConstructPercentPGIHeader(oRecord['percent_pgi']),
						"sType": 'trend',
						"sClass" : 'trend_column',
						"fnRender" : function(oObj, sVal) {
							var oVal = sVal['percent_pgi'] != null ? sVal['percent_pgi'] : '';
							var displayValue = oVal['value'];
							if(sVal['record']['debit']){
								displayValue *= -1;
							}
							return _fnFormatPercentageForDisplay(displayValue);
						},
						"aTargets" : [m]
					};

				} else if(oRecord['name'] != null) {
					oCol = {
						"bSortable" : false,
						"sTitle" : _fnConstructHeader(oRecord['period']),
						"sClass" : 'colclass spread_col',
						"sType": 'recordValue',
						"fnRender" : function(oObj, sVal) {
							if(!sVal['dummy'] && sVal['value'] != null) {
								var record = LifeCycle.SpreadData.lookupRecordById(sVal.record.id);
								return LifeCycle.SpreadData.FormattingService.formatRecordValue(sVal.value, record);
							}
							return '';
						},
						"fnCreatedCell": function (nTd, sData, oData, iRow, iCol) {
							var element = jQuery(nTd);
							var relatedRecord = aaData[iRow][iCol];
							if (!self.bStaticPeriods) {
								element.addClass(LifeCycle.msgs.msg_commentable_class);
							}
							element.attr('id', relatedRecord['period']['id'] + '_' + relatedRecord['record']['id']);
						},
						"aTargets" : [m]
					};
				}

				if(aoToReturn[m] == null) {
					aoToReturn[m] = oCol;
				}
			}
		}
		return aoToReturn;
	}

	function _fnConstructCommonSizingHeader(oPeriod){
		return '<div class="common_sizing_header">' + msgs.msg_spread_common_sizing_header_title + '</div>';
	}

	function _fnConstructTrendHeader(oPeriod){
		return '<div class="trend_header">' + msgs.msg_spread_trend_header_title + '</div>';
	}

	function _fnConstructPerUnitOperatingExpenseHeader(oPeriod){
		return '<div class="per_unit_operating_expense_header">Per Unit</div>';
	}

	function _fnConstructPercentPGIHeader(oPeriod){
		return '<div class="percent_pgi_header">%PGI</div>';
	}

	function _fnConstructHeader(oPeriod) {
		if(oPeriod != null && oPeriod['nameOverride'] != null){
			return oPeriod['nameOverride'];
		}
		return '';
	}

	function _fnRemoveAllCustomizations() {
		// clear all customizations to the headers and footers
		_fnRemoveAllHeaderCustomizations();
		_fnRemoveAllFooterCustomizations();
	}

	function _fnRemoveAllFooterCustomizations() {
		for(var i = 0; i < _anModifiedFooters.length; i++) {
			_anModifiedFooters[i].remove();
		}
		if(_anModifiedFooters.length > 0) {
			_anModifiedFooters.splice(0, _anModifiedFooters.length);
		}
	}

	function _fnRemoveAllHeaderCustomizations() {
		for(var i = 0; i < _anModifiedHeaders.length; i++) {
			_fnRemoveAddPeriodRendering(_anModifiedHeaders[i]);
		}
		if(_anModifiedHeaders.length > 0) {
			_anModifiedHeaders.splice(0, _anModifiedHeaders.length);
		}
	}

	function _fnShowColumn(oTable, iCol, bRerender) {
		oTable.fnSetColumnVis(iCol, true, bRerender);
	}

	function _fnHideFormula(nNode){
		jQuery(nNode).attr('title', msgs.msg_spreads_show_calc);
		jQuery(nNode).html('<i class="icon-resize-full"></i>');
		jQuery(nNode).closest('table').addClass('rows_hidden');
	}

	function _fnShowFormula(nNode){
		jQuery(nNode).attr('title', msgs.msg_spreads_hide_calc);
		jQuery(nNode).html('<i class="icon-resize-small"></i>');
		jQuery(nNode).closest('table').removeClass('rows_hidden');
	}

	function _fnBuildFormulaHideControl(nActionElem, sStatementId, nAttachTo) {
		jQuery(nActionElem).append(jQuery(nAttachTo).find('.hide_calculation').html());
		var nNode = jQuery(nActionElem).find('.action_item_calc_link');
		if(_bHideAllRecords){
			_fnHideFormula(nNode);
		} else {
			_fnShowFormula(nNode);
		}
		nNode.hide();
		jQuery(nNode).click(function(e) {
			e.preventDefault();
			_fnUpdateHideAllRecords(sStatementId, this);
		});
	}

	function _fnUpdateHideAllRecords(sStatementId, nNode){
		if (jQuery(nNode).attr('title') == msgs.msg_spreads_hide_calc) {
			_bHideAllRecords = true;
			_fnHideFormula(nNode);
		} else {
			_bHideAllRecords = false;
			_fnShowFormula(nNode);
		}

		// update db; retrieve total record
		_fnGetTotalRecord(
			sStatementId,
			_sTotalGroupId,
			function(totalRec) {
				//update HideAllRecords value
				totalRec.isHideAllRecords = _bHideAllRecords;
				// save total record
				_fnSaveIForceRecord(
					totalRec,
					function(){},
					SpreadStatement.handleError
				);
			}
		);

		// update display
		for(var i=0;i<_aoDataMap.length;i++){
			for(var j=1;j<_aoDataMap[i].length;j++){
				var oCol = _aoDataMap[i][j];
				if(oCol['record']['total_group_id'] != null && oCol['record']['total_group_id'] == _sTotalGroupId) {
					oCol['record']['total_hide_all_records'] = _bHideAllRecords;
					iRow = i;
				}
			}
		}

		_oSheetTable.fnUpdate(_aoDataMap[iRow], iRow, true, true);

	}
	function _fnBuildSpreadSelectWidget(nTable, sStatementId, nActionElem, oTable, bConfigurable, _aoUniqueRecords) {
		jQuery(nActionElem).text('');
		_fnBuildSpreadSelect(nActionElem);
		var sTitleClass = 'multiselect_' + _sAccountTitle.replace(/ /g,"_").replace(/\W/g, '');
		var selector = jQuery(nActionElem).find('.chart_selector');
		if(bConfigurable){
			var sTotalGroupId = _fnGetTotalGroupId();
			_.each(_aoUniqueRecords, function(oRecord){
				if (oRecord.include_in_total) {
					nActionElem.find('.chart_selector select')
					.append(jQuery('<option></option>')
					.attr('value', oRecord.id)
					.attr('selected', 'selected')
					.html(oRecord.name));
				} else {
					nActionElem.find('.chart_selector select')
					.append(jQuery('<option></option>')
					.attr('value', oRecord.id)
					.html(oRecord.name));
				}
			});
			selector.find('select').multiselect({
				header: false,
				selectedList: 100,
				selectedText: function(selectedCount, totalCount, nElem) {
					return _sAccountTitle;
				},
				minWidth : 'auto',
				multiple : true,
				classes : sTitleClass,
				show: ['scale', 200],
				hide: ['scale', 200],
				beforeclose: function() {},
				click: function(event, ui) {
					_fnUpdateIncludeInTotal(sStatementId, ui, nTable, oTable);
				}
			}).multiselectfilter({label:msgs.msg_spreads_search});

			jQuery('div.'+sTitleClass).find('.ui-multiselect-header').after(jQuery(_nAttachTo).find('div.add_new_chart').html());

			jQuery('div.'+sTitleClass).find('.action_item_new_chart').click(function() {
				if (spreadStatementInstance.navApp.viewModel.savePending()) {
					spreadStatementInstance.promptSave();
				} else {
					if (jQuery(nTable).find('tr.new_spread_row').length == 0) {
						_fnBuildNewChartControl(nTable, sStatementId);
					}
				}
			});

			SpreadStatement.styleMultiselectButton(nActionElem);
			nActionElem.find('.ui-widget').show();
		}else{
			selector.find('select').multiselect({
				header: false,
				classes: sTitleClass
			});
			selector.find('button.ui-multiselect span').not('.ui-icon')
					.html(_sAccountTitle);
			SpreadStatement.disableMultiselectButton(selector);
			SpreadStatement.styleMultiselectButton(nActionElem);
			nActionElem.find('.ui-widget').show();
		}
	}

	function _fnBuildSpreadSelect(nActionElem) {
		var html = '<div class="ui-widget" style="display:none;">'+
						'<div class="chart_selector">'+
							'<select name="'+ _sAccountTitle.replace(/ /g,"_") + '" multiple="multiple">'+
							'</select>'+
						'</div>'+
					'</div>';
		nActionElem.append(html);
	}

	function _fnUpdateIncludeInTotal(sStatementId, ui, nTable, oTable) {
		var iRow;
		var aiCol = [];
		aiCol = aiCol.concat(
			_aoCategorizedCols['months'],
			_aoCategorizedCols['quarters'],
			_aoCategorizedCols['years'],
			_aoCategorizedCols['common_sizing'],
			_aoCategorizedCols['trend']
		);
		for(var iRow=0;iRow<_aoDataMap.length;iRow++){
			if(_aoDataMap[iRow][0]['record']['id'] != null && _aoDataMap[iRow][0]['record']['id'] == ui.value) {
				_.each(aiCol, function(iCol){
					var oCol = _aoDataMap[iRow][iCol];
					oCol['record']['include_in_total'] = ui.checked;
					_navApp.publish('SPREAD.Spreads.Record_Selection_Changed', oCol['record']);
				});
				break;
			}
		}

		_oSheetTable.fnUpdate(_aoDataMap[iRow], iRow, undefined, true, false);

		var spreadStatementCellUpdate = _fnCalculateGroupTotals(
				oTable,
				_aoDataMap,
				aiCol,
				true,
				true,
				_sAccountTitle);

		_fnSetSuppressReDraw(false);
		_fnUpdateRecordCell(true, spreadStatementCellUpdate);

		_fnUpdateRemoteIncludeInTotal(
			sStatementId,
			ui.value,
			ui.checked,
			function(){},
			SpreadStatement.handleError
		);
	}

	function _fnBuildNewChartControl(nTable, sStatementId) {
		var totalId = nTable.id;
		// create new table row, remove cell content, style
		var nNewRow = jQuery(nTable).find('tbody tr').last().clone();
		jQuery(nNewRow).attr('class','new_spread_row');
		jQuery(nNewRow).find('td').each(function() {
			jQuery(this).attr('class', 'new_spread');
			jQuery(this).text('');
			jQuery(this).removeAttr('title');
		});

		// add form to new row and set button actions
		jQuery(nNewRow).find('td').first().html(jQuery(_nAttachTo).find('div.new_chart_control_container').html());
		jQuery(nNewRow).find('.new_chart_control input[name="cancel"]').click(function(e) {
			jQuery(nTable).find('tbody tr').last().remove();
		});

		var typeSel = jQuery(nNewRow).find('.new_chart_control select[name="recordType"]');
		typeSel.change(function(e) {
			var debitSel = jQuery(nNewRow).find('.new_chart_control select[name="debit"]');
			if (SpreadStatement.RecordType.isStandard(typeSel.val())) {
				debitSel.prop('disabled', false);
			} else {
				debitSel.prop('disabled', 'disabled');
			}
		});

		var classificationSel = jQuery(nNewRow).find('.new_chart_control select[name="classifications_input"]');
		var statement = LifeCycle.SpreadData.lookupStatementById(sStatementId);
		var classificationRequired = (statement.isIncomeStatement() || statement.isBalanceSheet());
		if (classificationRequired) {
			classificationSel.find('option').remove();

			var availableClassifications = LifeCycle.SpreadData.lookupClassificationsByFilter(function () { return true; });
			for (var i = 0; i < availableClassifications.length; i++) {
				var classification = availableClassifications[i];
				classificationSel.append('' +
					'<option value="' + classification.recordId() + '">' +
					classification.name() + ' (' + classification.category() + ')' +
					'</option>'
				);
			}

			var commonNeighboringClassifications = LifeCycle.SpreadData.RMAServices.ClassificationService.getClassificationsForTotalRecords(
				LifeCycle.SpreadData.lookupRecordTotalById(totalId)
			);
			if (commonNeighboringClassifications) {
				var commonIds = commonNeighboringClassifications.map(function (classification) {
					return ko.unwrap(classification.recordId);
				});

				classificationSel.val(commonIds).trigger('chosen:updated');
			}
		} else {
			classificationSel.closest('.control-group').remove();
		}
		jQuery.validator.addMethod(
			"uniqueChartName",
			function(value, element){
				var aChartNames = _fnGetChartsForGroup(_fnGetTotalGroupId());
				return !_.contains(aChartNames, value);
			},
			msgs.msg_spreads_validation_chart_name
		);
		var statement = LifeCycle.SpreadData.lookupStatementById(sStatementId);
		var classificationRequired = (statement.isIncomeStatement() || statement.isBalanceSheet());
		var validator = jQuery(nNewRow).find('.new_chart_control form').validate({
			rules: {
				spread_name: {
					required: true,
					uniqueChartName: true
				},
				classifications_input: {
					required: classificationRequired
				}
			},
			ignore: ':hidden:not(.classifications_input)',
			errorClass: "text-error pull-right",
			highlight: function(element) {
				jQuery(element).closest('.control-group').addClass('error');
			},
			success: function(element) {
				element.closest('.control-group').removeClass('error');
			},
			submitHandler: function(form) {
				Utils.blockUI('300px');
				var spreadRecordName = jQuery(form).find('input[name="spread_name"]').val();
				var recordType = jQuery(form).find('select[name="recordType"]').val();
				var isDebit = jQuery(form).find('select[name="debit"]').val();
				var displayType = jQuery(form).find('select[name="displayType"]').val();
				var sTotalGroupId = _fnGetTotalGroupId();
				var displayCommonSizing = jQuery("label.checkbox input[data-bind*='displayCommonSizing']");
				var displayTrend = jQuery("label.checkbox input[data-bind*='displayTrend']");
				var spreadsDatePickerVm = LifeCycle.RegistrationApp.getAppsByName('Spread_Date_Picker')[0].viewModel;
				var selectedClassificationIds = (jQuery(form).find('select[name=classifications_input]').val() || []);
				var selectedClassifications = selectedClassificationIds.map(function (id) {
					return LifeCycle.SpreadData.lookupClassificationById(id);
				});

				_fnAddSpreadStatementRecord(
					sStatementId,
					sTotalGroupId,
					spreadRecordName,
					recordType,
					isDebit,
					displayType,
					function(_result){
						LifeCycle.SpreadData.cacheUnmappedIForces([_result]);
						var result = LifeCycle.SpreadData.lookupIForceById(_result.recordId);

						var junctions = [];
						for (var i = 0; i < selectedClassifications.length; i++) {
							var classification = selectedClassifications[i];
							var junction = LifeCycle.SpreadData.RMAServices.ClassificationService.addClassification(
								result,
								classification
							);
							junctions.push(junction);
						}

						LifeCycle.LiteForceService.saveIForces(junctions, function (results) {
							LifeCycle.SpreadData.cacheUnmappedIForces(results);
							var _configApp = LifeCycle.RegistrationApp.getAppsByName('Spread_Config');
							if (_configApp.length) {
								_configApp[0].viewModel.spread.getRemoteData(true, false);
							}
						}, SpreadStatement.handleError);
					},
					SpreadStatement.handleError
				);
			}
		});

		jQuery(nTable).find('tbody').append(nNewRow);
		jQuery(nTable).find('.chart_selector select').multiselect('close');
		jQuery(nTable).find('input[name="spread_name"]').focus();
		
		classificationSel.chosen({
			width: '150px'
		}).change(function() {
			validator.form();
		});
	}

	function _fnGetTotalGroupId() {
		var sTotalGroupId = null;
		for(var i = 0; i < _aoDataMap.length; i++) {
			var aoRow = _aoDataMap[i];
			for(var k = 0; k < aoRow.length; k++) {
				var oRecord = aoRow[k];
				if(oRecord['record'] && oRecord['record']['total_group_id']){
					sTotalGroupId = oRecord['record']['total_group_id'];
					break;
				}
			}
			if(sTotalGroupId != null){
				break;
			}
		}
		return sTotalGroupId;
	}

	function _fnGetVisibleRows(){
		var aiVisibleRows = [];
		for (var i=0;i<1; i++){
			var aoRow = _aoDataMap[i];
			for(var k=0;k < aoRow.length;k++){
				var oRecord = aoRow[k];
				if(oRecord['record'] && oRecord['record']['include_in_total'] && oRecord['record']['include_in_total'] == true) {
					aiVisibleRows.push(i);
				}
			}
		}
		return aiVisibleRows;
	}

	function _fnGetRecordId(iDataIndex) {
		var sRecordId = null;
		var aoVisibleRows = [];

		for (var i=0;i<_aoDataMap.length; i++){
			var aoRow = _aoDataMap[i];
			for(var k=0;k < aoRow.length;k++){
				var oRecord = aoRow[k];
				if(oRecord['record'] && oRecord['record']['include_in_total'] && oRecord['record']['include_in_total'] == true) {
					aoVisibleRows.push(oRecord);
					break;
				}
			}
		}

		var oVisibleRecord = aoVisibleRows[iDataIndex];
		if(oVisibleRecord['record'] && oVisibleRecord['record']['id']){
			sRecordId = oVisibleRecord['record']['id'];
		}

		return sRecordId;
	}

	function _fnGetChartsForGroup(sTotalGroupId) {
		var aCharts = [];
		for(var i = 0; i < _aoDataMap.length; i++) {
			var aoRow = _aoDataMap[i];
			for(var k = 0; k < aoRow.length; k++) {
				var oRecord = aoRow[k];
				if(oRecord['record'] && oRecord['record']['total_group_id'] &&
					oRecord['record']['total_group_id'] != sTotalGroupId) {
					break;
				}
				if(oRecord['record'] && oRecord['record']['name'] &&
					!_.contains(aCharts, oRecord['record']['name'])) {
					var name = oRecord['record']['name'];
					aCharts.push(name.replace("&amp;", "&"));
					break;
				}
			}
		}
		return aCharts;
	}
	/**
	 * TODO: css classes should be passed in as parameters
	 */
	function _fnRenderHidePeriodGroup(oTable, nElem, iCol, aoCategorizedCols) {
		if(nElem.find('.action_item_hide') == null
				|| nElem.find('.action_item_hide').length == 0) {

			nElem.append(jQuery(_nAttachTo).find('div.hide_period').html());

			nElem.find('.action_item_hide').click(function() {
				_fnExpandOrHidePeriod(oTable, iCol, false, aoCategorizedCols);
			});
		} else {
			nElem.find('.action_item_hide').removeClass('hide');
		}

		nElem.find('.action_item_expand').addClass('hide');
	}

	/**
	 * TODO: css classes should be passed in as parameters
	 */
	function _fnRenderExpandPeriodGroup(oTable, nElem, iCol, aoCategorizedCols) {
		if(nElem.find('.action_item_expand') == null
				|| nElem.find('.action_item_expand').length == 0) {

			nElem.append(jQuery(_nAttachTo).find('div.expand_period').html());

			nElem.find('.action_item_expand').click(function() {
				_fnExpandOrHidePeriod(oTable, iCol, true, aoCategorizedCols);
			});
		} else {
			nElem.find('.action_item_expand').removeClass('hide');
		}

		nElem.find('.action_item_hide').addClass('hide');
	}

	function _fnRenderUnbalancedTotal(oTable, nElem, iCol, aoCategorizedCols) {
		jQuery(_nAttachTo).find('div.unbalanced_total').find('p').html(msgs.msg_spreads_unbalanced);
		nElem.prepend(jQuery(_nAttachTo).find('div.unbalanced_total').html());
	}
	function _fnRenderBalancedTotal(oTable, nElem, iCol, aoCategorizedCols) {
		jQuery(_nAttachTo).find('div.balanced_total').find('p').html(msgs.msg_spreads_balanced);
		nElem.prepend(jQuery(_nAttachTo).find('div.balanced_total').html());
	}

	function _fnCreateHeaderElement(
			oTable,
			nHead,
			nActionElem,
			iCol,
			sHeaderText,
			aoCategorizedCols,
			oRecord) {

		if(_bDateAppColumns){
			if(nActionElem.find('.additional-data-points') == null || nActionElem.find('.additional-data-points').length == 0){
				var colName = 'recordTotal_'+_that.sRecordTotalId+'_col_'+iCol+'_additional_header';

				var columnHeaderHtml =
					'<div data-bind="stopBinding: true">'
						+'<div id="'+colName+'" class="header-cols-'+_that.sRecordTotalId+' additional-data-points" data-bind="with: getPeriod(\'' + oRecord['period']['lookupKey'] + '\')" >'
							+'<div>'
								+'<span data-bind="text: moment(displayStatementDate()).format(\'L\')">'
								+'</span>'
								+'<a href="javascript:void(0);" class="pull-right" data-bind="visible: ($parent.isEditable || $parent.isColumnSourceEditable), click: $parent.editPeriod, enable: $parent.hasCreateStatementsPermission">'
									+'<span class="icon-edit">'
									+'</span>'
								+'</a>'
							+'</div>'
							+'<div>'
								+'<span data-bind="text: displayNumberOfPeriods">'
								+'</span>'
							+'</div>'
							+'<div>'
								+'<span data-bind="text: source">'
								+'</span>'
							+'</div>'
							+'<div>'
								+'<span data-bind="text: $parent.getAnalystName($data)">'
								+'</span>'
							+'</div>'
						+'</div>'
					+'</div>';
				nActionElem.attr('id', oRecord['period']['id']);
				nActionElem.append(columnHeaderHtml);
				ko.applyBindings(_spreadConfigApp.viewModel, document.getElementById(colName));
			}
		}

		if(aoCategorizedCols['years'].indexOf(iCol) >= 0) {
			var aiLinkedCols = null;
			if(aoCategorizedCols['years'].indexOf(iCol) >= 0) {
				aiLinkedCols = _fnFindLinkedPeriods(
					aoCategorizedCols['years'].indexOf(iCol),
					aoCategorizedCols['years'],
					aoCategorizedCols['quarters']);
			}

			var bExpand = true;
			for(var p = 0; p < aiLinkedCols.length; p++) {
				if(oTable.fnIsColVisible(aiLinkedCols[p])) {
					bExpand = false;
					break;
				}
			}

			if(_bEnableExpansionArrows){
				if(bExpand) {
					_fnRenderExpandPeriodGroup(oTable, nActionElem, iCol, aoCategorizedCols);
				} else {
					_fnRenderHidePeriodGroup(oTable, nActionElem, iCol, aoCategorizedCols);
				}
			}
		}
	}

	function _fnRenderAddPeriod(nHead, nActionElem, bNext) {
		if(nActionElem.find('.action_item') == null || nActionElem.find('.action_item').length == 0) {

			jQuery(_nAttachTo).find('div.add_new_period').find('strong').html(msgs.msg_spreads_add_period);
			nActionElem.append(jQuery(_nAttachTo).find('div.add_new_period').html());

			nActionElem.find('.action_item').click(function() {
				_fnAddNewPeriod(bNext);
			});
		}
	}

	/**
	 * TODO: how do we handle the CSS classes here? It should be passed in the config object
	 * @param {Object} nActionElem
	 */
	function _fnRemoveAddPeriodRendering(nActionElem) {
		if(nActionElem != null && nActionElem.length != 0) {
			if(nActionElem.find('.action_item') != null && nActionElem.find('.action_item').length != 0) {
				nActionElem.find('.action_item').remove();
			}
		}
	}

	function _fnFindLinkedPeriods(iParentIndex, aiParents, aiChildren) {
		var aiToReturn = [];
		if(iParentIndex >= 0) {
			var iLessIndex = iParentIndex - 1;
			var iLessParent = iLessIndex >= 0 ? aiParents[iLessIndex] : -1;
			for(var i = 0; i < aiChildren.length; i++) {
				var iChildCol = aiChildren[i];
				if(iChildCol < aiParents[iParentIndex] && iChildCol > iLessParent) {
					aiToReturn.push(iChildCol);
				}
			}
		}
		return aiToReturn;
	}



	function _fnReFreshPeriodData(newData, callback) {
		var groupData = newData[_sTotalGroupId];

		var aaData =  _fnGenerateAaData(groupData.records , groupData.asRowIds, groupData.aoPeriods, []);

		if(_bIsCommonSizingOptional || _bIsTrendOptional){
			_fnInsertCalculatedColumns(aaData);
		}

		_fnPadDataArray(aaData);
		
		for (var i = 0; i < aaData.length; i++) {
			_aoDataMap[i] = aaData[i];
		}

		_fnReDraw();

		if(!_.isUndefined(callback)){
			callback.apply();
		}

		LifeCycle.unblockUI();
	}



	function _fnExpandOrHidePeriod(oTable, iCol, bExpand, aoCategorizedCols) {
		var iColsToShow = [];
		var iQuartersToHide = [];

		// determine category of column
		var iYearIndex = aoCategorizedCols['years'].indexOf(iCol);
		var iQuarterIndex = aoCategorizedCols['quarters'].indexOf(iCol);
		if(iYearIndex >= 0) {
			iColsToShow = _fnFindLinkedPeriods(iYearIndex, aoCategorizedCols['years'], aoCategorizedCols['quarters']);
			iQuartersToHide = [].concat(iColsToShow);
		} else if(iQuarterIndex >= 0) {
			iColsToShow = _fnFindLinkedPeriods(iQuarterIndex, aoCategorizedCols['quarters'], aoCategorizedCols['months']);
		}

		for(var i = 0; i < iColsToShow.length; i++) {
			if(bExpand) {
				_fnShowColumn(oTable, iColsToShow[i], false);
			} else {
				_fnHidePeriod(oTable, iColsToShow[i], false);
			}
		}

		if(!bExpand){
			for(var f=0;f<iQuartersToHide.length;f++){
				_fnExpandOrHidePeriod(oTable,iQuartersToHide[f],bExpand, aoCategorizedCols);
			}
		}
		
		renderingService.requestDraw(oTable);
	}

	function _fnHidePeriod(oTable, iCol, bRerender) {
		_fnRemoveAllCustomizations();
		oTable.fnSetColumnVis(iCol, false, bRerender);
	}

	function _fnHideColumns(oTable, aiCols, bRerender) {
		if(aiCols != null) {
			for(var i = 0; i < aiCols.length; i++) {
				_fnHidePeriod(oTable, aiCols[i], bRerender);
			}
		}
	}

	function _fnRegisterInitEvent(){
		if(_that.bIsNOIStatementOperatingExpenses) {
			_fnRegisterEvent(true, LifeCycle.Events.Spreads.PGI_Record_Total_Init, _fnGetColumnTotals, true);
		}
	}

	function _fnRegisterUpdateEvent(){
		if(_that.bIsNOIStatementOperatingExpenses) {
			_fnRegisterEvent(true, LifeCycle.Events.Spreads.PGI_Record_Total_Update, _fnGetColumnTotals, false);
		}
	}

	function _fnRegisterEvent(bPublish, sTopic, handlerFunction){
		if(bPublish){
			_eventQueue['publish'].push({topic: sTopic, handler: handlerFunction })
		}else{
			_eventQueue['subscribe'].push({topic: sTopic, handler: handlerFunction })
		}
	}

	function _fnFireEvents(bPublish){
		if(bPublish){
			_.each(_eventQueue['publish'], function(e){
				_spreadConfigApp.publish(e.topic, e.handler());
			});
			_eventQueue.publish = [];
		}else{
			_.each(_eventQueue['subscribe'], function(e){
				_spreadConfigApp.subscribe(e.topic, e.handler);
			});
			_eventQueue.subscribe = [];
		}
	}

	function _fnEditTableCell(nNode, value) {
		var oTable = _oSheetTable;
		var aPos = oTable.fnGetPosition(nNode);
		var iRow = aPos[0];
		var iCol = aPos[2];
		var aoRecordValue = _aoDataMap[iRow][iCol];
		var displayValue = null;
		var isDebit = false;
		var displayType = 'Decimal';
		
		var element = jQuery(nNode);
		element.removeClass('error');
		element.attr('data-original-title', '');
		element.tooltip('hide');

		var record = LifeCycle.SpreadData.lookupRecordById(aoRecordValue.record.id);
		var period = LifeCycle.SpreadData.lookupPeriodById(aoRecordValue.period.recordId);
		if(LifeCycle.SpreadData.FormulaService.isFormulaLike(value)){
			return LifeCycle.SpreadData.FormulaService.updateRecordValueFormula('' + value, record, period, false);
		} else {
			LifeCycle.SpreadData.FormulaService.updateRecordValueFormula('' , record, period, false);
		}
		
		value = value * LifeCycle.SpreadData.FormattingService.getScaleDivisorForRecord(record);

		var originalValue = null;
		var originalFormula = null;
		if(aoRecordValue['period'] != null) {
			originalValue = aoRecordValue['value'];
			originalFormula = aoRecordValue['formula'];
		}

		displayType = aoRecordValue['record']['displayType'];

		if(displayType == 'Percentage'){
			value = Utils.getNumberFromCurrency(value/100);
		}else{
			value = Utils.getNumberFromCurrency(value);
		}

		if(value != originalValue || !_.isEmpty(originalFormula)){
			_fnSetSuppressReDraw(false);

			value = _editData(iRow,iCol,value,undefined, undefined, undefined, !_.isEmpty(originalFormula) ? true : false);
		}
		
		return LifeCycle.SpreadData.FormattingService.formatRecordValue(value, record);
	}

	/**
	 *
	 * @param {Object} iRow
	 * @param {Object} iCol
	 * @param {Object} value
	 * @param {Object} sGroupKey optional parameter
	 * @param {Object} [cellUpdateObj] if specified, no ajax requests will take place, instead the object will be
	 *	 enriched.
	 * @param {boolean} [suppressTableUpdate] prevents updating of _oSheetTable if set to true
	 * @param {boolean} [forceUpdate] will always update the value of the cell if set to true
	 * @return {(number|null)}
	 */
	function _editData(iRow, iCol, value, sGroupKey, cellUpdateObj, suppressTableUpdate, forceUpdate){
		try{
			var bTableUpdate = !suppressTableUpdate;
			var bWasNull = false;
			if(value == null){
				bWasNull = true;
				value = null;
			}

			var bRedraw = !bWasNull;

			if(!bWasNull && !Utils.isValidNumber(value)) {
				return null;
			}

			if(!bWasNull){
				value = +(value);
			}

			var oColData = _aoDataMap[iRow][iCol];

			var aoUpdatedCols = [];
			var aoUpdatedGroups = [];

			var aiUpdatedCols = [];
			var bUpdateValue = false;
			if(typeof forceUpdate != 'undefined'){
				bUpdateValue = forceUpdate;
			}

			// determine if an update is needed
			if(oColData['value'] != value || (oColData['value'] != null && bWasNull) ){
				bUpdateValue = true;
			}

			if(bUpdateValue){
				oColData['value'] = value;
				aoUpdatedCols.push(oColData);
			}

			if(bUpdateValue){
				Utils.addToArrayIfNotExists(aiUpdatedCols,iCol);

				var spreadStatementCellUpdate = _navApp.viewModel.spreadStatementCellUpdate;

				var directSaves = [];

				for(var j = 0; j < aoUpdatedCols.length; j++) {
					if(aoUpdatedCols[j].isLinked == false && !isSimulated(oColData.record.recordType)){
						var recordValue = LifeCycle.SpreadData.lookupRecordValueByRecordIdAndPeriodId(
							aoUpdatedCols[j]['record']['id'],
							aoUpdatedCols[j]['period']['recordId']
						);

						var changeObject = {
							id: aoUpdatedCols[j]['id'],
							recordId: aoUpdatedCols[j]['record']['id'],
							periodGUID: aoUpdatedCols[j]['period']['id'],
							val: aoUpdatedCols[j]['value'],
							formula : recordValue.formula()
						};

						if (isRentRollAnnualIncome(oColData.record.recordType)) {
							directSaves.push(changeObject);
						} else {
							_navApp.viewModel.addSaveValue(changeObject);
						}

						LifeCycle.SpreadData.updatePeriodToValue(
							aoUpdatedCols[j]['record']['id'],
							aoUpdatedCols[j]['period']['recordId'],
							aoUpdatedCols[j]['value']
						);
						if (recordValue.record.recordId() == recordValue.record.statement.calcCommonSizingDivisorId()) {
							_.each(aoSpreadStatementContainer, function(oSpreadStatementContainer) {
								oSpreadStatementContainer.reDraw();
							});
						}
					}
				}

				if (directSaves.length) {
					_navApp.viewModel.directSave(directSaves);
				}

				if(_that.bIsNOIStatementOperatingExpenses){
					_fnCalculatePerUnitOperatingExpenseValue(oColData, iRow, iCol);
					var pgiValue = _pgiColumnTotals[iCol].value;
					_fnCalculatePercentPGIValue(oColData, pgiValue, iRow, iCol);
				}

				_fnCalculateGroupTotals(
						_oSheetTable,
						_aoDataMap,
						aiUpdatedCols,
						false,
						_bUpdateTotalColumns,
						_sAccountTitle,
						spreadStatementCellUpdate);

				if(!_.isEmpty(cellUpdateObj)){
					cellUpdateObj.recordPeriods = [].concat(
							cellUpdateObj.recordPeriods,
							spreadStatementCellUpdate.recordPeriods);
				}

				if(_fnInSourceRecordIdMap(oColData['record']['id'])){
					_fnNotifySourceRecordUpdated(oColData, iCol);
				}

				if(bTableUpdate){
					_oSheetTable.fnUpdate(_aoDataMap[iRow], iRow, true, true);
				}
				_fnRegisterUpdateEvent(_aoDataMap);
				_fnFireEvents(true);

			}

			return oColData['value'];
		}
		finally{
			Utils.unblockUI();
		}
	}

	function _fnEditPeriodData(sRecordName, sPeriodId, sVal, spreadStatementCellUpdate, suppressTableUpdate){

			var iRow = -1;
			var iCol = -1;

			outerForLoop:
			for(var i=0;i<_aoDataMap.length;i++){
				for(var j=1;j<_aoDataMap[i].length;j++){
					var oCol = _aoDataMap[i][j];
					if(sRecordName == oCol['record']['name'] &&
						oCol['period'] != null &&
						oCol['calculated'] != true &&
						sPeriodId == oCol['period']['id']){

						iRow = i;
						iCol = j;
						break outerForLoop;
					}
				}
			}

			if(iRow >= 0 && iCol >= 0){
				return _editData(iRow,iCol,sVal,null,spreadStatementCellUpdate,suppressTableUpdate);
			}

	}

	/**
	 * _fnRecalculateTotal recalculates the Total for the spread statement.
	 *
	 * This function is committed for future functionality, however if we use this we need to
	 * handle the many 0.00 that will be present in the totals.
	 *
	 * TODO: Implement a fix for display purposes for the 0.00 in totals
	 */
	function _fnRecalculateTotal(){
		if(_that.bInitialized){
			var columnsToUpdate = [];
			for(i=0;i<_aoDataMap[0].length;i++){
				columnsToUpdate.push(i);
			}
			_fnCalculateGroupTotals(
				_oSheetTable,
				_aoDataMap,
				columnsToUpdate,
				false,
				_bUpdateTotalColumns,
				_sAccountTitle);
		}
	}

	function _bYearInDataSet(iYear, aoDataMap) {
		if(aoDataMap != null){
			for(var i = 0; i < aoDataMap.length; i++) {
				for(var j = 0; j < aoDataMap[i].length; j++) {
					if(aoDataMap[i][j] != null && aoDataMap[i][j]['year_group'] != null &&
						aoDataMap[i][j]['year_group']['year'] == iYear) {

						return true;
					}
				}
			}
		}
		return false;
	}

	function _fnViewSelectedYears(oTable, aiYears) {
		_aiCurrentYears = aiYears;
		_fnRemoveAllCustomizations();
		oTable.fnFilterPeriods(
			_aoDataMap,
			_aiCurrentYears,
			_aoCategorizedCols,
			_bDisplayControlWidget,
			_bSyncAllGrids,
			_bUpdateTotalColumns,
			_bGroupColumns,
			_bIsCommonSizingOptional,
			_bIsNOIStatementOperatingExpenses,
			_bIsTrendOptional);
	}

	function _fnSetSelectedYears(aiYears) {
		_fnViewSelectedYears(_oSheetTable, aiYears);
	}

	function _fnGetSelectedYears() {
		var asYears = jQuery(_nContainer).find('.'+_spreadControlWidgetClass).find(
			'.year_selector select').val();

		if(asYears == null){
			asYears = [];
		}
		for(var i = 0; i < asYears.length; i++) {
			asYears[i] = +(asYears[i]);
		}
		return asYears;
	}

	function _fnModifyYears(aiYears, bAdd) {
		if(bAdd) {
			for(var i=0;i<aiYears.length;i++){
				Utils.addToArrayIfNotExists(_aiCurrentYears, aiYears[i]);
			}

			_fnSaveSelectedYears(_aiCurrentYears);
			for(var j=0;j<aiYears.length;j++){
				var iYear = aiYears[j];
				if(!_bYearInDataSet(iYear, _aoDataMap)) {
					_fnIncrementRecordCounter(_iRecordCounter);
					_fnIncrementGroupCounter(_iGroupCounter);
					_fnAddNewPeriod(_aiCurrentYears);
					break;
				}
			}
		}
		else {
			for(var k=0;k<aiYears.length;k++){
				while(_aiCurrentYears.indexOf(aiYears[k]) >= 0){
					_aiCurrentYears.splice(_aiCurrentYears.indexOf(aiYears[k]), 1);
				}
			}

			_fnSaveSelectedYears(_aiCurrentYears);
		}
	}

	function _fnSaveSelectedYears(aiYears){
		jQuery.cookie(
			_sStatementId + '_spreads_selected_years',
			JSON.stringify(aiYears),
			{expires: 30});
	}

	function _fnHandleSelectedYears(event){
		var aiYears = [];
		aiYears.push(+(jQuery(this).prop("value")));
		_fnModifyYears(aiYears, jQuery(this).prop("checked"));
	}

	function _fnAddNumbers(a, b, subtract, bRoundNumbers){
		if(_.isUndefined(bRoundNumbers) || bRoundNumbers){
			a = _fnRoundNumber(a);
			b = _fnRoundNumber(b);
		}
		if(subtract != null && subtract == true){
			return a - b;
		}
		return a + b;
	}

	function _fnMultiplyNumbers(a, b, divide, bRoundNumbers){
		var denom = b;
		if(_.isUndefined(bRoundNumbers) || bRoundNumbers){
			denom = _fnRoundNumber(b);
			a = _fnRoundNumber(a);
		}
		if(divide != null && divide == true){
			if(denom == 0){
				return 0;
			}
			return a / denom;
		}
		return a * denom;
	}

	function _fnRoundNumber(a){
		if(typeof a == 'undefined' || a == null || a == ''){
			return 0;
		}
		return Math.round(a*100)/100;
	}

	function _fnGetCurrencyRegion(){
		return Utils.getCurrencyRegion();
	}
	function _fnFormatCurrencyForDisplay(value){
		return Utils.formatCurrencyForDisplay(value, true);
	}

	function _fnFormatPercentageForDisplay(value, precision, addSymbol){
		var result = '0';
		precision = precision || 1;
		if (precision > 0) {
			result += '.';
			for (var i=0; i<precision; i++) {
				result += '0';
			}
		}
		if(!_.isUndefined(value) && !isNaN(value)){
			var abs = (Math.abs(value) * 100).toFixed(precision);
			result = (value < 0) ? '(' + abs + ')' : abs;
		}
		return (addSymbol) ? result + '%' : result;
	}

	function _fnSetLinkedFieldsFunction(fn) {
		_fnGetLinkedFields = fn;
	}

	function _fnShowHideRecordWithName(recordName, checked){
		var iRow;
		var recordId;
		for(var i=0;i<_aoDataMap.length;i++){
			for(var j=1;j<_aoDataMap[i].length;j++){
				var oCol = _aoDataMap[i][j];
				if(oCol['record']['id'] != null && oCol['record']['name'] == recordName) {
					oCol['record']['include_in_total'] = checked;
					recordId = oCol['record']['id'];
					iRow = i;
				}
			}
		}
		_oSheetTable.fnUpdate(_aoDataMap[iRow], iRow, true, true);
		jQuery("input[type='checkbox'][value='"+recordId+"']").attr('checked',checked);
	}

	function _fnUpdateSelectedColumns(aiCols, bShow) {
		if(bShow){
			_.each(aiCols, function(iCol){
				_.each(_aoDataMap, function (row) {
					row[iCol].period.selected = true;
				});
			});
		}else{
			_.each(aiCols, function(iCol){
				_.each(_aoDataMap, function (row) {
					row[iCol].period.selected = false;
				});
			});
		}
	}

	function _fnShowHideColumns(aiCols, bShow){
		if(bShow){
			_.each(aiCols, function(iCol){
				_fnShowColumn(_oSheetTable, iCol, false);
			});
		}else{
			_.each(aiCols, function(iCol){
				_fnHidePeriod(_oSheetTable, iCol, false);
			});
		}

		renderingService.requestDraw(_oSheetTable);
	}

	function _fnBuildGroupColumnNumber(oGroupPeriod){
		return parseInt(oGroupPeriod['year'] + '0' + oGroupPeriod['quarter']);
	}

	function _fnIdentifyGroupPeriod(oGroup){
		return _.isUndefined(oGroup['quarter_group'])
				? oGroup['year_group'] : oGroup['quarter_group'];
	}

	function _fnIdentifyPeriodPreviousYear(oCurrentPeriod, oPeriods){
		var month = oCurrentPeriod['month'];
		var year = oCurrentPeriod['year'];
		var numberOfPeriods = oCurrentPeriod['numberOfPeriods'];

		var currentSource = oCurrentPeriod['source'];
		var sourceOrder =
			[
			 'CPA Audit',
			 'CPA Compiled',
			 'CPA Review',
			 'Tax Return',
			 'Comp. Prep',
			 'Projected',
			 'Other',
			 null,
			 ''
			];
		sourceOrder.splice(sourceOrder.indexOf(currentSource), 1);
		sourceOrder.unshift(currentSource);

		for(var i = 0; i < sourceOrder.length; i++){
			var propertyObject = {
					year: year - 1,
					month: month,
					source: sourceOrder[i],
					numberOfPeriods: numberOfPeriods
				}
			var prevPeriod = _.findWhere(_aoPeriods, propertyObject);
			if(!_.isUndefined(prevPeriod)){
				var prevPeriodKey = prevPeriod.periodKey;
				return oPeriods[prevPeriodKey];
			}
		}
		return undefined;
	}

	function _fnIdentifyPeriodPreviousFiscalYear(oCurrentPeriod, oPeriods){
		var month = oCurrentPeriod['month'];
		var year = oCurrentPeriod['year'];

		var currentSource = oCurrentPeriod['source'];
		var sourceOrder =
			[
			 'CPA Audit',
			 'CPA Compiled',
			 'CPA Review',
			 'Tax Return',
			 'Comp. Prep',
			 'Projected',
			 'Other',
			 null,
			 ''
			];
		sourceOrder.splice(sourceOrder.indexOf(currentSource), 1);
		sourceOrder.unshift(currentSource);

		for(var i = 0; i < sourceOrder.length; i++){
			var propertyObject = {
					year: year - 1,
					source: sourceOrder[i],
					numberOfPeriods: 12,
					isFiscalYear: true
				}
			var prevPeriod = _.findWhere(_aoPeriods, propertyObject);
			if(!_.isUndefined(prevPeriod)){
				var prevPeriodKey = prevPeriod.periodKey;
				return oPeriods[prevPeriodKey];
			}
		}
		return undefined;
	}

	function _fnIdentifyPeriodNextYear(oCurrentPeriod, oPeriods){
		return oPeriods[oCurrentPeriod['columnNumber'] + 100];
	}

	function _fnIdentifyGroupPreviousYear(oCurrentPeriod, oPeriods){
		return oPeriods[_fnBuildGroupColumnNumber(oCurrentPeriod) - 100];
	}

	function _fnIdentifyGroupNextYear(oCurrentPeriod, oPeriods){
		return oPeriods[_fnBuildGroupColumnNumber(oCurrentPeriod) + 100];
	}

	function _fnInsertLinkedRecordObjectsIntoDataMap(aoTargetRecord, aoSourceRecord, period_over_period_change, prior_fiscal_year){
		var aiCol = [];
		aiCol = aiCol.concat(
			_aoCategorizedCols['months'],
			_aoCategorizedCols['quarters'],
			_aoCategorizedCols['years']
		);

		_.each(aiCol, function(j){

			var targetRecordValue = aoTargetRecord[j];
			var sourceRecordValue = aoSourceRecord[j];
			var sourceRecordId = sourceRecordValue['record']['id'];
			var targetRecordId = targetRecordValue['record']['id'];

			targetRecordValue['record']['period_over_period_change'] = period_over_period_change;
			targetRecordValue['record']['prior_fiscal_year'] = prior_fiscal_year;

			if(!_.isUndefined(sourceRecordValue['period'])){
				var sourceValue = sourceRecordValue['value'];
				targetRecordValue['linkedRecord'] = {
							'value': sourceRecordValue['value'],
							'period_over_period_change': period_over_period_change,
							'prior_fiscal_year': prior_fiscal_year,
							'record': targetRecordValue['record'],
							'period': targetRecordValue['period'],
							'sourceRecord': {
								recordId: sourceRecordValue['record']['id']
							}
				}
				var sPeriodKey = targetRecordValue['period']['periodKey'];

				if(_.isUndefined(_linkedRecordValues[sourceRecordId])){
					_linkedRecordValues[sourceRecordId] = {};
				}
				if(_.isUndefined(_linkedRecordValues[sourceRecordId][sPeriodKey])){
					_linkedRecordValues[sourceRecordId][sPeriodKey] = {};
				}
				if(_.isUndefined(_linkedRecordValues[sourceRecordId][sPeriodKey][targetRecordId])){
					_linkedRecordValues[sourceRecordId][sPeriodKey][targetRecordId] = targetRecordValue;
				}

				_fnEditPeriodData(
					targetRecordValue['record']['name'],
					targetRecordValue['period']['id'],
					_fnCalculateLinkedRecordValue(
						targetRecordValue,
						sourceRecordValue,
						_linkedRecordValues[sourceRecordId]
					),
					null,
					true
				);
			}

		});

	}

	function _padString(str){
		var pad = '00';
		return (pad + str).slice(-pad.length);
	}

	function _fnBuildLinkedRecordValues(oLinkedRecordValues){
		var oMap = {};
		if(!_.isEmpty(oLinkedRecordValues)){
			var aiCol = [];
			aiCol = aiCol.concat(
				_aoCategorizedCols['months']
			);
			for(var i = 0; i < _aoDataMap.length; i++){
				var aoRow = _aoDataMap[i];
				var aoLinkedRecord = oLinkedRecordValues[aoRow[0]['record']['id']];

				if(!_.isUndefined(aoLinkedRecord) && aoLinkedRecord.length > 0){
					// starts at index 1 because first element is duplicate of second
					_.each(aiCol, function(j){
						var oValue = aoRow[j];
						var sValuePeriodKey = oValue['period']['periodKey'];

						if(!_.isUndefined(oValue['period'])
								&& !_.isUndefined(oValue['period']['id'])){

							for(var k = 0; k < aoLinkedRecord.length; k++){
								var oLinkedValue = aoLinkedRecord[k];
								var sLinkedValuePeriodKey = oLinkedValue['period']['periodKey'];
								if(sValuePeriodKey == sLinkedValuePeriodKey){

									oValue['linkedRecord'] = oLinkedValue;
									break;

								}
							}

							if(!_.isUndefined(oValue['linkedRecord'])){
								var sSourceId = _.isUndefined(oValue['linkedRecord']['sourceRecord']['recordId'])
										? oValue['linkedRecord']['sourceRecord']['totalGroupId']
										: oValue['linkedRecord']['sourceRecord']['recordId'];

								var sRecordId = oValue['linkedRecord']['record']['id'];

								if(_.isUndefined(oMap[sSourceId])){
									oMap[sSourceId] = {};
								}
								if(_.isUndefined(oMap[sSourceId][sValuePeriodKey])){
									oMap[sSourceId][sValuePeriodKey] = {};
								}
								oMap[sSourceId][sValuePeriodKey][sRecordId] = oValue;
							}
						}
					});
				}
			}
		}
		return oMap;
	}

	function _fnCalculateLinkedRecordValue(targetRecordValue, sourceRecordValue, oPeriods){
		if(!_.isUndefined(targetRecordValue) && !_.isUndefined(sourceRecordValue)){
			if(targetRecordValue['linkedRecord']['period_over_period_change']){
				var oPrevPeriod = _fnIdentifyPeriodPreviousYear(targetRecordValue['period'], oPeriods);
				if(!_.isUndefined(oPrevPeriod)
						&& !_.isUndefined(oPrevPeriod[targetRecordValue['record']['id']])){

					if(typeof targetRecordValue['linkedRecord']['value'] == 'undefined'
						|| targetRecordValue['linkedRecord']['value'] == null){
						targetRecordValue['linkedRecord']['value'] = 0;
					}
					if(typeof oPrevPeriod[targetRecordValue['record']['id']]['linkedRecord']['value'] == 'undefined'
						|| oPrevPeriod[targetRecordValue['record']['id']]['linkedRecord']['value'] == null){
						oPrevPeriod[targetRecordValue['record']['id']]['linkedRecord']['value'] = 0;
					}

					return targetRecordValue['linkedRecord']['value']
							- oPrevPeriod[targetRecordValue['record']['id']]['linkedRecord']['value'];
				}else{
					return null;
				}
			} else if(targetRecordValue['linkedRecord']['prior_fiscal_year']){
				var oPrevPeriod = _fnIdentifyPeriodPreviousFiscalYear(targetRecordValue['period'], oPeriods);
				if(!_.isUndefined(oPrevPeriod)
						&& !_.isUndefined(oPrevPeriod[targetRecordValue['record']['id']])){

					if(typeof targetRecordValue['linkedRecord']['value'] == 'undefined'
						|| targetRecordValue['linkedRecord']['value'] == null){
						targetRecordValue['linkedRecord']['value'] = 0;
					}
					if(typeof oPrevPeriod[targetRecordValue['record']['id']]['linkedRecord']['value'] == 'undefined'
						|| oPrevPeriod[targetRecordValue['record']['id']]['linkedRecord']['value'] == null){
						oPrevPeriod[targetRecordValue['record']['id']]['linkedRecord']['value'] = 0;
					}

					return oPrevPeriod[targetRecordValue['record']['id']]['linkedRecord']['value'];
				}else{
					return null;
				}
			}
			return targetRecordValue['linkedRecord']['value'];
		}
	}

	function _fnCalculatePercentPGIValues(){
		if(!_.isUndefined(arguments)){
			_pgiColumnTotals = arguments;
		}
		var aiCol = [];
		aiCol = aiCol.concat(
			_aoCategorizedCols['months'],
			_aoCategorizedCols['quarters'],
			_aoCategorizedCols['years']
		);

		for(var iRow = 0; iRow < _aoDataMap.length; iRow++){
			var aoRecord = _aoDataMap[iRow];
			_.each(aiCol, function(iCol){
				var pgiValue = _pgiColumnTotals[iCol].value;
				var oSourceCell = aoRecord[iCol];
				_fnCalculatePercentPGIValue(oSourceCell, pgiValue, iRow, iCol);
			});
		}

		_fnReDraw();

	}

	function _fnCalculatePercentPGIValue(oOperatingExpenseCell, pgiValue, iRow, iCol){
		var oPercentPGINode = _aoDataMap[iRow][iCol+2];
		var value = 0.0;
		if(!_.isUndefined(pgiValue) && pgiValue != 0){
			var operatingExpense = oOperatingExpenseCell.value;
			value = operatingExpense / pgiValue;
		}
		oPercentPGINode['percent_pgi'].value = value;
	}

	function _fnCalculatePerUnitOperatingExpenseValues(){
		var aiCol = [];
		aiCol = aiCol.concat(
			_aoCategorizedCols['months'],
			_aoCategorizedCols['quarters'],
			_aoCategorizedCols['years']
		);

		for(var iRow = 0; iRow < _aoDataMap.length; iRow++){
			var aoRecord = _aoDataMap[iRow];
			_.each(aiCol, function(iCol){
				var oSourceCell = aoRecord[iCol];
				_fnCalculatePerUnitOperatingExpenseValue(oSourceCell, iRow, iCol);
			});
		}
	}

	function _fnCalculatePerUnitOperatingExpenseValue(oUpdatedCell, iRow, iCol){
		var oPerUnitOperatingExpensesNode = _aoDataMap[iRow][iCol+1];
		var value = 0.0;
		if(!_.isUndefined(_iCollateralNumberOfUnits) && _iCollateralNumberOfUnits > 0){
			var operatingExpense = oUpdatedCell.value;
			value = (operatingExpense / _iCollateralNumberOfUnits);
		}
		oPerUnitOperatingExpensesNode['per_unit_operating_expense'].value = value;

	}

	function _fnUpdateLinkedRecords(oSourceRecordValue, sourceRecordIdMap, iCol){
		var sourceRecordId = oSourceRecordValue['record']['id'];

		// execution ends if the updated object is not the source
		// of a linked record in this statement/table.
		if(!_.isUndefined(sourceRecordIdMap[sourceRecordId])){

			var bRedrawTable = false;

			for(var i = 0; i < sourceRecordIdMap[sourceRecordId].length; i++){
				var targetRecordId = sourceRecordIdMap[sourceRecordId][i];
				var iRow = _fnFindiRow(targetRecordId);
				if(!_.isUndefined(iRow)){
					var aoRecord = _aoDataMap[iRow];
					var period_over_period_change = aoRecord[0]['record']['period_over_period_change'];
					var prior_fiscal_year = aoRecord[0]['record']['prior_fiscal_year'];

					bRedrawTable = true;
					var aiCol = [];
					var sGroupKey = 'period';
					if(_.isUndefined(iCol) || period_over_period_change || prior_fiscal_year){
						aiCol = aiCol.concat(_aoCategorizedCols['months']);
					}else{
						aiCol = [iCol];
					}

					for(var j = 0; j < aiCol.length; j++){
						var iCol = aiCol[j];
						var oTargetRecordValue = aoRecord[iCol];

						var newValue = oSourceRecordValue['value'];

						var sourcePeriodKey = oSourceRecordValue['period']['periodKey'];
						var targetPeriodKey = oTargetRecordValue['period']['periodKey'];

						if(_.isUndefined(_linkedRecordValues[sourceRecordId])){
							_linkedRecordValues[sourceRecordId] = {};
						}
						if(_.isUndefined(_linkedRecordValues[sourceRecordId][sourcePeriodKey])){
							_linkedRecordValues[sourceRecordId][sourcePeriodKey] = {};
						}
						if(_.isUndefined(_linkedRecordValues[sourceRecordId][sourcePeriodKey][targetRecordId])){
							_linkedRecordValues[sourceRecordId][sourcePeriodKey][targetRecordId] = oTargetRecordValue;
						}

						_linkedRecordValues[sourceRecordId][sourcePeriodKey][targetRecordId]['linkedRecord']['value'] = newValue;

						LifeCycle.SpreadData.updatePeriodToValue(
							targetRecordId,
							oTargetRecordValue['period']['recordId'],
							newValue
						);

						_fnEditPeriodData(
							oTargetRecordValue['record']['name'],
							oTargetRecordValue['period']['id'],
							_fnCalculateLinkedRecordValue(
									oTargetRecordValue,
									oSourceRecordValue,
									_linkedRecordValues[sourceRecordId]
							), null, true
						);

					}
				}
			}

			if(bRedrawTable){
				_fnReDraw();
			}

		}
	}

	// jQuery datatables.net plugins
	/**
	 * Customizes classes applied to standard datatables elements
	 */
	jQuery.fn.dataTableExt.oStdClasses.sFilter += ' hide no-print';

	/**
	* This plugin will hide the table rows in datatables.net that have include_in_total set to false
	* or total_hide_all_records set to true
	*/
	jQuery.fn.dataTableExt.afnFiltering.push(
		function(oSettings, aData, iDataIndex){
			if(_aoDataMap != null && iDataIndex >= 0 && _aoDataMap[iDataIndex] != null && _aoDataMap[iDataIndex].length > 0){
				var recName = aData[0];
				for(var k=1;k<_aoDataMap[iDataIndex].length;k++){
					var oCol = _aoDataMap[iDataIndex][k];
					if (oCol.record != null &&
						recName.indexOf(oCol.record.name) >= 0  &&
						oCol.record.total_group_id == oSettings.sTableId &&

						((oCol.record.include_in_total != null &&
						!oCol.record.include_in_total) ||

						(oCol.record.total_hide_all_records != null &&
						oCol.record.total_hide_all_records))){

						return false;
					}
				}
			}
			return true;
		}
	);
	jQuery.fn.dataTableExt.oApi.fnShouldExpandYears = function(oSettings, bDisplayControlWidget){
		var nElem =
			bDisplayControlWidget?
				jQuery(this).parent().find('.' + _spreadControlWidgetClass):
				jQuery('.' + _spreadControlWidgetClass);
		return 'checked' == (
			nElem.find('.expand_years label input').attr('checked'));
	};
	jQuery.fn.dataTableExt.oApi.fnShouldExpandQuarters = function(oSettings, bDisplayControlWidget){
		var nElem =
			bDisplayControlWidget?
				jQuery(this).parent().find('.' + _spreadControlWidgetClass):
				jQuery('.' + _spreadControlWidgetClass);
		return 'checked' == (
			nElem.find(
				'.expand_quarters label input').attr('checked'));
	};

	jQuery.fn.dataTableExt.oApi.fnResizeTable = function(oSettings, nContainer){
		var iWidth = jQuery(window).width();
		var sWidth = '100%';

		var iNewWidth = (this.fnIVisibleColCount() * 120) + 100;
		iNewWidth = Math.min(100,iNewWidth / iWidth * 100);
		sWidth = iNewWidth + '%';

		jQuery(nContainer).css({
			width: sWidth
		});
	};

	jQuery.fn.dataTableExt.oApi.fnFilterPeriods = function(
		oSettings,
		aaData,
		aiYears,
		aoCategorizedCols,
		bDisplayControlWidget,
		bSyncAllGrids,
		bUpdateTotalColumns,
		bGroupColumns,
		bDateAppColumns,
		bDisplayCommonSizing,
		bIsNOIStatementOperatingExpenses,
		bDisplayTrend,
		ssReference) {

		if(bGroupColumns){
			// find the columns of all the years
			var aiYearColIndex = [];

			for(var i = 0, iLen = oSettings.aoColumns.length; i < iLen; i++) {
				var iCurrentYear = null;
				if(aoCategorizedCols['years'].indexOf(i) >= 0 &&
				aiYears.indexOf(aaData[0][i]['year_group']['year']) >= 0) {
					Utils.addToArrayIfNotExists(aiYearColIndex, i);
				}
			}

			var bUseGridControl = bDisplayControlWidget? true : bSyncAllGrids ? false : true;
			var aiQuarters = [];
			var aiMonths = [];
			var aiCommonSizing = [];
			var aiPerUnitOperatingExpense = [];
			var aiTrend = [];


			for(var k=0;k<aiYearColIndex.length;k++){

				if(bDisplayCommonSizing){
					for(var i = 0; i < aiMonths.length; i++){
						Utils.addToArrayIfNotExists(aiCommonSizing, aiYears[i] + 1);
					}
				}
				if(bDisplayTrend){
					for(var i = 0; i < aiMonths.length; i++){
						Utils.addToArrayIfNotExists(aiTrend, aiYears[i] + 1);
					}
				}
				if(bIsNOIStatementOperatingExpenses){
					for(var i = 0; i < aiMonths.length; i++){
						Utils.addToArrayIfNotExists(aiPerUnitOperatingExpense, aiYears[i] + 1);
					}
				}

			}

			var aiDisplayable = [];
			aiDisplayable = aiDisplayable.concat(aiYearColIndex, aiQuarters, aiMonths, aiCommonSizing, aiPerUnitOperatingExpense);

			//start at 1 since the first col is the name
			for(var l = 1, iColLen = oSettings.aoColumns.length; l < iColLen; l++) {
				this.fnSetColumnVis(l, aiDisplayable.indexOf(l) >= 0, false);
			}
		}


		renderingService.requestDraw(this);
	};

	jQuery.fn.dataTableExt.oApi.fnShowAllColumns = function(oSettings) {
		for(var i = 0; i < oSettings.aoColumns.length; i++) {
			if(!oSettings.aoColumns[i].bVisible) {
				this.fnSetColumnVis(i, true, false);
			}
		}
	};

	jQuery.fn.dataTableExt.oApi.fnShowCommonSizingColumns = function(oSettings){
		for(var i = 0; i < oSettings.aoColumns.length; i++){
			if(oSettings.aoColumns[i].sType == 'commonSizing'){
				this.fnSetColumnVis(i, true, false);
			}
		}
	};

	jQuery.fn.dataTableExt.oApi.fnIsColVisible = function(oSettings, iCol) {
		return oSettings.aoColumns[iCol].bVisible;
	};

	jQuery.fn.dataTableExt.oApi.fnIHiddenColCount = function(oSettings) {
		var iToReturn = 0;
		for(var i = 0; i < oSettings.aoColumns.length; i++) {
			if(!oSettings.aoColumns[i].bVisible) {
				iToReturn++;
			}
		}
		return iToReturn;
	};
	jQuery.fn.dataTableExt.oApi.fnIVisibleColCount = function(oSettings) {
		if (!oSettings) {
			return null;
		}
		return oSettings.aoColumns.length - this.fnIHiddenColCount();
	};
	jQuery.fn.dataTableExt.oApi.fnColCount = function(oSettings) {
		return oSettings.aoColumns.length;
	};

	jQuery.fn.dataTableExt.oApi.fnGetColumnTotal = function(oSettings, iCol, aaMap) {
		var iColTotal = 0;

		var aiDisplayableRows = _fnGetVisibleRows();
		for(var j=0;j<aaMap.length;j++){
			var iIndex = aiDisplayableRows.indexOf(j);
			var oColData = {};

			if (iIndex >= 0){
				var iRow = aiDisplayableRows[iIndex];
				oColData = aaMap[iRow][iCol];

				iColTotal = _fnIncludeInCalculation(oColData, iColTotal);

			} else {
				oColData = aaMap[j][iCol];
				if (oColData['record']['include_in_total']) {
					iColTotal = _fnIncludeInCalculation(oColData, iColTotal);
				}
			}

		}

		return iColTotal;

	};

	function _fnIncludeInCalculation(oColData, iColTotal){
		var sToAdd = oColData['value'];
		var bGroup = oColData['period'] == null || oColData['period']['id'] == null;
		var bRoundNumbers = true;
		var bCommonSizing = oColData['common_sizing'];
		var bTrend = oColData['trend'];
		if(bGroup) {
			if(oColData['year_group'] != null) {
				sToAdd = oColData['year_group']['value'];
				sGroupKey = 'year_group';
			} else if(oColData['quarter_group'] != null) {
				sToAdd = oColData['quarter_group']['value'];
				sGroupKey = 'quarter_group';
			}
		}
		if(bCommonSizing){

			sToAdd = oColData['common_sizing']['value'];
			if(isNaN(sToAdd)){
				sToAdd = 0.0;
			}
			bRoundNumbers = false;

		}
		if(bTrend){

			sToAdd = oColData['trend']['value'];
			if(isNaN(sToAdd)){
				sToAdd = 0.0;
			}
			bRoundNumbers = false;

		}

		var iDelta = (sToAdd == null || sToAdd.length == 0) ? 0 : +(sToAdd);

		if(oColData['record']['debit']) {
			iDelta = iDelta*-1;
		}
		if(oColData['record']['operation_add'] == true){
			iColTotal = _fnAddNumbers(iColTotal, iDelta, false, bRoundNumbers);
		}
		else if(oColData['record']['operation_subtract'] == true){
			iColTotal = _fnAddNumbers(iColTotal, iDelta, true, bRoundNumbers);
		}
		else if(oColData['record']['operation_multiply'] == true){
			iColTotal = _fnMultiplyNumbers(iColTotal, iDelta, false, false);
		}
		else if(oColData['record']['operation_divide'] == true){
			iColTotal = _fnMultiplyNumbers(iColTotal, iDelta, true, false);
		}

		return iColTotal;
	}

	function _fnAggregateByTotalGroupId(sTotalGroupId, aoRecords, asRowIds, aoPeriods){
		var r = SpreadStatement.aggregateByTotalGroup(
				[],
				aoRecords,
				asRowIds,
				aoPeriods);
		return r[sTotalGroupId];
	}
	
	// function pointers (overridden by _fnInit)
	function _fnAddNewPeriod(sYears) {}
	function _fnSelectYearsForAll(aiYears){}
	function _fnIncrementRecordCounter(iCounter){}
	function _fnIncrementGroupCounter(iCounter){}
	function _fnUpdateRecordCell(bUpdateTotalColumns, updateObj){}
	function reset(oInitProps, that) {
		_fnInit(oInitProps, that);
	}

	function _fnGetRecordVal(element){
		var aoRecord = _fnFindRecord(element.parent().attr('id'));
		var record = LifeCycle.SpreadData.lookupRecordById(aoRecord[0].record.id);
		var period = LifeCycle.SpreadData.lookupPeriodByLookupKey(element.attr('id').split('_').shift(), {
			array: record.recordTotal.statement.periods()
		});
		return LifeCycle.SpreadData.lookupRecordValueByRecordAndPeriod(record, period, false);
	}

	_fnInit(oInit, this);
}

SpreadStatement.aggregateByTotalGroup = function(
		asStatementTotalMapKeys, 
		aoRecords, 
		asRowIds, 
		aoPeriods){

	var aoStatementTotalMap = {};
	asStatementTotalMapKeys = asStatementTotalMapKeys || [];
	var iCounter = 0;
	
	for ( var i = 0; i < aoRecords.length; i++) {
		
		var sCurrent = aoRecords[i]['record']['total_group_id'];
		if (asStatementTotalMapKeys.indexOf(sCurrent) < 0) {
			asStatementTotalMapKeys.push(sCurrent);
		}
		var aoCurrentMap = aoStatementTotalMap[sCurrent];
		if (aoCurrentMap == null) {
			aoCurrentMap = {
				id : sCurrent,
				name : aoRecords[i]['record']['total_group_name'],
				isSummaryGroup: aoRecords[i]['record']['total_group_is_summary_group'],
				title : aoRecords[i]['record']['total_group_title'],
				debit : aoRecords[i]['record']['total_group_debit'],
				include_in_total : aoRecords[i]['record']['total_group_include_in_total'],
				hideAllRecords : aoRecords[i]['record']['total_hide_all_records'],
				hideCurrencySymbol: aoRecords[i]['record']['total_hide_currency_symbol'],
				hideColumnTotals: aoRecords[i]['record']['total_hide_column_totals'],
				totalType: aoRecords[i]['record']['total_total_type'],
				records : [],
				asRowIds : [],
				aoPeriods : aoPeriods
			};
			aoStatementTotalMap[sCurrent] = aoCurrentMap;
		}

		var iRowId = asRowIds.indexOf(aoRecords[i]['record']['id']);
		if (iRowId >= 0 && aoCurrentMap.asRowIds.indexOf(aoRecords[i]['record']['id']) < 0) {
			aoCurrentMap.asRowIds.push(aoRecords[i]['record']['id']);
		}

		aoCurrentMap.records.push(aoRecords[i]);

	}
	return aoStatementTotalMap;
};

SpreadStatement.initTable = function (
	statementId,
	nAttachTo,
	aoRecords,
	bReset,
	aoSpreadStatementContainer,
	asSpreadStatementContainerKey,
	asRowIds,
	aoPeriods,
	sTotalRowName,
	bConfigurable,
	bEditable,
	bColumnSourceEditable,
	sInteraction,
	sGridControlWidget,
	fnResetVars,
	fnLoadPeriodTotals,
	fnAddNewPeriodProxy,
	fnSetRecordCounter,
	fnSetGroupCounter,
	fnSetSelectedYears,
	bTotalOnly,
	bGroupColumns,
	bBalanceTotals,
	bDateAppColumns,
	bEnableExpansionArrows,
	bFiltering,
	aiCurrentYears,
	aiAllowedPeriod,
	bIsTemplate,
	sGridControlTemplate,
	updateRecordCell,
	fnGetRemoteData,
	setupLinkedRecords,
	fnGetLinkedFields,
	fnShowHideRecordInGrandTotal,
	fnNotifySourceRecordUpdated,
	fnNotifySourceRecordTotalUpdated,
	fnGetStatementLinkedRecordValues,
	fnGetStatementLinkedRecordGroups,
	spreadId,
	unlinkRecords,
	isCommonSizingOptional,
	updateCommonSizingValue,
	isTrendOptional,
	updateTrendValue,
	accumulateRecordGroups,
	datePickerApp,
	trailingTwelveMonthApp,
	navApp,
	fnInSourceRecordIdMap,
	fnSetSuppressReDraw,
	typeOfStatement,
	spreadConfigApp,
	getSourceRecordIdMap,
	getDebtServiceRecordIdMap,
	getAnnualIncomeRecordIdMap,
	bIsChartOfAccountEditable,
	fnGetIForceVM,
	updateTableCell,
	deferredSheetTables,
	deferredDraw,
	isDrawDeferred,
	editIcon,
	renderingService
){
	
	var asStatementTotalMapKeys = [];

	var aoStatementTotalMap = SpreadStatement.aggregateByTotalGroup(
			asStatementTotalMapKeys, 
			aoRecords, 
			asRowIds,
			aoPeriods);

	var bShowTotalsGrid = sTotalRowName != null && sTotalRowName.length > 0 ? true : false;

	for ( var i = 0; i < asStatementTotalMapKeys.length; i++) {
		if (asSpreadStatementContainerKey
				.indexOf(asStatementTotalMapKeys[i]) < 0) {
			asSpreadStatementContainerKey
					.push(asStatementTotalMapKeys[i]);
		}

		var aoCurrentMap = aoStatementTotalMap[asStatementTotalMapKeys[i]];
		
		jQuery('.' + asStatementTotalMapKeys[i]).remove();

		var oSpreadStatement = aoStatementTotalMap[asStatementTotalMapKeys[i]];

		jQuery('<div data-bind="stopBinding:true" class="' + asStatementTotalMapKeys[i] + ' spreads_container_display" style="clear:both;">'
				+ '<div class="separator_div"></div><div class="spread_total_container">'
				+ '<div class="spread_total_container">'
				+ '<table class="spread_table table table-condensed" id="' + asStatementTotalMapKeys[i]
				+ '"><thead></thead><tbody></tbody></span><tfoot></tfoot></table></div></div>'
				+ '<div class="spread_grid_div_separator"></div>') 
				.appendTo(nAttachTo);

		var bIsSummaryGroup = bShowTotalsGrid && aoCurrentMap.isSummaryGroup;
		var oInit = {
			'statementId' : statementId,
			'recordTotalId' : asStatementTotalMapKeys[i],
			'config': aoCurrentMap,
			'aoRecords' : aoCurrentMap.records,
			'aoPeriods' : aoCurrentMap.aoPeriods,
			'asRowIds' : aoCurrentMap.asRowIds,
			'msgs' : msgs,
			'nTable' : jQuery('#' + asStatementTotalMapKeys[i])[0],
			'nContainer' : jQuery('#' + asStatementTotalMapKeys[i]).parent()[0],
			'nAttachTo' : nAttachTo,
			'sTotalRowName' : aoCurrentMap.name,
			'sAccountTitle' : aoCurrentMap.title,
			'addNewPeriod' : fnAddNewPeriodProxy,
			'incrementRecordCounter' : fnSetRecordCounter,
			'incrementGroupCounter' : fnSetGroupCounter,
			'selectYearsForAll' : fnSetSelectedYears,
			'iFutureYears' : 1,
			'iPastYears' : 20,
			'jQuery' : jQuery,
			'haml' : Haml,
			'bCurrencyPeriodValues' : true,
			'bDisplayControlWidget' : i == 0 && !bTotalOnly && bGroupColumns,
			'bSyncAllGrids' : true,
			'bUpdateTotalColumns' : !bIsSummaryGroup,
			'bIsSummaryGroup' : bIsSummaryGroup,
			'bConfigurable' : bConfigurable && !bTotalOnly,
			'bColumnSourceEditable' : bColumnSourceEditable,
			'bEditable' : bEditable && !(bIsSummaryGroup && asStatementTotalMapKeys.length > 1) && !bIsTemplate,
			'bJQueryUI' : false,	// do not use jQuery ThemeRoller
			'sInteraction' : sInteraction,
			'sSpreadControlWidgetTemplate' : sGridControlTemplate,
			'bGroupColumns': bGroupColumns,
			'bBalanceTotals': bIsSummaryGroup && bBalanceTotals,
			'bDateAppColumns': bDateAppColumns,
			'bEnableExpansionArrows': bEnableExpansionArrows,
			'aiCurrentYears':  aiCurrentYears,
			'aiAllowedPeriod': aiAllowedPeriod,
			'updateRecordCell': updateRecordCell,
			'showHideRecordInGrandTotal': fnShowHideRecordInGrandTotal,
			'notifySourceRecordUpdated': fnNotifySourceRecordUpdated,
			'notifySourceRecordTotalUpdated': fnNotifySourceRecordTotalUpdated,
			'getLinkedRecordValues': fnGetStatementLinkedRecordValues,
			'getLinkedRecordGroups': fnGetStatementLinkedRecordGroups,
			'getRemoteRecordValues': LifeCycle.SpreadsService.retrieveIForce,
			'getRemoteRecordGroups': LifeCycle.Spreads.getRemoteRecordGroups,
			'getRemoteTotals': SpreadStatement._getRecordTotals,
			'addSpreadStatementRecord' : LifeCycle.Spreads.addSpreadStatementRecord,
			'updateIncludeInTotal' : LifeCycle.Spreads.updateIncludeInTotal,
			'getSpreadStatementRecords' : LifeCycle.Spreads.getSpreadStatementRecords,
			'registerStatement' : LifeCycle.Spreads.registerStatement,
			'linkSpreadRecord' : LifeCycle.Spreads.linkSpreadRecord,
			'getLinkedFields' : fnGetLinkedFields || SpreadStatement.retrieveSpreadStatementsInSameBundle, 
			'updateSpreadOperation' : LifeCycle.Spreads.updateSpreadOperation, 
			'getTotalRecord' : SpreadStatement.retrieveTotalRecord, 
			'saveIForceRecord' : LifeCycle.SpreadsService.saveIForce,
			'bTotalOnly' : bTotalOnly,
			'setupLinkedRecords' : setupLinkedRecords,
			'unlinkRecords': unlinkRecords,
			'isCommonSizingOptional': isCommonSizingOptional,
			'isTrendOptional': isTrendOptional,
			'updateTrendValue': updateTrendValue,
			'bAccumulateRecordGroups' : accumulateRecordGroups,
			'datePickerApp' : datePickerApp,
			'trailingTwelveMonthApp' : trailingTwelveMonthApp,
			'navApp' : navApp,
			'inSourceRecordIdMap' : fnInSourceRecordIdMap,
			'setSuppressReDraw': fnSetSuppressReDraw,
			'typeOfStatement': typeOfStatement,
			'spreadConfigApp': spreadConfigApp,
			'getSourceRecordIdMap': getSourceRecordIdMap,
			'getDebtServiceRecordIdMap': getDebtServiceRecordIdMap,
			'getAnnualIncomeRecordIdMap': getAnnualIncomeRecordIdMap,
			'bIsChartOfAccountEditable': bIsChartOfAccountEditable,
			'fnGetIForceVM': fnGetIForceVM,
			'bHideColumnTotals': aoCurrentMap.hideColumnTotals,
			'deferredSheetTables': deferredSheetTables,
			'deferredDraw': deferredDraw,
			'isDrawDeferred': isDrawDeferred,
			'editIcon': editIcon,
			'renderingService': renderingService,
			'getRemoteData': fnGetRemoteData
		};

		oSpreadStatement = new SpreadStatement(oInit);

		aoSpreadStatementContainer[asStatementTotalMapKeys[i]] = oSpreadStatement;

		if (!aoCurrentMap.include_in_total) {
			jQuery('#'+aoCurrentMap.id+'_wrapper').hide();
		}

		if (bReset) {
			fnResetVars();
		}
		if (bShowTotalsGrid) {
			// fnLoadPeriodTotals();
		}
		
		if(!bTotalOnly) {
			SpreadStatement.addGroupConfigWidget(
				nAttachTo,
				statementId,
				bConfigurable,
				LifeCycle.SpreadsService.saveIForce,
				SpreadStatement._getRecordTotals,
				LifeCycle.Spreads.addSpreadStatementRecordTotal,
				fnGetRemoteData,
				fnShowHideRecordInGrandTotal,
				bDateAppColumns,
				datePickerApp,
				navApp);
		}

		if(bDateAppColumns){
			if(_.isFunction(datePickerApp.viewModel.enableSave)){
				datePickerApp.viewModel.enableSave();
			}
		}

	}

	return aoSpreadStatementContainer;
};

SpreadStatement._getStatement = function (statementId, success, failure, forceReload) {
	var app = new LifeCycle.App();

	function _statementCallback (statement) {
		if (success) {
			success(statement);
			success = undefined;
		}
	}

	LifeCycle.SpreadData.getStatementById(statementId, {alwaysLoadNewer: forceReload}, function () {
		_statementCallback(LifeCycle.SpreadData.lookupStatementById(statementId));
	});
};

SpreadStatement._getRecordTotals = function (statementId, success, failure, forceReload) {
	SpreadStatement._getStatement(statementId,function (statement) {
		if (success) {
			success(statement.recordTotals());
			success = undefined;
		}
	}, failure);
};

SpreadStatement._getLinkedRecordValues = function (statementId, bTotalOnly, aiSelectedYears, success, failure, forceReload) {
	// linked record: [values]
	var app = new LifeCycle.App();

	function _recordTotalsCallback (statement) {
		// Statement is ready
		var linkedRecords = {};
		for (var rt = 0; rt < statement.recordTotals().length; rt++) {
			var recordTotal = statement.recordTotals()[rt];
			for (var r = 0; r < ko.unwrap(recordTotal.records).length; r++) {
				var record = recordTotal.records()[r];
				if (record.isLinked()) {
					for (var v = 0; v < ko.unwrap(record.recordValues || []).length; v++) {
						var value = record.recordValues()[v];
						if (!linkedRecords[_18Id(record.recordId())]) {
							linkedRecords[_18Id(record.recordId())] = [];
						}

						linkedRecords[_18Id(record.recordId())].push(value);
					}
				}
			}
		}
		if (success) {
			success(linkedRecords);
			success = undefined;
		}
	}

	LifeCycle.SpreadData.getStatementById(statementId, {alwaysLoadNewer: forceReload}, function () {
		_recordTotalsCallback(LifeCycle.SpreadData.lookupStatementById(statementId));
	});
};

SpreadStatement.aRecordTotals = [];

SpreadStatement.addGroupConfigWidget = function (nAttachTo,
												  sStatementId,
												  bConfigurable,
												  fnUpdateGroupIncludeInTotal,
												  fnGetRecordTotals,
												  fnAddSpreadStatementRecordTotal,
												  fnGetRemoteData,
												  fnShowHideRecordInGrandTotal,
												  bDateAppColumns,
												  datePickerApp,
												  navApp) {

	var sMultiselect = sStatementId + '_multiselect';
	var nMultiselect = '.'+sMultiselect;
	var sDialog = sStatementId + '_dialog';
	var nDialog = '.'+sDialog;

	fnGetRecordTotals(
		sStatementId,
		function(aRecordTotals){
			_fnPopulateDropdowns(nAttachTo, aRecordTotals, nDialog);

			if (bConfigurable) {
				_fnBuildSpreadGroupMultiselect(
					nAttachTo,
					sMultiselect,
					bConfigurable,
					datePickerApp,
					navApp);

				SpreadStatement.aRecordTotals = aRecordTotals;
				
				//bind click action to open dialog for adding new group
				jQuery(nMultiselect).find('div.action_item_new_group').click(function() {
					if (spreadStatementInstance.navApp.viewModel.savePending()) {
						spreadStatementInstance.promptSave();
					} else {
						var select = jQuery(nAttachTo).find('.group_selector select');
						if (select.multiselect('isOpen')) {
							select.multiselect('close');
						}
						jQuery(nAttachTo).find('#add_new_group').modal();
					}
				});
			}
		},
		SpreadStatement.handleError
	);

	if (bConfigurable && jQuery(nAttachTo).find('#header_bar div.group_selector button').length == 0) {
		jQuery(nAttachTo).find('#header_bar').append(jQuery(nAttachTo).find('.group_control_container').html());
		jQuery(nAttachTo).find('.group_control_container').remove();

		if (bConfigurable) {
	
			var validator = _fnSetAddSpreadGroupSubmitAction(sStatementId, nDialog);
			jQuery.validator.addMethod(
				"uniqueGroupName", 
				function(value, element) {
					var toRet = true;
					_.each(SpreadStatement.aRecordTotals, function(total){
						if (value == total.name()){
							toRet = false;
						}
					});
					return toRet;
				}, 
				msgs.msg_spreads_validation_group_name
			);
			jQuery.validator.addMethod(
				"uniqueGroupTitle", 
				function(value, element) {
					var toRet = true;
					_.each(SpreadStatement.aRecordTotals, function(total){
						if (value == total.title()){
							toRet = false;
						}
					});
					return toRet;
				}, 
				msgs.msg_spreads_validation_group_title
			);
			jQuery.validator.addMethod(
				"uniqueGlobalAnalysisType", 
				function(value, element) {
					var toRet = true;
					if (!_.isUndefined(value) && value != '' && 
						(value == msgs.msg_global_analysis_type_cash_flow || 
						value == msgs.msg_global_analysis_type_debt_service)) {
						_.each(SpreadStatement.aRecordTotals, function(total){
							if (value == total.globalAnalysisType()){

								toRet = false;
							}
						});
					}
					return toRet;
				},
				msgs.msg_group_already_exists_with_global_analysis_type
			);

			jQuery(nAttachTo).find('div#add_new_group input[name="cancel"]').click(function(e) {
				jQuery(nAttachTo).find('select[name="classifications_sel"]').val('').trigger('chosen:updated');
				jQuery(nAttachTo).find('div#add_new_group').find('form')[0].reset(); // reset form fields
				jQuery(nAttachTo).find('div#add_new_group').find('.control-group').removeClass("error");
				validator.resetForm(); // reset validation errors
				jQuery(nAttachTo).find('div#add_new_group').modal('hide');
			});
		}else{
			fnGetRecordTotals(
				sStatementId,
				function(aRecordTotals){
					for(var i=0;i<=aRecordTotals.length;i++){
						if(aRecordTotals[i].includeInTotal() == true){
							datePickerApp.viewModel.headerRecordTotalId(aRecordTotals[i].recordId());
							break;
						}
					}
				},
				SpreadStatement.handleError
			);
			
			_fnBuildSpreadGroupMultiselect(
				nAttachTo,
				sMultiselect,
				bConfigurable,
				datePickerApp,
				navApp);
		}
	} else if (bConfigurable) {
		//refresh dropdowns to show newly added group
		fnGetRecordTotals(
			sStatementId,
			function(aRecordTotals){
				_fnPopulateDropdowns(nAttachTo, aRecordTotals, nDialog);
				SpreadStatement.aRecordTotals = aRecordTotals;
				jQuery(nAttachTo).find('.group_selector select').multiselect('refresh');
			},
			SpreadStatement.handleError
		);
	}

	function _fnPopulateDropdowns(nAttachTo, aRecordTotals, nDialog) {
		jQuery(nAttachTo).find('div#add_new_group select[name="group_order"]').empty();
		jQuery(nAttachTo).find('.group_selector select[name="group_display"]').empty();

		for(var i=0;i<aRecordTotals.length;i++){
			jQuery(nAttachTo).find('div#add_new_group select[name="group_order"]')
				.append(jQuery('<option></option>')
				.attr('value', aRecordTotals[i].rowNumber())
				.text(aRecordTotals[i].title()));
			
			if (aRecordTotals[i].includeInTotal()) {
				jQuery(nAttachTo).find('.group_selector select[name="group_display"]')
					.append(jQuery('<option></option>')
					.attr('value', aRecordTotals[i].recordId())
					.attr('selected', 'selected')
					.text(aRecordTotals[i].title()));
			} else {
				jQuery(nAttachTo).find('.group_selector select[name="group_display"]')
					.append(jQuery('<option></option>')
					.attr('value', aRecordTotals[i].recordId())
					.text(aRecordTotals[i].title()));
			}
		}

		var chartTypeSel = jQuery(nAttachTo).find('div#add_new_group select[name="chart_type"]');
		chartTypeSel.change(function(e) {
			var chartDebitSel = jQuery(nAttachTo).find('div#add_new_group select[name="chart_debit"]');
			if (chartTypeSel.val() == 'Standard') {
				chartDebitSel.prop('disabled', false);
			} else {
				chartDebitSel.prop('disabled', 'disabled');
			}
		});

		var statement = LifeCycle.SpreadData.lookupStatementById(navApp.viewModel.statement().recordId());
		var classificationRequired = (statement.isIncomeStatement() || statement.isBalanceSheet());
		var classificationsSel = jQuery(nAttachTo).find('div#add_new_group select[name="classifications_sel"]');
		if (classificationRequired) {
			if (classificationsSel.length) {
				classificationsSel.find('option').remove();
				var availableClassifications = LifeCycle.SpreadData.lookupClassificationsByFilter(function () { return true; });
				for (var i = 0; i < availableClassifications.length; i++) {
					var classification = availableClassifications[i];
					classificationsSel.append('' +
						'<option value="' + classification.recordId() + '">' +
						classification.name() + ' (' + classification.category() + ')' +
						'</option>'
					);
				}
				classificationsSel.chosen({
					width: '190px'
				}).change(function() {
					classificationsSel.trigger('chosen:updated');
					classificationsSel.valid();
				});
			}
		} else {
			classificationsSel.closest('.control-group').remove();
		}

		//show the header only on the top record total
		if(bDateAppColumns){
			var checked = jQuery(nAttachTo).find('.group_selector').find('select').val();
			if(typeof datePickerApp.viewModel != 'undefined' && checked != null && checked.length > 0){
				datePickerApp.viewModel.headerRecordTotalId(checked[0]);
			}
		}
	}

	function _fnBuildSpreadGroupMultiselect(
			nAttachTo,
			sMultiselect,
			bConfigurable,
			datePickerApp,
			navApp) {

		var selector = jQuery(nAttachTo).find('.group_selector');
		if(bConfigurable){
			selector.find('button:nth-child(3)').hide();
			selector.find('select').multiselect({
				header: false,
				selectedText: function(selectedCount, totalCount, nElem) {
					return msgs.msg_spreads_configure_groups;
				},
				minWidth : 'auto',
				multiple : true,
				classes : sMultiselect,
				show: ['scale', 200],
				hide: ['scale', 200],
				click: function(event, ui) {
					_fnUpdateIncludeGroupInTotal(sStatementId, ui);
					navApp.viewModel.toggleRecordTotalDisplay(ui.value, ui.checked);
				
					if(typeof fnShowHideRecordInGrandTotal != 'undefined'){
						fnShowHideRecordInGrandTotal(ui.text, ui.checked);
					}

					// determine which is the top most selected record total and enable the header
					var selectElement = jQuery(nAttachTo).find('.group_selector').find('select');
					var checked = selectElement.val();
					var highestCheckedRecordId = null;

					if(ui.checked){
						// build up a list with all possible select options
						var possibleSelectOptions = [];
						selectElement.find('option').each(function(){
							possibleSelectOptions.push(jQuery(this).val());
						});

						var newlyCheckedIndex = possibleSelectOptions.indexOf(ui.value);
						var currentSelectedIndex = null;

						if(checked != null && checked.length > 0){
							currentSelectedIndex = possibleSelectOptions.indexOf(checked[0]);
							highestCheckedRecordId = newlyCheckedIndex < currentSelectedIndex ? ui.value : checked[0];
						}else{
							highestCheckedRecordId = ui.value;
						}
					}else{
						var index = checked.indexOf(ui.value);
						checked.splice(index, 1);
						highestCheckedRecordId = checked[0];
					}
					if(highestCheckedRecordId != null){
						//show the header only on the top record total
						datePickerApp.viewModel.headerRecordTotalId(highestCheckedRecordId);
					}
				}
			}).multiselectfilter({label: msgs.msg_spreads_search});

			//add 'add new group' control to multiselect
			if(jQuery('.action_item_new_group').length < 2){
				jQuery(nMultiselect)
					.find('.ui-multiselect-header')
					.after(jQuery(nAttachTo).find('div.add_group').html());
			}
		}else{
			selector.find('select').multiselect({
				header: false,
				classes: sMultiselect
			});
			selector.find('button.ui-multiselect span').not('.ui-icon')
					.html(msgs.msg_spreads_configure_groups);
			SpreadStatement.disableMultiselectButton(selector);
		}
		SpreadStatement.styleMultiselectButton(selector);
	}

	function _fnSetAddSpreadGroupSubmitAction(sStatementId, nDialog) {
		var statement = LifeCycle.SpreadData.lookupStatementById(sStatementId);
		var classificationRequired = (statement.isIncomeStatement() || statement.isBalanceSheet());
		var elem =
			jQuery(nAttachTo).find('div#add_new_group form').validate({
				rules: {
					group_total_name: {
						required: true,
						uniqueGroupName: true
					},
					group_title: {
						required: true,
						uniqueGroupTitle: true
					},
					global_analysis_type: {
						required: false,
						uniqueGlobalAnalysisType: true
					},
					chart_name: "required",
					classifications_sel: {
						required: classificationRequired
					}
				},
				ignore: ":hidden:not(#classifications_sel)",
				errorClass: "text-error",
				highlight: function(element) {
					jQuery(element).closest('.control-group').addClass('error');
				},
				success: function(element) {
					element.closest('.control-group').removeClass('error');
				},
				submitHandler: function(form) {
					var spreadTotalName = jQuery(form).find('input[name="group_total_name"]').val();
					var spreadTotalTitle = jQuery(form).find('input[name="group_title"]').val();
					var isDebitTotal = jQuery(form).find('select[name="group_debit"]').val();
					var spreadTotalRow = jQuery(form).find('select[name="group_order"]').val();
					var spreadRecordName = jQuery(form).find('input[name="chart_name"]').val();
					var chartRecordType = jQuery(form).find('select[name="chart_type"]').val();
					var isDebitRecord = jQuery(form).find('select[name="chart_debit"]').val();
					var groupType = jQuery(form).find('select[name="group_type"]').val();
					var globalAnalysisType = jQuery(form).find('select[name="global_analysis_type"]').val();
					var hideColumnTotals = jQuery(form).find('input[name="hide_column_totals"]').is(':checked');
					var classificationIds = jQuery(form).find('select[name="classifications_sel"]').val() || [];
					form.reset();
					jQuery(form).find('select[name="classifications_sel"]').val('').trigger('chosen:updated');
					jQuery(nAttachTo).find('div#add_new_group').modal('hide');
	
					fnAddSpreadStatementRecordTotal(
						sStatementId,
						spreadTotalName,
						spreadTotalTitle,
						isDebitTotal,
						spreadTotalRow,
						spreadRecordName,
						chartRecordType,
						isDebitRecord,
						groupType,
						globalAnalysisType,
						hideColumnTotals,
						classificationIds,
						function(){
							fnGetRemoteData(true);
						},
						SpreadStatement.handleError
					);
				}
			});
		
		return elem;
	}
	
	function _fnUpdateIncludeGroupInTotal(sStatementId, ui) {
		jQuery(nAttachTo).find('#'+ui.value+'_wrapper').toggle();
		SpreadStatement.retrieveTotalRecord(
			sStatementId,
			ui.value,
			function(totalRec) { 
				//update HideAllRecords value
				totalRec.includeInTotal = ui.checked;
				// save total record
				fnUpdateGroupIncludeInTotal(
					totalRec,
					function(){},
					SpreadStatement.handleError
				);
			}
		);
	}
};

SpreadStatement.RecordType = function() {
	var self = this;
	var DAYS_IN_PERIOD = 'Days In Period';
	var RENT_ROLL_ANNUAL_INCOME = 'Rent Roll Annual Income';
	var DEBT_SERVICE = 'Debt Service';
	var READ_ONLY = 'Read Only';
	var SIMULATED = 'Simulated';
	var STANDARD = 'Standard';
	var PROTECTED_TYPES = [DAYS_IN_PERIOD, DEBT_SERVICE, READ_ONLY, SIMULATED, RENT_ROLL_ANNUAL_INCOME];
	self.isDaysInPeriod = function(test) {
		return test == DAYS_IN_PERIOD;
	};
	self.isDebtService = function(test) {
		return test == DEBT_SERVICE;
	};
	self.isRentRollAnnualIncome = function(test) {
		return test == RENT_ROLL_ANNUAL_INCOME;
	};
	self.isProtected = function(test) {
		return _.contains(PROTECTED_TYPES, test);
	};
	self.isReadOnly = function(test) {
		return test == READ_ONLY;
	};
	self.isStandard = function(test) {
		return test == STANDARD;
	};
	self.isSimulated = function(test) {
		return test == SIMULATED;
	};
	return self;
}();

SpreadStatement.PeriodType = function(){
	var self = this;
	var STANDARD = 'Standard';
	self.isReadOnly = function(test){
		return test != STANDARD && test;
	}
	return self;
}();

SpreadStatement.handleError = function(result){
	console.log('error');
	console.log(result);
};

SpreadStatement.styleMultiselectButton = function(nActionElem) {
	jQuery(nActionElem)
		.find('button.ui-multiselect')
		.removeClass('ui-widget ui-corner-all')
		.css('width', '220px')
		.css('font-size', '1em')
		.css('font-weight', 'bold')
		.css('cursor', 'pointer');
	jQuery(nActionElem)
		.find('span.ui-icon-triangle-2-n-s')
		.removeClass('ui-icon-triangle-2-n-s')
		.addClass('ui-icon-gear');
};

SpreadStatement.disableMultiselectButton = function(nActionElem) {
	jQuery(nActionElem).find('select').multiselect('disable');
	jQuery(nActionElem).find('button.ui-multiselect').attr('disabled', null).tooltip({
		placement: 'right',
		title: msgs.msg_permission_not_met
	});
};

SpreadStatement.findRecordGroupIndex = function (oRecord, oPeriod, isQuarter, aoRecordGroups){
	for(var i=0;i<aoRecordGroups.length;i++){
		var aoRecordGroup = aoRecordGroups[i];
		if(aoRecordGroup['record'] == oRecord['id'] &&
			aoRecordGroup['year'] == oPeriod['year']){
			if(isQuarter && aoRecordGroup['quarter'] == Utils.getQuarter(oPeriod['month'])){
				return i;
			}
			else if(!isQuarter && aoRecordGroup['quarter'] == 0){
				return i;
			}
		}
	}
	return -1;
};
SpreadStatement.parseOptionTreeFromEntityValues = function(aoEntityValues) {
	var oTree = {};
	
	for (var i=0;i<aoEntityValues.length;i++) {
		var oEntityNode = {};
		var oCurrentInvolvement = aoEntityValues[i];
		var aoSpreadStatements = oCurrentInvolvement.statements;

		for (var k=0;k<aoSpreadStatements.length;k++) {
			var oStatementNode = {};

			var oCurrentSpreadStatement = aoSpreadStatements[k];

			var aoSpreadStatementRecordTotals = oCurrentSpreadStatement.recordTotals;
			for (var l=0;l<aoSpreadStatementRecordTotals.length;l++) {
				var oRecordTotalNode = {};
				var oCurrentSpreadStatementRecordTotal = aoSpreadStatementRecordTotals[l];
				var aoSpreadStatementRecords = oCurrentSpreadStatementRecordTotal.records;

				for (var n=0;n<aoSpreadStatementRecords.length;n++) {
					var oCurrentSpreadStatementRecord = aoSpreadStatementRecords[n];
					oRecordTotalNode[oCurrentSpreadStatementRecord.name] = oCurrentSpreadStatementRecord.recordId;
				}
				oRecordTotalNode[oCurrentSpreadStatementRecordTotal.name] = oCurrentSpreadStatementRecordTotal.recordId;
				oStatementNode[oCurrentSpreadStatementRecordTotal.title] = oRecordTotalNode;
			}
			oEntityNode[oCurrentSpreadStatement.statementType] = oStatementNode;
		}
		oTree[oCurrentInvolvement.relationship.name] = oEntityNode;
	}
	return oTree;
};
SpreadStatement.parseRecordsFromIForceObjects = function(iForceStatement, aoRecords, aoPeriods, asRowIds, aiSelectedYears, asSourceRecordIds, bShowTotalOnly, bStaticPeriods, debtServiceRecordIdMap){
	var sTotalRowName = null;
	var totals = [];
	if(iForceStatement != null && iForceStatement.recordTotals != null && ko.unwrap(iForceStatement.recordTotals).length > 0){
		sTotalRowName = ko.unwrap(iForceStatement.totalRowName);
		if(!_.isUndefined(bShowTotalOnly) && bShowTotalOnly == true){
			_.each(ko.unwrap(iForceStatement.recordTotals), function(recordTotal){
				if (ko.unwrap(recordTotal.isSummaryGroup) == bShowTotalOnly) {
					totals.push(recordTotal);
				};
			});
		}

		_.each(ko.unwrap(iForceStatement.recordTotals), function(recordTotal) {
			var oRecords = SpreadStatement.mapFromIForceRecordTotalObject(recordTotal, aiSelectedYears, aoPeriods, asSourceRecordIds, bStaticPeriods, debtServiceRecordIdMap);
			_.each(oRecords, function(oRecord){
				aoRecords.push(oRecord);

				if (asRowIds.indexOf(oRecord['record']['id']) < 0) {
					asRowIds.push(oRecord['record']['id']);
				}

			});
		});
	}
	return sTotalRowName;
};

SpreadStatement.mapFromIForcePeriod = function(period){
	var app = new LifeCycle.App();
	// var period = app.mapToJS(koPeriod);
	return {
		recordId: ko.unwrap(period.recordId),
		id: ko.unwrap(period.lookupKey),
		statementId: ko.unwrap(period.statementId),
		accumulates: ko.unwrap(period.accumulates),
		statementDate: ko.unwrap(period.statementDate),
		analystName: ko.unwrap(period.analystName),
		analyst: ko.unwrap(period.analyst),
		year: ko.unwrap(period.year),
		month: ko.unwrap(period.month),
		nameOverride: ko.unwrap(period.nameOverride),
		numberOfPeriods: ko.unwrap(period.numberOfPeriods),
		isFiscalYear: ko.unwrap(period.isFiscalYear),
		source: ko.unwrap(period.source),
		columnNumber: ko.unwrap(period.columnNumber),
		periodKey: ko.unwrap(period.periodKey),
		selected : ko.unwrap(period.selected),
		lookupKey: ko.unwrap(period.lookupKey)
	};
};

SpreadStatement.mapFromIForceRecordTotalObject = function(koRecordTotal, aiSelectedYears, aoPeriods, asSourceRecordIds, bStaticPeriods, debtServiceRecordIdMap){
	var oRecords = [];
	var periodIds = [];
	aiSelectedYears.sort();
	var yearGroupIds = [];


	var app = new LifeCycle.App();
	var recordTotal = app.mapToJS(koRecordTotal, {
		useOptimizedMapper: true,
		maxDepth: 0,
		maxHeight: 0,
		allowedPaths: [
			'$root.records.linkedRecord'
		]
	});

	_.each(recordTotal.records, function(record){
		yearGroupId = Utils.generateUUID();
		var oRecord = {};
		oRecord['name'] = '';
		oRecord['value'] = null;
		oRecord['calculated'] = false;
		oRecord['isLinked'] = record.isLinked;
		oRecord['record'] = {
			id : record.recordId,
			name : record.name,
			debit : record.isDebit,
			displayType : record.displayType,
			operation: record.operation,
			operation_add: record.operation == 'ADD' ? true : false,
			operation_multiply: record.operation == 'MULTIPLY' ? true : false,
			operation_subtract: record.operation == 'SUBTRACT' ? true : false,
			operation_divide: record.operation == 'DIVIDE' ? true : false,
			include_in_total : record.includeInTotal,
			recordType: record.recordType,
			row : record.rowNumber,
			total_group_name: recordTotal.name,
			total_group_is_summary_group: recordTotal.isSummaryGroup,
			total_group_title:  recordTotal.title,
			total_group_debit:  recordTotal.isDebit,
			total_group_include_in_total:  recordTotal.includeInTotal,
			total_group_id:  recordTotal.recordId,
			total_group_row:  recordTotal.rowNumber,
			total_hide_all_records:  recordTotal.isHideAllRecords,
			total_hide_currency_symbol:  recordTotal.isHideCurrencySymbol,
			total_group_type: recordTotal.groupType,
			total_total_type: recordTotal.totalType,
			total_hide_column_totals: recordTotal.hideColumnTotals,
			total_userDefinedKPI: recordTotal.userDefinedKPI,
			total_kpiType: recordTotal.kpiType,
			total_publish_on_init_event: recordTotal.publishOnInitEvent,
			total_publish_on_update_event: recordTotal.publishOnUpdateEvent,
			period_over_period_change: record.periodOverPeriodChange,
			prior_fiscal_year: record.priorFiscalYear,
			userDefinedKPI: record.userDefinedKPI,
			kpiType: record.kpiType
		};

		oRecord['sourceRecord'] = {};
		ssTotalRegex = new RegExp("[\.]LifeCycleSpreadStatementTotal");
		ssRecordRegex = new RegExp("[\.]LifeCycleSpreadStatementRecord");
		if(typeof record.linkedRecord != 'undefined'){
			var sourceRecordId = record.linkedRecord['recordId'];
			if(ssRecordRegex.test(record.linkedRecord.apexType)){
				var recordType = record.linkedRecord['recordType'];
				oRecord['sourceRecord'] = {
					recordId : sourceRecordId,
					recordType: recordType
				};
			}else if(ssTotalRegex.test(record.linkedRecord.apexType)){
				var groupType = record.linkedRecord['groupType'];
				oRecord['sourceRecord'] = {
					totalGroupId : sourceRecordId,
					groupType: groupType
				};
			}
			if(!_.isUndefined(asSourceRecordIds)){
				if(_.isUndefined(asSourceRecordIds[sourceRecordId])){
					asSourceRecordIds[sourceRecordId] = [];
				}
				if(!_.contains(asSourceRecordIds[sourceRecordId], record.recordId)){
					asSourceRecordIds[sourceRecordId].push(record.recordId);
				}
			}
		}
		if (debtServiceRecordIdMap != undefined) {
			if (SpreadStatement.RecordType.isDebtService(oRecord.record.recordType)) {
				if (debtServiceRecordIdMap[recordTotal.recordId] == undefined) {
					debtServiceRecordIdMap[recordTotal.recordId] = [];
				}
				if(!_.contains(debtServiceRecordIdMap[recordTotal.recordId], oRecord.record.id)){
					debtServiceRecordIdMap[recordTotal.recordId].push(oRecord.record.id);
				}
			}
		}
		if (annualIncomeRecordIdMap != undefined) {
			if (SpreadStatement.RecordType.isRentRollAnnualIncome(oRecord.record.recordType)) {
				if (annualIncomeRecordIdMap[recordTotal.recordId] == undefined) {
					annualIncomeRecordIdMap[recordTotal.recordId] = [];
				}
				if(!_.contains(annualIncomeRecordIdMap[recordTotal.recordId], oRecord.record.id)){
					annualIncomeRecordIdMap[recordTotal.recordId].push(oRecord.record.id);
				}
			}
		}
		_.each(aoPeriods, function(period){

			var oRecordClone = jQuery.extend(true, {}, oRecord);
			oRecordClone['id'] = Utils.generateUUID();
			oRecordClone['period'] = SpreadStatement.mapFromIForcePeriod(period);
			oRecordClone['quarter_group'] = {};
			oRecordClone['year_group'] = {
				id: yearGroupId,
				name: '',
				quarter: 0,
				year: period.year,
				value: null,
				record: record.recordId,
				accumulate: false,
				nameOverride: ''
			};

			if(record.isLinked){
				oRecordClone['linkedRecord'] = {
						value: null,
						period_over_period_change: record.periodOverPeriodChange,
						prior_fiscal_year: record.priorFiscalYear,
						period: oRecordClone['period'],
						record: oRecordClone['record'],
						sourceRecord: { recordId: record.linkedRecord.recordId }
				};
			}

			oRecords.push(oRecordClone);
		});
	});
	return oRecords;
};
SpreadStatement.mergeRecordValuesIntoIForce = function(aoRecords, aoPeriods, iForces){
	aoRecordGroups = [];
	for (var i = 0; i < iForces.length; i++) {
		var record = iForces[i];
		var recordId = record.recordId;
		for (var j = 0; j < record.recordValues.length; j++) {
			var recordValue = record.recordValues[j];
			var value = recordValue.value;
			var periodKey = recordValue.period.periodKey;
			var recordValueKey = recordValue.lookupKey;
			
			for (var k = 0; k < aoRecords.length; k++) {
				var oRecord = aoRecords[k];
				if(oRecord.period.periodKey == periodKey) {
					if(oRecord.record.id == recordId){
						oRecord['id'] = recordValueKey;
						oRecord['value'] = value;
						oRecord['formula'] = recordValue.formula;
						oRecord['isLinked'] = recordValue.isLinked;
						oRecord['name'] = recordValue.name;
					}
				}
			}
		}
	}
};

SpreadStatement.determineAllowedPeriod = function(startYear, startMonth, endYear, endMonth){
	var yearArray = [];
	
	var current = startYear;
	do{
		yearArray.push(current++);
	}
	while(current <= endYear);
	
	var toRet = {
		'start': {'year': startYear, 'month': startMonth},
		'end': {'year': endYear, 'month': endMonth},
		'years': yearArray
	};
	return toRet;
};
/**
 * retrieve the statements that are in the same bundle
 * @param statementId the spread statement type id
 * @param callback function(statementlist){}
 */
SpreadStatement.retrieveSpreadStatementsInSameBundle = function(statementId, callback){
	var statement = LifeCycle.SpreadData.getStatementById(statementId);
	var app = new LifeCycle.App();
	LifeCycle.SpreadData.getEntireBundle(statement.bundle.recordId(), null, function(bundle){
		var mappedBundle = app.mapToJS(bundle, { useOptimizedMapper: true, maxDepth: 0,
			allowedPaths: ['$root.statements.recordTotals.records']});
		callback([{'relationship' : {'name': statement.bundle.name()}, 'statements': mappedBundle.statements}]);
	});
};

SpreadStatement.retrieveTotalRecord = function(statementId, totalId, callback){
	LifeCycle.SpreadsService.retrieveIForce({}, statementId, function(statement){
		if(statement.recordTotals && statement.recordTotals.length > 0){
			for (var i=0;i < statement.recordTotals.length;i++) {
				if (statement.recordTotals[i].recordId == totalId) {
					callback(statement.recordTotals[i]);
					break;
				}
			}
		}
	});
};	

SpreadStatement.hideSearch = function(nAttachTo) {
	jQuery(nAttachTo).find('.dataTables_filter').hide();
};

// Hook into module system
if( typeof module !== 'undefined') {
	module.exports = SpreadStatement;
}

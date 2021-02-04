function SpreadStatement(oInit) {

	// public variables
	this.bInitialized = false;
	this.bIsTotalsGrid = false;
	this.oInit = oInit;
	
	// public functions
	this.reset = reset;
	this.setSelectedYears = _fnSetSelectedYears;
	this.getSelectedYears = _fnGetSelectedYears;
	this.editPeriodData = _fnEditPeriodData;
	this.editGroupData = _fnEditGroupData;
	
	// private variables

	var jQuery = null;
	if( typeof oInit.jQuery != 'undefined') {
		jQuery = oInit.jQuery;
	}
	var KeyTable = null;
	if( typeof oInit.keyTable != 'undefined') {
		KeyTable = oInit.keyTable;
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
	var _nTable = null;
	var _nContainer = null;
	var msgs = null;
	var _sStatementId = null;
	var _spreadControlWidgetClass = 'spread_control_widget';
	var _sSpreadControlWidgetTemplate = null;
	var _iFutureYears = 0;
	var _iPastYears = 0;
	var _aiCurrentYears = [];
	var _bCurrencyPeriodValues = false;
	var _bDisplayControlWidget = false;
	var _bSyncAllGrids = false;
	var _bUpdateTotalColumns = false;
	var _bEditable = true;
	var _bFilter = true; 
	var _bJQueryUI = false;
	var _iRecordCounter = 0;
	var _iGroupCounter = 0;
	var _sInteraction = 'keyboard';

	function _fnInit(oInit, that) {

		if(_that != null) {
			_that.oInit = oInit;
		}
		_that = that;

		try {
			_anModifiedHeaders = [];
			_anModifiedFooters = [];
			_aoCategorizedCols = {};

			var aoRecords = [];
			var asColumnIds = [];
			var asRowIds = [];
			if( typeof oInit == 'undefined') {
				oInit = {};
			}

			if( typeof oInit.aoRecords != 'undefined') {
				oInit.aoRecords = Utils.cloneArray(oInit.aoRecords);
				aoRecords = oInit.aoRecords;
			}
			if( typeof oInit.asColumnIds != 'undefined') {
				oInit.asColumnIds = Utils.cloneArray(oInit.asColumnIds);
				asColumnIds = oInit.asColumnIds;
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
			
			if( typeof oInit.sTotalRowName != 'undefined') {
				_sTotalRowName = oInit.sTotalRowName;
			}

			if( typeof oInit.sAccountTitle != 'undefined') {
				_sAccountTitle = oInit.sAccountTitle;
			}

			if( typeof oInit.addNewPeriod != 'undefined') {
				_fnAddNewPeriod = oInit.addNewPeriod;
			}
			if( typeof oInit.updateRecordGroupVal != 'undefined') {
				_fnUpdateRecordGroupVal = oInit.updateRecordGroupVal;
			}
			if( typeof oInit.updateRecordPeriodVal != 'undefined') {
				_fnUpdateRecordPeriodVal = oInit.updateRecordPeriodVal;
			}
			if( typeof oInit.updateGroupTotal != 'undefined') {
				_fnUpdateGroupTotal = oInit.updateGroupTotal;
			}
			if( typeof oInit.updatePeriodTotal != 'undefined') {
				_fnUpdatePeriodTotal = oInit.updatePeriodTotal;
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
			if( typeof oInit.bCurrencyPeriodValues != 'undefined') {
				_bCurrencyPeriodValues = oInit.bCurrencyPeriodValues;
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
			
			if(typeof oInit.bFilter != 'undefined'){
				_bFilter = oInit.bFilter;
			}
			if(typeof oInit.bEditable != 'undefined'){
				_bEditable = oInit.bEditable;
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
			_aiCurrentYears = _fnReadSelectedYears();
			if(_aiCurrentYears == null || _aiCurrentYears.length == 0){
				_aiCurrentYears = [];
				_aiCurrentYears.push(new Date().getFullYear());
			} 

			try{
				_fnVerifyRecordIntegrity(aoRecords);
			}
			catch(error){
				_fnModifyYears(_aiCurrentYears, true);
				return;
			}
			_sortPeriods(asColumnIds, asRowIds, aoRecords);
			
			var aaData = _fnGenerateAaData(aoRecords, asRowIds, asColumnIds);
			
			_fnInsertPeriodGroups(aaData);
			_fnPadDataArray(aaData);
			

			_aoCategorizedCols = _fnCategorizeColumns(aaData);
			_aoDataMap = aaData;
			var aoColDefs = _fnGenerateColumnDefs(aaData);

			_oSheetTable = _fnCreateDataTable(
				_nTable, 
				_aoDataMap, 
				aoColDefs, 
				_aoCategorizedCols, 
				_anModifiedHeaders, 
				_anModifiedFooters, 
				_sTotalRowName,
				_sStatementId,
				_nContainer,
				_bDisplayControlWidget,
				_bFilter,
				_bJQueryUI,
				_sSpreadControlWidgetTemplate);

			if(_bEditable){
				var keys = null;
				if('keyboard' == _sInteraction){
					keys = new KeyTable({
						'table' : _nTable,
						'datatable' : _oSheetTable,
						'focusClass' : 'ui-state-highlight',
						'parentFocusClass' : 'ui-state-hover',
						'initScroll': false,
						'form': true
					});					
				}
				
				_fnEditableDataTable(keys, _oSheetTable, _nTable, _sInteraction);
			}

			_oSheetTable.fnFilterPeriods(
				_aoDataMap, 
				_aiCurrentYears, 
				_aoCategorizedCols,
				_bDisplayControlWidget,
				_bSyncAllGrids,
				false);
 
 			if(typeof oInit.bIsTotalsGrid != 'undefined'){
				_that.bIsTotalsGrid = oInit.bIsTotalsGrid; 
			}
			
 			_that.bInitialized = true;
			jQuery.unblockUI();
			
		} catch(ex) {
			console.log(ex);
			console.log(ex.stack);
			throw ex;
		} finally {
		}
	}

	function _fnCreateDataTable(
		nTable, 
		aaMap, 
		aoColDefs, 
		aoCategorizedCols, 
		anModifiedHeaders, 
		anModifiedFooters, 
		sTotalRowName,
		sStatementId,
		nContainer,
		bDisplayWidget,
		bFilter,
		bJQueryUI,
		sSpreadControlWidgetTemplate) {

		var aoColumns = [];
		for(var i=0;i<aoColDefs.length;i++){
			aoColumns.push({
				'sWidth' : aoColDefs[i]['sWidth']
			});
		}
		
		var oSheetTable = jQuery(nTable).dataTable({
			"bFilter": bFilter,
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
			 //"aaSortingFixed": [[0,'asc']],
			//"sScrollY": '100%',
			//"sScrollX": '100%',
			//"sScrollXInner": '2400px',
			"aaData" : aaMap,
			"fnDrawCallback" : function() {
				jQuery('.spreads_currency').formatCurrency();
				this.fnResizeTable(nContainer);
			},
			"fnInitComplete" : function() {
				var oTable = this;

				var html = Haml.render(sSpreadControlWidgetTemplate, {
					locals : {
						widget_class : _spreadControlWidgetClass,
						msgs : msgs,
						years : _fnGenerateAvailableYears(),
						statement : sStatementId
					}
				});
				
				var bCreate = bDisplayWidget;
					
				jQuery(nTable).parent().prepend(html);
				
				jQuery(nTable).parent().find('.year_selector select').multiselect({
					noneSelectedText : msgs.msg_spreads_control_widget_select_year,
					header : msgs.msg_spreads_control_widget_years,
					minWidth : 'auto',
					selectedList : 100,
					multiple : true,
					show: ['scale', 200],
					hide: ['scale', 200],
					beforeclose : function() {},
					click : function(event, ui) {
						if(bCreate){
							var aiYears = [];
							aiYears.push(+(ui.value));
							_fnModifyYears(aiYears, ui.checked);
						}
					}
				}).multiselectfilter();

				jQuery('.ui-multiselect-menu').css({
					'width' : 'auto'
				});
				jQuery('.ui-multiselect').css({
					'width' : '100%'
				});
				
				jQuery(nTable).parent().find('input').click(function(){
					if(!jQuery(this).is('input:text')){
						console.log(jQuery(this));
						_fnViewSelectedYears(oTable, _aiCurrentYears);
						_fnSelectYearsForAll(_aiCurrentYears);
					}
				});
				
				if(!bCreate){
					jQuery(nTable).parent().find(
						'.'+_spreadControlWidgetClass).hide();
				}
			},
			"fnHeaderCallback" : function(nHead, aaData, iStart, iEnd, aiDisplay) {
				var iCols = aaData.length > 0 ? aaData[0].length : 0;
				var iHidden = this.fnIHiddenColCount();

				// add periods to the right
				var iIndex = 1;
				// ensure that all required headers are created
				for(var i = 1; i < iCols; i++) {
					var j = i - 1;
					if(this.fnIsColVisible(i)){
						var nActionElem = jQuery(nHead.getElementsByTagName('th')[iIndex]);
						var nAdjacentActionElem = jQuery(nHead.getElementsByTagName('th')[iIndex-1]);
	
						var sHeaderText = '';
						var oRecord = aaMap[0][i];
	
						if(oRecord != null) {
							if(oRecord['period'] != null) {
								sHeaderText = _fnConstructHeader(oRecord['period']);
							} else if(oRecord['year_group'] != null) {
								sHeaderText = _fnConstructYearGroupHeader(oRecord['year_group']);
							} else if(oRecord['quarter_group'] != null) {
								sHeaderText = _fnConstructQuarterGroupHeader(oRecord['quarter_group']);
							}
							_fnCreateHeaderElement(nHead, nActionElem, nAdjacentActionElem, sHeaderText);
						}
						iIndex++;						
					}
				}
			},
			"fnFooterCallback" : function(nRow, aaData, iStart, iEnd, aiDisplay) {
				if(sTotalRowName != null && sTotalRowName.length > 0) {
					var iCols = aaData.length > 0 ? aaData[0].length : 0;
					_fnRemoveAllFooterCustomizations();
					if(nRow == null){
						jQuery('<tr/>', {}).appendTo(jQuery(this).find('tfoot'));
						nRow = jQuery(this).find('tfoot tr')[0];
					}
					if(jQuery(nRow) != null && jQuery(nRow).length > 0) {
						jQuery(nRow).addClass('ui-state-default');
						for(var i = 0; i < iCols; i++) {
							if(this.fnIsColVisible(i)) {
								var elem = _fnCreateFooterTdIfNotExist(nRow, i);
								_fnRenderFooterContent(this, elem, i, aaData, aiDisplay, aaMap, aoCategorizedCols);
								anModifiedFooters.push(elem);
							}
						}
					}
				}
			}
		});
		return oSheetTable;
	}
	
	function _fnCalculateGroupTotals(
		oTable, 
		aaMap, 
		aiCols, 
		bVisiblesOnly, 
		bUpdateTotalColumns,
		sAccountTitle){

		for(var g=0;g<aiCols.length;g++){
			var i = aiCols[g];
			if(!bVisiblesOnly || (bVisiblesOnly && oTable.fnIsColVisible(i))){
				var iCol = i;
				var aiDisplayableRows = oTable.fnGetFilteredDataRowIndex();
				for(var j = 0; j < aiDisplayableRows.length; j++) {
					var iRow = aiDisplayableRows[j];
					var oColData = aaMap[iRow][iCol];
					var bGroup = oColData['period'] == null || oColData['period']['id'] == null;
					var sGroupKey = oColData['quarter_group'] != null? 'quarter_group' : 'year_group';
					
					if(bGroup){
						_fnUpdateGroupTotal(
							bUpdateTotalColumns,
							sAccountTitle,
							oColData['record']['total_group_id'], 
							oColData[sGroupKey]['year'],
							oColData[sGroupKey]['quarter'],
							oTable.fnGetColumnTotal(iCol, aaMap));
					}
					else{
						_fnUpdatePeriodTotal(
							bUpdateTotalColumns,
							sAccountTitle,
							oColData['period']['id'],
							oColData['record']['total_group_id'], 
							oTable.fnGetColumnTotal(iCol, aaMap));				
					}
					break;
				}
			}
		}
	}
	
	function _fnSetInitialSelectedYears(aiCurrentYears){
		for(var i=new Date().getFullYear();i>new Date().getFullYear()-2;i--){
			Utils.addToArrayIfNotExists(aiCurrentYears, i);
		}
	}

	function _fnGenerateAvailableYears() {
		var aoYears = [];
		var iCurrent = new Date().getFullYear();
		for(var i = iCurrent + _iFutureYears; i > iCurrent - _iPastYears; i--) {
			var year = {
				value : i,
				selected : _aiCurrentYears.indexOf(i) >= 0
			}
			aoYears.push(year);
		}
		return aoYears;
	}

	function _fnCreateFooterTdIfNotExist(nRow, i) {
		var elem = jQuery(nRow).find('#' + i);
		if(elem == null || elem.length == 0) {
			jQuery('<td/>', {
				id : i
			}).appendTo(nRow);

			elem = jQuery(nRow).find('#' + i)
		}
		return elem;
	}

	function _fnRenderFooterContent(oTable, elem, iCol, aaData, aiDisplay, aaMap, aoCategorizedCols) {
		switch(iCol) {
			case 0:
				elem.html(_sTotalRowName);
				break;
			default:
				var iColTotal = oTable.fnGetColumnTotal(iCol, aaMap);

				if(elem.find('div') == null || elem.find('div').length == 0) {
					jQuery('<div><div class="spreads_currency total">' + iColTotal + '</div></div><div class="action"></div></div>', {}).appendTo(elem);
				} else {
					elem.find('.total').val(iColTotal);
				}

				if(aoCategorizedCols['years'].indexOf(iCol) >= 0 || aoCategorizedCols['quarters'].indexOf(iCol) >= 0) {

					var aiLinkedCols = null;
					if(aoCategorizedCols['years'].indexOf(iCol) >= 0) {
						aiLinkedCols = _fnFindLinkedPeriods(
							aoCategorizedCols['years'].indexOf(iCol), 
							aoCategorizedCols['years'], 
							aoCategorizedCols['quarters']);
					} else if(aoCategorizedCols['quarters'].indexOf(iCol) >= 0) {
						aiLinkedCols = _fnFindLinkedPeriods(
							aoCategorizedCols['quarters'].indexOf(iCol), 
							aoCategorizedCols['quarters'], 
							aoCategorizedCols['months']);
					}

					var bExpand = true;
					for(var p = 0; p < aiLinkedCols.length; p++) {
						if(oTable.fnIsColVisible(aiLinkedCols[p])) {
							bExpand = false;
							break;
						}
					}
					if(bExpand) {
						_fnRenderExpandPeriodGroup(oTable, elem.find('.action'), iCol, aoCategorizedCols);
					} else {
						_fnRenderHidePeriod(oTable, elem.find('.action'), iCol, aoCategorizedCols);
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
				}
			}
		}
	}

	function _sortPeriods(asColumnIds, asRowIds, aoRecords){
		var aoRecs = [];
		var aoPeriods = [];
		for(var i=0;i<asColumnIds.length;i++){
			var sId = asColumnIds[i];
			for(var j=0;j<aoRecords.length;j++){
				if(aoRecords[j]['period'] != null &&
					aoRecords[j]['period']['id'] == sId){
					
					aoPeriods.push(aoRecords[j]);
					break;
				}
			}
		}

		aoPeriods.sort(function(a,b){return a['period']['col'] - b['period']['col']});
		asColumnIds.splice(0, asColumnIds.length);
		for(var i=0;i<aoPeriods.length;i++){
			asColumnIds.push(aoPeriods[i]['period']['id']);
		}
		
		for(var i=0;i<asRowIds.length;i++){
			var sId = asRowIds[i];
			for(var j=0;j<aoRecords.length;j++){
				if(aoRecords[j]['record'] != null &&
					aoRecords[j]['record']['id'] == sId){
					
					aoRecs.push(aoRecords[j]);
					break;
				}
			}
		}
		
		aoRecs.sort(function(a,b){return a['record']['row'] - b['record']['row']});
		asRowIds.splice(0, asRowIds.length);

		for(var i=0;i<aoRecs.length;i++){
			asRowIds.push(aoRecs[i]['record']['id']);
		}
	}

	
	function _fnGenerateAaData(aoRecords, asRowIds, asColumnIds) {
		var aaData = [];
		for(var t = 0; t < aoRecords.length; t++) {
			var oRecordValue = aoRecords[t];
			var iRowId = asRowIds.indexOf(oRecordValue['record']['id']);
			var iColId = asColumnIds.indexOf(oRecordValue['period']['id']);

			var aoRow = aaData[iRowId];
			if(aoRow == null) {
				aoRow = [];
			}
			aoRow[iColId] = oRecordValue;
			aaData[iRowId] = aoRow;
		}
		return aaData;
	}

	function _fnInsertPeriodGroups(aaData) {
		for(var i = 0; i < aaData.length; i++) {
			var oCurrentYearPeriod = null;
			var oCurrentQuarterPeriod = null;

			var aoRow = aaData[i];
			var aoNewRow = [];
			for(var k = 0; k < aoRow.length; k++) {
				var oRecord = aoRow[k];
				if(oRecord['period'] == null || oRecord['period']['id'] == null) {
					continue;
				}

				var oYearPeriod = oRecord['year_group'];
				var oQuarterPeriod = oRecord['quarter_group'];

				var iToInsertIndex = k + 1;
				var iLength = aoRow.length;
				var iAddedCount = 0;
				var bLastRecord = iToInsertIndex >= iLength;

				if(bLastRecord) {
					aoNewRow.push(oRecord);
				}

				if(oQuarterPeriod != null && ((oCurrentQuarterPeriod != null && oCurrentQuarterPeriod['id'] != oQuarterPeriod['id']) || bLastRecord)) {

					aoNewRow.push({
						'quarter_group' : bLastRecord ? oQuarterPeriod : oCurrentQuarterPeriod,
						'record' : oRecord['record']
					});
				}
				if(oYearPeriod != null && ((oCurrentYearPeriod != null && oCurrentYearPeriod['id'] != oYearPeriod['id']) || bLastRecord)) {

					aoNewRow.push({
						'year_group' : bLastRecord ? oYearPeriod : oCurrentYearPeriod,
						'record' : oRecord['record']
					});
				}

				if(!bLastRecord) {
					aoNewRow.push(oRecord);
				}

				oCurrentYearPeriod = oYearPeriod;
				oCurrentQuarterPeriod = oQuarterPeriod;
			}
			aaData[i] = aoNewRow;
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

				if(oRecord['period'] != null && oRecord['period']['id'] != null) {
					Utils.addToArrayIfNotExists(aiMonths, j);
				} else if(oRecord['period'] == null || oRecord['period']['id'] == null) {
					if(oRecord['year_group'] != null) {
						Utils.addToArrayIfNotExists(aiYears, j);
					} else if(oRecord['quarter_group'] != null) {
						Utils.addToArrayIfNotExists(aiQuarters, j);
					}
				}
			}
		}
		return aoNonGroupIndex;
	}

	function _fnGenerateColumnDefs(aaData, bCurrencyPeriodValues) {
		var aoColMap = {};
		var aoToReturn = [];

		var oCol = {
			"bSortable" : true,
			//"sWidth" : '10%',
			//"bAutoWidth": false,
			"sType" : "record-name",
			"sClass": 'spread_title',
			"sTitle" : _sAccountTitle,
			"fnRender" : function(oObj, sVal) {
				if(!sVal['dummy'] && sVal['record'] != null) {
					var sIndicator = '';
					if(sVal['record']['debit']){
						sIndicator = ' (-)';
					}
					return sVal['record']['name'] + sIndicator;
				}
				return '';
			},
			"aTargets" : [0]
		};
		aoToReturn.push(oCol);

		var iColCount = 0;
		for(var k = 0; k < aaData.length; k++) {
			iColCount = aaData[k].length;
			for(var m = 1; m < iColCount; m++) {
				var oRecord = aaData[k][m];

				if(oRecord['name'] != null) {
					oCol = {
						"bSortable" : false,
						//"sWidth": '10%',
						//"bAutoWidth": false,
						"sTitle" : _fnConstructHeader(oRecord['period']),
						"sClass" : 'colclass spread_col ui-state-default ',
						"fnRender" : function(oObj, sVal) {
							if(!sVal['dummy'] && sVal['value'] != null) {
								return _fnRoundNumber(sVal['value']);
							}
							return '';
						},
						"aTargets" : [m]
					};
				} else if(oRecord != null && (oRecord['year_group'] != null || oRecord['quarter_group'])) {

					var oYearGroup = oRecord['year_group'];
					var oQuarterGroup = oRecord['quarter_group'];
					var sTitle = oQuarterGroup != null ? _fnConstructQuarterGroupHeader(oQuarterGroup) : _fnConstructYearGroupHeader(oYearGroup);

					oCol = {
						//"sWidth" : '15%',
						//"bAutoWidth": false,
						"bSortable" : false,
						"sTitle" : sTitle,
						"sClass" :   oQuarterGroup != null ? 'spread_col colgroupclass_quarter ui-state-focus' : 'spread_col colgroupclass_year ui-state-active',
						"fnRender" : function(oObj, sVal) {
							var oVal = sVal['year_group'] != null ? sVal['year_group'] : sVal['quarter_group'];
							return _fnRoundNumber(oVal['value']);
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

	function _fnConstructHeader(oPeriod) {
		if(oPeriod != null) {
			return oPeriod['month'] + '/' + oPeriod['year'];
		}
	}

	function _fnConstructYearGroupHeader(oYearGroup) {
		return oYearGroup['year'] + '';
	}

	function _fnConstructQuarterGroupHeader(oQuarterGroup) {
		return msgs['msg_spreads_quarter_' + oQuarterGroup['quarter']] + ' ' + 
			oQuarterGroup['year'];
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

	/**
	 * TODO: css classes should be passed in as parameters
	 */
	function _fnRenderHidePeriod(oTable, nElem, iCol, aoCategorizedCols) {
		if(nElem.find('.action_item_hide') == null || nElem.find('.action_item_hide').length == 0) {

			jQuery('.main_spreading div.hide_period').find('strong').html(msgs.msg_spreads_period_hide);
			nElem.append(jQuery('.main_spreading div.hide_period').html());

			nElem.find('.action_item_hide').click(function() {
				_fnExpandOrHidePeriod(oTable, iCol, false, aoCategorizedCols);
			});
		}

		nElem.find('.action_item_expand').hide();
	}

	/**
	 * TODO: css classes should be passed in as parameters
	 */
	function _fnRenderExpandPeriodGroup(oTable, nElem, iCol, aoCategorizedCols) {
		if(nElem.find('.action_item_expand') != null && 
			nElem.find('.action_item_expand').length > 0) {
			nElem.find('.action_item_expand').remove();
		}
		
		jQuery('.main_spreading div.expand_period').find('strong').html(msgs.msg_spreads_period_expand);
		nElem.append(jQuery('.main_spreading div.expand_period').html());
			
		nElem.find('.action_item_expand').click(function() {
			_fnExpandOrHidePeriod(oTable, iCol, true, aoCategorizedCols);
		});

		nElem.find('.action_item_hide').hide();
	}

	function _fnCreateHeaderElement(nHead, nActionElem, nAdjacentActionElem, sHeaderText) {
		if(nActionElem == null || nActionElem.length == 0) {
			nActionElem = jQuery('<th>' + sHeaderText + '</th>', {});
			nActionElem.appendTo(nHead);
		}
	}

	function _fnRenderAddPeriod(nHead, nActionElem, bNext) {
		if(nActionElem.find('.action_item') == null || nActionElem.find('.action_item').length == 0) {

			jQuery('.main_spreading div.add_new_period').find('strong').html(msgs.msg_spreads_add_period);
			nActionElem.append(jQuery('.main_spreading div.add_new_period').html());

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

	function _fnExpandOrHidePeriod(oTable, iCol, bExpand, aoCategorizedCols) {
		var iColsToShow = [];
		
		// determine category of column
		var iYearIndex = aoCategorizedCols['years'].indexOf(iCol);
		var iQuarterIndex = aoCategorizedCols['quarters'].indexOf(iCol);
		if(iYearIndex >= 0) {
			iColsToShow = _fnFindLinkedPeriods(iYearIndex, aoCategorizedCols['years'], aoCategorizedCols['quarters']);
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
		oTable.fnDraw();
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

	/**
	 * @param {Object} sGroupKey
	 * @param {Object} oColData
	 * @param {Object} aoData
	 * @param {Object} iRow
	 * @param {Object} aoUpdatedGroups
	 */
	function _fnFindAttachedPeriodsAndSetToNotAccumulate(sGroupKey, oColData, aoData, iRow, aoUpdatedGroups) {
		var sId = oColData[sGroupKey]['id'];
		// find all cols in this row attached to the same groups and set to not accumulate
		var aoRow = aoData[iRow];
		for(var i = 1; i < aoRow.length; i++) {// start at index 1 since first col is just a name field
			var oCol = aoRow[i];

			if(oCol['year_group'] != null && oCol['year_group']['id'] == sId && 
				oCol['year_group']['accumulate']) {
				
				oCol['year_group']['accumulate'] = false;
			}
			if(oCol['quarter_group'] != null && oCol['quarter_group']['id'] == sId && 
				oCol['quarter_group']['accumulate']) {
				
				oCol['quarter_group']['accumulate'] = false;
			}
		}
	}

	function _fnEditableDataTable(keys, oTable, nTable, sInteraction) {
		if(keys != null){
			keys.event.action(null, null, function(nCell) {
				_fnEditableCell(oTable, keys, nCell, sInteraction);
			});
		}
		else{
			_fnEditableCell(
				oTable, 
				null, 
				jQuery(nTable).find('td.spread_col'), 
				sInteraction);
		}
		
	}

	function _fnEditableCell(oTable, keys, nCell, sInteraction) {

		/* Block KeyTable from performing any events while jEditable is in edit mode */
		if(keys != null){
			keys.block = true;
		}
		
		var oOpts = {
			'tooltip' : msgs.msg_spreads_click_to_edit,
			'placeholder' : '',
			'indicator' : '', // TODO!
			'type' : 'text',
			'style' : 'inherit',
			"onblur" : 'submit',
			"event": sInteraction,
			"onreset" : function() {
				/* Unblock KeyTable, but only after this 'esc' key event has finished. Otherwise
				 * it will 'esc' KeyTable as well
				 */
				setTimeout(function() {
					if(keys != null){
						keys.block = false;
					}
				}, 0);
			}
		};
		if(sInteraction == 'keyboard'){
			oOpts = {
				'tooltip' : msgs.msg_spreads_click_to_edit,
				'placeholder' : '',
				'indicator' : '', // TODO!
				'type' : 'text',
				'style' : 'inherit',
				"onblur" : 'submit',
				"onreset" : function() {
					/* Unblock KeyTable, but only after this 'esc' key event has finished. Otherwise
					 * it will 'esc' KeyTable as well
					 */
					setTimeout(function() {
						if(keys != null){
							keys.block = false;
						}
					}, 0);
				}
			};
		}
		
		/* Initialize the editable instance for this table */
		jQuery(nCell).editable(function(sVal, settings) {
			try {
				return _fnEditTableCell(oTable, this, sVal, settings);
			} finally {
				if(keys != null){
					keys.block = false;
				}
			}
		}, oOpts);

		/* Dispatch click event to go into edit mode - Saf 4 needs a timeout... */
		setTimeout(function() {
			jQuery(nCell).click();
		}, 10);
	}
	/**
	 * @param {Object} oTable
	 * @param {Object} nNode
	 * @param {Object} value
	 * @param {Object} settings
	 */
	function _fnEditTableCell(oTable, nNode, value, settings) {
		if(!Utils.isValidNumber(value)) {
			return null;
		}
		var aPos = oTable.fnGetPosition(nNode);
		var iRow = aPos[0];
		var iCol = aPos[2];
		
		// determine whether or not this is a group column
		var sGroupKey = null;
		if(jQuery(nNode).hasClass('colgroupclass_quarter')) {
			sGroupKey = 'quarter_group';
		} else if(jQuery(nNode).hasClass('colgroupclass_year')) {
			sGroupKey = 'year_group';
		}
		
		_editData(iRow,iCol,value, sGroupKey);
		
		return (value);
	}
	
	/**
	 * 
	 * @param {Object} iRow
	 * @param {Object} iCol
	 * @param {Object} value
	 * @param {Object} sGroupKey optional parameter
	 */
	function _editData(iRow, iCol, value, sGroupKey){
		
		if(!Utils.isValidNumber(value)) {
			return null;
		}
		
		var oColData = _aoDataMap[iRow][iCol];
		
		var aoUpdatedCols = [];
		var aoUpdatedGroups = [];

		var aiUpdatedCols = [];
		
		if(sGroupKey != null) {// if this is a group that was updated
			oColData[sGroupKey]['value'] = value;
			_fnFindAttachedPeriodsAndSetToNotAccumulate(sGroupKey, oColData, _aoDataMap, iRow, aoUpdatedGroups);
			aoUpdatedGroups.push(oColData);
		} else {// if this is not a group that was updated
			oColData['value'] = value;
			aoUpdatedCols.push(oColData);
		}
		Utils.addToArrayIfNotExists(aiUpdatedCols,iCol);
		
		
		// update year totals for the current row
		_fnCalculateRecordGroupTotals(
			iRow,
			_aoCategorizedCols['quarters'],
			'months',
			'quarter_group',
			null,
			_aoDataMap,
			_aoCategorizedCols,
			aoUpdatedGroups,
			aiUpdatedCols);
			
		_fnCalculateRecordGroupTotals(
			iRow,
			_aoCategorizedCols['years'],
			'quarters',
			'year_group',
			'quarter_group',
			_aoDataMap,
			_aoCategorizedCols,
			aoUpdatedGroups,
			aiUpdatedCols);
			
		for(var i = 0; i < aoUpdatedGroups.length; i++) {
			var oGroup = aoUpdatedGroups[i]['quarter_group'] != null ? aoUpdatedGroups[i]['quarter_group'] : aoUpdatedGroups[i]['year_group'];
			var sId = oGroup['id'];
			var sVal = oGroup['value'];
			var bAccumulate = oGroup['accumulate'];

			_fnUpdateRecordGroupVal(sId, sVal, bAccumulate);
		}
		for(var i = 0; i < aoUpdatedCols.length; i++) {
			_fnUpdateRecordPeriodVal(aoUpdatedCols[i]['id'], aoUpdatedCols[i]['value']);
		}
		_oSheetTable.fnUpdate(_aoDataMap[iRow], iRow);
		
		_fnCalculateGroupTotals(
			_oSheetTable, 
			_aoDataMap, 
			aiUpdatedCols, 
			false,
			_bUpdateTotalColumns,
			_sAccountTitle);
	}
	
	function _fnEditPeriodData(sRecordName, sPeriodId, sVal){
		var iRow = -1;
		var iCol = -1;
		
		for(var i=0;i<_aoDataMap.length;i++){
			for(var j=0;j<_aoDataMap[i].length;j++){
				var oCol = _aoDataMap[i][j];
				if(sRecordName == oCol['record']['name']){
					if(oCol['period'] != null &&
						sPeriodId == oCol['period']['id']){
							
						iRow = i;
						iCol = j;
						break;
					}
				}
			}
		}
		if(iRow >= 0 && iCol >= 0){
			return _editData(iRow,iCol,sVal,null);
		}
	}
	
	function _fnEditGroupData(sRecordName, iYear, iQuarter, sVal){
		var iRow = -1;
		var iCol = -1;
		
		var sGroupKey = iQuarter > 0? 'quarter_group' : 'year_group';

		for(var i=0;i<_aoDataMap.length;i++){
			for(var j=0;j<_aoDataMap[i].length;j++){
				var oCol = _aoDataMap[i][j];
				if(oCol[sGroupKey] != null &&
					 sRecordName == oCol['record']['name']){
					 
					 	
					if(oCol[sGroupKey]['year'] == iYear &&
						oCol[sGroupKey]['quarter'] == iQuarter &&
						oCol['period'] == null){
						
						if((sGroupKey == 'year_group' && oCol['quarter_group'] == null) ||
							(sGroupKey == 'quarter_group' && oCol['quarter_group'] != null)){
								
							iRow = i;
							iCol = j;	
						}
						break;
					}
				}
			}
		}
		if(iRow >= 0 && iCol >= 0){
			return _editData(iRow,iCol,sVal,sGroupKey);
		}
	}
	

	function _fnCalculateRecordGroupTotals(
			iRow, 
			aiGroups, 
			sCategorizedLinkedKey, 
			sGroupKey, 
			sLinkedGroupKey, 
			aoDataMap, 
			aoCategorizedCols, 
			aoUpdatedGroups,
			aiUpdatedCols){
				
		for(var i=0;i<aiGroups.length;i++){
			var oGroup = aoDataMap[iRow][aiGroups[i]];
			var aiLinkedCols = _fnFindLinkedPeriods(
				i, 
				aiGroups, 
				aoCategorizedCols[sCategorizedLinkedKey]);
			var iCalcVal = null;
			for(var j=0;j<aiLinkedCols.length;j++){
				var sValue = null;
				if(sLinkedGroupKey != null){
					sValue = aoDataMap[iRow][aiLinkedCols[j]][sLinkedGroupKey]['value'];
				}
				else{
					sValue = aoDataMap[iRow][aiLinkedCols[j]]['value'];
				}
				
				if(typeof sValue != 'undefined' && sValue != null){
					if(iCalcVal == null){
						iCalcVal = 0; 
					}
					iCalcVal = _fnAddNumbers(iCalcVal,+(sValue));
				}
			}
			if(typeof iCalcVal != 'undefined' && 
					iCalcVal != null &&
					oGroup[sGroupKey]['accumulate']){
				
				if(iCalcVal != 0){
					var iPrevValue = oGroup[sGroupKey]['value'];
					oGroup[sGroupKey]['value'] = iCalcVal;
					if(iPrevValue != iCalcVal){
						Utils.addToArrayIfNotExists(aoUpdatedGroups, oGroup);
						Utils.addToArrayIfNotExists(aiUpdatedCols,aiGroups[i]);
					}
				}
			}
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
			_bUpdateTotalColumns);
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
		
		_fnRemoveAllCustomizations();
		var bFilter = true;
		if(bAdd) {
			for(var i=0;i<aiYears.length;i++){
				Utils.addToArrayIfNotExists(_aiCurrentYears, aiYears[i]);
			}
			
			_fnSaveSelectedYears(_aiCurrentYears);
			for(var i=0;i<aiYears.length;i++){
				var iYear = aiYears[i]; 
				if(!_bYearInDataSet(iYear, _aoDataMap)) {
					bFilter = false;
					_fnIncrementRecordCounter(_iRecordCounter);
					_fnIncrementGroupCounter(_iGroupCounter);
					_fnAddNewPeriod(JSON.stringify(aiYears));
					break;
				}
			}
		} 
		else {
			for(var i=0;i<aiYears.length;i++){
				while(_aiCurrentYears.indexOf(aiYears[i]) >= 0){
					_aiCurrentYears.splice(_aiCurrentYears.indexOf(aiYears[i]), 1);
				}
			}
			
			_fnSaveSelectedYears(_aiCurrentYears);
		}

		if(bFilter) {
			_fnSelectYearsForAll(_aiCurrentYears);
		}
	}
	
	function _fnSaveSelectedYears(aiYears){
		jQuery.cookie(
			_sStatementId + '_spreads_selected_years',
			JSON.stringify(aiYears),
			{expires: 30});
	}
	function _fnReadSelectedYears(){
		var sCookie = jQuery.cookie(_sStatementId + '_spreads_selected_years');
		if(sCookie == null){
			return [];
		}
		return jQuery.parseJSON(sCookie);
	}
	
	
	function _fnAddNumbers(a, b){
		if(typeof a == 'undefined' || a == '' && b != 'undefined' && b != null && b != ''){
			return b;
		}
		else if(typeof b == 'undefined' || b == '' && typeof a != 'undefined' && a != null && a != ''){
			return a;
		}
		return _fnRoundNumber(a) + _fnRoundNumber(b); 
	}
	
	function _fnRoundNumber(a){
		if(typeof a == 'undefined' || a == null){
			return '';
		}
		else if(a == ''){
			return a;
		}
		return Math.round(a*100)/100;
	}
	
	// jQuery datatables.net plugins

	jQuery.fn.dataTableExt.oApi.fnShouldExpandYears = function(oSettings, bDisplayControlWidget){
		var nElem = 
			bDisplayControlWidget? 
				jQuery(this).parent().find('.' + _spreadControlWidgetClass):
				jQuery('.' + _spreadControlWidgetClass); 
		return 'checked' == (
			nElem.find('.expand_years label input').attr('checked'));
	}
	jQuery.fn.dataTableExt.oApi.fnShouldExpandQuarters = function(oSettings, bDisplayControlWidget){
		var nElem = 
			bDisplayControlWidget? 
				jQuery(this).parent().find('.' + _spreadControlWidgetClass):
				jQuery('.' + _spreadControlWidgetClass); 
		return 'checked' == (
			nElem.find(
				'.expand_quarters label input').attr('checked'));
	} 
	
	jQuery.fn.dataTableExt.oApi.fnResizeTable = function(oSettings, nContainer){
		var iWidth = jQuery(window).width();
		var sWidth = '100%';
		
		var iNewWidth = this.fnIVisibleColCount() * 120;
		iNewWidth = Math.min(100,iNewWidth / iWidth * 100);
		sWidth = iNewWidth + '%';
		
		jQuery(nContainer).css({
			width: sWidth
		}); 
	} 
	
	jQuery.fn.dataTableExt.oApi.fnFilterPeriods = function(
		oSettings, 
		aaData, 
		aiYears, 
		aoCategorizedCols,
		bDisplayControlWidget,
		bSyncAllGrids,
		bUpdateTotalColumns) {
			
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
		
		if(this.fnShouldExpandYears(bUseGridControl) || 
			this.fnShouldExpandQuarters(bUseGridControl)){
				
			for(var i=0;i<aiYearColIndex.length;i++){
				var aiQ = _fnFindLinkedPeriods(
					aoCategorizedCols['years'].indexOf(aiYearColIndex[i]), 
					aoCategorizedCols['years'], 
					aoCategorizedCols['quarters']);
				
				if(this.fnShouldExpandYears(bUseGridControl)){
					aiQuarters = aiQuarters.concat(aiQ);
				}
				
				if(this.fnShouldExpandYears(bUseGridControl) && 
					this.fnShouldExpandQuarters(bUseGridControl)){
						
					for(var j=0;j<aiQ.length;j++){
						var aiM = _fnFindLinkedPeriods(
							aoCategorizedCols['quarters'].indexOf(aiQ[j]), 
							aoCategorizedCols['quarters'], 
							aoCategorizedCols['months']);
					
						aiMonths = aiMonths.concat(aiM);
					}
				}
			}	
		}
		
		var aiDispayable = [];
		aiDispayable = aiDispayable.concat(aiYearColIndex, aiQuarters, aiMonths);

		// start at 1 since the first col is the name
		for(var i = 1, iLen = oSettings.aoColumns.length; i < iLen; i++) {
			this.fnSetColumnVis(i, aiDispayable.indexOf(i) >= 0, false);
		}
		this.fnDraw();
	};

	jQuery.fn.dataTableExt.oApi.fnShowAllColumns = function(oSettings) {
		for(var i = 0; i < oSettings.aoColumns.length; i++) {
			if(!oSettings.aoColumns[i].bVisible) {
				this.fnSetColumnVis(i, true, false);
			}
		}
	}

	jQuery.fn.dataTableExt.oApi.fnIsColVisible = function(oSettings, iCol) {
		return oSettings.aoColumns[iCol].bVisible;
	}

	jQuery.fn.dataTableExt.oApi.fnIHiddenColCount = function(oSettings) {
		var iToReturn = 0;
		for(var i = 0; i < oSettings.aoColumns.length; i++) {
			if(!oSettings.aoColumns[i].bVisible) {
				iToReturn++;
			}
		}
		return iToReturn;
	}
	jQuery.fn.dataTableExt.oApi.fnIVisibleColCount = function(oSettings) {
		return oSettings.aoColumns.length - this.fnIHiddenColCount();
	}
	jQuery.fn.dataTableExt.oApi.fnColCount = function(oSettings) {
		return oSettings.aoColumns.length;
	}
		
	jQuery.fn.dataTableExt.oApi.fnGetColumnTotal = function(oSettings, iCol, aaMap) {
		var iColTotal = 0;
		var aiDisplayableRows = this.fnGetFilteredDataRowIndex();
		for(var j = 0; j < aiDisplayableRows.length; j++) {
			var iRow = aiDisplayableRows[j];
			var oColData = aaMap[iRow][iCol];
			var sToAdd = oColData['value'];
			var bGroup = oColData['period'] == null || oColData['period']['id'] == null;
			if(bGroup) {
				if(oColData['year_group'] != null) {
					sToAdd = oColData['year_group']['value'];
					sGroupKey = 'year_group';
				} else if(oColData['quarter_group'] != null) {
					sToAdd = oColData['quarter_group']['value'];
					sGroupKey = 'quarter_group';
				}
			}
			
			var iDelta = (sToAdd == null || sToAdd.length == 0) ? 0 : +(sToAdd);
			
			if(oColData['record']['debit']) {
				iDelta = iDelta*-1;
			} 
			iColTotal = _fnAddNumbers(iColTotal, iDelta);
		}
		return iColTotal;
	}
	// function pointers (overridden by _fnInit)
	function _fnAddNewPeriod(bNext) {};
	function _fnUpdateRecordGroupVal(sGroupId, sGroupValue, bGroupAccumulate) {};
	function _fnUpdateRecordPeriodVal(sRecordId, sRecordValue) {};
	function _fnSelectYearsForAll(aiYears){};
	function _fnUpdateGroupTotal(bUpdateTotalColumns, sRecordName, sTotalId, iYear, iQuarter, sTotalVal) {};
	function _fnUpdatePeriodTotal(bUpdateTotalColumns, sRecordName, sPeriodId, sTotalId, sTotalVal) {};
	function _fnIncrementRecordCounter(iCounter){};
	function _fnIncrementGroupCounter(iCounter){};
	function reset(oInitProps, that) {
		_fnInit(oInitProps, that);
	}
	
	
	_fnInit(oInit, this);
}

// Hook into module system
if( typeof module !== 'undefined') {
	module.exports = SpreadStatement;
}

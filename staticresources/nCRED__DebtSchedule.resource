function DebtSchedule(oInit){

	var jQuery = null;
	if(typeof jQuery == 'undefined'){
		jQuery = oInit.jQuery;
	}

	// instance variables
	var _that = null;
	var _data_backup = null;
	var _data = null;
	var _nContainer = null;
	var _updateData = function(){};
	var _restartDebtSchedule = function(){};
	var _reloadDebtSchedule = function(){};
	
	var _keys = ['creditFacilities', 'otherObligations', 'indirectDebt', 'proposedLoans'];
	var _keyLabels = ['creditFacilitiesLabels', 'otherObligationsLabels', 'indirectDebtLabels', 'proposedLoansLabels'];
	var _sectionLabels = ['creditFacilitiesLabel', 'otherObligationsLabel', 'indirectDebtLabel', 'proposedLoansLabel'];
	var _columnKeys = ['relationshipName','loanNr' , 'product', 'originalAmount','principalAmount',
					   'ownershipPercentage', 'unfundedAmount','paymentAmount','proposedPaymentAmount','rate',
					   'maturityDateStr','payoffAmount','participatedAmount'];
	
	var _columnLifeCycleHtmlElems = 
		[new Utils.LifeCycleHtmlElem({ // relationshipName
			'required': true,
			'minlength': 1}),
		 new Utils.LifeCycleHtmlElem({ // name
			'required': true,
			'minlength': 1}),
		new Utils.LifeCycleHtmlElem({  // product
			'required': true,
			'minlength': 1}),
		new Utils.LifeCycleHtmlElem({  // originalAmount
			'required': true,
			'currency': true}),
		new Utils.LifeCycleHtmlElem({  // principalAmount
			'required': true,
			'currency': true}),  
		new Utils.LifeCycleHtmlElem({  // ownershipPercentage
			'required': true,
			'number': true}),  
		new Utils.LifeCycleHtmlElem({  // unfundedAmount
			'required': true,
			'currency': true}),
		new Utils.LifeCycleHtmlElem({  // paymentAmount
			'required': true,
			'currency': true}),
		new Utils.LifeCycleHtmlElem({  // proposedPaymentAmount
			'required': true,
			'currency': true}),
		new Utils.LifeCycleHtmlElem({  // rate
			'required': true,
			'number': true}),
		new Utils.LifeCycleHtmlElem({  // maturityDateStr
			'required': true,
			'date': true}),
		new Utils.LifeCycleHtmlElem({  // payoffAmount
			'required': true,
			'currency': true,
			'rawdata': function(sVal){
				var val = Utils.getNumberFromCurrency(sVal);
				if(val > 0){
					val = val * -1;
				}
				return val;
			}}),
		new Utils.LifeCycleHtmlElem({  // participatedAmount
			'required': true,
			'currency': true,
			'rawdata': function(sVal){
				var val = Utils.getNumberFromCurrency(sVal);
				if(val > 0){
					val = val * -1;
				}
				return val;
			}})
	];

	
	var _allAttributes = ['relationshipName','loanId', 'loanNr', 'name', 'institution','product','originalAmount',
						  'principalAmount','ownershipPercentage', 'unfundedAmount','paymentAmount','proposedPaymentAmount',
						  'payments','paymentFrequency','rate','maturityDate','maturityDateStr','payoffAmount',
						  'participatedAmount','participatedEntity','isRemoved','isOveridden'];
	
	var _tableContainers = [];
	var _dataTables = [];

	var jQuery = null;
	if( typeof oInit.jQuery != 'undefined') {
		jQuery = oInit.jQuery;
	}
	
	// public functions 
	this.getDataTables = function(){
		return _dataTables;
	}
	
	// private functions
	function _fnInitTitleArea(nContainer, bCanLock, bLock, that){
		//jQuery('<h1 class="ui-widget-header">' + msgs.msg_underwriting_debt_schedule_title + '</h1>').appendTo(nContainer);

		
		var lockString = '';
		try{
			
			lockString = msgs.msg_underwriting_locked_by + ' ' +
				_data.lockedByUser +' - ' + 
				(_data.lockedDate != null? 
					jQuery.format.date(new Date(_data.lockedDate.substr(0,_data.lockedDate.length-5))) : '');;
		}
		catch(error){
			console.log(error);
		}
			
		
		// 2012-10-25T19:37:54.040Z 
		var lockedBy = jQuery('<div><p>'+ lockString +'</p></div>');
		
		var lock = jQuery('<div class="debt_schedule_action"><a class="debt_schedule_lock"><span class="ui-icon ui-icon-unlocked" style="float: left; margin-right: .3em;"></span>'+
				msgs.msg_underwriting_lock_statement+'</a></div>');
		var unLock = jQuery('<div class="debt_schedule_action"><a class="debt_schedule_lock"><span class="ui-icon ui-icon-locked" style="float: left; margin-right: .3em;"></span>'+
				msgs.msg_underwriting_unlock_statement+ ' ('+lockString+')</a></div>');
		var refresh = jQuery('<div class="debt_schedule_action"><a class="debt_schedule_refresh"><span class="ui-icon ui-icon-refresh" style="float: left; margin-right: .3em;"></span>'+
				msgs.msg_underwriting_debt_schedule_reload+'</a></div>');
		var save = jQuery('<div class="debt_schedule_action"><a class="debt_schedule_save"><span class="ui-icon ui-icon-bullet" style="float: left; margin-right: .3em;"></span>'+
				msgs.msg_underwriting_debt_schedule_save+'</a></div>');
		var restart = jQuery('<div class="debt_schedule_action"><a class="debt_schedule_restart"><span class="ui-icon ui-icon-refresh" style="float: left; margin-right: .3em;"></span>'+
				msgs.msg_underwriting_debt_schedule_restart+'</a></div>');
		
		var headerContainer =  jQuery('<div class="ui-corner-all debt_schedule_header"></div>');
		//jQuery(headerContainer).append(save).append(refresh).append(restart).appendTo(nContainer);
		
		if(bLock){
			if(bCanLock){
				jQuery(headerContainer).append(unLock).appendTo(nContainer);
			}
			else{
				jQuery(headerContainer).append(lockedBy).appendTo(nContainer);
			}
		}
		else{
			if(bCanLock){
				jQuery(headerContainer).append(lock).appendTo(nContainer);
			}
			jQuery(headerContainer).append(restart).appendTo(nContainer);
		}
		
		_fnCreateAndAttachSeparatorDiv(nContainer);
		
		jQuery(lock).find('a').click(function(){
			_data.isLocked = true;
			_reloadDebtSchedule(JSON.stringify(_data));
		});
		jQuery(unLock).find('a').click(function(){
			_data.isLocked = false;
			_reloadDebtSchedule(JSON.stringify(_data));
		});
		jQuery(save).find('a').click(function(){
			_updateData(JSON.stringify(_data));
		});
		jQuery(refresh).find('a').click(function(){
			that.reload(_data_backup);
		});
		jQuery(restart).find('a').click(function(){
			_restartDebtSchedule();
		});
	}
	function _fnCreateAndAttachSeparatorDiv(nElem){
		jQuery('<div>',{'class': 'underwriting_section__debt_schedule_clear'}).appendTo(nElem);
	}
	function _fnCreateHeaderDiv(nElem){
		return jQuery('<div>',{'class': 'ui-widget underwriting_section_debt_schedule'});
	}
	function _fnCreateTable(className, index){
		return jQuery('<table class="debt_schedule_table spread_table ui-corner-all detailList '+className + 
				'"><thead class=""></thead><tbody class="ui-widget-content"></tbody><tfoot></tfoot></table>');
	}
	function _fnCreateAddButton(description, index){
		var button = jQuery(
				'<a class="'+_keys[index]+' ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" role="button" aria-disabled="false">' +
				'<span class="ui-button-text"><span class="ui-icon ui-icon-plus" style="float: right; margin-right: .3em;"></span>'+description+'</span></a>');
		button.addClass('debt_schedule_add');
		return button;
	}
	function _fnCreateButtonContainer(index){
		var div = jQuery('<div>');
		if(!_data.isLocked){
			div.append(_fnCreateDeleteButton(index)).append(_fnCreateEnableButton(index));
		}
		return div;
	}
	function _fnCreateDeleteButton(index){
		var button = jQuery(
				'<div><a class="debt_schedule_delete" title="'+msgs.msg_underwriting_debt_schedule_remove+'"><span class="ui-icon ui-icon-trash" style="float: left; margin-right: .3em;"></span>'+''+'</a></div>');
		return button;
	}
	function _fnShowDeleteConfirmDialog(okCallback){
		var div = jQuery('<div class="ui-corner-all">'+msgs.msg_underwriting_debt_schedule_delete_confirm+'</div>');
		return div.dialog({
			autoOpen : 'true',
			modal : 'true',
			draggable : 'false',
			resizable : false,
			title : msgs.msg_underwriting_debt_schedule_delete_confirm_title,
			buttons : [ {
				text : msgs.msg_underwriting_debt_schedule_delete_confirm_yes,
				click : function() {
					okCallback.apply(this, arguments);
					jQuery(div).dialog('close');
				}},
				{
				text : msgs.msg_spreads_cancel,
				click : function() {
					jQuery(div).dialog('close');
				}} ],
			close : function(event, ui) {
			}
		});
	}
	function _fnCreateEnableButton(index){
		var button = jQuery(
				'<div><a class="debt_schedule_enable" title="'+msgs.msg_underwriting_debt_schedule_enable+'"><span class="ui-icon ui-icon-check" style="float: left; margin-right: .3em;"></span>'+''+'</a></div>');
		return button;
	}
	function _fnDisableAllRemovedRows(oTable, data, dataKey){
		var removedRows = [];
		for(var p=0;p<data[dataKey].length;p++){
			if(data[dataKey][p]['isRemoved']){
				removedRows.push(p);
			}
		}
		var adjustCols = function(that, removed){
			var colCount = jQuery(that).find('td').length;
			jQuery(that).find('td').each(function(colIndex){
				// only disable to 2nd to last col
				if(colIndex < colCount-1){
					if(removed){
						jQuery(this).addClass('ui-state-disabled');
					}
					else{
						jQuery(this).removeClass('ui-state-disabled');
					}
				}
			});
			if(removed){
				jQuery(that).removeClass('labelCol');
				jQuery(that).find('a.debt_schedule_delete').hide();
				jQuery(that).find('a.debt_schedule_enable').show();
			}
			else{
				jQuery(that).addClass('labelCol');
				jQuery(that).find('a.debt_schedule_delete').show();
				jQuery(that).find('a.debt_schedule_enable').hide();
			}
		};
		jQuery(oTable).find('tbody').find('tr').each(function(index){
			adjustCols(this,_.contains(removedRows, index));
		});
	}
	function _fnProcessRowAction(
			that, 
			oTable, 
			data, 
			dataKey, 
			dataIndex,
			keyLabels, 
			dataCallback, 
			nonDbTableCallback){
		try{
			var nRow = jQuery(that).parent().parent()[0];
			var aPos = oTable.fnGetPosition(nRow);
			var iRow = aPos[0];
			
			var bIsDbRecord = data[dataKey][iRow]['loanId'] != null && 
			data[dataKey][iRow]['loanId'].length > 0;
				
			if(bIsDbRecord){
				data[dataKey][iRow]['isOveridden'] = true;
				if(dataCallback != null){
					dataCallback.apply(that, [data[dataKey][iRow]]);
				}

				_fnUpdateTableRow(oTable, data, iRow, keyLabels);
			}
			else{
				if(nonDbTableCallback != null){
					nonDbTableCallback.apply(that,[data[dataKey], iRow, oTable]);
				}
			}
		}
		catch(error){
			console.log(error);
			console.log(error.stack);
		}
		finally{
			_updateData(JSON.stringify(data));
		}
	}
	function _fnRenderColumn(oObj, sVal, lifeCycleHtmlElem){
		return lifeCycleHtmlElem.render.apply(this, [sVal]);
	}
	function _fnFormatCurrencyForDisplay(value){
		return Utils.formatCurrencyForDisplay(value, false);
	}
	function _fnUpdateTableRow(oTable, data, iRow,keyLabels){
		var dataKeyLoc = _fnGetDataRowLocation(oTable); 
		var dataIndex = _fnGetDataRowLocation(oTable, true);
		
		var tempArray = [];
		tempArray.push(data[dataKeyLoc][iRow]);
		var updateData = _fnGenerateAaData(tempArray, data[keyLabels[dataIndex]]);
		oTable.fnUpdate(
				updateData[0],
				iRow, 
				0);
	}

	function _fnGenerateColumnDefs(aaData, labels, columnLifeCycleHtmlElems){
		var toReturn = [];
		for(var s=0;s<labels.length;s++){
			var label = labels[s];

			var col = {
				"bSortable" : false,
				"bAutoWidth": false,
				//"sClass": 'colclass spread_col ui-state-default',
				"sClass": 'spread_col spread_title ui-widget-content',
				"sTitle" : label,
				"fnRender" : function(oObj, sVal) {
					return _fnRenderColumn(oObj, sVal, columnLifeCycleHtmlElems[oObj.iDataColumn]);
				},
				"aTargets" : [s]
			};
			toReturn.push(col);
		}
		toReturn[toReturn.length-1]['sClass'] = 'debt_schedule_action_col ui-widget-content';
		toReturn[toReturn.length-1]['sWidth'] = '23px'; // TODO: change this
		toReturn[toReturn.length-1]['fnRender'] = function(oObj, sVal) {
			return _fnCreateButtonContainer().html();
		};
		return toReturn;
	}
	function _fnGenerateNewRecord(){
		var toReturn = {};
		for(var d=0;d<_allAttributes.length;d++){
			toReturn[_allAttributes[d]] = null;
		}
		return toReturn;
	}
	function _fnGenerateAaData(aoRecords, labels) {
		var aaData = [];
		for(var t = 0; t < aoRecords.length; t++) {
			var oRecordValue = aoRecords[t];
			aaData.push([]);
			aaData[t]['data'] = oRecordValue;
			for(var j=0;j<labels.length;j++){
				var columnVal = null;
				if(j < _columnKeys.length){
					columnVal = _columnKeys[j];
					aaData[t][j] = oRecordValue[columnVal];
				}
				else{
					aaData[t][j] = '';
				}
			}
		}
		return aaData;
	}
	/**
	 * Maps the column location of the local data map to the global data map 
	 */
	function _fnGetDataColLocation(iCol){
		return _columnKeys[iCol];
	}
	/**
	 * Maps the row location of the local data map to the global data map 
	 */
	function _fnGetDataRowLocation(elem, returnIndex){
		var key = '';
		var index = 0;
		for(var p=0;p<_keys.length;p++){
			if(jQuery(elem).hasClass(_keys[p])){
				key = _keys[p];
				index = p;
				break;
			}
		}
		if(returnIndex){
			return index;
		}
		return key;
	}
	
	function _fnInitTableStructures(nContainer, keys){
		var tableContainers = [];
		for(var i=0;i<keys.length;i++){
			var header = _fnCreateHeaderDiv(nContainer);
			var elem = _fnCreateTable(keys[i], i);
			tableContainers.push(elem);
			nContainer.append(header.append(elem));
			_fnCreateAndAttachSeparatorDiv(nContainer);
		}
		return tableContainers;
	}
	
	function _fnInit(oInit, that) {
		if(_that != null) {
			_that.oInit = oInit;
		}
		_that = that;
		
		if(oInit.nContainer != null &&  typeof oInit.nContainer != 'undefined') {
			_nContainer = oInit.nContainer;
		} else {
			throw '--> a container element must be specified';
		}
		if(oInit.data != null && typeof oInit.data != 'undefined') {
			_data = oInit.data;
		} else {
			throw '--> data must be specified';
		}
		if(oInit.updateData != null && typeof oInit.updateData != 'undefined') {
			_updateData = oInit.updateData;
		}
		if(oInit.restart != null && typeof oInit.restart != 'undefined'){
			_restartDebtSchedule = oInit.restart; 
		}
		if(oInit.reloadSection != null && typeof oInit.reloadSection != 'undefined'){
			_reloadDebtSchedule = oInit.reloadSection; 
		}	
		try{
			_fnInitTitleArea(_nContainer, _data.canBeLocked, _data.isLocked, that);
			_tableContainers = _fnInitTableStructures(_nContainer, _keys);
			_that.reload(_data);
		}
		catch(error){
			console.log(error);
			console.log(error.stack);
			throw error;
		}
		
	}
	
	// public functions
	this.reload = function(data){
		_data_backup = jQuery.parseJSON(JSON.stringify(data)); // deep clone
		_data = data;
		_dataTables = [];
		for(var i=0;i<_keys.length;i++){
			
			var tableData = data[_keys[i]];
			var tableLabels = data[_keyLabels[i]];
			if(tableData != null && tableLabels != null){
				var columns = _fnGenerateColumnDefs(tableData, tableLabels, _columnLifeCycleHtmlElems);
				
				var oTable = jQuery(_tableContainers[i]).dataTable({
					"aaOriginalData": data,
					"bFilter": false,
					"bStateSave" : false,
					"bScrollInfinite" : false,
					"bScrollCollapse" : true,
					"bJQueryUI" : false,
					"bAutoWidth" : false,
					"bPaginate" : false,
					"bRetrieve" : false,
					"bDestroy" : true,
					"bUseRendered" : false,
					"aoColumnDefs" : columns,
					"asStripeClasses": ['labelCol'],
					"bInfo": false,
					"bSort": false,
					"aaData" : _fnGenerateAaData(tableData, tableLabels),
					"fnDrawCallback" : function() {
						var oTable = this;
						
						var dataKey = _fnGetDataRowLocation(this);
						var dataIndex = _fnGetDataRowLocation(this, true);
						
						// find all 'isRemoved' rows and mark them as disabled
						_fnDisableAllRemovedRows(oTable, _data, dataKey);
						
						if(!_data.isLocked){
							// register listeners					
							jQuery(this).find('a.debt_schedule_delete').unbind();
							jQuery(this).find('a.debt_schedule_delete').click(function(){
								_fnProcessRowAction.apply(
										this, 
										[this, 
										oTable, 
										_data, 
										dataKey, 
										dataIndex,
										_keyLabels, 
										function(record){
											record['isRemoved'] = true;
										},
										function(row, iRow, oTable){
											_fnShowDeleteConfirmDialog(function(){
												row.splice(iRow, 1);
												oTable.fnDeleteRow(iRow);
												_updateData(JSON.stringify(_data));
											});
										}]);
							});
							
							jQuery(this).find('a.debt_schedule_enable').unbind();
							jQuery(this).find('a.debt_schedule_enable').click(function(){
								_fnProcessRowAction.apply(
										this, 
										[this, 
										oTable, 
										_data, 
										dataKey,
										dataIndex, 
										_keyLabels, 
										function(record){
											record['isRemoved'] = false;
										},
										function(row, iRow, oTable){}]);
							});
							
							jQuery(this).find('td.spread_col').unbind();
							
							jQuery(this).find('tbody').find('tr.labelCol').find('td.spread_col').hover(function(){
								var editableArea = this;
								
								jQuery(this).addClass('inlineEditWriteOn');
								
								var aPos = oTable.fnGetPosition(editableArea);
								var iRow = aPos[0];
								var iCol = aPos[2];
								var lifeCycleElem = _columnLifeCycleHtmlElems[iCol];
								
								var oOpts = lifeCycleElem.editableOpts;
								oOpts['tooltip'] = msgs.msg_spreads_dblclick_to_edit;
								oOpts['cancel'] = msgs.msg_spreads_cancel;
								oOpts['submit'] = msgs.msg_spreads_ok;
								oOpts['onreset'] = function() {}
								var nCell = this;
								
								// can only edit one plugin at a time
								jQuery.editable.types.text.plugin = lifeCycleElem.attachValidators; 
								
								new Utils.LifeCycleHtmlEditable(nCell, oOpts, function(sVal, settings){
									try{
										var nNode = this;
										var aPos = oTable.fnGetPosition(nNode);
										iRow = aPos[0];
										iCol = aPos[2];
										var columnKey = _fnGetDataColLocation(iCol);
										var dataKeyLoc = _fnGetDataRowLocation(oTable); 

										_data[dataKeyLoc][iRow][columnKey] = sVal;
										_data[dataKeyLoc][iRow]['isOveridden'] = true;
										
										if('originalAmount' == columnKey){
											if(_data[dataKeyLoc][iRow]['principalAmount'] == null){
												_data[dataKeyLoc][iRow]['principalAmount'] = sVal;
												
												_fnUpdateTableRow(oTable, _data, iRow,_keyLabels);
											}
										}
										else if('paymentAmount' == columnKey){
											if(_data[dataKeyLoc][iRow]['proposedPaymentAmount'] == null){
												_data[dataKeyLoc][iRow]['proposedPaymentAmount'] = sVal;
												
												_fnUpdateTableRow(oTable, _data, iRow,_keyLabels);
											}
										} 
									}
									finally{
										_updateData(JSON.stringify(_data));
									}
								});
							},
							function(){});
							
							jQuery(this).find('tbody').find('tr.labelCol').find('td.spread_col').bind('mouseout',function(){
								jQuery(this).removeClass('inlineEditWriteOn');
							});
						}
					},
					"fnInitComplete" : function(oSettings, json) {

						var oTable = this;
						
						var sectionLabel = data[_sectionLabels[i]];
						
						jQuery(this).parent().prepend(
								jQuery('<h3 class="debt_schedule_header">'+sectionLabel+'</h3>'));
						
						if(!_data.isLocked){
							var addButton = _fnCreateAddButton(
									msgs['msg_underwriting_debt_schedule_add_'+_keys[i]],
									i);
								
							_fnCreateAndAttachSeparatorDiv(jQuery(this).parent());
							jQuery(this).parent().append(addButton);
							
							// register listeners
							jQuery(addButton).click(function(){
								var dataKey = _fnGetDataRowLocation(this);
								var dataIndex = _fnGetDataRowLocation(this, true);
								var newRecord = _fnGenerateNewRecord();
								
								_data[dataKey].push(newRecord);
								
								var tempArray = [];
								tempArray.push(newRecord);
								
								var tableArray = _fnGenerateAaData(tempArray,_data[_keyLabels[dataIndex]]);
								oTable.fnAddData(tableArray);
							});
						}
					}
				});
				_dataTables.push(oTable);
			}
		}
	}
	this.getData = function(){
		return _that._data;
	}
	_fnInit(oInit, this);
}

// Hook into module system
if( typeof module !== 'undefined') {
	module.exports = DebtSchedule;
}

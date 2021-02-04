(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			self.app = app;
			var defaultData = {
				tableId: null,
				tableRow: null,
				tableColumn: null,
				tableNode: null,
				navDirection: null,
				isGlobalAnalysisActive: false,
				statement: null
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}


			self.app.subscribe("SPREAD.Spreads.Global_Analysis_Active", function (globalAnalysisState) {
				self.isGlobalAnalysisActive(globalAnalysisState);
			});

			self.app.subscribe("SPREAD.Spreads.Dirty_Data", function () {
				self.overrideSavePending(true);
			});

			self.mapping = app.getMapping();
			self.mapping['statement'] = {
				create: function(options){
					return ko.observable(new app.SpreadStatement(options.data));
				}
			}
			self.mapping['ignore'] = ['statementContainer'];
			// so it does not create a new instance
			self.mapping['copy'] = ['spread'];
			app.mapFromJS(defaultData, self.mapping, self);
			
			self.statementContainer = data.statementContainer;
			self.trElement;
			self.exportDisabled = LifeCycle.msgs.msg_spread_save_pending_text;
			
			self.recordPeriods = ko.observableArray();
			self.addSaveValue = function(obj){
				for(var i = 0; i < self.recordPeriods().length; i++){
					if(self.recordPeriods()[i].id == obj.id){
						self.recordPeriods.splice(i, 1);
						break;
					}
				}
				self.recordPeriods.push(obj);
			};
			
			self.autoSave = ko.observable(false);
			self.editingCell = ko.observable(false);
			self.recordsToSave = ko.observable();
			
			// Throttles the remote call queue by preventing the user from editing the statement.
			self.blockedUI = ko.observable(false);
			self.blockedUI.subscribe(function(value){
				if(value == true){
					jQuery('.main_spreading').addClass('processing_save');
				}else{
					jQuery('.main_spreading').removeClass('processing_save');
				}
			});
			self.savePercentage = ko.computed({
				read: function(){
					if(!_.isUndefined(self.recordsToSave())){
						return ( Math.round((1 - (self.recordPeriods().length / self.recordsToSave())) * 100 )) + '%'; 
					}
				}
			});

			self.directSave = function (valuesToSave, callback) {
				var periodTotalsToBeSaved = [];
				for (var i = 0; i < self.statement().recordTotals().length; i++) {
					var recordTotal = self.statement().recordTotals()[i];
					for (var j = 0; j < recordTotal.periodTotals().length; j++) {
						var periodTotal = recordTotal.periodTotals()[j];
						if (!periodTotal.recordId()) {
							periodTotalsToBeSaved.push(periodTotal);
						}
					}
				}
				saveIndividualPeriodTotal(periodTotalsToBeSaved);

				function saveIndividualPeriodTotal(periodTotals){
					if (periodTotals.length) {
						var periodTotalToBeSaved = app.mapToJS(periodTotals.pop(), { useOptimizedMapper: true, maxDepth: 0 });
						LifeCycle.SpreadsService.saveIForce(periodTotalToBeSaved, function(periodTotal){ 
							LifeCycle.SpreadData.cacheUnmappedIForces([periodTotal]);
						});
						saveIndividualPeriodTotal(periodTotals);
					} else {
						LifeCycle.Spreads.updateRecordCells(
							{ recordPeriods: valuesToSave },
							function(result){
								if(_.isFunction(callback)){
									callback.apply(result);
								}
							},
							self.spread.handleRemoteError
						);
					}
				}
			};
			
			self.saveChanges = function(callback){
				if(self.recordPeriods().length > 0){
					if(_.isUndefined(self.recordsToSave())){
						self.recordsToSave(self.recordPeriods().length);
						if(self.recordPeriods().length > 200){
							jQuery('#alert-progress-save').slideDown();
						}
						if(jQuery('#button-save').hasClass('btn-success')){
							jQuery('#button-save').removeClass('btn-success');
						}
					}
					self.blockedUI(true);
					var valuesToSave = self.recordPeriods.splice(0, 200);
					self.directSave(valuesToSave, function (result) {
						if(self.recordPeriods().length == 0){
							self.recordPeriods.removeAll();
							self.blockedUI(false);
							jQuery('#alert-progress-save').slideUp();
							self.recordsToSave(undefined);
							app.publish('SPREAD.Spreads.Saved');
							if(_.isFunction(callback)){
								callback.apply();
							}
						}else{
							self.saveChanges();
						}
					});
				} else {
					app.publish('SPREAD.Spreads.Saved');
				}
				self.overrideSavePending(false);
			};
			
			self.uiAutoSave = ko.computed({
				read: function(){
					if(self.autoSave() && !self.editingCell()){
						self.saveChanges();
					}
				}
			}).extend({ throttle: 10000 });
			
			self.overrideSavePending = ko.observable(false);
			self.savePending = ko.computed({
				read: function(){ 
					return self.overrideSavePending() || self.recordPeriods().length > 0;
				}
			});
			
			self.uiRowScrollElement = ko.computed({
				read: function(){
					if(self.tableNode() != null){
						var iTableRow = self.tableRow();
						self.trElement = jQuery(self.tableNode()).closest('tr');
						jQuery.scrollTo( self.trElement, 300,  {offset: -400} );
					}
				}
			}).extend({ throttle: 400 });
			
			self.selectCell = ko.computed(function(){
				var nNode = self.tableNode();
				if(!_.isUndefined(self.statementContainer[self.tableId()])){
					var statement = self.statementContainer[self.tableId()];
					var aPos = statement.findPositionFromTD(nNode);
					var selected = jQuery('.spread_table').find('.selected');
					if(selected.length){
						jQuery(selected).removeClass('selected');
					}
					self.tableRow(aPos[0]);
					self.tableColumn(aPos[2]);
					jQuery(nNode).addClass('selected');
					jQuery(nNode).closest('tr').addClass('selected');
				}
			}).extend({ throttle: 100 });

			self.load = function(){
				try{
					if(_.isEmpty(self.recordId())){
						throw new Error(LifeCycle.msgs.msg_spread_config_required_data);
					}
					SpreadStatement._getStatement(
							self.recordId(),
							function(statement, event){
								self.statement(statement);
								jQuery(document).on('keydown', function(e) {
									if (
										key.getScope() == 'formula' &&
										[37, 38, 39, 40].indexOf(e.which) != -1
									) {
										return;
									}
									
									switch(e.which){
										case 37: //left
											self.navDirection('left');
											break;
										case 38: // up
											self.navDirection('up');
											break;
										case 9:
											e.preventDefault();
											if(key.shift){
												self.navDirection('left');
												break;
											}
										case 39: //right
											self.navDirection('right');
											break;
										case 13: // enter
											if(key.shift){
												self.navDirection('up');
												break;
											}
										case 40: // down
											self.navDirection('down');
											break;
									}
								});
									
							},
							app.log.failure);
				}catch(e){
					app.log.failure(null, e);
				}
			};
			
			self.navDirection.subscribe(function(value){
				if(!_.isUndefined(value)){
					var nNode = self.tableNode();
					if(!_.isUndefined(nNode)){
						var input = jQuery(nNode).find('input');
						if(!_.isUndefined(input)){
							jQuery(input).blur();
						}
					}				
					self.navDirection(undefined);
				}
			});
			self.navigate = function(direction){
				if(_.isUndefined(direction)){
					direction = self.navDirection();
					self.navDirection(undefined);
				}
				var statement = self.statementContainer[self.tableId()];
				if(!_.isUndefined(statement)){

					if (!_.isUndefined(self.tableNode())){
						
						if (!jQuery.contains(document, self.tableNode()) && self.tableNode().id) {
							var undetachedNode = document.getElementById(self.tableNode().id);
							if (undetachedNode) {
								self.tableNode(undetachedNode);
							}
						}
				
						var datePickerVM = self.spread.datePickerApp.viewModel;
						
						var aNodes = statement.getNodes();
						var aiVisibleRows = _getVisibleRowNumbers(aNodes);
						var asVisibleStatements = _getVisibleStatementIds();
						
						var currentTable = self.tableId();
						var currentRow = self.tableRow();
						var currentColumn = self.tableColumn();

						var aiSelectedColumns, aiVisibleColumns;
						if (!self.statement().isStaticPeriods()) {
							aiSelectedColumns = datePickerVM.getCurrentSelectedColumns();
							aiVisibleColumns = datePickerVM.getVisibleColumns().sort(function(a, b){
								return a - b;
							});
						} else {
							var recordTotalId = jQuery(self.tableNode()).parents('table').attr('id');
							var selectedYear = datePickerVM.selectedYear();
							var years = Object.keys(statement.getCategorizedColsByYear(true));
							if (!selectedYear && years.length == 1) {
								selectedYear = years[0];
							}

							if (selectedYear) {
								aiSelectedColumns = datePickerVM.staticPeriodNonCalcColumnYearMap[recordTotalId][selectedYear];
								aiVisibleColumns = datePickerVM.staticPeriodColumnYearMap[recordTotalId][selectedYear].sort(function(a, b){
									return a - b;
								});
							}
						}
		
						
						
						var currentColumnIndex = aiSelectedColumns.indexOf(self.tableColumn());
						var currentRowIndex = aiVisibleRows.indexOf(self.tableRow());
						var currentStatementIndex = asVisibleStatements.indexOf(self.tableId());
						
						switch(direction){
							case 'down': 
								if(currentRowIndex + 1 < aiVisibleRows.length){
									currentRow = aiVisibleRows[currentRowIndex + 1];
									self.tableRow(currentRow);
								}else if(currentStatementIndex + 1 < asVisibleStatements.length){
									self.tableId(asVisibleStatements[currentStatementIndex + 1]);
									statement = self.statementContainer[self.tableId()];
									aNodes = statement.getNodes();
									aiVisibleRows = _getVisibleRowNumbers(aNodes);
									self.tableRow(aiVisibleRows[0]);
								}
							break;
							case 'right':
								if(self.tableColumn() != aiSelectedColumns[aiSelectedColumns.length - 1]){
									self.tableColumn(aiSelectedColumns[++currentColumnIndex]);
								}else if(currentStatementIndex + 1 < asVisibleStatements.length){
									self.tableColumn(aiSelectedColumns[0]);
									self.navigate('down');
									return;
								}
							break;
							case 'left':
								if(self.tableColumn() != aiSelectedColumns[0]){
									self.tableColumn(aiSelectedColumns[--currentColumnIndex]);
								}else if(currentStatementIndex != 0){
									self.tableColumn(aiSelectedColumns[aiSelectedColumns.length - 1]);
									self.navigate('up');
									return;
								}
							break;
							case 'up':
								if(currentRowIndex > 0){
									currentRow = aiVisibleRows[currentRowIndex - 1];
									self.tableRow(currentRow);
								}else if(currentStatementIndex != 0){
									self.tableId(asVisibleStatements[currentStatementIndex - 1]);
									statement = self.statementContainer[self.tableId()];
									aNodes = statement.getNodes();
									aiVisibleRows = _getVisibleRowNumbers(aNodes);
									self.tableRow(aiVisibleRows[aiVisibleRows.length - 1]);
								}
							break;
						}
						
					}

					var nextNode = aNodes[0];
					if (nextNode && self.statement().isStaticPeriods()) {
						// Redetermine visible columns in case next/prev record total has different columns
						var recordTotalId = jQuery(aNodes[0]).parents('table').attr('id');
						var selectedYear = datePickerVM.selectedYear();
						var years = Object.keys(statement.getCategorizedColsByYear(true));
						if (!selectedYear && years.length == 1) {
							selectedYear = years[0];
						}

						if (selectedYear) {
							aiVisibleColumns = datePickerVM.staticPeriodColumnYearMap[recordTotalId][selectedYear].sort(function(a, b){
								return a - b;
							});
						}
					}
					
					var nextIndex = aiVisibleColumns.indexOf(self.tableColumn());
					
					if(_.isUndefined(aNodes[self.tableRow()])){
						var statementId = self.statement().recordId();
						var renderingService =
							LifeCycle.SpreadRenderingService.getInstanceForStatementId(statementId);
						
						if (
							!aNodes.length &&
							renderingService.isQueued(statementId)
						) {
							return;
						}
						
						self.navigate(direction);
						return;
						
					}
					self.editingCell(false);
					self.tableNode(aNodes[self.tableRow()]['cells'][nextIndex + 1]);
				}
			};
			
			self.toggleRecordTotalDisplay = function(recordTotalId, bVisible){
				for(var i = 0; i < self.statement().recordTotals().length; i++){
					var recordTotal = self.statement().recordTotals()[i];
					if(recordTotal.recordId() == recordTotalId){
						recordTotal.includeInTotal(bVisible);
						app.publish('SPREAD.Spreads.Group_Selection_Changed', recordTotal);
						break;
					}
				}
			};
			key.setScope('nav');
			key('delete', 'nav', function(event, handler){
				if(self.blockedUI() == false){
					var nNode = jQuery(self.tableNode());
					if(!nNode.hasClass('disabled')){
						var statement = self.statementContainer[self.tableId()];
						if(!statement.bIsTotalsGrid){
							nNode.html(statement.editTableCell(self.tableNode(), null));
						}
					}
				}
				
			});
			
			key('right, left, up, down, tab, enter, shift+enter, shift+tab', 'nav', function(event, handler){
				function _handleKey(event) {
					switch (event.keyCode) {

						case 37: // left
							self.navigate('left');
							break;
						case 38: // up
							self.navigate('up');
							break;
						case 9: // tab
							if (key.shift) {
								console.log('tab-shift');
								self.navigate('left');
								break;
							}
						case 39:
							self.navigate('right');
							break;
						case 13: // enter
							if (key.shift) {
								self.navigate('up');
								break;
							}
						case 40:
							self.navigate('down');
							break;
						default:
							break;

					}
				}
				
				if (
					//TODO: don't be "that guy"
					navigator.appName == 'Microsoft Internet Explorer' ||
					navigator.userAgent.match(/Trident/) ||
					navigator.userAgent.match(/rv 11/) ||
					(window['$'] && typeof $.browser !== "undefined" && $.browser['msie'] == 1)
				) {
					setTimeout(function () {
						_handleKey(event);
					}, 0);
				} else {
					_handleKey(event);
				}
			});
			
			key('.,0,1,2,3,4,5,6,7,8,9,shift+9,=,shift+=,-,(,+,109,107,96,97,98,99,100,101,102,103,104,105,61,173,187', 'nav', function(event, handler){
				if(event.keyCode == 40){
					return;
				}
				if(self.blockedUI() == false){
					var statement = self.statementContainer[self.tableId()];
					if(typeof statement !== "undefined" && !statement.bIsSummaryGroup){
						self.editingCell(true);
						jQuery(self.tableNode()).trigger('navAppEditEvent');
					}
				}
			});

			_getVisibleStatementIds = function(){
				var asVisibleStatements = [];
				_.each(self.statement().recordTotals(), function(recordTotal){
					if(recordTotal.includeInTotal()){
						asVisibleStatements.push(recordTotal.recordId());
					}
				});
				return asVisibleStatements;
			};
			
			_getVisibleRowNumbers = function(aNodes){
				var aiVisibleRows = [];
				for(var i = 0; i < aNodes.length; i++){
					if(aNodes[i].rowIndex > 0 && !_.contains(aNodes[i]['firstChild']['classList'], 'disabled')){
						aiVisibleRows.push(i);
					}
				}
				return aiVisibleRows;
			};
			
			return self;
			
		}
	};
	
	if(LifeCycle.SpreadNavigation.ViewModel == undefined){
		LifeCycle.SpreadNavigation.ViewModel = ViewModel;
	}
	
})();

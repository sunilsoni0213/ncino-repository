(function(){
	var View = function(event, app){
		app.View = function(viewModel){
			var self = this;
			self.bReadyToClose = false;

			var _recordHasValue = function(statement, record){
				var containsValues = false;
				_.each(statement.recordValueMap, function(periodMap){
					if(_.contains(_.keys(periodMap), record.recordId())){
						containsValues = true;
					}
				});
				return containsValues;
			};

			var _getDisplayDate = function(statementDate){
				var sDate = _setTimezoneOffset(statementDate);
				return (sDate.getMonth()+1) + '/' + sDate.getDate() + '/' + sDate.getFullYear();
			};

			function _setTimezoneOffset(time) {
				time = new Date(time);
				var newDate = new Date(time.getTime()+time.getTimezoneOffset()*60*1000);

				var offset = time.getTimezoneOffset() / 60;
				var hours = time.getHours();

				newDate.setHours(hours - offset);
				return newDate;
			}

			var _removeElements = function(selector) {
					var elementsToDetach = jQuery(selector);
					if (!_.isUndefined(elementsToDetach)) {
						elementsToDetach.remove();
					}
			};

            function getRentRollPeriodYear(statement){
                var rentRoll = undefined;
                for(var i = 0; i < viewModel.rentRolls().length; i++){
                    if(viewModel.rentRolls()[i].statementId() == statement.recordId()){
                        rentRoll = viewModel.rentRolls()[i];
                    }
                }

                if(_.isUndefined(rentRoll)){
                    return undefined;
                }

                var date = new Date(rentRoll.currentYear());
                return date.getFullYear();
            }
			
			/**
			 * @typedef {KOStatement} SpreadBaseStatement
			 * @property selectedOrderedPeriodIds
			 * @property periodMap
			 */
			
			/**
			 *
			 * @param table
			 * @param {SpreadBaseStatement} statement
			 * @param {boolean} displayCommonSizing
			 * @param {boolean} displayTrend
			 * @param periodFilterYear
			 * @return {string|*}
			 */
            function getStatementHeaders(table, statement, displayCommonSizing, displayTrend, periodFilterYear){

                var header = '<tr><th></th>';

                if(!statement.isStaticPeriods()){

                    // statement date
                    _.each(statement.periods(), function (period) {
						if (statement.selectedOrderedPeriodIds.indexOf(period.recordId()) == -1) {
							return;
						}
						
                        header += (displayTrend && LifeCycle.SpreadData.TrendService.hasPreviousTrendPeriod(period) ?'<th></th>':'');
                        header += '<th id="' + ko.unwrap(period.lookupKey) + '" class="' + LifeCycle.msgs.msg_commentable_class + '">' + _getDisplayDate(period.statementDate()) + '</th>';
                        header += (displayCommonSizing?'<th></th>':'');
                    });
                    header += '</tr>';

                    // number of months
                    header += '<tr><th></th>';
                    _.each(statement.periods(), function (period) {
						if (statement.selectedOrderedPeriodIds.indexOf(period.recordId()) == -1) {
							return;
						}
						
                        header += (displayTrend && LifeCycle.SpreadData.TrendService.hasPreviousTrendPeriod(period) ?'<th></th>':'');
                        var numberOfPeriods = period.numberOfPeriods();
                        header += '<th>' + (numberOfPeriods > 1 ? numberOfPeriods + ' months' : numberOfPeriods + ' month') + '</th>';
                        header += (displayCommonSizing?'<th></th>':'');
                    });
                    header += '</tr>';

                    // sources
                    header += '<tr><th></th>';
                    _.each(statement.periods(), function (period) {
						if (statement.selectedOrderedPeriodIds.indexOf(period.recordId()) == -1) {
							return;
						}
						
                        header += (displayTrend && LifeCycle.SpreadData.TrendService.hasPreviousTrendPeriod(period) ?'<th></th>':'');
                        header += '<th>' + period.source() + '</th>';
                        header += (displayCommonSizing?'<th></th>':'');
                    });
                    header += '</tr>';

                    // analyst
                    header += '<tr><th></th>';
                    _.each(statement.periods(), function (period) {
						if (statement.selectedOrderedPeriodIds.indexOf(period.recordId()) == -1) {
							return;
						}
						
                        header += (displayTrend && LifeCycle.SpreadData.TrendService.hasPreviousTrendPeriod(period) ?'<th><div class="trend_column"> Trend % </div></th>':'');
                        header += '<th>' + (period.analystName ? period.analystName() : '') + '</th>';
                        header += (displayCommonSizing?'<th><div class="cs">' + LifeCycle.msgs.msg_spread_common_sizing_header_title + '</div></th>':'');
                    });
                    header += '</tr>';
                }else{
                    _.each(statement.periods(), function (period) {
						if (statement.selectedOrderedPeriodIds.indexOf(period.recordId()) == -1) {
							return;
						}
						

                        if(_.isUndefined(periodFilterYear) || period.year() == periodFilterYear){
                            header += (displayTrend && LifeCycle.SpreadData.TrendService.hasPreviousTrendPeriod(period) ?'<th><div class="trend_column"> Trend % </div></th>':'');
                            header += '<th>' + period.nameOverride() + '</th>';
                            header += (displayCommonSizing?'<th><div class="cs">' + LifeCycle.msgs.msg_spread_common_sizing_header_title + '</div></th>':'');
                        }
                    });
                    header += '</tr>';
                }

                table += header;

                return table;
            }
			
            function getStatementRows (table, statement, displayCommonSizing, displayTrend, bExcel, periodFilterYear){

                _.each(statement.recordTotals(), function(recordTotal){

                    if(recordTotal.includeInTotal()){

                        if(!recordTotal.isHideAllRecords()){
                            _.each(recordTotal.records(), /** @param {KORecord} record */ function(record){

                                if(
                                	record.includeInTotal() &&
									(
                                        !viewModel.hideEmptyRecords() ||
										_recordHasValue(statement, record)
									)
								){
                                    var recordRow = '<tr>';
                                    recordRow += '<td id="' + ko.unwrap(record.recordId) + '" class="' + LifeCycle.msgs.msg_commentable_class + '"><div class="record">'+(bExcel?'&nbsp;&nbsp;':'')+(record.isDebit()?'('+record.name()+')':record.name())+'</div></td>';
                                    _.each(statement.periods(), function(period){
                                        if (statement.selectedOrderedPeriodIds.indexOf(period.recordId()) == -1) {
											return;
										}

                                        if(_.isUndefined(periodFilterYear) || period.year() == periodFilterYear){
                                            var currentRecordValue = LifeCycle.SpreadData.lookupRecordValueByRecordAndPeriod(record, period, true);
                                            var commentId = ko.unwrap(period.lookupKey) + '_' + ko.unwrap(record.recordId);
	
											var cellValue = (currentRecordValue.value() || 0);
                                            var displayCellValue = LifeCycle.SpreadData.FormattingService.formatRecordValue(cellValue, record);
                                           
                                            var commonSizingValue;
                                            if (displayCommonSizing) {
                                            	commonSizingValue = LifeCycle.SpreadData.CommonSizingService.calculateAndFormatCommonSizing(currentRecordValue);
											}
											
											var trendValue;
                                            if (displayTrend) {
                                            	trendValue = LifeCycle.SpreadData.TrendService.calculateAndFormatTrend(currentRecordValue);
											}

											recordRow += (displayTrend && LifeCycle.SpreadData.TrendService.hasPreviousTrendPeriod(period) ? '<td><div class="trend_column">'+trendValue+'</div></td>':'');
											recordRow += '<td id="' + commentId + '" class="' + LifeCycle.msgs.msg_commentable_class + '"><div>'+ displayCellValue +'</div></td>';
											recordRow += (displayCommonSizing?'<td><div class="cs">'+commonSizingValue+'</div></td>':'');
                                        }
                                    });
                                    recordRow += '</tr>';
                                    table += recordRow;
                                }
                            });
                        }

                        if (!recordTotal.hideColumnTotals()) {
                            var recordTotalRow = '<tr class="recordTotalRow' +(recordTotal.isSummaryGroup()?' grandTotal':'')+ '">';
                            recordTotalRow += '<td id="' + recordTotal.recordId() + '" class="' + LifeCycle.msgs.msg_commentable_class + '">';
                            recordTotalRow += '<div class="recordTotalName"><b>'+recordTotal.name()+'</b></div></td>';

                            _.each(statement.periods(), function(period){
								if (statement.selectedOrderedPeriodIds.indexOf(period.recordId()) == -1) {
									return;
								}
								
                                if(_.isUndefined(periodFilterYear) || period.year() == periodFilterYear){
									var currentPeriodTotal = LifeCycle.SpreadData.lookupPeriodTotalByRecordTotalAndPeriod(recordTotal, period, true);
									var commentId = ko.unwrap(period.lookupKey) + '_' + ko.unwrap(recordTotal.recordId);
									
									var cellValue = (currentPeriodTotal.value() || 0);
                                   
                                    var commonSizingValue;
                                    if (displayCommonSizing) {
                                    	commonSizingValue = LifeCycle.SpreadData.CommonSizingService.calculateAndFormatCommonSizingTotal(currentPeriodTotal);
									}
                                    
                                    if (displayTrend) {
                                    	var trendValue = LifeCycle.SpreadData.TrendService.calculateAndFormatTrendTotal(currentPeriodTotal);
										if(LifeCycle.SpreadData.TrendService.hasPreviousTrendPeriod(period)){
											recordTotalRow += (displayTrend?'<td><div class="trend_column"><b>'+trendValue+'</b></div></td>':'');
										}
									}
           

                                    recordTotalRow += '<td id="' + commentId + '" class="' + LifeCycle.msgs.msg_commentable_class + '"><div><b>';
									recordTotalRow += LifeCycle.SpreadData.FormattingService.formatPeriodTotal(cellValue, recordTotal) +'</b></div></td>';
									recordTotalRow += (displayCommonSizing?'<td><div class="cs"><b>'+ commonSizingValue + '</b></div></td>':'');
                                }
                            });

                            recordTotalRow += '</tr>';
                            table += recordTotalRow;
                        } else {
                            table += '<tr class="recordTotalRow"><td colspan="'
                                + (statement.selectedOrderedPeriodIds.length + 1)
                                + '">&nbsp;</td></tr>';
                        }
                    }
                });

                return table;
            }

			self.render = function(text){
				var bPrint = false;
				var bExcel = false;
				var bDisplayOnPage = false;
				var viewMode = app.viewModel.viewMode();
				var bAutoClose = app.viewModel.autoclose();
				
				if(viewMode == 'print'){
					bDisplayOnPage = true;
					bPrint = true;
				}else if(viewMode == 'excel'){
					bExcel = true;
					bDisplayOnPage = true;
				}else if(viewMode == 'display'){
					bDisplayOnPage = true;
				}
				var html = '';

				if (!viewModel.isGlobalOnly()) {
					var exportedDebtSchedules = [];
					var exportedRmaStatements = [];
					var exportedRentRolls = [];
					var exportedFootnotes = [];
					_.each(viewModel.bundles(), /** @param {KOUnderwritingBundle} bundle */ function(bundle){
						for(var x = 0; x < bundle.statements().length; x++){
							var statement = bundle.statements()[x];
							
							/** @type {KOSpread} */
							var spread = _.find(statement.spreads(), function(spread){
								return spread.loan.recordId() == viewModel.loanId();
							});

							if(_.isUndefined(spread) || ko.unwrap(spread.collateralMgmt) && !viewModel.includeCRE()){
								break;
							}else{
								var entityId = statement.spreads()[0].involvement.recordId();
								if(viewModel.exportDebtSchedule() && !_.contains(exportedDebtSchedules, entityId)){
									var nDebtSchedule = jQuery('#debtschedule-' + entityId);
									if(nDebtSchedule.html()) {
										html += nDebtSchedule.html();
									}
									exportedDebtSchedules.push(entityId);
								}
								var relationshipId = statement.spreads()[0].involvement.relationship.recordId()
								if(viewModel.exportRmaStatement() && !_.contains(exportedRmaStatements, relationshipId)){
									var nRmaStatement = jQuery('#rmaBenchmarks-' + relationshipId);
									if(nRmaStatement.html()){
										html += nRmaStatement.html() + '<div class="always-break-after" />';
									}
									exportedRmaStatements.push(relationshipId);
								}

								if(viewModel.entities().length > 0){
									var exportedEntity = undefined;
									_.each(viewModel.entities(), function(entity) {
									    if (_.isUndefined(exportedEntity)) {
											_.each(statement.spreads(), function(spread) {
												if (entity.recordId() == spread.involvement.recordId()) {
												exportedEntity = entity;
												}
											});
									    }
									});
									exportedEntity.exported = true;
								}

								var scaleLabel = LifeCycle.SpreadData.FormattingService.formatScaleInToDisplayString(bundle.scaleDivisor(),true);

								var table = '';
								if(bPrint){
									table += '<div class="always-break-after" style="padding: 1em;">'
										+'<div class="statementName">' + statement.statementType() + ' ' + '<span class="spread_bundle_scale_label">' + scaleLabel + '</span>' + '</div>'
										+'<div>' + statement.spreads()[0].involvement.relationship.name() + ' ('+ statement.spreads()[0].involvement.relationship.entityType() +')</div>'
										+'<div>' + statement.spreads()[0].involvement.borrowerType() + '</div>';
									table += '<hr/><table class="spread_print_table">';
								}else if(bExcel || bDisplayOnPage){
									table += '<table>'
										+'<tr><td><b>'+statement.statementType() + ' ' + '<span class="spread_bundle_scale_label">' + scaleLabel + '</span>' + '</b></td></tr>'
										+'<tr><td><b>' + statement.spreads()[0].involvement.relationship.name() + ' ('+ statement.spreads()[0].involvement.relationship.entityType() +')</b></td></tr>'
										+'<tr><td><b>'+statement.spreads()[0].involvement.borrowerType()+'</b></td></tr>'
										+'</table>';
									table += '<table class="spread_print_table">';
								}

                                var displayTrend = statement.displayTrend() && statement.supportsTrend();
								var displayCommonSizing = statement.displayCommonSizing() && statement.supportsCommonSizing();

                                if(statement.statementType() === LifeCycle.msgs.msg_spread_noi_statement){
                                    var year = getRentRollPeriodYear(statement);
                                    table = getStatementHeaders(table, statement, displayCommonSizing, displayTrend, year);
								    table = getStatementRows(
										table,
										statement,
										displayCommonSizing,
										displayTrend,
										bExcel,
										year
									);
								}else{
								    table = getStatementHeaders(table, statement, displayCommonSizing, displayTrend);
								    table = getStatementRows(
										table,
										statement,
										displayCommonSizing,
										displayTrend,
										bExcel,
										undefined
									);
								}
								table += '</table><br />';

								// Add the footnotes below the statement.
								_.each(statement.spreads(), function(spread) {
									var spreadId = spread.recordId();
									if (ko.unwrap(bundle.showFootnotes) && !_.contains(exportedFootnotes, spreadId)) {
										var nodeId = '#footnotes-' + spreadId;
										var nFootnotes = jQuery(nodeId);
										if (!_.isUndefined(nFootnotes.html())) {
											table += nFootnotes.html();
										}
										exportedFootnotes.push(spreadId);
									}
								});

								table += '</div>';

								if(bExcel){
									table += '<hr />';
								}
								html += table;

								if (_.isFunction(spread.collateralMgmt)) {
									if (viewModel.includeCRE() && !_.contains(exportedRentRolls, spread.collateralMgmt())) {
										var nodeId = '#loaninformation-'+spread.collateralMgmt();
										var nLoanInformation = jQuery(nodeId);
										if (!_.isUndefined(nLoanInformation.html())) {
											html += nLoanInformation.html();
										}
										nodeId = '#sensitivityanalysis-'+spread.collateralMgmt();
										var nSensitivityAnalysis = jQuery(nodeId);
										if (!_.isUndefined(nSensitivityAnalysis.html())) {
											html += nSensitivityAnalysis.html();
										}
										nodeId = '#rentroll-'+spread.collateralMgmt();
										var nRentRoll = jQuery(nodeId);
										if (!_.isUndefined(nRentRoll.html())) {
											html += nRentRoll.html();
										}
									}
								}
							}
						}
					});

					var spreadingNotStartedForEntity = false;
					for(var i = 0; i < app.viewModel.entities().length; i++){
						var entity = app.viewModel.entities()[i];
						if(_.isUndefined(entity.exported) || (entity.exported == false && viewModel.scope() != 'entity')){
							spreadingNotStartedForEntity = true;
							html += '<table>'
								+'<tr><td><b>' + entity.relationship.name() + ' ('+ entity.relationship.entityType() +')</b></td></tr>'
								+'<tr><td><b>' + entity.borrowerType() + '</b></td></tr>'
								+'<tr><td>'
								+'<p>' + LifeCycle.msgs.msg_spread_base_print_view_underwriting_not_started + '</p>'
								+'</tr></td>'
								+'</table>';
						}
					}

					if(spreadingNotStartedForEntity){
						html += '<div class="always-break-after" />';
					}
				}

				if (viewModel.exportGlobalAnalysis()) {
					var gaNodeId = '#global-analysis-print';
					var nGlobalAnalysis = jQuery(gaNodeId);
					if (!_.isUndefined(nGlobalAnalysis.html())) {
						if (bExcel) {
							jQuery("#global-analysis-templates").detach();
						}
						html += nGlobalAnalysis.html();
					}
				}

				jQuery("#loading-modal").modal("hide");

				var excelStart = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>Worksheet</x:Name><x:WorksheetOptions><x:DisplayGridlines /></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body>';
				var excelEnd = '</body></html>';

				if(bDisplayOnPage){
					jQuery('#spread_print_main').append(html);
				}

				if (!bPrint) {
					_removeElements('.print-only');
				}
				if (!bExcel) {
					_removeElements('.excel-only');
				}

				if(bExcel){
					return excelStart + html + excelEnd;
				}

				if(bPrint){
					window.print();
					self.bReadyToClose = true;
				}

				if(bAutoClose){
					setInterval(function(){
						if(self.bReadyToClose === true){
							window.close();
							// prevent infinite loop if page was not opened by window.open
							_bPrinted = false;
						}
					},500);
				}
			};
			return self;
		};
		app.log('View initialized.');
	};
	if(LifeCycle.Spread_Base == undefined){
		LifeCycle.Spread_Base = {};
	}
	if(LifeCycle.Spread_Base.View == undefined){
		LifeCycle.Spread_Base.View = View;	
	}
})();

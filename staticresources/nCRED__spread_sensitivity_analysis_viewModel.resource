(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(serverData){

			Array.prototype.upsert = function (recordToUpsert) {
				upsert(this, recordToUpsert);
			};
			ko.observableArray.fn.upsert = function (recordToUpsert) {
				upsert(this, recordToUpsert);
			};
			var upsert = function (array, recordToUpsert) {
				var idToUpdate;
				if (typeof recordToUpsert.recordId == 'function') {
					idToUpdate = recordToUpsert.recordId();
				} else {
					idToUpdate = recordToUpsert.recordId;
				}

				var matched = false;
				var idIndexes = [];
				var arraySnapshot;
				if (typeof array == 'function') {
					arraySnapshot = array();
				} else if (typeof array == 'object' && array instanceof Array) {
					arraySnapshot = array;
				}
				for (var i = 0; i < arraySnapshot.length; i++) {
					var record = arraySnapshot[i];

					var idToCompare;
					if (typeof record.recordId == 'function') {
						idToCompare = record.recordId();
					} else {
						idToCompare = record.recordId;
					}

					if (idToCompare == idToUpdate) {
						matched = true;
						array.splice(i, 1, recordToUpsert);
					}
				}

				if (!matched) {
					array.push(recordToUpsert);
				}
			};
			ko.extenders.currency = function(target, showDollar) {
				target.currency = ko.computed({
					read: function() {
						return ((showDollar) ? '$' : '') + Number(this()).formatMoney(2, '.', ',');
					},
					write: function(value) {
						this(value.replace(/[^0-9\.]/g, ''));
					},
					owner: target
				});
				return target;
			};
			ko.extenders.percentage = function(target, showPercent) {
				target.percentage = ko.computed({
					read: function() {
						return (this() * 100).toFixed(2) + ((showPercent) ? '%' : '');
					},
					write: function(value) {
						this(value.replace(/[^0-9\.\-]/g, '') / 100);
					},
					owner: target
				});
				return target;
			};
			ko.bindingHandlers.saColumnText = {
				update: function(element, valueAccessor, allBindingsAccessor) {
					var type = allBindingsAccessor().type || '';
					var value = ko.unwrap(valueAccessor());
					var formatted;

					if (isNaN(value)) {
						formatted = 'N/A';
					} else if (value == Infinity) {
						formatted = 'Infinity';
					} else if (type == 'percent') {
						formatted = (value * 100).toFixed(2) + "%";
					} else if (type == 'currency') {
						formatted = '$' + Number(value).formatMoney(2, '.', ',');
					} else {
						formatted = Number(value).toFixed(2);
					}

					ko.bindingHandlers.text.update(element, function() {
						return formatted;
					});
				}
			};
			Number.prototype.formatMoney = function(c, d, t) {
				var n = this,
					c = isNaN(c = Math.abs(c)) ? 2 : c,
					d = d == undefined ? "." : d,
					t = t == undefined ? "," : t,
					s = n < 0 ? "-" : "",
					i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "",
					j = (j = i.length) > 3 ? j % 3 : 0;
				return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
			};

			/*
				Author: @Adam on StackOverflow
				Source: http://stackoverflow.com/questions/2094967/excel-pmt-function-in-js
			*/
			Math.pmt = function (rate_per_period, number_of_payments, present_value, future_value, type) {
				if (rate_per_period != 0.0) {
					// Interest rate exists
					var q = Math.pow(1 + rate_per_period, number_of_payments);
					return -(rate_per_period * (future_value + (q * present_value))) / ((-1 + q) * (1 + rate_per_period * (type)));

				} else if (number_of_payments != 0.0) {
					// No interest rate, but number of payments exists
					return -(future_value + present_value) / number_of_payments;
				}

				return 0;
			};

			function padLeft(value, length) {
				if (typeof value === 'undefined') {
					value = '';
				}
				return (value.toString().length < length) ? padLeft(" " + value, length) : value.toString().substring(0, length);
			}

			function padRight(value, length) {
				if (typeof value === 'undefined') {
					value = '';
				}
				return (value.toString().length < length) ? padRight(value + " ", length) : value.toString().substring(0, length);
			}

			if (!app.subscribeOnce) {
				var o = jQuery(window.document);
				app.subscribeOnce = function(topic, callback){
					function wrapper(){
						return callback.apply(this, Array.prototype.slice.call(arguments, 1));
					}
					o.one(topic, wrapper);
				};
			}

			var self = this;
			self.app = app;
			var defaultData = {
				statement: null,
				spread: null,
				loan: null,
				collateral: null,

				info: null,

				isSSAOpen: false,
				isLoanInfoOpen: false,
				mode: ''
			};
			if(serverData != undefined){
				_.extend(defaultData, serverData);
			}

			app.setMapping({
				'info': {
					create: function(options){
						return new app.SAInfo(options.data);
					}
				}
			});

			app.mapFromJS(defaultData, app.getMapping(), self);

			self.isOpen = ko.computed(function () {
				return (self.isSSAOpen() || self.isLoanInfoOpen());
			}, self);

			self.savedInfo = ko.observable(app.mapToJS(self.info, {useOptimizedMapper: true}));
			self.isLoading = ko.observable(true);
			self.isPrintView = ko.computed(function() {
				return self.mode() == LifeCycle.msgs.msg_mode_print; 
			});
			self.isDirty = ko.computed(function () {
				if (self.isLoading()) {
					return false;
				}
				var current = app.mapToJS(self.info, {useOptimizedMapper: true});
				var saved = self.savedInfo();

				// do not take selected period into account
				current.period = undefined;
				saved.period = undefined;

				var currentJSON = JSON.stringify(current);
				var savedJSON = JSON.stringify(saved);
				return savedJSON != currentJSON;
			});
			self.isDirty.subscribe(function (dirty) {
				if (dirty) {
					app.publish('SPREAD.Spreads.Dirty_Data');
				}
			});
			app.subscribe('SPREAD.Spreads.Saved', function (data) {
				self.save(data);
			});
			var o = jQuery(window.document);
			app.subscribeOnce = function(topic, callback){
				function wrapper(){
					return callback.apply(this, Array.prototype.slice.call(arguments, 1));
				}
				o.one(topic, wrapper);
			};
			app.subscribeOnce("SPREAD.Spreads.Load_Sensitivity_Analysis", function (sensitivityAnalysisParams) {
				var sensitivityAnalysisVM = new app.ViewModel(sensitivityAnalysisParams);
				sensitivityAnalysisVM.load(function(){
					app.publish("SPREAD.Spreads.Sensitivity_Analysis_Loaded", sensitivityAnalysisVM);
				});
			});

			self.load = function(callback){
				if (!_.isNull(self.collateral.recordId())) {
					self.isLoading(true);

					function _iforceCallback () {
						var parentId = self.statement.recordId();
						if (self.spread && self.spread.recordId()) {
							parentId = self.spread.recordId();
						}
						LifeCycle.Spreads.loadSensitivityAnalysisContainer(
							parentId,
							function (result) {
								if(result){
									result = JSON.parse(jQuery('<textarea />').html(
										JSON.stringify(result)
											.replace(/&lt;/g, '<')
											.replace(/&gt;/g, '>')
										).text()
									);

									app.mapFromJS({
										info: result
									}, app.getMapping(), self);

									self.savedInfo(app.mapToJS(self.info, {useOptimizedMapper: true}));

									// Match period to available period
									if (result.period) {
										for (var i = 0; i < self.statement.periods().length; i++) {
											var _period = self.statement.periods()[i];
											if (_period.periodKey() == result.period.periodKey) {
												self.info.period(_period);
												break;
											}
										}
									}

									self.info.period.subscribe(function (newPeriod) {
										if (!self.isDirty()) {
											// save period change
											self.save();
										}
									});

									var syntaxChanged = false;
									self.setFields(self.info.fields(), function (fields, _syntaxChanged) {
										syntaxChanged |= _syntaxChanged;

										self.setTables(self.info.tables(), function (tables, _syntaxChanged) {
											syntaxChanged |= _syntaxChanged;

											if (syntaxChanged) {
												// Save before completing loading to send resolved names back to server
												self.save(true);
											}

											self.isLoading(false);
											callback.apply();
										});
									});
								}
							},
							function () {}
						);
					}

					LifeCycle.SpreadData.getIForceById(
						self.loan.recordId(),
						{},
						function (_loan) {
							_loan.interestRate(_loan.interestRate() / 100.0);
							self.loan = _loan;

							LifeCycle.SpreadData.getStatementById(
								self.statement.recordId(),
								{wait: true},
								function (_statement) {
									self.statement = _statement;

									if (self.spread && self.spread.recordId()) {
										LifeCycle.SpreadData.getSpreadById(
											self.spread.recordId(),
											{},
											function (_spread) {
												self.spread = _spread;
												_iforceCallback();
											}
										);
									} else {
										_iforceCallback();
									}

								}
							);
						}
					);

					app.subscribe("SPREAD.Spreads.Fullscreen_App_Opened", self.closeSSA);
					app.subscribe("SPREAD.Spreads.Fullscreen_App_Opened", self.closeLoanInfo);

					var ssaButton = document.getElementById('sensitivity_analysis_button');
					if (ssaButton) {
						ko.applyBindings(self, ssaButton);
					}

					var ssaLoanInfoButton = document.getElementById('sensitivity_analysis_loan_information_button');
					if (ssaLoanInfoButton) {
						ko.applyBindings(self, ssaLoanInfoButton);
					}
				}
			};

			self.toggleSSA = function (e) {
				app.publish("SPREAD.Spreads.Fullscreen_App_Opened", self.app.appId);
				self.isSSAOpen(!self.isSSAOpen());
			};

			self.toggleLoanInfo = function (e) {
				app.publish("SPREAD.Spreads.Fullscreen_App_Opened", self.app.appId);
				self.isLoanInfoOpen(!self.isLoanInfoOpen());

				_toggle(e);
			};

			function _toggle (e) {
				if (!_.isUndefined(key)) {
					if (self.isLoanInfoOpen()) {
						key.setScope('sensitivity_analysis_loan_information');
					} else {
						key.setScope('nav');
					}
				}
			}

			self.closeSSA = function (e) {
				if (e != self.app.appId) {
					self.isSSAOpen(false);
				}
			};

			self.closeLoanInfo = function (e) {
				if (e != self.app.appId) {
					self.isLoanInfoOpen(false);
				}
			};

			self.save = function(ignoreLoading){
				if (!ignoreLoading && self.isLoading()) {
					throw "Tried to save SA while still loading";
				}

				var parentId = self.statement.recordId();
				if (self.spread && self.spread.recordId()) {
					parentId = self.spread.recordId();
				}

				var info = app.mapToJS(self.info, {useOptimizedMapper: true});

				LifeCycle.Force.saveAttachment(
					parentId,
					LifeCycle.msgs.msg_sensitivity_analysis_filename,
					'application/json',
					JSON.stringify(info),
					true,
					false,
					function () {
						app.log('Saved SA');
						self.savedInfo(app.mapToJS(self.info, {useOptimizedMapper: true}));
					},
					function (err) {
						app.log('Error saving SA');
						app.log(err);
					}
				);
			};



			self.setFields = function (fields, callback) {
				var syntaxChanged = false;
				self.info.fields([]);

				var remaining = [];
				for (var f = 0; f < fields.length; f++) {
					var field = fields[f];
					remaining.push(field);
				}


				function _linkFieldToRecords (field, allLinkCallback) {
					function _linkFieldToRecord (field, syntax, allLinkCallback) {
						var linkSyntax = syntax;
						if (!linkSyntax) {
							// Resolved
							return;
						}
						

						function _recordCallback (_recordId) {
							var record = LifeCycle.SpreadData.lookupIForceById(_recordId);
							field.linkedRecordSyntaxes.replace(syntax, '<#' + _recordId + '>');
							syntaxChanged = true;
							if (record) {
								_linkCallback(field, record, allLinkCallback);
							} else {
								console.error('SA: Field record still not available even after loading statement. Unable to continue');
								return;
							}
						}

						function _linkCallback (field, record, allLinkCallback) {
							// Link records
							field.linkedRecords.push(record);

							if (allLinkCallback) {
								if (_isFieldLinked(field)) {
									allLinkCallback(field);
								}
							}
						}

						if (linkSyntax.indexOf('<#') == 0) {
							var recordId = linkSyntax.substring(2, linkSyntax.length - 1);
							var record = LifeCycle.SpreadData.lookupIForceById(recordId);

							if (record) {
								_linkCallback(field, record, allLinkCallback);
							} else {
								var currentStatementId = self.statement.recordId();

								app.subscribe('SPREAD.Spreads.Spread_Data.Loaded_Statement', function (_statement) {
									if (_18Id(_statement.recordId()) != _18Id(currentStatementId)) {
										return;
									}
									var record = LifeCycle.SpreadData.lookupIForceById(recordId);
									if (record) {
										_linkCallback(field, record, allLinkCallback);
									} else {
										console.error('SA: Field record still not available even after loading statement. Unable to continue');
										return;
									}
								});
							}

						} else if (linkSyntax.indexOf('<!') == 0){
							var recordName = linkSyntax.substring(2, linkSyntax.length - 1);

							self.resolveRecordNameToId(recordName, _recordCallback);
						}
					}

					if (_isFieldLinked(field)) {
						if (allLinkCallback) {
							allLinkCallback(field);
						}
						return;
					}
					
					var syntaxes = field.linkedRecordSyntaxes();
					for (var i = 0; i < syntaxes.length; i++) {
						var syntax = syntaxes[i];
						_linkFieldToRecord(field, syntax, allLinkCallback);
					}
				}

				function _isFieldLinked (field) {
					var syntaxes = field.linkedRecordSyntaxes();
					var records = field.linkedRecords();

					return (syntaxes.length == records.length);
				}
								
				function _isAllFieldsLinked (fields) {
					for (var f = 0; f < fields.length; f++) {
						var field = fields[f];
						if (!_isFieldLinked(field)) {
							return false;
						}
					}
					return true;
				}

				function _processCalculatedValue (field, valueCallback) {
					var commonPeriods = null;

					// Is Calculated?
					if (!field.calculated()) {
						if (valueCallback) {
							valueCallback();
						}
						return;
					}

					if (_isFieldLinked(field)) {
						var records = field.linkedRecords();

						function _periodsMatch (periods1, periods2) {
							if (periods1.length != periods2.length) {
								return false;
							}

							for (var i = 0; i < periods1.length; i++) {
								var period1 = periods1[i];
								var period2 = periods2[i];

								if (period1.periodKey() != period2.periodKey()) {
									return false;
								}
							}

							return true;
						}

						if (field.periodSpecific()) {
							for (var r = 0; r < records.length; r++) {
								var record = field.linkedRecords()[r];
								var statementId = record.recordTotal.statement.recordId();
								var statement = LifeCycle.SpreadData.lookupStatementById(statementId);
								var periods = statement.periods();

								if (commonPeriods) {
									if (!_periodsMatch(commonPeriods, periods)) {
										app.log('SAField linked records include mismatched periods, stopping');
										return;
									}
								} else {
									commonPeriods = periods;
								}
							}
						}

						function _resolveFieldSyntax (field, fieldCallback) {
							var syntax = field.initialValue();

							if (_isSyntaxResolved(syntax)) {
								field.initialValue(syntax);
								if (fieldCallback) {
									fieldCallback();
								}
								return;
							}

							function _replaceNameWithId (recordName) {
								self.resolveRecordNameToId(recordName, function (recordId) {
									syntax = syntax.replace(
										'<!' + recordName + '>', 
										'<#' + recordId + '>'
									);
									syntaxChanged = true;

									if (_isSyntaxResolved(syntax)) {
										field.initialValue(syntax);
										
										if (fieldCallback) {
											fieldCallback();
										}
									}
								});
							}
							
							var recordNames = syntax.match(/<![^>]+>/g);
							if (recordNames) {
								for (var r = 0; r < recordNames.length; r++) {
									var recordName = recordNames[r];
									_replaceNameWithId(
										recordName.replace('<!', '').replace('>', '')
									);
								}
							}
						}

						_resolveFieldSyntax(field, function () {

							function _fieldEvaluator () {
								var result = self.calculate(this.syntax, 0, [], this.period);
								if (typeof result == 'number') {
									return result.toString();
								} else {
									return result;
								}
							}

							if (field.periodSpecific()) {
								for (var p = 0; p < commonPeriods.length; p++) {
									var period = commonPeriods[p];
									var data = {
										syntax: field.initialValue(),
										period: period
									};
									var computed = ko.computed(_fieldEvaluator, data);
									field.periodValues.push({
										period: period,
										value: computed
									});
								}
							} else {
								var data = {
									syntax: field.initialValue(),
									period: null
								};
								var computed = ko.computed(_fieldEvaluator, data);
								field.value = computed;
							}

							if (valueCallback) {
								valueCallback();
							}
						});
					}
				}

				function _isAllFieldValueSyntaxResolved (fields) {
					for (var i = 0; i < fields.length; i++) {
						if (!fields[i].calculated()) {
							continue;
						}

						var syntax = fields[i].initialValue();
						if (!syntax) {
							continue;
						}
						if (!_isSyntaxResolved(syntax)) {
							return false;
						}
						if (!fields[i].processed) {
							return false;
						}
					}
					return true;
				}


				function _isAllFieldInitialValueSyntaxResolved (fields) {
					for (var i = 0; i < fields.length; i++) {
						var syntax = fields[i].initialValue();
						if (!syntax) {
							continue;
						}
						if (!_isSyntaxResolved(syntax)) {
							return false;
						}
						if (!fields[i].processed) {
							return false;
						}
					}
					return true;
				}

				function _processInitialValueOnField (field, initialValueCallback) {
					field.processed = false;

					if (field.calculated()) {
						field.processed = true;
						if (initialValueCallback) {
							initialValueCallback();
						}
						return;
					}

					var syntax = field.initialValue();
					if (!syntax) {
						field.initialValue('');
						field.processed = true;
						if (initialValueCallback) {
							initialValueCallback();
						}
						return;
					}

					function _resolutionCallback () {
						// One time calculation
						syntax = field.initialValue();
						var value = self.calculate(syntax);
						// Prevent re-calculation
						field.initialValue('');
						field.value(value);

						if (initialValueCallback) {
							initialValueCallback();
						}
					}

					function _replaceNameWithId (recordName) {
						self.resolveRecordNameToId(recordName, function (recordId) {
							syntax = syntax.replace(
								'<!' + recordName + '>', 
								'<#' + recordId + '>'
							);

							syntaxChanged = true;

							field.initialValue(syntax);

							if (_isSyntaxResolved(syntax)) {
								field.processed = true;
							}

							_resolutionCallback();
						});
					}
					
					var recordNames = syntax.match(/<![^>]+>/g);
					if (recordNames) {
						for (var r = 0; r < recordNames.length; r++) {
							var recordName = recordNames[r];
							_replaceNameWithId(
								recordName.replace('<!', '').replace('>', '')
							);
						}
					} else {
						field.processed = true;
						_resolutionCallback();
					}
				}

				function _singleFieldFlow (field) {

					// Initial Value Flow
					_processInitialValueOnField(field, function () {
						// Initial Value Done

						// Verify
						var syntax = field.initialValue();
						if (!field.processed) {
							throw "SAField: Initial Value callback fired before initial value syntax resolved";
						}

						// Linking Flow
						_linkFieldToRecords(field, function () {
							// Linking Done

							// Verify
							if (!_isFieldLinked(field)) {
								throw "SAField: Linked Record callback fired before all records linked";
							}

							// Calculated Value Flow
							_processCalculatedValue(field, function () {
								// Calculated Flow Done

								// Verify
								if (field.calculated()) {
									var syntax = field.initialValue();
									if (!_isSyntaxResolved(syntax)) {
										throw "SAField: Calculated Value callback fired before calculated value syntax resolved";
									}

									// Verify periods
									if ((
											field.periodSpecific() && 
											self.statement.periods() &&
											field.periodValues().length != self.statement.periods().length
										) || (
											!field.periodSpecific() && !ko.isComputed(field.value)
										)) {
										throw "SAField: Calculated Value callback fired before period value computeds populated";
									}
								}

								// Per linked record:
								function _calculatedHandler (newVal) {
									LifeCycle.SpreadData.updatePeriodToValue(this.recordId, this.periodId, newVal);
								}
								function _nonCalculatedHandler (newVal) {
									if (this.record) {
										LifeCycle.SpreadData.updateAllPeriodsToValue(this.record.recordId(), newVal);
									}
								}

								for (var lr = 0; lr < field.linkedRecords().length; lr++) {
									var record = field.linkedRecords()[lr];

									if (!field.periodSpecific()) {
										// Send initial value
										LifeCycle.SpreadData.updateAllPeriodsToValue(record.recordId(), field.value());

										field.value.subscribe(_nonCalculatedHandler, {
											record: record
										});
									} else if (field.calculated()) {

										for (var pv = 0; pv < field.periodValues().length; pv++) {
											var periodValue = field.periodValues()[pv];

											var recordId = record.recordId();
											LifeCycle.SpreadData.updatePeriodToValue(recordId, periodValue.period.recordId(), periodValue.value());
											periodValue.value.subscribe(_calculatedHandler, {
												recordId: recordId,
												periodId: periodValue.period.recordId()
											});
										}
									} else {
										throw "SAField: Can't have a non-calculated period-specific field";
									}

								}

								self.info.fields.push(field);
								var index = remaining.indexOf(field);
								if (index >= 0) {
									remaining.splice(index, 1);
								}

								// Verify all, all, and all?
								// allCallback only here
								if (callback) {
									if (
										_isAllFieldInitialValueSyntaxResolved(fields) &&
										_isAllFieldsLinked(fields) && 
										_isAllFieldValueSyntaxResolved(fields) &&
										remaining.length == 0) {
										callback(fields, syntaxChanged);
									}
								}
							});
						});
					});

				}

				for (var i = 0; i < fields.length; i++) {
					// Per-field flow
					var field = fields[i];
					_singleFieldFlow(field);
				}
			};

			self.setTables = function (tables, allTablesCallback) {

				var syntaxChanged = false;
				var processed = [];


				function _tableSyntaxResolved (table) {
					if (_isTableSyntaxResolved(table)) {	
						self.generateRows(table);
						self.info.tables.upsert(table);
					}

					processed.upsert(table);

					if (allTablesCallback) {
						if (_isAllSyntaxResolved(tables) && processed.length == tables.length) {
							allTablesCallback(tables, syntaxChanged);
						}
					}
				}

				function _resolveTableSyntax (table, tableCallback) {
					function _resolveColumnSyntax (column, tableCallback) {
						var syntax = column.syntax();

						if (_isSyntaxResolved(syntax)) {
							column.syntax(syntax);
							if (tableCallback) {
								tableCallback(table);
							}
							return;
						}

						function _replaceNameWithId (recordName) {
							self.resolveRecordNameToId(recordName, function (recordId) {
								syntax = syntax.replace(
									'<!' + recordName + '>', 
									'<#' + recordId + '>'
								);
								syntaxChanged = true;

								if (_isSyntaxResolved(syntax)) {
									column.syntax(syntax);
									if (tableCallback) {
										tableCallback(table);
									}
								}
							});
						}
						
						var recordNames = syntax.match(/<![^>]+>/g);
						if (recordNames) {
							for (var r = 0; r < recordNames.length; r++) {
								var recordName = recordNames[r];
								_replaceNameWithId(
									recordName.replace('<!', '').replace('>', '')
								);
							}
						}
					}

					if (_isTableSyntaxResolved(table)) {
						if (tableCallback) {
							tableCallback(table);
						}
						return;
					}

					for (var c = 0; c < table.columns().length; c++) {
						var column = table.columns()[c];
						_resolveColumnSyntax(column, tableCallback);
					}
				}



				for (var t = 0; t < tables.length; t++) {
					var table = tables[t];
					_resolveTableSyntax(table, _tableSyntaxResolved);
				}

			};

			function _isAllSyntaxResolved (tables) {
				var ready = true;
				for (var i = 0; i < tables.length; i++) {
					var table = tables[i];
					if (!_isTableSyntaxResolved(table)) {
						ready = false;
					}
				}

				return ready;
			}

			function _isTableSyntaxResolved (table) {
				var ready = true;
				for (var j = 0; j < table.columns().length; j++) {
					var column = table.columns()[j];
					if (!_isSyntaxResolved(column.syntax())) {
						ready = false;
					}
				}

				return ready;
			}


			self.generateRows = function (table) {

				var rowCount = table.bidirectional()
					? table.deviations() * 2 + 1
					: table.deviations() * 1 + 1

				var topValue = table.bidirectional()
					? table.startValue() + (table.stepValue() * table.deviations()) 
					: table.startValue();

				var bottomValue = table.bidirectional()
					? table.startValue() - (table.stepValue() * table.deviations())
					: table.startValue() - (table.stepValue() * table.deviations());

				function _cellProcessor () {
					return self.calculateCell(this.row, this.col);
				}

				var oldRows = table.rows();

				if (rowCount != oldRows.length) {
					var emptyRows = [];
					for (var r = 0; r < rowCount; r++) {
						emptyRows.push(null);
					}
					table.rows(emptyRows);
				}

				for (var i = 0; i < rowCount; i++) {
					var value = topValue - table.stepValue() * i;
					value = value.toFixed(4);

					// Set to old value if present
					if (oldRows.length == rowCount) {
						value = oldRows[i].percentValue();
					}

					var row = new app.SARow({
						percentValue: ko.observable(value).extend({
							'percentage': false
						})
					});

					for (var c = 0; c < table.columns().length; c++) {
						var col = table.columns()[c];
						var dat = {
							row: row,
							col: col
						};
						row.cells.push({
							value: ko.computed(_cellProcessor, dat),
							type: col.type
						});
					}
					var existingRow = table.rows()[i];
					table.rows.replace(existingRow, row);
				}
			};



			self.calculateCell = function (row, col) {
				var cellSyntax = col.syntax();
				var result = self.calculate(cellSyntax, row.percentValue(), row.cells());
				return result;
			};

			self.calculate = function (syntax, optionalUserInput, optionalCells, optionalPeriod) {
				var cellEvaluatable = self.processTokens(syntax, optionalUserInput, optionalCells, optionalPeriod);
				var result;
				try {
					result = eval(cellEvaluatable);
				} catch (e) {
					console.error('Uncalculatable syntax: ' + 
								syntax + '. Attempted to evaluate: ' +
								cellEvaluatable + '. Replacing with NaN. Error: ' + e);
					result = NaN;
				}
				return result;
			};

			self.processTokens = function (syntax, userInput, cells, optionalPeriod) {

				// Sanitize incoming user input (numbers only)
				if (userInput) {
					userInput = userInput.toString().replace(/[^0-9\.\-]/g, '');
				}

				if (!userInput) {
					userInput = 0;
				}

				var evaluationCandidate = syntax.replace('%', userInput);

				var indirections = evaluationCandidate.match(/\$[0-9]+\$/g);
				if (indirections) {
					for (var i = 0; i < indirections.length; i++) {
						var indirection = indirections[i];
						var indirectValue = cells[indirection.replace(/\$/g, '')].value();
						evaluationCandidate = evaluationCandidate.replace(indirection, indirectValue);
					}
				}

				var fieldLookups = evaluationCandidate.match(/\{\{[^\}]+\}\}/g);
				if (fieldLookups) {
					for (var e = 0; e < fieldLookups.length; e++) {
						var fieldLookup = fieldLookups[e];
						var fieldLookupValue;
						for (var f = 0; f < self.info.fields().length; f++) {
							var field = self.info.fields()[f];
							if (field.name().toLowerCase() == fieldLookup.replace('{{','').replace('}}','').toLowerCase()) {
								fieldLookupValue = field.value();
								break;
							}
						}
						if (fieldLookupValue === undefined) {
							app.log('Field not available at time of evaluation. Replacing with undefined');
						}
						evaluationCandidate = evaluationCandidate.replace(fieldLookup, fieldLookupValue);
					}
				}

				var expressions = evaluationCandidate.match(/\{[^\}]+\}/g);
				if (expressions) {
					for (var e = 0; e < expressions.length; e++) {
						var expression = expressions[e];
						var expressionValue;
						try {
							expressionValue = eval(expression.replace('{', '').replace('}', ''));
						} catch (e) {
							app.log('Unparseable expression present in syntax: ' + 
								expression + '. Replacing with undefined. Error: ' + e);
							expressionValue = undefined;
						}
						evaluationCandidate = evaluationCandidate.replace(expression, expressionValue);
					}
				}

				var records = evaluationCandidate.match(/<#[^>]+>/g);
				if (records) {
					for (var r = 0; r < records.length; r++) {
						var recordId = records[r];
						var spreadValue = self.getSpreadValueByIdSynchronously(
							recordId.replace('<#', '').replace('>', ''),
							optionalPeriod
						);
						evaluationCandidate = evaluationCandidate.replace(recordId, spreadValue);
					}
				}

				if (!_isSyntaxEvaluatable(evaluationCandidate)) {
					console.error('Syntax generated unevaluatable expression: ' + evaluationCandidate);
					return '';
				}


				return evaluationCandidate;
			};

			function _isSyntaxEvaluatable (syntax) {
				if (typeof syntax == 'number') {
					return true;
				}

				if (syntax.indexOf('<') != -1 ||
					  syntax.indexOf('>') != -1) {
					return false;
				}

				if (syntax.indexOf('{') != -1 ||
					  syntax.indexOf('}') != -1) {
					return false;
				}

				if (syntax.indexOf('$') != -1) {
					return false;
				}

				return true;
			}

			function _isSyntaxResolved (syntax) {
				if (typeof syntax == 'number' || typeof syntax == 'undefined') {
					return true;
				}
				if (syntax.indexOf('<!') != -1) {
					return false;
				}
				return true;
			}

			self.getSpreadValueByIdSynchronously = function (spreadRecordId, optionalPeriod) {
				var period = self.info.period();
				if (optionalPeriod) {
					period = optionalPeriod;
				}

				var period = (optionalPeriod || self.info.period());
				if (!period) {
					return undefined;
				}

				// Check for RT first
				var recordTotal = LifeCycle.SpreadData.lookupRecordTotalById(spreadRecordId);
				if (recordTotal) {
					var periodTotals = recordTotal.periodTotals();
					for (var i = 0; i < periodTotals.length; i++) {
						var periodTotal = periodTotals[i];
						var periodKey = periodTotal.period.periodKey();
						if (periodKey == period.periodKey()) {
							return periodTotal.value();
						}
					}
					return 0;
				}

				// Check for Record second
				var record = LifeCycle.SpreadData.lookupRecordById(spreadRecordId);
				if (record) {
					var recordValues = record.recordValues();
					for (var i = 0; i < recordValues.length; i++) {
						var recordValue = recordValues[i];
						var periodKey = recordValue.period.periodKey();
						if (periodKey == period.periodKey()) {
							return recordValue.value();
						}
					}
					return 0;
				}

				app.log('Unable to locate record by Id in cache');
				return undefined;
			};

			self.resolveRecordNameToId = function (recordName, callback) {
				var _fullRecordName = recordName;
				var statement = self.statement;
				var bundleId = self.statement.bundle.recordId();
				if (statement && statement.recordId()) {
					statementId = statement.recordId();
				} else {
					app.log('Unable to create record search constraint.' +
						'Statement not defined.');
					return;
				}

				if (recordName.indexOf('!') === 0) {
					// Cross-statement lookup
					var delimiterIndex = recordName.indexOf(':');
					var statementName = recordName.substring(1, delimiterIndex);
					recordName = recordName.substring(delimiterIndex + 1);
					var statements = LifeCycle.SpreadData.lookupStatementsByName(statementName, bundleId);
					switch (statements.length) {
						case 1:
							statement = statements[0];
							break;
						case 0:
							app.log('Statement Name resolved to 0 statements in bundle. ' +
								'Adding subscription to statement load event (by name) and waiting.');
							var escapedName = statementName.toString().replace(/ /, '_');
							app.subscribeOnce('SPREAD.Spreads.Spread_Data.Loaded_Statement', function (_statement) {
								if (
									_statement.statementType && 
									_statement.statementType().toString().replace(/ /, '_') != escapedName
								) {
									return;
								}
								self.resolveRecordNameToId(_fullRecordName, callback);
							});
							return undefined;
						default:
							throw 'Statement Name resolved to >1 statements in bundle.';
					}
				}

				var statementId = statement.recordId();
				var id = LifeCycle.SpreadData.resolveNameToId(recordName, statementId);
				if (!id) {
					app.log('Record name did not resolve to Id. ' +
						'Adding subscription to statement load event (by Id) and waiting.');
					app.subscribeOnce('SPREAD.Spreads.Spread_Data.Loaded_Statement', function (_statement) {
						if (_18Id(statementId) != _18Id(_statement.recordId())) {
							return;
						}
						self.resolveRecordNameToId(_fullRecordName, callback);
					});
					return;
				}

				callback(id);
			};

			return self;
		};

		app.log('ViewModel initialized.');
	};
	if(LifeCycle.Spread_Sensitivity_Analysis.ViewModel == undefined){
		LifeCycle.Spread_Sensitivity_Analysis.ViewModel = ViewModel;
	}
})();

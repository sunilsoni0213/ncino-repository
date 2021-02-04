(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			self.app = app;
			var defaultData = {
				contextObjectId: ''
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			Array.prototype.upsert = function (recordToUpsert) {
				upsert(this, recordToUpsert);
			};
			ko.observableArray.fn.upsert = function (recordToUpsert) {
				upsert(this, recordToUpsert);
			};

			self.bundles = ko.observableArray();
			self.bundleMap = {};
			self.statementMap = {};
			self.recordTotalMap = {};
			self.recordMap = {};

			self.queuedRecordValueUpdates = {};
			self.queuedPeriodTotalUpdates = {};

			function _updateRecordWithChange (recordValueInfo) {
				var targetRecordId = recordValueInfo.recordId;
				var targetPeriodId = recordValueInfo.periodId;
				var newValue = recordValueInfo.value;

				var matchingRecord = self.recordMap[_15Id(targetRecordId)];

				if (!matchingRecord) {
					// Otherwise queue, in case record is loaded afterwards
					if (!self.queuedRecordValueUpdates[targetRecordId])
						self.queuedRecordValueUpdates[targetRecordId] = {};

					self.queuedRecordValueUpdates[targetRecordId][targetPeriodId] = recordValueInfo;

					return;
				}

				var recordValues = matchingRecord.recordValues();

				for (var i = 0; i < recordValues.length; i++) {
					var recordValue = recordValues[i];
					if (recordValue.period && recordValue.period.recordId() == targetPeriodId) {
						recordValue.value(newValue);
						return;
					}
				}

				var recordValue = new app.SpreadStatementRecordValue({
					period: {
						recordId: targetPeriodId
					},
					value: newValue
				});
				var parentStatementId = matchingRecord.statement.recordId();
				var parentStatement = self.statementMap[_15Id(parentStatementId)];
				if (parentStatement) {
					for (var p = 0; p < parentStatement.periods().length; p++) {
						var stmtPeriod = parentStatement.periods()[p];
						if (_15Id(stmtPeriod.recordId()) == _15Id(targetPeriodId)) {
							recordValue.period = stmtPeriod;
							break;
						}
					}
				}
				matchingRecord.recordValues.push(recordValue);
			}

			function _updateRecordTotalWithChange (periodTotalInfo) {
				var targetRecordTotalId = periodTotalInfo.recordTotalId;
				var targetPeriodId = periodTotalInfo.periodId;
				var newValue = periodTotalInfo.value;

				var matchingRecordTotal = self.recordTotalMap[_15Id(targetRecordTotalId)];

				if (!matchingRecordTotal) {
					// Otherwise queue, in case record total is loaded afterwards
					if (!self.queuedPeriodTotalUpdates[targetRecordTotalId])
						self.queuedPeriodTotalUpdates[targetRecordTotalId] = {};


					self.queuedPeriodTotalUpdates[targetRecordTotalId][targetPeriodId] = periodTotalInfo;

					return;
				}

				var periodTotals = matchingRecordTotal.periodTotals();

				for (var i = 0; i < periodTotals.length; i++) {
					var periodTotal = periodTotals[i];
					if (periodTotal.period && periodTotal.period.recordId() == targetPeriodId) {
						periodTotal.value(newValue);
						return;
					}
				}

				var periodTotal = new app.SpreadStatementPeriodTotal({
					period: {
						recordId: targetPeriodId
					},
					value: newValue
				});
				var parentStatementId = matchingRecordTotal.statement.recordId();
				var parentStatement = self.statementMap[_15Id(parentStatementId)];
				if (parentStatement) {
					for (var p = 0; p < parentStatement.periods().length; p++) {
						var stmtPeriod = parentStatement.periods()[p];
						if (_15Id(stmtPeriod.recordId()) == _15Id(targetPeriodId)) {
							periodTotal.period = stmtPeriod;
							break;
						}
					}
				}
				matchingRecordTotal.periodTotals.push(periodTotal);
			}

			app.subscribe('LLC_BI.Spreads.RecordValue_Updated', _updateRecordWithChange);
			app.subscribe('LLC_BI.Spreads.PeriodTotal_Updated', _updateRecordTotalWithChange);

			app.subscribe('LLC_BI.Spreads.Saved', function () {
				// Clear queues, retrieved RVs and PTs will reflect new values
				self.queuedRecordValueUpdates = {};
				self.queuedPeriodTotalUpdates = {};
			});

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
			

			self.upsertBundle = function (bundle) {
				self.bundleMap[_15Id(bundle.recordId())] = bundle;
				self.bundles.upsert(bundle);
				self.buildMaps();
			};

			self.upsertStatement = function (statement) {
				self.statementMap[_15Id(statement.recordId())] = statement;
				// Update parent
				if (statement.bundle) {
					var bundleId = _15Id(statement.bundle.recordId());
					if (!bundleId) {
						return;
					}
					var bundle = self.bundleMap[bundleId];
					if (bundle) {
						bundle.statements.upsert(statement);
					}
				}
			};

			self.upsertRecordTotal = function (recordTotal) {
				self.recordTotalMap[_15Id(recordTotal.recordId())] = recordTotal;
				// Update parent
				if (recordTotal.statement) {
					var statementId = _15Id(recordTotal.statement.recordId());
					if (!statementId) {
						return;
					}
					var statement = self.statementMap[statementId];
					if (statement) {
						statement.recordTotals.upsert(recordTotal);
					}
				}
			};

			self.upsertRecord = function (record) {
				self.recordMap[_15Id(record.recordId())] = record;
				// Update parent
				if (record.recordTotal) {
					var recordTotalId = _15Id(record.recordTotal.recordId());
					if (!recordTotalId) {
						return;
					}
					var recordTotal = self.recordTotalMap[recordTotalId];
					if (recordTotal) {
						recordTotal.records.upsert(record);
					}
				}

				function _addEventsForValue (value) {
					var period = value.period;

					// Value loaded
					app.publish('LLC_BI.Spreads.RecordValue_Updated', {
						recordId: record.recordId(),
						periodId: period.recordId(),
						value: value.value()
					});

					// Value updated
					value.value.subscribe(function (newVal) {
						app.publish('LLC_BI.Spreads.RecordValue_Updated', {
							recordId: record.recordId(),
							periodId: period.recordId(),
							value: newVal
						});
					});
				}

				for (var i = 0; i < record.recordValues().length; i++) {
					var value = record.recordValues()[i];
					_addEventsForValue(value);

					// Point recordValue periods to statement periods
					if (value.period) {
						var periodId = value.period.recordId();
						var parentStatementId = record.statement.recordId();
						var parentStatement = self.statementMap[_15Id(parentStatementId)];
						if (parentStatement) {
							for (var p = 0; p < parentStatement.periods().length; p++) {
								var stmtPeriod = parentStatement.periods()[p];
								if (_15Id(stmtPeriod.recordId()) == _15Id(periodId)) {
									value.period = stmtPeriod;
									break;
								}
							}
						}
					}
				}

				// Value inserted
				record.recordValues.subscribe(function (newRecordValues) {
					for (var i = 0; i < newRecordValues; i++) {
						var newRecordValue = newRecordValues[i];
						_addEventsForValue(newRecordValue);
					}
				});
				
			};

			self.updateAllPeriodsToValue = function (recordId, newVal) {
				// TODO: update this to work the other way around
				// Update / create RVs based on periods

				// Publish towards SS, SS will publish back, updating cache
				app.publish('LLC_BI.Spreads.RecordValue_Updated', {
					recordId: _18Id(recordId),
					periodId: null,
					value: newVal
				});
			};

			self.updatePeriodToValue = function (recordId, periodId, newVal) {
				// Publish towards SS, SS will publish back, updating cache
				app.publish('LLC_BI.Spreads.RecordValue_Updated', {
					recordId: _18Id(recordId),
					periodId: _18Id(periodId),
					value: newVal
				});
			};

			self.buildMaps = function () {
				for (var prop in self.bundleMap) {
					if (self.bundleMap.hasOwnProperty(prop)) {
						var bundleId = prop;
						var bundle = self.bundleMap[_15Id(bundleId)];

						for (var s = 0; s < bundle.statements().length; s++) {
							var statement = bundle.statements()[s];
							self.upsertStatement(statement);

							for (var r = 0; r < statement.recordTotals().length; r++) {
								var recordTotal = statement.recordTotals()[r];
								self.upsertRecordTotal(recordTotal);
							}
						}
					}
				}
				for (var prop in self.statementMap) {
					if (self.statementMap.hasOwnProperty(prop)) {
						var statementId = prop;
						var statement = self.statementMap[_15Id(statementId)];

						for (var r = 0; r < statement.recordTotals().length; r++) {
							var recordTotal = statement.recordTotals()[r];
							self.upsertRecordTotal(recordTotal);
						}	
					}
				}
			};

			var _getBundle = function(bundleId){
				if(_.isUndefined(self.bundleMap[_15Id(bundleId)])){
					self.loadBundle(bundleId, function(bundle){
						app.publish("Spread_Data.Bundle_Loaded", bundle);
					});
				}
			};

			self.load = function(){
				app.subscribe("Spread_Data.Load_Bundle", function(bundleId){
					_getBundle(bundleId);
				});

				app.subscribe('LLC_BI.Spreads.Spread_Data.Load_Bundle', function (bundleId) {
					self.loadBundle(bundleId, function loadCallback (bundle) {
						app.publish('LLC_BI.Spreads.Spread_Data.Loaded_Bundle', bundle);
					});
				});

				app.subscribe('LLC_BI.Spreads.Spread_Data.Load_Cached_Bundle', function (bundleId) {
					if (self.bundleMap[_15Id(bundleId)]) {
						app.publish('LLC_BI.Spreads.Spread_Data.Cached_Bundle', self.bundleMap[_15Id(bundleId)]);
					}
					self.loadBundle(bundleId, function loadCallback (bundle) {
						app.publish('LLC_BI.Spreads.Spread_Data.Cached_Bundle', bundle);
					});
				});

				app.subscribe('LLC_BI.Spreads.Spread_Data.Load_Cached_Statement', function (statementId) {
					if (self.statementMap[_15Id(statementId)]) {
						app.publish('LLC_BI.Spreads.Spread_Data.Cached_Statement', self.statementMap[_15Id(statementId)]);
					}
					self.loadStatement(statementId, function loadCallback (statement) {
						app.publish('LLC_BI.Spreads.Spread_Data.Cached_Statement', statement);
					});
				});

				app.subscribe('LLC_BI.Spreads.Spread_Data.Load_Cached_Record_Total', function (recordTotalId) {
					if (self.recordTotalMap[_15Id(recordTotalId)]) {
						var recordTotal = self.recordTotalMap[_15Id(recordTotalId)];
						recordTotal.statement = self.statementMap[_15Id(recordTotal.statement.recordId())];
						app.publish('LLC_BI.Spreads.Spread_Data.Cached_Record_Total', recordTotal);
					}
					self.loadRecordTotal(recordTotalId, function loadCallback (recordTotal) {
						app.publish('LLC_BI.Spreads.Spread_Data.Cached_Record_Total', recordTotal);
					});
				});

				app.subscribe('LLC_BI.Spreads.Spread_Data.Load_Cached_Record', function (recordId) {
					if (self.recordMap[_15Id(recordId)]) {
						var record = self.recordMap[_15Id(recordId)];
						record.recordTotal = self.recordTotalMap[_15Id(record.recordTotal.recordId())];
						record.statement = self.statementMap[_15Id(record.statement.recordId())];
						app.publish('LLC_BI.Spreads.Spread_Data.Cached_Record', record);
					}
				});

				app.subscribe('LLC_BI.Spreads.Spread_Data.Get_Bundles', function () {
					app.publish('LLC_BI.Spreads.Spread_Data.Bundles', self.bundles);
				});

				app.subscribe('LLC_BI.Spreads.Spread_Data.Load_All_Bundles.' + _15Id(self.contextObjectId()), function () {
					self.loadAllBundles(function loadAllCallback (bundlesObservable) {
						app.publish('LLC_BI.Spreads.Spread_Data.Loaded_All_Bundles.' + _15Id(self.contextObjectId()), 
							[bundlesObservable]);
					});
				});


				app.subscribe('LLC_BI.Spreads.Spread_Data.Load_Statement', self.loadStatement);
				app.subscribe('LLC_BI.Spreads.Spread_Data.Load_Record_Total', self.loadRecordTotal);

				app.publish('LLC_BI.Spreads.Spread_Data.Started');
			};

			self.loadBundle = function(bundleId, callback){
				self.loadBundles([bundleId], function (bundles) {
					if (bundles.length == 1)
						callback(bundles[0]);
					else
						callback(null);
				});
			};

			self.loadBundles = function (bundleIds, callback) {
				LifeCycle.BorrowerTree.retrieveIForces(
					[],
					bundleIds,
					function(results, event){
						var all = [];
						_.each(results, function (result) {

							var kpiStatement;
							var statementIdList = [];
							for (var i = result.statements.length - 1; i >= 0; i--) {
								var statement = result.statements[i]
								if(statement.statementType == LifeCycle.msgs.msg_kpi) {
									kpiStatement = statement;
								}
								// Start loading all statements
								self.loadStatement(statement.recordId);
							}
							if (!_.isUndefined(kpiStatement)) {
								var tmp = result.statements.splice(result.statements.indexOf(kpiStatement), 1)[0];
								result.statements.splice(0,0,tmp);
							}

							var bundle = new app.UnderwritingBundle(result);
							// Load Statements
							self.upsertBundle(bundle);
							all.push(bundle);
						});
						self.buildMaps();
						callback(all);
					},
					app.log.failure,
					undefined,
					false
				);
			};
			
			self.loadAllBundles = function (callback) {
				self.loadAllBundlesForContextObject(self.contextObjectId(), callback);
			};

			self.loadAllBundlesForContextObject = function(contextId, callback){
				if (self.contextObjectId() && self.contextObjectId() != contextId) {
					throw "Spread Data is already assigned to " + self.contextObjectId() +
						". A separate instance is required for each context object.";
				}
				LifeCycle.Spreads.getBundleIdsForContextId(
					[],
					contextId,
					function(results, event){
						self.loadBundles(results, callback);
					},
					app.log.failure,
					undefined,
					false
				);
			};

			self.loadStatement = function loadStatement (statementId, callback) {
				var statement = self.statementMap[_15Id(statementId)];

				function loadComplete (statement) {
					app.publish('LLC_BI.Spreads.Spread_Data.Loaded_Statement', statement);
					statement.isFilled(true);
					if (callback) {
						callback(statement);
					}
				}

				function statementReady (statement) {
					// Load records and values
					var loadedRecords = false;
					self.getRecordsForStatement(statement, function (records) {
						loadedRecords = true;
						// Loaded PTs first
						if (!remainingRTs) {
							// All done
							loadComplete(statement);
						}
					});

					var recordTotals = statement.recordTotals();
					var remainingRTs = recordTotals.length;
					function periodTotalsLoaded (periodTotals) {
						remainingRTs--;
						// Loaded Recs & Vals first
						if (!remainingRTs && loadedRecords) {
							// All done
							loadComplete(statement);
						}
					}
					for (var i = 0; i < recordTotals.length; i++) {
						var recordTotal = recordTotals[i];
						self.getPeriodTotalsForRecordTotal(recordTotal, periodTotalsLoaded);
					}
				}

				if (statement) {
					statementReady(statement);
				} else {
					app.log('Statement ' + statementId + ' not in pre-loaded bundles, LOADING INDIVIDUALLY...');
					LifeCycle.BorrowerTree.retrieveIForce(
						{},
						statementId,
						function(result, event){
							var statement = new app.SpreadStatement(result);
							self.upsertStatement(statement);
							self.buildMaps();
							statementReady(statement);
							if (callback)
								callback.apply(this,[statement]);
						},
						app.log.failure,
						undefined,
						false
					);
				}
			};

			self.loadRecordTotal = function loadRecordTotal (recordTotalId, callback) {
				var recordTotal = self.recordTotalMap[_15Id(recordTotalId)];

				function loadComplete () {
					app.publish('LLC_BI.Spreads.Spread_Data.Loaded_Record_Total.' + _15Id(recordTotalId), recordTotal);
					if (callback) {
						callback(recordTotal);
					}
				}

				function recordTotalReady (recordTotal) {
					// Load records and values
					self.getPeriodTotalsForRecordTotal(recordTotal, function periodTotalsLoaded (periodTotals) {
						self.getRecordsForRecordTotal(recordTotal, function (records) {
							loadComplete();
						});
					});
				}

				if (recordTotal) {
					recordTotalReady(recordTotal);
				} else {
					// Try and load Record Total by loading all bundles
					console.warn('Record Total ' + recordTotalId + ' not in pre-loaded bundles, LOADING ALL BUNDLES...');
					self.loadAllBundles(function (bundles) {
						recordTotal = self.recordTotalMap[_15Id(recordTotalId)];
						if (recordTotal) {
							recordTotalReady(recordTotal);
						} else {
							// Give up
							app.publish('LLC_BI.Spreads.Error', 'Unable to load Record Total');
							console.error('Record total ' + recordTotalId + ' not in bundles for context');
						}
					});
				}
			};

			self.getRecordsForStatement = function (statement, callback) {
				if (!statement) {
					callback.apply(this, [statement]);
					return;
				}

				function matchRecordsToTotals (records) {
					for (var i = 0; i < records.length; i++) {
						var recordObj = records[i];
						var record = new app.SpreadStatementRecord(recordObj);
						self.upsertRecord(record);

						var recordTotalId = record.recordTotal.recordId();
						var recordTotal = self.recordTotalMap[_15Id(recordTotalId)];

						var queuedChanges = self.queuedRecordValueUpdates[record.recordId()];
						if (queuedChanges) {
							// Update retrieved record to locally changed values
							for (var periodId in queuedChanges) {
								if (queuedChanges.hasOwnProperty(periodId)) {
									var queuedChange = queuedChanges[periodId];
									_updateRecordWithChange(queuedChange);
								}
							}
							self.queuedRecordValueUpdates[record.recordId()] = undefined;
						}

						if (!recordTotal) {
							console.warn("Unmatched Record, no such record total: " + recordTotalId);
						} else {
							recordTotal.records.upsert(record);
						}
					}
				}

				LifeCycle.Spreads.loadRecordsForStatementId(
					[],
					statement.recordId(),
					function (result, event) {
						matchRecordsToTotals(result);
						callback.apply(this, [statement]);
					},
					app.log.failure,
					undefined,
					false
				);
			};

			self.getRecordsForRecordTotal = function (recordTotal, callback) {
				if (!recordTotal) {
					callback.apply(this, [recordTotal]);
					return;
				}

				LifeCycle.Spreads.loadRecordsForRecordTotalId(
					[],
					recordTotal.recordId(),
					function (results, event) {
						_.each(results, function (result) {
							var recordObj = result;
							var record = new app.SpreadStatementRecord(recordObj);
							self.upsertRecord(record);
							recordTotal.records.upsert(record);
						});
						callback.apply(this, [recordTotal]);
					},
					app.log.failure
				);
			};

			self.getPeriodTotalsForRecordTotal = function (recordTotal, callback) {
				if (!recordTotal) {
					callback.apply(this, [recordTotal]);
					return;
				}

				LifeCycle.Spreads.loadPeriodTotalsForRecordTotalId(
					[],
					recordTotal.recordId(),
					function (results, event) {
						var periodTotals = [];
						for (var i = 0; i < results.length; i++) {
							var periodTotalObj = results[i];
							var periodTotal = new app.SpreadStatementPeriodTotal(periodTotalObj);
							periodTotals.push(periodTotal);
						}

						// Merge in new period totals
						function _indexOfPeriodTotal (periodTotal) {
							for (var i = 0; i < recordTotal.periodTotals().length; i++) {
								var _periodTotal = recordTotal.periodTotals()[i];
								if (_periodTotal.period.periodKey() == periodTotal.period.periodKey()) {
									return i;
								}
							}
							return -1;
						}
						for (var pt = 0; pt < periodTotals.length; pt++) {
							var _periodTotal = periodTotals[pt];
							var existingIndex = _indexOfPeriodTotal(_periodTotal);
							var existingPT;
							if (existingIndex >= 0) {
								existingPT = recordTotal.periodTotals()[existingIndex];
								if (ko.unwrap(existingPT.isLoaded)) {
									recordTotal.periodTotals.replace(existingPT, _periodTotal);
								} else {
									// Local change, do not merge
								}
							} else {
								recordTotal.periodTotals.push(_periodTotal);
							}
						}

						var queuedChanges = self.queuedPeriodTotalUpdates[recordTotal.recordId()];
						if (queuedChanges) {
							// Update retrieved record to locally changed values
							for (var periodId in queuedChanges) {
								if (queuedChanges.hasOwnProperty(periodId)) {
									var queuedChange = queuedChanges[periodId];
									_updateRecordTotalWithChange(queuedChange);
								}
							}
							self.queuedPeriodTotalUpdates[periodTotal.recordId()] = undefined;
						}

						callback.apply(this, [recordTotal]);
					},
					app.log.failure,
					undefined,
					false
				);
			};

			self.findStatementBySpreadId = function (spreadId) {
				for (var b = 0; b < self.bundles().length; b++) {
					var bundle = self.bundles()[b];
					for (var s = 0; s < bundle.statements().length; s++) {
						var statement = bundle.statements()[s];
						for (var p = 0; p < statement.spreads().length; p++) {
							var spread = statement.spreads()[p];
							if (_15Id(spread.recordId()) == _15Id(spreadId)) {
								return statement;
							}
						}
					}
				}
			};

			self.resolveNameToId = function (name, optionalStatementId) {
				// Check Spread Record Totals first
				var recordTotals = self.getRecordTotalsByName(name, optionalStatementId);
				switch (recordTotals.length) {
					case 1:
						var recordTotal = recordTotals[0];
						return recordTotal.recordId();
					case 0:
						break;
					default:
						throw 'Record Total Name resolved to >1 record total in statement.';
				}

				// Check Spread Records second
				var records = self.getRecordsByName(name, optionalStatementId);
				switch (records.length) {
					case 1:
						var record = records[0];
						return record.recordId();
					case 0:
						break;
					default:
						throw 'Record Name resolved to >1 record in statement.';
				}
				
				app.log('Record / Total Name resolved to 0 record totals in statement.');
				return undefined;
			};

			self.getRecordsByName = function (name, optionalStatementId) {
				return self._findDataByName(name, self.recordMap, optionalStatementId);
			};

			self.getRecordTotalsByName = function (name, optionalStatementId) {
				return self._findDataByName(name, self.recordTotalMap, optionalStatementId);
			};

			self.getStatementsByName = function (name) {
				var matches = [];

				for (var prop in self.statementMap) {
					if (self.statementMap.hasOwnProperty(prop)) {
						var statement = self.statementMap[prop];

						if (statement.statementType().toString().toLowerCase() == name.toString().toLowerCase()) {
							matches.push(statement);
						}

					}
				}

				return matches;
			};

			self._findDataByName = function (name, dataMap, optionalStatementId) {
				var matches = [];

				for (var prop in dataMap) {
					if (dataMap.hasOwnProperty(prop)) {
						var data = dataMap[prop];

						if ((
									!optionalStatementId || 
									_15Id(optionalStatementId) == _15Id(data.statement.recordId())
								) && (
									data.name().toString().toLowerCase() == name.toString().toLowerCase()
								)) {
							matches.push(data);
						}

					}
				}

				return matches;
			};

			return self;

		};

	};
	if(LifeCycle.Spread_Data.ViewModel == undefined){
		LifeCycle.Spread_Data.ViewModel = ViewModel;
	}
})();

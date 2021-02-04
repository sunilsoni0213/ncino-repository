/**
 * Spread Data extension of the {@link LifeCycle.IForceCache global IForce Cache}
 *
 * @typedef {(LifeCycle.SpreadData|SpreadDataAutoGen|LifeCycle.IForceData.IForceCache)} LifeCycle.SpreadData
 *
 * NOTE: for the specific <verb><type>ById functions, documentation does not display properly
 * so reference the generic ones instead:
 * {@link LifeCycle.SpreadData.loadIForceById}
 * {@link LifeCycle.SpreadData.loadIForcesById}
 * {@link LifeCycle.SpreadData.getIForceById}
 * {@link LifeCycle.SpreadData.getIForcesById}
 * {@link LifeCycle.SpreadData.lookupIForceById}
 * {@link LifeCycle.SpreadData.lookupIForcesByName}
 * {@link LifeCycle.SpreadData.lookupIForcesByProperty}
 * {@link LifeCycle.SpreadData.lookupIForcesByFilter}
 *
 * The type-specific ones are only for readability and add Apex-type-checking for the results
 */
function IForceProvider() {
	return LifeCycle.LiteForceService;
}
if (_.isEmpty(LifeCycle.SpreadData)) {
	LifeCycle.SpreadData = LifeCycle.IForceCache._extend({
		pubSubNamespace: 'SPREAD.Spreads.Spread_Data',
		defaultIForceProvider: IForceProvider,
		typeDefinitions: [{
			name: 'bundle',
			uniqueKeyProperties: ['lookupKey'],
			apexTypes: [
				'LifeCycleUnderwritingBundle',
				'LifeCycleUnderwritingBundleTemplate'
			]
		},{
			name: 'statement',
			uniqueKeyProperties: ['lookupKey'],
			shortcutProperties: [
				'statementType'
			],
			apexTypes: [
				'LifeCycleSpreadStatement',
				'LifeCycleSpreadStatementTemplate'
			]
		},{
			name: 'recordTotal',
			uniqueKeyProperties: ['lookupKey'],
			apexTypes: [
				'LifeCycleSpreadStatementRecordTotal',
				'LifeCycleSpreadStatementTotal'
			]
		},{
			name: 'periodTotal',
			uniqueKeyProperties: ['lookupKey'],
			shortcutProperties: [
				'period'
			],
			apexTypes: [
				'LifeCycleSpreadStatementPeriodTotal'
			]
		},{
			name: 'period',
			uniqueKeyProperties: ['lookupKey'],
			shortcutProperties: [
				'periodKey'
			],
			apexTypes: [
				'LifeCycleSpreadStatementPeriod'
			]
		},{
			name: 'record',
			uniqueKeyProperties: ['lookupKey'],
			apexTypes: [
				'LifeCycleSpreadStatementRecord'
			]
		},{
			name: 'recordValue',
			uniqueKeyProperties: ['lookupKey'],
			shortcutProperties: [
				'period'
			],
			apexTypes: [
				'LifeCycleSpreadStatementRecordValue'
			]
		},{
			name: 'spread',
			uniqueKeyProperties: ['lookupKey'],
			apexTypes: [
				'LifeCycleSpread'
			]
		},{
			name: 'covenantCompliance',
			uniqueKeyProperties: ['lookupKey'],
			apexTypes: [
				'LifeCycleCovenantCompliance2'
			],
			shortcutProperties: [
				'period'
			]
		},{
			name: 'classification',
			uniqueKeyProperties: ['lookupKey'],
			apexTypes: [
				'Classification'
			],
			shortcutProperties: [
				'category'
			]
		},{
			name: 'spreadRecordClassification',
			apexTypes: [
				'SpreadRecordClassification'
			],
			shortcutProperties: [
				'record'
			]
		},{
			name: 'spreadRecordTotalClassification',
			apexTypes: [
				'SpreadRecordTotalClassification'
			],
			shortcutProperties: [
				'recordTotal'
			]
		}]
	});
}

// Ensure that models are available to cache
var _app = LifeCycle.SpreadData._app;
LifeCycle.Relationship.Models(null, _app);
LifeCycle.Underwriting.Models(null, _app);
LifeCycle.Covenant.Models(null, _app);
LifeCycle.Comments.Models(null, _app);
LifeCycle.Spreading.Models(null, _app);
LifeCycle.Classification.Models(null, _app);

/**
 * Applies a value update to all available Periods
 *
 * Generates new RecordValues for Periods that do not already have them
 *
 * @param {string} recordId
 * @param {(string|number)} newValue
 * @returns {KORecordValue[]} new or existing RecordValues with updated value
 * @static
 */
LifeCycle.SpreadData.updateAllPeriodsToValue = function (recordId, newValue) {
	return LifeCycle.SpreadData.updatePeriodToValue(recordId, null, newValue);
};

/**
 * Checks if an updated value in a Record-Period intersection (RecordValue) occurs on a period associated to a TTM.
 * If so, it recalculates the associated RecordValue for the TTM period.
 *
 * @param {KORecord} record
 * @static
 */
LifeCycle.SpreadData.recalculateTTMPeriodsForRecord = function(record) {
	var periods = record.recordTotal.statement.periods();
	periods.forEach(function (period) {
		if (ko.unwrap(period.periodType) == LifeCycle.SpreadData.TRAILING_TWELVE_MONTH) {
			var ttmRecordValue = LifeCycle.SpreadData.lookupRecordValueByRecordAndPeriod(record, period, true);
			var val = LifeCycle.SpreadData.TTMServices.CalculationService.calculateTTMValues(ttmRecordValue);
			if (ttmRecordValue.value() !== val) {
				ttmRecordValue.value(val);
			}
		}
	});
}

/**
 * Places an updated value into a Record-Period intersection (RecordValue)
 *
 * Will generate a new model object and attach to parent Record if RecordValue non-existent
 *
 * @param {string} targetRecordId
 * @param {(string|null)} [targetPeriodId]
 * @param {(string|number)} newValue
 * @returns {(KORecordValue|KORecordValue[])} new or existing RecordValue
 * @static
 */
LifeCycle.SpreadData.updatePeriodToValue = function (targetRecordId, targetPeriodId, newValue) {
	var targetRecord = LifeCycle.SpreadData.lookupRecordById(targetRecordId, {
		placeholderType: 'LifeCycleSpreadStatementRecord',
		generatePlaceholder: true,
		alwaysReturnModel: true
	});

	if (targetRecordId && !targetPeriodId) {
		// All periods
		var recordValues = [];

		if (
			targetRecord.recordTotal &&
			targetRecord.recordTotal.statement &&
			ko.unwrap(targetRecord.recordTotal.statement.periods)
		) {
			var periods = targetRecord.recordTotal.statement.periods();
			periods.forEach(function (period) {
				recordValues.push(LifeCycle.SpreadData.updatePeriodToValue(
					targetRecordId,
					ko.unwrap(period.recordId),
					newValue
				));
			});
		}

		return recordValues;
	}

	var targetPeriod = LifeCycle.SpreadData.lookupPeriodById(targetPeriodId, {
		placeholderType: 'LifeCycleSpreadStatementPeriod',
		generatePlaceholder: true,
		alwaysReturnModel: true
	});

	var recordValue = LifeCycle.SpreadData.lookupRecordValueByRecordAndPeriod(targetRecord, targetPeriod, true);
	if (recordValue.value() !== newValue) {
		recordValue.value(newValue);
	}

	LifeCycle.SpreadData.recalculateTTMPeriodsForRecord(targetRecord);

	return recordValue;
};

/**
 * Places an updated value into a RecordTotal-Period intersection (PeriodTotal)
 *
 * Will generate a new model object and attach to parent RecordTotal if PeriodTotal non-existent
 *
 * @param {string} targetRecordTotalId
 * @param {(string|null)} [targetPeriodId]
 * @param {(string|number)} newValue
 * @returns {(KOPeriodTotal|KOPeriodTotal[])} new or existing PeriodTotal
 * @static
 */
LifeCycle.SpreadData.updatePeriodTotalToValue = function (targetRecordTotalId, targetPeriodId, newValue) {
	var targetRecordTotal = LifeCycle.SpreadData.lookupRecordTotalById(targetRecordTotalId, {
		placeholderType: 'LifeCycleSpreadStatementRecordTotal',
		generatePlaceholder: true,
		alwaysReturnModel: true
	});

	var targetPeriod = LifeCycle.SpreadData.lookupPeriodById(targetPeriodId, {
		placeholderType: 'LifeCycleSpreadStatementPeriod',
		generatePlaceholder: true,
		alwaysReturnModel: true
	});

	var periodTotal = LifeCycle.SpreadData.lookupPeriodTotalByRecordTotalAndPeriod(
		targetRecordTotal,
		targetPeriod,
		true
	);
	if (periodTotal.value() !== newValue) {
		periodTotal.value(newValue);
	}

	return periodTotal;
};

/**
 * Lookup (or create if non existent) record value for record-period intersection
 *
 * @param {KORecord} record
 * @param {KOPeriod} period
 * @param {boolean} [generateNew = false] - Generate and return a new record value if one is not present
 * @return {KORecordValue}
 * @throws {Error} if record and/or period provided are invalid
 * @static
 */
LifeCycle.SpreadData.lookupRecordValueByRecordAndPeriod = function (record, period, generateNew) {
	if (!LifeCycle.SpreadData._isRecord(record) || !LifeCycle.SpreadData._isPeriod(period)) {
		throw new Error('Spread Data - Invalid record or period passed as arguments');
	}

	var recordValues = [];

	for (var i = 0; i < record.recordValues().length; i++) {
		var possibleMatchRecordValue = record.recordValues()[i];
		if (possibleMatchRecordValue.period == period) {
			recordValues.push(possibleMatchRecordValue);
		}
	}

	if (recordValues.length > 1) {
		recordValues[0] = LifeCycle.SpreadData._chooseLatestIForce(recordValues);
		console.error('Spread Data - Too many period total objects for RecordTotal-Period intersection');
	}
	if (recordValues.length || !generateNew) {
		return recordValues[0];
	}

	var recordValue = new _app.SpreadStatementRecordValue({});
	recordValue.period = period;
	recordValue.record = record;

	record.recordValues.push(recordValue);

	LifeCycle.SpreadData._utils.trackChanges(recordValue);

	return recordValue;
};

/**
 * Returns a KORecordValue from the recordId-periodId intersection
 *
 * @param {string} recordId
 * @param {string} periodId
 * @param {boolean} [generateNew = false]
 * @return {(KORecordValue|null)}
 * @static
 */
LifeCycle.SpreadData.lookupRecordValueByRecordIdAndPeriodId = function (recordId, periodId, generateNew) {
	var record = LifeCycle.SpreadData.lookupRecordById(recordId);
	var period = LifeCycle.SpreadData.lookupPeriodById(periodId);
	if (!record || !period) {
		return null;
	}
	return LifeCycle.SpreadData.lookupRecordValueByRecordAndPeriod(record, period, generateNew);
};

/**
 * Lookup (or create if non existent) period total for record-period intersection
 *
 * @param {KORecordTotal} recordTotal
 * @param {KOPeriod} period
 * @param {boolean} [generateNew = false] - Generate and return a new period total if one is not present
 *
 * @throws {Error} if invalid recordTotal / period provided
 * @return {KOPeriodTotal} found or generated period total
 * @static
 */
LifeCycle.SpreadData.lookupPeriodTotalByRecordTotalAndPeriod = function (recordTotal, period, generateNew) {
	if (!LifeCycle.SpreadData._isRecordTotal(recordTotal) || !LifeCycle.SpreadData._isPeriod(period)) {
		throw new Error('Spread Data - Invalid record or period passed as arguments');
	}

	var periodTotals = [];

	for (var i = 0; i < recordTotal.periodTotals().length; i++) {
		var possibleMatchPeriodTotal = recordTotal.periodTotals()[i];
		if (possibleMatchPeriodTotal.period == period) {
			periodTotals.push(possibleMatchPeriodTotal);
		}
	}

	if (periodTotals.length > 1) {
		periodTotals[0] = LifeCycle.SpreadData._chooseLatestIForce(periodTotals);
		console.error('Spread Data - Too many period total objects for RecordTotal-Period intersection');
	}

	if (periodTotals.length || !generateNew) {
		return periodTotals[0];
	}

	var periodTotal = new _app.SpreadStatementPeriodTotal({});
	periodTotal.period = period;
	periodTotal.recordTotal = recordTotal;

	recordTotal.periodTotals.push(periodTotal);

	LifeCycle.SpreadData._utils.trackChanges(periodTotal);

	return periodTotal;
};

/**
 * Returns a KOPeriodTotal from the recordId-periodId intersection
 *
 * @param {string} recordTotalId
 * @param {string} periodId
 * @param {boolean} [generateNew = false]
 * @return {(KOPeriodTotal|null)}
 * @static
 */
LifeCycle.SpreadData.lookupPeriodTotalByRecordTotalIdAndPeriodId = function (recordTotalId, periodId, generateNew) {
	var recordTotal = LifeCycle.SpreadData.lookupRecordTotalById(recordTotalId);
	var period = LifeCycle.SpreadData.lookupPeriodById(periodId);
	if (!recordTotal || !period) {
		return null;
	}
	return LifeCycle.SpreadData.lookupPeriodTotalByRecordTotalAndPeriod(recordTotal, period, generateNew);
};

/**
 * Find a period total by period key
 *
 * // TODO: move to iforce_data_cache, generalize, and create function generators
 *
 * @param {string} periodKey
 * @param {Array} searchSet - Array to reduce the search set to
 * @returns {(KOPeriodTotal|null)}
 * @static
 */
LifeCycle.SpreadData.lookupPeriodTotalByPeriodKey = function (periodKey, searchSet) {
	var _lookupIForcesByFilter = function (filter, userOptions) {
		var matches = [];

		if (!filter || !userOptions) {
			return [];
		}

		var options = {
			filter: filter
		};
		if (userOptions) {
			_.extend(options, userOptions);
		}

		function _each(obj) {
			// Check filter
			try {
				if (options.filter(obj)) {
					matches.push(obj);
				}
			} catch (e) {
				console.warn('IForce Lookup Filter Error: ' + e.toString());
			}
		}

		var obj;
		if (options.array) {
			for (var i = 0; i < options.array.length; i++) {
				obj = options.array[i];
				_each(obj);
			}
		} else {
			//TODO: Uncomment when back in IForce cache
			//for (var prop in _iForceMap) {
			//	if (_iForceMap.hasOwnProperty(prop)) {
			//		obj = _iForceMap[prop];
			//		_each(obj);
			//	}
			//}
		}

		return matches;
	};
	return _lookupIForcesByFilter(function (x) {
		if (!x.period || !x.period.periodKey) {
			return false;
		}
		return x.period.periodKey() == periodKey;
	}, {array: searchSet});
};

LifeCycle.SpreadData.loadAllBundlesForContextObject = function (contextId, options, callback) {
	options = (options || {});
	options.alwaysLoadNewer = true;
	return LifeCycle.SpreadData.getAllBundlesForContextObject(contextId, options, callback);
};
LifeCycle.SpreadData.getAllBundlesForContextObject = function (contextId, options, callback) {
	options = (options || {});
	options.recordId = (contextId || options.recordId);
	return LifeCycle.SpreadData._iForceIdServiceTemplate(
		LifeCycle.Spreads.getBundleIdsForContextId, options, function (bundles) {
			_app.publish(
				'SPREAD.Spreads.Spread_Data.Loaded_All_Bundles', {
					bundles: bundles,
					contextId: options.recordId
				}
			);
			if (callback) {
				callback(bundles);
			}
		}
	);
};

LifeCycle.SpreadData.getRecordsAndTotalsAndClassificationsByName = function (name, options, callback) {
	options = (options || {});
	options.recordId = name;
	return LifeCycle.SpreadData._iForceIdServiceTemplate(
		LifeCycle.SpreadAdminService.getStatementRecordAndRecordTotalAndClassificationIdsByName,
		options,
		callback
	);
};

LifeCycle.SpreadData.lookupAllBundlesForContextObject = function (contextObject) {
	var bundles = [];

	if (LifeCycle.SpreadData._utils.isType(contextObject, 'LifeCycleLoan', false)) {
		var otherLoanSpreads = LifeCycle.SpreadData.lookupSpreadsByProperty('loan', contextObject);
		_.each(otherLoanSpreads, function (loanSpread) {
			var spreadBundle = loanSpread.statement.bundle;
			if (spreadBundle && bundles.indexOf(spreadBundle) == -1) {
				bundles.push(spreadBundle);
			}
		});
	} else if (LifeCycle.SpreadData._utils.isType(contextObject, 'LifeCycleRelationship', false)) {
		bundles = ko.unwrap(contextObject.bundles);
	}

	return bundles;
};

LifeCycle.SpreadData.loadEntireContext = function (contextId, options, callback) {
	options = (options || {});
	options.alwaysLoadNewer = true;
	return LifeCycle.SpreadData.getEntireContext(contextId, options, callback);
};
LifeCycle.SpreadData.getEntireContext = function (contextId, options, callback) {
	options = (options || {});
	options.recordId = (contextId || options.recordId);
	return LifeCycle.SpreadData._iForceTypedIdMapServiceTemplate(
		LifeCycle.Spreads.getContextAndBundleIdsForContext,
		options,
		callback
	);
};

LifeCycle.SpreadData.loadEntireBundle = function (bundleId, options, callback) {
	options = (options || {});
	options.alwaysLoadNewer = true;
	return LifeCycle.SpreadData.getEntireBundle(bundleId, options, callback);
};
LifeCycle.SpreadData.getEntireBundle = function (bundleId, options, callback) {
	options = (options || {});
	options.recordId = (bundleId || options.recordId);
	return LifeCycle.SpreadData._iForceTypedIdMapServiceTemplate(
		LifeCycle.Spreads.getContextAndBundleIdsForContext,
		options,
		function (data) {
			for (var i = 0; i < data.length; i++) {
				var iForce = data[i];
				if (callback && _18Id(iForce.recordId()) == _18Id(options.recordId)) {
					return callback(iForce);
				}
			}
			if (callback) {
				throw 'LifeCycle.SpreadData - Requested bundle not retrieved with result set';
			}
		}
	);
};
LifeCycle.SpreadData.getEntireBundles = function (bundleIds, options, callback) {
	options = (options || {});
	options.recordId = (bundleIds || options.recordIds);

	bundleIds = bundleIds.map(function (id) { return _18Id(id); });

	return LifeCycle.SpreadData._iForceTypedIdMapServiceTemplate(
		LifeCycle.Spreads.getContextAndBundleIdsForContexts,
		options,
		function (data) {
			var bundles = [];
			for (var i = 0; i < data.length; i++) {
				var iForce = data[i];
				if (callback && bundleIds.indexOf(_18Id(iForce.recordId())) != -1) {
					bundles.push(iForce);
				}
			}
			if (callback) {
				if (bundles.length == bundleIds.length) {
					callback(bundles);
				} else {
					throw 'LifeCycle.SpreadData - Requested bundle not retrieved with result set';
				}
			}
		}
	);
};

LifeCycle.SpreadData.loadStatementsForBundle = function (bundleId, options, callback) {
	options = (options || {});
	options.alwaysLoadNewer = true;
	return LifeCycle.SpreadData.getStatementsForBundle(bundleId, options, callback);
};
LifeCycle.SpreadData.getStatementsForBundle = function (bundleId, options, callback) {
	options = (options || {});
	options.recordId = (bundleId || options.recordId);
	return LifeCycle.Spreads.getContextAndBundleIdsForContext([], ko.unwrap(options.recordId), function (typedIds) {
		var statementIds = null;
		for (var type in typedIds) {
			if (typedIds.hasOwnProperty(type)) {
				if (type.indexOf('Spread_Statement_Type') != -1) {
					statementIds = typedIds[type];
					break;
				}
			}
		}
		if (statementIds) {
			options.recordId = null;
			options.recordIds = null;
			LifeCycle.SpreadData.getStatementsById(statementIds, options, callback);
		} else {
			callback(null);
		}
	});
};

LifeCycle.SpreadData.loadRecordTotalsForStatement = function (statementId, options, callback) {
	options = (options || {});
	options.alwaysLoadNewer = true;
	return LifeCycle.SpreadData.getRecordTotalsForStatement(statementId, options, callback);
};
LifeCycle.SpreadData.getRecordTotalsForStatement = function (statementId, options, callback) {
	options = (options || {});
	options.recordId = (statementId || options.recordId);
	return LifeCycle.Spreads.getAllIdsForStatement([], ko.unwrap(options.recordId), function (typedIds) {
		var recordTotalIds = null;
		for (var type in typedIds) {
			if (typedIds.hasOwnProperty(type)) {
				if (type.indexOf('Spread_Statement_Record_Total') != -1) {
					recordTotalIds = typedIds[type];
					break;
				}
			}
		}
		if (recordTotalIds) {
			options.recordId = null;
			options.recordIds = null;
			LifeCycle.SpreadData.getRecordTotalsById(recordTotalIds, options, callback);
		} else {
			callback(null);
		}
	});
};

LifeCycle.SpreadData.loadEntireStatement = function (statementId, options, callback) {
	options = (options || {});
	options.alwaysLoadNewer = true;
	return LifeCycle.SpreadData.getEntireStatement(statementId, options, callback);
};
LifeCycle.SpreadData.getEntireStatement = function (statementId, options, callback) {
	options = (options || {});
	options.recordId = (statementId || options.recordId);
	return LifeCycle.SpreadData._iForceTypedIdMapServiceTemplate(
		LifeCycle.Spreads.getAllIdsForStatement,
		options,
		callback
	);
};

LifeCycle.SpreadData.loadEntireSpread = function (spreadId, options, callback) {
	options = (options || {});
	options.alwaysLoadNewer = true;
	return LifeCycle.SpreadData.getEntireSpread(spreadId, options, callback);
};
/**
 *
 * @param {string} spreadId
 * @param {Object} options
 * @param {boolean} options.includeGlobalAnalysis
 * @param {function} callback
 * @return {*}
 * @static
 */
LifeCycle.SpreadData.getEntireSpread = function (spreadId, options, callback) {
	options = (options || {});
	options.recordId = (spreadId || options.recordId);
	options.additionalArguments = [
		!!options.includeGlobalAnalysis
	];
	return LifeCycle.SpreadData._iForceTypedIdMapServiceTemplate(
		LifeCycle.Spreads.getAllIdsForSpread,
		options,
		callback
	);
};

LifeCycle.SpreadData.loadGlobalAnalysis = function (loanId, options, callback) {
	options = (options || {});
	options.alwaysLoadNewer = true;
	return LifeCycle.SpreadData.getGlobalAnalysis(loanId, options, callback);
};
LifeCycle.SpreadData.getGlobalAnalysis = function (loanId, options, callback) {
	options = (options || {});
	options.recordId = (loanId || options.recordId);
	return LifeCycle.SpreadData._iForceTypedIdMapServiceTemplate(
		LifeCycle.Spreads.getAllIdsForGlobalAnalysis, options, function () {
			var gaBundles = [];

			var loan = LifeCycle.SpreadData.lookupIForceById(options.recordId);
			var loanSpreads = LifeCycle.SpreadData.lookupSpreadsByProperty('loan', loan);
			for (var i = 0; i < loanSpreads.length; i++) {
				var spread = loanSpreads[i];
				if (!spread || !spread.statement || !spread.statement.bundle || _.isEmpty(spread.statement.bundle)) {
					continue;
				}

				var bundle = spread.statement.bundle;
				if (gaBundles.indexOf(bundle) == -1) {
					gaBundles.push(bundle);
				}
			}

			if (callback) {
				callback(gaBundles);
			}
		}
	);
};
LifeCycle.SpreadData.getRMA = function (accountId, options, callback) {
	options = (options || {});
	options.recordId = (accountId || options.recordId);
	return LifeCycle.SpreadData._iForceTypedIdMapServiceTemplate(
	LifeCycle.Spreads.getAllIdsForRMA, options, function () {
			var relationship = LifeCycle.SpreadData.getIForceById(options.recordId);
			if (callback) {
				callback(relationship.bundle);
			}
		}
	);
};

LifeCycle.SpreadData.lookupCovenantComplianceOptionsForStatement = function (statement) {
	if (_.isEmpty(statement)) {
		return null;
	}

	return LifeCycle.SpreadData.lookupCovenantComplianceOptionsForBundle(statement.bundle);
};

LifeCycle.SpreadData.lookupCovenantComplianceOptionsForBundle = function (bundle) {
	if (_.isEmpty(bundle)) {
		return null;
	}

	if (!bundle.container) {
		return [];
	}

	var container = bundle.container;
	var accountCompliances = [];

	if (!container || _.isEmpty(container)) {
		return [];
	}

	for (var i = 0; i < container.accountCovenants().length; i++) {
		var covenant = container.accountCovenants()[i].covenant;
		var covenantCompliances = covenant.covenantCompliances();

		if (!covenant || _.isUndefined(covenantCompliances)) {
			continue;
		}
		([]).push.apply(accountCompliances, covenantCompliances);
	}

	return accountCompliances;

};

LifeCycle.SpreadData.resolveNameToId = function (name, optionalStatementId) {
	// Check Spread Record Totals first
	var recordTotals = LifeCycle.SpreadData.lookupRecordTotalsByName(name, optionalStatementId);
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
	var records = LifeCycle.SpreadData.lookupRecordsByName(name, optionalStatementId);
	switch (records.length) {
		case 1:
			var record = records[0];
			return record.recordId();
		case 0:
			break;
		default:
			throw 'Record Name resolved to >1 record in statement.';
	}

	LifeCycle.SpreadData._app.log('Record / Total Name resolved to 0 record totals in statement.');
	return undefined;
};



LifeCycle.SpreadData._chooseLatestIForce = function (IForces) {
	return _.max(IForces, function(IForce){ return  ko.unwrap(IForce.lastModifiedDate); });
};

LifeCycle.SpreadData.FINANCIAL_GROUP = 'Financial';
LifeCycle.SpreadData.DECIMAL_GROUP = 'Decimal';
LifeCycle.SpreadData.PERCENTAGE_GROUP = 'Percentage';

LifeCycle.SpreadData.DECIMAL_RECORD = 'Decimal';
LifeCycle.SpreadData.PERCENTAGE_RECORD = 'Percentage';
LifeCycle.SpreadData.TRAILING_TWELVE_MONTH = 'Trailing Twelve Month';

LifeCycle.SpreadData.SOURCE_PRECEDENCE = {
	'CPA Audit': 80,
	'CPA Compiled': 70,
	'CPA Review': 60,
	'Tax Return': 50,
	'Comp. Prep': 40,
	'Projected': 30,
	'Other': 20,
	'': 0
};
LifeCycle.SpreadData.SOURCE_PRECEDENCE[null] = 10;

LifeCycle.SpreadData.run = function () {
	_app.subscribe('SPREAD.Spreads.Saved', function () {
		// Clear queues, retrieved RVs and PTs will reflect new values
		LifeCycle.SpreadData.queuedRecordValueUpdates = {};
		LifeCycle.SpreadData.queuedPeriodTotalUpdates = {};
	});

	_app.publish('SPREAD.Spreads.Spread_Data.Started');
};

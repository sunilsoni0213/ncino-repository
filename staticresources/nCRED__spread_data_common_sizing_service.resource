/**
 * Common Sizing calculation and formatting service
 *
 * @class
 * @memberOf LifeCycle.SpreadData
 * @constructor
 */
var CommonSizingService = function () {};

/**
 *
 * @param {KORecordValue} recordValue
 * @return {string}
 * @static
 */
CommonSizingService.calculateAndFormatCommonSizing = function (recordValue) {
	if (!LifeCycle.SpreadData._isRecordValue(recordValue)) {
		return CommonSizingService._formatCommonSizingValue(0, null);
	}
	
	var commonSizingValue = CommonSizingService._calculateCommonSizing(recordValue);
	var record = recordValue.record;
	return CommonSizingService._formatCommonSizingValue(commonSizingValue, record);
};

/**
 *
 * @param {KOPeriodTotal} periodTotal
 * @return {string}
 * @static
 */
CommonSizingService.calculateAndFormatCommonSizingTotal = function (periodTotal) {
	if (!LifeCycle.SpreadData._isPeriodTotal(periodTotal)) {
		return CommonSizingService._formatCommonSizingTotalValue(0);
	}
	
	var commonSizingValue = CommonSizingService._calculateCommonSizing(periodTotal);
	return CommonSizingService._formatCommonSizingTotalValue(commonSizingValue);
};

/**
 * Divides the container's value by the current CS divisor (if present)
 *
 * @param {(KORecordValue|KOPeriodTotal)} valueContainer
 * @return {number}
 * @private
 * @static
 */
CommonSizingService._calculateCommonSizing = function (valueContainer) {
	var divisorRow = CommonSizingService._getCSDivisorRowFromValueContainer(valueContainer);
	if (
		!LifeCycle.SpreadData._isRecord(divisorRow) &&
		!LifeCycle.SpreadData._isRecordTotal(divisorRow)
	) {
		return NaN;
	}
	
	var divisorChildren = (ko.unwrap(divisorRow.recordValues) || ko.unwrap(divisorRow.periodTotals));
	/** @type (KORecordValue|KOPeriodTotal) */
	var divisorValueContainer;
	for (var i = 0; i < divisorChildren.length; i++) {
		var divisorChild = divisorChildren[i];
		if (divisorChild.period == valueContainer.period) {
			divisorValueContainer = divisorChild;
		}
	}
	
	var value = ko.unwrap(valueContainer.value);
	if (!divisorValueContainer) {
		return CommonSizingService._commonSize(value, 0);
	}
	
	var divisor = ko.unwrap(divisorValueContainer.value);
	return CommonSizingService._commonSize(value, divisor);
};

/**
 * Find the calcCommonSizingDivisor
 *
 * @param {(KORecordValue|KOPeriodTotal)} valueContainer
 * @return {(IForceKO|null)} the row that contains the divisor value (KORecord or KORecordTotal)
 * @private
 * @static
 */
CommonSizingService._getCSDivisorRowFromValueContainer = function (valueContainer) {
	/** @type KOStatement */
	if (
		_.isEmpty(valueContainer) ||
		(
			(
				_.isEmpty(valueContainer.record) ||
				_.isEmpty(valueContainer.record.statement)
			) && (
				_.isEmpty(valueContainer.recordTotal) ||
				_.isEmpty(valueContainer.recordTotal.statement)
			)
		)
	) {
		return null;
	}
	
	var statement;
	
	if (LifeCycle.SpreadData._isRecordValue(valueContainer)) {
		statement = valueContainer.record.statement;
	} else if (LifeCycle.SpreadData._isPeriodTotal(valueContainer)) {
		statement = valueContainer.recordTotal.statement;
	} else {
		throw new Error('Value container must be a RecordValue or PeriodTotal');
	}
	
	var divisorId = ko.unwrap(statement.calcCommonSizingDivisorId);
	return LifeCycle.SpreadData.lookupIForceById(divisorId);
};

/**
 * @param {number} value
 * @param {number} divisor
 * @return {number}
 * @private
 * @static
 */
CommonSizingService._commonSize = function (value, divisor) {
	return value / divisor;
};

/**
 * Format a CS value
 *
 * @param {(string|number)} decimalFractionValue - value like 0.5 to format to 50.0%
 * @param {KORecord} record - parent record
 * @return {string}
 * @private
 * @static
 */
CommonSizingService._formatCommonSizingValue = function (decimalFractionValue, record) {
	if (
		isNaN(decimalFractionValue) ||
		decimalFractionValue == Infinity ||
		decimalFractionValue == -Infinity
	) {
		return CommonSizingService.INVALID_COMMON_SIZING_INDICATOR;
	}
	
	if (LifeCycle.SpreadData._isRecord(record) && ko.unwrap(record.isDebit)) {
		decimalFractionValue *= -1;
	}
	
	return LifeCycle.SpreadData.FormattingService.formatPercentageForDisplay(
		decimalFractionValue, {
			decimalPlaces: 1,
			stripSymbol: false
		}
	);
};

/**
 * Format a CS total
 *
 * @param {(string|number)} decimalFractionValue - value like 0.5 to format to 50.0%
 * @return {string}
 * @private
 * @static
 */
CommonSizingService._formatCommonSizingTotalValue = function (decimalFractionValue) {
	if (
		isNaN(decimalFractionValue) ||
		decimalFractionValue == Infinity ||
		decimalFractionValue == -Infinity
	) {
		return CommonSizingService.INVALID_COMMON_SIZING_INDICATOR;
	}
	
	return LifeCycle.SpreadData.FormattingService.formatPercentageForDisplay(
		decimalFractionValue, {
			decimalPlaces: 1,
			stripSymbol: false
		}
	);
};

CommonSizingService.INVALID_COMMON_SIZING_INDICATOR = 'N/A';

if (_.isEmpty(LifeCycle.SpreadData.CommonSizingService)) {
	LifeCycle.SpreadData.CommonSizingService = CommonSizingService;
}
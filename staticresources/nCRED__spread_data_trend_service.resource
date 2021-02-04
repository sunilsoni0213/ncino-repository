/**
 * Trend calculation and formatting service
 *
 * @class
 * @memberOf LifeCycle.SpreadData
 * @constructor
 */
var TrendService = function () {};

/**
 * Checks whether a Period has a matching previous Trend period
 *
 * @param {(KOPeriod|KORecordValue|KOPeriodTotal)} futureThing -
 *	Possible future half of Trend. Can be Period, RecordValue, or PeriodTotal
 * @returns {boolean}
 * @static
 */
TrendService.hasPreviousTrendPeriod = function (futureThing) {
	if (LifeCycle.SpreadData._isPeriod(futureThing)) {
		return !!TrendService.findPreviousTrendPeriodForPeriod(futureThing);
	} else if (
		LifeCycle.SpreadData._isRecordValue(futureThing) ||
		LifeCycle.SpreadData._isPeriodTotal(futureThing)
	) {
		return !!TrendService.findPreviousTrendPeriodForContainer(futureThing);
	} else {
		return false;
	}
};

/**
 * Calculate and format the Trend from the right-hand, future RecordValue
 *
 * @param {KORecordValue} futureRecordValue - PeriodTotal containing the future half of the Trend
 * @returns {string}
 * @static
 */
TrendService.calculateAndFormatTrend = function (futureRecordValue) {
	if (!LifeCycle.SpreadData._isRecordValue(futureRecordValue)) {
		return TrendService._formatTrendValue(0, null);
	}
	
	var trendValue = TrendService._calculateTrendFromFutureValue(futureRecordValue);
	var record = (futureRecordValue.record || null);
	return TrendService._formatTrendValue(trendValue, record);
};

/**
 * Calculate and format the total Trend from the right-hand, future PeriodTotal
 *
 * @param {KOPeriodTotal} futurePeriodTotal - PeriodTotal containing the future half of the Trend
 * @returns {string}
 * @static
 */
TrendService.calculateAndFormatTrendTotal = function (futurePeriodTotal) {
	if (!LifeCycle.SpreadData._isPeriodTotal(futurePeriodTotal)) {
		return TrendService._formatTrendTotalValue(0);
	}
	
	var trendTotalValue = TrendService._calculateTrendFromFutureValue(futurePeriodTotal);
	return TrendService._formatTrendTotalValue(trendTotalValue);
};

/**
 * Finds the appropriate matching past period for trend.
 * The RecordValue argument is assumed to belong to the 'future' period of the trend.
 *
 * @param {(KORecordValue|KOPeriodTotal)} futureValueContainer - parent RecordValue or PeriodTotal
 *	 belonging to 'future half' of trend
 * @return {(KOPeriod|null)} previous period that makes up past half of trend, null if nonexistent
 * @static
 */
TrendService.findPreviousTrendPeriodForContainer = function (futureValueContainer) {
	if (
		(
			!LifeCycle.SpreadData._isPeriodTotal(futureValueContainer) &&
			!LifeCycle.SpreadData._isRecordValue(futureValueContainer)
		) || (
			(
				_.isEmpty(futureValueContainer.record) ||
				_.isEmpty(ko.unwrap(futureValueContainer.record.recordValues))
			) && (
				_.isEmpty(futureValueContainer.recordTotal) ||
				_.isEmpty(ko.unwrap(futureValueContainer.recordTotal.periodTotals))
			)
		)
	) {
		return null;
	}
	
	var parent = (futureValueContainer.record || futureValueContainer.recordTotal);
	var siblings = (ko.unwrap(parent.recordValues) || ko.unwrap(parent.periodTotals));
	siblings.sort(LifeCycle.SpreadData.SortingService.periodValueSorter);
	var thisIndex = siblings.indexOf(futureValueContainer);
	if (thisIndex == -1) {
		console.warn(
			'Trend value container with ID: ' +
			ko.unwrap(futureValueContainer.recordId) +
			' does not belong to its parent\'s children array'
		);
		return null;
	}
	
	var thisPeriod = futureValueContainer.period;
	return TrendService.findPreviousTrendPeriodForPeriod(thisPeriod);
};

/**
 * Find previous Trend period from the (possibly) matching future Trend period
 *
 * @param {KOPeriod} futurePeriod - Future period half of trend
 * @returns {KOPeriod}
 * @throws if argument is not a Statement Period
 * @static
 */
TrendService.findPreviousTrendPeriodForPeriod = function (futurePeriod) {
	if (
		!LifeCycle.SpreadData._isPeriod(futurePeriod) ||
		_.isEmpty(futurePeriod.statement) ||
		_.isEmpty(ko.unwrap(futurePeriod.statement.periods))
	) {
		throw new Error('Argument must be a Period which belongs to a Statement');
	}
	
	var siblingPeriods = ko.unwrap(futurePeriod.statement.periods);
	var bestPastPeriod = null;
	for (var i = 0; i < siblingPeriods.length; i++) {
		var pastPeriod = siblingPeriods[i];
		if (
			pastPeriod == futurePeriod ||
			!TrendService._isEligibleTrendPeriod(futurePeriod, pastPeriod)
		) {
			continue;
		}
		
		if (TrendService._isBetterTrendPeriod(futurePeriod, bestPastPeriod, pastPeriod)) {
			bestPastPeriod = pastPeriod;
		}
	}
	
	return bestPastPeriod;
};

/**
 * Calculates a trend decimal fraction for a RecordValue.
 * Locates appropriate past RecordValue to compare for trend automatically
 *
 * @param {(KORecordValue|KOPeriodTotal)} futureValueContainer - object to calculate
 *	 trend for
 * @return {number}
 * @private
 * @static
 */
TrendService._calculateTrendFromFutureValue = function (futureValueContainer) {
	if (
		!LifeCycle.SpreadData._isRecordValue(futureValueContainer) &&
		!LifeCycle.SpreadData._isPeriodTotal(futureValueContainer)
	) {
		throw new Error('Argument must either be a RecordValue or PeriodTotal object');
	}
	
	var previousTrendRecordValue = TrendService._findPreviousTrendValueContainer(futureValueContainer);
	if (!previousTrendRecordValue) {
		return NaN;
	}
	
	var thisValue = TrendService._prorateTrendValue(futureValueContainer);
	var previousValue = Number(ko.unwrap(previousTrendRecordValue.value));
	
	return TrendService._calculateTrend(previousValue, thisValue);
};

/**
 * Calculates simple trend between two numbers
 *
 * @param {number} previousValue - last period value
 * @param {number} futureValue - next period value
 * @return {number}
 * @private
 * @static
 */
TrendService._calculateTrend = function (previousValue, futureValue) {
	return ((futureValue - previousValue) / previousValue);
};

/**
 * Prorate a value for 12 months
 *
 * @param {number} value
 * @param {number} numberOfPeriods
 * @return {number}
 * @private
 * @static
 */
TrendService._prorateValue = function (value, numberOfPeriods) {
	return (12 / numberOfPeriods) * value;
};

/**
 * Prorates a RecordValue or PeriodTotal to 12 months IFF it belongs in the Income Statement
 *
 * @param {(KORecordValue|KOPeriodTotal)} futureValue
 * @return {number}
 * @throws if invalid argument type
 * @private
 * @static
 */
TrendService._prorateTrendValue = function (futureValue) {
	if (
		!LifeCycle.SpreadData._isPeriodTotal(futureValue) &&
		!LifeCycle.SpreadData._isRecordValue(futureValue)
	) {
		throw new Error('Argument must either be a RecordValue or PeriodTotal object');
	}

	var value = Number(ko.unwrap(futureValue.value));
	
	var parent = (futureValue.record || futureValue.recordTotal);
	if (
		!parent ||
		_.isEmpty(parent.statement) ||
		!ko.unwrap(parent.statement.isIncomeStatement)
	) {
		return value;
	}
	
	var numberOfPeriods = ko.unwrap(futureValue.period.numberOfPeriods);
	return TrendService._prorateValue(value, numberOfPeriods);
};

/**
 * Finds the appropriate matching past RecordValue for trend.
 * The RecordValue argument is assumed to belong to the 'future' period of the trend.
 *
 * @param {(KORecordValue|KOPeriodTotal)} futureValueContainer - parent RecordValue,
 *	 belonging to 'future half' of trend
 * @return {(KORecordValue|KOPeriodTotal|null)} previous RecordValue that makes up past
 *	 half of trend, null if nonexistent
 * @private
 * @static
 */
TrendService._findPreviousTrendValueContainer = function (futureValueContainer) {
	var previousPeriod = TrendService.findPreviousTrendPeriodForContainer(futureValueContainer);
	if (!LifeCycle.SpreadData._isPeriod(previousPeriod)) {
		return null;
	}

	var parent = (futureValueContainer.record || futureValueContainer.recordTotal);
	var siblings = (ko.unwrap(parent.recordValues) || ko.unwrap(parent.periodTotals));
	for (var i = 0; i < siblings.length; i++) {
		var siblingValue = siblings[i];
		if (siblingValue.period == previousPeriod) {
			return siblingValue;
		}
	}
	
	return null;
};

/**
 * Tests whether or not a period meets all of the criteria to be a trend period
 *
 * @param {KOPeriod} futurePeriod
 * @param {KOPeriod} possiblePastPeriod
 * @return {boolean} Trend eligibility
 * @private
 * @static
 */
TrendService._isEligibleTrendPeriod = function (futurePeriod, possiblePastPeriod) {
	if (
		!LifeCycle.SpreadData._isPeriod(futurePeriod) ||
		!LifeCycle.SpreadData._isPeriod(possiblePastPeriod) ||
		!ko.unwrap(futurePeriod.statementDate) ||
		!ko.unwrap(possiblePastPeriod.statementDate)
	) {
		return false;
	}
	
	var futureDate = new Date(ko.unwrap(futurePeriod.statementDate));
	var pastDate = new Date(ko.unwrap(possiblePastPeriod.statementDate));
	if (isNaN(futureDate.getTime()) || isNaN(pastDate.getTime())) {
		throw new Error('Period contained invalid date');
	}
	
	var futureYear = futureDate.getFullYear();
	var pastYear = pastDate.getFullYear();
	
	return (
		ko.unwrap(possiblePastPeriod.numberOfPeriods) == 12 &&
		ko.unwrap(possiblePastPeriod.isFiscalYear) &&
		(futureYear - pastYear) == 1
	);
};

/**
 * Check if one past period is better than another for Trend
 *
 * @param {KOPeriod} futurePeriod - Current future trend period
 * @param {KOPeriod} currentBestPeriod - Currently selected best period
 * @param {KOPeriod} possibleBestPeriod - Possibly better candidate
 * @return {boolean} is best, bro
 * @private
 * @static
 */
TrendService._isBetterTrendPeriod = function (futurePeriod, currentBestPeriod, possibleBestPeriod) {
	if (!LifeCycle.SpreadData._isPeriod(futurePeriod)) {
		throw new Error('Unable to tell if period is better since future-half of trend is not a period');
	}
	
	if (!LifeCycle.SpreadData._isPeriod(possibleBestPeriod)) {
		// most worst
		return false;
	} else if (!LifeCycle.SpreadData._isPeriod(currentBestPeriod)) {
		// so much better
		return true;
	}
	
	var futureSource = ko.unwrap(futurePeriod.source);
	var currentBestSource = ko.unwrap(currentBestPeriod.source);
	var possibleBestSource = ko.unwrap(possibleBestPeriod.source);
	
	// Can't get any better
	if (futureSource == currentBestSource) {
		return false;
	}
	
	var currentBestSourceOrder = TrendService.SOURCE_PRECEDENCE[currentBestSource];
	var possibleBestSourceOrder = TrendService.SOURCE_PRECEDENCE[possibleBestSource];
	
	return (
		possibleBestSource == futureSource ||
		possibleBestSourceOrder > currentBestSourceOrder
	);
};

/**
 * Format a trend value belonging next to a record value
 *
 * @param {(number|string)} decimalFractionValue - trend value like 0.5 to format
 * @param {KORecord} [record] - optional parent record to apply conditional formatting from
 * @return {string}
 * @private
 * @static
 */
TrendService._formatTrendValue = function (decimalFractionValue, record) {
	if (
		isNaN(decimalFractionValue) ||
		decimalFractionValue == Infinity ||
		decimalFractionValue == -Infinity
	) {
		return TrendService.INVALID_TREND_VALUE_INDICATOR;
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
 * Format the group total for trend
 *
 * @param {(number|string)} decimalFractionValue - trend value like 0.5 to format
 * @return {string}
 * @private
 * @static
 */
TrendService._formatTrendTotalValue = function (decimalFractionValue) {
	if (
		isNaN(decimalFractionValue) ||
		decimalFractionValue == Infinity ||
		decimalFractionValue == -Infinity
	) {
		return TrendService.INVALID_TREND_VALUE_INDICATOR;
	}
	
	return LifeCycle.SpreadData.FormattingService.formatPercentageForDisplay(
		decimalFractionValue, {
			decimalPlaces: 1,
			stripSymbol: false
		}
	);
};

/**
 * Same as standard for now
 * @static
 */
TrendService.SOURCE_PRECEDENCE = LifeCycle.SpreadData.SOURCE_PRECEDENCE;
TrendService.INVALID_TREND_VALUE_INDICATOR = 'N/A';

if (_.isEmpty(LifeCycle.SpreadData.TrendService)) {
	LifeCycle.SpreadData.TrendService = TrendService;
}
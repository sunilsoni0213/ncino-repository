/**
 * Sorts spread objects
 * @class
 * @memberOf LifeCycle.SpreadData
 * @constructor
 */
var SortingService = function () {};

/**
 * Sort function used for ordering SpreadStatementPeriodTotal or SpreadStatementRecordValue objects
 *
 * @static
 * @param {(KORecordValue|KOPeriodTotal)} left - liberal argument
 * @param {(KORecordValue|KOPeriodTotal)} right - conservative argument
 *	 parenthesis
 * @returns {Number} -1, 0, or 1 based on which argument is more persuasive
 */
SortingService.periodValueSorter = function (left, right) {
	if (!left.period && !right.period) {
		return 0;
	} else if (!left.period && right.period) {
		return -1;
	} else if (left.period && !right.period) {
		return 1;
	}

	return SortingService.periodSorter(left.period, right.period);
};

/**
 * Sort function used for ordering SpreadStatementPeriod objects by periodKey
 *
 * @static
 * @param {KOPeriod} left - liberal argument
 * @param {KOPeriod} right - conservative argument
 *	 parenthesis
 * @returns {Number} -1, 0, or 1 based on which argument is more persuasive
 */
SortingService.periodSorter = function (left, right) {
	var leftPeriodKey = ko.unwrap(left.periodKey);
	var rightPeriodKey = ko.unwrap(right.periodKey);

	if (leftPeriodKey < rightPeriodKey) {
		return -1;
	}

	if (leftPeriodKey > rightPeriodKey) {
		return 1;
	}

	return 0;
};

if (_.isEmpty(LifeCycle.SpreadData.SortingService)) {
	LifeCycle.SpreadData.SortingService = SortingService;
}
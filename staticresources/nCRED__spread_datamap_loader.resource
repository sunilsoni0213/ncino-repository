/**
 * Loads Statement Data and redraws spread
 * @class
 * @memberOf LifeCycle.SpreadData
 */
var SpreadDataMapLoader = function () {};

/**
 * Contructs an the statement from the given statement Id and the associated Iforce objects related to it
 * @param {string} statementId - The spread statement type/template id to be constructed
 * @param {buildAoDataMapCallback} callback - The callback function that will be passed the resulting variables from the function
 * @static
 */

SpreadDataMapLoader.buildAoDataMap = function(statementId, reload, callback){

	var completed = false;
	var aoPeriods = [];
	var aoRecords = [];
	var aiSelectedYears = [];
	var asRowIds = [];
	var sourceRecordIdMap = {};
	var debtServiceRecordIdMap = {};

	LifeCycle.SpreadData.getEntireStatement(
		statementId,
		{alwaysLoadNewer: reload},
		function () {
			LifeCycle.SpreadData.getStatementById(
				statementId,
				{},
				function (statement) {
					if (completed) {
						return;
					}
					completed = true;

					var app = new LifeCycle.App();
					aoPeriods = app.mapToJS(statement.periods, {
						useOptimizedMapper: true,
						maxDepth: 0,
						maxHeight: 0
					});
					aoPeriods.sort(LifeCycle.SpreadData.SortingService.periodSorter);

					for (var i = 0; i < aoPeriods.length; i++) {
						var period = aoPeriods[i];
						period.iCol = i;

						if (!_.contains(aiSelectedYears, period.year)) {
							aiSelectedYears.push(period.year);
						}
					}

					SpreadStatement.parseRecordsFromIForceObjects(
						statement,
						aoRecords,
						aoPeriods,
						asRowIds,
						aiSelectedYears,
						sourceRecordIdMap,
						false,
						bStaticPeriods,
						debtServiceRecordIdMap);

					var iForceRecords = [];
					_.each(ko.unwrap(statement.recordTotals), function (recordTotal) {
						_.each(ko.unwrap(recordTotal.records), function (record) {
							iForceRecords.push(app.mapToJS(record, {
								allowedPaths: [
									'$root.recordValues.period'
								]
							}));
						});
					});
					SpreadStatement.mergeRecordValuesIntoIForce(aoRecords, aoPeriods, iForceRecords);
					callback(
						statement,
						aoRecords,
						aoPeriods,
						asRowIds,
						aiSelectedYears,
						sourceRecordIdMap,
						bStaticPeriods,
						debtServiceRecordIdMap);
				}
			);
		}
	);
};
/**
 * After AO data has been built pass the results back to
 * @callback buildAoDataMapCallback
 * @param {KOStatement} statement - The statement object populated with periods and recordTotals
 * @param {Object[]} aoRecords - An object array of all the records associated to the statement
 * @param {Object[]} aoPeriods - An object array of all the periods associated to the statement
 * @param {string[]} asRowIds - A string array containing the Statement Record Ids related to the statement
 * @param {number[]} aiSelectedYears - An integer array contain a set of all the selected period's year values
 * @param {Object<string, string>} sourceRecordIdMap - A map with the Statement Total Group Id as the key and the Statement Records as the values
 * @param {boolean} bStaticPeriods - Boolean indicate whether the period has a date or is static
 * @param {Object} debtServiceRecordIdMap - Associated debt service mapped by record Id
 *
 */


if (_.isEmpty(LifeCycle.SpreadData.SpreadDataMapLoader)) {
	LifeCycle.SpreadData.SpreadDataMapLoader = SpreadDataMapLoader;
}


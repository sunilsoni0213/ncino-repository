/**
 * Evaluates formulas contained in {@link KORecordValue RecordValues}
 * @class
 * @memberOf LifeCycle.SpreadData
 * @constructor
 */
var FormulaService = function () {};

/**
 * Evaluates and updates (or creates) a record value that contains a formula
 *
 * This will update the formula property on the specified record-period intersection (record value)
 * If the record value does not exist, this function will create it, and store it
 *
 * The formula string will then be evaluated, and stored in the record value's value property
 *
 * @param {string} formulaString - string of the formula to evaluate
 * @param {KORecord} record
 * @param {KOPeriod} period
 * @param {boolean} preventRecordValueCreation - If there is not a matching value object for the
 * 		record-period intersection one will not be created if this is true
 *
 * @throws {Error} when invalid arguments are passed
 * @static
 */
FormulaService.updateRecordValueFormula = function (formulaString, record, period, preventRecordValueCreation) {
	var recordValue = LifeCycle.SpreadData.lookupRecordValueByRecordAndPeriod(
		record,
		period,
		!preventRecordValueCreation
	);
	
	if (!recordValue) {
		return;
	}
	
	recordValue.formula(formulaString);
};

/**
 * Evaluate a record value's formula property string into a number
 * NOTE: does not actually update the record value's value (this is done via a computed within the model)
 *
 * This should probably only be used in one place across the entire product
 * All other usages should go through updateRecordValueFormula first
 *
 * @param {KORecordValue} recordValue - record value that contains a formula
 *
 * @return {number} the value derived from the RecordValue's formula string property
 * @static
 */
FormulaService.evaluateRecordValueFormula = function (recordValue) {
	var formulaString = ko.unwrap(recordValue.formula);
	return FormulaService.evaluateRecordValueFormulaString(formulaString);
};

/**
 * Evaluate a formula string into a number
 * NOTE: does not actually update a record value's value
 *
 * This can be used to fully check a formula's validity
 *
 * @param {(string|number)} formulaString - the formula string
 * @returns {number} the evaluated formula string
 * @static
 */
FormulaService.evaluateRecordValueFormulaString = function (formulaString) {
	if (typeof formulaString == 'number') {
		return formulaString;
	} else if (typeof formulaString != 'string') {
		return NaN;
	}
	
	if (!FormulaService._preValidateRecordValueFormulaString(formulaString)) {
		return NaN;
	}
	
	var processedString = FormulaService._preProcessRecordValueFormulaString(formulaString);
	
	return FormulaService._evaluateFormulaString(processedString);
};

/**
 * Checks to see if a string (or number) is a valid formula
 *
 * This function performs all stages of evaluation (pre-validation, pre-processing, and evaluation)
 *
 * @param {(string|number)} formulaString - the formula string to check
 * @returns {boolean}
 * @static
 */
FormulaService.isValidFormulaString = function (formulaString) {
	return !isNaN(FormulaService.evaluateRecordValueFormulaString(formulaString));
};

/**
 * Perform some preliminary checks before passing the string to the evaluator
 *
 * NOTE: This does NOT validate the formula.
 * It just performs *additional* validation that the evaluator itFormulaService does not check
 * The evaluator may still return NaN or some other invalid formula result even when this returns true
 *
 * @param {string} unVerifiedFormulaString - formula string of unknown validity
 * @return {boolean} false if formula should be rejected prior to evaluation
 * @private
 * @static
 */
FormulaService._preValidateRecordValueFormulaString = function (unVerifiedFormulaString) {
	// No exponents allowed
	if (unVerifiedFormulaString.indexOf('**') != -1) {
		return false;
	}
	
	for (var i = 0; i < unVerifiedFormulaString.length; i++) {
		var char = unVerifiedFormulaString[i];
		if (FormulaService.VALID_FORMULA_CHARACTERS.indexOf(char) == -1) {
			return false;
		}
	}
	
	return (unVerifiedFormulaString.lastIndexOf('=') <= 0);
};

/**
 * Perform any necessary pre-processing on the formula string before evaluation
 * Notably, removing the optional equal sign
 *
 * @param {string} unprocessedString
 * @return {string} the processed string that other than inherent syntax errors should evaluate correctly
 * @private
 * @static
 */
FormulaService._preProcessRecordValueFormulaString = function (unprocessedString) {
	var processedString = unprocessedString;
	
	processedString = processedString.slice(processedString.indexOf('=') + 1);
	processedString = FormulaService._convertPercentsToDecimals(processedString);
	
	return processedString;
};

/**
 * Removes percent-notation fractions from a string and replaces them with decimal fractions
 *
 * @param {string} stringContainingPercents - any string with percentages in it
 * @returns {string} the string with percents replaced with decimals in place
 * @private
 * @static
 */
FormulaService._convertPercentsToDecimals = function (stringContainingPercents) {
	var percentMatcher = new RegExp('\\b\([0-9\\' + FormulaService.DECIMAL_SYMBOL + ']+\)\\b%', 'g');
	var percents = stringContainingPercents.match(percentMatcher);
	if (percents) {
		for (var i = 0; i < percents.length; i++) {
			var percent = percents[i];
			if (!percent) {
				continue;
			}
			
			var value = percent.substring(0, percent.length - 1);
			var realValue = '' + (value / 100.0);
			
			stringContainingPercents = stringContainingPercents.replace(new RegExp('\\b' + percent, 'g'), realValue);
		}
	}
	
	return stringContainingPercents;
};

/**
 * Internal function to perform the actual evaluation
 * Not specific to record values
 *
 * @param {string} formulaString
 * @return {number} the evaluated formula value (or NaN if formula was invalid)
 * @private
 * @static
 */
FormulaService._evaluateFormulaString = function (formulaString) {
	try {
		return Number(eval(formulaString)); // jshint ignore:line
	} catch (e) {
		return NaN;
	}
};

/**
 * Evaluates whether or not a value *could* be a formula
 *
 * NOTE: Does not evaluate formula validity
 *
 * @param {(string|number)} value - the string or number that needs to be checked
 * @return {boolean} does this string look like a formula
 * @static
 */
FormulaService.isFormulaLike = function (value) {
	var _value = ko.unwrap(value);

	if (typeof _value != 'string') {
		return false;
	}
	
	if (!isNaN(_value)) {
		return false;
	}
	
	// Checks for unary operator only
	for (var i = 0; i < FormulaService.VALID_FORMULA_OPERATORS.length; i++) {
		var operator = FormulaService.VALID_FORMULA_OPERATORS[i];
		if (_value.indexOf(operator) != -1) {
			return true;
		}
	}
	
	return false;
};

var _Utils = (LifeCycle.getCurrencyRegion) ? LifeCycle : Utils; // jshint ignore:line

FormulaService.DECIMAL_SYMBOL =
	jQuery.formatCurrency.regions[_Utils.getCurrencyRegion()]['decimalSymbol'];// jscs:ignore

FormulaService.VALID_UNARY_OPERATORS = ['+', '-'];
FormulaService.VALID_FORMULA_OPERATORS = ['=', '+', '-', '*', '/', '(', ')', ' ', '%'];
FormulaService.VALID_FORMULA_CHARACTERS = FormulaService.VALID_FORMULA_OPERATORS.slice(0).concat(
	['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', FormulaService.DECIMAL_SYMBOL]
);

if (_.isEmpty(LifeCycle.SpreadData.FormulaService)) {
	LifeCycle.SpreadData.FormulaService = FormulaService;
}


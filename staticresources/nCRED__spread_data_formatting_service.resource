/**
 * Generic Formatting Functions for Spreads Functionality
 *
 * Contains shmediumly specific functions for formatting RecordValues and PeriodTotals
 *
 * @class
 * @memberOf LifeCycle.SpreadData
 * @constructor
 */
var FormattingService = function () {};

/**
 * Get a number divisor based on the record or record total's scale
 *
 * @param {(KORecord|KORecordTotal)} recordOrTotal - scale source
 * @returns {number} an integer or floating point divisor based on the bundle's scale
 * @static
 */
FormattingService.getScaleDivisorForRecord = function (recordOrTotal) {
	if (
		!LifeCycle.SpreadData._isRecord(recordOrTotal) &&
		!LifeCycle.SpreadData._isRecordTotal(recordOrTotal)
	) {
		return 1;
	}
	
	if (recordOrTotal.statement && recordOrTotal.statement.bundle) {
		var divisor = ko.unwrap(recordOrTotal.statement.bundle.scaleDivisor);
		if (!isNaN(divisor)) {
			return divisor;
		}
	}
	
	return 1;
};

/**
 * Scales a value by it's parent record or total's bundle's scale.
 * If the value being passed in is not a number or and empty string that value is passed back out.
 * This function does not round or truncate.
 *
 * @param {(number|string)} value - number or number-string to scale
 * @param {(KORecord|KORecordTotal)} recordOrTotal - parent record or total
 * @returns {number} the scaled value
 * @static
 */
FormattingService.scaleValueForRecord = function (value, recordOrTotal) {
	if (isNaN(value) || value === '') {
		return value;
	}
	var scale = FormattingService.getScaleDivisorForRecord(recordOrTotal);
	return FormattingService.scaleValue(value, scale);
};

/**
 * Scales a value by a scale divisor. But does not round or truncate.
 *
 * @param {(number|string)} value - number or number string to scale
 * @param {number} scaleDivisor - number to divide value by
 * @returns {number} scaled number
 * @static
 */
FormattingService.scaleValue = function (value, scaleDivisor) {
	return value / scaleDivisor;
};

/**
 *
 * @param {(number|string)} value - value to format (FINANCIAL, DECIMAL, PERCENTAGE)
 * @param {KORecord} record
 *
 * @param {Object} [userOptions] - formatting options
 * @param {boolean} [userOptions.stripSymbol = true] - remove currency or percent symbol
 * @param {number} [userOptions.decimalPlaces] -  - number of decimal places to display.
 * 		default value per group type:
 * 			FINANCIAL: 0
 *			PERCENTAGE: 0
 *			RATIO: 2
 *
 * @return {string}
 * @static
 */
FormattingService.formatRecordValue = function (value, record, userOptions) {
	var options = {
		stripSymbol: true
	};
	if (userOptions) {
		_.extend(options, userOptions);
	}
	
	if (ko.unwrap(record.isDebit)) {
		value *= -1;
	}
	
	return FormattingService.formatSpreadsValue(value, record, options);
};

/**
 *
 * @param {(number|string)} value - value to format (FINANCIAL, DECIMAL, PERCENTAGE)
 * @param {KORecordTotal} recordTotal
 * @param {Object} [userOptions] - formatting options
 * @param {boolean} [userOptions.stripSymbol = false] - remove currency or percent symbol
 * @param {number} [userOptions.decimalPlaces] -  - number of decimal places to display.
 * 		default value per group type:
 * 			FINANCIAL: 0
 *			PERCENTAGE: 0
 *			RATIO: 2
 *
 * @return {string}
 * @static
 */
FormattingService.formatPeriodTotal = function (value, recordTotal, userOptions) {
	var options = {
		stripSymbol: false
	};
	if (userOptions) {
		_.extend(options, userOptions);
	}
	
	return FormattingService.formatSpreadsValue(value, recordTotal, options);
};

/**
 * Formats a record value or period total
 *
 * @param {(number|string)} value - value to format (FINANCIAL, DECIMAL, PERCENTAGE)
 * @param {(KORecord|KORecordTotal)} container - the direct hierarchical parent.
 *	If the value argument is for a RecordValue, this *must* be a Record
 *	If the value argument is for a PeriodTotal, this *must* be a RecordTotal
 *
 * @param {Object} [userOptions] - formatting options
 * @param {boolean} [userOptions.stripSymbol] - remove currency or percent symbol
 * @param {number} [userOptions.decimalPlaces] -  - number of decimal places to display.
 * 		default value per group type:
 * 			FINANCIAL: 0
 *			PERCENTAGE: 0
 *			RATIO: 2
 *
 * @throws error if recordOrTotal is not a Record or RecordTotal
 * @return {string}
 * @static
 */
FormattingService.formatSpreadsValue = function (value, container, userOptions) {
	var recordTotal;
	var record;
	if (LifeCycle.SpreadData._isRecordTotal(container)) {
		recordTotal = container;
	} else if (LifeCycle.SpreadData._isRecord(container)) {
		if (LifeCycle.SpreadData._isRecordTotal(container.recordTotal)) {
			recordTotal = container.recordTotal;
		} else {
			recordTotal = new LifeCycle.SpreadData._app.SpreadStatementRecordTotal({});
		}
		record = container;
	} else {
		throw new Error('recordOrTotal parameter must be a record or recordTotal');
	}
	
	// Format based on source record
	if (
		record &&
		(
			LifeCycle.SpreadData._isRecordTotal(record.linkedRecord) ||
			(
				LifeCycle.SpreadData._isRecord(record.linkedRecord) &&
				LifeCycle.SpreadData._isRecordTotal(record.linkedRecord.recordTotal)
			)
		)
	) {
		return FormattingService.formatSpreadsValue(value, record.linkedRecord, userOptions);
	}
	
	// Record type overrides group type if not DECIMAL
	if (record && record.displayType && ko.unwrap(record.displayType) == LifeCycle.SpreadData.PERCENTAGE_RECORD) {
		return FormattingService.formatPercentageForDisplay(value, userOptions);
	}
	
	switch (ko.unwrap(recordTotal.groupType)) {
		case LifeCycle.SpreadData.FINANCIAL_GROUP:
			var scaleDivisor = FormattingService.getScaleDivisorForRecord(container);
			return FormattingService._formatAndScaleCurrencyForDisplay(value, scaleDivisor, userOptions);
		case LifeCycle.SpreadData.PERCENTAGE_GROUP:
			return FormattingService.formatPercentageForDisplay(value, userOptions);
		case LifeCycle.SpreadData.DECIMAL_GROUP:
			return FormattingService.formatRatioForDisplay(value, userOptions);
		default:
			return '' + value;
	}
};

/**
 * NOTE: In-Spreads values should use formatRecordValue, formatPeriodTotal, or formatSpreadsValue instead
 *
 * Format a percentage for display
 *
 * @param {(number|string)} decimalFractionValue - value like 0.5 to format to 50.0%
 * @param {Object} [userOptions] - formatting options:
 * @param {boolean} [userOptions.stripSymbol = false] - remove currency or percent symbol
 * @param {number} [userOptions.decimalPlaces = 0] -  - number of decimal places to display.
 *
 * @returns {string}
 * @static
 */
FormattingService.formatPercentageForDisplay = function (decimalFractionValue, userOptions) {
	var options = {
		stripSymbol: false,
		decimalPlaces: 0
	};
	if (userOptions) {
		_.extend(options, userOptions);
	}
	if (isNaN(decimalFractionValue)) {
		return decimalFractionValue;
	}
	function _fnFormatPercentageForDisplay(value, precision, addSymbol) {

		var result = '0';
		if (!precision && precision !== 0) {
			precision = 1;
		}
		if (precision > 0) {
			result += '.';
			for (var i = 0; i < precision; i++) {
				result += '0';
			}
		}
		if (!_.isUndefined(value) && !isNaN(value)) {
			var abs = (Math.abs(value) * 100).toFixed(precision);
			result = (value < 0) ? '(' + abs + ')' : abs;
		}
		return (addSymbol) ? result + '%' : result;
	}
	
	return _fnFormatPercentageForDisplay(decimalFractionValue, options.decimalPlaces, !options.stripSymbol);
};

/**
 * NOTE: In-Spreads values should use formatRecordValue, formatPeriodTotal, or formatSpreadsValue instead
 *
 * Format a ratio for display
 *
 * @param {(number|string)} decimalValue - decimal value for ratios
 * @param {Object} [userOptions] - formatting options
 * @param {number} [userOptions.decimalPlaces = 2] -  - number of decimal places to display.
 *
 * @returns {string}
 * @static
 */
FormattingService.formatRatioForDisplay = function (decimalValue, userOptions) {
	var options = {
		decimalPlaces: 2
	};
	if (userOptions) {
		_.extend(options, userOptions);
	}

	if (isNaN(decimalValue)) {
		return decimalValue;
	}

	return decimalValue.toFixed(options.decimalPlaces);
};

/**
 * NOTE: In-Spreads values should use formatRecordValue, formatPeriodTotal, or formatSpreadsValue instead
 *
 * Scale a value, format as a currency value, and apply locale formatting
 * Optionally, remove the locale symbol from the formatted value
 *
 * @param {(number|string)} currencyValue - value to format and scale
 * @param {number} scaleDivisor - scale to multiply the value by
 * @param {Object} [userOptions] - formatting options:
 *		stripSymbol {boolean} - remove currency or percent symbol.
 *			default false
 *		decimalPlaces {number} - number of decimal places to display.
 *			default 0
 *
 * @return {*}
 * @private
 * @static
 */
FormattingService._formatAndScaleCurrencyForDisplay = function (currencyValue, scaleDivisor, userOptions) {
	var options = {
		stripSymbol: false,
		decimalPlaces: 0
	};
	if (userOptions) {
		_.extend(options, userOptions);
	}
	if (isNaN(currencyValue)) {
		return currencyValue;
	}
	scaleDivisor = (scaleDivisor || 1);
	
	var adjustedValue = FormattingService.scaleValue(currencyValue, scaleDivisor);
	
	if (
		options.stripSymbol &&
		!options.decimalPlaces &&
		currencyValue &&
		Math.abs(adjustedValue) < 1
	) {
		return FormattingService.INSIGNIFICANT_VALUE_INDICATOR;
	}
	
	/**
	 * Copy of the Utils.formatCurrencyForDisplay
	 *
	 * @param {(string|number)} value - the value to format
	 * @param {boolean} stripSymbol - remove locale symbol after formatting
	 * @returns {string} formatted locale-specific currency string
	 */
	var formatCurrencyForDisplay = function (value, stripSymbol) {
		/**
		 * @typedef {Object}
		 * @property {function} getCurrencyRegion
		 */
		var lang = Utils.getCurrencyRegion();
		var currencySettings = {
			'region': lang,
			'roundToDecimalPlace': options.decimalPlaces,
			'removeTrailingZerosOnDecimal': true
		};
		
		/**
		 * @typedef {Object}
		 * @property {function} formatCurrency
		 */
		var input = jQuery('<input>');
		input.val(value);
		input.formatCurrency(currencySettings);
		
		var toReturn = input.val();
		if (stripSymbol) {
			// now strip off the currency symbol
			var symbol = jQuery.formatCurrency.regions[lang]['symbol'];// jscs: ignore
			toReturn = toReturn.replace(symbol, '');
		}
		
		return toReturn;
	};
	
	return formatCurrencyForDisplay(adjustedValue, options.stripSymbol);
};

/**
 * Returns the correct String literal for the given scale
 * If the value being passed in is not a number or and empty string that value is passed back out.
 *
 * @param {(number|string)} scale - number or number-string to matching scale literal
 * @param {boolean} [parenthesisIndicator] - whether or not the function should return the string surrounded with
 *	 parenthesis
 * @returns {string} the scaled value in a string representation of 'Displayed in ' +  'millions', 'thousands', or
 *	 'actual'
 * @static
 */
FormattingService.formatScaleInToDisplayString = function (scale, parenthesisIndicator) {

	var scaleLabel = LifeCycle.msgs.msg_spreads_scale_hint + ' ';
	switch (scale) {
		case 'm':
		case 'M':
		case '1000' :
		case 1000 :
			scaleLabel += LifeCycle.msgs.msg_spreads_scale_description_thousands;
			break;
		case 'mm':
		case 'MM':
		case '1000000' :
		case 1000000 :
			scaleLabel += LifeCycle.msgs.msg_spreads_scale_description_millions;
			break;
		default:
			scaleLabel += LifeCycle.msgs.msg_spreads_scale_description_actual;
	}
	scaleLabel = (parenthesisIndicator) ? '(' + scaleLabel + ')' : scaleLabel;
	return scaleLabel;
};

FormattingService.INSIGNIFICANT_VALUE_INDICATOR = '<1';

ko.bindingHandlers.spreadsValue = {
	update: function(element, valueAccessor, allBindingsAccessor){
		var options = allBindingsAccessor().formatOptions || {};
		var container = allBindingsAccessor().record || allBindingsAccessor().recordTotal || {};
		var value = ko.utils.unwrapObservable(valueAccessor());
		var formatted = FormattingService.formatSpreadsValue(value, container, options);
		ko.bindingHandlers.text.update(element, function() { return formatted; });
	}
};

ko.bindingHandlers.nonSpreadsCurrencyValue = {
	update: function(element, valueAccessor, allBindingsAccessor){
		var options = allBindingsAccessor().formatOptions || {};
		var value = ko.utils.unwrapObservable(valueAccessor());
		var formatted = FormattingService._formatAndScaleCurrencyForDisplay(value, options.scale, options);
		ko.bindingHandlers.text.update(element, function() { return formatted; });
	}
};

ko.bindingHandlers.nonSpreadsPercentageValue = {
	update: function(element, valueAccessor, allBindingsAccessor){
		var options = allBindingsAccessor().formatOptions || {};
		var value = ko.utils.unwrapObservable(valueAccessor());
		var formatted = FormattingService.formatPercentageForDisplay(value, options);
		ko.bindingHandlers.text.update(element, function() { return formatted; });
	}
};

ko.bindingHandlers.nonSpreadsRatioValue = {
	update: function(element, valueAccessor, allBindingsAccessor){
		var options = allBindingsAccessor().formatOptions || {};
		var value = Number(ko.utils.unwrapObservable(valueAccessor()));
		var formatted = FormattingService.formatRatioForDisplay(value, options);
		ko.bindingHandlers.text.update(element, function() { return formatted; });
	}
};

if (_.isEmpty(LifeCycle.SpreadData.FormattingService)) {
	LifeCycle.SpreadData.FormattingService = FormattingService;
}

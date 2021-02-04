angular.module('selfRegisterApp')
	.constant('LOADER_EVENTS', {
		'SHOW': 'SHOW_LOADER',
		'HIDE': 'HIDE_LOADER'
	})
	.factory('helperService', ['$rootScope', 'LOADER_EVENTS', '$location', '$filter', 'FORM_CONSTANTS',
		function($rootScope, LOADER_EVENTS, $location, $filter, FORM_CONSTANTS) {
	var svc = this;
	svc.getURL = getURL;
	svc.setWindowURL = setWindowURL;
	svc.getParameterByName = getParameterByName;
	svc.updateQueryStringParameter = updateQueryStringParameter;
	svc.getAppName = getAppName;
	svc.convertToLongDate = convertToLongDate;
	svc.showLoader = showLoader;
	svc.hideLoader = hideLoader;
	svc.generateID = generateID;
	svc.showMessage = showMessage;
	svc.linkify = linkify;
	svc.applyFieldFormatting = applyFieldFormatting;
	svc.buildAddress = buildAddress;
	svc.convertDatepickerTimeToLocalDate = convertDatepickerTimeToLocalDate;
	svc.formatNumber = formatNumber;
	svc.filterDate = filterDate;
	svc.filterDatetime = filterDatetime;
	svc.printSelectedMultiPicklistItems = printSelectedMultiPicklistItems;
	svc.isValidMonth = isValidMonth;
	svc.isValidDay = isValidDay;
	svc.isValidYear = isValidYear;
	svc.parseISODate = parseISODate;

	svc.addressFields = {
		'Account': {
			primaryTitle: 'Billing Address',
			primary: [
				'BillingStreet',
				'BillingCity',
				'BillingState',
				'BillingPostalCode',
				'BillingCountry'
			],
			secondaryTitle: 'Shipping Address',
			secondary: [
				'ShippingStreet',
				'ShippingCity',
				'ShippingState',
				'ShippingPostalCode',
				'ShippingCountry'
			]
		},
		'Contact': {
			primaryTitle: 'Residential Address',
			primary: [
				'LLC_BI__Home_Address__c',
				'LLC_BI__Home_City__c',
				'LLC_BI__Home_State__c',
				'LLC_BI__Home_Zipcode__c',
				'MailingCountry'
			],
			secondaryTitle: 'Mailing Address',
			secondary: [
				'MailingStreet',
				'MailingCity',
				'MailingState',
				'MailingPostalCode',
				'MailingCountry'
			]
		}
	};

	return svc;

	function getURL() {
		return window.location.href;
	}

	function setWindowURL(url) {
		window.location.href = url;
	}

	function getParameterByName(name) {
		var url = svc.getURL();
		name = name.replace(/[\[\]]/g, "\\$&");
		var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
		results = regex.exec(url);
		if (!results) {
			return null;
		}
		if (!results[2]) {
			return '';
		}
		return decodeURIComponent(results[2].replace(/\+/g, " "));
	}

	function updateQueryStringParameter(uri, key, value){
		var re = new RegExp("([?&])" + key + "=.*?(&|$)", "i");
		var separator = uri.indexOf('?') !== -1 ? "&" : "?";
		if (uri.match(re)) {
			return uri.replace(re, '$1' + key + "=" + value + '$2');
		}
		else {
			return uri + separator + key + "=" + value;
		}
	}

	function getAppName() {
		// Get the app name from the hashbang parameter
		if (!$location.path() || !$location.path().replace('/', '')) {
			return svc.getParameterByName('app');
		}
		else {
			return $location.path().replace('/', '');
		}
	}

	function convertToLongDate(dateString) {
		return Date.parse(dateString);
	}

	function showLoader(msg) {
		var loaderID = generateID();
		$rootScope.$broadcast(LOADER_EVENTS.SHOW, {
			id: loaderID,
			message: msg
		});
		return loaderID;
	}

	function hideLoader(loaderID) {
		$rootScope.$broadcast(LOADER_EVENTS.HIDE, {
			id: loaderID
		});
	}

	function generateID() {
		var id = '';
		var length = 10;
		var possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
		for(var i = 0; i < length; i++) {
			id += possible.charAt(Math.floor(Math.random() * possible.length));
		}
		return id;
	}

	function showMessage(msg, type, txt) {
		var messageID = generateID();
		$rootScope.$broadcast('SHOW_MESSAGE', {
			id: messageID,
			message: msg,
			type: type,
			subText: txt
		});
 	}

 	function linkify(uri, text, isNewTab) {
		var link = document.createElement('a');
		link.href = uri;
		link.appendChild(document.createTextNode(text || uri));
		if (isNewTab) {
			link.target = '_blank';
		}
		return link.outerHTML;
	}

	function applyFieldFormatting(fieldSet) {
		var lineItems = svc.addressFields[fieldSet.sObjectType];

		var filteredFields = [];
		var hasPrimaryAddress = false;
		var hasSecondaryAddress = false;
		var primaryAddress = {};
		var secondaryAddress = {};
		for (var i = 0; i < fieldSet.fields.length; i++) {
			var field = fieldSet.fields[i];
			var path = field.fieldPath.split('.')[field.fieldPath.split('.').length - 1];
			if (lineItems && lineItems.primary.indexOf(path) > -1) {
				hasPrimaryAddress = true;
				primaryAddress[path] = field.value;
			}
			else if (lineItems && lineItems.secondary.indexOf(path) > -1) {
				hasSecondaryAddress = true;
				secondaryAddress[path] = field.value;
			}
			else if (field.type == FORM_CONSTANTS.MULTIPICKLIST_TYPE) {
				// Multi-select values are stored as semicolon delimited lists, pretty print them
				field.value = svc.printSelectedMultiPicklistItems(field);
				filteredFields.push(field);
			}
			else {
				filteredFields.push(field);
			}
		}

		if (hasPrimaryAddress) {
			var address = buildAddress(lineItems.primaryTitle, lineItems.primary, primaryAddress);
			filteredFields.push(address);
		}

		if (hasSecondaryAddress) {
			var address = buildAddress(lineItems.secondaryTitle, lineItems.secondary, secondaryAddress);
			filteredFields.push(address);
		}

		return filteredFields;
	}

	function printSelectedMultiPicklistItems(field) {
		return field.value ? field.value.split(';').join(', ') : '';
	}

	function buildAddress(title, fieldList, addressFields) {
		var addressField = {type : 'ADDRESS', label : title, value : ''};

		var address = [];
		var street = addressFields[fieldList[0]];
		var city = addressFields[fieldList[1]];
		var state = addressFields[fieldList[2]];
		var zip = addressFields[fieldList[3]];
		var country = addressFields[fieldList[4]];

		if (street) {
			address.push(street);
		}

		var line2 = '';
		if (city) {
			line2 += city;
		}
		if (state) {
			if (line2 != '')
				line2 += ', ';
			line2 += state;
		}
		if (zip) {
			if (line2)
				line2 += ' ';
			line2 += zip;
		}
		if (line2)
			address.push(line2);

		if (country) {
			address.push(country);
		}

		addressField.value = address;

		return addressField;
	}

	function convertDatepickerTimeToLocalDate(date) {
		var offset = date.getTimezoneOffset() / 60;
		var hours = date.getHours();

		date.setHours(hours - offset);

		return date;
	}

	function formatNumber(number) {
		if (!number) {
			return null;
		}
		number = number.replace(/[^\d.-]/g, '');
		number = number.replace(/,/g,'');
		var parts = number.toString().split(".");
		parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		return parts.join(".");
	}

	function filterDate(dateString, format) {
		if (!dateString) {
			return '';
		}
		// For whole dates, parse the date as absolute (converting it to local time could result in inaccuracy)
		return $filter('date')(svc.parseISODate(dateString), format);
	}

	function filterDatetime(dateString, format) {
		if (!dateString) {
			return '';
		}
		// Convert the stored / retrieved UTC date to local time
		var localDate = svc.convertDatepickerTimeToLocalDate(svc.parseISODate(dateString));
		return $filter('date')(localDate, format);
	}

	function parseISODate(dateString) {
		var parts = dateString.split(' ');
		var dateValue = parts[0].split("-");
		var timeValue = parts[1].split(":");
		return new Date(dateValue[0],(dateValue[1] - 1), dateValue[2], timeValue[0], timeValue[1], timeValue[2]);
	}

	function isValidMonth(month) {
		return month > 0 && month < 13;
	}

	function isValidDay(year, month, day) {
		return day > 0 && day <= new Date(year, month, 0).getDate();
	}

	function isValidYear(year) {
		return year > 999 && year <= 9999;
	}
}]);
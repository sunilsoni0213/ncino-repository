angular.module('selfRegisterApp')
	.constant('FORM_CONSTANTS', {
		'FILE_SERVLET': 'servlet/servlet.FileDownload?file=',
		'STATUS_SUBMITTED': 'Complete',
		'ID_TYPE': 'ID',
		'LOOKUP_TYPE': 'REFERENCE',
		'DATE_TYPE': 'DATE',
		'DATETIME_TYPE': 'DATETIME',
		'MULTIPICKLIST_TYPE': 'MULTIPICKLIST',
		'NUMBER_TYPE': 'NUMBER',
		'DOUBLE_TYPE': 'DOUBLE',
		'PERCENT_TYPE': 'PERCENT',
		'CURRENCY_TYPE': 'CURRENCY',
		'DATETIME_TYPE': 'DATETIME',
		'LOAN_APPLICATION_TYPE': 'Online Loan Application',
		'ID_PARAM': 'id'
	})
	.constant('FIELD_ERRORS', {
		'LOOKUP': 'invalidLookup'
	})
	.constant('NAV_EVENTS', {
		'SAVE_FORM': 'SAVE_FORM',
		'NAV_LOAD': 'NAV_LOAD',
		'NAVIGATE': 'NAVIGATE',
		'EDIT_REVIEW': 'EDIT_REVIEW',
		'HASH_CHANGE': 'HASH_CHANGE'
	})
	.constant('VF_PAGES', {
		'PORTAL': 'PORTAL?',
		'DASHBOARD': 'DASHBOARD',
		'DOCUMENTUPLOAD': 'DOCUMENTUPLOAD',
		'PRODUCTEXPLORER': 'PRODUCTEXPLORER'
	})
	.constant('DOC_CONSTANTS', {
		'TO_DO_HASH': 'to-do',
		'REVIEW_HASH': 'under-review',
		'APPROVED_HASH': 'approved'
	})
	.constant('DYNAMIC_RENDER', {
		'RENDER_START': '{{',
		'RENDER_END': '}}'
	})
	.constant('SOBJ_TYPES', {
		'APPLICATION': 'LLC_BI__Application__c',
		'LOAN': 'LLC_BI__Loan__c',
		'DEPOSIT': 'LLC_BI__Deposit__c',
		'ACCOUNT': 'Account'
	})
	.constant('DATE_DELIMITER', {
		'SLASH': '/',
		'DASH': '-'
	});
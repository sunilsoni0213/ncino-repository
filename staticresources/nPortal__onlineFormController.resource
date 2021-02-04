angular.module('selfRegisterApp')
	.controller('OnlineFormController', ['$rootScope', '$scope', 'label', 'onlineFormsDataService', '$sce',
		'helperService', 'NAV_EVENTS', 'FORM_CONSTANTS', 'MESSAGE_CONSTANTS', 'FIELD_ERRORS', 'applicationFactory', '$location',
		function($rootScope, $scope, label, onlineFormsDataService, $sce, helperService, NAV_EVENTS,
			FORM_CONSTANTS, MESSAGE_CONSTANTS, FIELD_ERRORS, applicationFactory, $location) {

		var vm = this;
		vm.label = label.getLabels();
		vm.applicationId = '';
		vm.route = {
			headerText: '',
			subheaderText: '',
			portalIconPath: ''
		};
		vm.appName = '';
		vm.productId = null;
		vm.onlineFormSubmitted = false;
		vm.iconBasePath = '';
		vm.terms = [];
		vm.reviewRoutes = [];
		vm.exitInfo = {};
		vm.othersInvolved = [];
		vm.othersInvolvedRoute = {};
		vm.connectionRoles = [];
		vm.borrowerTypes = ['Co-Borrower', 'Guarantor'];
		vm.applicationStatus = '';
		vm.isContextComplete = false;
		vm.applicationType = '';
		vm.productName = '';
		vm.currencySymbol = '';
		vm.dateFormat = '';
		vm.fieldErrors = FIELD_ERRORS;

		vm.init = init;
		vm.getId = getId;
		vm.loadUrlParameters = loadUrlParameters;
		vm.retrieveUIData = retrieveUIData;
		vm.submitOnlineForm = submitOnlineForm;
		vm.handleSaveEvent = handleSaveEvent;
		vm.handleNavigateEvent = handleNavigateEvent;
		vm.reloadFormData = reloadFormData;
		vm.toTrusted = toTrusted;
		vm.getGridColClass = getGridColClass;
		vm.setupFields = setupFields;
		vm.retrieveTerms = retrieveTerms;
		vm.formatAgreementText = formatAgreementText;
		vm.updateAgreement = updateAgreement;
		vm.retrieveReviewData = retrieveReviewData;
		vm.getRouteHref = getRouteHref;
		vm.saveAndExit = saveAndExit;
		vm.saveReview = saveReview;
		vm.exitApplication = exitApplication;
		vm.submitApp = submitApp;
		vm.skipForm = skipForm;
		vm.addOther = addOther;
		vm.removeOther = removeOther;
		vm.saveOthersInvolved = saveOthersInvolved;
		vm.retrieveOthersInvolved = retrieveOthersInvolved;
		vm.retrieveOthersInvolvedRoles = retrieveOthersInvolvedRoles;
		vm.getOthersInvolvedRoute = getOthersInvolvedRoute;
		vm.buildConnectionRoleField = buildConnectionRoleField;
		vm.retrieveLookupOptions = retrieveLookupOptions;
		vm.expandLookup = expandLookup;
		vm.expandMultiPicklist = expandMultiPicklist;
		vm.selectMultiPicklistItem = selectMultiPicklistItem;
		vm.printSelectedMultiPicklistItems = printSelectedMultiPicklistItems;
		vm.isMultiPicklistItemSelected = isMultiPicklistItemSelected;
		vm.syncAddresses = syncAddresses;
		vm.validateFormat = validateFormat;
		vm.formIsValid = formIsValid;
		vm.clearIfMasked = clearIfMasked;
		vm.resetIfMasked = resetIfMasked;
		vm.getReviewRouteFields = getReviewRouteFields;
		vm.getIsContextComplete = getIsContextComplete;
		vm.getOnlineApplicationType = getOnlineApplicationType;
		vm.getProductName = getProductName;
		vm.editReviewItem = editReviewItem;
		vm.convertToLongDate = convertToLongDate;
		vm.getIsGrandchildRoute = getIsGrandchildRoute;
		vm.getCurrencySymbol = getCurrencySymbol;
		vm.getDateFormat = getDateFormat;
		vm.redirectToParentRoute = redirectToParentRoute;
		vm.filterDate = filterDate;
		vm.filterDatetime = filterDatetime;
		vm.validateLookupField = validateLookupField;
		vm.selectLookupEntry = selectLookupEntry;

		vm.init();

		$scope.$on(NAV_EVENTS.SAVE_FORM, vm.handleSaveEvent);
		$scope.$on(NAV_EVENTS.NAVIGATE, vm.handleNavigateEvent);

		function init() {
			vm.getId();
			vm.loadUrlParameters();
			vm.getCurrencySymbol();
			vm.getDateFormat();
			vm.getIsContextComplete();
			vm.retrieveUIData();
			vm.getOnlineApplicationType();
			vm.getProductName();
		}

		function getId() {
			vm.applicationId = helperService.getParameterByName('id');
		}

		function loadUrlParameters() {
			vm.appName = helperService.getAppName();
			vm.productId = helperService.getParameterByName('productId');
		}

		function retrieveUIData() {
			var loaderID = helperService.showLoader();
			if (vm.appName) {
				onlineFormsDataService.retrieveUIData(vm.appName, vm.applicationId).then(function(response) {
					helperService.hideLoader(loaderID);
					if (response.type && response.type === 'exception') {
						helperService.showMessage(vm.label.Error_Retrieve_UI, MESSAGE_CONSTANTS.TYPE_ERROR);
					}
					else {
						vm.setupFields(JSON.parse(response));
						vm.retrieveTerms();
					}
				});
			}
		}

		function handleSaveEvent(event, data) {
			// Reload form data and clear watcher
			if (vm.appName != helperService.getAppName()) {
				vm.reloadFormData();
			}
		}

		function handleNavigateEvent(event, data) {
			// Reload form data and clear watcher
			if (vm.appName != helperService.getAppName()) {
				vm.reloadFormData();
			}
		}

		function reloadFormData() {
			// Reset page state
			vm.onlineFormSubmitted = false;

			// Reload dynamic data
			vm.init();
		}

		function formatAgreementText(terms) {
			var link = helperService.linkify(FORM_CONSTANTS.FILE_SERVLET + terms.documentId, terms.name, true);
			return terms.agreementText.replace('{0}', link);
		}

		function submitOnlineForm(loaderMessage) {
			vm.onlineFormSubmitted = true;
			if (vm.formIsValid()) {
				var loaderID = helperService.showLoader(loaderMessage);
				onlineFormsDataService.saveForm(angular.toJson(vm.route), vm.applicationId, vm.productId).then(function(response) {
					if (response.type && response.type === 'exception') {
						helperService.hideLoader(loaderID);
						helperService.showMessage(vm.label.Application_Save_Error, MESSAGE_CONSTANTS.TYPE_ERROR);
					}
					else {
						var application = JSON.parse(response);
						vm.applicationId = application.sid;
						for (var i = 0; i < vm.terms.length; i++) {
							vm.updateAgreement(i);
						}
						applicationFactory.handleSaveEvent(JSON.parse(response));
						helperService.hideLoader(loaderID);
					}
				});
			}
		}

		function submitApp() {
			vm.onlineFormSubmitted = true;
			if (vm.formIsValid()) {
				var loaderID = helperService.showLoader(vm.label.Application_Submit_Message);
				// Update the application status and mark context complete
				onlineFormsDataService.submitApp(angular.toJson(vm.route), vm.applicationId).then(function(response) {
					if (response.type && response.type === 'exception') {
						helperService.hideLoader(loaderID);
						helperService.showMessage(vm.label.Application_Submit_Error, MESSAGE_CONSTANTS.TYPE_ERROR);
					}
					else {
						var application = JSON.parse(response);
						vm.applicationId = application.sid;

						// Activate any inactive users
						onlineFormsDataService.reactivateOthersInvolved(vm.applicationId).then(function(response) {
							if (response.type && response.type === 'exception') {
								helperService.hideLoader(loaderID);
								helperService.showMessage(vm.label.Application_Submit_Error, MESSAGE_CONSTANTS.TYPE_ERROR);
							}
							else {
								// Finally, perform user and context creation for the application
								onlineFormsDataService.submitOthersInvolved(vm.applicationId).then(function(response) {
									if (response.type && response.type === 'exception') {
										helperService.hideLoader(loaderID);
										helperService.showMessage(vm.label.Application_Submit_Error, MESSAGE_CONSTANTS.TYPE_ERROR);
									}
									else {
										helperService.hideLoader(loaderID);
										vm.isContextComplete = true;
										applicationFactory.handleSaveEvent(JSON.parse(response));
									}
								});
							}
						});
					}
				});
			}
		}

		function retrieveTerms() {
			onlineFormsDataService.retrieveTerms(vm.route.sid, vm.applicationId).then(function(response) {
				if (response != null) {
					vm.terms = JSON.parse(response);
				}
			});
		}

		function updateAgreement(termsIndex) {
			if (vm.applicationId) {
				onlineFormsDataService.updateAgreement(angular.toJson(vm.terms[termsIndex]), vm.applicationId).then(function(response) {
					if (response != null) {
						vm.terms[termsIndex] = JSON.parse(response);
					}
				});
			}
		}

		function toTrusted(html) {
			return $sce.trustAsHtml(html);
		}

		function getGridColClass(columnSize) {
			if (columnSize == null || columnSize == 0 || !angular.isNumber(columnSize)) {
				return 'slds-small-size--1-of-1';
			} else {
				return 'slds-small-size--1-of-' + columnSize;
			}
		}

		function setupFields(route) {
			if (route == null || route.screen == null || route.screen.sections == null) {
				vm.route = route;
				return;
			}

			// Scan fields to assess available of address fields and create mappings
			for (var i = 0; i < route.screen.sections.length; i++) {
				var section = route.screen.sections[i];
				if (section.fieldSet == null || section.fieldSet.fields == null) {
					vm.route = route;
					continue;
				}
				var lineItems = helperService.addressFields[section.fieldSet.sObjectType];

				// Set mappings
				var hasPrimaryAddress = false;
				var hasSecondaryAddress = false;
				var fieldIndexMap = {};
				for (var j = 0; j < section.fieldSet.fields.length; j++) {
					var field = section.fieldSet.fields[j];

					// Map default values if a value is not populated
					if (field.value == null || field.value == '') {
						field.value = field.defaultValue;
					}

					// Convert date strings to JS dates
					if (field.type == FORM_CONSTANTS.DATE_TYPE) {
						// Dates are zeroed on the hours/minutes/second component so use the date as-is
						if (field.value) {
							field.value = helperService.parseISODate(field.value);
						}
					}
					else if (field.type == FORM_CONSTANTS.NUMBER_TYPE || field.type == FORM_CONSTANTS.DOUBLE_TYPE ||
						field.type == FORM_CONSTANTS.PERCENT_TYPE || field.type == FORM_CONSTANTS.CURRENCY_TYPE) {
						// Format number
						field.value = helperService.formatNumber(field.value);
					}

					// Build address mappings if this section contains address information
					if (lineItems) {
						fieldIndexMap[field.fieldPath] = j;
						if (lineItems.primary.indexOf(field.fieldPath) > -1) {
							hasPrimaryAddress = true;
						}
						else if (lineItems.secondary.indexOf(field.fieldPath) > -1) {
							hasSecondaryAddress = true;
							field.mapAddressTo = lineItems.primary[lineItems.secondary.indexOf(field.fieldPath)];
						}
					}
				}
				if (hasPrimaryAddress && hasSecondaryAddress) {
					section.fieldSet.hasAddresses = true;
					section.fieldSet.addressSameAs = true;

					// Set up watches to keep mapped fields in sync
					section.fieldSet.fields.forEach(function(watchingField) {
						var sectionIndex = i;
						if (!watchingField.mapAddressTo) {
							return;
						}
						if (section.fieldSet.addressSameAs && watchingField.value !=
							route.screen.sections[sectionIndex].fieldSet.fields[fieldIndexMap[watchingField.mapAddressTo]].value) {
							// Fields are not in sync
							section.fieldSet.addressSameAs = false;
						}
						$scope.$watch(function(scope) {
							if (vm.route && vm.route.screen && vm.route.screen.sections.length > sectionIndex &&
								vm.route.screen.sections[sectionIndex].fieldSet.fields) {
								return vm.route.screen.sections[sectionIndex].fieldSet
									.fields[fieldIndexMap[watchingField.mapAddressTo]].value;
							}
						},
						function(newValue, oldValue) {
							if (vm.route.screen && vm.route.screen.sections &&
								vm.route.screen.sections.length > sectionIndex &&
								vm.route.screen.sections[sectionIndex].fieldSet.addressSameAs
								&& newValue !== oldValue) {
								watchingField.value = newValue;
							}
						});
					});
				}
			}

			vm.route = route;
		}

		function syncAddresses(fieldSet) {
			var lineItems = helperService.addressFields[fieldSet.sObjectType];
			if (!lineItems) {
				return;
			}

			// Build lookup table for quick iteration
			var fieldIndexMap = {};
			for (var i = 0; i < fieldSet.fields.length; i++) {
				var field = fieldSet.fields[i];
				fieldIndexMap[field.fieldPath] = i;
				if (lineItems.secondary.indexOf(field.fieldPath) > -1) {
					field.mapAddressTo = lineItems.primary[lineItems.secondary.indexOf(field.fieldPath)];
				}
			}

			// Sync secondary fields with associated primary fields
			fieldSet.fields.forEach(function(watchingField) {
				if (!watchingField.mapAddressTo) {
					return;
				}
				watchingField.value = fieldSet.fields[fieldIndexMap[watchingField.mapAddressTo]].value;
			});
		}

		function retrieveReviewData() {
			if (vm.appName) {
				onlineFormsDataService.retrieveReviewData(vm.appName, vm.applicationId).then(function(response) {
					if (response != null) {
						vm.reviewRoutes = JSON.parse(response);
					}
				});
			}
		}

		function getRouteHref(route) {
			var appName = vm.appName.split('.')[0] + '.' + route.app;
			return helperService.updateQueryStringParameter(helperService.getURL(), 'app', appName);
		}

		function getReviewRouteFields(route) {
			var routeFields = [];
			if (route.screen !== null) {
				for (var i = 0; i < route.screen.sections.length; i++) {
					var sectionFields = helperService.applyFieldFormatting(route.screen.sections[i].fieldSet);
					for (var j = 0; j < sectionFields.length; j++) {
						var field = sectionFields[j];
						field.sObjectType = route.screen.sections[i].fieldSet.sObjectType;
						routeFields.push(field);
					}
				}
			}
			return routeFields;
		}

		function saveAndExit() {
			vm.onlineFormSubmitted = true;
			if (vm.formIsValid()) {
				var loaderID = helperService.showLoader(vm.label.Application_Save_Message);
				onlineFormsDataService.saveForm(angular.toJson(vm.route), vm.applicationId, vm.productId).then(function(response) {
					if (response.type && response.type === 'exception') {
						helperService.hideLoader(loaderID);
						helperService.showMessage(vm.label.Application_Save_Error, MESSAGE_CONSTANTS.TYPE_ERROR);
					}
					else {
						var application = JSON.parse(response);
						vm.applicationId = application.sid;
						for (var i = 0; i < vm.terms.length; i++) {
							vm.updateAgreement(i);
						}
						setTimeout(function() {
							vm.exitApplication(loaderID);
						}, 2000);
					}
				});
			}
		}

		function saveReview() {
			var loaderID = helperService.showLoader(vm.label.Application_Save_Message);
			setTimeout(function() {
				vm.exitApplication(loaderID);
			}, 2000);
		}

		function exitApplication(loaderID) {
			onlineFormsDataService.exitApplication(vm.applicationId).then(function(response) {
				if (response.type && response.type === 'exception') {
					helperService.hideLoader(loaderID);
					helperService.showMessage(vm.label.Application_Exit_Error, MESSAGE_CONSTANTS.TYPE_ERROR);
				}
				else {
					var exitInfo = JSON.parse(response);

					// Build the URL
					var url = exitInfo.sitePrefix + '/secur/logout.jsp?retUrl=' +
						exitInfo.sitePrefix + '/' + exitInfo.namespace + 'SaveForLater?email=' + exitInfo.userEmail;

					helperService.setWindowURL(url);
				}
			});
		}

		function skipForm() {
			var loaderID = helperService.showLoader();
			onlineFormsDataService.skipForm(angular.toJson(vm.route), vm.applicationId).then(function(response) {
				helperService.hideLoader(loaderID);
				if (response.type && response.type === 'exception') {
					helperService.showMessage(vm.label.Application_Skip_Error, MESSAGE_CONSTANTS.TYPE_ERROR);
				}
				else {
					applicationFactory.handleSaveEvent(JSON.parse(response));
				}
			});
		}

		function retrieveOthersInvolvedRoles() {
			onlineFormsDataService.retrieveOthersInvolvedRoles().then(function(response) {
				if (response.type && response.type == 'exception') {
					helperService.showMessage(vm.label.Others_Involved_Roles_Error, MESSAGE_CONSTANTS.TYPE_ERROR);
				}
				else {
					vm.connectionRoles = JSON.parse(response);
				}
			});
		}

		function addOther() {
			var other = {
				entityType: 'Individual',
				firstName: '',
				lastName: '',
				email: '',
				mobile: '',
				businessName: '',
				street: '',
				city: '',
				state: '',
				zip: '',
				connectionRole: '',
				borrowerType: ''
			};
			vm.othersInvolved.push(other);
			vm.onlineFormSubmitted = false;
		}

		function removeOther(index) {
			vm.othersInvolved.splice(index, 1);
			vm.onlineFormSubmitted = false;
		}

		function saveOthersInvolved() {
			vm.onlineFormSubmitted = true;
			if ($scope.onlineFormForm.$valid) {
				var loaderID = helperService.showLoader(vm.label.Application_Save_Message);
				var othersInvolvedData = '';
				if (vm.othersInvolved.length > 0) {
					othersInvolvedData = angular.toJson(vm.othersInvolved);
				}
				onlineFormsDataService.saveOthersInvolved(angular.toJson(vm.route),
					othersInvolvedData, vm.applicationId).then(function (response) {
					helperService.hideLoader(loaderID);
					if (response.type && response.type === 'exception') {
						helperService.hideLoader(loaderID);
						helperService.showMessage(vm.label.Others_Involved_Save_Error, MESSAGE_CONSTANTS.TYPE_ERROR);
					}
					else {
						applicationFactory.handleSaveEvent(JSON.parse(response));
					}
				});
			}
		}

		function retrieveOthersInvolved() {
			onlineFormsDataService.retrieveOthersInvolved(vm.applicationId).then(function (response) {
				if (response.type && response.type === 'exception') {
					helperService.showMessage(vm.label.Others_Involved_Retrieve_Error, MESSAGE_CONSTANTS.TYPE_ERROR);
				}
				else {
					vm.othersInvolved = JSON.parse(response);
				}
			});
		}

		function buildConnectionRoleField(roleId) {
			var field = {
				object: 'LLC_BI__Connection__c',
				fieldPath: 'LLC_BI__Connection_Role__c',
				value: roleId,
				lookupLabel: ''
			};
			return field;
		}

		function getOthersInvolvedRoute() {
			onlineFormsDataService.getOthersInvolvedRoute(vm.route.routeGroupId).then(function(response) {
				if (response.type && response.type === 'exception') {
					helperService.showMessage(vm.label.Others_Involved_Route_Error, MESSAGE_CONSTANTS.TYPE_ERROR);
				}
				else {
					vm.othersInvolvedRoute = JSON.parse(response);
				}
			});
		}

		function retrieveLookupOptions(sObjectType, field, fieldPath, lookupSearchText, loadSelection) {
			onlineFormsDataService.retrieveLookupOptions(sObjectType, fieldPath, lookupSearchText).then(function(response) {
				if (response.type && response.type === 'exception') {
					helperService.showMessage(vm.label.Application_Lookup_Error, MESSAGE_CONSTANTS.TYPE_ERROR);
				}
				else {
					field.lookupEntries = JSON.parse(response);
					if (!loadSelection) {
						return;
					}
					field.lookupEntries.forEach(function (entry) {
						// Truncate length of Id fields to 15 to evaluate equality since format can vary
						if ((field.type == FORM_CONSTANTS.ID_TYPE || field.type == FORM_CONSTANTS.LOOKUP_TYPE) &&
							entry.value && field.value && idValuesAreEqual(entry.value, field.value)) {
							field.lookupLabel = entry.label;
						}
						else if (entry.value == field.value) {
							field.lookupLabel = entry.label;
						}
					});
				}
			});
		}

		function validateLookupField(field) {
			// Nothing in input, ui will handle required validation
			if (!field.lookupLabel) {
				field.value = '';
				$scope.onlineFormForm[field.fieldPath].$setValidity('invalidLookup', true);
				return;
			}

			// Does the text entered match the text of a lookup entry
			var lookupEntry;
			if (field.lookupEntries.length != 0) {
				for (var i = 0; i < field.lookupEntries.length; i++) {
					if (field.lookupEntries[i].label == field.lookupLabel) {
						lookupEntry = field.lookupEntries[i];
						break;
					}
				}
			}

			if (lookupEntry) {
				// Mark field as valid and bind to model
				$scope.onlineFormForm[field.fieldPath].$setValidity('invalidLookup', true);
				field.value = lookupEntry.value;
			}
			else {
				// Mark field as invalid
				$scope.onlineFormForm[field.fieldPath].$setValidity('invalidLookup', false);
			}
		}

		function selectLookupEntry(field, entry) {
			field.value = entry.value;
			field.lookupLabel = entry.label;
			$scope.onlineFormForm[field.fieldPath].$setValidity('invalidLookup', true);
			vm.expandLookup(field, false);
		}

		function idValuesAreEqual(firstId, secondId) {
			return firstId.substring(0, 15) == secondId.substring(0, 15);
		}

		function expandLookup(field, isExpanded) {
			field.lookupExpanded = isExpanded;
		}

		function expandMultiPicklist(field, isExpanded) {
			field.lookupExpanded = isExpanded;
		}

		function selectMultiPicklistItem(field, selectedIndex) {
			var delim = ';';

			// Manage the semi-colon delimited list by transforming it into an array
			var selections = field.value ? field.value.split(delim) : [];
			var selectedItem = field.picklistEntries[selectedIndex];
			if (selections.indexOf(selectedItem.value) == -1) {
				selections.push(selectedItem.value);
			}
			else {
				selections.splice(selections.indexOf(selectedItem.value), 1);
			}

			field.value = selections.join(delim);
		}

		function printSelectedMultiPicklistItems(field) {
			return helperService.printSelectedMultiPicklistItems(field);
		}

		function isMultiPicklistItemSelected(field, picklistItem) {
			var delim = ';';
			var selections = field.value ? field.value.split(delim) : [];
			return selections.indexOf(picklistItem.value) !== -1;
		}

		function validateFormat(field) {
			if (!$scope.onlineFormForm[field.fieldPath]) {
				return true;
			}
			if (!$scope.onlineFormForm[field.fieldPath].$invalid) {
				field.isDirty = $scope.onlineFormForm[field.fieldPath].$dirty;
			}
			if (field.formatExpression && field.formatEnabled && !(field.isMaskedField && !field.isDirty)) {
				$scope.onlineFormForm[field.fieldPath].$invalid = !field.value.match(new RegExp(field.formatExpression));
				return !$scope.onlineFormForm[field.fieldPath].$invalid;
			}
			field.isDirty = $scope.onlineFormForm[field.fieldPath].$dirty;
			return true;
		}

		function clearIfMasked($event, field) {
			if (field.value && field.isMaskedField) {
				$event.target.value = '';
			}
		}

		function resetIfMasked($event, field) {
			if ($event.target.value == '' && !$scope.onlineFormForm[field.fieldPath].$dirty) {
				$event.target.value = $scope.onlineFormForm[field.fieldPath].$viewValue;
			}
		}

		function formIsValid() {
			if (vm.route == null || vm.route.screen == null || vm.route.screen.sections == null) {
				return true;
			}

			// Scan fields to validate formatting
			var errMsg = '';
			for (var i = 0; i < vm.route.screen.sections.length; i++) {
				var section = vm.route.screen.sections[i];
				if (section.fieldSet == null || section.fieldSet.fields == null) {
					continue;
				}
				for (var j = 0; j < section.fieldSet.fields.length; j++) {
					var field = section.fieldSet.fields[j];
					if (!vm.validateFormat(field)) {
						$scope.onlineFormForm.$valid = false;
						errMsg += (field.formatMessage || (field.altLabel || field.label)) + '<br />';
					}
				}
			}

			if (!$scope.onlineFormForm.$valid) {
				helperService.showMessage(vm.label.Application_Input_Error, MESSAGE_CONSTANTS.TYPE_WARNING, errMsg);
				return false;
			}
			return true;
		}

		function getIsContextComplete() {
			if (vm.applicationId) {
				onlineFormsDataService.getIsContextComplete(vm.applicationId).then(function(response) {
					if (response.type && response.type === 'exception') {
						console.log('An error occurred getting application context status.');
					}
					else {
						vm.isContextComplete = response;
					}
				});
			}
		}

		function getOnlineApplicationType() {
			if (vm.applicationId) {
				onlineFormsDataService.getOnlineApplicationType(vm.applicationId).then(function(response) {
					if (response.type && response.type === 'exception') {
						console.log('An error occurred getting Online Application type.');
					}
					else {
						vm.applicationType = response;
					}
				});
			}
		}

		function getProductName() {
			if (vm.applicationId) {
				onlineFormsDataService.getProductName(vm.applicationId).then(function(response) {
					if (response.type && response.type === 'exception') {
						console.log('An error occurred getting Product Name.');
					}
					else {
						vm.productName = response;
					}
				});
			}
		}

		function getCurrencySymbol() {
			onlineFormsDataService.getCurrencySymbol().then(function(response) {
				vm.currencySymbol = response;
			});
		}

		function getDateFormat() {
			onlineFormsDataService.getDateFormat().then(function(response) {
				vm.dateFormat = response;
			});
		}

		function editReviewItem(appName) {
			$rootScope.$broadcast(NAV_EVENTS.EDIT_REVIEW, {
				appName: appName
			});
		}

		function convertToLongDate(dateString) {
			return helperService.convertToLongDate(dateString);
		}

		function getIsGrandchildRoute() {
			var currentRoute = applicationFactory.getRouteByAppName(vm.appName.split('.')[1]);
			if (currentRoute.parentRouteId) {
				if (applicationFactory.routes[currentRoute.parentRouteId].parentRouteId) {
					return true;
				}
			}
			return false;
		}

		function redirectToParentRoute() {
			var currentRoute = applicationFactory.getRouteByAppName(vm.appName.split('.')[1]);
			if (currentRoute.parentRouteId) {
				var redirAppName =
					applicationFactory.buildAppName(applicationFactory.routes[currentRoute.parentRouteId].app);
				$location.path(redirAppName);
			}
		}

		function filterDate(dateString, format) {
			return helperService.filterDate(dateString, format);
		}

		function filterDatetime(dateString, format) {
			return helperService.filterDatetime(dateString, format);
		}
}]);

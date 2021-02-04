
angular.module('ruleEngineApp')
	.controller('RuleEngineRunController', ['$scope', '$location', 'dataService',
		function($scope, $location, dataService) {
		"use strict";
		var vm = this;
		vm.redirectURLQueryParams = {};
		vm.redirectURLQueryParamStr = null;
		vm.errors = null;
		vm.success = null;
		vm.location = $location;
		vm.runRule = runRule;
		vm.getContinueURL = getContinueURL;
		var INPUT_PREFIX = 're.input.';
		var OUTPUT_PREFIX = 're.output.';

		function errorHandler(error) {
			LifeCycle.unblockUI();
			vm.errors = [];
			vm.errors.push(error);
		}

		function getContinueURL(destinationURL) {
			if (vm.redirectURLQueryParamStr === null) {
				return destinationURL;
			}
			if (destinationURL.indexOf('?') < 0) {
				destinationURL += '?'
			}
			else {
				destinationURL += '&'
			}
			destinationURL += vm.redirectURLQueryParamStr;
			return destinationURL;
		}

		function getQueryParameterList(additionalQueryParameters) {
			var queryParamsList = [];
			if (vm.location.$$absUrl.indexOf('?') > 0) {
				queryParamsList = vm.location.$$absUrl.substring(vm.location.$$absUrl.indexOf('?')+1).split('&');
			}

			if (additionalQueryParameters !== null && additionalQueryParameters !== '') {
				var additionalParams = additionalQueryParameters.split('&');
				if (additionalParams.length > 0) {
					queryParamsList = queryParamsList.concat(additionalParams);
				}
			}
			return queryParamsList;
		}

		function addParameter(existing, key, value) {
			if (existing == null) {
				return key + '=' + value;
			}
			else {
				return existing + '&' + addParameter(null,key,value);
			}
		}

		function runRule(ruleName, additionalQueryParameters, copyInput, copyOutput) {
			var queryParamsList = getQueryParameterList(additionalQueryParameters);
			if (queryParamsList.length > 0) {
				var queryParamsMap = {};
				queryParamsList.forEach(function (param) {
					var tokens = param.split('=');
					if (tokens[0] !== 'app') {
						var content;
						try {
							content = JSON.parse(decodeURIComponent(tokens[1]));
						}
						catch(err) {
						    content = decodeURIComponent(tokens[1]);
						}

						vm.redirectURLQueryParams[tokens[0]]=content;
						if (tokens[0].indexOf(INPUT_PREFIX) == 0) {
							queryParamsMap[tokens[0].substring(9)] = content;
							if (copyInput) {
								vm.redirectURLQueryParamStr = addParameter(
									vm.redirectURLQueryParamStr,
									tokens[0],
									tokens[1]);
							}
						}
						else {
							vm.redirectURLQueryParamStr = addParameter(
								vm.redirectURLQueryParamStr,
								tokens[0],
								tokens[1]);
						}
					}
				});
			}

			LifeCycle.blockUI();
			dataService.executeRule(ruleName, queryParamsMap).then(
				function(response) {
					if (response.status === 'SUCCESS') {
						vm.success = true;
						if (copyOutput) {
							Object.keys(response.outputParameters).forEach(function (key) {
								vm.redirectURLQueryParamStr = addParameter(
									vm.redirectURLQueryParamStr,
									OUTPUT_PREFIX + key,
									response.outputParameters[key]);
							});
						}
					}
					else {
						vm.errors = response.errors;
					}
					LifeCycle.unblockUI();
				},
				errorHandler
			);
		}
}]);

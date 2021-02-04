(function(){
	"use strict";
	angular.module('app')
	.controller('expereComDocPrepQuestionsController', ['$scope', '$filter', '$rootScope', '$locale', '$q', 'ui', 'expereComPluginConstantsRemoting',
		function($scope, $filter, $rootScope, $locale, $q, ui, expereComPluginConstantsRemoting) {

        var vm = this;
        vm.init = init;
        vm.remoteGoNext = remoteGoNext;
        vm.remoteGoNextApp = remoteGoNextApp;
        vm.formatAnswerList = formatAnswerList;

        vm.pConstants = null;
        vm.tLogId = tLId;
        vm.entityId = eId;
        vm.pagePassed = pageIn;
        vm.init();

        function init(){
            expereComPluginConstantsRemoting.getPluginConstants()
                .then(function(result){
                    vm.pConstants = result;
                    buildDisplayStructure();
                });
        }

        function remoteGoNext(){
            ui.block();
            Visualforce.remoting.Manager.invokeAction(
                remoteString,
                vm.tLogId,
                vm.entityId,
                vm.formatAnswerList(),
                function(result, event){
                    if (event.status) {
                        window.location = result;
                    }
                },
                { escape: false }
            );
            return false;
        }

        function remoteGoNextApp(){
            ui.block();
            Visualforce.remoting.Manager.invokeAction(
                remoteString,
                vm.tLogId,
                vm.entityId,
                     vm.pagePassed,
                vm.formatAnswerList(),
                function(result, event){
                    if (event.status) {
                        window.location = result;
                    }
                },
                { escape: false }
            );
            return false;
        }

        function formatAnswerList(){
            var returnList = _.clone(vm.pConstants);

            angular.forEach(returnList, function(val){
                if(val.userInput != null){
                    val.value = _.invert(val.valueTranslationMap)[val.userInput];
                } else {
                    val.value = null;
                }
                delete val.userInput;
                delete val.displayList;
                delete val.valueTranslationMap;
            });

            return JSON.stringify(returnList);
        }

        function buildDisplayStructure(){
            angular.forEach(vm.pConstants, function(constant){
                var valueList = [];
                var translationList = [];
                constant.userInput = null;
                constant.apexType = "nFUSE.PluginConstants"

                constant.displayList = [];
                constant.valueTranslationMap = {};

                if(constant.value != null){
                    valueList = constant.value.split("|");
                }
                if(constant.translation != null){
                    translationList = constant.translation.split("|");
                } else {
                    translationList = constant.value.split("|");
                }

                for (var i = 0; i < valueList.length; i++){
                    if(translationList[i] == null){
                        constant.valueTranslationMap[valueList[i]] = null;
                        constant.displayList.push(valueList[i]);
                    } else {
                        constant.valueTranslationMap[valueList[i]] = translationList[i];
                        constant.displayList.push(translationList[i]);
                    }
                }

            });
        }

	}]).filter('range', function() {
            return function(input, min, max) {
                min = parseInt(min);
                max = parseInt(max);
                for (var i=min; i<=max; i++)
                    input.push(i);
                return input;
            };
        });
})();
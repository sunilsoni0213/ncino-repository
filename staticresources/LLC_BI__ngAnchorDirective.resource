(function(){
	'use strict';
	angular.module('app').directive('anchor', anchor);
	function anchor(){
		return {
			restrict: 'E',
			transclude: true,
			replace: true,
			scope: {
				anchor: '=?'
			},
			controller: function($scope){
				$scope.anchor = $scope.$parent.anchor;
			},
			template: '<a href="{{anchor.link}}" class="context full-width"><div class="slds {{anchor.background}} topbar-icon"><img class="slds {{anchor.background}} slds-icon" src="{{anchor.src}}"/></div>{{anchor.text}}</a>'
		};
	}
})();

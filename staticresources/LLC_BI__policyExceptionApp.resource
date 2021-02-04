(function() {
	var app = angular.module('policyExceptionApp', ['ngSanitize', 'ncFormElements', 'ncFilters', 'app']);
	app.run(function() {
		jQuery('.slds-modal__content form').attr('id', 'modalForm');
		jQuery('.slds-modal__content form').attr('name', 'modalForm');
	});
})();
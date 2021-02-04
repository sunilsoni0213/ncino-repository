(function() {
	var FieldSelector = function(data) {
		var self = this;
		self.data = {
			permissionMessage: null,
			hasPermission: false
		};
		_.extend(self.data, data);
		self.getMissingFields = function(apiData) {
			var toComplete = [],
				relationship = apiData.relationship,
				involvements = apiData.involvements ? apiData.involvements : null;
			if (!self.data.hasPermission) {
				toComplete.push(self.data.permissionMessage);
			}
			if (relationship == undefined || relationship == null) {
				toComplete.push(LifeCycle.msgs.msgs_relationship_loan);
			}
			if (involvements == undefined || involvements == null) {
				toComplete.push(LifeCycle.msgs.msgs_entity_loan);
			}
			return toComplete;
		};
		return self;
	};
	if(LifeCycle.DataServices.ClosingLoanReview.FieldSelector == undefined){
		LifeCycle.DataServices.ClosingLoanReview.FieldSelector = FieldSelector;
	}
})()
(function() {
	var FieldSelector = function() {
		var self = this;
		self.getMissingFields = function(apiData) {
			var toComplete = [],
				relationship = apiData.relationship,
				typeCode = typeof apiData.typeCode === 'function' ? apiData.typeCode() : null,
				paymentType = typeof apiData.paymentType === 'function' ? apiData.paymentType() : null;
				involvements = apiData.involvements ? apiData.involvements : null;

			if (relationship == undefined || relationship == null){
				toComplete.push(LifeCycle.msgs.msgs_relationship_loan);
			}
			if (typeCode == undefined || typeCode == null | typeCode == ""){
				toComplete.push(LifeCycle.msgs.msgs_loan_type_code);
			}
			if (paymentType == undefined || paymentType == null || paymentType == ""){
				toComplete.push(LifeCycle.msgs.msgs_payment_type);
			}

			if(involvements != null){
				_.each(involvements(), function(involvement){
					entityType = involvement.relationship.entityType;
					if (entityType == undefined || entityType == null ){
						toComplete.push(LifeCycle.msgs.msgs_relationship_type);
					} else if (entityType() == 'Partnership'
							|| entityType() == 'Corporation'
							|| entityType() == 'Trust'
							|| entityType() == 'Limited Liability Company'
							|| entityType() == 'Government'
							|| entityType() == 'Association'
							) {

						taxId = involvement.relationship.taxIdentificationNumber;
						if (taxId == undefined || taxId == null) {
							toComplete.push(LifeCycle.msgs.msgs_business_tax_id);
						}
					} else if (entityType() == 'Sole Proprietorship' || entityType() == 'Individual') {

						contact = involvement.relationship.primaryContact;
						if ((contact != undefined || contact != null)
							&& (contact.recordId != null || contact.recordId != undefined)) {

							ssn = involvement.relationship.primaryContact.ssn;
							if (ssn == undefined || ssn == null) {
								toComplete.push(LifeCycle.msgs.msgs_ssn);
							}
						}
					}
				});
			}
			return toComplete;
		};
		return self;
	};
	if(LifeCycle.DataServices.ClosingLoanReview.FieldSelector == undefined){
		LifeCycle.DataServices.ClosingLoanReview.FieldSelector = FieldSelector;
	}
})();
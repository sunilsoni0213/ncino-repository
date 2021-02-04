jQuery(function() {
	if(!LifeCycle.BorrowerTree.requestNewInvolvementRecords) {
		LifeCycle.BorrowerTree.requestNewInvolvementRecords = function(relationship, loan) {
			relationship.fireEntityTypeChange();
			if(!(relationship.involvements() && relationship.involvements().length &&
					!relationship.involvements()[relationship.involvements().length-1].recordId())){
					LifeCycle.BorrowerTree.loadRelationshipContacts(relationship);
					var record = window.borrowerTreeApp.objMapping['BORROWER']({});
					var raw = ko.mapping.toJS(record);
					LifeCycle.BorrowerTree.newRecord.apply(
							self,
							[raw,function(result, event) {
								var record = window.borrowerTreeApp.objMapping[
									LifeCycle.BorrowerTree.typeMap[result.apexType]](result);
								record.relationship = relationship;
								relationship.involvements.push(record);
								relationship.contacts.push(record.signers()[record.signers().length-1].contact);
								relationship.fireEntityTypeChange();
							} ]);
			}
		};
	}

	if(!LifeCycle.BorrowerTree.saveNewEntity) {
		LifeCycle.BorrowerTree.saveNewEntity = function(urlRedirect, objectType, relationship, loanRecord, package, data, event) {
			window.borrowerTreeApp.validate(relationship);
			var involvement = relationship.involvements()[relationship.involvements().length - 1];
			window.borrowerTreeApp.validate(involvement);

			// get the signer
			var signer = involvement.signers()[involvement.signers().length - 1];
			window.borrowerTreeApp.validate(signer);
			// get the contact
			var contacts = relationship.contacts().length? relationship.contacts() : [signer.contact];
			var contact = null;
			_.each(contacts, function(element, index,list){
				if(element.selected()){
					contact = element;
				}
			});
			if(contact == null){
				contact = contacts[contacts.length-1];
			}
			if(relationship.isIndividualComputed() || contact.selected()){
				window.borrowerTreeApp.validate(contact);
			}

			if(relationship.isIndividualComputed()){
				contact.isPrimaryContact(true);
			}

			var redirectAfterSave = function(app){
				if(urlRedirect == '' && typeof __karma__ == 'undefined') {
					window.location.reload();
				}
				else if (typeof __karma__ == 'undefined') {
					window.location = urlRedirect;
				}
				app.viewModel.clear();
			}

			LifeCycle.BorrowerTree.saveRecordProxy.apply(
					this,
					[relationship, window.borrowerTreeApp, function(relationship, app, record){
						contact.relationship = record;
						involvement.relationship = record;
						involvement.loan = loanRecord;
						if (loanRecord) {
							involvement.productPackage = loanRecord.productPackage;
						}
						else {
							involvement.productPackage = package;
						}
						LifeCycle.BorrowerTree.saveRecordProxy.apply(
								this,
								[involvement, app, function(involvement, app, record){
									signer.involvement = record;

									if (contact.firstName() != "" ||
										contact.lastName() != "" ||
										contact.ssn() != ""){
										LifeCycle.BorrowerTree.saveRecordProxy.apply(
											this,
											[contact, app, function(contact, app, record){
												signer.contact = record;

												if (contact.selected()){
													LifeCycle.BorrowerTree.saveRecordProxy.apply(
															this,
															[signer, app, function(signer, app, record){
																redirectAfterSave();
															}]);
												} else {
													redirectAfterSave();
												}

											}]);
									} else {
										redirectAfterSave(app);
									}
								}]);
					}]);
		}
	}

	if(!LifeCycle.BorrowerTree.loadRelationshipContacts){
		LifeCycle.BorrowerTree.loadRelationshipContacts = function(relationship){
			_.each(relationship.contacts(), function(element, index, list){
				if(!element.isLoaded() && element.recordId()){
						LifeCycle.BorrowerTree.retrieveIForce.apply(
							self,
							[element, element.recordId(), function(result, event, mergeObject){
								relationship.contacts()[index] =
									window.borrowerTreeApp.objMapping[LifeCycle.BorrowerTree.typeMap[result.apexType]](result);
							}]);
				}
			});
		};
	}
});
(function (app){
	ViewModel = function(type, canvasId){
		var self = this;
		self.canvasDivId = canvasId;
		self.recordType = type;
		self[type] = {};

		//
		// key: record id
		// value: record
		//
		self.OBJECTMAP = {};
		self.remoteCalls = [];
		self.ALLOBJECTS = [];
		self.SEARCHRESULTS = ko.observableArray([]);
		self.searched = ko.observable(false);
		self.searchType = ko.observable('NONE');

		self.retrieveRecord = function(objectId, objectType){
			var self = this;
			var record = window.borrowerTreeApp.objMapping[objectType]({
				recordId : objectId
			});
			self[self.recordType()][objectType] = ko.observable(record);

			LifeCycle.BorrowerTree.debug('INFO', 'retrieving ' + objectType + ' with id ' + objectId);

			LifeCycle.BorrowerTree.retrieveIForce.apply(
					self,
					[record, record.recordId(), function(result, event, mergeObject) {
							LifeCycle.BorrowerTree._extend(mergeObject, result);
							var record = window.borrowerTreeApp.objMapping[LifeCycle.BorrowerTree.typeMap[result.apexType]](result);
							self[self.recordType()][objectType](record);
					}]);
			return self;
		};
		self.createNewModel = function(model, data, event){
			this.clear();
			var t = LifeCycle.BorrowerTree.typeMap[model.apexType()];
			var record = app.objMapping[t]({});
			var raw = ko.mapping.toJS(record);
			LifeCycle.BorrowerTree.newRecord.apply(self, [raw, function(result, event){
				var record = app.objMapping[LifeCycle.BorrowerTree.typeMap[result.apexType]](result);
				self.selectedModel(record);
			}]);
		};
		self.selectedModel = ko.observable();
		self.selectModel = function(callback, allResults, data, event){
			self.selectedModel(null);
			data.selected(!data.selected());

			var b = data.selected();
			self.deselectAll(allResults());
			data.selected(b);

			if(data.selected()){
				self.selectedModel(data);
				callback(data);
			}
		};
		self.clear = function(){
			var self = this;
			self.SEARCHRESULTS.removeAll();
			self.selectedModel(null);
			self.searched(false);
			return self;
		};
		self.deselectAll = function(list){
			_.each(list, function(element, index, list){
				LifeCycle.BorrowerTree.debug('INFO', 'deselecting: ' + (element.recordId? element.recordId() : index));
				element.selected(false);
			});
			return self;
		};
		self.searchRecords = function(){
			var self = this;
			self.clear();

			var processed = self[self.recordType()];
			var raw = ko.mapping.toJS(self[self.recordType()]);

			app.performingAjax(true);
			LifeCycle.BorrowerTree.searchRecords.apply(self, [raw, function(result, event){

				if(!result || !result.length){
					self.searched(true);
					self.searchType('SIMILAR');
					app.performingAjax(false);
				}
				_.each(result, function(element, index, list){

					LifeCycle.BorrowerTree.debug('INFO', 'retrieving object');
					LifeCycle.BorrowerTree.debugObject('INFO', element);

					LifeCycle.BorrowerTree.retrieveIForce.apply(
							self,
							[element, element.recordId, function(result, event, mergeObject){
								LifeCycle.BorrowerTree._extend(mergeObject, result);
								self.searched(true);
								self.searchType('SIMILAR');
								self.SEARCHRESULTS.push(
										app.objMapping[LifeCycle.BorrowerTree.typeMap[result.apexType]](result));
							},
							null,
							{buffer: false}]);
				});

				self.SEARCHRESULTS.subscribe(function(value){
					if(value.length == result.length){
						app.performingAjax(false);
					}
				});

			}]);
		};
		self.searchRelationshipRecords = function(){
			var self = this;
			self.clear();
			var processed = self[self.recordType()];
			var raw = ko.mapping.toJS(self.RELATIONSHIP.LOAN().productPackage);
			app.performingAjax(true);
			LifeCycle.BorrowerTree.findDistinctRelationships.apply(self, [raw, function(result, event){

				if(!result || !result.length){
					self.searched(true);
					self.searchType('PACKAGE');
					app.performingAjax(false);
				}
				_.each(result, function(element, index, list){

					LifeCycle.BorrowerTree.debug('INFO', 'retrieving object');
					LifeCycle.BorrowerTree.debugObject('INFO', element);

					LifeCycle.BorrowerTree.retrieveIForce.apply(
						self,
						[element, element.recordId, function(result, event, mergeObject){
							LifeCycle.BorrowerTree._extend(mergeObject, result);
							self.searched(true);
							self.searchType('PACKAGE');
							self.SEARCHRESULTS.push(
								app.objMapping[LifeCycle.BorrowerTree.typeMap[result.apexType]](result));
						},
						null,
						{buffer: false}]);
				});

				self.SEARCHRESULTS.subscribe(function(value){
					if(value.length == result.length){
						app.performingAjax(false);
					}
				});
			}]);
		};
		self.getInflatedObjects = function(objs){
			LifeCycle.BorrowerTree.debug('INFO', 'retrieving inflated objects input');
			LifeCycle.BorrowerTree.debugObject('INFO', objs);

			var toRet = [];
			_.each(objs, function(element, index, list){
				toRet.push(self.getInflatedObject(element.recordId()));
			});

			LifeCycle.BorrowerTree.debug('INFO', 'retrieving inflated objects output');
			LifeCycle.BorrowerTree.debugObject('INFO', toRet);

			return toRet;
		};
		self.getInflatedObject = function(recordId){
			return self.OBJECTMAP[recordId];
		};
		self.interrogateParentObjAndRetrieve = function(parentObj, result){

			LifeCycle.BorrowerTree.debug('INFO', 'interrogateParentObjAndRetrieve object');
			LifeCycle.BorrowerTree.debugObject('INFO', parentObj);

			var toReturn = true;
			_.each(result, function(value, key, object){
				LifeCycle.BorrowerTree.debug('INFO', 'interrogateParentObjAndRetrieve KEY: ' + key);
				if('ISLOADED' == key.toUpperCase()){
					if(value == false){
						// peek into the cache for the object
						if(self.OBJECTMAP[object.recordId] != null){
							LifeCycle.BorrowerTree.debug('INFO', 'found cached object: ' + object.recordId);
							object[key] = true;
						}
						else{
							//if(object.recordId != null && object.recordId.length > 0)
							{
								return self.recurseChainRetrieve(
										parentObj,
										object.recordId,
										LifeCycle.BorrowerTree.typeMap[object.apexType]);
							}
						}
					}
					else if(!self.OBJECTMAP[object.recordId]){

						var rawData = ko.mapping.toJS(object);
						var mappedObj =
							app.objMapping[LifeCycle.BorrowerTree.typeMap[rawData.apexType]](rawData);

						// cache object
						self.OBJECTMAP[object.recordId] = mappedObj;

						self.ALLOBJECTS.push(mappedObj);
						LifeCycle.BorrowerTree.debug('INFO', 'caching object: ' + object.recordId);
					}
					}
				});
			return toReturn;
		};
		self.recurseChainRetrieve = function(objToMergeInto, recId, type){
			LifeCycle.BorrowerTree.debug('INFO', 'recurseChainRetrieve: recordId: ['+recId+'] type: ['+type+']');

			var remoteCall = LifeCycle.BorrowerTree.getCall(type);
			LifeCycle.BorrowerTree.debug('INFO', 'recurseChainRetrieve: remoteCall found: ['+ remoteCall != null +']');

			self.remoteCalls.push({});
			remoteCall.apply(self, [objToMergeInto, recId, function(result, event, mergeObject){
				try{
					LifeCycle.BorrowerTree._extend(mergeObject, result);

					//
					// TODO: map as we go as opposed to mapping and binding only at the end
					//
					/*
					ko.mapping.fromJS(
							self,
							app.contextMapping[self.recordType],
							app.viewModel);
					*/

					LifeCycle.BorrowerTree.debug('INFO', 'merge object: ');
					LifeCycle.BorrowerTree.debugObject('INFO', mergeObject)

					self.interrogateParentObjAndRetrieve.apply(self, [mergeObject, result]);

					LifeCycle.BorrowerTree.debug('INFO', 'apex type: ' + LifeCycle.BorrowerTree.typeMap[result.apexType]);

					switch(LifeCycle.BorrowerTree.typeMap[result.apexType]){
						case 'LOAN':
							if(result.relationship){
								self.interrogateParentObjAndRetrieve.apply(self, [mergeObject.relationship, result.relationship]);
							}
							if(result.borrowers){
								_.each(result.borrowers, function(element, index, list){
									self.interrogateParentObjAndRetrieve.apply(self, [mergeObject.borrowers[index], element]);
								});
							}
							if(result.guarantors){
								_.each(result.guarantors, function(element, index, list){
									self.interrogateParentObjAndRetrieve.apply(self, [mergeObject.guarantors[index], element]);
								});
							}
							break;
						case 'RELATIONSHIP':
							if(result.parent){
								self.interrogateParentObjAndRetrieve.apply(self, [mergeObject.parent, result.parent]);
							}
							/*if(result.loans){
								_.each(result.loans, function(element, index, list){
									self.interrogateParentObjAndRetrieve.apply(self, [mergeObject.loans[index], element]);
								});
							}*/
							if(result.contacts){
								_.each(result.contacts, function(element, index, list){
									self.interrogateParentObjAndRetrieve.apply(self, [mergeObject.contacts[index], element]);
								});
							}

							/*if(result.involvements){
								_.each(result.involvements, function(element, index, list){
									self.interrogateParentObjAndRetrieve.apply(self, [mergeObject.involvements[index], element]);
								});
							}*/
							break;
						case 'BORROWER':
						case 'GUARANTOR':
							/*if(result.loan){
								self.interrogateParentObjAndRetrieve.apply(self, [mergeObject.loan, result.loan]);
							}*/
							if(result.relationship){
								self.interrogateParentObjAndRetrieve.apply(self, [mergeObject.relationship, result.relationship]);
							}
							if(result.signers){
								_.each(result.signers, function(element, index, list){
									self.interrogateParentObjAndRetrieve.apply(self, [mergeObject.signers[index], element]);
								});
							}
							break;
						case 'SIGNER':
							if(result.contact){
								self.interrogateParentObjAndRetrieve.apply(self, [mergeObject.contact, result.contact]);
							}

							if(result.involvement){
								self.interrogateParentObjAndRetrieve.apply(self, [mergeObject.involvement, result.involvement]);
							}
							break;
						case 'CONTACT':
							if(result.relationship){
								self.interrogateParentObjAndRetrieve.apply(self, [mergeObject.relationship, result.relationship]);
							}
							if(result.signings){
								_.each(result.signings, function(element, index, list){
									self.interrogateParentObjAndRetrieve.apply(self, [mergeObject.signings[index], element]);
								});
							}
							break;
					}
				}
				finally{
					self.remoteCalls.splice(self.remoteCalls.length-1, 1);
					if(self.remoteCalls.length == 0){
						LifeCycle.BorrowerTree.debug('INFO', 'DONE WITH OBJECT');
						LifeCycle.BorrowerTree.debugObject('INFO', self);
						//
						// TODO: map as we go as opposed to mapping and binding only at the end
						//

						ko.mapping.fromJS(
								self,
								app.contextMapping,
								app.viewModel);

						//ko.applyBindings(ko.validatedObservable(app.viewModel));

						jQuery(function(){
							app.view = new app.View(app.viewModel).render();
						})
					}
				}
			}]);
		};
		self.getPrimaryContactForRelationship = function(account){
			var inflatedAccount = self.getInflatedObject(account.recordId()) || account;
			var contacts = inflatedAccount.contacts();
			var primaryContact = null;
			_.each(contacts, function(element, index, list){
				var inflatedContact = self.getInflatedObject(element.recordId()) || element;

				if(inflatedContact.isPrimaryContact() || primaryContact == null){
					primaryContact = inflatedContact;
				}
			});
			if(primaryContact == null){
				primaryContact = new Contact({});
			}
			return primaryContact;
		};


		return self;
	};
	app.ViewModel = ViewModel;
})(window.borrowerTreeApp);
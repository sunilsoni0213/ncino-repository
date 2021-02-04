(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(serverData){
			var self = this;
			self.app = app;
			var defaultData = {
				isLoaded: false,
				isSaving: false,
				isLoan: false,
				nextEvalDateRequired: true,
				involvements: [],
				relationship: {},
				selectedRelationship: undefined,
				covenants: [],
				selectedCovenant: '',
				addCovenantModalOpen: false,
				addExistingCovenantModalOpen: false,
				covenantTypeCategoryOptions: [],
				covenantFrequencyLabelOptions: [],
				categoriesWithIsFinancialIndicator: [],
				covenantFrequencyLabelToValueMap: {},
				covenantFrequencyValueToLabelMap: {},
				covenantFrequencyOptions: [],
				covenantTypes: [],
				errorMsg: '',
				operatorOptions: [],
				statementsLoading: false,
				complianceDaysPriorOptions: '',
				newFICovenantChild: false,
				filteredFICovenants: {}
		};
			if(serverData != undefined){
				_.extend(defaultData, serverData);
			}

			app.mapFromJS(defaultData, app.getMapping(), self);

			self.showingPanelOn = ko.observable();

			function getCategoryFromCovenant(covenant) {
				var category = '';
				if (_.isFunction(covenant.category)) {
					var covenantCategory = covenant.category();
					if (covenantCategory) {
						category = covenantCategory;
					}
				}
				return category;
			}

			self.isSaveEnabled = ko.computed(function() {
				var covenant = self.selectedCovenant();
				if (self.isSaving()) {
					return false;
				}

				if (covenant) {
					var category = getCategoryFromCovenant(covenant);

					if (!category) {
						return false;
					}

					if (!covenant.covenantType) {
						return false;
					}

					if (ko.unwrap(self.nextEvalDateRequired) && !covenant.nextEvalDate()) {
						return false;
					}

					if (category == LifeCycle.msgs.msg_financial_statement_requirements) {
						if (!covenant.effectiveDate()) {
							return false;
						}
					}

					return true;
				}
				return false;
			});

			self.filteredCovenants = ko.computed(function() {
				if(_.isUndefined(self.selectedRelationship())) {
					return self.covenants();
				} else {
					var toRet = [];
					_.each(self.covenants(), function(covenant) {
						_.each(covenant.accountCovenants(), function(accountCovenant) {
							if (!_.isEmpty(accountCovenant.account) && accountCovenant.account.recordId() == self.selectedRelationship().recordId()) {
								if(toRet.indexOf(covenant) < 0) {
									toRet.push(covenant);
								}
							}
						});
					});
					return toRet;
				}
			});

			self.fsrCovenants = ko.computed(function() {
				return ko.utils.arrayFilter(self.filteredCovenants(), function(covenant) {
					return covenant.covenantType.category() == LifeCycle.msgs.msg_financial_statement_requirements;
				});
			});

			self.fiCovenants = ko.computed(function() {
				return ko.utils.arrayFilter(self.categoriesWithIsFinancialIndicator(), function(fiCategory) {
					return fiCategory.isFinancialIndicator()
						|| fiCategory.categoryName() == LifeCycle.msgs.msg_financial_indicators;
				});
			});

			self.filteredCovenantTypes = ko.computed(function() {
				if (_.isFunction(self.selectedCovenant().category)) {
					return ko.utils.arrayFilter(self.covenantTypes(), function(covenantType) {
						return covenantType.category() == self.selectedCovenant().category();
					});
				} else {
					return [];
				}
			});

			self.selectedRelationship.subscribe(function(selectedRelationship) {
				if (!_.isUndefined(selectedRelationship)) {
					if(self.isLoan()) {
						if (!_.isUndefined(selectedRelationship.bundle())) {
							LifeCycle.SpreadData.getEntireBundle(selectedRelationship.bundle().recordId());
						}
						LifeCycle.CovenantManager.getAccountCovenants(
							selectedRelationship.recordId(),
							self.contextObject.recordId(),
							function(result){
								if (result != null) {
									var data = {
										covenants: result
									};
									app.mapFromJS(data, app.getMapping(), selectedRelationship);
								}
							},
							app.log.failure);
					}

				}
			});

			self.addNewCovenant = function(covenant) {
				self.newFICovenantChild(false);
				self.selectedCovenant(new app.Covenant({}));
				if (!_.isUndefined(covenant.apexType)) {
					self.selectedCovenant().relatedCovenant(covenant);
					self.selectedCovenant().isFinancialIndicator(true);
					self.selectedCovenant().frequencyLabel(covenant.frequencyLabel());
					self.selectedCovenant().frequency(covenant.frequency());
					self.newFICovenantChild(true);
				}
				self.errorMsg(null);
				self.addCovenantModalOpen(true);
			};

			self.addExistingCovenant = function() {
				if (self.selectedRelationship().covenants().length > 0) {
					self.errorMsg(null);
					self.addExistingCovenantModalOpen(true);
				}
			};

			var pushCovenant = function(covenant, covenantIds) {
				covenant.frequencyLabel = self.covenantFrequencyValueToLabelMap[ko.unwrap(covenant.frequency)];
				covenantIds.push(covenant.recordId());
				var relatedCovenants = covenant.relatedCovenants();
				if (relatedCovenants && relatedCovenants.length > 0) {
					_.each(relatedCovenants, function(relatedCovenant) {
						pushCovenant(relatedCovenant, covenantIds);
					});
				}
			};

			self.applyExistingCovenants = function(covenant) {
				var covenantIds = [];
				_.each(self.selectedRelationship().covenants(), function(covenant) {
					if (covenant.selected()) {
						pushCovenant(covenant, covenantIds);
					}
				});
				LifeCycle.CovenantManager.createLoanCovenants(
					self.contextObject.recordId(),
					covenantIds,
					function(result, event){
						var selectedCovenants = [];
						_.each(self.selectedRelationship().covenants(), function(covenant) {
							if (covenant.selected()) {
								self.covenants.push(covenant);
								selectedCovenants.push(covenant);
							}
						});
						_.each(selectedCovenants, function(covenant) {
							self.selectedRelationship().covenants.remove(covenant);
						});
						self.errorMsg(null);
						self.addExistingCovenantModalOpen(false);
					},
					function(result, event){
						self.errorMsg(self.handleValidationError(covenant, event.message));
					});
			};

			self.handleValidationError = function(covenant, error){
				if(covenant.frequency){
					covenant.frequencyLabel(self.covenantFrequencyValueToLabelMap[covenant.frequency()]);
				}

				if(error.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION') != -1){
					return error.substring(error.indexOf(',')+2, error.length - 4);
				} else {
					return error.toString();
				}
			};

			self.editPerformanceRules = function(covenant) {
				covenant.showPanel(!covenant.showPanel());
				if (covenant.showPanel()) {
					if (self.showingPanelOn() != covenant && self.showingPanelOn()) {
						if (self.showingPanelOn().editingRelatedSpreadRecord()) {
							self.showingPanelOn().cancelEditRelatedSpreadRecord();
						}
						self.showingPanelOn().showPanel(false);
					}
					if (LifeCycle.SpreadData) {
						if ((!_.isNull(covenant.linkedSpreadStatementRecord())
							|| !_.isNull(covenant.linkedSpreadStatementRecordTotal()))
							&& _.isUndefined(covenant.selectedStatement())) {
							self.statementsLoading(true);
							if (!_.isNull(covenant.linkedSpreadStatementRecord())) {
								LifeCycle.SpreadData.getIForceById(
									covenant.linkedSpreadStatementRecord().recordId(),
									undefined,
									function (record) {
										covenant.selectedRecord(record);
										covenant.selectedRecordTotal(record.recordTotal);
										covenant.selectedStatement(record.statement);
										self.statementsLoading(false);
									}
								);
							} else if (!_.isNull(covenant.linkedSpreadStatementRecordTotal())) {
								LifeCycle.SpreadData.getEntireStatement(
									covenant.linkedSpreadStatementRecordTotal().statement.recordId(),
									{},
									function () {
										LifeCycle.SpreadData.getIForceById(
											covenant.linkedSpreadStatementRecordTotal().recordId(),
											undefined,
											function (recordTotal) {
												covenant.selectedRecordTotal(recordTotal);
												covenant.selectedStatement(recordTotal.statement);
												self.statementsLoading(false);
											}
										);

									}
								);
							}
						}
					}
					self.showingPanelOn(covenant);
				} else {
					self.showingPanelOn(undefined);
				}
			};

			self.load = function(callback){
				LifeCycle.blockUI();
				LifeCycle.CovenantManager.loadCovenantManagerContainer(
					self.contextObject.recordId(),
					function(result) {
						app.mapFromJS(result, app.getMapping(), self);

						if(self.covenantFrequencyValueToLabelMap != undefined &&
							self.covenantFrequencyValueToLabelMap != null) {
							_.each(self.covenants(), function (cov) {
								cov.frequencyLabel(self.covenantFrequencyValueToLabelMap[cov.frequency()]);
								_.each(cov.relatedCovenants(), function (relCov) {
									relCov.frequencyLabel(self.covenantFrequencyValueToLabelMap[cov.frequency()]);
								});
							});
						}
						self.isLoaded(true);
						if (!self.isLoan()) {
							self.selectedRelationship(self.relationship);
							if (LifeCycle.SpreadData) {
								LifeCycle.SpreadData.getAllBundlesForContextObject(
									_18Id(self.selectedRelationship().recordId()),
									{},
									function (bundles) {
										if (bundles.length > 0) {
											self.selectedRelationship().bundle(bundles[0]);
											LifeCycle.SpreadData.getEntireBundle(bundles[0].recordId());
										}
									}
								);
							}
						} else if (LifeCycle.SpreadData) {
							LifeCycle.SpreadData.getAllBundlesForContextObject(
								_18Id(self.contextObject.recordId()),
								{},
								function (bundles) {
									_.each(bundles, function (bundle) {
										_.each(self.involvements(), function (involvement) {
											if (involvement.relationship.recordId() == bundle.container.recordId()) {
												involvement.relationship.bundle(bundle);
											}
										});
									});
								}
							);
						}
						self.complianceDaysPriorOptions(
							_getDependentOptions(
								self.namespace() + '__Covenant2__c',
								self.namespace() + '__Frequency__c',
								self.namespace() + '__Compliance_Days_Prior__c'));
						LifeCycle.unblockUI();
						callback.apply();
					},
					app.log.failure);
			};

			self.updateRelatedRecord = function(covenant) {
				covenant.__cached = true;
				LifeCycle.LiteForceService.saveIForce(
					app.mapToJS(covenant, { maxDepth: 0 }),
					function(result) {
						app.mapFromJS(result[0], app.getMapping(), covenant);
						covenant.editingRelatedSpreadRecord(false);
					});
			};

			ko.bindingHandlers.covenantDate = {
				update: function(element, valueAccessor, allBindingsAccessor) {
					var value = ko.utils.unwrapObservable(valueAccessor());

					if(value != null) {
						if(typeof(value) === 'string') {
							ko.bindingHandlers.text.update(element, function() { return value; });
						} else {
							var parsedDate = new Date(parseInt(value));
							parsedDate = new Date(parsedDate.getTime() + (parsedDate.getTimezoneOffset() * 60 * 1000) );
							ko.bindingHandlers.text.update(element, function() {
								return window.LifeCycle.Internationalize.format(parsedDate, 'd')
							});
						}
					}
				}
			};

			var dateToYMDString = function(date) {
				var d = new Date(date),
				month = '' + (d.getMonth() + 1),
				day = '' + d.getDate(),
				year = d.getFullYear();

				if (month.length < 2) {
					month = '0' + month;
				}
				if (day.length < 2) {
					day = '0' + day;
				}

				return [year, month, day].join('-');
			};

			var _saveCovenant = function(accountId, loanId, covenant, callback) {

				if (covenant.relatedCovenant()) {
					covenant.frequency(ko.unwrap(covenant.relatedCovenant().frequency));
					covenant.frequencyLabel(ko.unwrap(covenant.relatedCovenant().frequencyLabel));
				}

				if (covenant.frequencyLabel() && self.complianceDaysPriorOptions()) {
					covenant.complianceDaysPrior(self.complianceDaysPriorOptions()[ko.unwrap(covenant.frequencyLabel())][0]);
				}
				var freqLabel = '';
				if (covenant.frequencyLabel != undefined &&
					covenant.frequencyLabel != null &&
					self.covenantFrequencyLabelToValueMap != undefined &&
					self.covenantFrequencyLabelToValueMap != null) {
						if (ko.isObservable(ko.unwrap(covenant.frequencyLabel))) {
							freqLabel = covenant.frequencyLabel()._latestValue;
						} else {
							freqLabel = ko.unwrap(covenant.frequencyLabel);
						}
						covenant.frequency(self.covenantFrequencyLabelToValueMap[freqLabel]);
				}

				var d = covenant.nextEvalDate();
				if (d) {
					covenant.nextEvalDate(dateToYMDString(d));
				}

				d = covenant.effectiveDate();
				if (d) {
					covenant.effectiveDate(dateToYMDString(d));
				}

				if (covenant.relatedCovenant()) {
					covenant.relatedCovenant = ko.observable(new app.Covenant({
						recordId: covenant.relatedCovenant().recordId(),
						nextEvalDate: covenant.relatedCovenant().nextEvalDate(),
						frequency: covenant.relatedCovenant().frequency()
					}));
				}
				if (!self.isLoan()) {
					covenant.isActive(true);
				}
				LifeCycle.LiteForceService.saveIForce(
					app.mapToJS(covenant),
					function (result) {
						var loan,
							account,
							accountCovenant,
							loanCovenant;
						var objectsToSave = [];
						app.mapFromJS(result, app.getMapping(), self.selectedCovenant);

						if(self.isLoan() && loanId){
							loan = new app.Loan({recordId: loanId});
							loanCovenant = new  app.LoanCovenant({ loan: loan, covenant: self.selectedCovenant});
							objectsToSave.push(loanCovenant);
						}
						account = new app.Relationship({recordId: accountId});
						accountCovenant = new app.AccountCovenant({account: account, covenant: self.selectedCovenant});
						objectsToSave.push(accountCovenant);

						LifeCycle.LiteForceService.saveIForces(app.mapToJS(objectsToSave),function (results) {
							results = app.mapFromJS(results);
							var resultingAccountCovenant = ko.utils.arrayFilter(results(), function(result){return accountCovenant.apexType() == result.apexType();})[0];
							resultingAccountCovenant.account = account;
							self.selectedCovenant().accountCovenants().push(resultingAccountCovenant);

							if(_.isUndefined(self.selectedCovenant().relatedCovenant())) {
								self.selectedCovenant().frequencyLabel = ko.observable(freqLabel);
								self.covenants.push(self.selectedCovenant());
							} else {
								ko.utils.arrayFilter(self.covenants(), function(covenant) {
									return covenant.recordId() == self.selectedCovenant().relatedCovenant().recordId();
								})[0].relatedCovenants.push(new app.Covenant(app.mapToJS(self.selectedCovenant())));
							}
							callback.apply();
							self.errorMsg(null);
						},
							function(result, event){
								self.errorMsg(self.handleValidationError(covenant, event.message));
							}
						);

					},
					function(result, event){
						self.errorMsg(self.handleValidationError(covenant, event.message));
					}
				);
			};

			self.saveCovenant = function(covenant) {
				self.isSaving(true);
				_saveCovenant(
					self.selectedRelationship().recordId(),
					self.isLoan() ? self.contextObject.recordId() : null,
					self.selectedCovenant(),
					function() {
						self.errorMsg(null);
						self.addCovenantModalOpen(false);
						self.isSaving(false);
					});
			};

			self.saveCovenantAndNew = function(covenant) {
				self.isSaving(true);
				_saveCovenant(
					self.selectedRelationship().recordId(),
					self.isLoan() ? self.contextObject.recordId() : null,
					self.selectedCovenant(),
					function() {
						self.selectedCovenant(new app.Covenant({}));
						self.isSaving(false);
					});
			};

			self.deleteCovenant = function(covenant){
				//TODO: Delete
			};

			self.isFinancialIndicatorCategory = function() {
				if (!_.isUndefined(self.selectedCovenant().category())) {
					var categoryWithFI = ko.utils.arrayFirst(self.categoriesWithIsFinancialIndicator(),
						function(category) {
							return category.categoryName() == self.selectedCovenant().category();
						});

					if (categoryWithFI !== null &&
						(categoryWithFI.isFinancialIndicator() || categoryWithFI.categoryName() == LifeCycle.msgs.msg_financial_indicators)) {
						return true;
					}
					return false;
				}
			};

			var _getDependentOptions = function(objName, ctrlFieldName, depFieldName) {
				// Isolate the Describe info for the relevant fields
				var objDesc = sforce.connection.describeSObject(objName);
				var ctrlFieldDesc, depFieldDesc;
				var found = 0;
				if (objDesc) {
					for (var i=0; i<objDesc.fields.length; i++) {
						var f = objDesc.fields[i];
						if (f.name == ctrlFieldName) {
							ctrlFieldDesc = f;
							found++;
						} else if (f.name == depFieldName) {
							depFieldDesc = f;
							found++;
						}
						if (found==2) break;
					}

					// Set up return object
					var dependentOptions = {};
					var ctrlValues = ctrlFieldDesc.picklistValues;
					for (var i=0; i<ctrlValues.length; i++) {
						dependentOptions[ctrlValues[i].label] = [];
					}

					var base64 = new sforce.Base64Binary("");
					function testBit (validFor, pos) {
						var byteToCheck = Math.floor(pos/8);
						var bit = 7 - (pos % 8);
						return ((Math.pow(2, bit) & validFor.charCodeAt(byteToCheck)) >> bit) == 1;
					}

					// For each dependent value, check whether it is valid for each controlling value
					var depValues = depFieldDesc.picklistValues;
					for (var i=0; i<depValues.length; i++) {
						var thisOption = depValues[i];
						var validForDec = base64.decode(thisOption.validFor);
						for (var ctrlValue=0; ctrlValue<ctrlValues.length; ctrlValue++) {
							if (testBit(validForDec, ctrlValue)) {
								dependentOptions[ctrlValues[ctrlValue].label].push(thisOption.label);
							}
						}
					}
					return dependentOptions;
				}
			};

			return self;
		};
		app.log('ViewModel initialized.');
	};
	if(LifeCycle.Covenant_Manager.ViewModel == undefined){
		LifeCycle.Covenant_Manager.ViewModel = ViewModel;
	}
})();

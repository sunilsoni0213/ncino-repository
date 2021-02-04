(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			self.app = app;
			self.statementType = ko.observable();
			self.relationshipName = ko.observable(); // relationship of involvement, not loan
			self.relationshipType = ko.observable(); // relationship of involvement, not loan
			self.borrowerType = ko.observable();

			var defaultData = {
				spread: {},
				aiYears: ko.observableArray([]),
				globalAnalysisLabel: ko.observable()
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.statementTypeWithYearsLabel = ko.computed({
				read: function(){
					if (self.statementType() != null &&
						self.aiYears().length > 0){
						return self.formatDetails(
							self.statementType(),
							self.aiYears().sort().join(', '));
					} else {
						return self.statementType();
					}
				}, deferEvaluation: true
			});

			self.relationshipNameWithTypeLabel = ko.computed({
				read: function(){
					if (self.statementType() != null &&
						self.statementType() != self.globalAnalysisLabel() &&
						self.relationshipName() != null &&
						self.relationshipType() != null){
						return self.formatDetails(
							self.relationshipName(),
							self.relationshipType());
					} else if (self.statementType() != null &&
						self.statementType() != self.globalAnalysisLabel() &&
						self.relationshipName() != null){
						return self.relationshipName();
					} else {
						return '';
					}
				}, deferEvaluation: true
			});

			self.borrowerTypeLabel = ko.computed({
				read: function(){
					if (self.statementType() != null &&
						self.statementType() != self.globalAnalysisLabel() &&
						self.borrowerType() != null){
						return self.borrowerType();
					} else {
						return '';
					}
				}, deferEvaluation: true
			});

			self.setYears = function(aiYears){
				self.aiYears.removeAll();
				for (var i = 0; i < aiYears.length; i++){
					self.aiYears.push(aiYears[i]);
				}
			}

			self.formatDetails = function(first, second){
				if (second != null){
					return first + ' (' + second + ')';
				} else {
					return first;
				}
			}

			self.retrieve = function(data, success){
				if(!data.isLoaded()){
					LifeCycle.SpreadsService.retrieveIForce(
							{},
							data.recordId(),
							function(result, event){
								app.mapFromJS(result, app.getMapping(), data);
								if(success != undefined){
									success.apply(this, [result, event, data]);
								}
							},
							app.log.failure);
				}else{
					success.apply(this, [{}, {}, data]);
				}
			};
			self.retrieveRelationship = function(data, success){
				if(!data.isLoaded){
					LifeCycle.BorrowerTree.retrieveRelationship(
							{},
							data.recordId,
							function(result, event){
								app.mapFromJS(result, app.getMapping(), data);
								if(success != undefined){
									success.apply(this, [result, event, data]);
								}
							},
							app.log.failure);
				}else{
					success.apply(this, [{}, {}, data]);
				}
			};

			self.loadSpread = function(spread){
				if(!_.isEmpty(spread.recordId())){
					self.retrieve(
						self.spread,
						function(result, event, spread){
							if(spread.recordId() == self.spread.recordId()){
								self.spread = spread;

								self.retrieve(
									self.spread.statement,
									function(result, event){
										self.statementType(result.statementType);
										if (self.statementType() != undefined &&
											self.statementType() != self.globalAnalysisLabel()){

											self.retrieve(
												self.spread.involvement,
												function(result, event){
													if (result != null){
														self.borrowerType(result.borrowerType);
													}
													if(!_.isEmpty(result.relationship)){

														self.retrieveRelationship(
															result.relationship,
															function(result, event){
																if (result != null){
																	if(!_.isEmpty(result.name)){
																		self.relationshipName(result.name);
																	}
																	if(!_.isEmpty(result.entityType)){
																		self.relationshipType(result.entityType);
																	}
																}
														});
													}
											});
										}
								});
							}
						});
				}
			};

			self.load = function(){
				try{
					if(_.isEmpty(self.spread.recordId())){
						throw new Error(LifeCycle.msgs.msg_spread_printing_required_data);
					}
					self.loadSpread(self.spread);
				}catch(e){
					Utils.blockUI();
					app.log.failure(null, e);
				}
			};
			app.log('Spread_Printing ViewModel instantiated.');
			return self;
		}
		app.log('Spread_Printing ViewModel initialized.');
	};
	if(LifeCycle.Spread_Printing.ViewModel == undefined){
		LifeCycle.Spread_Printing.ViewModel = ViewModel;
	}
})();
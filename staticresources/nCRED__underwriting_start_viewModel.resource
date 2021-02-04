(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			var defaultData = {
				bundle: {},
				bundles: [],
				isEditable: false,
				involvement: {},
				loan: {},
				relationship: {},
				searchCriteria: {},
				searched: false,
				selected: null,
				spreads: [],
				statements: [],
				underwriting: {},
				nextHref: null
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.hasReferrer = ko.computed({
				read: function(){
					return window.history.length > 2;
				}
			});
			self.performingAjax = ko.computed({
				read: function(){
					return app.performingAjax();
				}
			});
			// error message displayed on page
			self.errorMsg = ko.computed({
				read: function(){
					return app.log.errorMsg();
				}
			});
			self.cancel = function(){
				window.history.back();
			};
			// remoting wrappers
			self.retrieve = function(data, success){
				if(!data.isLoaded()){
					app.performingAjax(true);
					LifeCycle.SpreadsService.retrieveIForce(
							data,
							data.recordId(),
							function(result, event){
								app.performingAjax(false);
								for(var key in result.statementBundles) {
									if (result.statementBundles.hasOwnProperty(key) && key.match(/\w+\./)) {
										result.statementBundles[key.replace(/\w+\./,'')] = result.statementBundles[key];
									}
								}
								app.mapFromJS(result, app.getMapping(), data);
								if(success != undefined){
									success.apply(this, [result, event, data]);
								}
							},
							app.log.failure, undefined, false);
				}else{
					success.apply(this, [{}, {}, data]);
				}
			};
			self.search = function(){
				app.performingAjax(true);
				self.selected(undefined);
				LifeCycle.SpreadsService.searchRecords(
						app.mapToJS(self.searchCriteria),
						function(result, event){
							app.performingAjax(false);
							self.searched(true);
							self.bundles.removeAll();
							_.each(result, function(value){
								self.bundles.mappedCreate(value);
							});
						}, app.log.failure, undefined, false);
			};
			self.filterData = function(data){
				return data.isLoaded() && !_.isEmpty(data.loan.recordId())
						&& !_.isEmpty(self.loan.recordId())
						&& data.loan.recordId() == self.loan.recordId();
			};
			self.build = function(){
				var request = {
					loanId: self.loan.recordId(),
					templateId: (self.selected()) ? self.selected().recordId() : null,
					involvementId: self.involvement.recordId(),
					relationshipId: self.relationship.recordId(),
					relationshipName: self.relationship.name()
				};
				app.performingAjax(true);
				LifeCycle.Underwriting.Start.createBundle(
					request,
					function(spreadId, event){
						window.location =  self.nextHref() + spreadId;
					},
					app.log.failure
				);
			};
			var _loadRelationship = function(relationship){
				if(!_.isEmpty(relationship.recordId())){
					if(relationship.recordId() != self.relationship.recordId()){
						app.mapFromJS(
								{ 'relationship': app.mapToJS(relationship) },
								app.getMapping(),
								self);
					}
					self.retrieve(
							self.relationship,
							function(result, event, relationship){
								if(!_.isEmpty(relationship.statementBundles.ILifeCycleUnderwritingBundle.recordId())){
									self.build();
								}
							});
				}
			};
			var _loadLoan = function(loan){
				if(!_.isEmpty(loan.recordId())){
					if(loan.recordId() != self.loan.recordId()){
						app.mapFromJS(
								{ 'loan': app.mapToJS(loan) },
								app.getMapping(),
								self);
					}
					self.retrieve(self.loan);
				}
			};
			var _loadInvolvement = function(involvement){
				if(!_.isEmpty(involvement.recordId())){
					if(involvement.recordId() != self.involvement.recordId()){
						app.mapFromJS(
								{ 'involvement': app.mapToJS(involvement) },
								app.getMapping(),
								self);
					}
					self.retrieve(
							self.involvement,
							function(result, event, involvement){
								_loadLoan(involvement.loan);
								_loadRelationship(involvement.relationship);
							});
				}
			};
			var _loadUnderwriting = function(underwriting){
				if(!_.isEmpty(underwriting.recordId())){
					if(underwriting.recordId() != self.underwriting.recordId()){
						app.mapFromJS(
								{ 'underwriting': app.mapToJS(underwriting) },
								app.getMapping(),
								self);
					}
					self.retrieve(self.underwriting);
				}
			};
			self.load = function(){
				try{
					if(_.isEmpty(self.involvement.recordId())
							|| _.isEmpty(self.underwriting.recordId())){
						throw new Error(LifeCycle.msgs.msg_underwriting_start_required_data);
					}
					_loadInvolvement(self.involvement);
					_loadUnderwriting(self.underwriting);
					self.search();
				}catch(e){
					app.log.failure(null, e);
				}
			};
			app.log('Underwriting.Start ViewModel instantiated.');
			return self;
		}
		app.setMapping({
			'searchCriteria': {
				create: function(options){
					return new app.UnderwritingBundleTemplate(options.data);
				}
			}
		});
		app.log('Underwriting.Start ViewModel initialized.');
	};
	if(LifeCycle.Underwriting.Start.ViewModel == undefined){
		LifeCycle.Underwriting.Start.ViewModel = ViewModel;
	}
})();
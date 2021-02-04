(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;

			var defaultData = {
				creditMemo: {},
				creditMemoTemplates: [],
				creditMemoContainer: {},
				searchCriteria: {},
				searched: false,
				selected: null,
				showBuilt: false
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.built = ko.computed({
				read: function(){
					return !_.isEmpty(self.creditMemo.recordId());
				}
			});
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
					LifeCycle.BorrowerTree.retrieveIForceCreditMemoContainer(
							data,
							data.recordId(),
							function(result, event){
								app.mapFromJS(result, app.getMapping(), data);
								self.search();
								if(success != undefined){
									success.apply(this, [result, event, data]);
								}
							},
							app.log.failure);
				}else{
					success.apply(this, [{}, {}, data]);
				}
			};
			self.save = function(data, success){
				LifeCycle.BorrowerTree.saveRecord(
						app.mapToJS(data),
						function(result, event){
							if(success != undefined){
								success.apply(this, [result, event, data]);
							}
						},
						app.log.failure);
			};
			self.clone = function(data, success){
				LifeCycle.BorrowerTree.cloneRecord(
						app.mapToJS(data),
						function(result, event){
							if(success != undefined){
								success.apply(this, [result, event, data]);
							}
						},
						app.log.failure);
			};
			self.cloneAndSaveCreditMemo = function(data, success) {
				LifeCycle.BorrowerTree.cloneAndSaveCreditMemo(
					app.mapToJS(data),
					function(result, event) {
						if (success != undefined) {
							success.apply(this, [result, event, data]);
						}
					},
					app.log.failure);
			};
			self.cloneAttachments = function(templateScreenId, cloneScreenId, success) {
				LifeCycle.Force.cloneScreenSectionAttachments(
					templateScreenId,
					cloneScreenId,
					success
				);
			};
			self.search = function(){
				self.selected(undefined);
				self.searchCriteria.relatedObjectId = self.creditMemoContainer.recordId;
				self.searchCriteria.apexType = self.creditMemoContainer.apexType;
				LifeCycle.BorrowerTree.searchRecords(
						app.mapToJS(self.searchCriteria),
						function(result, event){
							self.searched(true);
							self.creditMemoTemplates.removeAll();
							_.each(result, function(value){
								self.creditMemoTemplates.mappedCreate(value);
							});
						}, app.log.failure);
			};

			var _cloneTemplate = function() {
				if (self.selected()) {
					app.performingAjax(true);
					self.cloneAndSaveCreditMemo(
						self.selected(),
						function(result, event){
							app.mapFromJS(result, app.getMapping(), self.creditMemo);
							self.creditMemoContainer.creditMemo = self.creditMemo;

							self.save(
								self.creditMemoContainer,
								function(result, event){
									app.mapFromJS(result, app.getMapping(), self.creditMemoContainer);
									self.showBuilt(true);
									self.cloneAttachments(
										self.selected().screen.recordId(),
										self.creditMemoContainer.creditMemo.screen.recordId(),
										function() {
											app.performingAjax(false);
											location.reload(true);
										}
									);
								});
						}
					);
				}
			};
			self.build = function(){
				if(!self.built()){
					_cloneTemplate();
				}
			};

			var _loadCreditMemoContainer = function(creditMemoContainer){
				if(!_.isEmpty(creditMemoContainer.recordId())){
					if(creditMemoContainer.recordId() != self.creditMemoContainer.recordId()){
						app.mapFromJS(
							{ 'creditMemoContainer': app.mapToJS(creditMemoContainer) },
							app.getMapping(),
							self);
					}
					self.retrieve(self.creditMemoContainer);
				}
			};
			self.load = function(){
				_loadCreditMemoContainer(self.creditMemoContainer);
			};

			app.log('CreditMemo.Start ViewModel instantiated.');
			return self;
		};
		app.setMapping({
			'searchCriteria': {
				create: function(options){
					return new app.CreditMemoContainer(options.data);
				}
			}
		});
		app.log('CreditMemo.Start ViewModel initialized.');
	};
	if(LifeCycle.CreditMemo.Start.ViewModel == undefined){
		LifeCycle.CreditMemo.Start.ViewModel = ViewModel;
	}
})();
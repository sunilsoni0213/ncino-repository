(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			var defaultData = {
				creditMemo: {},
				screen: {},
				creditMemoScreenContainer: {},
				creditMemoScreens: [],
				creditMemoContainer: {},
				selected: null,
				showBuilt: false
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.built = ko.computed({
				read: function(){
					return _.isEmpty(self.selected);
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

			self.creditMemo = LifeCycle.IForceCache.lookupIForceById(self.creditMemo.recordId(), {
				alwaysReturnModel: true,
				generatePlaceholder: true,
				placeholderType: 'c.LifeCycleCreditMemo'
			});

			self.creditMemoContainer = LifeCycle.IForceCache.lookupIForceById(self.creditMemoContainer.recordId(), {
				alwaysReturnModel: true,
				generatePlaceholder: true,
				placeholderType: 'c.LifeCycleCreditMemoContainer'
			});

			self.retrieveCreditMemoScreens = function(data, success) {
				LifeCycle.BorrowerTree.retrieveCreditMemoScreensContainer(
					data,
					data.recordId(),
					processCreditMemoScreens,
					app.log.failure);
			};

			var _showTemplate = function(){
				if(self.selected()){
					app.performingAjax(true);
					var url = '&screenId=' + self.selected().screen.recordId();
					location.search += url;
				}
			};
			self.build = function(){
				if(!self.built()){
					_showTemplate();
				}
			};

			function processCreditMemoScreens(result, event) {
				var i;
				var memoIds = [];
				var screen = [];
				var sections = [];
				var keys = Object.keys(result['creditMemoScreens'][0]);

				for (i = 0; i < result['creditMemoScreens'].length; i++) {
					memoIds.push(result['creditMemoScreens'][i].Id);
					screen.push(result['creditMemoScreens'][i][keys[1]]);
				}

				for (i = 0; i < result['sections'].length; i++) {
					sections.push(result['sections'][i]);
				}

				sections = groupBy(sections, 'nFORCE__Screen__c');

				LifeCycle.IForceCache.getIForcesById(memoIds, {
					iForceProvider: function(){
						return LifeCycle.LiteForceService;
					}
				}, function(){
					self.creditMemoScreens(LifeCycle.IForceCache.getIForcesById(memoIds));
					for (i=0; i < screen.length; i++) {
						for(var x = 0; x < sections[screen[i]].length; x++) {
							ko.unwrap(self.creditMemoScreens)[i].screen.screenSections.push(sections[screen[i]][x].nFORCE__Screen_Section__r.Name);
						}
						ko.unwrap(self.creditMemoScreens)[i].screen.screenSections.sort();
					}
					getTranslations();
				});
			}

			function groupBy(xs, key) {
				return xs.reduce(function(rv, x) {
					(rv[x[key]] = rv[x[key]] || []).push(x);
					return rv;
				}, {});
			}

			function getTranslations() {
				var creditMemoScreens = [];
				var len = ko.unwrap(self.creditMemoScreens).length;

				for (var i = 0; i < len; i++) {
					creditMemoScreens.push({
						'Id': ko.unwrap(self.creditMemoScreens)[i].recordId(),
						'Name': ko.unwrap(self.creditMemoScreens)[i].name()
					});
				}

				Visualforce.remoting.Manager.invokeAction(
					'nFORCE.RemoteActionController.invoke',
					'LLC_BI.LifeCycleCreditMemoScreenFactory.GetTranslatedCreditMemoScreenNamesEndpoint',
					{
						'creditMemoScreens': JSON.stringify(creditMemoScreens)
					},
					function(result, event) {
						if (result && result.length) {
							for (var i = 0; i < result.length; i++) {
								for (var j = 0; j < len; j++) {
									if (ko.unwrap(self.creditMemoScreens)[j].recordId() === result[i].Id) {
										ko.unwrap(self.creditMemoScreens)[j].name(result[i].Name);
									}
								}
							}
						}
					},
					{escape: true, buffer: true}
				);
			}

			var _loadCreditMemoScreenContainers = function(creditMemoScreenContainer) {
				if(!_.isEmpty(creditMemoScreenContainer.recordId())) {
					if(creditMemoScreenContainer.recordId() != self.creditMemoScreenContainer.recordId()){
						app.mapFromJS(
							{ 'creditMemoScreenContainer': app.mapToJS(creditMemoScreenContainer) },
							app.getMapping(),
							self);
					}
					self.retrieveCreditMemoScreens(self.creditMemoScreenContainer);
				}

			};
			self.load = function(){
				_loadCreditMemoScreenContainers(self.creditMemoScreenContainer);
			};

			app.log('CreditMemo.Splash ViewModel instantiated.');
			return self;
		};
		app.setMapping({
			'creditMemoScreenContainer': {
				create: function(options){
					return new app.CreditMemoScreenContainer(options.data);
				}
			}
		});
		app.log('CreditMemo.Splash ViewModel initialized.');
	};
	if(LifeCycle.CreditMemo.Splash.ViewModel == undefined){
		LifeCycle.CreditMemo.Splash.ViewModel = ViewModel;
	}
})();
(function () {
	var ViewModel = function (event, app) {
		app.ViewModel = function (serverData) {
			var self = this;
			self.app = app;
			var defaultData = {
				contextObject: '',
				contextObjectId: '',
				spreadStatementView: new app.SpreadStatementView(),
				targetElement: null,
				isChild: false,
				ready: false,
				readOnly: true,
				addStyling: true,
				selecting: false,
				showInfoHeader: true,
				showRecordTotalTitle: true,
				allowRecordExclusion: false,
				recordTotalsSelected: false
			};
			if (serverData != undefined) {
				_.extend(defaultData, serverData);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
 
			self.bundles = ko.observableArray([]);
			app.subscribe('SPREAD.Spreads.Spread_Data.Loaded_All_Bundles', function (data) {
				// var _contextObject = LifeCycle.SpreadData.lookupIForceById(self.contextObjectId());
				// self.bundles = ko.observableArray(LifeCycle.SpreadData.lookupAllBundlesForContextObject(_contextObject));
				self.bundles = ko.observableArray(data.bundles);
			});
			// TODO: add when relationships are observables
			// if (self.contextObjectId()) {
			// 	self.bundles = ko.computed(function () {
			// 		var a = 
			// 		var _contextObject = LifeCycle.SpreadData.lookupIForceById(self.contextObjectId());
			// 		return LifeCycle.SpreadData.lookupAllBundlesForContextObject(_contextObject);
			// 	});
			// }

			
			self.load = function (callback) {

				app.subscribe("SPREAD.Spreads.Spread_Statement_View.Init", function (params) {
					var viewModel = new app.ViewModel(params);
					viewModel.bundles = self.bundles;
					viewModel.loadChildVM();
				});	
				callback.apply();
				app.publish('SPREAD.Spreads.Spread_Statement_View.Started');
			};

			self.loadChildVM = function (callback) {
				self.isChild(true);
				self.targetElement(document.getElementById(self.spreadStatementView.recordId()));
				if (!self.selecting()) {
					self.retrieve(self.spreadStatementView, function () {
						if (self.targetElement()) {
							ko.applyBindings(self, self.targetElement());
							app.publish("SPREAD.Spreads.Spread_Statement_View.Loaded." +
								self.spreadStatementView.recordId(), self);
							self.linkStatement();
							self.ready(true);
						} else {
							app.publish("SPREAD.Spreads.Error",
								'Unable to locate template for this Spread Statement View. It Can Not Be Displayed ' +
								self.spreadStatementView.recordId());
						}
					});
				} else {
					ko.applyBindings(self, self.targetElement());
					app.publish("SPREAD.Spreads.Spread_Statement_View.Ready." +
						self.spreadStatementView.recordId(), self);
					self.ready(true);
				}
			};

			self.linkStatement = function () {
				if (!self.spreadStatementView.statement()) {
					console.warn("SSV: Can't link statement if null");
					return;
				}

				var statementId = self.spreadStatementView.statement().recordId();
				LifeCycle.SpreadData.getStatementById(
					statementId,
					{wait: true}, 
					function (statement) {
						if (_18Id(statement.recordId()) != _18Id(statementId)) {
							return;
						}
						//hot swap statement
						self.spreadStatementView.statement(statement);
					}
				);
			};

			self.retrieve = function (data, success, remotingOptions) {
				LifeCycle.SpreadsService.retrieveIForce(
					data,
					data.recordId(),
					function (result, event) {
						app.mapFromJS(result, app.getMapping(), data);
						if (_.isFunction(success)) {
							success.apply(this, [result, event, data]);
						}
					},
					app.log.failure, remotingOptions, false);
			};

			self.save = function (success) {
				self.spreadStatementView.__cached = true;
				var data = app.mapToJS(self.spreadStatementView, {
					useOptimizedMapper: true,
					maxDepth: 0,
					allowedPaths: ['$root.viewFilter.filterRecords']
				});
				if (self.selecting()) {
					data.recordId = null;
				}
				LifeCycle.LiteForceService.saveIForce(
					data,
					function(result, event){
						if (success != undefined) {
							success.apply(this, [result, event, data]);
						}
					},
					app.log.failure
				);
			};

			return self;
		}
		app.log('ViewModel initialized.');
	};
	if (LifeCycle.Spread_Statement_View.ViewModel == undefined) {
		LifeCycle.Spread_Statement_View.ViewModel = ViewModel;
	}
})();

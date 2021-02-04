(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(config){
			var self = this;
			self.app = app;
			var defaultData = {
				objectId: null,
				objectName: null,
				actions: {
					retrieveWLRHistory: null
				},
				isLoaded: false,
				watchListRelationshipMap: [],
				requestId: null,
				returnUrl: null,
				accountId: null
			};
			var rankings = [app.labels.noMatch, app.labels.inComplete, app.labels.moreInfo, app.labels.match];
			if (config!=undefined) {
				_.extend(defaultData, config);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.status = ko.computed(function() {
				var status = app.labels.noMatch;
				var rank = -1;
				var wlrList = self.watchListRelationshipMap();
				for (var i = 0; i < wlrList.length; i++) {
					var wlr = wlrList[i];
					if (_.isFunction(wlr.watchListRelationship.dispositionStatus)) {
						var disposition = wlr.watchListRelationship.dispositionStatus();
						if(rank < _.indexOf(rankings,disposition)){
							rank = _.indexOf(rankings,disposition);
						}
					}
				}
				if(rank < 0){
					return app.labels.noMatch;
				}
				return rankings[rank];
			}, this);

			self.goBack = function() {
				self.setLocation(self.returnUrl());
			};
			self.goSearch = function() {
				self.setLocation(self.requestId());
			};
			self.goSearchItem = function(accountId) {
				var viewUrl = self.requestId() + '&accountId=' + accountId;
				self.setLocation(viewUrl);
			}
			self.goView = function(requestId) {
				var viewUrl = self.requestId() + '&requestId=' + requestId;
				self.setLocation(viewUrl);
			};
			self.load = function() {
				LifeCycle.blockUI();
				self.retrieveWLRHistory(function(watchListRelationshipMap, event) {
					if (event.status) {
						var index = -1;
						watchListRelationshipMap = _.chain(watchListRelationshipMap)
							.values(watchListRelationshipMap)
							.map(function(req) {
								index++;
								return {
									relationship: _.keys(watchListRelationshipMap)[index],
									watchListRelationship: req
								}
							})
							.value();
						app.mapFromJS({watchListRelationshipMap: watchListRelationshipMap}, app.getMapping(), self);
						LifeCycle.unblockUI();
						self.isLoaded(true);
					} else {
						failRequest(event.message);
					}
				});
			};

			self.retrieveWLRHistory = function(callback) {
				Visualforce.remoting.Manager.invokeAction(
					self.actions.retrieveWLRHistory(),
					self.objectId(),
					callback
				);
			};
			self.setLocation = function(url) {
				if (_.isString(url)) {
					window.location = url;
				}
			};

			function failRequest(message) {
				app.log('Failed Request: ' + message);
				LifeCycle.unblockUI();
				self.isLoaded(true);
			}
			app.log('ViewModel instantiated.');
			LifeCycle.setupBlockUI();
			return self;
		}
		app.log('ViewModel initialized.');
	};
	if(LifeCycle.WatchlistHistory.ViewModel == undefined){
		LifeCycle.WatchlistHistory.ViewModel = ViewModel;
	}
})();
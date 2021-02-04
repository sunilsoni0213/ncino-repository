(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(config){
			var self = this;
			self.app = app;
			var defaultData = {
				objectId: null,
				actions: {
					preserveRequest: null,
					retrieveAccounts: null,
					retrieveRequest: null,
					search: null
				},
				error: null,
				accounts: [],
				filteredAccounts: [],
				displayAccounts: false,
				isLoaded: false,
				requests: [],
				request: null,
				requestId: null,
				returnUrl: null,
				accountId: null
			};
			if (config!=undefined) {
				_.extend(defaultData, config);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.goBack = function() {
				self.setLocation(self.returnUrl());
			};
			self.hasMultipleAccounts = ko.computed(function() {
				if (self.accounts() && self.accounts().length > 1) {
					return true;
				}
				return false;
			}, this);
			self.hasAccount = ko.computed(function() {
				var ctr = 0;
				for(var i = 0; i < self.accounts().length; i++) {
					if(self.accounts()[i].selected()) {
						return true;
					}
				}
				return false;
			}, this);
			self.goSearch = function() {
				LifeCycle.blockUI();
				self.displayAccounts(false);
				self.loadFilteredAccounts();
				self.createSearch();
			};

			self.hasMatches = ko.computed(function() {
				var ctr = 0;
				for(var i = 0; i < self.requests().length; i++){
					var hits = self.requests()[i].matches();
					ctr += hits.length;
				}
				if(ctr > 0){
					return true;
				}
				return false;
			});

			self.hasError = function() {
				return _.isString(self.error());
			};

			self.loadFilteredAccounts = function() {
				var ctr = 0;
				for(var i = 0; i < self.accounts().length; i++) {
					if(self.accounts()[i].selected()) {
						self.filteredAccounts()[ctr++] = self.accounts()[i].recordId();
					}
				}
			};

			self.loadRequest = function(requestId) {
				self.retrieveRequest(function(result, event) {
					if(event.status) {
						self.displayAccounts(false);
						var results = [];
						results[0] = result;
						handleRequest(results, event);
					}
					else {
						failRequest(event.message);
					}
				}, requestId);
			};

			self.loadAccountSelection = function() {
				var hasMultipleAccounts = self.hasMultipleAccounts();
				if (!hasMultipleAccounts) {
					self.displayAccounts(false);
					self.filteredAccounts()[0] = self.accounts()[0].recordId();
					self.createSearch();
				}
				else {
					self.displayAccounts(true);
					LifeCycle.unblockUI();
				}

			};

			self.createSearch = function() {
				self.search(function(result, event) {
					if(event.status) {
						handleRequest(result, event);
					}
					else {
						failRequest(event.message);
					}
				}, self.filteredAccounts());
			};

			self.load = function() {
				LifeCycle.blockUI();
				var requestId = self.requestId();
				var accountId = self.accountId();
				if (requestId) {
					self.loadRequest(requestId);
				} else {
					if(accountId){
						self.retrieveAccount(function(accounts, event) {
							if (event.status) {
								deepUnescapeJSON(accounts);
								app.mapFromJS(accounts, app.getMap('accounts'), self.accounts);
								self.loadAccountSelection();
							} else {
								failRequest(event.message);
							}
						}, accountId);	  
					} else {
						var objectId = self.objectId();
						self.retrieveAccounts(function(accounts, event) {
							if (event.status) {
								deepUnescapeJSON(accounts);
								app.mapFromJS(accounts, app.getMap('accounts'), self.accounts);
								self.loadAccountSelection();
							} else {
								failRequest(event.message);
							}
						}, objectId);
					}

				}
			};

			self.preserveRequests = function(callback) {
				var requests = app.mapToJS(self.requests);
				var hasMatches = self.hasMatches();
				Visualforce.remoting.Manager.invokeAction(
					self.actions.preserveRequests(),
					requests,
					callback
				);
			};

			self.retrieveRequest = function(callback, requestId) {
				Visualforce.remoting.Manager.invokeAction(
					self.actions.retrieveRequest(),
					requestId,
					callback
				);
			};

			self.retrieveAccount = function(callback) {
				Visualforce.remoting.Manager.invokeAction(
					self.actions.retrieveAccounts(),
					self.accountId(),
					callback
				);
			};
			
			self.retrieveAccounts = function(callback) {
				Visualforce.remoting.Manager.invokeAction(
					self.actions.retrieveAccounts(),
					self.objectId(),
					callback
				);
			};

			self.update = function() {
				var founderror = false;
				for(var i = 0; i < self.requests().length; i++){
					if(!self.requests()[i].validate()) {
						this.error(app.labels.checkValidations);
						window.scrollTo(0,0);
						founderror=true;
						break;
					}
				}
				if(!founderror) {
					LifeCycle.blockUI();
					var requests = [];
					requests[0] = self.request;
					self.preserveRequests(function(requests, event) {
						handleRequest(requests, event);
						self.goBack();
					});
				}

			};

			self.search = function(callback, accountIds) {
				Visualforce.remoting.Manager.invokeAction(
					self.actions.search(),
					accountIds,
					self.objectId(),
					callback
				);
			};

			self.setLocation = function(url) {
				if (_.isString(url)) {
					window.location = url;
				}
			};

			function deepUnescapeJSON(object) {
				var apostrophe = /(&#39;)/g;
				var val;
				
				for(var propName in object) {
					val = object[propName]; 

					if(typeof( object[propName] ) == "string") {
						val = _.unescape(val);
						val = val.replace(apostrophe, "\'"); // unescape function does not fix apostrophe
					}
					if(typeof( object[propName]) == "object") 
						val = deepUnescapeJSON(object[propName]);
					object[propName] = val;
				}
				return object;
			}

			function failRequest(message) {
				app.log('Failed Request: ' + message);
				self.error(message);
				self.isLoaded(false);
				LifeCycle.unblockUI();
			}

			function handleRequest(result, event) {
				if (event.status) {
					deepUnescapeJSON(result);
					
					app.mapFromJS(result, app.getMap('request'), self.requests);
					var counter = 0;
					_.each(self.requests(), function(r) {
						r.counter(counter);
						counter++;
					});

					LifeCycle.unblockUI();
					self.isLoaded(true);
				} else {
					failRequest(event.message);
				}
			}

			app.log('ViewModel instantiated.');
			LifeCycle.setupBlockUI();
			return self;
		}
		app.log('ViewModel initialized.');
	};
	if(LifeCycle.WatchlistReport.ViewModel == undefined){
		LifeCycle.WatchlistReport.ViewModel = ViewModel;
	}
})();
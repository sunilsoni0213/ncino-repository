(function(){
	var Models = function(event, app) {
		app.Address = function(data) {
			var self = this;
			var defaultData = {
				city: null,
				country: null,
				matchId: null,
				postalCode: null,
				recordId: null,
				state: null,
				street: null
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.Disposition = function(data) {
			var self = this;
			var rankings = [app.labels.moreInfo, app.labels.match];
			var defaultData = {
				comments: null,
				matchId: null,
				recordId: null,
				status: null,
				createdByName: null,
				requestOverride: false,
				overrideApproved: false
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.selectdata = ko.observableArray([app.labels.falsePositive, app.labels.moreInfo, app.labels.match]);
			self.override = ko.computed(function(){
				return (self.status() == app.labels.match);
			}, this);
			self.hasApproval = ko.computed(function() {
				return (app.labels.approvalProcess != 'NONE');
			}, this);
			self.canEdit = ko.computed(function() {
				return (self.recordId() == null);
			}, this);
			self.canSave = ko.computed(function() {
				return _.isString(self.comments()) && !_.isEmpty(self.comments()) && _.isString(self.status()) && !_.isEmpty(self.status());
			}, this);
			self.getRank = function() {
				return _.indexOf(rankings, self.status());
			};
			return self;
		};
		app.Match = function(data) {
			var self = this;
			var defaultData = {
				addresses: [],
				birthDate: null,
				comments: null,
				dispositions: [],
				gender: null,
				name: null,
				nationality: null,
				placeOfBirth: null,
				recordId: null,
				requestId: null,
				score: null,
				watchList: null
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			defaultData.dispositions = _.sortBy(defaultData.dispositions, function(d) {
				return d.createdDate;
			}).reverse();
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.validating = ko.observable(false);
			self.hasApproval = ko.computed(function() {
				return (app.labels.approvalProcess != 'NONE');
			}, this);
			self.canEdit = ko.computed(function() {
				return _.find(self.dispositions(), function(d) {
					return d.canEdit();
				}) != null;
			}, this);
			self.canSave = ko.computed(function() {
				var disp = _.find(self.dispositions(), function(d) {
					return !d.canSave();
				});
				return !_.isObject(disp);
			}, this);
			self.addNew = function() {
				var dArray = self.dispositions();
				dArray.splice(0, 0, new app.Disposition());
				self.dispositions(dArray);
			};
			self.getLatestDisposition = function() {
				return (self.dispositions().length > 0) ? self.dispositions()[0] : null;
			};
			return self;
		};
		app.Relationship = function(data) {
			var self = this;
			var defaultData = {
				recordId: null,
				name: null
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.selected = ko.observable(false);
			self.setSelected = function() {
				self.selected(!self.selected());
			};
			self.getClass = function() {
				return (self.selected()) ? "list-group-item active" : "list-group-item";
			};
			return self;
		};
		app.History = function(data) {
			var self = this;
			var defaultData = {
				requestId: null,
				loanId: null,
				primaryrelationshipId: null,
				productpackageId: null
			}
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.selected = ko.observable(false);
			self.setSelected = function() {
				self.selected(!self.selected());
			};
			return self;
		};
		app.Request = function(data) {
			var self = this;
			var defaultData = {
				accountId: null,
				dbaName: null,
				objectId: null,
				reason: null,
				birthDate: null,
				city: null,
				createdDate: null,
				entityType: null,
				isIndividual: false,
				matches: [],
				name: null,
				postalCode: null,
				recordId: null,
				ssn: null,
				state: null,
				street: null,
				tin: null,
				history: []
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.counter = ko.observable(0);
			self.goView = function() {
				app.viewModel.goView(self.recordId());
			};
			self.birthDateText = ko.computed(function() {
				var floatOfBirthday = parseFloat(self.birthDate());
				return (floatOfBirthday!=undefined && self.birthDate())
					? moment(floatOfBirthday).utc().format('LL')
					: null;
			}, this);
			self.dbaNameMatch = ko.computed(function() {
				return (self.dbaName() == self.name()) ? false : true;
			}, this);
			self.getHref = function() {
				return '#'+self.recordId();
			};
			self.getActive = function() {
				return (self.counter()==0) ? "active" : "";
			};
			self.getClass = function() {
				return (self.counter()==0) ? "tab-pane active" : "tab-pane";
			};
			self.isExpired = ko.computed(function() {
				var currentDate = moment();
				var newD = self.createdDate();
				var daysApart = currentDate.diff(newD,'days');
				return(daysApart >= app.expirationDays) ? true : false ;
			}, this);
			self.hitCount = ko.computed(function() {
				var matches = self.matches();
				if (_.isArray(matches)) {
					return matches.length;
				}
				return 0;
			}, this);
			self.requestedDate = ko.computed(function() {
				var date = self.createdDate();
				return (date!=undefined)
					? moment(date).utc().format('LLL')
					: null;
			}, this);
			self.status = ko.computed(function() {
				var status = app.labels.noMatch;
				var rank = -1;
				var matches = self.matches();
				for (var i = 0; i < matches.length; i++) {
					var match = matches[i];
					var disposition = match.getLatestDisposition();
					if (!_.isObject(disposition)) {
						return app.labels.inComplete;
					}
					var dStatus = disposition.status();
					var dRank = disposition.getRank();
					if (dRank > rank) {
						status = dStatus;
						rank = dRank;
					}
				}
				return status;
			}, this);
			self.watchLists = ko.computed(function() {
				var index = 0;
				return _.chain(self.matches())
					.groupBy(function(match) {
						return match.watchList();
					})
					.map(function(value, key) {
						index++;
						return {
							name: key,
							index: index,
							matches: value
						};
					})
					.sortBy(function(watchList) {
						return watchList.name;
					})
					.value();
			}, this);
			self.validate = function() {
				var valid = true;
				_.each(self.matches(), function(match) {
					match.validating(true);
					valid = valid && match.canSave();
				});
				return valid;
			};
			return self;
		};
		app.AliasMap = function(data) {
			var self = this;
			var defaultData = {
				alias: null,
				request: []
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			defaultData.request = _.sortBy(defaultData.request, function(r) {
				return r.createdDate;
			}).reverse();			
			self.isAliasNull = ko.computed(function() {
				var name = self.alias();
				if(name == 'null'){
					return true;
				}
				else{
					return false;
				}
			},this);
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.WatchListRelationship = function(data) {
			var self = this;
			var defaultData = {
				accountId: null,
				objectId: null,
				name: null,
				reason: [],
				aliasMap: [],
				expirationLengthDays: null,
				dispositionStatus: null,
				dispositionDate: null
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			self.goView = function() {
				app.viewModel.goView(self.accountId());
			};
			self.goSearchAccount = function() {
				app.viewModel.goSearchItem(self.accountId());
			}
			self.buttonClass = ko.computed(function() {
				if(self.dispositionStatus() === app.labels.inComplete){
					return "btn btn-danger btn-sm pull-right";
				} else if(self.dispositionStatus() === app.labels.moreInfo){
					return "btn btn-danger btn-sm pull-right";
				} else if(self.dispositionStatus() === app.labels.noMatch){
					return "btn btn-success btn-sm pull-right";
				} else if(self.dispositionStatus() === app.labels.match){
					return "btn btn-danger btn-sm pull-right";
				} else if(self.dispositionStatus() === app.labels.overRide){
					return "btn btn-success btn-sm pull-right";
				} else {
					return "btn btn-sm pull-right";
				}

			},this);
			self.isNameNull= ko.computed(function() {
				if(self.name == 'null'){
					return true;
				}
				else{
					return false;
				}
			},this); 
			
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.WatchListRelationshipMap = function(data) {
			var self = this;
			var defaultData = {
				relationship: null,
				watchListRelationship: []
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			self.goSearch = function() {
				app.viewModel.goSearchItem(self.watchListRelationshipMap());
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.setMapping({
			'accounts': {
				create: function(options){
					return new app.Relationship(options.data);
				}
			},
			'addresses': {
				create: function(options){
					return new app.Address(options.data);
				}
			},
			'dispositions': {
				create: function(options){
					return new app.Disposition(options.data);
				}
			},
			'history' : {
				create: function(options){
					return new app.History(options.data);
				}				
			},
			'matches': {
				create: function(options){
					return new app.Match(options.data);
				}
			},
			'request': {
				create: function(options){
					return new app.Request(options.data);
				}
			},
			'requests': {
				create: function(options){
					return new app.Request(options.data);
				}
			},
			'aliasMap' : {
				create: function(options){
					var index = -1;
					return _.chain(options.data)
							.values(options.data)
							.map(function(req) {
								index++;
								return new app.AliasMap({
									alias: _.keys(options.data)[index],
									request: req
								})
							})
							.value();
				}
			},
			'watchListRelationship': {
				create: function(options){
					return new app.WatchListRelationship(options.data);
				}
			},
			'watchListRelationshipMap' : {
				create: function(options){
					return new app.WatchListRelationshipMap(options.data);
				}   
			}
		});
		app.log('Models initialized.');
	};
	if(LifeCycle.Watchlist == undefined){
		LifeCycle.Watchlist = {};
	}
	if(LifeCycle.Watchlist.Models == undefined){
		LifeCycle.Watchlist.Models = Models;
	}
})();

(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(config){
			var self = this;
			self.app = app;
			var defaultData = {
				loanId: null,
				actions: {
					retrieveReview: null,
					submitToETran: null
				},
				review: null,
				response: null
			};
			if (config!=undefined) {
				_.extend(defaultData, config);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.pageState = ko.observable();
			self.errorMessage = ko.observable();

			self.load = function() {
				LifeCycle.blockUI();
				self.retrieveReview(function(review, event){
					if(event.status){
						deepUnescapeJSON(review);
						app.mapFromJS(review, app.getMap("review"), self.review);
						self.pageState('review');
					}
					else {
						failRequest(event.message);
					}
					LifeCycle.unblockUI();
				});
			};

			self.retrieveReview = function(callback){
					Visualforce.remoting.Manager.invokeAction(
					self.actions.retrieveReview(),
					self.loanId(),
					callback
				);
			};

			self.submitToETran = function(callback){
					Visualforce.remoting.Manager.invokeAction(
					self.actions.submitToETran(),
					self.loanId(),
					callback
				);
			};

			self.submit = function(){
				LifeCycle.blockUI();
				self.submitToETran(function(response, event){
					if(event.status) {
						deepUnescapeJSON(response);
						app.mapFromJS(response, app.getMap("response"), self.response);
						self.pageState('response');
					}
					else {
						failRequest(event.message);
					}
					LifeCycle.unblockUI();
				});
			}

			self.showReview = function(){
				self.pageState('review');
			}

			self.returnToLoan = function(){
				window.location.href = '/' + self.loanId();
			}

			function failRequest(message) {
				app.log('Failed Request: ' + message);
				self.errorMessage(message);
				self.pageState('error');
			}
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
			app.log('ViewModel instantiated.');
			LifeCycle.setupBlockUI();
			return self;
		}
		app.log('ViewModel initialized.');
	};
	ko.bindingHandlers.editButton = {
		init: function(element, valueAccessor) {
			var id = valueAccessor();
			var btn = jQuery('<button>Edit</button>').appendTo(element);
			btn.addClass('btn btn-xs btn-default pull-right');
			jQuery(btn).click(function() {
				window.location = '/' + id();
			});
		}
	};
	if(LifeCycle.ETranReview.ViewModel == undefined){
		LifeCycle.ETranReview.ViewModel = ViewModel;
	}
})();
(function(){
	var Models = function(event, app){
		var defaultModelData = {
			recordId: '',
			name: ''
		};

		app.Comment = function(data) {
			var self = this;
			var defaultData = _.extend({
					date: Date.now(),
					message: '',
					user: '',
					deleted: false
				},
				defaultModelData);

			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.generateUUID = function(){
				return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g,
					function(c) {
						var r = Math.random()*16|0,v=c=='x'?r:r&0x3|0x8;return v.toString(16);
					});
			};

			if (_.isEmpty(self.recordId())) {
				self.recordId(self.generateUUID());
			}

			/**
			 * Returns a display-friendly version of the date.
			 * @return	{Date}	The localized version of the date.
			 */
			self.displayDate = ko.computed(function() {
				return new Date(self.date()).toLocaleString().replace(',', '');
			});

			return self;
		};

		app.CommentableItem = function(data) {
			var self = this;
			var defaultData = _.extend({
					newCommentMessage: '',
					comments: [],
					currentUser: '',
					permissions: {}
				},
				defaultModelData);

			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			/**
			 * Returns whether the new comment message is valid or not.
			 * @return	{Boolean}	True if the comment message is valid.  Otherwise, false.
			 */
			self.isCommentValidated = ko.computed(function() {
				return !_.isEmpty(self.newCommentMessage());
			});

			/**
			 * Returns whether the current user can add a comment.
			 * @return	{Boolean}	True if the current user can add a comment.  Otherwise, false.
			 */
			self.canAddComment = ko.computed(function() {
				return self.permissions.canAddComment();
			});

			/**
			 * Returns whether this item has comments or not.
			 * @return	{Boolean}	True if this item has comments.  Otherwise, false.
			 */
			self.hasComments = ko.computed(function() {
				return self.comments().length > 0;
			});

			/**
			 * Hooks into the keypress events of the .
			 * @param	{Object}	data	Data of the event fired.
			 * @param	{Event}	event	Event that was fired.
			 * @return	None
			 */
			self.onKeyPress = function(data, event) {
				if (event.keyCode === 13) {
					self.addComment();
				}
				return true;
			};

			/**
			 * Creates a new comment from the newCommentMessage and the currentUser, then appends it
			 * to the list.
			 */
			self.addComment = function() {
				if (self.canAddComment()) {
					var newComment = new app.Comment({
						message: self.newCommentMessage(),
						user: app.mapToJS(self.currentUser) });
					self.comments.push(newComment);

					// Reset the new comment message.
					self.newCommentMessage('');

					// Publish the new comment.
					var publishData = _.extend(_.pick(self, 'recordId'), { 'comments': ko.observableArray([newComment]) });
					app.publish("LLC_BI.Comments.Comment_Added", publishData);
				}
			};

			return self;
		};

		app.Configuration = function(data) {
			var self = this;
			var defaultData = _.extend({
					autoLoad: true
				},
				defaultModelData);

			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			return self;
		};

		app.Permissions = function(data) {
			var self = this;
			var defaultData = _.extend({
					canAddComment: false
				},
				defaultModelData);

			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			return self;
		};

		app.User = function(data) {
			var self = this;
			var defaultData = _.extend({}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			return self;
		};

		app.setMapping({
			'commentableItems': {
				create: function(options){
					return new app.CommentableItem(options.data);
				}
			},
			'comments': {
				create: function(options){
					return new app.Comment(options.data);
				}
			},
			'configuration': {
				create: function(options){
					return new app.Configuration(options.data);
				}
			},
			'currentUser': {
				create: function(options){
					return new app.User(options.data);
				}
			},
			'permissions': {
				create: function(options){
					return new app.Permissions(options.data);
				}
			},
			'user': {
				create: function(options){
					return new app.User(options.data);
				}
			}
		});

		app.setTypesMap({
			'CommentCollection': 'commentableItems',
			'LifeCycleUser': 'user'
		});

		app.log('Comment models initialized.');
	};
	if(LifeCycle.Comments == undefined){
		LifeCycle.Comments = {};
	}
	if(LifeCycle.Comments.Models == undefined){
		LifeCycle.Comments.Models = Models;
	}
})();

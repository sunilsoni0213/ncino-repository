(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			self.app = app;
			var defaultData = {
				commentableItems: [],
				commentsCount: 0,
				commentsLoaded: 0,
				configuration: {},
				contextId: '',
				currentUser: '',
				hasDataLoaded: false,
				hasPublishedData: false,
				permissions: {},
				recordId: '',
				userId: '',
				openComment: '',
				spread: ''	// Only required by Spread_Base KO app for printing and exporting.
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			// Required for Spread_Base KO app for printing and exporting.
			self.mapping = app.getMapping();
			self.mapping['ignore'] = ['spread'];
			if (!_.isUndefined(data.spread)) {
				self.spread = data.spread;
			}

			var _getCommentableItem = function(id) {
				if (_.isEmpty(id)) {
					return null;
				}

				var result = _.find(self.commentableItems(), function(cluster) {
					return (!_.isUndefined(cluster.recordId) && cluster.recordId() == id);
				});

				if (!_.isUndefined(result)) {
					return result;
				} else {
					var newItem = new app.CommentableItem({
						recordId: id,
						permissions: app.mapToJS(self.permissions),
						currentUser: self.currentUser });
					self.commentableItems.push(newItem);
					return newItem;
				}
			}

			var _getPopoverOptions = function(title, template, delay, elementNode) {
				return {
					container: elementNode,
					title: title,
					html: false,
					placement: 'right',
					template: template,
					delay: delay,
					trigger: 'manual'
				};
			};

			// Generates the popover template.
			var _buildPopoverTemplate = function(id) {
				var popover_container = document.createElement('div'),
				popover_content = document.createElement('div'),
				popover_arrow = document.createElement('div');
				jQuery(popover_container).attr('id', 'popover_' + id);
				jQuery(popover_container).attr('data-bind', 'stopBinding: true');
				jQuery(popover_container).attr('class', 'popover');
				jQuery(popover_container).attr('role', 'tooltip');

				jQuery(popover_content).attr('id', 'popover_content_' + id);
				jQuery(popover_content).attr('data-bind', 'template: { name: \'popoverContentTemplate\' }');

				jQuery(popover_arrow).attr('class', 'arrow');

				popover_container.appendChild(popover_content);
				popover_container.appendChild(popover_arrow);

				return jQuery(popover_container);
			};

			var _hideComment = function() {
				if (self.openComment() != '') {
					if(jQuery.isFunction(jQuery('#' + self.openComment()).popover)) {
						jQuery('#' + self.openComment()).popover('hide');
					}
					if(jQuery.isFunction(jQuery('#' + self.openComment() + ' td').popover)) {
						jQuery('#' + self.openComment() + ' td').popover('hide');
					}
					self.openComment('');
					if (typeof key !== "undefined") {
						key.setScope('nav');
					}
				}
			};

			// Handles the double-click event of a commentable html element.  Generates the popover
			// and retrieves the correct CommentableItem to use as its VM.
			self.onDoubleClick = function(e) {
				var elementNode = jQuery(this);
				// Retrieve the list of classes for the element.
				if (elementNode.length) {
					var nodeId = elementNode[0].id;
					self.openComment(nodeId);
					var context = _getCommentableItem(nodeId);
					if (context != null) {
						if (jQuery('popover_' + nodeId).length === 0) {
							elementNode.popover('destroy');
							var template = _buildPopoverTemplate(nodeId);
							elementNode.popover(_getPopoverOptions('Comments', template, 100, jQuery('#popover_content_' + nodeId)[0]));
							elementNode.append(template);
							ko.applyBindings(context, jQuery('#popover_content_' + nodeId)[0]);
							elementNode.popover('show');
							if (typeof key !== "undefined") {
								key.setScope('comment');
							}
							// handle clicking on the popover itself
							jQuery('.popover').off('click').on('click', function(e) {
								e.stopPropagation(); // prevent event for bubbling up => will not get caught with document.onclick
							});
						}

					}
				}
			};

			// Called when the consumer has been rendered or during load if autoload is true.
			self.onConsumerRendered = function() {
				// Retrieve the ID of the commentable object.  This ID will be the sObject ID to save
				// the comments to as an attachment.
				if (_.isEmpty(ko.unwrap(self.contextId))) {
					var objectElement = jQuery('.commentableObject');
					if (objectElement.length > 0) {
						self.contextId(objectElement[0].id);
					}
				}
				// Retrieve existing comments.
				self.retrieveAttachment(self.contextId());
			};

			// Called during post-run.  Sets up the necessary subscriptions.
			self.load = function() {
				// Subscribe to comments being added.
				app.subscribe("LLC_BI.Comments.Comment_Added", self.onCommentAdded);

				if (self.configuration.autoLoad()) {
					self.onConsumerRendered();
				} else {
					// Subscribe to the Consumer Rendered event.  This will let the comments vm know it can 
					// load its data.
					app.subscribeOnce("LLC_BI.Comments.Consumer_Rendered", self.onConsumerRendered);
				}
				jQuery(document).on('click', function(e) {
					if (self.openComment() != '') {
						_hideComment();
					}
				});
			};

			var _generateFilename = function(id) {
				return 'Comments_' + id;
			};

			// Retrieves the attachment from Salesforce.
			self.retrieveAttachment = function(id) {
				var filename = _generateFilename(id);

				LifeCycle.Force.retrieveAttachment(
					id,
					filename,
					function(attachment){
						self.loadAttachment(attachment);
						self.loadElements();
					},
					function(){
						console.log('An error occurred loading the attachment.');
					},
					true
				);
			};

			// Loads the contents of the attachment, then fires the followup logic.
			self.loadAttachment = function(attachment) {
				if (!_.isEmpty(attachment)) {
					var encodedAttachment = attachment.body;
					var unencodedAttachment;
					try {
						unencodedAttachment = JSON.parse(encodedAttachment.replace(/&quot;/g, '"').split('&#39;').join('\''));
					} catch (e) {
						try {
							encodedAttachment = decodeURIComponent(encodedAttachment);
							unencodedAttachment = JSON.parse(encodedAttachment.replace(/&quot;/g, '"').split('&#39;').join('\''));
						} catch(f) {
							throw new Error('Unable to decode comments attachment: Invalid Attachment Format');
						}
					}
					for (var i = 0; i < unencodedAttachment.commentableItems.length; i++) {
						var item = unencodedAttachment.commentableItems[i];
						item.currentUser = self.currentUser;
					}
					app.mapFromJS({
						commentableItems: unencodedAttachment.commentableItems
					}, app.getMapping(), self);
					self.recordId(attachment.recordId);
					self.hasDataLoaded(true);
				}
			};

			self.onDataLoaded = ko.computed(function() {
				if (self.hasDataLoaded() && !self.hasPublishedData()) {
					// Publish the loaded content.
					var publishData = _.extend({ 'recordId': self.contextId }, _.pick(self, 'commentableItems'));
					app.publish("LLC_BI.Comments.Comments_Loaded", publishData);
					self.hasPublishedData(true);
				}
			});

			// Adds the double-click function and hasComments style for applicable html elements.
			self.loadElements = function() {
				// Add a double click event to all items labeled commentable.
				var commentableElements = jQuery('.commentable');
				commentableElements.unbind('dblclick');
				commentableElements.dblclick(self.onDoubleClick);
				_.each(commentableElements, function(element) {
					// if it has comments, add a class called 'hasComments'
					var commentable = _.find(self.commentableItems(), function(commentableItem) {
						return commentableItem.recordId() == element.id;
					});
					if (!_.isUndefined(commentable) && commentable.hasComments()) {
						jQuery(element).addClass('hasComments');
					}
				});
			}

			// Main save function.
			self.save = function() {
				self.saveAttachment(self.contextId());
			};

			// Saves the attachment and stores the attachmentId in recordId.
			self.saveAttachment = function(id) {
				var body = JSON.stringify(app.mapToJS(self));
				var fileSize = body.length;

				var forcetkClient = new forcetk.Client();
				forcetkClient.setSessionToken(__sfdcSessionId);

				var filename = _generateFilename(id);
				if (!self.recordId()) {
					forcetkClient.createBlob(
						'Attachment',
						{
							ParentId: id,
							ContentType: 'application/json',
							IsPrivate: false,
							Name: filename
						},
						filename,
						'Body',
						body,
						function(data) {
							self.recordId(data.id);
						},
						function () {}
					);
				} else {
					forcetkClient.updateBlob(
						'Attachment',
						self.recordId(),
						{
							ContentType: 'application/json',
							Name: filename
						},
						filename,
						'Body',
						body,
						function() {},
						function () {}
					);
				}

			};

			// Handles logic for when a comment is added.
			self.onCommentAdded = function() {
				self.save();
				self.loadElements();
			};

			return self;
		}
	};

	if(LifeCycle.Comments.ViewModel == undefined){
		LifeCycle.Comments.ViewModel = ViewModel;
	}
})();

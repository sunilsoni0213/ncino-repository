(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			self.app = app;
			var defaultData = {
				footnoteConfiguration: { 'showFootnotes': false },
				footnoteSections: [],
				footnotesTitle: '',
				isPeriodMapLoaded: false,
				isRecordMapLoaded: false,
				isCommentsDataLoaded: false,
				loaded: false,
				mode: '',
				spread: '',	// Only required by Spread_Base KO app for printing and exporting.
				spreadId: '',
				statementType: '',
				statementTypeId: ''
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			// Required for Spread_Base KO app for printing and exporting.
			self.mapping = app.getMapping();
			self.mapping['ignore'] = ['spread'];
			if (data.spread) {
				self.spread = data.spread;
			}
			self.commentsData = {};

			self.isBudget = ko.computed(function() {
				return (self.statementType() == LifeCycle.msgs.msg_statement_budget);
			});

			self.isPrintView = ko.computed(function() {
				return (self.mode() == LifeCycle.msgs.msg_mode_print);
			});

			self.isExportView = ko.computed(function() {
				return (self.mode() == LifeCycle.msgs.msg_mode_export);
			});

			self.isStandardView = ko.computed(function() {
				return (!self.isPrintView() && !self.isExportView());
			});

			if (!_.isUndefined(LifeCycle.msgs.msg_spread_footnotes_title)) {
				self.footnotesTitle(LifeCycle.msgs.msg_spread_footnotes_title);
			}

			self.title = ko.computed(function() {
				return self.statementType() + ' ' + self.footnotesTitle();
			});

			self.readyToLoadComments = ko.computed(function() {
				return (self.isCommentsDataLoaded());
			});

			self.readyToLoadComments.subscribe(function(value) {
				if (value) {
					self.loadComments();
				}
			});

			self.loadComments = function() {
				self.footnoteSections.removeAll();
				if (self.commentsData.length) {
					_.each(self.commentsData, function(commentableItem) {
						_addFootnotes(commentableItem);
					});
				} else if(self.commentsData) {
					_addFootnotes(self.commentsData);
				}
				self.loaded(true);
			};

			self.onCommentsLoaded = function(data) {
				if (self.statementTypeId() === ko.unwrap(data.recordId)) {
					self.commentsData = ko.unwrap(data.commentableItems);
					self.isCommentsDataLoaded(true);
				}
			};

			var _addFootnotes = function(commentableItem) {
				var spreadData = app.FootnoteFactory.getSpreadData(commentableItem);
				var section = _.find(self.footnoteSections(), function(section) { 
					return (!spreadData.period && spreadData.record && section.id() == LifeCycle.msgs.msg_footnote_type_record) ||
						(spreadData.period && section.id() == ko.unwrap(spreadData.period.recordId));
				});

				if (!section) {
					section = app.FootnoteFactory.buildSection(commentableItem);
					if (section) {
						self.footnoteSections.push(section);
					}
				}

				if (section) {
					var footnotes = app.FootnoteFactory.buildFootnotes(commentableItem);
					section.footnotes.push.apply(section.footnotes, footnotes);
				}
			};

			self.onCommentAdded = function(data) {
				_addFootnotes(data);
			};

			self.load = function(data){
				app.subscribe('LLC_BI.Comments.Comments_Loaded', self.onCommentsLoaded);
				app.subscribe('LLC_BI.Comments.Comment_Added', self.onCommentAdded);
			};

			app.log('ViewModel instantiated.');
			return self;
		}
		app.log('ViewModel initialized.');
	};
	if(LifeCycle.SpreadFootnotes.ViewModel == undefined){
		LifeCycle.SpreadFootnotes.ViewModel = ViewModel;
	}
})();

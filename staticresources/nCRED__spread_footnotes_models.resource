(function(){
	var Models = function(event, app){
		var defaultModelData = {
			recordId: '',
			name : ''
		};

		function _mapWithPremappedProperties(data, mapping, target, premappedProperties) {
			var premapped = {};
			var unmapped = {};
			for (var prop in data) {
				if (data.hasOwnProperty(prop)) {
					var val = data[prop];
					if (premappedProperties.indexOf(prop) != -1) {
						premapped[prop] = val;
					} else {
						unmapped[prop] = val;
					}
				}
			}
			app.mapFromJS(unmapped, mapping, target);
			for (var prop in premapped) {
				if (premapped.hasOwnProperty(prop)) {
					var val = data[prop];
					if (typeof val == 'object') {
						target[prop] = val;
					} else {
						target[prop] = ko.observable(ko.unwrap(val));
					}
				}
			}
		}


		app.FootnoteFactory = {
			'buildSection': function(commentableItem) {
				if (commentableItem.comments().length > 0) {
					var pickedItem = _.pick(commentableItem, 'recordId');
					var spreadData = this.getSpreadData(pickedItem);
					var modelData = _.extend(pickedItem, spreadData);
					return new app.FootnoteSection(modelData);
				}
			},
			'buildFootnotes': function(commentableItem) {
				var footnotes = [];

				var spreadData = this.getSpreadData(commentableItem);
				_.each(commentableItem.comments(), function(comment) {
					var modelData = _.extend(spreadData, comment);
					footnotes.push(new app.Footnote(modelData));
				});

				return footnotes;
			},
			'getSpreadData': function(commentableItem) {
				// If the recordId can be split into two parts on underscore, then separate the period and record total.
				var results = ko.unwrap(commentableItem.recordId).split('_');

				var periodId = results[0];
				var recordId = results[(results.length - 1) ? 1 : 0];

				return {
					'period': (periodId) ? LifeCycle.SpreadData.lookupPeriodByLookupKey(periodId) : null,
					'record': LifeCycle.SpreadData.lookupRecordById(recordId),
					'recordTotal': (LifeCycle.SpreadData.lookupRecordById(recordId) || {}).recordTotal,
				};
			}
		};

		app.FootnoteSection = function(data){
			var self = this;
			var defaultData = _.extend({
					'footnotes': [],
					'visible': true
				}, 
				defaultModelData);

			if(data != undefined){
				_.extend(defaultData, data);
			}
			_mapWithPremappedProperties(defaultData, app.getMapping(), self, ['period', 'record', 'recordTotal']);
			if(data != undefined){
				self.period = data['period'];
			}

			self.hasVisibleFootnotes = ko.computed(function() {
				return (_.filter(self.footnotes(), function(footnote) {
					return footnote.visible();
				}).length > 0);
			});

			self.sectionType = ko.computed(function() {
				if (!self.period) {
					return LifeCycle.msgs.msg_footnote_type_record;
				} else if (self.period) {
					return LifeCycle.msgs.msg_footnote_type_period;
				}
				return '';
			});

			self.id = ko.computed(function() {
				if (self.sectionType() == LifeCycle.msgs.msg_footnote_type_record) {
					return LifeCycle.msgs.msg_footnote_type_record;
				} else if (self.sectionType() == LifeCycle.msgs.msg_footnote_type_period) {
					return ko.unwrap(self.period.recordId());
				}

				return '';
			});

			self.orderedFootnotes = ko.computed(function() {
				return self.footnotes().sort(function(l, r) {
					if (!l.recordTotal) { return -1; }
					else if (!r.recordTotal) { return 1; }
					else {
						if (l.recordTotal.rowNumber() > r.recordTotal.rowNumber()) {
							return 1;
						} else if (l.recordTotal.rowNumber() < r.recordTotal.rowNumber()) {
							return -1;
						} else {
							if (!l.record) { return -1; }
							else if (!r.record) { return 1; }
							else {
								if (l.record.rowNumber() == r.record.rowNumber()) {
									if (l.date() > r.date()) { return 1; }
									else { return -1; }
								}
								else if (l.record.rowNumber() > r.record.rowNumber()) { return 1; }
								else { return -1; }
							}
						}
					}
				});
			});

			var _generatePeriodHeaderText = function(period) {
				return ko.unwrap(period.displayStatementDate) + ' (' +
					ko.unwrap(period.displayNumberOfPeriods) + '): ' +
					ko.unwrap(period.source);
			};

			self.sectionTitle = ko.computed(function() {
				if (self.sectionType() == LifeCycle.msgs.msg_footnote_type_record) {
					return LifeCycle.msgs.msg_footnote_section_records;
				} else if (self.sectionType() == LifeCycle.msgs.msg_footnote_type_period) {
					return _generatePeriodHeaderText(self.period);
				}

				return '';
			});

			self.visible(!self.period || (self.period && ko.unwrap(self.period.selected)));

			self.onPeriodSelectionChanged = function(periodData) {
				if (periodData && self.id() == ko.unwrap(periodData.recordId)) {
					var value = ko.unwrap(periodData.selected);
					if (_.isObject(value)) {
						self.visible(value);
					}
				}
			};

			app.subscribe('SPREAD.Spreads.Column_Selection_Changed', self.onPeriodSelectionChanged);

			return self;
		};

		// This model extends
		app.Footnote = function(data) {
			var self = this;
			var defaultData = _.extend({
					'displayDate': '',
					'message': '',
					'user': {},
					'visible': false
				},
				defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			_mapWithPremappedProperties(defaultData, app.getMapping(), self, ['period', 'record', 'recordTotal']);

			if(data != undefined){
				self.period = data['period'];
				self.record = data['record'];
				self.recordTotal = data['recordTotal'];
			}

			self.sectionType = ko.computed(function() {
				if (self.period && self.record) {
					return LifeCycle.msgs.msg_footnote_type_record_value;
				} else if (self.record) {
					return LifeCycle.msgs.msg_footnote_type_record;
				} else if (self.period) {
					return LifeCycle.msgs.msg_footnote_type_period;
				}
				return '';
			});

			self.title = ko.computed(function() {
				if (self.sectionType() == LifeCycle.msgs.msg_footnote_type_record_value ||
					self.sectionType() == LifeCycle.msgs.msg_footnote_type_record) {

					return ko.unwrap(self.record.name);
				} else if (self.sectionType() == LifeCycle.msgs.msg_footnote_type_period) {
					return LifeCycle.msgs.msg_footnote_type_period;
				}

				return '';
			});

			self.visible(!self.record ||
				(self.record && ko.unwrap(self.record.includeInTotal)) ||
				(self.record.recordTotal && ko.unwrap(self.record.recordTotal.includeInTotal)));

			self.onRecordSelectionChanged = function(record) {
				if (self.record && self.record.recordId() == record.id) {
					self.record.includeInTotal(record.include_in_total);
					if (!self.record.recordTotal.includeInTotal) {
						self.record.recordTotal.includeInTotal = ko.observable();
					}
					self.record.recordTotal.includeInTotal(record.total_group_include_in_total);
					self.visible(record.include_in_total && record.total_group_include_in_total);
				}
			};

			self.onGroupSelectionChanged = function(recordTotal) {
				if (self.record &&
					ko.unwrap(self.record.recordTotal.recordId) == ko.unwrap(recordTotal.recordId)) {

					self.visible(ko.unwrap(self.record.includeInTotal) && ko.unwrap(recordTotal.includeInTotal));
				}
			};

			app.subscribe('SPREAD.Spreads.Record_Selection_Changed', self.onRecordSelectionChanged);
			app.subscribe('SPREAD.Spreads.Group_Selection_Changed', self.onGroupSelectionChanged);

			return self;
		};

		app.FootnoteConfiguration = function(data) {
			var self = this;
			var defaultData = _.extend({
					'showFootnotes': true
				}, defaultModelData);
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.onConfigurationChanged = function(data) {
				if (data['name'] === LifeCycle.msgs.msg_configuration_show_footnotes) {
					self.showFootnotes(data['value']);
				}
			};

			app.subscribe('SPREAD.Spreads.Configuration_Changed', self.onConfigurationChanged);

			return self;
		};

		app.setMapping({
			'footnotes': {
				create: function(options){
					return new app.Comment(options.data);
				}
			},
			'footnoteSections': {
				create: function(options){
					return new app.FootnoteSection(options.data);
				}
			},
			'footnoteConfiguration': {
				create: function(options){
					return new app.FootnoteConfiguration(options.data);
				}
			}
		});
		app.log('Models initialized.');
	};
	if(LifeCycle.SpreadFootnotes == undefined){
		LifeCycle.SpreadFootnotes = {};
	}
	if(LifeCycle.SpreadFootnotes.Models == undefined){
		LifeCycle.SpreadFootnotes.Models = Models;
	}
})();

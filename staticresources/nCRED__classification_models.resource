(function () {
	var Models = function (event, app) {
		var defaultModelData = {
			recordId: null,
			name: '',
			isLoaded: false,
			isSaved: false,
			disabled: false
		};

		/**
		 * @typedef {app.Classification} KOClassification
		 * @implements IForceKO
		 * @type Object
		 *
		 * @property {function(): string} category
		 * @property {function(): string} lookupKey
		 * @property {function(): Array<KOSpreadRecordClassification>} spreadRecordClassifications
		 * @property {function(): Array<KOSpreadRecordTotalClassification>} spreadRecordTotalClassifications
		 *
		 * @returns {KOClassification}
		 * @constructor
		 */
		app.Classification = function (data, shallow) {
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('classification'),
				category: '',
				lookupKey: ''
			}, defaultModelData);
			if (data) {
				_.extend(defaultData, data);
			}
			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, app.getMapping(), self);
			}

			self.spreadRecordClassifications  = ko.observableArray();
			self.spreadRecordTotalClassifications  = ko.observableArray();

			return self;
		};

		/**
		 * @typedef {app.SpreadRecordClassification} KOSpreadRecordClassification
		 * @implements IForceKO
		 * @type Object
		 *
		 * @property {KOClassification} classification
		 * @property {KORecord} record
		 *
		 * @returns {KOSpreadRecordClassification}
		 * @constructor
		 */
		app.SpreadRecordClassification = function (data, shallow) {
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('spreadRecordClassification'),
				classification: {},
				record: {},
			}, defaultModelData);
			if (data) {
				_.extend(defaultData, data);
			}
			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, app.getMapping(), self);
			}

			return self;
		};

		/**
		 * @typedef {app.SpreadRecordTotalClassification} KOSpreadRecordTotalClassification
		 * @implements IForceKO
		 * @type Object
		 *
		 * @property {KOClassification} classification
		 * @property {KORecordTotal} recordTotal
		 *
		 * @returns {KOSpreadRecordTotalClassification}
		 * @constructor
		 */
		app.SpreadRecordTotalClassification = function (data, shallow) {
			var self = this;
			var defaultData = _.extend({
				apexType: app.mapApexFromModel('spreadRecordTotalClassification'),
				classification: {},
				recordTotal: {}
			}, defaultModelData);
			if (data) {
				_.extend(defaultData, data);
			}
			if (shallow) {
				self = ko.viewmodel.fromModel(defaultData);
			} else {
				app.mapFromJS(defaultData, app.getMapping(), self);
			}

			return self;
		};

		app.setMapping({
			'classification': {
				create: function (options) {
					return new app.Classification(options.data, options.useViewModelPlugin);
				}
			},
			'classifications': {
				create: function (options) {
					return new app.Classification(options.data, options.useViewModelPlugin);
				}
			},
			'spreadRecordClassification': {
				create: function (options) {
					return new app.SpreadRecordClassification(options.data, options.useViewModelPlugin);
				}
			},
			'spreadRecordClassifications': {
				create: function (options) {
					return new app.SpreadRecordClassification(options.data, options.useViewModelPlugin);
				}
			},
			'spreadRecordTotalClassification': {
				create: function (options) {
					return new app.SpreadRecordTotalClassification(options.data, options.useViewModelPlugin);
				}
			},
			'spreadRecordTotalClassifications': {
				create: function (options) {
					return new app.SpreadRecordTotalClassification(options.data, options.useViewModelPlugin);
				}
			}
		});

		app.setTypesMap({
			Classification: 'classification',
			SpreadRecordClassification: 'spreadRecordClassification',
			SpreadRecordTotalClassification: 'spreadRecordTotalClassification'
		});

		app.log('Classification Models initialized.');
	};

	if (!LifeCycle.Classification) {
		LifeCycle.Classification = {};
	}

	if (!LifeCycle.Classification.Models) {
		LifeCycle.Classification.Models = Models;
	}
})();

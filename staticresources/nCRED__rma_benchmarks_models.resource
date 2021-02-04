(function () {
	var Models = function (event, app) {
		var defaultModelData = {
			recordId: null,
			name: '',
			isLoaded: false,
			isSaved: false,
			disabled: false
		};

		app.RMATable = function (data) {
			var self = this;
			var defaultData = _.extend({
				historical: [],
				sales: [],
				assets: [],
				relationshipData: '',
				cashAndEquivalentsWarnings: [],
				totalCurrentAssetsWarnings: [],
				totalAssetsWarnings: [],
				totalCurrentLiabilitiesWarnings: [],
				totalLiabilitiesWarnings: [],
				totalEquityWarnings: [],
				totalLiabilitiesAndNetWorthWarnings: [],
				profitBeforeTaxesWarnings: [],
				currentRatioWarnings: [],
				quickRatioWarnings: [],
				salesToReceivablesWarnings: [],
				costOfSalesToInventoryWarnings: [],
				costOfSalesToPayablesWarnings: [],
				salesToWorkingCapitalWarnings: [],
				ebitToInterestWarnings: [],
				cashFlowToDebtWarnings: [],
				fixedToWorthWarnings: [],
				debtToWorthWarnings: [],
				profitToNetWorthWarnings: [],
				profitToTotalAssetsWarnings: [],
				salesToFixedAssetsWarnings: [],
				salesToTotalAssetsWarnings: [],
				depreciationToSalesWarnings: [],
				compToSalesWarnings: [],
				netSalesWarnings: [],
				assetsWarnings: []
			}, defaultModelData);
			if (data !== undefined) {
				_.extend(defaultData, data);
			}

			app.mapFromJS(defaultData, {}, self);

			self._getRowValues = function(rowName, dataSet) {
				var values = [];
				if (Array.isArray(self[dataSet]())) {
					for (var i = 0; i < self[dataSet]().length; i++) {
						var column = self[dataSet]()[i];
						if (column[rowName]()) {
							var rmaValue = parseInt(column[rowName]());
							if (isNaN(rmaValue)) {
								values.push('');
							} else {
								values.push(rmaValue);
							}
						} else {
							values.push('');
						}
					}
				}
				return values;
			};

			self.getSizingCodeForDataSet = function(dataSet) {
				var sizingScales = [];
				if (Array.isArray(self[dataSet]())) {
					for (var i = 0; i < self[dataSet]().length; i++) {
						var column = self[dataSet]()[i];
						switch (dataSet) {
							case 'sales':
								 sizingScales.push(self.getSizingForSalesColumns(column.SizeCd()));
								 break;
							case 'assets':
								  sizingScales.push(self.getSizingForAssetColumns(column.SizeCd()));
								  break;
							case 'historical':
								 sizingScales.push('All');
								 break;
							default:
								 sizingScales.push(column.SizeCd());
						}
					}
				}
				return sizingScales;
			};

			self.getSizingForSalesColumns = function(sizingCode) {
				switch (sizingCode) {
					case 1:
						return '0-1' + LifeCycle.msgs.msg_selected_scale_millions;
					case 2:
						return '1' + LifeCycle.msgs.msg_selected_scale_millions + '-3' + LifeCycle.msgs.msg_selected_scale_millions;
					case 3:
						return '3' + LifeCycle.msgs.msg_selected_scale_millions + '-5' + LifeCycle.msgs.msg_selected_scale_millions;
					case 4:
						return '5' + LifeCycle.msgs.msg_selected_scale_millions + '-10' + LifeCycle.msgs.msg_selected_scale_millions;
					case 5:
						return '10' + LifeCycle.msgs.msg_selected_scale_millions + '-25' + LifeCycle.msgs.msg_selected_scale_millions;
					case 6:
						return '25' + LifeCycle.msgs.msg_selected_scale_millions + ' & Over';
					case 7:
						return 'All Companies';
					default:
						return 'Size Not Found';
				}
			};

			self.getSizingForAssetColumns = function(sizingCode) {
				switch (sizingCode) {
					case 1:
						return '0 - 500' + LifeCycle.msgs.msg_selected_scale_thousands;
					case 2:
						return '500' + LifeCycle.msgs.msg_selected_scale_thousands + '-2' + LifeCycle.msgs.msg_selected_scale_millions;
					case 3:
						return '2' +  LifeCycle.msgs.msg_selected_scale_millions + '-10' +  LifeCycle.msgs.msg_selected_scale_millions;
					case 4:
						return '10' +  LifeCycle.msgs.msg_selected_scale_millions + '-50' +  LifeCycle.msgs.msg_selected_scale_millions;
					case 5:
						return '50' + LifeCycle.msgs.msg_selected_scale_millions + '-100' +  LifeCycle.msgs.msg_selected_scale_millions;
					case 6:
						return '100' + LifeCycle.msgs.msg_selected_scale_millions + '-250' +  LifeCycle.msgs.msg_selected_scale_millions;
					case 7:
						return 'All Companies';
					default:
						return 'Size Not Found';
				}
			};


			self.getValuesAsRatios = function(rowName, dataSet) {
				var rowValues = self._getRowValues(rowName, dataSet);
				return _.map(
					rowValues,
					function(value) {
						if (value == '') {
							return value;
						} else {
							return LifeCycle.SpreadData.FormattingService.formatRatioForDisplay(
								value,
								{decimalPlaces: 1});
						}
					}
				);
			};

			return self;
		};

		app.RMAColumn = function (data) {
			var self = this;
			var defaultData = _.extend({
				PubYear: '',
				Sector: '',
				IndCd: '',
				Region: '',
				Sectionn: '',
				SizeCd: '',
				StmtCnt: '',
				Unqualified: '',
				Reviewed: '',
				Compiled: '',
				TaxRtrn: '',
				Other: '',
				Cash: '',
				Artrade: '',
				Inv: '',
				Aocurra: '',
				Totcurra: '',
				Fixeda: '',
				Intang: '',
				Aononcurra: '',
				Totala: '',
				Notespy: '',
				Currmat: '',
				Aptrade: '',
				Aptax: '',
				Aocurrl: '',
				Totcurrl: '',
				Ltd: '',
				Deftax: '',
				Aononcurrl: '',
				Netwrth: '',
				Totallnw: '',
				Sales: '',
				Grproft: '',
				Opexp: '',
				Opproft: '',
				Aoexp: '',
				Proftbtax: '',
				CurrH: '',
				CurrM: '',
				CurrL: '',
				QuickH: '',
				QuickM: '',
				QuickL: '',
				SalesarH: '',
				SalesarM: '',
				SalesarL: '',
				CosinvH: '',
				CosinvM: '',
				CosinvL: '',
				CosapH: '',
				CosapM: '',
				CosapL: '',
				SaleswcapH: '',
				SaleswcapM: '',
				SaleswcapL: '',
				EbitintH: '',
				EbitintM: '',
				EbitintL: '',
				CflowcdebtH: '',
				CflowcdebtM: '',
				CflowcdebtL: '',
				FixedwrthH: '',
				FixedwrthM: '',
				FixedwrthL: '',
				DebtwrthH: '',
				DebtwrthM: '',
				DebtwrthL: '',
				PbttnwH: '',
				PbttnwM: '',
				PbttnwL: '',
				PbttotassH: '',
				PbttotassM: '',
				PbttotassL: '',
				SalesfixedH: '',
				SalesfixedM: '',
				SalesfixedL: '',
				SalestotassH: '',
				SalestotassM: '',
				SalestotassL: '',
				DdasalesH: '',
				DdasalesM: '',
				DdasalesL: '',
				OffcompsalesH: '',
				OffcompsalesM: '',
				OffcompsalesL: '',
				SalesarDH: '',
				SalesarDM: '',
				SalesarDL: '',
				CosinvDH: '',
				CosinvDM: '',
				CosinvDL: '',
				CosapDH: '',
				CosapDM: '',
				CosapDL: '',
				QuickCnt: '',
				EbitintCnt: '',
				CflowcdebtCnt: '',
				PbttnwCnt: '',
				DdasalesCnt: '',
				OffcompsalesCnt: '',
				DllrSales: '',
				DllrAssets: ''
			}, defaultModelData);
			if (data !== undefined) {
				_.extend(defaultData, data);
			}

			app.mapFromJS(defaultData, {}, self);

			self.historicalYearDisplayText = ko.computed(function() {
				return (parseInt(self.PubYear()) - 5) + parseInt(self.SizeCd());
			});
			return self;
		};

		app.setMapping({
			industryBenchmarks: {
				create: function (options) {
					return new app.RMAColumn(options.data);
				}
			}
		});

	};

	if (LifeCycle.RmaBenchmarks === undefined) {
		LifeCycle.RmaBenchmarks = {};
	}

	if (LifeCycle.RmaBenchmarks.Models === undefined) {
		LifeCycle.RmaBenchmarks.Models = Models;
	}

})();

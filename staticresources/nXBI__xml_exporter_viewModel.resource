(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;

			var defaultData = {
				apiData: {},
				data: {},
				actions: {
					saveExtract: null
				},
				extract: {
					content: null,
					isMapped: false,
					name: "extract.xml",
					id: null
				},
				metadata: {
					declaration: "<?xml version='1.0' encoding='UTF-8'?>",
					protocol: "data:application/xml;charset=UTF-8;base64,"
				},
				service: {
					action: function(){},
					arguments: []
				}
			};
			if(!_.isUndefined(data)){
				if(!_.isUndefined(data.data)){
					_.extend(defaultData.data, data.data);
				}
				if(!_.isUndefined(data.actions)){
					_.extend(defaultData.actions, data.actions);
				}
				if(!_.isUndefined(data.extract)){
					_.extend(defaultData.extract, data.extract);
				}
				if(!_.isUndefined(data.metadata)){
					_.extend(defaultData.metadata, data.metadata);
				}
				if(!_.isUndefined(data.service)){
					_.extend(defaultData.service, data.service);
				}
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.performingAjax = ko.computed({
				read: function(){
					return app.performingAjax();
				},
				deferEvaluation: true
			});

			// error message displayed on page
			self.errorMsg = ko.computed({
				read: function(){
					return app.log.errorMsg();
				},
				deferEvaluation: true
			});

			var converter = new X2JS();
			self.convertToXml = function(data){
				return converter.json2xml_str(data);
			};
			self.load = function(){
				app.performingAjax(true);
				self.service.arguments.push(function(result){
					app.mapFromJS({ apiData: result }, app.getMapping(), self);

					// Move to a function that can be called on demand from the FLO application:
					app.mapFromJS({ data: result }, app.getMapping(), self);

					self.extract.isMapped(true);

					app.performingAjax(false);
				});
				self.service.arguments.push(app.log.failure);
				self.service.action.apply(self, self.service.arguments);
			};

			self.loanDefaultValues = function(){
				return {
					loanDefaults: {
						loanNumber: "",
						typeCode: "",
						branchId: "",
						officerName: "",
						purpose: "",
						status: "",
						ficoTimestamp: "",
						ficoScore: "",
						amount: "",
						interestRate: "",
						spread: "",
						rateFloor: "",
						rateCeiling: "",
						closeTimestamp: "",
						interestRateAdjustmentFrequency: "",
						nextPaymentDueTimestamp: "",
						termMonths: "",
						maturityTimestamp: "",
						amortizedTermMonths: "",
						monthlyPayment: "",
						nextInterestPaymentTimestamp: "",
						paymentSchedule: "",
						isBalloon: "",
						balloonPayment: "",
						paymentType: "",
						pricingBasis: ""
					},
					relationshipDefaults: {
						entityType: ""
					}
				};
			};

			self.loadView = function(){
				return app.view;
			};

			self.saveExtract = function() {
				self.extract.content(self.metadata.declaration()
					+ self.convertToXml(app.mapToJS(self.data)));

				self.remoteSaveAttachment(function(id, event) {
					if (event.status) {
						self.extract.id(id);

						self.downloadExtract();
					}
				});
			};

			self.downloadExtract = function() {
				if(self.extract.id() != undefined && self.extract.id() != null){
					window.location = '/servlet/servlet.FileDownload?file=' + self.extract.id();
				}
			};

			self.remoteSaveAttachment = function(callback){
				Visualforce.remoting.Manager.invokeAction(
					self.actions.saveExtract(),
					self.extract.name(),
					self.extract.content(),
					self.apiData.recordId(),
					callback
				);
			}

			app.log('Exporter.Xml ViewModel instantiated.');
			return self;
		};
		app.setMapping({
			"copy": [ "service" ]
		});
		app.log('Exporter.Xml ViewModel initialized.');
	};
	if(LifeCycle.DataServices.Exporter.Xml.ViewModel == undefined){
		LifeCycle.DataServices.Exporter.Xml.ViewModel = ViewModel;
	}
}());

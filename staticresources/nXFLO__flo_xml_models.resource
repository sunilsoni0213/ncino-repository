(function(){
	var Models = function(event, app){
		if(app.Flo == undefined){
			app.Flo = {};
		}
		if(app.Flo.Xml == undefined){
			app.Flo.Xml = {};
		}
		app.Flo.Xml.Metadata = function(){
			var self = this;
			self.mapFromJS = function(data){
				return app.mapFromJS(_.extend({
					"xmlns:xsi": "",
					"xmlns:tns": "",
					"xsi:schemaLocation": "",
					"fiid": "",
					"version": "",
					"source": ""
				}, data), app.getMapping(), self);
			};
			return self;
		};
		// Metadata does not need 'tns' prefix
		app.Flo.Xml.Element = function(){
			var self = this;
			self.mapFromJS = function(data){
				return app.mapFromJS(data, app.getMapping(), self);
			};
			self.mapFromJS({
				"__prefix": "tns"
			});
			return self;
		};
		app.Flo.Xml.AccountOpeningStatus = function(){
			var self = this;
			self.CLOSING = "Closing";
			self.OPEN = "Open";
			self.isOpen = function(value){
				return _.isString(value) && !_.isEmpty(value)
					&& value.search(new RegExp(self.OPEN, "i")) != -1;
			};
			self.translate = function(value){
				return self.isOpen(value) ? self.CLOSING : "";
			};
			return self;
		};
		// AccountOpeningStatus does not need 'tns' prefix
		app.Flo.Xml.Address = function(){
			var self = this;
			self.mapFromJS = function(data){
				return app.mapFromJS({
					"_country": data.country || "",
					"_primary": data.primary,
					"_mailing": data.mailing,
					"USAddress": data
				}, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.Address.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.Addresses = function(){
			var self = this;
			self.mapFromJS = function(data){
				var addresses = [];
				if(data.isIndividual){
					if(!_.isUndefined(data.primaryContact.mailingAddress)
							&& !_.isUndefined(data.primaryContact.mailingAddress.street)){
						addresses.push(_.extend({
							"primary": true,
							"mailing": true
						}, data.primaryContact.mailingAddress));
					}
					if(!_.isUndefined(data.primaryContact.otherAddress)
							&& !_.isUndefined(data.primaryContact.otherAddress.street)){
						addresses.push(_.extend({
							"primary": addresses.length == 0,
							"mailing": addresses.length == 0
						}, data.primaryContact.otherAddress));
					}
				}else{
					if(!_.isUndefined(data.billingAddress)
							&& !_.isUndefined(data.billingAddress.street)){
						addresses.push(_.extend({
							"primary": true,
							"mailing": true
						}, data.billingAddress));
					}
					if(!_.isUndefined(data.shippingAddress)
							&& !_.isUndefined(data.shippingAddress.street)){
						addresses.push(_.extend({
							"primary": addresses.length == 0,
							"mailing": addresses.length == 0
						}, data.shippingAddress));
					}
				}
				return app.mapFromJS({ "address": addresses }, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.Addresses.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.AdjustableRate = function(){
			var self = this;
			self.mapFromJS = function(data){
				return app.mapFromJS({
					"_proceedsAmount": data.amount || "",
					"_numberOfPayments": data.totalMonthlyPayment || "",
					"_frequencyOfPayments": data.paymentSchedule || "",
					"_interestRate": Utils.setScaleString(data.interestRate),
					"_interestRateMargin": Utils.setScaleString(data.spread),
					"_interestRateFloor": Utils.setScaleString(data.rateFloor),
					"_interestRateCeiling": Utils.setScaleString(data.rateCeiling),
					"_lateChargeRoutine": "", // no mapping
					"_loanDate": data.closeTimestamp || "",
					"_fundingDate": data.closeTimestamp || "",
					"_rateChangeFrequency": data.interestRateAdjustmentFrequency || "",
					"_rateChangeDate": "", // no mapping
					"_rateChangeFrequencyText": "", // no mapping
					"_paymentChangeFrequency": "", // no mapping
					"_paymentChangeDate": "", // no mapping
					"_paymentChangeFrequencyText": "", // no mapping
					"_multipleAdvanceFlag": "", // no mapping
					"_initialAdvanceAmount": "", // no mapping
					"_variableRate": "", // no mapping
					"_teaserInterestRate": "", // no mapping
					"_teaserNumberOfPayments": "", // no mapping
					"_annualRateAdjustmentCap": "", // no mapping
					"renewals": { "renewalItem": data.renewedLoans }
				}, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.AdjustableRate.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.Applications = function(){
			var self = this;
			self.mapFromJS = function(data){
				return app.mapFromJS(_.extend({
					"_xmlns:xsi": app.viewModel.metadata["xmlns:xsi"](),
					"_xmlns:tns": app.viewModel.metadata["xmlns:tns"](),
					"_xsi:schemaLocation": app.viewModel.metadata["xsi:schemaLocation"](),
					"_fiid": app.viewModel.metadata["fiid"](),
					"_version": app.viewModel.metadata["version"](),
					"_source": app.viewModel.metadata["source"]()
				}, data), app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.Applications.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.Balloon = function(){
			var self = this;
			self.mapFromJS = function(data){
				return app.mapFromJS({
					"_proceedsAmount": data.amount || "",
					"_numberOfPayments": data.totalMonthlyPayment || "",
					"_frequencyOfPayments": data.paymentSchedule || "",
					"_interestRate": Utils.setScaleString(data.interestRate),
					"_interestRateMargin": Utils.setScaleString(data.spread),
					"_interestRateFloor": Utils.setScaleString(data.rateFloor),
					"_interestRateCeiling": Utils.setScaleString(data.rateCeiling),
					"_lateChargeRoutine": "", // no mapping
					"_loanDate": data.closeTimestamp || "",
					"_fundingDate": data.closeTimestamp || "",
					"_rateChangeFrequency": data.interestRateAdjustmentFrequency || "",
					"_rateChangeDate": "", // no mapping
					"_rateChangeFrequencyText": "", // no mapping
					"_paymentChangeFrequency": "", // no mapping
					"_paymentChangeDate": "", // no mapping
					"_paymentChangeFrequencyText": "", // no mapping
					"_multipleAdvanceFlag": "", // no mapping
					"_initialAdvanceAmount": "", // no mapping
					"_variableRate": "", // no mapping
					"_firstPaymentDate": data.nextPaymentDueTimestamp || "",
					"_amortizedNumberOfPayments": data.amortizedTermMonths || "",
					"_finalPaymentAmount": "", // no mapping
					"_regularPaymentAmount": data.monthlyPayment || "",
					"renewals": { "renewalItem": data.renewedLoans }
				}, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.Balloon.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.BranchCode = function(){
			var self = this;
			self.translate = function(value){
				return _.isString(value) && !_.isEmpty(value)
						&& value.search(/^[1-9][0-9]{0,2}$/) != -1
						? value : "";
			};
			return self;
		};
		// BranchCode does not need 'tns' prefix
		app.Flo.Xml.Business = function(){
			var self = this;
			self.mapFromJS = function(data){
				return app.mapFromJS({
					"customerName": { "businessName": data },
					"taxID": data,
					"addresses": data,
					"faxTelephone": { number: data.fax || "" },
					"businessTelephone": { number: data.phone || "" },
					"creditScores": { creditScore: [ data ] },
					"internetAddress": data
				}, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.Business.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.BusinessName = function(){
			var self = this;
			self.mapFromJS = function(data){
				return app.mapFromJS({
					"_name": data.name || "",
					"_dbaaka": "" // no mapping
				}, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.BusinessName.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.BusinessOrConsumer = function(){
			var self = this;
			self.BUSINESS = "Business";
			self.CONSUMER = "Consumer";
			self.INDIVIDUAL = "Individual";
			self.isIndividual = function(value){
				return _.isString(value) && !_.isEmpty(value)
						&& value.search(new RegExp(self.INDIVIDUAL, "i")) != -1;
			};
			self.translate = function(value){
				return self.isIndividual(value) ? self.CONSUMER : self.BUSINESS;
			};
			return self;
		};
		// BusinessOrConsumer does not need 'tns' prefix
		app.Flo.Xml.Calculation = function(){
			var self = this;
			self.ADJUSTABLE_RATE = "Adjustable Rate";
			self.BALLOON = "Balloon";
			self.DEFINED_SCHEDULE = "Defined Schedule";
			self.FREE_FORM = "Free Form";
			self.INSTALLMENT = "Installment";
			self.INTEREST_ONLY = "Interest Only";
			self.PRINCIPAL_PLUS = "Principal Plus";
			self.PRINCIPAL_PLUS_INTEREST = "Principal+Interest";
			self.SINGLE_PAY = "Single Pay";
			self.translate = function(type){
				var name = type;
				if(!_.isString(name) || _.isEmpty(name)){
					return "";
				}
				switch(type){
					case self.ADJUSTABLE_RATE:
					case self.BALLOON:
					case self.DEFINED_SCHEDULE:
					case self.FREE_FORM:
					case self.INSTALLMENT:
					case self.INTEREST_ONLY:
					case self.PRINCIPAL_PLUS:
					case self.SINGLE_PAY:
						// do nothing
						break;
					case self.PRINCIPAL_PLUS_INTEREST:
						name = self.PRINCIPAL_PLUS;
						break;
					default:
						name = self.FREE_FORM;
						break;
				}
				return (name.charAt(0).toLowerCase() + name.slice(1)).replace(/[\s]/g, "");
			};
			self.mapFromJS = function(data){
				var calculation = {};
				calculation[self.translate(data.paymentType)] = data;
				return app.mapFromJS(calculation, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.Calculation.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.Collateral = function(){
			var self = this;
			self.filter = function(item){
				return !_.isEmpty(this.translate(item.assetSubtype));
			};
			self.mapFromJS = function(data){
				if(_.isEmpty(data.collateralItem)){
					return self;
				}
				data.collateralItem = _.filter(
						_.isArray(data.collateralItem) ? data.collateralItem : [ data.collateralItem ],
						self.filter, new app.Flo.Xml.CollateralItem());
				return app.mapFromJS(data, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.Collateral.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.CollateralItem = function(){
			var self = this;
			self.AIRCRAFT = "Aircraft";
			self.ALL_ASSETS = "All Assets";
			self.AS_EXTRACTED = "As Extracted";
			self.CHATTEL_PAPER = "Chattel Paper";
			self.COMMERCIAL_REAL_ESTATE = "Commercial Real Estate";
			self.COMMERCIAL_REAL_ESTATE_RESIDENTIAL = "Commercial Real Estate Residential";
			self.CONSTRUCTION = "Commercial Real Estate Construction";
			self.CONSUMER_REAL_ESTATE_CONSTRUCTION = "Consumer Real Estate Construction";
			self.CONSUMER_REAL_ESTATE_NON_PURCHASE = "Consumer Real Estate Non Purchase";
			self.CONSUMER_REAL_ESTATE_PORTFOLIO = "Consumer Real Estate Portfolio";
			self.EQUIPMENT = "Equipment";
			self.EXISTING_COLLATERAL = "Existing Collateral";
			self.FARM_EQUIPMENT = "Farm Equipment";
			self.FARM_PRODUCTS = "Farm Products";
			self.FIXTURES = "Fixtures";
			self.GENERAL_INTANGIBLES = "General Intangibles";
			self.HOUSEHOLD_GOODS = "Household Goods";
			self.INVENTORY = "Inventory";
			self.LIFE_INSURANCE = "Life Insurance";
			self.MOBILE_HOME = "Mobile Home";
			self.MOTOR_VEHICLE = "Motor Vehicle";
			self.NON_TITLED_PERSONAL_PROPERTY = "Non Titled Personal Property";
			self.NOTE_INSTRUMENT = "Instruments";
			self.PLEASURE_BOAT = "Watercraft";
			self.RECEIPTS_BILLS = "Accounts Receivable";
			self.RECREATIONAL_VEHICLE = "Recreational Vehicle";
			self.SAVINGS_CDS = "Assignment Of Deposit Account";
			self.SECURITIES = "Investment Instrument";
			self.SHIP = "Documented Vessel";
			self.STANDING_TIMBER = "Standing Timber";
			self.key = function(value){
				return !_.isString(value) || _.isEmpty(value)
						? undefined : value.toUpperCase().replace(/[\W]/g, "_");
			};
			self.translate = function(value){
				var key = self.key(value);
				return _.isUndefined(key) || _.isUndefined(self[key]) ? ""
						: (self[key].charAt(0).toLowerCase() + self[key].slice(1)).replace(/[\s]/g, "");
			};
			self.mapFromJS = function(data){
				var collateral = {
					"_id": data.recordId,
					"_referenceNumber": "", // no mapping
					"_servicingSystemID": "" // no mapping
				};
				collateral[self.translate(data.assetSubtype)] = data;
				return app.mapFromJS(collateral, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.CollateralItem.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.CollateralBaseType = function(){
			var self = this;
			self.mapFromJS = function(data){
				var collateral = {
					"description": { "__text": data.description || "" },
					"value": { "__text": data.value || "" },
					"valuationDate": { timestamp: data.appraisalTimestamp || "" }
				};
				if(!_.isUndefined(data.address) && !_.isUndefined(data.address.street)){
					collateral.address = data.address;
				}
				return app.mapFromJS(collateral, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.CollateralBaseType.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.CreditScore = function(){
			var self = this;
			self.mapFromJS = function(data){
				return app.mapFromJS({
					"_reportingDate": data.ficoTimestamp || "",
					"_score": data.ficoScore || "",
					"_scoreModel": "", // no mapping
					"_scoreRangeFrom": "", // no mapping
					"_scoreRangeTo": "", // no mapping
					"_notUsedInDenialFlag": "" // no mapping
				}, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.CreditScore.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.Customer = function(){
			var self = this;
			self.PARTNERSHIP = "Partnership";
			self.GENERAL_PARTNERSHIP = "General " + self.PARTNERSHIP;
			self.LIMITED_PARTNERSHIP = "Limited " + self.PARTNERSHIP;
			self.LIMITED_LIABILITY_PARTNERSHIP = "Limited Liability " + self.PARTNERSHIP;
			self.isLimitedPartnership = function(value){
				return !_.isEmpty(value) && value.search(new RegExp(self.LIMITED_PARTNERSHIP, "i")) != -1;
			};
			self.isLimitedLiabilityPartnership = function(value){
				return !_.isEmpty(value) && value.search(new RegExp(self.LIMITED_LIABILITY_PARTNERSHIP, "i")) != -1;
			};
			self.isPartnership = function(value){
				return !_.isEmpty(value) && value.search(new RegExp(self.PARTNERSHIP, "i")) != -1;
			};
			self.translate = function(entity, partnership){
				var name = entity;
				if(self.isPartnership(entity)){
					if(self.isLimitedPartnership(partnership)){
						name = self.LIMITED_PARTNERSHIP;
					}else if(self.isLimitedLiabilityPartnership(partnership)){
						name = self.LIMITED_LIABILITY_PARTNERSHIP;
					}else{
						name = self.GENERAL_PARTNERSHIP;
					}
				}
				return _.isEmpty(name) ? "" : (name.charAt(0).toLowerCase() + name.slice(1)).replace(/[\s]/g, "");
			};
			self.mapFromJS = function(data){
				var customer = {
					"_id": data.recordId,
					"_referenceNumber": data.recordId,
					"_servicingSystemID": data.relationship.cifNumber || ""
				};
				customer[self.translate(
						data.relationship.entityType,
						data.relationship.partnershipType)] = data.relationship;
				return app.mapFromJS(customer, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.Customer.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.Date = function(){
			var self = this;
			self.DATE_DELIMITER = "-";
			self.MONTH_OFFSET = 1;
			self.format = function(timestamp){
				if (timestamp === null || timestamp === undefined || timestamp.length < 13) {
					return timestamp;
				}
				var local = Utils.convertGmtTimestampToLocalDate(timestamp);
				var month = ((local.getMonth() + this.MONTH_OFFSET) < 10)
					? '0' + (local.getMonth() + this.MONTH_OFFSET)
					: (local.getMonth() + this.MONTH_OFFSET)
				var date = (local.getDate() < 10) ? '0' + local.getDate() : local.getDate();
				return _.isNull(local) ? local
						: local.getFullYear() + this.DATE_DELIMITER
						+ month + this.DATE_DELIMITER + date;
			};
			self.mapFromJS = function(data){
				return app.mapFromJS({
					"__text": self.format(data.timestamp)
				}, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.Date.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.DefinedSchedule = function(){
			var self = this;
			self.mapFromJS = function(data){
				return app.mapFromJS({
					"_proceedsAmount": data.amount || "",
					"_numberOfPayments": data.totalMonthlyPayment || "",
					"_frequencyOfPayments": data.paymentSchedule || "",
					"_interestRate": Utils.setScaleString(data.interestRate),
					"_interestRateMargin": Utils.setScaleString(data.spread),
					"_interestRateFloor": Utils.setScaleString(data.rateFloor),
					"_interestRateCeiling": Utils.setScaleString(data.rateCeiling),
					"_lateChargeRoutine": "", // no mapping
					"_loanDate": data.closeTimestamp || "",
					"_fundingDate": data.closeTimestamp || "",
					"_rateChangeFrequency": data.interestRateAdjustmentFrequency || "",
					"_rateChangeDate": "", // no mapping
					"_rateChangeFrequencyText": "", // no mapping
					"_paymentChangeFrequency": "", // no mapping
					"_paymentChangeDate": "", // no mapping
					"_paymentChangeFrequencyText": "", // no mapping
					"_multipleAdvanceFlag": "", // no mapping
					"_initialAdvanceAmount": "", // no mapping
					"_variableRate": "", // no mapping
					"renewals": { "renewalItem": data.renewedLoans }
				}, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.DefinedSchedule.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.FreeForm = function(){
			var self = this;
			self.mapFromJS = function(data){
				return app.mapFromJS({
					"_proceedsAmount": data.amount || "",
					"_numberOfPayments": data.totalMonthlyPayment || "",
					"_frequencyOfPayments": data.paymentSchedule || "",
					"_interestRate": Utils.setScaleString(data.interestRate),
					"_interestRateMargin": Utils.setScaleString(data.spread),
					"_interestRateFloor": Utils.setScaleString(data.rateFloor),
					"_interestRateCeiling": Utils.setScaleString(data.rateCeiling),
					"_lateChargeRoutine": "", // no mapping
					"_loanDate": data.closeTimestamp || "",
					"_fundingDate": data.closeTimestamp || "",
					"_rateChangeFrequency": data.interestRateAdjustmentFrequency || "",
					"_rateChangeDate": "", // no mapping
					"_rateChangeFrequencyText": "", // no mapping
					"_paymentChangeFrequency": "", // no mapping
					"_paymentChangeDate": "", // no mapping
					"_paymentChangeFrequencyText": "", // no mapping
					"_multipleAdvanceFlag": "", // no mapping
					"_initialAdvanceAmount": "", // no mapping
					"_variableRate": "", // no mapping
					"_maturityDate": data.maturityTimestamp || "",
					"_balloonPaymentFlag": data.isBalloon || "",
					"_balloonPaymentAmount": data.balloonPayment || "",
					"renewals": { "renewalItem": data.renewedLoans }
				}, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.FreeForm.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.Identification = function(){
			var self = this;
			self.TYPE_DRIVERS_LICENSE = "DriversLicense";
			self.mapFromJS = function(data){
				return app.mapFromJS({
					"_description": "", // no mapping
					"_issuedBy": "", // no mapping
					"_issuedDate": "", // no mapping
					"_expirationDate": "", // no mapping
					"_number": data.driversLicense || "",
					"_type": self.TYPE_DRIVERS_LICENSE,
					"_primary": "" // no mapping
				}, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.Identification.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.Individual = function(){
			var self = this;
			self.mapFromJS = function(data){
				var birthTimestamp = '';
				var homePhone = '';
				var mobilePhone = '';
				var fax = '';
				var phone = '';

				if (data.primaryContact != null || data.primaryContact != undefined) {
						birthTimestamp = data.primaryContact.birthTimestamp;
						homePhone = data.primaryContact.homePhone;
						mobilePhone = data.primaryContact.mobilePhone;
						fax = data.primaryContact.fax;
						phone = data.primaryContact.phone;
				}

				console.log("birthTimestamp: " + birthTimestamp);

				return app.mapFromJS({
					"customerName": { "individualName": data.primaryContact || "" },
					"dateOfBirth": { timestamp: birthTimestamp || "" },
					"taxID": data,
					"identifications": { "identification": [ data.primaryContact ] },
					"addresses": data,
					"homeTelephone": { number: homePhone || "" },
					"cellularTelephone": { number: mobilePhone || "" },
					"faxTelephone": { number: fax || "" },
					"businessTelephone": { number: phone || "" },
					"creditScores": { creditScore: [ data ] }
				}, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.Individual.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.IndividualName = function(){
			var self = this;
			self.mapFromJS = function(data){
				return app.mapFromJS({
					"_prefix": data.salutation || "",
					"_first": data.firstName || "",
					"_middle": "", // no mapping
					"_last": data.lastName || "",
					"_suffix": "", // no mapping
					"_dbaaka": "", // no mapping
					"_poaName": "", // no mapping
					"_poaDescription": "", // no mapping
				}, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.IndividualName.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.Installment = function(){
			var self = this;
			self.mapFromJS = function(data){
				return app.mapFromJS({
					"_proceedsAmount": data.amount || "",
					"_numberOfPayments": data.totalMonthlyPayment || "",
					"_frequencyOfPayments": data.paymentSchedule || "",
					"_interestRate": Utils.setScaleString(data.interestRate),
					"_interestRateMargin": Utils.setScaleString(data.spread),
					"_interestRateFloor": Utils.setScaleString(data.rateFloor),
					"_interestRateCeiling": Utils.setScaleString(data.rateCeiling),
					"_lateChargeRoutine": "", // no mapping
					"_loanDate": data.closeTimestamp || "",
					"_fundingDate": data.closeTimestamp || "",
					"_rateChangeFrequency": data.interestRateAdjustmentFrequency || "",
					"_rateChangeDate": "", // no mapping
					"_rateChangeFrequencyText": "", // no mapping
					"_paymentChangeFrequency": "", // no mapping
					"_paymentChangeDate": "", // no mapping
					"_paymentChangeFrequencyText": "", // no mapping
					"_multipleAdvanceFlag": "", // no mapping
					"_initialAdvanceAmount": "", // no mapping
					"_variableRate": "", // no mapping
					"_firstPaymentDate": data.nextPaymentDueTimestamp || "",
					"renewals": { "renewalItem": data.renewedLoans }
				}, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.Installment.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.InterestOnly = function(){
			var self = this;
			self.mapFromJS = function(data){
				return app.mapFromJS({
					"_proceedsAmount": data.amount || "",
					"_numberOfPayments": data.totalMonthlyPayment || "",
					"_frequencyOfPayments": data.paymentSchedule || "",
					"_interestRate": Utils.setScaleString(data.interestRate),
					"_interestRateMargin": Utils.setScaleString(data.spread),
					"_interestRateFloor": Utils.setScaleString(data.rateFloor),
					"_interestRateCeiling": Utils.setScaleString(data.rateCeiling),
					"_lateChargeRoutine": "", // no mapping
					"_loanDate": data.closeTimestamp || "",
					"_fundingDate": data.closeTimestamp || "",
					"_rateChangeFrequency": data.interestRateAdjustmentFrequency || "",
					"_rateChangeDate": "", // no mapping
					"_rateChangeFrequencyText": "", // no mapping
					"_paymentChangeFrequency": "", // no mapping
					"_paymentChangeDate": "", // no mapping
					"_paymentChangeFrequencyText": "", // no mapping
					"_multipleAdvanceFlag": "", // no mapping
					"_initialAdvanceAmount": "", // no mapping
					"_variableRate": "", // no mapping
					"_firstPaymentDate": data.nextPaymentDueTimestamp || "",
					"renewals": { "renewalItem": data.renewedLoans }
				}, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.InterestOnly.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.InternetAddress = function(){
			var self = this;
			self.mapFromJS = function(data){
				return app.mapFromJS({
					"__text": data.website
				}, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.InternetAddress.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.BorrowerAssociation = function(){
			var self = this,
				AUTHORIZED = 'Authorized';
			
			self.buildAuthorizedSigner = function(data, signer) {
				var newSigner = {};
				
				newSigner.isAuthorizedSigner = true;
				if (!_.isEmpty(data)) {
					newSigner.recordId = data.recordId || "";
				}
				if (!_.isEmpty(signer)) {
					newSigner.businessRelationship 
						= signer.capacity || "";
					newSigner.level2ID = signer.recordId || "";
				}
				
				return newSigner;
			};
			self.buildBorrowerBusinessAssociation = function(data) {
				var results = [], 
					authorizedSigner = null;
				
				if (data == null || data.signers === undefined) {
					return data;
				}
				
				results.push(data);
				_.each(data.signers, function(signer){
					if (signer.authority == AUTHORIZED && results.length < 5) {
						results.push(self.buildAuthorizedSigner(data, signer));
					}
				});
				return results;
			};
			self.setAssociationType = function(data) {
				if (data != null && data.relationship != null && data.relationship.isIndividual) {
					return { 'individualAssociation' : data };
				}
				return { 'businessAssociation' : self.buildBorrowerBusinessAssociation(data) };
			};
			self.mapFromJS = function(data){
				return app.mapFromJS(self.setAssociationType(data), app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.BorrowerAssociation.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.GuarantorAssociation = function(){
			var self = this;
			self.setAssociationType = function(data) {
				if (data != null && data.relationship != null && data.relationship.isIndividual) {
					return { 'individualAssociation' : data };
				}
				return { 'businessAssociation' : data };
			};
			self.mapFromJS = function(data){
				return app.mapFromJS(self.setAssociationType(data), app.getMapping(), self);
			};
			return self;
		}; 
		app.Flo.Xml.GuarantorAssociation.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.BusinessAssociation = function(){
			var self = this;
			self.mapFromJS = function(data){
				var businessAssociation = { 
					"_level1ID" : data.recordId, 
					"_sortOrder" : data.sortOrder
				};
				if (!_.isUndefined(data.isAuthorizedSigner)) {
					businessAssociation = {
						"_businessRelationship" : data.businessRelationship,
						"_level1ID" : data.recordId,
						"_level2ID" : data.level2ID
					}
				}
				return app.mapFromJS(businessAssociation, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.BusinessAssociation.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.IndividualAssociation = function(){
			var self = this;
			self.mapFromJS = function(data){
					return app.mapFromJS({ 
						"_level1ID" : data.recordId, 
						"_sortOrder" : data.sortOrder
					}, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.IndividualAssociation.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.LoanApplication = function(){
			var self = this;
			self.buildAssociations = function(data) {
				var associations = {}, 
					borrowers = [],
					guarantors = [],
					sortOrderBorrower = 0,
					sortOrderGuarantor = 0;
				
				_.each(data, function(row){
					if (row.isGuarantor) {
						row.sortOrder = sortOrderGuarantor += 1;
						guarantors.push(row);
					} else if (row.isBorrower || row.isCoborrower) {
						row.sortOrder = sortOrderBorrower += 1;
						borrowers.push(row);
					}
				});
				if (borrowers.length > 0) {
					associations.borrowerAssociation = borrowers;
				}
				if (guarantors.length > 0) {
					associations.guarantorAssociation = guarantors;
				}
				return associations;
			};
			self.isBusinessInvolvement = function(involvement){
				return !(_.isUndefined(involvement) || _.isUndefined(involvement.relationship)
						|| involvement.relationship.isIndividual);
			};
			self.createSignerCustomers = function(involvement){
				if(!(_.isUndefined(self.customers) || _.isUndefined(self.customers.customer)
						|| _.isUndefined(self.customers.customer.mappedCreate) || _.isUndefined(involvement))
						&& _.isArray(involvement.signers)){
					
					_.each(involvement.signers, function(signer){
						self.customers.customer.mappedCreate({
							"recordId": signer.recordId,
							"relationship": {
								"isIndividual": true,
								"entityType": this.INDIVIDUAL,
								"primaryContact": signer.contact
							}
						});
					}, this);
				}
			};
			self.mapFromJS = function(data){
				var relationship = data.relationship,
					entityType = relationship != null && relationship != undefined ? data.relationship.entityType : "",
					entInvolvements = data.involvements ? data.involvements : [];

				app.mapFromJS({
					"_referenceNumber": data.loanNumber || "",
					"_productCode": data.typeCode || "",
					"_accountNumber": data.loanNumber || "",
					"_noteNumber": data.loanNumber || "",
					"_businessOrConsumer": entityType || "",
					"_creditType": "", // no mapping
					"_applicationDate": "", // no mapping
					"_branchCode": data.branchId || "",
					"_loanOfficer": data.officerName || "",
					"_loanUnderwriter": "", // no mapping
					"_loanProcessor": "", // no mapping
					"_loanPurpose": data.purpose || "",
					"_demandLoan": "", // no mapping
					"_accountOpeningStatus": data.status || "",
					"customers": { "customer": entInvolvements },
					"associations": self.buildAssociations(entInvolvements),
					"collateral": { "collateralItem": data.collateral },
					"calculation": data
				}, app.getMapping(), self);
				_.each(_.filter(entInvolvements, self.isBusinessInvolvement),
						self.createSignerCustomers, new app.Flo.Xml.BusinessOrConsumer());
				return self;
			};
			return this;
		};
		app.Flo.Xml.LoanApplication.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.Phone = function(){
			var self = this;
			self.START = 0;
			self.AREA_LENGTH = 3;
			self.LOCAL_LENGTH = 7;
			self.extract = function(data){
				var extracted = {
					area: "",
					local: "",
					ext: ""
				};
				if(_.isUndefined(data) || data == "" || data == null){
					return extracted;
				}
				var cleaned = data.replace(/[\D]/g, "");
				if(cleaned.length >= self.LOCAL_LENGTH){
					if(cleaned.length >= (self.LOCAL_LENGTH + self.AREA_LENGTH)){
						extracted.area = cleaned.substr(self.START, self.AREA_LENGTH);
						cleaned = cleaned.substr(self.AREA_LENGTH);
					}
					extracted.local = cleaned.substr(self.START, self.LOCAL_LENGTH);
					cleaned = cleaned.substr(self.LOCAL_LENGTH);
					if(cleaned.length > self.START){
						extracted.ext = cleaned;
					}
				}
				return extracted;
			};
			self.mapFromJS = function(data){
				var extracted = self.extract(data.number);
				return app.mapFromJS({
					"_country": "", // no mapping
					"_area": extracted.area || "",
					"_local": extracted.local || "",
					"_extension": extracted.ext || ""
				}, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.Phone.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.PrincipalPlus = function(){
			var self = this;
			self.mapFromJS = function(data){
				return app.mapFromJS({
					"_proceedsAmount": data.amount || "",
					"_numberOfPayments": data.totalMonthlyPayment || "",
					"_frequencyOfPayments": data.paymentSchedule || "",
					"_interestRate": Utils.setScaleString(data.interestRate),
					"_interestRateMargin": Utils.setScaleString(data.spread),
					"_interestRateFloor": Utils.setScaleString(data.rateFloor),
					"_interestRateCeiling": Utils.setScaleString(data.rateCeiling),
					"_lateChargeRoutine": "", // no mapping
					"_loanDate": data.closeTimestamp || "",
					"_fundingDate": data.closeTimestamp || "",
					"_rateChangeFrequency": data.interestRateAdjustmentFrequency || "",
					"_rateChangeDate": "", // no mapping
					"_rateChangeFrequencyText": "", // no mapping
					"_paymentChangeFrequency": "", // no mapping
					"_paymentChangeDate": "", // no mapping
					"_paymentChangeFrequencyText": "", // no mapping
					"_multipleAdvanceFlag": "", // no mapping
					"_initialAdvanceAmount": "", // no mapping
					"_variableRate": "", // no mapping
					"_firstPaymentDate": data.nextPaymentDueTimestamp || "",
					"_principalPaymentAmount": data.monthlyPayment || "",
					"_firstInterestPaymentDate": data.nextInterestPaymentTimestamp || "",
					"_principalPaymentFrequency": data.paymentSchedule || "",
					"_seperateInterestScheduleFlag": "", // no mapping
					"renewals": { "renewalItem": data.renewedLoans }
				}, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.PrincipalPlus.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.RateChangeFrequency = function(){
			var self = this;
			self.DAILY = "Daily";
			self.WEEKLY = "Weekly";
			self.MONTHLY = "Monthly";
			self.QUARTERLY = "Quarterly";
			self.ANNUAL = "Annually";
			self.EVERY_TWO_YEARS = "Annually2";
			self.EVERY_THREE_YEARS = "Annually3";
			self.EVERY_FOUR_YEARS = "Annually4";
			self.EVERY_FIVE_YEARS = "Annually5";
			self.EVERY_TEN_YEARS = "Annually10";
			self.OTHER = "Other";
			self.key = function(value){
				return !_.isString(value) || _.isEmpty(value)
						? undefined : value.toUpperCase().replace(/[\W]/g, "_");
			};
			self.translate = function(value){
				var key = self.key(value);
				return _.isUndefined(key) || _.isUndefined(self[key]) ? "" : self[key];
			};
			return self;
		};
		// RateChangeFrequency does not need 'tns' prefix
		app.Flo.Xml.RenewalItem = function(){
			var self = this;
			self.mapFromJS = function(data){
				return app.mapFromJS({
					"_amount": data.amount || "",
					"_account": data.loanNumber || "",
					"_originationDate": data.closeTimestamp || ""
				}, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.RenewalItem.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.Renewals = function(){
			var self = this;
			self.mapFromJS = function(data){
				if(_.isEmpty(data.renewalItem)){
					return self;
				}
				data.renewalItem = _.isArray(data.renewalItem)
						? data.renewalItem : [ data.renewalItem ];
				return app.mapFromJS(data, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.Renewals.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.SinglePay = function(){
			var self = this;
			self.mapFromJS = function(data){
				return app.mapFromJS({
					"_proceedsAmount": data.amount || "",
					"_numberOfPayments": data.totalMonthlyPayment || "",
					"_frequencyOfPayments": data.paymentSchedule || "",
					"_interestRate": Utils.setScaleString(data.interestRate),
					"_interestRateMargin": Utils.setScaleString(data.spread),
					"_interestRateFloor": Utils.setScaleString(data.rateFloor),
					"_interestRateCeiling": Utils.setScaleString(data.rateCeiling),
					"_lateChargeRoutine": "", // no mapping
					"_loanDate": data.closeTimestamp || "",
					"_fundingDate": data.closeTimestamp || "",
					"_rateChangeFrequency": data.interestRateAdjustmentFrequency || "",
					"_rateChangeDate": "", // no mapping
					"_rateChangeFrequencyText": "", // no mapping
					"_paymentChangeFrequency": "", // no mapping
					"_paymentChangeDate": "", // no mapping
					"_paymentChangeFrequencyText": "", // no mapping
					"_multipleAdvanceFlag": "", // no mapping
					"_initialAdvanceAmount": "", // no mapping
					"_variableRate": "", // no mapping
					"_maturityDate": data.maturityTimestamp || "",
					"renewals": { "renewalItem": data.renewedLoans }
				}, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.SinglePay.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.SoleProprietorship = function(){
			var self = this;
			self.mapFromJS = function(data){
				return app.mapFromJS({
					"customerName": { "individualName": data.primaryContact || "" },
					"taxID": data,
					"identifications": { "identification": [ data.primaryContact ] },
					"addresses": data,
					"faxTelephone": { number: data.primaryContact.fax || "" },
					"businessTelephone": { number: data.primaryContact.phone || "" },
					"creditScores": { creditScore: [ data ] }
				}, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.SoleProprietorship.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.TaxId = function(){
			var self = this;
			self.TYPE_SSN = "SSN";
			self.TYPE_EIN = "EIN";
			self.mapFromJS = function(data){
				return app.mapFromJS(data.isIndividual
						? {
							"_type": self.TYPE_SSN,
							"_number": data.primaryContact.ssn || "",
							"_verified": "", // no mapping
						} : {
							"_type": self.TYPE_EIN,
							"_number": data.taxIdentificationNumber || "",
							"_verified": "", // no mapping
						}, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.TaxId.prototype = new app.Flo.Xml.Element();
		app.Flo.Xml.USAddress = function(){
			var self = this;
			self.mapFromJS = function(data){
				return app.mapFromJS({
					"_street1": data.street || "",
					"_street2": "", // no mapping
					"_city": data.city || "",
					"_stateCode": data.state || "",
					"_postalCode": data.postalCode || ""
				}, app.getMapping(), self);
			};
			return self;
		};
		app.Flo.Xml.USAddress.prototype = new app.Flo.Xml.Element();
		app.setMapping({
			"accountsReceivable": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"address": {
				create: function(options){
					return !_.isUndefined(options.data.primary)
							? new app.Flo.Xml.Address() : new app.Flo.Xml.USAddress();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"addresses": {
				create: function(options){
					return new app.Flo.Xml.Addresses();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"adjustableRate": {
				create: function(options){
					return new app.Flo.Xml.AdjustableRate();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"aircraft": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"allAssets": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"associations": {
				create: function(options){
					return new app.Flo.Xml.Element();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"applications": {
				create: function(options){
					return new app.Flo.Xml.Applications();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"borrowerAssociation": {
				create: function(options){
					return new app.Flo.Xml.BorrowerAssociation();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"asExtracted": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"assignmentOfDepositAccount": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"association": {
				create: function(options){
					return new app.Flo.Xml.Business();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"balloon": {
				create: function(options){
					return new app.Flo.Xml.Balloon();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"businessAssociation": {
				create: function(options){
					return new app.Flo.Xml.BusinessAssociation();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"businessName": {
				create: function(options){
					return new app.Flo.Xml.BusinessName();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"businessTelephone": {
				create: function(options){
					return new app.Flo.Xml.Phone();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"calculation": {
				create: function(options){
					return new app.Flo.Xml.Calculation();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"cellularTelephone": {
				create: function(options){
					return new app.Flo.Xml.Phone();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"chattelPaper": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"collateral": {
				create: function(options){
					return new app.Flo.Xml.Collateral();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"collateralItem": {
				create: function(options){
					return new app.Flo.Xml.CollateralItem();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"commercialRealEstate": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"commercialRealEstateConstruction": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"commercialRealEstateResidential": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"consumerRealEstateConstruction": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"consumerRealEstateNonPurchase": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"consumerRealEstatePortfolio": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"corporation": {
				create: function(options){
					return new app.Flo.Xml.Business();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"creditScore": {
				create: function(options){
					return new app.Flo.Xml.CreditScore();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"creditScores": {
				create: function(options){
					return new app.Flo.Xml.Element();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"customer": {
				create: function(options){
					return new app.Flo.Xml.Customer();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"customerName": {
				create: function(options){
					return new app.Flo.Xml.Element();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"customers": {
				create: function(options){
					return new app.Flo.Xml.Element();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"data": {
				update: function(options){
					return _.isEmpty(options.data) ? options.target : app.mapFromJS({
						applications: {
							loanApplication: options.data
						}
					}, app.getMapping(), options.target);
				}
			},
			"dateOfBirth": {
				create: function(options){
					return new app.Flo.Xml.Date();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"definedSchedule": {
				create: function(options){
					return new app.Flo.Xml.DefinedSchedule();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"description": {
				create: function(options){
					return new app.Flo.Xml.Element();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"documentedVessel": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"equipment": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"existingCollateral": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"farmEquipment": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"farmProducts": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"faxTelephone": {
				create: function(options){
					return new app.Flo.Xml.Phone();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"fixtures": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"freeForm": {
				create: function(options){
					return new app.Flo.Xml.FreeForm();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"generalIntangibles": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"generalPartnership": {
				create: function(options){
					return new app.Flo.Xml.Business();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"government": {
				create: function(options){
					return new app.Flo.Xml.Business();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"guarantorAssociation": {
				create: function(options){
					return new app.Flo.Xml.GuarantorAssociation();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"homeTelephone": {
				create: function(options){
					return new app.Flo.Xml.Phone();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"householdGoods": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"identification": {
				create: function(options){
					return new app.Flo.Xml.Identification();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"identifications": {
				create: function(options){
					return new app.Flo.Xml.Element();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"individual": {
				create: function(options){
					return new app.Flo.Xml.Individual();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"individualAssociation": {
				create: function(options){
					return new app.Flo.Xml.IndividualAssociation();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"individualName": {
				create: function(options){
					return new app.Flo.Xml.IndividualName();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"installment": {
				create: function(options){
					return new app.Flo.Xml.Installment();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"instruments": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"interestOnly": {
				create: function(options){
					return new app.Flo.Xml.InterestOnly();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"internetAddress": {
				create: function(options){
					return new app.Flo.Xml.InternetAddress();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"inventory": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"investmentInstrument": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"lifeInsurance": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"limitedPartnership": {
				create: function(options){
					return new app.Flo.Xml.Business();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"limitedLiabilityCompany": {
				create: function(options){
					return new app.Flo.Xml.Business();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"limitedLiabilityPartnership": {
				create: function(options){
					return new app.Flo.Xml.Business();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"loanApplication": {
				create: function(options){
					return new app.Flo.Xml.LoanApplication();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"metadata": {
				create: function(options){
					return new app.Flo.Xml.Metadata();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"mobileHome": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"motorVehicle": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"nonTitledPersonalProperty": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"principalPlus": {
				create: function(options){
					return new app.Flo.Xml.PrincipalPlus();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"recreationalVehicle": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"renewalItem": {
				create: function(options){
					return new app.Flo.Xml.RenewalItem();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"renewals": {
				create: function(options){
					return new app.Flo.Xml.Renewals();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"standingTimber": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"singlePay": {
				create: function(options){
					return new app.Flo.Xml.SinglePay();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"soleProprietorship": {
				create: function(options){
					return new app.Flo.Xml.SoleProprietorship();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"taxID": {
				create: function(options){
					return new app.Flo.Xml.TaxId();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"trust": {
				create: function(options){
					return new app.Flo.Xml.Business();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"USAddress": {
				create: function(options){
					return new app.Flo.Xml.USAddress();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"value": {
				create: function(options){
					return new app.Flo.Xml.Element();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"valuationDate": {
				create: function(options){
					return new app.Flo.Xml.Date();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"watercraft": {
				create: function(options){
					return new app.Flo.Xml.CollateralBaseType();
				},
				update: function(options){
					return options.target.mapFromJS(options.data);
				}
			},
			"_accountOpeningStatus": {
				update: function(options){
					return new app.Flo.Xml.AccountOpeningStatus().translate(options.data);
				}
			},
			"_branchCode": {
				update: function(options){
					return new app.Flo.Xml.BranchCode().translate(options.data);
				}
			},
			"_businessOrConsumer": {
				update: function(options){
					return new app.Flo.Xml.BusinessOrConsumer().translate(options.data);
				}
			},
			"_firstInterestPaymentDate": {
				update: function(options){
					return new app.Flo.Xml.Date().format(options.data);
				}
			},
			"_firstPaymentDate": {
				update: function(options){
					return new app.Flo.Xml.Date().format(options.data);
				}
			},
			"_fundingDate": {
				update: function(options){
					return new app.Flo.Xml.Date().format(options.data);
				}
			},
			"_loanDate": {
				update: function(options){
					return new app.Flo.Xml.Date().format(options.data);
				}
			},
			"_maturityDate": {
				update: function(options){
					return new app.Flo.Xml.Date().format(options.data);
				}
			},
			"_originationDate": {
				update: function(options){
					return new app.Flo.Xml.Date().format(options.data);
				}
			},
			"_principalPaymentFrequency": {
				update: function(options){
					return !_.isString(options.data) || _.isEmpty(options.data)
							? "" : options.data.replace(/-/g, "");
				}
			},
			"_rateChangeFrequency": {
				update: function(options){
					return new app.Flo.Xml.RateChangeFrequency().translate(options.data);
				}
			},
			"_reportingDate": {
				update: function(options){
					return new app.Flo.Xml.Date().format(options.data);
				}
			}
		});
		app.log('Flo.Xml Models initialized.');
	};
	if(LifeCycle.DataServices.Flo == undefined){
		LifeCycle.DataServices.Flo = {};
	}
	if(LifeCycle.DataServices.Flo.Xml == undefined){
		LifeCycle.DataServices.Flo.Xml = {};
	}
	if(LifeCycle.DataServices.Flo.Xml.Models == undefined){
		LifeCycle.DataServices.Flo.Xml.Models = Models;
	}
}());

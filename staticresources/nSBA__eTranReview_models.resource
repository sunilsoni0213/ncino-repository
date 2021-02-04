(function(){
	var Models = function(event, app) {
		app.Account = function(data) {
			var self = this;
			var defaultData = {
				id: null,
				ruralUrbanIndicator: null,
				zip4required: null,
				zipCode: null,
				exportCountry: null,
				isDestinationCountriesRequired: null,
				data: {
					currEmpQty: null,
					naicsCd: null,
					netExprtAmt: null,
					frnchiseInd: null,
					frnchiseCd: null,
					frnchiseName: null,
					projectCityName: null,
					projectStrtName1: null,
					projectStCd: null,
					projectZipCd: null,
					projectZip4Cd: null,
					ruralUrbanInd: null
				},
				dateOfEst: null
			};
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.hasFranchise = ko.computed(function() {
				return _.isFunction(self.data.frnchiseInd) &&
					self.data.frnchiseInd() === 'Y';
			}, this);
			self.isZip4Required = ko.computed(function() {
				if(_.isFunction(self.zip4required)) {
					return(self.zip4required() === 'Y');
				}
				return false;
			}, this);
			return self;
		};
		app.Agents = function(data) {
			var self = this;
			var defaultData = {
				id: null,
				loanAgentTypeText: null,
				loanAgentCountry: null,
				loanAgentState: null,
				data: {
					loanAgentSeqNmb: null,
					loanAgentBusPerInd: null,
					loanAgentFirstName: null,
					loanAgentMI: null,
					loanAgentLastName: null,
					loanAgentSuffix: null,
					loanAgentName: null,
					loanAgentType: null,
					loanAgentCntCd: null,
					loanAgentCDCTPLFeeAmt: null,
					loanAgentCDCTplFeeInd: null,
					loanAgentStreet1: null,
					loanAgentStreet2: null,
					loanAgentCity: null,
					loanAgentStateCD: null,
					loanAgentZipCD: null,
					loanAgentZip4CD: null
				}
			};
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			self.getAgentFees = ko.computed(function(){
				if(app.viewModel && app.viewModel.review){
					var af = app.viewModel.review.agentFees();

					return _.filter(af,function(li){
						return li.agentId() === self.id();
					});
				}
			},this);
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.AgentFees = function(data) {
			var self = this;
			var defaultData = {
				id: null,
				agentId: null,
				loanAgentServiceType: null,
				data: {
					loanAgentSeqNmb: null,
					loanAgentServTypCd: null,
					loanAgentAppCNTPaidAmt: null,
					loanAgentSbaLenderPaidAmt: null,
					loanAgntServOtherType: null
				}
			};
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.Application = function(data) {
			var self = this;
			var defaultData = {
				id: null,
				eligibilityChecklist: null,
				eligibilitySizeStandard: null,
				eligibilityInformationTrue: null,
				eligibilityCAIP: null,
				eligibilityARC: null,
				limitCompensation: null,
				limitFixedAssets: null,
				maturityStartsFrom: null,
				floorOrCeilingRateVariable: null,
				floorOrCeilingRateSpecified: null,
				lenderAltContactCellPhn: null,
				lenderAltContactPrimPhn: null,
				paymentFrequency: null,
				paymentFrequencyUnit: null,
				interestOnlyMonths: null,
				interestOnlyStartsFrequency: null,
				interestOnlyStartsUnit: null,
				interestOnlyPaymentsFrequency: null,
				interestOnlyPaymentsUnit: null,
				pymtIntOnlyDayOfMonth: null,
				interestOnlyPaymentsDayOfMonth: null,
				paymentStartsFrequency: null,
				paymentStartsUnit: null,
				paymentScheduleFrequency: null,
				paymentScheduleUnit: null,
				paymentsDayOfMonth: null,
				pymtType: null,
				zip4required: null,
				zipCode: null,
				data: {
					lenderApplicNmb: null,
					processingMethodCd: null,
					ewcpPostShipmntInd: null,
					ewcpSnglTransInd: null,
					injectionInd: null,
					lenderAltContactTypCd: null,
					lenderAltContactFirstNm: null,
					lenderAltContactInitialNm: null,
					lenderAltContactLastNm: null,
					lenderAltContactTitlTxt: null,
					lenderAltContactPrimPhn: null,
					lenderAltContactCellPhn: null,
					lenderAltContactEmail: null,
					locationId: null,
					reconsiderationInd: null,
					underwritingBy: null,
					fundingFeeAmt: null,
					fullAmortPymtInd: null,
					jobsCreatdQty: null,
					jobsRetaindQty: null,
					frnchiseDeferPymtInd: null,
					frnchiseDeferPymtMonths: null,
					frnchiserBooksInd: null,
					frnchiseWarnTermInd: null,
					frnchiseOpporCureInd: null,
					limitCompensationInd: null,
					limitCompensationAmt: null,
					limitFixedAssetInd: null,
					limitFixedAssetAmt: null,
					limitLocation: null,
					loanTermStartTypInd: null,
					noteDt: null,
					pymtCeilingAndFloorCode : null,
					pymtCeilingMaxPct: null,
					pymtFloorMinPct: null,
					pymtEscrowInd: null,
					pymtIntOnlySkipMonths: null,
					pymtIntOnlyDayOfMonth: null,
					pymtIntOnlyFreqCode: null,
					pymtPrinAndIntSkipMonths: null,
					pymtFrequency: null,
					pymtPrinAndIntDayOfMonth: null,
					pymtNetEarnRecaptureInd: null,
					pymtNetEarnPrepayAmt: null,
					pymtNetEarnPrepayPct: null,
					pymtLateChargeInd: null,
					pymtLateChargeDays: null,
					pymtLateChargePct: null,
					pymtIntRateDeductionInd: null,
					pymtIntRateProgramOther: null,
					pymtSchedule: null,
					pymtTypeCode: null,
					stateLawComplianceForBulkInd: null,
					agentInvolved: null,
					loanExtraordinaryServFeeAmt: null,
					loanExtraordinaryServFeeInd: null
				},
				packageSource: null
			};
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.isZip4Required= ko.computed(function() {
				if(_.isFunction(self.zip4required)) {
					return(self.zip4required() === 'Y');
				}
				return false;
			}, this);
			return self;
		};
		app.Eligibility = function(data) {
			var self = this;
			var defaultData = {
				id: null,
				data: {
					eligibleInd: null,
				},
				eTranValue: null,
			};
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.DestinationCountries = function(data) {
			var self = this;
			var defaultData = {
				id: null,
				data: {
					destinationCountryCd: null,
				},
				destinationCountry: null,
			};
			if (data !== undefined) {
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.Entity = function(data) {
			var self = this;
			var defaultData = {
				id: null,
				accountId: null,
				contactId: null,
				epcIndicator: null,
				isIndividual: null,
				isPrimary: null,
				isMailingAddressRequired: null,
				operatingCompanyIndicator: null,
				transGuarantorType: null,
				primaryPhone: null,
				transCitizenship: null,
				taxIdentifier: null,
				accountType: null,
				simplifiedAccountType: null,
				externalCreditScoreSource: null,
				hasAffiliates: null,
				guaranteeLimit: null,
				zip4required: null,
				zipCodePhys: null,
				zipCodeMail: null,
				controlInterestTypeEntity: null,
				alternatePhone: null,
				primaryEmail: null,
				alternateEmail: null,
				busPrimCntctNm: null,
				busOutstandingDebtInd: null,
				data: {
					businessName: null,
					businessPersonInd: null,
					lawsuitInd: null,
					legalOrgnztnCd: null,
					priorSBALoanInd: null,
					taxId: null,
					tradeName: null,
					bnkrptcyInd: null,
					busDUNSNmb: null,
					currBankName: null,
					exporterInd: null,
					creditScorSourcCd: null,
					extrnlCreditScorDt: null,
					extrnlCreditScorNmb: null,
					extrnlCreditScorInd: null,
					fngrprntWaivDt: null,
					mailStrtName1: null,
					mailStrtName2: null,
					mailCityName: null,
					mailStCd: null,
					mailZipCd: null,
					mailCountryCd: null,
					mailStNm: null,
					mailPostalCd: null,
					physStrtName1: null,
					physStrtName2: null,
					physCityName: null,
					physStCd: null,
					physZipCd: null,
					physCountryCd: null,
					physStNm: null,
					physPostalCd: null,
					intrstOthBusinessInd: null,
					controlInterestType: null,
					prevGovFinInd: null,
					fedDisqualifiedInd: null,
					gamblingOrSexualNatureInd: null,
					nonFmrSBAEmpInd: null,
					nonLegBrnchEmpInd: null,
					nonFedEmpInd: null,
					nonGS13EmpInd: null,
					nonSBACEmpInd: null,
					alternatePhone: null,
					primaryEmail: null,
					alternateEmail: null,
					busPrimCntctNm: null,
					busOutstandingDebtInd: null
				},
				entityType: null
			};
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.isCountryUS = ko.computed(function() {
				if(_.isFunction(self.data.physCountryCd)){
					return(self.data.physCountryCd() === 'US');
				}
				return false;
			}, this);
			self.isZip4Required = ko.computed(function() {
				if(_.isFunction(self.zip4required)) {
					return(self.zip4required() === 'Y');
				}
				return false;
			}, this);
			return self;
		};
		app.Interest = function(data) {
			var self = this;
			var defaultData = {
				id: null,
				adjustmentFrequency: null,
				index: null,
				pricingBasisValue: null,
				isComplex: null,
				data: {
					baseIntrstRatePct: null,
					borrIntrstRatePct: null,
					shareOfTotalMnths: null,
					shareOfTotalPct: null,
					firstRateAdjustDt: null,
					intrstGuaranteeInd: null,
					phase: null
				},
			};
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.Loan = function(data) {
			var self = this;
			var defaultData = {
				id: null,
				entityType: null,
				primaryEntityId: null,
				officerId: null,
				pricingBasisValue: null,
				totalCollateral: null,
				lenderCntctPhnNmb:null,
				lenderCntctFax: null,
				etranUsername: null,
				realEstateTaxesOrInsuranceEscrowNeeded: null,
				loanAmortTermMnths: null,
				data: {
					collateralInd: null,
					pymtEscrowInd: null,
					eligPassiveCompanyInd: null,
					lenderCntctEmail: null,
					lenderCntctFax: null,
					lenderCntctFirstName: null,
					lenderCntctLastName: null,
					lenderCntctPhnNmb: null,
					lenderCntctTitl: null,
					outPrgrmAreaOfOperInd: null,
					lenderLoanNmb: null,
					loanName: null,
					loanTermMnths: null,
					mnthsIntrstOnlyQty: null,
					pymtAmt: null,
					requestedAmt: null,
					sbaGntyPct: null,
					revolvingInd: null,
					loanBusinessEstDt: null,
					loanTermAmortMnths: null,
					loanTermRevlMnths: null
				}
			};
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.isLoanNameTooLong = ko.computed(function() {
				if(_.isFunction(self.data.loanName)){
					return (String(self.data.loanName()).length > 80)? true : false;
				}
				return false;
			}, this);
			self.isLoanNumberTooLong = ko.computed(function() {
				if(_.isFunction(self.data.lenderLoanNmb)){
					return (String(self.data.lenderLoanNmb()).length > 20)? true : false;
				}
				return false;
			}, this);
			return self;
		};
		app.Review = function(data) {
			var self = this;
			var defaultData = {
				account: null,
				agents: [],
				agentFees: [],
				borrowers: [],
				changeOfOwnership: null,
				application: null,
				entity: null,
				eligibility: null,
				destinationCountries: [],
				loan: null,
				guarantors: [],
				unavailableCreditInformations: [],
				useOfProceeds: [],
				injections:[],
				standbyAgreements: [],
				interest: [],
				principals: [],
				collateral: [],
				liens: [],
				specialPurpose: null,
				partnerInformation: null,
				lenderComments: null
			};
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.Response = function(data) {
			var self = this;
			var defaultData = {
				authErrorNmb: null,
				authErrorText: null,
				loanAppNmb: null,
				loanNmb: null,
				loanAppNm: null,
				loanAppRecvDt: null,
				loanAppStatCd: null,
				loanAppRqstAmt: null,
				loanAppPrtLoanNmb: null,
				loanAppPrtAppNmb: null,
				loanAppEtranEmailAdr: null,
				loanAppAppvDt: null,
				loanAppSBAAppvAmt: null,
				loanGntyFeeAmt: null,
				loanGntyFeeExplainTxt: null,
				loanAppFundDt: null,
				busDUNSNmb: null,
				liquidCreditScore: null,
				synopsis: [],
				errors: []
			};
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.synopsisText = ko.computed(function(){
				return self.synopsis().join('<br/><br/>');
			}, this);
			self.errorText = ko.computed(function(){
				return self.errors().join('<br/><br/>');
			}, this);
			self.isPassed= ko.computed(function() {
				if(_.isFunction(self.loanAppStatCd)){
					return(self.loanAppStatCd() !== null && self.loanAppStatCd() !== '');
				}
				return false;
			}, this);
			return self;
		};
		app.UnavailableCreditInformations = function(data){
			var self = this;
			var defaultData = {
				id: null,
				creditUnavailableReason: null,
				data: {
					creditUnavailReasonCommnt: null
				}
			};
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.isReasonCommntRequired = ko.computed(function(){
				return _.isFunction(self.data.creditUnavailReasonCd)
					&& self.data.creditUnavailReasonCd === '5';
			}, this);
			return self;
		};
		app.Principals = function(data){
			var self = this;
			var defaultData = {
				id: null,
				connectionId: null,
				contactId: null,
				accountId: null,
				borrowerTaxId: null,
				isUsCitizen: null,
				transEthnicity: null,
				transGender: null,
				transVeteranStatus: null,
				transRace: null,
				taxIdentifier: null,
				transCitizenship: null,
				principalTaxString:null,
				accountType: null,
				simplifiedAccountType: null,
				externalCreditScoreSource: null,
				controlInterestTypeDescription: null,
				hasAffiliates: null,
				guaranteeLimit: null,
				transGuarantorType: null,
				zip4required: null,
				zipCodePhys: null,
				zipCodeMail: null,
				citznShipCntryName: null,
				alternatePhone: null,
				primaryEmail: null,
				alternateEmail: null,
				data: {
					gntyInd: null,
					vetCertInd: null,
					ownrshpInBusinessPct: null,
					eligPassiveCompanyInd: null,
					businessName:null,
					businessPersonInd:null,
					lawsuitInd:null,
					legalOrgnztnCd:null,
					priorSBALoanInd:null,
					taxId:null,
					tradeName:null,
					bnkrptcyInd:null,
					busDUNSNmb:null,
					currBankName:null,
					exporterInd:null,
					creditScorSourcCd: null,
					extrnlCreditScorDt:null,
					extrnlCreditScorNmb:null,
					extrnlCreditScorInd:null,
					fngrprntWaivDt:null,
					mailStrtName1:null,
					mailStrtName2:null,
					mailCityName:null,
					mailStCd:null,
					mailZipCd:null,
					mailCountryCd:null,
					mailStNm:null,
					mailPostalCd:null,
					physStrtName1:null,
					physStrtName2:null,
					physCityName:null,
					physStCd:null,
					physZipCd:null,
					physCountryCd:null,
					physStNm:null,
					physPostalCd:null,
					primaryPhone: null,
					primBusExprnceYrNmb: null,
					insureName: null,
					insuranceAmt: null,
					controlInterestType: null,
					insuranceLifeInd: null,
					noNCAInd: null,
					noNCACompetitorName: null,
					insuranceDisabInd: null,
					insureDisabNames: null,
					cSP60DayDelnqInd: null,
					fedDisqualifiedInd: null,
					citznShipCntryName: null,
					lglActnInd: null,
					alternatePhone: null,
					primaryEmail: null,
					alternateEmail: null
				}
			};
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.isZip4Required = ko.computed(function() {
				if(_.isFunction(self.zip4required)) {
					return(self.zip4required() === 'Y');
				}
				return false;
			}, this);
			return self;
		};
		app.UseOfProceeds = function(data){
			var self = this;
			var defaultData = {
				id: null,
				data: {
					proceedAmt: null,
					proceedOthTypTxt: null,
					proceedTypCd: null,
					loanProceedTypCd:null,
					refDescTxt: null,
					purchaseAgrmtDt: null,
					stockholderName: null,
					purchaseAgrmtNCAInd: null,
					purchaseIntngblAssetAmt: null,
					purchaseIntngblAssetDescTxt: null
				},
				transLoanProceedTypCd: null
			};
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.injections = ko.computed(function(){
				var inject = app.viewModel.review.injections();
				return _.filter(inject,function(inj){
					return inj.proceedsId() === self.id();
				});
			},this);
			self.standbyAgreements = ko.computed(function(){
				var injectstdby = app.viewModel.review.standbyAgreements();
				return _.filter(injectstdby,function(stbby){
					return stbby.proceedsId() === self.id();
				});
			},this);
			self.changeOfOwnership = ko.computed(function(){
				var changeOfOwner = app.viewModel.review.changeOfOwnership;
				if(self.data.loanProceedTypCd() === '16'){
					return changeOfOwner;
				}
				else{
					return null;
				}
			},this);
			self.isOther = ko.computed(function(){
				return (_.isFunction(self.data.loanProceedTypCd) && (
					self.data.loanProceedTypCd() === '21' ||
					self.data.loanProceedTypCd() === '24' ||
					self.data.loanProceedTypCd() === '25'));
			});
			return self;
		};
		app.Injections = function(data){
			var self = this;
			var defaultData = {
				id: null,
				proceedsId: null,
				injectionTypeValue: null,
				data: {
					injctnTypCd: null,
					injctnAmt: null,
					injctnOthDescTxt: null,
					injctnTermNotLessThanYrNmb: null
				}
			};
			if(data !==undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.isTypeCodeOther = ko.computed(function(){
				return _.isFunction(self.data.injctnTypCd)
					&& self.data.injctnTypCd() === 'O';
			}, this);
			self.isSubordinateFunding = ko.computed(function(){
				return (_.isFunction(self.data.injctnTypCd) && (
					self.data.injctnTypCd() === 'D' ||
					self.data.injctnTypCd() === 'O' ||
					self.data.injctnTypCd() === 'S'));
			});
			return self;
		};
		app.StandbyAgreements = function(data){
			var self = this;
			var defaultData = {
				id: null,
				proceedsId: null,
				standbyTypeValue: null,
				standbyTypeCode: null,
				data: {
					sequenceNmb: null,
					beginDt: null,
					creditorName: null,
					pymtAmt: null,
					repayAmt: null,
					repayAPR: null,
					repayOtherDesc: null,
					repayTypeCd: null
				}
			};
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			self.isRepayOtherDescVisible = ko.computed(function(){
				return (_.isFunction(self.data.repayTypeCd) &&
					self.data.repayTypeCd() === '5');
			});
			self.isRepayAprVisible = ko.computed(function(){
				return (_.isFunction(self.data.repayTypeCd) && (
					self.data.repayTypeCd() === '2' ||
					self.data.repayTypeCd() === '3' ||
					self.data.repayTypeCd() === '4'));
			});
			self.isPymtAmtVisible = ko.computed(function(){
				return (_.isFunction(self.data.repayTypeCd) && (
					self.data.repayTypeCd() === '3' ||
					self.data.repayTypeCd() === '4'));
			});
			self.isBeginDtVisible = ko.computed(function(){
				return (_.isFunction(self.data.repayTypeCd) &&
					self.data.repayTypeCd() === '4');
			});
			return self;
		};
		app.ChangeOfOwnership = function(data) {
			var self = this;
			var defaultData = {
				id: null,
				realEstateValuationType:null,
				machineryEquipmentEvaluationType:null,
				busApprABVInd: null,
				busApprASAInd: null,
				busApprAVAInd: null,
				busApprCBAInd: null,
				busApprCPAInd: null,
				busApprCVAInd: null,
				busApprLIVInd: null,
				data: {
					acctRecvAssetAmt: null,
					busApprNm: null,
					busApprFeeAmt: null,
					busBrkrAdr: null,
					busBrkrNm: null,
					busBrkrComisnAmt: null,
					busBrkrComisnInd: null,
					buyerEqtyOthDescTxt: null,
					buyerEqtyOthAmt: null,
					buyerEqtyBorrAmt: null,
					buyerEqtyCashDescTxt: null,
					buyerEqtyCashAmt: null,
					covntAssetAmt: null,
					custAssetAmt: null,
					equipAssetAmt: null,
					equipValTypInd: null,
					fixAssetAmt: null,
					frnchsAssetAmt: null,
					goodwillAssetAmt: null,
					intangAssetAmt: null,
					invtryAssetAmt: null,
					licnsAssetAmt: null,
					loan7aPymtAmt: null,
					othAssetAmt: null,
					othAssetDescTxt: null,
					othIntangAssetAmt: null,
					othIntangAssetDescTxt: null,
					reAssetAmt: null,
					revalTypInd: null,
					sellerFinanFullStbyAmt: null,
					sellerFinanNonFullStbyAmt: null,
					totApprAmt: null
				}
			};
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.BusAppr = function(data){
			var self = this;
			var defaultData = {
				id: null,
				data: {
					ind: null
				}
			};
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.Collateral = function(data){
			var self = this;
			var defaultData = {
				id: null,
				collateralType: null,
				collateralSubType: null,
				isComplexCollateral: null,
				lienPosition: null,
				marketValueSource: null,
				realEstateTaxesOrInsuranceEscrowNeeded: null,
				assessmentMethod: null,
				streetAddress: null,
				vesselList: null,
				collateralOnLeasedPremise: null,
				instrumentType: null,
				noteAssignments: null,
				sharedPariPassuName: null,
				sharedPariPassuAmount: null,
				purchaseInterestPurchaser: null,
				purchaseInterestSeller: null,
				purchaseInterestAmounts: null,
				zip4required: null,
				zipCode: null,
				statusCode: null,
				securTitlVrfyTypCode: null,
				data: {
					collateralSequenceNmb: null,
					descriptionTxt: null,
					typCd: null,
					subTypCd: null,
					mrktValuAmt: null,
					ownrRecrd: null,
					mrktValuDt: null,
					mrktValuSourcCd: null,
					aLTATitleInsuredInd: null,
					apprCode: null,
					apprOrderedDt: null,
					cDCDeedInEscrowInd: null,
					strtName1: null,
					strtName2: null,
					cityName: null,
					zipCd: null,
					zip4Cd: null,
					stCd: null,
					countyCode: null,
					commRealEnvInvMustBeApprInd: null,
					insFloodInd: null,
					insMarineFullInd: null,
					insPerPropHazInd: null,
					insRealEstHazInd: null,
					lienOnLiqLicInd: null,
					onLeasedPremCd: null,
					onLeasedPremExtraYrNmb: null,
					instrumentTypCd: null,
					landlordWaiverInd: null,
					leaseTermOverLoanYrNmb: null,
					lessorTermNoticeDaysNmb: null,
					lienLimitedAmt: null,
					madeYr: null,
					makeName: null,
					noteSecuredInd: null,
					owedToSellerAmt: null,
					pariPassuAmt: null,
					pariPassuLenderName: null,
					sharedPariPassuInd: null,
					sharedPariPassuNonSBAInd: null,
					priorAsgnInd: null,
					priorAsgnTxt: null,
					priorAsgnLimitAmt: null,
					priorLienTxt: null,
					priorLienLimitAmt: null,
					stockSharesNmb: null,
					rentAsgnInd: null,
					waterRightsInd: null,
					purchaserName: null,
					sellerIntDescTxt: null,
					sellerIntTypInd: null,
					sellerName: null,
					statusCd: null,
					securTitlVrfyTypCd: null,
					securTitlVrfyOthTxt: null
				}
			};
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			self.getLiens = ko.computed(function(){
				if(app.viewModel && app.viewModel.review){
					var lie = app.viewModel.review.liens();
					return _.filter(lie,function(li){
						return li.collateralId() === self.id();
					});
				}
			},this);
			self.isZip4Required= ko.computed(function() {
				if(_.isFunction(self.zip4required)) {
					return(self.zip4required() === 'Y');
				}
				return false;
			}, this);
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.Liens = function(data){
			var self = this;
			var defaultData = {
				id: null,
				collateralId: null,
				lienPosition: null,
				data: {
					lienBalanceAmt: null,
					lienHldrName: null
				}
			}
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.SpecialPurpose = function(data){
			var self = this;
			var defaultData = {
				id: null,
				transSpcPurpsLoanCd: null,
			}
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.PartnerInformation = function(data){
			var self = this;
			var defaultData = {
				id: null,
				data: {
					locationId: null
				}
			}
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.LenderComments = function(data){
			var self = this;
			var defaultData = {
				id: null,
				data: {
					commntTxt: null
				}
			}
			if(data !== undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			return self;
		};
		app.setMapping({
			'account': {
				create: function(options){
					return new app.Account(options.data);
				}
			},
			'application': {
				create: function(options){
					return new app.Application(options.data);
				}
			},
			'borrowers': {
				create: function(options){
					return new app.Entity(options.data);
				}
			},
			'eligibility': {
				create: function(options){
					return new app.Eligibility(options.data);
				}
			},
			'destinationCountries': {
				create: function(options) {
					return new app.DestinationCountries(options.data);
				}
			},
			'entity': {
				create: function(options){
					return new app.Entity(options.data);
				}
			},
			'guarantors': {
				create: function(options){
					return new app.Entity(options.data);
				}
			},
			'loan': {
				create: function(options){
					return new app.Loan(options.data);
				}
			},
			'review': {
				create: function(options){
					return new app.Review(options.data);
				}
			},
			'response': {
				create: function(options){
					return new app.Response(options.data);
				}
			},
			'unavailableCreditInformations': {
				create: function(options){
					return new app.UnavailableCreditInformations(options.data);
				}
			},
			'principals': {
				create: function(options){
					return new app.Principals(options.data);
				}
			},
			'useOfProceeds': {
				create: function(options){
					return new app.UseOfProceeds(options.data);
				}
			},
			'injections': {
				create: function(options){
					return new app.Injections(options.data);
				}
			},
			'standbyAgreements': {
				create: function(options){
					return new app.StandbyAgreements(options.data);
				}
			},
			'interest': {
				create: function(options){
					return new app.Interest(options.data);
				}
			},
			'changeOfOwnership': {
				create: function(options){
					return new app.ChangeOfOwnership(options.data);
				}
			},
			'busAppr': {
				create: function(options){
					return new app.BusAppr(options.data);
				}
			},
			'collateral': {
				create: function(options){
					return new app.Collateral(options.data);
				}
			},
			'liens': {
				create: function(options){
					return new app.Liens(options.data);
				}
			},

			'agents': {
				create: function(options){
					return new app.Agents(options.data);
				}
			},
			'agentFees': {
				create: function(options){
					return new app.AgentFees(options.data);
				}
			},

			'specialPurpose': {
				create: function(options){
					return new app.SpecialPurpose(options.data);
				}
			},
			'partnerInformation': {
				create: function(options){
					return new app.PartnerInformation(options.data);
				}
			},
			'comments': {
				create: function(options){
					return new app.LenderComments(options.data);
				}
			}

		});
	};
	if(LifeCycle.ETranReview === undefined){
		LifeCycle.ETranReview = {};
	}
	if(LifeCycle.ETranReview.Models === undefined){
		LifeCycle.ETranReview.Models = Models;
	}
})();
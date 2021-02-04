(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			self.app = app;
			var defaultData = { 
					underwritingSummary: '',
					legalEntities: '',
					container: '',
					spread: '',
					legalEntity: '',
					user: '',
					borrowerType: '',
					mode: LifeCycle.msgs.msg_mode_standard
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			self.mapping = app.getMapping();
			// so it does not create a new instance
			self.mapping['ignore'] = [
				'spread',
				'legalEntity',
				'user',
				'relationship',
				'mode'
			];

			app.mapFromJS(defaultData, app.getMapping(), self);

			self.spread = data.spread;
			self.legalEntity = data.legalEntity;
			self.relationship = data.relationship;
			self.user = data.user;
			self.mode = ko.observable(data.mode);
			self.loaded = ko.observable(false);
			self.open = ko.observable();
			self.isEditing = ko.observable(false);
			self.isCommenting = ko.observable(false);
			self.comment = ko.observable('');

			self.isPrintView = ko.computed(function() {
				return (self.mode() == undefined || self.mode() == LifeCycle.msgs.msg_mode_print);
			});

			self.isExportView = ko.computed(function() {
				return (self.mode() == LifeCycle.msgs.msg_mode_export);
			});

			self.isStandardView = ko.computed(function() {
				return (!self.isPrintView() && !self.isExportView());
			});

			self.toggle = function(data, e){
				if (!self.spread.navApp.viewModel.savePending()) {
					app.publish("SPREAD.Spreads.Fullscreen_App_Opened", self.app.appId);
					if ( typeof key !== "undefined") {
						if(self.open()){
							key.setScope('nav');
						}else{
							key.setScope('ds');
						}
					}
					self.open(!self.open());
					if (self.open() && jQuery('.main_spreading').is(':visible')) {
						jQuery('.main_spreading, .spread-footnotes').hide();
						jQuery('.nav .current-spread').removeClass('active');
					} else if (!self.open() && jQuery('.main_spreading').is(':hidden')) {
						jQuery('.main_spreading, .spread-footnotes').show();
						jQuery('.nav .current-spread').addClass('active');
					}
				} else {
					if (e) {
						e.cancelBubble = true;
						if (e.stopPropagation) e.stopPropagation();
						if (e.stopImmediatePropagation) e.stopImmediatePropagation();
					}
					self.spread.promptSave();
				}
			};
			self.closeApp = function(e){
				if (e != self.app.appId) {
					self.open(false);
				}
			}
			if ( typeof key !== "undefined" ) {
				key('tab', 'ds', function(event, handler){
					var found = false;
					var td = jQuery(event.srcElement).parent().next('td');
					do{
						if(jQuery(td).has('input').length > 0){
							jQuery(td).find('input').focus();	
							found = true;
						}
						td = jQuery(td).next('td');
						if(td.length == 0){
							found = true;
						}
					}while(found == false);
				});
				key.filter = function(event){
					return true;
				};
			}

			self.onConfigurationChanged = function(data) {
				if (data['name'] === LifeCycle.msgs.msg_configuration_show_footnotes) {
					self.container.showFootnotes(data['value']);
					self.save();
				}
			}

			self.save = function(){
				var totalMonthlyDebtService = self.container.totalMonthlyDebtService();
				if (!self.spread || !self.spread.updateDebtServiceRecords) {
					return;
				}
				
				self.spread.updateDebtServiceRecords(totalMonthlyDebtService, function(){
					LifeCycle.Spreads.saveDebtSchedule(
						self,
						app.mapToJS(self),
						function(result, event){
							LifeCycle.SpreadsService.saveIForce(
								app.mapToJS(self.legalEntity, { useOptimizedMapper: true, maxDepth: 0 }),
								function(result, event){
									app.mapFromJS(result, app.getMapping(), self.legalEntity);
								},
								app.log.failure);
						},
						 function(result, event){
							app.log.failure;
						}
					);
				});


			};

			self.container.totalMonthlyDebtService.subscribe(function(value){
				if(!self.isPrintView()){
					self.legalEntity.monthlyDebtService = value;
				}
			});
			self.open.subscribe(function(value){
				if(!_.isUndefined(self.spread.datePickerApp)){
					self.spread.datePickerApp.viewModel.debtScheduleOpen(value);
				}
				if(!_.isUndefined(self.spread.spreadConfigApp)){
					self.spread.spreadConfigApp.viewModel.debtScheduleOpen(value);
				}
			});
			
			self.allowAction = function() {
				return (!self.isEditing() && !self.isCommenting());
			};

			self.iconOpacity = ko.computed(function(){
				return (self.allowAction()) ? { opacity:0, cursor: 'pointer'} : { opacity: 0.5, cursor: 'pointer'};
			});
			self.commentIconOpacity = ko.computed(function(){
				return (!self.isEditing()) ? { opacity:0, cursor: 'pointer'} : { opacity: 0.5, cursor: 'pointer'};
			});

			var o = jQuery(window.document);
			app.subscribeOnce = function(topic, callback){
				function wrapper(){
					return callback.apply(this, Array.prototype.slice.call(arguments, 1));
				}
				o.one(topic, wrapper);
			};
			app.subscribeOnce('SPREAD.Spreads.Load_Debt_Schedule', function (debtScheduleParams) {
				var debtScheduleVM = new app.ViewModel(debtScheduleParams);
				debtScheduleVM.loadDebtSchedule(function(){
					app.publish('SPREAD.Spreads.Debt_Schedule_Loaded', debtScheduleVM);
				});
			});

			self.load = function(){
				app.subscribe('SPREAD.Spreads.Statement_Ready', self.statementReady);
			};

			self.statementReady = function(statementId){
				if (statementId == self.spread.spreadConfigApp.viewModel.statement.recordId()) {
					self.loadDebtSchedule();
				}
			};
			self.loadDebtSchedule = function(callback){
				LifeCycle.blockUI('300px');
				app.subscribe('SPREAD.Spreads.Configuration_Changed', self.onConfigurationChanged);
				app.subscribe('SPREAD.Spreads.Fullscreen_App_Opened', self.closeApp);
				LifeCycle.Spreads.loadDebtSchedule(
					self,
					self.spread.spreadId,
					function(result, event){
						app.mapFromJS(result.debtScheduleAnalysis, app.getMapping(), self);
						self.relationship = result.debtScheduleAnalysis.relationship;
						self.loaded(true);
						LifeCycle.unblockUI();
						LifeCycle.SpreadsService.retrieveIForce(
							self.legalEntity,
							self.legalEntity.recordId,
							function(result, event){
								if (result.monthlyDebtService == undefined) {
									result.monthlyDebtService = 0;
								}
								app.mapFromJS(result, app.getMapping(), self.legalEntity);
								self.borrowerType(self.legalEntity.borrowerType());
								self.container.selectedEntity(self.legalEntity.relationship.recordId());
								if (self.spread.datePickerApp != undefined) {
									if (self.spread.datePickerApp.viewModel.showFootnotes() != self.container.showFootnotes()) {
										self.container.showFootnotes(self.spread.datePickerApp.viewModel.showFootnotes());
									}
								}
								self.save();
								if(_.isFunction(callback)){
								    callback.apply();
								}
							},
							app.log.failure,{
								buffer: false
							});
					}, function(result, event){
						app.log.failure;
					}
				);
			};
			
			self.creditFacilitiesAdd = function() {
				self.isEditing(true);
				var debt = new app.DebtScheduleLoan({"source": msgs.msg_user, "relationshipId": self.legalEntity.relationship.recordId()});
				debt.isEditing(true);
				self.container.creditFacilities.push(debt);
			}

			self.proposedLoansAdd = function() {
				self.isEditing(true);
				var debt = new app.DebtScheduleLoan({"source": msgs.msg_user, "relationshipId": self.legalEntity.relationship.recordId()});
				debt.isEditing(true);
				self.container.proposedLoans.push(debt);
			}


			self.removeDebt = function(debt) {
				if (self.allowAction()) {
					if ( confirm(msgs.msg_remove_prompt + ' ' + debt.name() + '?') ) {
						self.container.proposedLoans.remove(debt);
						self.container.creditFacilities.remove(debt);
						self.save();
					}
				}
			}

			self.editDebt = function(debt) {
				if (self.allowAction()) {
					debt.isEditing(true);
					self.isEditing(true);
				}
			}

			self.saveDebt = function(debt) {
				debt.isEditing(false);
				debt.savePending(false);
				self.isEditing(false);
				self.save();
			}

			self.toggleIsRemoved = function(debt) {
				if (self.allowAction()){
					debt.isRemoved(!debt.isRemoved());
					self.save();
				}
			}

			self.showComments = function(debt) {
				if (self.allowAction()) {
					debt.showComments(true);
					self.isCommenting(true);
				} else if (self.isCommenting() && !self.isEditing() && debt.showComments()) {
					self.comment('');
					self.comment.isModified(false);
					debt.showComments(false);
					self.isCommenting(false);
				} else if (self.isCommenting() && !self.isEditing() && !debt.showComments()) {
						self.comment('');
						self.comment.isModified(false);
					_.each(self.container.activeCreditFacilities(), function(loan) {
						loan.showComments(false);
					});
					_.each(self.container.activeProposedLoans(), function(loan) {
						loan.showComments(false);
					});
					debt.showComments(true);
				}
			}

			self.cancelComment = function(debt) {
				self.comment('');
				self.comment.isModified(false);
				debt.showComments(false);
				self.isCommenting(false);
			}

			self.addComment = function(debt, event) {
				if (self.user.name == undefined) {
					LifeCycle.SpreadsService.retrieveIForce(
						self.user,
						self.user.recordId,
						function(result, event){
							app.mapFromJS(result, app.getMapping(), self.user);
							_saveComment(debt);
							self.comment.isModified(false);
						},
						app.log.failure);
				} else {
					_saveComment(debt);
				}
			}

			var _saveComment = function(debt) {
				var toAdd = new app.DebtScheduleLoanComment();
				toAdd.comment(self.comment());
				toAdd.createdDate((new Date()).getTime());
				toAdd.name(self.user.name());
				toAdd.userId(self.user.recordId);
				debt.dsComments.push(toAdd);
				self.comment('');
				self.comment.isModified(false);
				self.save();
			}

			self.validationModel = ko.validatedObservable({
				comment: self.comment.extend({
					maxLength: 500,
					required: true
				})
			});

			return self;
			
		}
		
		app.setMapping({
			'container': {
				create: function(options){
					return new app.DebtScheduleContainer(options.data);
				}
			},
			'legalEntities': {
				create: function(options){
					return new app.LegalEntitySObject(options.data);
				}

			}
		});
		app.setTypesMap({
			'DebtSchedule.DebtScheduleContainer': 'debtScheduleContainer'
		});
		
	};
	
	if(LifeCycle.DebtSchedule.ViewModel == undefined){
		LifeCycle.DebtSchedule.ViewModel = ViewModel;
	}
	
})();

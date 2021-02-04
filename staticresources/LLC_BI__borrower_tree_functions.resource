(function (app){
		if(!LifeCycle.BorrowerTree){
			LifeCycle.BorrowerTree = { debug: false, buffer: true, remotingTimeout: 60000};
			LifeCycle.BorrowerTree.failure = function(result, event){
				console.log('[BORROWER TREE ERROR: ]');
				console.log(result);
				console.log(event);
				app.performingAjax(false);
				jQuery('#loading-modal').modal('hide');
				jQuery('body').removeClass('modal-open');
				jQuery('.modal-backdrop').remove();
				app.errorMsg(event.message);

				var messageDiv = jQuery('#errorMessage');
				messageDiv.show().html(event.message);

				jQuery('#BorrowerTreeError').modal("show");
				return console.log('[BORROWER TREE ERROR: ]' + (event? event.message : ''));
			};
			LifeCycle.BorrowerTree.debug = function(level, msg){
				if(LifeCycle.BorrowerTree.debug == true){
					console.log('[BORROWER TREE '+level+']: ' + msg);
				}
			};
			LifeCycle.BorrowerTree.debugObject = function(level, obj){
				if(LifeCycle.BorrowerTree.debug == true){
					console.log('[BORROWER TREE '+level+']: ');
					console.log(obj);
					console.log('[------------------]');
				}
			};
			if(!LifeCycle.BorrowerTree.postIncludeLoading){
				LifeCycle.BorrowerTree.postIncludeLoading = function () {
					if(!LifeCycle.BorrowerTree.remoteCallMap){
							LifeCycle.BorrowerTree.remoteCallMap = {
								'LOAN': LifeCycle.BorrowerTree.retrieveLoan,
								'RELATIONSHIP': LifeCycle.BorrowerTree.retrieveRelationship,
								'BORROWER': LifeCycle.BorrowerTree.retrieveBorrower,
								'GUARANTOR': LifeCycle.BorrowerTree.retrieveGuarantor,
								'SIGNER': LifeCycle.BorrowerTree.retrieveSigner,
								'CONTACT': LifeCycle.BorrowerTree.retrieveContact,
								'PRODUCTPACKAGE': LifeCycle.BorrowerTree.retrievePackage
							};
						}
						if(!LifeCycle.BorrowerTree.getCall){
							LifeCycle.BorrowerTree.getCall = function(type){
								return LifeCycle.BorrowerTree.remoteCallMap[type];
							};
						}
						if(!LifeCycle.BorrowerTree.typeMap){
							var PREFIX = LifeCycle.Spreads &&
							    LifeCycle.Spreads.getNamespacePrefix &&
							    LifeCycle.Spreads.getNamespacePrefix().length
								? LifeCycle.Spreads.getNamespacePrefix() + '.'
								: 'c.';
							var typeMap = {
								'LifeCycleLoan': 'LOAN',
								'LifeCycleRelationship': 'RELATIONSHIP',
								'LifeCycleBorrower': 'BORROWER',
								'LifeCycleGuarantor': 'GUARANTOR',
								'LifeCycleSigner': 'SIGNER',
								'LifeCycleContact': 'CONTACT',
								'ALifeCycleInvolvement': 'INVOLVEMENT',
								'LifeCycleProductPackage': 'PRODUCTPACKAGE'
							};
							LifeCycle.BorrowerTree.typeMap = {};
							_.each(typeMap, function(value, key){
								LifeCycle.BorrowerTree.typeMap[PREFIX + key] = value;
							});
						};
						if(!LifeCycle.BorrowerTree.typeMapFlipped){
							LifeCycle.BorrowerTree.typeMapFlipped = {};
							_.each(LifeCycle.BorrowerTree.typeMap, function(value, key){
								LifeCycle.BorrowerTree.typeMapFlipped[value] = key;
							});
						}
					}
			}
			LifeCycle.BorrowerTree._extend = function(obj) {
				_.each(Array.prototype.slice.call(arguments, 1), function(source) {
					if (source && source.apexType && source.isLoaded) {

						LifeCycle.BorrowerTree.debug('INFO', 'DEST');
						LifeCycle.BorrowerTree.debugObject('INFO', obj);

						LifeCycle.BorrowerTree.debug('INFO', 'SOURCE');
						LifeCycle.BorrowerTree.debugObject('INFO', source);

						for (var prop in source) {
							LifeCycle.BorrowerTree.debug('INFO', 'EXTEND KEY ' + prop);
							if(jQuery.isArray(source[prop])){

								LifeCycle.BorrowerTree.debug('INFO', 'ARRAY ' + true);

								if(!obj[prop]){
									obj[prop] = source[prop];
								}
								else{
									_.each(source[prop], function(element, index, list){
										LifeCycle.BorrowerTree._extend(obj[prop][index], element);
									});
								}
							}
							else if(source[prop] && obj[prop] && source[prop].apexType){
								LifeCycle.BorrowerTree.debug('INFO', 'RECURSE ' + true);
								LifeCycle.BorrowerTree._extend(obj[prop], source[prop]);
							}
							else{
								obj[prop] = source[prop];
							}
						}
					}
				});
				LifeCycle.BorrowerTree.debug('INFO', 'END EXTEND');
				LifeCycle.BorrowerTree.debugObject('INFO,', obj);
				return obj;
			};

			// -- Dynamic Remoting Action arguments in BorrowerTree.remotingTemplate --
			// Dynamic remoting action arguments must be at least one argument long, like:
			// (remoteCall, objToMergeInto,   recordId,   success, failure, remotingOptions, bBlockUI)
			//
			// When using extra remoting action arguments, you must provide all additional remotingTemplate arguments:
			//
			// OK:
			// (remoteCall, objToMergeInto,   recordId, arg2, arg3,  success, failure, remotingOptions, bBlockUI)
			//
			// NOT OK:
			// (remoteCall, objToMergeInto,   recordId, arg2, arg3,  success, failure)


			LifeCycle.BorrowerTree.remotingTemplate = function(remoteCall, objToMergeInto/*, remotingActionArg1[, arg2[, arg3[, ...]]], success, failure, remotingOptions, bBlockUI */) {
				var remotingArguments = [ arguments[2] ];
				var success = arguments[3];
				var failure = arguments[4];
				var remotingOptions = arguments[5];
				var bBlockUI = arguments[6];
				
				if (arguments.length > 7) {
					remotingArguments = Array.prototype.slice.call(arguments).slice(2, arguments.length - 4);

					success = arguments[arguments.length - 4];
					failure = arguments[arguments.length - 3];
					remotingOptions = arguments[arguments.length - 2];
					bBlockUI = arguments[arguments.length - 1];
				}

				if(bBlockUI){
					app.performingAjax(true);
				}
				LifeCycle.BorrowerTree.debug(
					'INFO',
					'calling ' + '[' + remoteCall + '] with arguments [' + objToMergeInto + '] and ['+JSON.stringify(remotingArguments)+']');

				var callingArgs = _.toArray(arguments);
				var defaultRemotingOptions = {
					escape: false,
					buffer: LifeCycle.BorrowerTree.buffer
				};
				if(!_.isUndefined(remotingOptions)){
					_.extend(defaultRemotingOptions, remotingOptions);
				}
				var actionArguments = [
					remoteCall,
					function(result, event){
						if(bBlockUI){
							app.performingAjax(false);
						}
						if (event.status) {
							success.apply(this, [result, event, objToMergeInto].concat(callingArgs));
						}
						else {
							var failureCallback = LifeCycle.BorrowerTree.failure;
							if(jQuery.isFunction(failure)){
								failureCallback = failure;
							}
							failureCallback.apply(this, [result, event, objToMergeInto].concat(callingArgs));
						}
					},
					defaultRemotingOptions
				];
				([]).splice.apply(actionArguments, [1, 0].concat(remotingArguments));

				return Visualforce.remoting.Manager.invokeAction.apply(Visualforce.remoting.Manager, actionArguments);
			};

			LifeCycle.BorrowerTree.saveRecordProxy = function(model, app, callback){
				LifeCycle.BorrowerTree.debug('INFO', 'validating model: ' + model.validationModel.isValid());
				app.validate(model);
				app.performingAjax(true);
				var raw = app.mapToJS(model);
				LifeCycle.BorrowerTree.debug('INFO', 'persisting model');
				LifeCycle.BorrowerTree.debugObject('INFO', raw);
				LifeCycle.BorrowerTree.saveRecord.apply(
						this,
						[raw,
						 function(result, event){
							app.performingAjax(false);
							app.mapFromJS(result, app.mapping[LifeCycle.BorrowerTree.typeMap[result.apexType]], model);
							if(jQuery.isFunction(callback)){
								callback.apply(this, [model, app, model])
							}
						}]);
			};
			ko.validation.init({
				decorateElement: true,
				errorElementClass: 'error has-error',
				errorMessageClass: 'help-inline help-block'
			});
		};
})(window.borrowerTreeApp);

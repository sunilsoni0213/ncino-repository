(function(){
	var LifeCycleApp = function(data){
		var self = this;
		
		var defaultData = {
			appId: null,
			buffer: false,
			debug: false,
			mapping: {},
			typesMap: {},
			typesMapFlipped: {}
		};
		if(data != undefined){
			_.extend(defaultData, data);
		}
		_.extend(self, defaultData);
		
		self.appMap = ko.observable(self.appMap);
		self.appOrder = ko.observableArray(self.appOrder);
		
		// Accessors/Mutators
		self.getMapping = function(){
			return self.mapping;
		};
		self.setMapping = function(mapping){
			if(mapping != null && typeof mapping == 'object'){
				_.extend(self.mapping, mapping);
			}
		};
		self.getTypesMap = function(){
			return self.typesMap;
		};
		self.getTypesMapFlipped = function(){
			return self.typesMapFlipped;
		};
		self.setTypesMap = function(typesMap){
			if(typesMap != null && typeof typesMap == 'object'){
				_.each(typesMap, function(value, key){
					if(key.indexOf(self.NAMESPACE_PREFIX) == -1){
						key = self.NAMESPACE_PREFIX + key;
					}
					self.getTypesMap()[key] = value;
					self.getTypesMapFlipped()[value] = key;
				});
			}
		};
		self.parentApp = function(){
			var parent = null;
			_.each(self.appOrder(), function(appName, index, list){
				if(appName == self.appId){
					if(index > 0){
						parent = self.appMap()[self.appOrder()[index-1]];
					}
				}
			});
			return parent;
		};
		// Logging
		self.log = (function(app){
			var self = function(msg, level){
				level = (level != undefined ? level : self.LEVELS.DEBUG);
				if(level <= self.LEVEL){
					var output = self.getOutput(level);
					if(typeof msg == 'object'){
						console.log('[LIFECYCLE APP: ' + app.appId + ' - ' + output + ']: ');
						console.log(msg);
						console.log('[-------------------]');
					}else{
						console.log('[LIFECYCLE APP: ' + app.appId + ' - ' + output + ']: ' + msg);
					}
				}
			};
			
			self.errorMsg = ko.observable('');
			
			self.failure = function(result, event){
				var output = self.getOutput(self.LEVELS.ERROR);
				app.log(result, self.LEVELS.ERROR);
				app.log(event, self.LEVELS.ERROR);
				self.errorMsg(event.message);
				return console.log('[LIFECYCLE APP ' + output + ']: '
								+ (event ? event.message : ''));
			};
			
			self.OUTPUT = [
				'ERROR',
				'WARN',
				'DEBUG',
				'INFO'
			];
			
			self.LEVELS = {
				ERROR: self.OUTPUT.indexOf('ERROR'),
				WARN: self.OUTPUT.indexOf('WARN'),
				DEBUG: self.OUTPUT.indexOf('DEBUG'),
				INFO: self.OUTPUT.indexOf('INFO')
			};
			
			self.LEVEL = (app.debug == true ? self.LEVELS.DEBUG : self.LEVELS.ERROR);
			
			self.getOutput = function(level){
				return (level != undefined && self.OUTPUT[level] != undefined
						? self.OUTPUT[level] : self.OUTPUT[self.DEBUG]);
			};
			
			return self;
		})(self);
		
		// Mapping
		self.mapFromJS = function(data, mapping, instance){
			return ko.mapping.fromJS(data, mapping, instance);
		};
		self.mapToJS = function(instance){
			return ko.mapping.toJS(instance);
		};
		self.mapApexFromModel = function(modelType){
			if(modelType != undefined && self.getTypesMapFlipped()[modelType] != undefined){
				return self.getTypesMapFlipped()[modelType];
			}
			return undefined;
		};
		self.mapApexToModel = function(apexType){
			if(apexType != undefined && self.getTypesMap()[apexType] != undefined){
				return self.getTypesMap()[apexType];
			}
			return undefined;
		};
		// Remoting
		var _ajaxPerformers = ko.observableArray([]);
		self.performingAjax = ko.computed({
			read: function(){
				return _ajaxPerformers().length > 0;
			},
			write: function(value){
				if(value){
					_ajaxPerformers.push(value);
				}else{
					_ajaxPerformers.pop();
				}
			}
		});
		self.performingAjax.subscribe(function(newValue){
			(newValue ? self.blockUI : self.unblockUI)();
		});
		self.remotingAction = function(remoteCall, remoteArgs, callbackArgs, success, failure){
			self.performingAjax(true);
			self.log('Calling ' + '[' + remoteCall + '] with arguments [' + remoteArgs + ']');
			
			remoteArgs = (_.isEmpty(remoteArgs)
					? [] : (_.isArray(remoteArgs) ? remoteArgs : [remoteArgs]));
			callbackArgs = (_.isEmpty(callbackArgs)
					? [] : (_.isArray(callbackArgs) ? callbackArgs : [callbackArgs]));
			
			remoteArgs.unshift(remoteCall);
			remoteArgs.push(function(result, event){
				self.performingAjax(false);
				if (event.status) {
					success.apply(this, [result, event].concat(callbackArgs));
				}
				else {
					(_.isFunction(failure) ? failure : self.log.failure).apply(
							this, [result, event].concat(callbackArgs));
				}
			});
			remoteArgs.push({escape: false, buffer: self.buffer});
			
			return Visualforce.remoting.Manager.invokeAction.apply(this, remoteArgs);
		};
		return self;
	};
	LifeCycleApp.prototype = {
		blockUI: function(){ return LifeCycle.blockUI(); },
		unblockUI: function(){ return LifeCycle.unblockUI(); },
		preRun: function(data){ return data; },
		postRun: function(vm){ return true; }
	};
	LifeCycle.App = LifeCycleApp;
	
	var Registration = function(){
		var self = this;
		var _appMap = {};
		var _loggingApp = new LifeCycle.App({debug: false, appId: 'REGISTRATION_APP'}); 
		self.registeredApps = _appMap;
		self.registeredAppsOrder = [];
		
		// Registration
		var EVENTS = {
			INIT_EXT: 'initExt',
			INIT_MODELS: 'initModels',
			INIT_VM: 'initVM',
			INIT_VIEW: 'initView'
		};
		self.registerAppName = function(name){
			if(!_appMap[name]){
				self.log('Registering app with name: ' + name);
				_appMap[name] = new LifeCycle.App({
					debug: false,
					appId: name,
					appMap: self.registeredApps,
					appOrder: self.registeredAppsOrder
				});
				self.registeredAppsOrder.push(name);
			}
		};
		self.registerExtension = function(callback){
			self.log('Registering extension..');
			jQuery(document).one(EVENTS.INIT_EXT, callback);
		};
		self.registerModels = function(appId, callback){
			self.log('Registering models with app: ' + appId);
			jQuery(document).one(EVENTS.INIT_MODELS + appId, callback);
		};
		self.registerViewModel = function(appId, callback){
			self.log('Registering view model with app: ' + appId);
			jQuery(document).one(EVENTS.INIT_VM + appId, callback);
		};
		self.registerView = function(appId, callback){
			self.log('Registering view with app: ' + appId);
			jQuery(document).one(EVENTS.INIT_VIEW + appId, callback);
		};
		self.preRun = function(data){
			self.log('Executing pre-run hook...');
			data = (data != undefined ? data : {});
			_.each(_appMap, function(value, key, map){
				data[key] = value.preRun((data[key] != undefined ? data[key] : {}));
			});
			return data; 
		};
		self.postRun = function(vm){
			self.log('Executing post-run hook...');
			var retval = true;
			_.each(_appMap, function(value, key, map){
				retval = retval && value.postRun(vm[key]);
			});
			return retval; 
		};
		self.View = function(vm){
			self.log('Instantiating view...');
			var appData = {};
			_.each(_appMap, function(value, key, map){
				if(_.isFunction(value.View)){
					appData[key] = new value.View(vm[key]);
					_appMap[key].view = appData[key];
				}
			});
			return appData;
		};
		self.getMapping = function(){
			var appData = {};
			_.each(_appMap, function(value, key, map){
				appData[key] = {
						create: function(options){
							_appMap[key].viewModel = new value.ViewModel(options.data);
							return _appMap[key].viewModel;
						}
				}
			});
			return appData;
		};
		self.ViewModel = function(data){
			self.log('Instantiating view model...');
			var appData = {};
			_.each(_appMap, function(value, key, map){
				appData[key] = data[key];
			});
			return appData;
		};
		self.log = function(){
			return _loggingApp.log.apply(this, arguments);
		};
		// Execution
		self.run = function(data){
			data = self.preRun(data);
			self.viewModel = ko.mapping.fromJS(
					new self.ViewModel(data),
					self.getMapping());
			ko.applyBindings(ko.validatedObservable(self.viewModel));
			
			self.view = new self.View(self.viewModel);
			self.postRun(self.viewModel);
			self.log('LifeCycleApp running.');
			return self;
		};
		jQuery(function(){	// On DOM ready
			
			self.NAMESPACE_PREFIX = 'c.';
			jQuery(document).trigger(EVENTS.INIT_EXT, [self]);
			
			_.each(_appMap, function(value, key, map){
				
				_appMap[key].NAMESPACE_PREFIX = self.NAMESPACE_PREFIX;
				
				self.log('Instantiating app artifacts: ' + value.appId);
				
				jQuery(document).trigger(
						jQuery.Event(EVENTS.INIT_MODELS + value.appId), 
						[value]);
				jQuery(document).trigger(
						jQuery.Event(EVENTS.INIT_VM + value.appId), 
						[value]);
				jQuery(document).trigger(
						jQuery.Event(EVENTS.INIT_VIEW + value.appId), 
						[value]);
			});
			
		});
		self.log('LifeCycleApp initialized.');
		return self;
	};
	window.LifeCycle.RegistrationApp = new Registration();
	
})();
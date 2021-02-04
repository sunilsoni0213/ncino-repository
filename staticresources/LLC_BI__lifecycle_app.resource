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

		var o = jQuery(window.document);
		self.subscribe = function(topic, callback){
			function wrapper(){
				return callback.apply(this, Array.prototype.slice.call(arguments, 1));
			}
			o.on(topic, wrapper);
		};
		self.subscribeOnce = function(topic, callback){
			function wrapper(){
				return callback.apply(this, Array.prototype.slice.call(arguments, 1));
			}
			o.one(topic, wrapper);
		};
		self.unsubscribe = function(){
			o.off.apply(o, arguments);
		};
		self.publish = function(){
			o.trigger.apply(o, arguments);
		};

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
					if(!_.isUndefined(self.NAMESPACE_PREFIX)
							&& key.indexOf(self.NAMESPACE_PREFIX) == -1){
						key = self.NAMESPACE_PREFIX + key;
					}
					self.getTypesMap()[key] = value;
					self.getTypesMapFlipped()[value] = key;
				});
			}
		};
		self.pad = function (width, string, padding) { 
			return (width <= string.length) ? string : self.pad(width, padding + string, padding);
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
		self.mapToJS = function(instance, _options) {
			var _instance = ko.unwrap(instance);
			if (
					!_instance || (
						!_instance.__cached &&
						!(_options || {}).useOptimizedMapper
					) || _instance.__useKoMapper
				) {
				return ko.mapping.toJS(instance);
			} else {

				// Allowed "height" for traversing parent properties
				// just the object itself would be 0
				// recordTotal.statement.bundle would be 2;

				// Max depth is how far to traverse children
				// null/undefined - go as deep as possible
				// 0 - no children
				// 1 - 1st level children
				var options = {
					maxHeight: 0,
					maxDepth: null,
					allowedPaths: [],
					debug: false
				};
				_.extend(options, _options);


				if (!options.allowedPaths && !(options.allowedPaths instanceof Array)) {
					throw 'app.mapToJS allowedPaths option must be an Array';
				}

				var currentHeight = 0;
				var currentDepth = 0;
				var currentPath = '$root';
				function _map (_instance, currentHeight, currentDepth, currentPath, _parentId) {

					var _instanceId;
					if (_instance && _instance.recordId) {
						_instanceId = ko.unwrap(_instance.recordId);
					}

					var js = {};
					if (options.debug) {
						js.__path = currentPath;
						js.__height = currentHeight;
						js.__depth = currentDepth;
					}

					var exclusionMode = !!(_instance.__ko_mapping__ && _instance.__ko_mapping__.mappedProperties);

					function _generateIgnoredEdge (prop, val, heightDifference) {
						var obj = {
							apexType: ko.unwrap(val.apexType),
							recordId: ko.unwrap(val.recordId)
						};

						if (options.debug) {
							obj.__path = currentPath + '.' + prop;
							obj.__depth = currentDepth;
							obj.__height = currentHeight + Number(heightDifference);
						}

						return obj;
					}

					function _isPathExplicitlyAllowed (path) {
						var checkPath = path.replace(/\[[0-9]+\]/g, '');
						for (var i = 0; i < options.allowedPaths.length; i++) {
							var allowedPath = options.allowedPaths[i].replace(/\[[0nx]?\]/g, '');
							if (allowedPath.indexOf(checkPath) === 0) {
								return true;
							}
						}
						return false;
					}

					if (typeof _instance != 'object') {
						return _instance;
					}

					var ignores = [];
					var mappedParents = {};
					for (var prop in _instance) {
						if ((
							_instance.__ko_mapping__ &&
							_instance.__ko_mapping__.ignore &&
							_instance.__ko_mapping__.ignore.indexOf(prop) != -1
						) || (
							exclusionMode && 
							!_instance.__ko_mapping__.mappedProperties[prop]
						)) {
							// Skip property
							continue;
						}
						if (_instance.hasOwnProperty(prop)) {
							var val = _instance[prop];
							var _val = ko.unwrap(val);
							var propPath = currentPath + '.' + prop;
							if (_val && typeof _val == 'object') {
								if (_val instanceof Array) {
									// Children property
									if (
										currentDepth < options.maxDepth || 
										(!options.maxDepth && options.maxDepth !== 0) ||
										_isPathExplicitlyAllowed(propPath)
									) {
										var jsChildren = [];
										for (var i = 0; i < _val.length; i++) {
											// Replace child with premapped version
											var child = _val[i];
											var childPath = currentPath + '.' + prop + '[' + i + ']';
											var jsChild = _map(child, 0, currentDepth + 1, childPath, _instanceId);
											jsChildren.push(jsChild);
										}
										js[prop] = jsChildren;
									} else {
										// Too deep, skip property
									}
								} else if (_val.apexType) {
									// Parent property

									// Ignore back-edge to parent
									var valId = ko.unwrap(_val.recordId);
									if (_18Id(valId) == _18Id(_parentId) && valId) {
										js[prop] = _generateIgnoredEdge(prop, _val, 1);
										continue;
									}

									// Ignore back-edges past max depth (except allowed paths)
									if (
										currentHeight < options.maxHeight || 
										_isPathExplicitlyAllowed(propPath)
									) {
										// Map object
										var jsParent = _map(_val, currentHeight + 1, currentDepth, propPath);
										js[prop] = jsParent;
									} else {
										// Too high up
										js[prop] = _generateIgnoredEdge(prop, _val, 1);
									}
								} else {
									// Direct map
									js[prop] = _map(_val, currentHeight, currentDepth, propPath);
								}
							} else {
								js[prop] = _val;
							}
						}
					}
					return js;
				}

				if (_instance instanceof Array) {
					var items = [];
					for (var i = 0; i < _instance.length; i++) {
						var item = _instance[i];
						items.push(_map(item, currentHeight, currentDepth, currentPath));
					}
					return items;
				} else {
					return _map(_instance, currentHeight, currentDepth, currentPath);
				}
			}
		};
		self.retrieve = function(model, success, remotingOptions) {
			LifeCycle.BorrowerTree.retrieveIForce(
				model,
				model.recordId(),
				function(result, event) {
					self.mapFromJS(result, self.getMapping(), model);
					if (_.isFunction(success)) {
						success.apply(this, [result, event, model]);
					}
				},
				self.log.failure,
				remotingOptions,
				false
			);
		};
		self.retrieveAll = function(models, success, remotingOptions) {
			var recordIdSet = [];
			for (var i = 0; i < models.length; i++) {
				var model = models[i];
				recordIdSet.push(model.recordId());
			}
			LifeCycle.BorrowerTree.retrieveIForces(
				models,
				recordIdSet,
				function(results, event) {
					for (var i = 0; i < results.length; i++) {
						var result = results[i];
						for (var j = 0; j < models.length; j++) {
							var model = models[j];
							if (model.recordId() == result.recorId()) {
								self.mapFromJS(result, self.getMapping(), model);
								break;
							}
						}
					}
					if (_.isFunction(success)) {
						success.apply(this, [result, event, models]);
					}
				},
				self.log.failure,
				remotingOptions,
				false
			);
		};
		self.save = function(model, success) {
			LifeCycle.BorrowerTree.saveRecord(
				model,
				function(result, event){
					self.mapFromJS(result, self.getMapping(), model);
					if(typeof success == 'function'){
						success.apply(this, [arguments]);
					}
				},
				self.log.failure
			);
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
		blockUI: function(){ return LifeCycle.blockUI ? LifeCycle.blockUI() : Utils.blockUI(); },
		unblockUI: function(){ return LifeCycle.unblockUI ? LifeCycle.unblockUI() : Utils.unblockUI(); },
		preRun: function(data){ return data; },
		postRun: function(vm){ return true; }
	};
	LifeCycle.App = LifeCycleApp;
	
	var Registration = function(){
		var self = this;
		var _appMap = {};
		var _loggingApp = new LifeCycle.App({debug: false, appId: 'REGISTRATION_APP'}); 
		self.registeredApps = _appMap;
		
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
				_appMap[name] = new LifeCycle.App({debug: false, appId: name});
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
		self.getAppsByName = function (desiredAppName) {
			var apps = this.registeredApps;
			var matchingApps = [];

			for (var prop in apps) {
				if (apps.hasOwnProperty(prop)) {
					var registeredAppName = prop;
					if (registeredAppName.indexOf(desiredAppName) === 0) {
						// Match
						matchingApps.push(apps[registeredAppName]);
					}
				}
			}

			return matchingApps;
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
			
			self.NAMESPACE_PREFIX = (!_.isUndefined(LifeCycle.Spreads)
					&& LifeCycle.Spreads.getNamespacePrefix().length > 0)
					? LifeCycle.Spreads.getNamespacePrefix() + '.' : 'c.';
			
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

	/* 
		SFDC Id utilities
		Convert between case-sensitive 15-char Ids and 18-char case-insensitive Ids
	*/
	window._15Id = function (id18) {
		if (typeof id18 != 'string') {
			return '';
		} else if (id18.length == 15) {
			return id18;
		} else if (id18.length != 18) {
			return '';
		}

		var id = id18.toString().substring(0, 15);
		var code = id18.toString().substring(15, 18);
			
		function _pad5 (num) {
			var s = "0000" + num;
			return s.substr(s.length - 5);
		}

		// Apply case-code
		var result = '';
		for (var i = 0; i < 3; i++) {
			var codeChr = code.charCodeAt(i) - 65;
			var caseBinary = codeChr.toString(2);
			var caseValues = _pad5(caseBinary).split('').reverse();
			var slice = id.substring(i * 5, i * 5 + 5);

			for (var j = 0; j < 5; j++) {
				var sliceChr = slice.charAt(j);
				var shouldBeUpperCase = caseValues[j];
				if (shouldBeUpperCase == '1') {
					result += sliceChr.toUpperCase();
				} else {
					result += sliceChr.toLowerCase();
				}
			}
		}
		return result;
	};

	window._18Id = function (id15) {
		if (typeof id15 != 'string') {
			return '';
		} else if (id15.length == 18) {
			return id15;
		} else if (id15.length != 15) {
			return '';
		}
		
		// Generate case-code
		id15 = id15.toString();
		if (id15.length < 15) {
			return null;
		}
		id15 = id15.substring(0, 15);
		
		var code = '';
		for (var i = 0; i < 15; i+=5) {
			var section = id15.substring(i, i + 5);
			var arr = section.split('');
			var val = 0;
			for (var j = 0; j < 5; j++) {
				var chr = arr[j];
				if (chr != chr.toLowerCase()) {
					// Is uppercase
					val += Math.pow(2, j);
				}
			}
			var charVal;
			if (val >= 0 && val <= 25) {
				charVal = val + 65;
			} else {
				charVal = val + 22;
			}
			code += String.fromCharCode(charVal);
		}
		
		return id15 + code;
	};
	
	window.LifeCycle.RegistrationApp = new Registration();


	/*
		SFDC Id utilities
		Convert between case-sensitive 15-char Ids and 18-char case-insensitive Ids
	*/
	window._15Id = function (id18) {
		if (typeof id18 != 'string') {
			return '';
		} else if (id18.length == 15) {
			return id18;
		} else if (id18.length != 18) {
			return '';
		}

		var id = id18.toString().substring(0, 15);
		var code = id18.toString().substring(15, 18);

		function _pad5 (num) {
			var s = "0000" + num;
			return s.substr(s.length - 5);
		}

		// Apply case-code
		var result = '';
		for (var i = 0; i < 3; i++) {
			var codeChr = code.charCodeAt(i) - 65;
			var caseBinary = codeChr.toString(2);
			var caseValues = _pad5(caseBinary).split('').reverse();
			var slice = id.substring(i * 5, i * 5 + 5);

			for (var j = 0; j < 5; j++) {
				var sliceChr = slice.charAt(j);
				var shouldBeUpperCase = caseValues[j];
				if (shouldBeUpperCase == '1') {
					result += sliceChr.toUpperCase();
				} else {
					result += sliceChr.toLowerCase();
				}
			}
		}
		return result;
	};

	window._18Id = function (id15) {
		if (typeof id15 != 'string') {
			return '';
		} else if (id15.length == 18) {
			return id15;
		} else if (id15.length != 15) {
			return '';
		}

		// Generate case-code
		id15 = id15.toString();
		if (id15.length < 15) {
			return null;
		}
		id15 = id15.substring(0, 15);

		var code = '';
		for (var i = 0; i < 15; i+=5) {
			var section = id15.substring(i, i + 5);
			var arr = section.split('');
			var val = 0;
			for (var j = 0; j < 5; j++) {
				var chr = arr[j];
				if (chr != chr.toLowerCase()) {
					// Is uppercase
					val += Math.pow(2, j);
				}
			}
			var charVal;
			if (val >= 0 && val <= 25) {
				charVal = val + 65;
			} else {
				charVal = val + 22;
			}
			code += String.fromCharCode(charVal);
		}

		return id15 + code;
	};

})();

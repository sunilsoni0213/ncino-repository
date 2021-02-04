(function () {
	/**
	 * @typedef {Object} IForceKO
	 *
	 * @property {(function(): string|KnockoutObservable)} apexType
	 * @property {(function(): string|KnockoutObservable)} name
	 * @property {(function(): string|KnockoutObservable)} recordId
	 */

	
	/**
	 * @typedef {Object} IForceJS
	 *
	 * @property {string} apexType
	 * @property {string} name
	 * @property {string} recordId
	 */
	
	if (!LifeCycle.IForceData) {
		LifeCycle.IForceData = {};
	}
	
	/**
	 *
	 * LifeCycle IForce Data Cache
	 *
	 * Includes facilities for loading IForce Data.
	 *
	 * Three main verbs are used to retrieve IForces from/via the cache:
	 * <ul>
	 *     <li>LOAD - Retrieve from server no matter what
	 *     <li>GET - Retrieve most efficient way possible
	 *     <li>LOOKUP - Only retrieve locally
	 * </ul>
	 *
	 * @class IForceCache
	 * @constructor
	 * @param {LifeCycle.App} [_optionalMappingApp]
	 * @param {Object} [_privateContext]
	 * @return {LifeCycle.IForceData.IForceCache}
	 */
	var IForceCache = function (_optionalMappingApp, _privateContext) {
		var self = this;

		if (!_privateContext) {
			_privateContext = {};
		}

		self.defaultIForceProvider = null;

		// ==============================================================
		// Public Cache Retrieval Functions
		// ==============================================================

		/* By Id */
		/**
		 * Calls {@link LifeCycle.IForceData.IForceCache.getIForcesById getIForcesById}
		 *
		 * @method
		 * @name IForceCache#getIForceById
		 * @param {string} id15Or18 - One 15 or 18 character SFDC Id
		 * @param {(Object|null|undefined)} [userOptions] - User defined options
		 * @param {boolean} [userOptions.useLiteForces] - Use LiteForces instead of IForces, defaults to
		 *     cache/extension property
		 * @param {boolean} [userOptions.wait = false]
		 * @param {boolean} [userOptions.alwaysLoadNewer = false] - If true, loadIForces will always be called
		 * @param {(Object|function)} [userOptions.iForceProvider = _utils.getIForceProvider()] - Override the cache's
		 *     IForceProvider
		 * @param {Array<*>} [userOptions.additionalArguments] - Additional arguments to apply onto the service
		 *     function
		 * @param {function} [userOptions.failureFunction] - Called when the service function fails
		 * @param {boolean} [userOptions.expectResult = true] - Expects at least one result to come back, otherwise
		 *     throws
		 * @param {boolean} [userOptions.cacheAsync = false] - Run cache calls inside a setTimeout(..., 0);
		 * @param {boolean} [userOptions.deferNotifications = false] - do not notifyAndRemoveSubscribers
		 * @param {boolean} [userOptions.readOnly = false] - Optionally omit expensive read/write preparations
		 * @param {function(IForceKO)} [callback] - callback with the requested IForce
		 * @returns {IForceKO} Immediately available IForces
		 */
		self.getIForceById = function (id15Or18, userOptions, callback) {
			var result = self.getIForcesById([id15Or18], userOptions, function (all) {
				if (callback && all instanceof Array) {
					if (all.length == 1) {
						callback(all[0]);
					} else {
						throw 'getIForceById: single IForce requested, but ' + all.length + ' were provided';
					}
				}
			});
			if (result instanceof Array) {
				if (result.length == 1) {
					return result[0];
				} else {
					throw 'getIForceById: single IForce requested, but ' + result.length + ' were provided';
				}
			}
		};

		/**
		 * Get IForces By Id.
		 * Use when you need IForces, but don't need duplicate/fresher requests
		 *
		 * Calls {@link LifeCycle.IForceData.IForceCache.lookupIForceById lookupIForceById} and conditionally,
		 * {@link LifeCycle.IForceData.IForceCache.loadIForcesById loadIForcesById}
		 *
		 * @method
		 * @name IForceCache#getIForcesById
		 * @param {Array<string>} ids15Or18 - Array of 15 or 18 character SFDC Ids
		 * @param {(Object|null|undefined)} [userOptions] - User defined options
		 * @param {boolean} [userOptions.useLiteForces] - Use LiteForces instead of IForces, defaults to
		 *     cache/extension property
		 * @param {boolean} [userOptions.wait = false]
		 * @param {boolean} [userOptions.alwaysLoadNewer = false] - If true, loadIForces will always be called
		 * @param {(Object|function)} [userOptions.iForceProvider = _utils.getIForceProvider()] - Override the cache's
		 *     IForceProvider
		 * @param {Array<*>} [userOptions.additionalArguments] - Additional arguments to apply onto the service
		 *     function
		 * @param {function} [userOptions.failureFunction] - Called when the service function fails
		 * @param {boolean} [userOptions.expectResult = true] - Expects at least one result to come back, otherwise
		 *     throws
		 * @param {boolean} [userOptions.cacheAsync = false] - Run cache calls inside a setTimeout(..., 0);
		 * @param {boolean} [userOptions.deferNotifications = false] - do not notifyAndRemoveSubscribers
		 * @param {boolean} [userOptions.readOnly = false] - Optionally omit expensive read/write preparations
		 * @param {function(Array<IForceKO>)} [callback] - callback with all requested IForces
		 * @returns {Array<IForceKO>} Immediately available IForces
		 */
		self.getIForcesById = function (ids15Or18, userOptions, callback) {
			var options = {
				wait: false,
				alwaysLoadNewer: false
			};
			
			if (userOptions) {
				_.extend(options, userOptions);
			}

			options.recordIds = ids15Or18;

			var unavailableIds = [];
			var availableIForces = [];
			var placeholders = [];
			for (var i = 0; i < options.recordIds.length; i++) {
				var requestedId = options.recordIds[i];
				var existingIForce = self.lookupIForceById(requestedId, options);
				if (existingIForce && !_utils.isPlaceholder(existingIForce)) {
					availableIForces.push(existingIForce);
				} else {
					if (existingIForce) {
						placeholders.push(existingIForce);
					}
					
					unavailableIds.push(_18Id(requestedId));
				}
			}

			function _loadedRemaining (iForces) {
				if (!(iForces instanceof Array)) {
					throw 'getIForcesById: Did not receive iForce array from loader';
				}

				for (var i = 0; i < iForces.length; i++) {
					availableIForces.push(iForces[i]);
				}

				if (callback) {
					callback(availableIForces);
				}

				return availableIForces;
			}

			var _pendingChanged;
			if (unavailableIds.length === 0) {
				if (options.alwaysLoadNewer) {
					if (pendingRequests().length) {
						// Delay loadNewer request
						_pendingChanged = function (newArray) {
							if (!newArray.length) {
								if (changeSubscription) {
									changeSubscription.dispose();
								}
								
								self.loadIForcesById(options.recordIds, options, _loadedRemaining);
							}
						};
						
						var changeSubscription = pendingRequests.subscribe(_pendingChanged);
					} else {
						self.loadIForcesById(options.recordIds, options, _loadedRemaining);
					}
				} else {
					// Use cached
					return _loadedRemaining([], true);
				}
			} else if (!options.wait) {
				if (!options.alwaysLoadNewer) {
					options.recordIds = unavailableIds;
				}
				
				self.loadIForcesById(options.recordIds, options, _loadedRemaining);
			} else {
				// Wait
				_app.log('Pending on [' + unavailableIds + ']');

				var _loadSubscription = function (iForce) {
					_app.log('iForce ' + iForce.recordId() + ' is now ready');
					var unavailableIndex = unavailableIds.indexOf(iForce.recordId());
					unavailableIds.splice(unavailableIndex, 1);

					if (availableIForces.indexOf(iForce) == -1) {
						availableIForces.push(iForce);
					}

					if (!unavailableIds.length) {
						_app.log('All requested iForces loaded');
						_loadedRemaining([], true);
					}
				};

				for (var j = 0; j < unavailableIds.length; j++) {
					var unavailableId = unavailableIds[j];
					IdSubscription.create(unavailableId, this, _loadSubscription);
				}
			}

			if (placeholders.length && options.alwaysReturnModel) {
				return _loadedRemaining(placeholders, true);
			}
		};
		
		/**
		 * Calls {@link LifeCycle.IForceData.IForceCache.loadIForcesById loadIForcesById}
		 *
		 * @method
		 * @name IForceCache#loadIForceById
		 * @param {string} id15Or18 - One 15 or 18 character SFDC Id
		 * @param {(Object|null|undefined)} [userOptions] - User defined options
		 * @param {boolean} [userOptions.useLiteForces] - Use LiteForces instead of IForces, defaults to
		 *     cache/extension property
		 * @param {(Object|function)} [userOptions.iForceProvider = _utils.getIForceProvider()] - Override the cache's
		 *     IForceProvider
		 * @param {Array<*>} [userOptions.additionalArguments] - Additional arguments to apply onto the service
		 *     function
		 * @param {function} [userOptions.failureFunction] - Called when the service function fails
		 * @param {boolean} [userOptions.expectResult = true] - Expects at least one result to come back, otherwise
		 *     throws
		 * @param {boolean} [userOptions.cacheAsync = false] - Run cache calls inside a setTimeout(..., 0);
		 * @param {boolean} [userOptions.deferNotifications = false] - do not notifyAndRemoveSubscribers
		 * @param {boolean} [userOptions.readOnly = false] - Optionally omit expensive read/write preparations
		 * @param {function(IForceKO)} [callback] - callback with the requested IForce
		 * @returns void
		 */
		self.loadIForceById = function (id15Or18, userOptions, callback) {
			self.loadIForcesById([id15Or18], userOptions, function (all) {
				if (callback && all instanceof Array) {
					if (all.length == 1) {
						callback(all[0]);
					} else {
						throw 'loadIForceById: single IForce requested, but ' + all.length + ' were provided';
					}
				}
			});
		};
		
		/**
		 * Wraps and calls the appropriate retrieval service function to get the requested IForces
		 *
		 * Depending on configuration and scenario one of the following will be called:
		 * <ul>
		 *     <li><IForceProvider>.retrieveIForce
		 *     <li><IForceProvider>.retrieveIForces
		 *     <li><IForceProvider>.retrieveIForcesLean
		 *     <li>LifeCycle.LiteForceService.retrieveLiteForces
		 * </ul>
		 *
		 * The IForceProvider is determined from the following:
		 * <ul>
		 *     <li>The userOptions.iForceProvider option
		 *     <li>The cache extension's default provider
		 *     <li>The IForceCache default iForceProvider (default null)
		 *     <li>IForceUtils.getIForceProvider (<i>LifeCycle.Service</i>)
		 * </ul>
		 *
		 * @method
		 * @name IForceCache#loadIForcesById
		 * @param {Array<string>} ids15Or18 - Array of 15 or 18 character SFDC Ids
		 * @param {(Object|null|undefined)} [userOptions] - User defined options
		 * @param {boolean} [userOptions.useLiteForces] - Use LiteForces instead of IForces, defaults to
		 *     cache/extension property
		 * @param {(Object|function)} [userOptions.iForceProvider = _utils.getIForceProvider()] - Override the cache's
		 *     IForceProvider
		 * @param {Array<*>} [userOptions.additionalArguments] - Additional arguments to apply onto the service
		 *     function
		 * @param {function} [userOptions.failureFunction] - Called when the service function fails
		 * @param {boolean} [userOptions.expectResult = true] - Expects at least one result to come back, otherwise
		 *     throws
		 * @param {boolean} [userOptions.cacheAsync = false] - Run cache calls inside a setTimeout(..., 0);
		 * @param {boolean} [userOptions.deferNotifications = false] - do not notifyAndRemoveSubscribers
		 * @param {boolean} [userOptions.readOnly = false] - Optionally omit expensive read/write preparations
		 * @param {function(Array<IForceKO>)} [callback] - callback with all requested IForces
		 * @returns void
		 */
		self.loadIForcesById = function (ids15Or18, userOptions, callback) {
			var options = {
				iForceProvider: self.defaultIForceProvider || _utils.getIForceProvider(),
				useLiteForces: self.useLiteForces
			};
			if (userOptions) {
				_.extend(options, userOptions);
			}

			options.recordIds = ids15Or18;
			
			if (typeof options.iForceProvider == 'function') {
				options.iForceProvider = options.iForceProvider();
			}

			var iForceIdsToLoad = _trimPendingRequests(options.recordIds);
			var trimmedRequests = _.difference(options.recordIds, iForceIdsToLoad);

			var allIForces = [];
			for (var i = 0; i < trimmedRequests.length; i++) {
				var trimmedId = trimmedRequests[i];
				IdSubscription.create(trimmedId, this, _pendingLoaded);
			}

			function _pendingLoaded (iForce) {
				allIForces.push(iForce);
				var index = trimmedRequests.indexOf(iForce.recordId());
				trimmedRequests.splice(index, 1);

				if (callback && !iForceIdsToLoad.length && !trimmedRequests.length) {
					callback(allIForces);
				}
			}

			function _nonTrimmedLoaded (iForces) {
				allIForces.push.apply(allIForces, iForces);
				iForceIdsToLoad = [];

				if (callback && !trimmedRequests.length) {
					callback(allIForces);
				}
			}

			if (!iForceIdsToLoad.length) {
				return;
			}
			
			_addPendingRequests(iForceIdsToLoad);
			
			if (typeof options.iForceProvider.retrieveIForcesLean == 'function') {
				return self._iForceServiceTemplate(
					options.iForceProvider.retrieveIForcesLean, {
						objectToMergeInto: [],
						recordIds: iForceIdsToLoad,
						loaderOptions: options
					}, _nonTrimmedLoaded
				);
			} else if (iForceIdsToLoad.length > 1) {
				return self._iForceServiceTemplate(options.iForceProvider.retrieveIForces, {
					objectToMergeInto: [],
					recordIds: iForceIdsToLoad,
					loaderOptions: options
				}, _nonTrimmedLoaded);
			} else {
				return self._iForceServiceTemplate(options.iForceProvider.retrieveIForce, {
					objectToMergeInto: [],
					recordId: iForceIdsToLoad[0],
					loaderOptions: options
				}, _nonTrimmedLoaded);
			}
		};
		
		/**
		 * Lookup only, do not perform any retrieval actions
		 *
		 * @method
		 * @name IForceCache#lookupIForceById
		 * @param {string} id15Or18
		 * @param {Object} [userOptions]
		 * @param {boolean} [userOptions.generatePlaceholder = false] - If no match, generate and cache a placeholder
		 * @param {string} [userOptions.placeholderType = null] - Apex type to assign placeholder
		 * @param {boolean} [userOptions.alwaysReturnModel = false] - Return model even if not cache-able (no Id)
		 * @param {Array<string>} [userOptions.expectedTypes] - Filter result by expected type
		 * @param {boolean} [userOptions.includeNamespace = false] - Include namespace in expected type filter
		 * @param {boolean} [userOptions.cacheAsync = false] - Run cache calls inside a setTimeout(..., 0);
		 * @param {boolean} [userOptions.deferNotifications = false] - do not notifyAndRemoveSubscribers
		 * @param {boolean} [userOptions.readOnly = false] - Optionally omit expensive read/write preparations
		 * @param {(Object|function)} [userOptions.iForceProvider = _utils.getIForceProvider()] - Override the cache's
		 *     IForceProvider
		 * @return {*}
		 */
		self.lookupIForceById = function (id15Or18, userOptions) {

			var options = {
				includeNamespace: false,
				generatePlaceholder: false,
				placeholderType: null,
				alwaysReturnModel: false
			};
			if (userOptions) {
				_.extend(options, userOptions);
			}

			var includeNamespace = options.includeNamespace;

			var expectedTypes = options.expectedTypes;
			if (typeof options.expectedType == 'string') {
				expectedTypes = [options.expectedType];
			} else if (expectedTypes && !(expectedTypes instanceof Array)) {
				return null;
			}

			if (_15Id(id15Or18) != id15Or18 && _18Id(id15Or18) != id15Or18) {
				// Invalid SFDC Id
				if (
					options.generatePlaceholder &&
					options.placeholderType &&
					options.alwaysReturnModel
				) {
					// Return model anyways
					return _utils.constructModel({
						recordId: _18Id(id15Or18),
						apexType: options.placeholderType
					});
				}
				
				return null;
			}

			var match = _iForceMap[_18Id(id15Or18)];
			
			if (typeof match == 'undefined') {
				if (
					options.generatePlaceholder &&
					options.placeholderType
				) {
					var placeholder = {
						__placeholder: true,
						recordId: _18Id(id15Or18),
						apexType: options.placeholderType
					};
					return _cacheObject(placeholder, [], null, userOptions);
				}
				
				return null;
			}

			if (match && expectedTypes) {
				for (var t = 0; t < expectedTypes.length; t++) {
					var expectedType = expectedTypes[t];
					if (_utils.isType(match, expectedType, includeNamespace)) {
						return match;
					}
				}
				
				return null;
			}

			return match;
		};

		/* By Property */
		/**
		 * Shortcut for {@link LifeCycle.IForceData.IForceCache.lookupIForcesByProperty lookupIForcesByProperty}
		 *
		 * @method
		 * @name IForceCache#lookupIForcesByName
		 * @param {string} name
		 * @param {Object} [userOptions]
		 * @param {boolean} [userOptions.nameProperty = 'name']
		 * @param {boolean} [userOptions.caseSensitive = false]
		 * @param {function(IForceKO): boolean} [userOptions.filter] - additional criteria on each item in the search
		 * 	set
		 * @param {Array<IForceKO>} [userOptions.array] - narrow the search set
		 * @return {Array<IForceKO>}
		 */
		self.lookupIForcesByName = function (name, userOptions) {
			var options = {
				caseSensitive: false,
				nameProperty: 'name'
			};
			if (userOptions) {
				_.extend(options, userOptions);
			}

			return self.lookupIForcesByProperty(options.nameProperty, name, options);
		};
		
		/**
		 * Searches the entire cache (or a specified subset) for a particular property match
		 * Calls {@link LifeCycle.IForceData.IForceCache.lookupIForcesByFilter lookupIForcesByFilter}
		 *
		 * @method
		 * @name IForceCache#lookupIForcesByProperty
		 * @param {string} property
		 * @param {*} value
		 * @param {Object} [userOptions]
		 * @param {boolean} [userOptions.caseSensitive = false]
		 * @param {function(IForceKO): boolean} [userOptions.filter] - additional criteria on each item in the search
		 * 	set
		 * @param {Array<IForceKO>} [userOptions.array] - narrow the search set
		 * @return {Array<IForceKO>}
		 */
		self.lookupIForcesByProperty = function (property, value, userOptions) {
			var options = {
				caseSensitive: false,
				property: property
			};
			if (userOptions) {
				_.extend(options, userOptions);
			}
			
			function _each (obj) {
				if (options.caseSensitive || typeof ko.unwrap(obj[options.property]) != 'string') {
					if (ko.unwrap(obj[options.property]) != value) {
						return false;
					}
				} else {
					if (ko.unwrap(obj[options.property]).toLowerCase() != value.toLowerCase()) {
						return false;
					}
				}
				
				// Check filter
				if (options.filter) {
					return options.filter(obj);
				} else {
					return true;
				}
			}
			
			return self.lookupIForcesByFilter(_each, options);
		};
		
		/**
		 * Lookup cached IForces by a filter function
		 *
		 * @method
		 * @name IForceCache#lookupIForcesByFilter
		 * @param {function(IForceKO): boolean} filter - gets called on each eligible iForce
		 * @param {Object} userOptions - lookup options
		 * @param {Array<IForceKO>} [userOptions.array] - narrow the search set
		 * @return {Array<IForceKO>} Matched IForces
		 */
		self.lookupIForcesByFilter = function (filter, userOptions) {
			var matches = [];
			
			if (!filter) {
				return [];
			}
			
			var options = {
				filter: filter
			};
			if (userOptions) {
				_.extend(options, userOptions);
				
				if (userOptions.filter) {
					options.filter = function (x) {
						return filter(x) && userOptions.filter(x);
					};
				}
			}
			
			function _each (obj) {
				// Check filter
				try {
					if (options.filter(obj)) {
						matches.push(obj);
					}
				} catch (e) {
					console.error('IForce Lookup Filter Error: ' + e.toString());
				}
			}
			
			var obj;
			if (options.array) {
				for (var i = 0; i < options.array.length; i++) {
					obj = options.array[i];
					_each(obj);
				}
			} else {
				for (var prop in _iForceMap) {
					if (_iForceMap.hasOwnProperty(prop)) {
						obj = _iForceMap[prop];
						_each(obj);
					}
				}
			}
			
			return matches;
		};
		
		// ==============================================================
		// Public Cache Utility Functions
		// ==============================================================
		/**
		 * Checks the cache to see if the KO IForce is present
		 *
		 * @method
		 * @name IForceCache#isCached
		 * @param {IForceKO} obj
		 * @return {boolean}
		 */
		self.isCached = function (obj) {
			if (!obj) {
				return false;
			}
			
			var id = ko.unwrap(obj.recordId);
			if (!id) {
				return false;
			}
			
			return !!self.lookupIForceById(id);
		};
		
		// ==============================================================
		// Public Loader Functions
		// ==============================================================
		/**
		 * Calls a BorrowerTree-style VFRemoting Template that is expected to return Map<String, List<Id>>
		 * Subsequently requests the corresponding IForces via retrieveIForces (or cache if allowed)
		 *
		 * @method
		 * @name IForceCache#_iForceTypedIdMapServiceTemplate
		 * @param serviceFunction BorrowerTree-style VFRemoting Template to call
		 * @param userOptions Standard loader options
		 * @param callback
		 * @returns {*} Whatever the service function returns
		 */
		self._iForceTypedIdMapServiceTemplate = function (serviceFunction, userOptions, callback) {
			var options = {
				recordId: undefined,
				additionalArguments: [],
				failureFunction: function () {},

				expectResult: true,
				alwaysLoadNewer: false
			};
			if (userOptions) {
				_.extend(options, userOptions);
			}

			options.successFunction = function (results) {
				if (
					options.expectResult &&
					(
						!results ||
						(
							results instanceof Array &&
							results.length === 0
						)
					)
				) {
					throw 'IForce Id Loader: IForce Provider returned null result for: ' + options.recordId;
				}
				
				var allIds = [];
				for (var type in results) {
					if (results.hasOwnProperty(type)) {
						var typeIds = results[type];
						for (var i = 0; i < typeIds.length; i++) {
							var typeId = typeIds[i];
							if (allIds.indexOf(typeId) == -1) {
								allIds.push(typeId);
							}
						}
					}
				}
				
				if (options.alwaysLoadNewer) {
					self.loadIForcesById(allIds, options, callback);
				} else {
					self.getIForcesById(allIds, options, callback);
				}
			};

			return _serviceCallTemplate(serviceFunction, options.recordId, options);
		};

		/**
		 * Calls a BorrowerTree-style VFRemoting Template that is expected to return a list of Ids
		 * Subsequently requests the corresponding IForces via retrieveIForces (or cache if allowed)
		 *
		 * @method
		 * @name IForceCache#_iForceIdServiceTemplate
		 * @param serviceFunction BorrowerTree-style VFRemoting Template to call
		 * @param userOptions Standard loader options
		 * @param callback
		 * @returns {*} Whatever the service function returns
		 */
		self._iForceIdServiceTemplate = function (serviceFunction, userOptions, callback) {
			var options = {
				recordId: undefined,
				additionalArguments: [],
				failureFunction: function () {},

				expectResult: true,
				alwaysLoadNewer: false
			};
			if (userOptions) {
				_.extend(options, userOptions);
			}

			options.successFunction = function (results) {
				if (
					options.expectResult &&
					(
						!results ||
						(
							results instanceof Array &&
							results.length === 0
						)
					)
				) {
					throw 'IForce Id Loader: IForce Provider returned null result for: ' + options.recordId;
				}

				if (options.alwaysLoadNewer) {
					self.loadIForcesById(results, options, callback);
				} else {
					self.getIForcesById(results, options, callback);
				}
			};

			return _serviceCallTemplate(serviceFunction, options.recordId, options);
		};

		/**
		 * @Deprecated (Publicly) It is not recommended to use RemotingActions that return List<IForce> or IForce w/
		 *     IForceCache This limits the concurrency and caching optimizations that occur Instead use RemotingActions
		 *     that return List<Id> or Id with _iForceIdServiceTemplate
		 *
		 * @method
		 * @name IForceCache#_iForceServiceTemplate
		 * @param serviceFunction BorrowerTree-style VFRemoting Template to call
		 * @param userOptions Standard loader options
		 * @param callback
		 * @returns {*} Whatever the service function returns
		 */
		self._iForceServiceTemplate = function (serviceFunction, userOptions, callback) {
			var options = {
				recordId: undefined,
				recordIds: undefined,
				additionalArguments: [],
				failureFunction: function () {},
				
				loaderOptions: {},

				expectResult: true
			};
			if (userOptions) {
				_.extend(options, userOptions);
			}

			options.successFunction = function (results) {
				if (
					options.expectResult &&
					(
						!results ||
						(
							results instanceof Array &&
							results.length === 0
						)
					)
				) {
					throw 'IForce Loader: IForce Provider returned null result for: ' + options.recordId;
				}

				if (results instanceof Array && results[0].isLLCBI || results.isLLCBI) {
					options.loaderOptions.iForceProvider = LifeCycle;
				}
				
				if (self._liteForceUtils.hasLiteForces(results)) {
					results = self._liteForceUtils.translateLiteForces(results);
				}

				if (results instanceof Array) {
					self._cacheUnmappedIForces(results, callback, options.loaderOptions);
				} else {
					self._cacheUnmappedIForces([results], callback, options.loaderOptions);
				}
			};

			return _recordServiceTemplate(serviceFunction, options, callback);
		};

		function _recordServiceTemplate (serviceFunction, userOptions, callback) {
			var options = {
				objectToMergeInto: {},
				recordId: undefined,
				recordIds: undefined,
				additionalArguments: [],
				successFunction: function () {},
				failureFunction: function () {},
				loaderOptions: {},
				remotingOptions: {},
				blockUI: false
			};
			if (userOptions) {
				_.extend(options, userOptions);
			}

			if (options.recordIds) {
				if (!(options.recordIds instanceof Array)) {
					throw new Error('IForce Service Loader: options.recordIds must be an array');
				}

				_.each(options.recordIds, function (recordId) {
					if (_18Id(recordId) === '') {
						throw 'IForce Service Loader: All options.recordIds must be valid SFDC Ids, Invalid: ' +
							recordId;
					}
				});
			} else if (_18Id(options.recordId) === '') {
				throw new Error(
					'IForce Service Loader: options.recordId must be valid SFDC Id, Invalid: ' +
					options.recordId
				);
			}

			if (options.recordId) {
				options.successFunction = function (results) {
					if (
						options.expectResult &&
						(
							!results ||
							(
								results instanceof Array &&
								results.length === 0
							)
						)
					) {
						throw 'IForce Loader: IForce Provider returned null result for: ' + options.recordId;
					}

					if (results instanceof Array && results[0].isLLCBI || results.isLLCBI) {
						options.loaderOptions.iForceProvider = LifeCycle;
					}
					
					if (self._liteForceUtils.hasLiteForces(results)) {
						results = self._liteForceUtils.translateLiteForces(results);
					}

					self._cacheUnmappedIForces([results], callback, options.loaderOptions);
				};
				
				return _serviceCallTemplate(serviceFunction, options.recordId, options);
			} else {
				var ids = options.recordIds;

				var numQueues = Math.max(1, Math.ceil(self._concurrencyAvailable() / self._recordBatchChunkSize));
				var queueSize = Math.ceil(ids.length / numQueues); // How to split the set of ids into concurrent queue
				var chunkSize = self._recordBatchChunkSize;
				
				if (options.loaderOptions.iForceProvider == LifeCycle.LiteForceService) {
					numQueues = Math.min(
						Math.ceil(ids.length / self._liteRecordBatchChunkSize),
						Math.ceil(self._liteConcurrencyAvailable() / self._liteRecordBatchChunkSize)
					);
					queueSize = Math.ceil(ids.length / numQueues); // How to split the set of ids into concurrent queue
					chunkSize = self._liteRecordBatchChunkSize;
				}
				
				var batch = {
					id: ++self._stats.batchCount,
					requestIds: ids,
					queues: [],
					cachedResults: ko.observableArray(),
					batchSuccess: callback,
					batchFailure: options.failureFunction,
					batchStart: new Date(),
					batchEnd: null,

					flightTime: 0 // In-Flight time of all records (dont count rate limiting)
				};

				batch.inProgress = function () {
					for (var i = 0; i < batch.queues.length; i++) {
						var queue = batch.queues[i];
						if (queue.inProgress) {
							return true;
						}
					}
					
					return false;
				};

				self._batches.push(batch);

				for (var i = 0; i < numQueues; i++) {
					var start = i * queueSize;
					var end = start + queueSize;
					var queue = {
						id: i,
						batch: batch,
						inProgress: true,
						allQueueIds: ids.slice(start, end),
						queueIds: ids.slice(start, end),
						results: ko.observableArray(),
						cachedResults: ko.observableArray(),
						chunkFailures: 0,
						maxChunkRetries: 5,
						retryDelay: self._batchRetryDelay,
						chunkSize: chunkSize,

						queueStart: new Date(),
						queueEnd: null,
						status: QUEUE_STATUS.PENDING
					};
					if (!queue.allQueueIds.length) {
						continue;
					}
					
					batch.queues.push(queue);
					_recordServiceTemplateBatch(batch, queue, serviceFunction, options);
				}
				
				_printBatches();
			}
		} //jscs: ignore
		_privateContext._recordServiceTemplate = _recordServiceTemplate;

		var QUEUE_STATUS = {
			PENDING: 'Pending',
			RATELIMITED: 'Rate-Limited',
			REQUEST: 'In-Flight',
			FAILSAFE: 'Failed, Waiting',
			RETRY: 'Failed, Retrying',
			CACHING: 'Caching',
			DONE: '√',
			FAILED: 'X, Fatal Error'
		};

		function _printBatches () {
			if (!self._app.debug) {
				return;
			}

			console.log('');
			console.log('=========================================');

			_.each(self._batches().sort(function (a, b) {
				return !b.inProgress();
			}), function (batch) {
				var bStr = 'Batch #' + batch.id + '  ';

				if (batch.inProgress()) {
					bStr += '(' + (batch.cachedResults().length) + '/' + batch.requestIds.length + ')';
					console.group(bStr);
					_.each(batch.queues, function (queue) {
						if (queue.status != QUEUE_STATUS.DONE) {
							var qStr = 'Queue ' + queue.id + ': ';
							
							qStr +=
								queue.status +
								' - ' +
								Math.round(((queue.results().length) / queue.allQueueIds.length) * 100) + '% ' +
								'(' + (queue.results().length) + '/' + queue.allQueueIds.length + ') ' +
								'Chunk Size: ' + queue.chunkSize;
							
							switch (queue.status) {
								case QUEUE_STATUS.FAILSAFE:
								case QUEUE_STATUS.FAILED:
								case QUEUE_STATUS.RETRY:
									console.error(qStr);
									break;
								case QUEUE_STATUS.RATELIMITED:
								case QUEUE_STATUS.PENDING:
									console.warn(qStr);
									break;
								case QUEUE_STATUS.CACHING:
								case QUEUE_STATUS.DONE:
									console.debug(qStr);
									break;
								default:
									console.log(qStr);
							}
						}
					});
					console.groupEnd();
				} else {
					bStr += ' √ ';
					console.log(bStr);
				}
			});
		}

		/**
		 * Batched + Chunked IForce Requests
		 *
		 *  Example:
		 *    2 Temporally Offset Requests
		 *    Concurrency Limit: 500
		 *    Chunk Size: 50
		 *
		 *      ^
		 *      |
		 *      |            -------------------
		 *      |            | [50][50][50]--> |
		 *      |            | [50][50][50]--> |
		 *      | Request #1 | [50][50][50]--> |
		 *      |   (Batch)  | [50][50][50]--> |
		 *      |            | [50][50][50]--> |
		 *   Q  |            | [50][50]------> |
		 *   u  |            -------------------
		 *   e  |                   ::  ::
		 *   u  |                ------------------------
		 *   e  |                | [50][50][50]-------> |
		 *   s  |                | [50][50][50]-------> |
		 *      |     Request #2 | [50][50][50]-------> |
		 *      |       (Batch)  | [50][50][50]-------> |
		 *      |                |  .. [50][50][50] --> |
		 *      |                |  ..  .. [50][50] --> |
		 *      |                ------------------------
		 *      |
		 *      ---------------------------------------------->
		 *                         Chunks
		 *
		 * @param queue
		 * @param serviceFunction
		 * @param userOptions
		 * @param batch
		 * @private
		 */
		function _recordServiceTemplateBatch (batch, queue, serviceFunction, userOptions) {
			var options = {
				objectToMergeInto: {},
				recordId: undefined,
				recordIds: undefined,
				additionalArguments: [],
				successFunction: function () {},
				failureFunction: function () {},
				remotingOptions: {},
				blockUI: false
			};
			if (userOptions) {
				_.extend(options, userOptions);
			}
			
			var concurrencyAvailable = self._concurrencyAvailable;
			var recordBatchChunkSize = self._recordBatchChunkSize;
			var maxConcurrentRecords = self._maxConcurrentRecords;
			if (options.loaderOptions.iForceProvider == LifeCycle.LiteForceService) {
				concurrencyAvailable = self._liteConcurrencyAvailable;
				recordBatchChunkSize = self._liteRecordBatchChunkSize;
				maxConcurrentRecords = self._liteMaxConcurrentRecords;
			}

			var chunkSize = queue.chunkSize;
			var chunk = queue.queueIds.slice(0, chunkSize);
			var actualChunkSize = chunk.length;

			var isWaiting = ko.observable(true);

			function _execute () {
				_printBatches();

				var chunkStart = Date.now();

				options.successFunction = function chunkSuccess (results) {
					batch.flightTime += (Date.now() - chunkStart);

					// Return quantity to available batch requests
					queue.status = QUEUE_STATUS.REQUEST;
					queue.queueIds.splice(0, chunkSize);
					
					concurrencyAvailable(concurrencyAvailable() + actualChunkSize);
					
					// Slowly return to arbitrary batch size
					if (queue.maxChunkRetries == 5) {
						queue.chunkSize = Math.min(recordBatchChunkSize, Math.ceil(actualChunkSize * 2));
					}
					
					queue.maxChunkRetries = Math.min(5, queue.maxChunkRetries + 1);
					(queue.results).push.apply(queue.results, results);

					// Process chunk results
					if (
						options.expectResult &&
						(
							!results ||
							(
								results instanceof Array &&
								results.length === 0
							)
						)
					) {
						throw 'IForce Loader: IForce Provider returned null result for: ' + options.recordId;
					}

					if (results instanceof Array && results[0].isLLCBI || results.isLLCBI) {
						options.iForceProvider = LifeCycle;
					}

					// Begin next chunk
					if (queue.queueIds.length && batch.inProgress() && queue.inProgress) {
						_recordServiceTemplateBatch(batch, queue, serviceFunction, options);
					}

					if (!queue.queueIds.length) {
						queue.status = QUEUE_STATUS.CACHING;
					}
					
					// Then also begin caching chunk results while next chunk is loading
					_printBatches();
					
					if (!options.loaderOptions) {
						options.loaderOptions = {};
					}
					
					if (self._liteForceUtils.hasLiteForces(results)) {
						results = self._liteForceUtils.translateLiteForces(results);
					}
					
					options.loaderOptions.cacheAsync = false;
					options.loaderOptions.deferNotifications = true;
					self._cacheUnmappedIForces(results, function (iForces) {
						(queue.cachedResults).push.apply(queue.cachedResults, iForces);
						_printBatches();
						if (queue.cachedResults().length == queue.allQueueIds.length) {
							var existing = _.find(queue.cachedResults(), function (x) {
								var existing = [];
								for (var i = 0; i < iForces.length; i++) {
									var iForce = iForces[i];
									if (x.recordId() == iForce.recordId()) {
										existing.push(x);
									}
								}
								
								return existing;
							});
							batch.cachedResults.removeAll(existing);
							(batch.cachedResults).push.apply(batch.cachedResults, queue.cachedResults());
							queue.inProgress = false;
							queue.queueEnd = new Date();
							queue.status = QUEUE_STATUS.DONE;

							_printBatches();
							if (!batch.inProgress()) {
								_printBatches();
								batch.batchEnd = new Date();
								batch.batchSuccess(batch.cachedResults(), null);

								for (var i = 0; i < batch.cachedResults().length; i++) {
									var iForce = batch.cachedResults()[i];
									_notifyAndRemoveSubscribers(iForce);
								}
							}
						}
					}, options.loaderOptions);
				};

				options.failureFunction = function chunkFailure (result, event) {
					if (
						queue.chunkFailures < queue.maxChunkRetries
					) {
						queue.status = QUEUE_STATUS.FAILSAFE;
						console.warn(
							'(#' + batch.id + ': ' + batch.requestIds.length + ') - ' +
							'Batch Request: Attempting to recover from error, requeuing chunk and reducing chunk size'
						);

						// Recoverable failure
						queue.chunkFailures++;
						
						// Exponentially back off of arbitrary chunk size
						queue.chunkSize = Math.max(1, Math.floor(Math.sqrt(actualChunkSize)));

						// Re-execute after delay (but keep concurrency reduced)
						setTimeout(function () {
							queue.status = QUEUE_STATUS.RETRY;
							
							concurrencyAvailable(
								Math.min(
									concurrencyAvailable() + actualChunkSize,
									maxConcurrentRecords
								)
							);
							
							if (batch.inProgress() && queue.inProgress) {
								_recordServiceTemplateBatch(batch, queue, serviceFunction, options);
							}
						}, queue.retryDelay);
					} else {
						// Fatal failure
						queue.status = QUEUE_STATUS.FAILED;
						
						concurrencyAvailable(
							Math.min(
								concurrencyAvailable() + actualChunkSize,
								maxConcurrentRecords
							)
						);
						
						queue.inProgress = false;
						batch.inProgress = function () { return false; };
						
						console.error(
							'(#' + batch.id + ': ' + batch.requestIds.length + ') - ' +
							'BATCH REQUEST FAILED: Unrecoverable error'
						);
						_removePendingRequest(options.recordId);
						_removePendingRequests(options.recordIds);
						batch.batchFailure(result, event);
					}
				};

				options.remotingOptions.buffer = false;

				if (chunk.length && batch.inProgress() && queue.inProgress) {
					if (queue.status != QUEUE_STATUS.RETRY) {
						queue.status = QUEUE_STATUS.REQUEST;
					}
					
					return _serviceCallTemplate(serviceFunction, chunk, options);
				}
			}

			if (concurrencyAvailable() > actualChunkSize) {
				concurrencyAvailable(concurrencyAvailable() - actualChunkSize);
				_execute();
			} else {
				_printBatches();
				queue.status = QUEUE_STATUS.RATELIMITED;
				concurrencyAvailable.subscribe(function (newVal) {
					if (isWaiting() && newVal > actualChunkSize) {
						concurrencyAvailable(concurrencyAvailable() - actualChunkSize);
						_printBatches();
						isWaiting(false);
						_execute();
					}
				});
			}
		} //jscs: ignore
		_privateContext._recordServiceTemplateBatch = _recordServiceTemplateBatch;

		function _serviceCallTemplate (serviceFunction, firstArgument, options) {
			var serviceArguments = [
				options.objectToMergeInto,
				firstArgument,
				function chunkSuccess (results, event) {
					options.successFunction(results, event);
				},
				
				function fail (result, event) {
					if (options.failureFunction) {
						options.failureFunction(result, event);
					}
				},
				
				options.remotingOptions,
				options.blockUI
			];
			([]).splice.apply(serviceArguments, [2, 0].concat(options.additionalArguments));
			return serviceFunction.apply(this, serviceArguments);
		} //jscs: ignore
		_privateContext._serviceCallTemplate = _serviceCallTemplate;
		
		/**
		 * Cache JS IForces
		 *
		 * @method
		 * @name IForceCache#cacheUnmappedIForces
		 * @param {Array<IForceJS>} unmappedObjects
		 * @param {function(Array<IForceKO>): void} [callback] - called synchronously or asynchronously based on option
		 * @param {Object} [serviceOptions]
		 * @param {boolean} [serviceOptions.cacheAsync = false] - Run cache calls inside a setTimeout(..., 0);
		 * @param {boolean} [serviceOptions.deferNotifications = false] - do not notifyAndRemoveSubscribers
		 * @param {boolean} [serviceOptions.readOnly = false] - Optionally omit expensive read/write preparations
		 * @param {(Object|function)} [serviceOptions.iForceProvider = _utils.getIForceProvider()] - Used for __retrieve
		 * @returns {void}
		 */
		self.cacheUnmappedIForces = function (unmappedObjects, callback, serviceOptions) {
			function _execute () {
				return _cacheObjects(unmappedObjects, serviceOptions, function (results) {
					_.each(
						results, function (result) {
							_removePendingRequest(result.recordId());
						}
					);
					
					if (callback) {
						callback(results);
					}
				});
			}

			if (serviceOptions && serviceOptions.cacheAsync) {
				setTimeout(_execute, 0);
			} else {
				return _execute();
			}
		};
		
		self._cacheUnmappedIForces = self.cacheUnmappedIForces; // legacy
		
		// ==============================================================
		// Public Cache Extension / Customization Functions
		// ==============================================================
		/*
		 * Extend cache for specific types
		 *
		 * Provide the context (app, view model, etc) which you want to extend the cache onto
		 *   - Will alias public functions onto context
		 *   - Type specific functionality:
		 *     - Will subscribe load messages for types
		 *     - Will hook into cache load event and publish type messages out
		 *     - Adds shortcut type-checked load/get/lookup functions
		 *
		 *
		 *  Type definition structure:
		 *    {
		 *      name: 'camelCasedTypeName', (like recordTotal)
		 *      pluralName: 'deer', (optional)
		 *      apexTypes: [ 'UnNamespaced', 'ApexTypes', 'IncludingInheritanceIfNecessary' ]
		 *      shortcutProperties: [ 'statementType', 'periodKey' ],
		 *      uniqueKeyProperties: [ 'lookupKey', 'unique-key-property-name' ]
		 *    }
		 *
		 *  Shortcut Properties:
		 *    generates 'lookup<Type>By<Property>' shortcut
		 *    Example: lookupStatementsByStatementType() or lookupPeriodsByPeriodKey()
		 *
		 * @method
		 * @name IForceCache#_extend
		 */
		self._extend = function (extensionOptions) {
			extensionOptions.cache = self;
			return LifeCycle.IForceData.IForceCache._extend(extensionOptions);
		};

		// ==============================================================
		// Cache Core Functions
		// ==============================================================
		var hierarchyOrder = {
			LifeCycleUnderwritingBundle: 100,
			LifeCycleLoan: 101,
			LifeCycleRelationship: 110,
			LifeCycleGuarantor: 111,
			LifeCycleBorrower: 111,
			ALifeCycleInvolvement: 111,
			LifeCycleSpreadStatement: 200,
			LifeCycleSpread: 300,
			LifeCycleSpreadStatementPeriod: 400,
			LifeCycleSpreadStatementTotal: 500,
			LifeCycleSpreadStatementRecordTotal: 600,
			LifeCycleSpreadStatementPeriodTotal: 700,
			LifeCycleSpreadStatementRecord: 800,
			LifeCycleSpreadStatementRecordValue: 1000
		};
		
		/**
		 *
		 * @param {Array<IForceJS>} jsObjs
		 * @param {Object} [userOptions]
		 * @param {boolean} [userOptions.cacheAsync = false] - Run cache calls inside a setTimeout(..., 0);
		 * @param {boolean} [userOptions.deferNotifications = false] - do not notifyAndRemoveSubscribers
		 * @param {boolean} [userOptions.readOnly = false] - Optionally omit expensive read/write preparations
		 * @param {(Object|function)} [userOptions.iForceProvider = _utils.getIForceProvider()] - Used for __retrieve
		 *     shortcut function
		 * @param {function(Array<IForceKO>): void} [callback] - Useful when cacheAsync = true
		 * @return {(void|Array<IForceKO>)}
		 * @private
		 */
		function _cacheObjects (jsObjs, userOptions, callback) {

			if (!jsObjs || !jsObjs.length) {
				return [];
			}

			userOptions = (userOptions || []);

			self._stats.inserts = 0;
			self._stats.updates = 0;
			self._stats.parentToChildUpsert = 0;
			self._stats.parentChildToParent = 0;
			self._stats.childToParent = 0;
			self._stats.childParentToChild = 0;
			self._stats.childParentToChildUpsert = 0;
			self._stats.orphanParentToChildLinks = 0;
			self._stats.orphanChildToParentLinks = 0;
			self._stats.orphans = 0;

			var originalSet = [];
			for (var i = 0; i < jsObjs.length; i++) {
				var originalItem = jsObjs[i];
				if (originalItem && originalItem.recordId) {
					var originalId = _18Id(originalItem.recordId);
					if (originalSet.indexOf(originalId) == -1) {
						originalSet.push(originalId);
					}
				}
			}

			var startTime = new Date();

			var sortStart = new Date();
			jsObjs.sort(function (a, b) {
				if (!a && !b || a && !a.apexType && b && !b.apexType) {
					return 0;
				} else if (!a && b || a && !a.apexType && b && b.apexType) {
					return -1;
				} else if (a && !b || a && a.apexType && b && !b.apexType) {
					return 1;
				}

				var aType = _utils.getApexType(a.apexType);
				var aOrder = hierarchyOrder[aType];
				if (!aOrder) {
					aOrder = 10000;
				}
				
				var bType = _utils.getApexType(b.apexType);
				var bOrder = hierarchyOrder[bType];
				if (!bOrder) {
					bOrder = 10000;
				}

				if (aOrder < bOrder) {
					return 1;
				} else if (aOrder > bOrder) {
					return -1;
				} else {
					return 0;
				}
			});
			var sortEnd = new Date();
			var sortDuration = (sortEnd - sortStart) / 1000;
			_app.log('Pre sorted ' + jsObjs.length + ' in ' + sortDuration + 's');

			var requestedCachedObjects = [];
			var cachedObjects = {};
			function _cacheOne (jsObj) {
				var chain = [];
				var cachedObject = _cacheObject(jsObj, chain, jsObjs, userOptions);
				if (cachedObject) {
					cachedObjects[_18Id(cachedObject.recordId())] = cachedObject;
					requestedCachedObjects.push(cachedObject);
				}
				
				for (var j = 0; j < chain.length; j++) {
					var chainObj = chain[j];
					cachedObjects[_18Id(chainObj.recordId())] = chainObj;
				}

				if (userOptions && userOptions.cacheAsync && requestedCachedObjects.length == jsObjs.length) {
					_done();
				}
			}
			
			function _done () {
				_app.log('Inserted ' + self._stats.inserts + ' objects');
				_app.log('Updated ' + self._stats.updates + ' objects');
				_app.log('Upserted ' + self._stats.parentToChildUpsert + ' children into parent arrays');
				_app.log('Linked ' + self._stats.parentChildToParent + ' parents to children');
				_app.log('Linked ' + self._stats.childToParent + ' children to parent objects');
				_app.log('Linked ' + self._stats.childParentToChild + ' parents to child objects');
				_app.log('Upserted ' + self._stats.childParentToChildUpsert + ' children to parent arrays');
				_app.log('Processed ' + self._stats.orphans + ' orphans');
				_app.log('  Resulted in ' + self._stats.orphanParentToChildLinks + ' parent->child links');
				_app.log('  and ' + self._stats.orphanChildToParentLinks + ' child->parent links');

				var endTime = new Date();
				var duration = (endTime - startTime) / 1000;

				_app.log('------ all in ' + duration + 's');

				for (var i = 0; i < requestedCachedObjects.length; i++) {
					var cachedObject = requestedCachedObjects[i];
					if (!_utils.isPlaceholder(cachedObject)) {
						if (!userOptions.deferNotifications) {
							_notifyAndRemoveSubscribers(cachedObject);
						}
					}
				}
				
				if (callback) {
					callback(requestedCachedObjects);
				}

				return requestedCachedObjects;
			}

			for (var j = 0; j < jsObjs.length; j++) {
				var jsObj = jsObjs[j];

				if (userOptions && userOptions.cacheAsync) {
					setTimeout(_cacheOne(jsObj), 0);
				} else {
					_cacheOne(jsObj);
				}
			}

			return _done();
		} //jscs: ignore
		_privateContext._cacheObjects = _cacheObjects;
		
		/**
		 *
		 * @param {IForceJS} jsObj - Unprocessed JS data
		 * @param {Array<IForceKO>} [_cacheChain] recursive cache train (choo choo)
		 * @param {Array<IForceKO>} [topLevelObjects] objects being cached from the same batch
		 * @param {Object} [userOptions]
		 * @param {boolean} [userOptions.readOnly = false] - Optionally omit expensive read/write preparations
		 * @param {(Object|function)} [userOptions.iForceProvider = _utils.getIForceProvider()] - Used for __retrieve
		 *     shortcut function
		 * @return {*} - Processed and cached KO IForce
		 * @private
		 */
		function _cacheObject (jsObj, _cacheChain, topLevelObjects, userOptions) {
			if (!userOptions) {
				userOptions = {};
			}
			
			var id = ko.unwrap(jsObj.recordId);
			var type = ko.unwrap(jsObj.apexType);
			var existing = self.lookupIForceById(id);
			
			if (existing && _utils.isPlaceholder(jsObj)) {
				return existing;
			}

			var cacheChain = [];
			cacheChain.push.apply(cacheChain, _cacheChain);

			if (
				!jsObj ||
				!_utils.isModelObject(jsObj)
			) {
				console.warn("Can't cache " + jsObj + ' [id: ' + id + ' , type: ' + type + ']');
				return null;
			}

			var cachedObj;
			if (_utils.getMappingForObj(jsObj)) {

				// Insert this object first
				var shallowClone = _utils.generateMergeableClone(jsObj);
				shallowClone.isLoaded = true;
				if (!existing) {
					// _app.log(id + ' not in cache, creating shallow');
					// Generate new model object
					var stagingObj;
					if (userOptions.readOnly) {
						stagingObj = _utils.constructReadOnly(shallowClone);
					} else {
						stagingObj = _utils.constructModel(shallowClone);
					}
					
					stagingObj.apexType(shallowClone.apexType);
					cachedObj = _addObject(stagingObj, userOptions);
					self._stats.inserts++;
				} else {

					if (_utils.willCache(jsObj, cacheChain, topLevelObjects)) {
						// Already included as part of train
						// Stop here
						return existing;
					}

					if (_utils.isPlaceholder(existing)) {
						shallowClone.__placeholder = false;
						existing.__placeholder = false;
					}
					
					_utils.safeMerge(existing, shallowClone, false, true);
					cachedObj = self.lookupIForceById(id);
					self._stats.updates++;
				}
				
				if (!cachedObj) {
					return cachedObj;
				}

				cacheChain.push(cachedObj);

				if (_utils.isPlaceholder(jsObj)) {
					return cachedObj;
				}

				// Insert children and related objects
				for (var prop in jsObj) {
					if (jsObj.hasOwnProperty(prop)) {
						var val = jsObj[prop];
						self._stats.dataPointsProcessed++;
						var thisPropType = _utils.getTypeForProperty(prop);
						if (_utils.isChildrenProperty(prop, val)) {
							// Direct children / forward-edges (obj = master of master-detail)
							for (var c = 0; c < val.length; c++) {
								var child = val[c];
								if (!child) {
									continue;
								}
								
								var cachedChildObject = _cacheObject(child, cacheChain, topLevelObjects, userOptions);
								_utils.mergeInto(cachedObj[prop], cachedChildObject);
								
								// Check to see if child object has back-edge to this object
								for (var childProp in cachedChildObject) {
									if (cachedChildObject.hasOwnProperty(childProp)) {
										var childPropType = _utils.getTypeForProperty(childProp);
										if (childPropType && _utils.areTypesMergeable(childPropType, type)) {
											// Match
											var backEdgeObject = cachedChildObject[childProp];
											if (backEdgeObject != cachedObj) {
												cachedChildObject[childProp] = cachedObj;
												self._stats.parentChildToParent++;
											}
										}
									}
								}
								
								self._stats.parentToChildUpsert++;
							}
						} else if (_utils.isModelObject(val) || thisPropType) {//&& map) {
							// Out-of-tree or Back-edge relationship (obj = detail of master-detail)
							if (!val || !ko.unwrap(val.recordId)) {
								// Not a valid incoming object
								continue;
							}
							
							// Cache record
							var cachedRelatedObject = _cacheObject(val, cacheChain, topLevelObjects, userOptions);
							self._stats.childToParent++;
							if (cachedObj[prop] && cachedObj[prop] != cachedRelatedObject) {
								cachedObj[prop] = cachedRelatedObject;
							}

							var relType = ko.unwrap(cachedRelatedObject.apexType);

							// Check to see if related object has edge to this object (two-way lookup / master-detail)
							for (var relProp in cachedRelatedObject) {
								if (cachedRelatedObject.hasOwnProperty(relProp)) {
									var relPropType = _utils.getTypeForProperty(relProp);
									if (
										relPropType &&
											
										// Does A's property match B
										_utils.areTypesMergeable(thisPropType, relType) &&
											
										// Can A be merged into B's A property
										_utils.areTypesMergeable(relPropType, type)
									) {
										// Match
										if (ko.unwrap(cachedRelatedObject[relProp]) instanceof Array) {
											self._stats.childParentToChildUpsert++;
											_utils.mergeInto(cachedRelatedObject[relProp], cachedObj);
										} else {
											// Set
											self._stats.childParentToChild++;
											cachedRelatedObject[relProp] = cachedObj;
										}
									}
								}
							}
						}
					}
				}
			} else {
				console.error('No mapping for ' + id + ' (' + type + ') . Not caching');
			}

			self._stats.totalObjectsCached++;
			return cachedObj;
		} //jscs: ignore
		_privateContext._cacheObject = _cacheObject;
		
		/**
		 * Adds an IForceKO to the data cache
		 *
		 * @param {IForceKO} mappedObj - Prepared KO IForce
		 * @param {Object} [userOptions]
		 * @param {boolean} [userOptions.readOnly = false] - Optionally omit expensive read/write preparations
		 * @param {(Object|function)} [userOptions.iForceProvider = _utils.getIForceProvider()] - Used for __retrieve
		 *     shortcut function
		 * @return {IForceKO} - same object
		 * @private
		 */
		function _addObject (mappedObj, userOptions) {
			if (!userOptions) {
				userOptions = {};
			}
			
			if (self.isCached(mappedObj)) {
				throw 'Tried to overwrite an existing IForce rather than merging';
			}
			
			if (!_utils.isTailObject(mappedObj)) {
				throw 'Tried to cache an IForce that was not isolated';
			}

			if (
				!mappedObj ||
				!mappedObj.recordId ||
				!mappedObj.apexType
			) {
				console.warn('Tried to add an object that was not a valid IForce');
				return;
				
				// throw 'Tried to add an object that was not a valid IForce';
			}

			var id = mappedObj.recordId();
			if (_18Id(id)) {
				if (!userOptions || !userOptions.readOnly) {
					// Apply change tracking
					_utils.trackChanges(mappedObj);
					
					// Perform insert
					_utils.addKOMappings(mappedObj);
				}
				
				mappedObj.__cached = true;
				mappedObj.__retrieve = function (_userOptions, callback) {
					var options = {};
					if (userOptions && userOptions.iForceProvider) {
						options.iForceProvider = userOptions.iForceProvider;
						
						if (typeof options.iForceProvider == 'function') {
							options.iForceProvider = options.iForceProvider();
						}
					}
					
					_.extend(options, _userOptions);
					self.loadIForceById(mappedObj.recordId(), options, callback);
				};
				
				mappedObj.__save = function (_userOptions, callback) {
					LifeCycle.LiteForceService.saveIForce(mappedObj, function (jsForce) {
						self.cacheUnmappedIForces([jsForce], function (updated) {
							if (callback && updated.length == 1) {
								callback(updated[0]);
							}
						});
					});
				};
				
				_iForceMap[_18Id(id)] = mappedObj;
			} else {
				throw 'Tried to add an IForce w/o a valid id: ' + id;
			}

			self._stats.uniqueObjectsCached++;

			return mappedObj;
		} //jscs: ignore
		_privateContext._addObject = _addObject;
		
		// ==============================================================
		// Concurrent Request Management
		// ==============================================================
		var pendingRequests = ko.observableArray();
		function _isPending (id) {
			if (_18Id(id).length != 18) {
				throw 'Invalid SFDC Id: ' + id;
			}
			
			return pendingRequests.indexOf(_18Id(id)) != -1;
		} //jscs: ignore
		_privateContext._isPending = _isPending;

		function _addPendingRequest (id) {
			if (_isPending(id)) {
				return;
			}
			
			pendingRequests.push(_18Id(id));
		} //jscs: ignore
		_privateContext._addPendingRequest = _addPendingRequest;

		function _addPendingRequests (ids) {
			for (var i = 0; i < ids.length; i++) {
				_addPendingRequest(ids[i]);
			}
		} //jscs: ignore
		_privateContext._addPendingRequests = _addPendingRequests;

		function _removePendingRequest (id) {
			var index = pendingRequests.indexOf(_18Id(id));
			pendingRequests.splice(index, 1);
		} //jscs: ignore
		_privateContext._removePendingRequest = _removePendingRequest;

		function _removePendingRequests (ids) {
			for (var i = 0; i < ids.length; i++) {
				_removePendingRequest(ids[i]);
			}
		} //jscs: ignore
		_privateContext._removePendingRequests = _removePendingRequests;

		function _trimPendingRequests (ids) {
			var nonPendingIds = [];
			for (var i = 0; i < ids.length; i++) {
				var id = ids[i];
				if (_18Id(id).length != 18) {
					throw 'Invalid SFDC Id: ' + id;
				}
				
				if (!_isPending(id)) {
					nonPendingIds.push(id);
				}
			}
			
			return nonPendingIds;
		} //jscs: ignore
		_privateContext._trimPendingRequests = _trimPendingRequests;
		
		function IdSubscription (id, context, callback) {
			this.id = id;
			this.context = context;
			this.callback = callback;
		}
		
		IdSubscription.create = function (id, context, callback) {
			_subscribeToId(
				id,
				new IdSubscription(id, context, callback)
			);
		};
		
		IdSubscription.prototype.notify = function (iForce) {
			this.callback.call(this.context, iForce);
		};
		
		//TODO: Move into own file
		_privateContext.IdSubscription = IdSubscription;

		var idSubscriptions = {};
		function _subscribeToId (id15Or18, subscription) {
			var id = _18Id(id15Or18);
			var subscriberList = idSubscriptions[id];
			if (!subscriberList) {
				subscriberList = [];
				idSubscriptions[id] = subscriberList;
			}

			subscriberList.push(subscription);
		}

		function _unsubscribeFromId (id15Or18, subscription) {
			var id = _18Id(id15Or18);
			var subscriberList = idSubscriptions[id];
			if (!subscriberList) {
				return;
			}

			var index = subscriberList.indexOf(subscription);
			if (index == -1) {
				return;
			}

			subscriberList.splice(index, 1);
		} //jscs: ignore
		_privateContext._unsubscribeFromId = _unsubscribeFromId;

		function _getSubscribers (id15Or18) {
			var id = _18Id(id15Or18);
			var subscriberList = idSubscriptions[id];
			if (!subscriberList) {
				return [];
			}

			return subscriberList;
		} //jscs: ignore
		_privateContext._getSubscribers = _getSubscribers;

		function _notifyAndRemoveSubscribers (iForce) {
			if (_utils.isPlaceholder(iForce)) {
				return;
			}

			var id = _18Id(ko.unwrap(iForce.recordId));
			var subscriberList = idSubscriptions[id];
			if (!subscriberList) {
				return;
			}

			// Notify
			var subscriber;
			var subscribers = [];
			for (var i = 0; i < subscriberList.length; i++) {
				subscriber = subscriberList[i];
				if (subscriber instanceof IdSubscription) {
					subscriber.notify(iForce);
				} else {
					console.warn('IForceCache: Load subscriber is not an IdSubscription');
				}
				
				subscribers.push(subscriber);
			}

			// Remove
			for (var j = subscribers.length - 1; j >= 0; j--) {
				subscriber = subscribers[j];
				var index = subscriberList.indexOf(subscriber);
				subscriberList.splice(index, 1);

			}
		} //jscs: ignore
		_privateContext._notifyAndRemoveSubscribers = _notifyAndRemoveSubscribers;
		
		// ==============================================================
		// Private properties
		// ==============================================================
		var _app = (_optionalMappingApp) ? _optionalMappingApp : LifeCycle.IForceData._globalMappingApp;

		var _iForceMap;
		function _initializeCache () {
			if (_iForceMap) {
				for (var _id in _iForceMap) {
					if (_iForceMap.hasOwnProperty(_id)) {
						// Break all cache references to IForce
						var obj = _iForceMap[_id];
						for (var prop in obj) {
							if (obj.hasOwnProperty(prop)) {
								// Break all relationships and data references in objects
								if (ko.isObservable(obj[prop])) {
									obj[prop].notifySubscribers = function () {};
									
									if (ko.unwrap(obj[prop]) instanceof Array) {
										try { obj[prop].removeAll(); } catch (e) {}
									} else {
										try { obj[prop](null); } catch (e) {}
									}
								}
								
								delete obj[prop];
							}
						}
						
						delete _iForceMap[_id];
					}
				}
			}
			
			_iForceMap = {};
			_privateContext._iForceMap = _iForceMap;
		}
		
		_initializeCache();
		if (!_app.NAMESPACE_PREFIX) {
			_app.NAMESPACE_PREFIX = 'c.';
		}

		var _utils = new LifeCycle.IForceData.IForceUtils(_app);
		/**
		 * @method
		 * @name IForceCache#_reinitializeCache
		 * @type {_initializeCache}
		 * @private
		 */
		self._reinitializeCache = _initializeCache;
		/**
		 * @member {LifeCycleApp}
		 * @name IForceCache#_app
		 */
		self._app = _app;
		/**
		 * @member {LifeCycle.IForceData.IForceUtils}
		 * @name IForceCache#_utils
		 */
		self._utils = _utils;
		/**
		 * @member {LiteForceUtils}
		 * @name IForceCache#_liteForceUtils
		 */
		self._liteForceUtils = new LifeCycle.IForceData.LiteForceUtils(_app, _utils);

		self._recordBatchChunkSize = 250; // Records per VFRemoting request
		self._maxConcurrentRecords = 4000; // Maximum # of outstanding id requests
		self._concurrencyOffset = ko.observable(0);
		self._concurrencyAvailable = ko.computed({
			read: function () {
				return self._concurrencyOffset() + self._maxConcurrentRecords;
			},
			write: function (value) {
				self._concurrencyOffset(value ? value - self._maxConcurrentRecords : 0);
			},
			deferEvaluation: true
		});
		
		self._liteRecordBatchChunkSize = 1000; // Records per VFRemoting request
		self._liteMaxConcurrentRecords = 50000; // Maximum # of outstanding id requests
		self._liteConcurrencyOffset = ko.observable(0);
		self._liteConcurrencyAvailable = ko.computed({
			read: function () {
				return self._liteConcurrencyOffset() + self._liteMaxConcurrentRecords;
			},
			write: function (value) {
				self._liteConcurrencyOffset(value ? value - self._liteMaxConcurrentRecords : 0);
			},
			deferEvaluation: true
		});
		
		self._batchRetryDelay = 500;
		self._batches = ko.observableArray();
		self._batchedIdsCompleted = ko.computed(function () {
			var count = 0;
			var batches = self._batches();
			for (var i = 0; i < batches.length; i++) {
				var batch = batches[i];
				for (var j = 0; j < batch.queues.length; j++) {
					var queue = batch.queues[j];
					count += queue.cachedResults().length;
				}
			}
			
			return count;
		});
		self._batchedIds = ko.computed(function () {
			var count = 0;
			var batches = self._batches();
			for (var i = 0; i < batches.length; i++) {
				var batch = batches[i];
				count += batch.requestIds.length;
			}
			
			return count;
		});
		
		self._batchETA = function () {

			var recordsPerSecondList = [];
			var batches = self._batches();
			var multiplier = 1.5;

			var totalCount = 0;

			for (var i = 0; i < batches.length; i++) {
				var batch = batches[i];
				var batchCount = 0;
				
				for (var j = 0; j < batch.queues.length; j++) {
					var queue = batch.queues[j];
					batchCount += queue.results().length;

					multiplier = Math.max(multiplier, queue.chunkFailures);
				}
				
				totalCount += batchCount;
				
				if (batch.flightTime) {
					var rps = batchCount / (batch.flightTime / 1000);
					if (rps < 0.000001) {
						continue;
					}
					
					recordsPerSecondList.push(rps);
				}
			}

			if (!recordsPerSecondList.length) {
				return 'Unknown';
			} else if (self._batchProgress() < 30.0) {
				return 'Estimating...';
			}
			
			var numQueues = self._maxConcurrentRecords / self._recordBatchChunkSize;
			var avgRPS = recordsPerSecondList.reduce(function (a, b) {
				return a + b;
			}, 0) / recordsPerSecondList.length;
			
			var remaining = Math.max(0, self._batchedIds() - totalCount);
			
			var scale = 60 / self._batchProgress();
			var seconds = remaining / ((avgRPS * numQueues * scale) / multiplier);

			var minutes = Math.floor(seconds / 60);
			var secondsLeftover = seconds % 60;
			var str = '';
			if (minutes > 0) {
				str += minutes.toFixed(0) + 'm ';
			}
			
			str += secondsLeftover.toFixed(0);
			if (!secondsLeftover) {
				str += '0';
			}
			
			str += 's';

			return str;
		};
		
		var _etaInterval = null;
		self._batchProgress = ko.computed({
			read: function () {
				var progressBar = jQuery('#global_batch_progress');
				var remoteCallCount = self._batchedIds();
				var remoteCallSuccessCount = self._batchedIdsCompleted();
				var loadedPercent = _utils.formatPercentageForDisplay(remoteCallSuccessCount / remoteCallCount, 0);
				if (loadedPercent > 99.0) {
					progressBar.find('.progress-legend').hide();
					jQuery('#progress-eta-legend').hide();
					progressBar.find('.progress-eta').hide();
					progressBar.find('.progress').hide();
					progressBar.find('.progress-text').text('Processing...');
					return;
				} else {
					progressBar.find('.progress-legend').show();
					jQuery('#progress-eta-legend').show();
					progressBar.find('.progress-eta').show();
					progressBar.find('.progress').show();
				}
				
				progressBar.find('.progress-bar').css('width', loadedPercent + '%');
				progressBar.find('.progress-text').text(loadedPercent + '%');
				progressBar.find('.progress-eta').text(self._batchETA());
				if (_etaInterval) {
					clearInterval(_etaInterval);
				}

				var eta = self._batchETA();
				progressBar.find('.progress-eta').text(_utils.formatETAForDisplay(eta));
				if (!isNaN(eta) && eta > 0) {
					_etaInterval = setInterval(function () {
						eta--;
						progressBar.find('.progress-eta').text(_utils.formatETAForDisplay(eta));
					}, 1000);
				}
				
				return loadedPercent;
			}
		});
		
		self._stats = {
			inserts: 0,
			updates: 0,
			parentToChildUpsert: 0,
			parentChildToParent: 0,
			childToParent: 0,
			childParentToChild: 0,
			childParentToChildUpsert: 0,
			orphanParentToChildLinks: 0,
			orphanChildToParentLinks: 0,
			orphans: 0,
			
			batchCount: 0,
			idsRequested: 0,
			uniqueObjectsCached: 0,
			totalObjectsCached: 0,
			dataPointsProcessed: 0
		};
		
		/**
		 * @member {string}
		 * @readonly
		 * @name IForceCache#ME_OUTSIDE
		 */
		self.ME_OUTSIDE = 'How bou dah?';	
			
		return self;
	};

	/**
	 * @static
	 * @method
	 * @name IForceCache._extend
	 * @param extensionOptions
	 * @return {{}}
	 * @private
	 */
	IForceCache._extend = function (extensionOptions) {
		var context = (extensionOptions && (typeof extensionOptions.context == 'object'))
			? extensionOptions.context
			: {};
		var cache = (extensionOptions && (extensionOptions.cache instanceof LifeCycle.IForceData.IForceCache))
			? extensionOptions.cache
			: new LifeCycle.IForceData.IForceCache();

		var _app = cache._app;
		var _utils = cache._utils;
		var _liteForceUtils = cache._liteForceUtils;
		
		// Shortcuts
		context._app = _app;
		context._utils = _utils;
		context._liteForceUtils = _liteForceUtils;

		context._iForceTypedIdMapServiceTemplate = function (serviceFunction, userOptions, callback) {
			var options = _generateLoaderOptions(userOptions);
			return cache._iForceTypedIdMapServiceTemplate(serviceFunction, options, callback);
		};
		
		context._iForceIdServiceTemplate = function (serviceFunction, userOptions, callback) {
			var options = _generateLoaderOptions(userOptions);
			return cache._iForceIdServiceTemplate(serviceFunction, options, callback);
		};
		
		context._iForceServiceTemplate = function (serviceFunction, userOptions, callback) {
			var options = _generateLoaderOptions(userOptions);
			return cache._iForceServiceTemplate(serviceFunction, options, callback);
		};

		context._cacheUnmappedIForces = cache.cacheUnmappedIForces;
		context.cacheUnmappedIForces = cache.cacheUnmappedIForces;

		function _generateLoaderOptions (userOptions, type) {
			var options = {};
			if (extensionOptions.defaultIForceProvider) {
				options.iForceProvider = extensionOptions.defaultIForceProvider;
				options.useLiteForces = (extensionOptions.useLiteForces || cache.useLiteForces);
			}
			
			if (type) {
				options.placeholderType = type.apexTypes[0];
			}
			
			_.extend(options, userOptions);
			return options;
		}

		function _generateIsType (context, type) {
			function _isType (apexTypes, object) {
				for (var i = 0; i < apexTypes.length; i++) {
					var type = apexTypes[i];
					if (_utils.isType(object, type)) {
						return true;
					}
				}
				
				return false;
			}
			
			context['_is' + type.transformedName] = function (object) {
				return _isType(type.apexTypes, object);
			};
		}

		function _trimIForces (context, type, iForces) {
			if (!iForces) {
				return iForces;
			}

			var trimmedIForces = [];

			for (var i = 0; i < iForces.length; i++) {
				var iForce = iForces[i];
				if (context['_is' + type.transformedName](iForce)) {
					trimmedIForces.push(iForce);
				}
			}

			return trimmedIForces;
		}

		function _generateRetrievalFunctions (context, type) {
			// Get
			context['get' + type.transformedName + 'ById'] = function (id15Or18, userOptions, callback) {
				userOptions = _generateLoaderOptions(userOptions, type);
				var iForce = cache.getIForceById(id15Or18, userOptions, function (_iForce) {
					if (context['_is' + type.transformedName](_iForce) && callback) {
						callback(_iForce);
					}
				});
				
				if (context['_is' + type.transformedName](iForce)) {
					return iForce;
				}
			};

			context['get' + type.transformedPluralName + 'ById'] = function (id15Or18, userOptions, callback) {
				userOptions = _generateLoaderOptions(userOptions, type);
				var iForces = cache.getIForcesById(id15Or18, userOptions, function (_iForces) {
					if (callback) {
						callback(_trimIForces(context, type, _iForces));
					}
				});

				return _trimIForces(context, type, iForces);
			};

			// Load
			context['load' + type.transformedName + 'ById'] = function (id15Or18, userOptions, callback) {
				userOptions = _generateLoaderOptions(userOptions, type);
				cache.loadIForceById(id15Or18, userOptions, function (iForce) {
					if (context['_is' + type.transformedName](iForce) && callback) {
						callback(iForce);
					}
				});
			};

			context['load' + type.transformedPluralName + 'ById'] = function (id15Or18, userOptions, callback) {
				userOptions = _generateLoaderOptions(userOptions, type);
				cache.loadIForcesById(id15Or18, userOptions, function (iForces) {
					if (callback) {
						callback(_trimIForces(context, type, iForces));
					}
				});
			};

			// Lookup
			context['lookup' + type.transformedName + 'ById'] = function (id15Or18, userOptions) {
				userOptions = _generateLoaderOptions(userOptions, type);
				var iForce = cache.lookupIForceById(id15Or18, userOptions);
				if (context['_is' + type.transformedName](iForce)) {
					return iForce;
				}
			};

			context['lookup' + type.transformedPluralName + 'ByName'] = function (name, userOptions) {
				userOptions = _generateLoaderOptions(userOptions, type);
				
				if (userOptions.filter) {
					var filter = userOptions.filter;
					userOptions.filter = function (x) {
						return context['_is' + type.transformedName](x) && filter(x);
					};
				}
				
				var iForces = cache.lookupIForcesByName(name, userOptions);
				return _trimIForces(context, type, iForces);
			};

			context['lookup' + type.transformedPluralName + 'ByProperty'] = function (property, value, userOptions) {
				userOptions = _generateLoaderOptions(userOptions, type);
				
				if (userOptions.filter) {
					var filter = userOptions.filter;
					userOptions.filter = function (x) {
						return context['_is' + type.transformedName](x) && filter(x);
					};
				}
				
				var iForces = cache.lookupIForcesByProperty(property, value, userOptions);
				return _trimIForces(context, type, iForces);
			};

			context['lookup' + type.transformedPluralName + 'ByFilter'] = function (filter, userOptions) {
				userOptions = _generateLoaderOptions(userOptions, type);
				var _filter = function (x) {
					return context['_is' + type.transformedName](x) && filter(x);
				};
				
				var iForces = cache.lookupIForcesByFilter(_filter, userOptions);
				return _trimIForces(context, type, iForces);
			};

			// Shortcut lookups
			function _generateShortcutProperty (shortcutProperty, transformedPropertyName) {
				context['lookup' + type.transformedPluralName + 'By' + transformedPropertyName] = function (
					value,
					userOptions
				) {
					userOptions = _generateLoaderOptions(userOptions, type);
					var iForces = cache.lookupIForcesByProperty(shortcutProperty, value, userOptions);
					return _trimIForces(context, type, iForces);
				};
			}

			// Unique lookups
			function _generateUniqueKeyProperty (uniqueKeyProperty, transformedPropertyName) {
				context['lookup' + type.transformedName + 'By' + transformedPropertyName] = function (
					value,
					userOptions
				) {
					userOptions = _generateLoaderOptions(userOptions, type);
					var iForces = cache.lookupIForcesByProperty(uniqueKeyProperty, value, userOptions);
					var trimmed = _trimIForces(context, type, iForces);

					if (!trimmed || !trimmed.length) {
						return null;
					} else if (trimmed.length == 1) {
						return trimmed[0];
					} else {
						throw new Error('IForce Cache: Unique key lookup produced multiple results');
					}
				};
			}

			if (type.shortcutProperties) {
				for (var s = 0; s < type.shortcutProperties.length; s++) {
					var shortcutProperty = type.shortcutProperties[s];
					if (['name', 'id', 'recordid', 'recordids'].indexOf(shortcutProperty.toLowerCase()) != -1) {
						continue;
					}

					var transformedPropertyName = shortcutProperty.charAt(0).toUpperCase() +
						shortcutProperty.substring(1);
					
					_generateShortcutProperty(shortcutProperty, transformedPropertyName);
				}
			}

			if (type.uniqueKeyProperties) {
				for (var u = 0; u < type.uniqueKeyProperties.length; u++) {
					var uniqueKeyProperty = type.uniqueKeyProperties[u];
					if (['name', 'id', 'recordid', 'recordids'].indexOf(uniqueKeyProperty.toLowerCase()) != -1) {
						continue;
					}

					var transformedUniquePropertyName = uniqueKeyProperty.charAt(0).toUpperCase() +
						uniqueKeyProperty.substring(1);
					
					_generateUniqueKeyProperty(uniqueKeyProperty, transformedUniquePropertyName);
				}
			}
		}

		function _generateLoadSubscribes (context, pubSubNamespace, type) {
			_app.subscribe(pubSubNamespace + '.Load_' + type.transformedName, function (options) {
				context['load' + type.transformedName + 'ById'](options.recordId, options);
			});
			_app.subscribe(pubSubNamespace + '.Load_' + type.transformedPluralName, function (options) {
				context['load' + type.transformedPluralName + 'ById'](options.recordIds, options);
			});
			_app.subscribe(pubSubNamespace + '.Get_Cached_' + type.transformedName, function (options) {
				context['get' + type.transformedName + 'ById'](options.recordId, options);
			});
			_app.subscribe(pubSubNamespace + '.Get_Cached_' + type.transformedPluralName, function (options) {
				context['get' + type.transformedPluralName + 'ById'](options.recordIds, options);
			});
		}

		function _generateIForceHooks (context, pubSubNamespace, type) {
			function _iForceHook (iForce) {
				if (_utils.isPlaceholder(iForce)) {
					return;
				}
				
				if (context['_is' + type.transformedName](iForce)) {
					_app.publish(pubSubNamespace + '.Loaded_' + type.transformedName, iForce);
				}
			}
			
			_app.subscribe('nFORCE.IForce_Data.Loaded_IForce', _iForceHook);

			function _cachedIForceHook (iForce) {
				if (_utils.isPlaceholder(iForce)) {
					return;
				}
				
				if (context['_is' + type.transformedName](iForce)) {
					_app.publish(pubSubNamespace + '.Cached_' + type.transformedName, iForce);
				}
			}
			
			_app.subscribe('nFORCE.IForce_Data.Cached_IForce', _cachedIForceHook);
		}

		function _generateGenericFunctions (context) {

			var funs = [
				{name: 'getIForceById', optionsPropertyIndex: 1},
				{name: 'getIForcesById', optionsPropertyIndex: 1},
				{name: 'loadIForceById', optionsPropertyIndex: 1},
				{name: 'loadIForcesById', optionsPropertyIndex: 1},
				{name: 'lookupIForceById', optionsPropertyIndex: 1},
				{name: 'lookupIForcesByName', optionsPropertyIndex: 1},
				{name: 'lookupIForcesByProperty', optionsPropertyIndex: 2}
			];

			function _aliasTemplate (fun, index) {
				return function () {
					var args = Array.prototype.slice.call(arguments);

					var userOptions = null;
					if (index == args.length) {
						args.push(userOptions);
					} else if (args[index]) {
						userOptions = args[index];
					}

					args[index] = _generateLoaderOptions(userOptions);
					return cache[fun].apply(cache[fun], args);
				};
			}

			for (var i = 0; i < funs.length; i++) {
				var fun = funs[i];
				var functionName = fun.name;
				var index = fun.optionsPropertyIndex;
				context[functionName] = _aliasTemplate(functionName, index);
			}
		}

		// Generate type specific functions
		for (var i = 0; i < extensionOptions.typeDefinitions.length; i++) {
			var type = extensionOptions.typeDefinitions[i];

			type.transformedName = type.name.charAt(0).toUpperCase() + type.name.substring(1);
			if (!type.pluralName) {
				type.pluralName = type.name + 's';
			}
			
			type.transformedPluralName = type.pluralName.charAt(0).toUpperCase() + type.pluralName.substring(1);

			_generateIsType(context, type);
			_generateRetrievalFunctions(context, type);
			if (cache == LifeCycle.IForceData.globalCache && extensionOptions.pubSubNamespace) {
				_generateLoadSubscribes(context, extensionOptions.pubSubNamespace, type);
				_generateIForceHooks(context, extensionOptions.pubSubNamespace, type);
			}
		}

		_generateGenericFunctions(context);

		return context;
	};
	
	LifeCycle.IForceData.IForceCache = IForceCache;
})();
